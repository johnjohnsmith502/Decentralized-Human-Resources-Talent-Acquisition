;; Candidate Sourcing Contract
;; Manages candidate profiles and sourcing activities

(define-constant contract-owner tx-sender)
(define-constant err-owner-only (err u100))
(define-constant err-not-found (err u101))
(define-constant err-unauthorized (err u102))
(define-constant err-already-exists (err u103))

;; Data structures
(define-map candidates
    { candidate-id: uint }
    {
        candidate: principal,
        name: (string-ascii 100),
        skills: (string-ascii 200),
        experience-years: uint,
        availability: bool,
        sourced-by: principal,
        created-at: uint
    }
)

(define-map job-positions
    { position-id: uint }
    {
        title: (string-ascii 100),
        requirements: (string-ascii 300),
        posted-by: principal,
        status: (string-ascii 20),
        created-at: uint
    }
)

(define-map candidate-applications
    { application-id: uint }
    {
        candidate-id: uint,
        position-id: uint,
        status: (string-ascii 20),
        applied-at: uint
    }
)

(define-data-var next-candidate-id uint u1)
(define-data-var next-position-id uint u1)
(define-data-var next-application-id uint u1)

;; Public functions
(define-public (register-candidate (name (string-ascii 100)) (skills (string-ascii 200)) (experience-years uint))
    (let (
        (candidate-id (var-get next-candidate-id))
        (candidate tx-sender)
    )
        (map-set candidates
            { candidate-id: candidate-id }
            {
                candidate: candidate,
                name: name,
                skills: skills,
                experience-years: experience-years,
                availability: true,
                sourced-by: candidate,
                created-at: block-height
            }
        )
        (var-set next-candidate-id (+ candidate-id u1))
        (ok candidate-id)
    )
)

(define-public (source-candidate (candidate principal) (name (string-ascii 100)) (skills (string-ascii 200)) (experience-years uint))
    (let (
        (candidate-id (var-get next-candidate-id))
        (recruiter tx-sender)
    )
        (map-set candidates
            { candidate-id: candidate-id }
            {
                candidate: candidate,
                name: name,
                skills: skills,
                experience-years: experience-years,
                availability: true,
                sourced-by: recruiter,
                created-at: block-height
            }
        )
        (var-set next-candidate-id (+ candidate-id u1))
        (ok candidate-id)
    )
)

(define-public (post-job-position (title (string-ascii 100)) (requirements (string-ascii 300)))
    (let (
        (position-id (var-get next-position-id))
        (employer tx-sender)
    )
        (map-set job-positions
            { position-id: position-id }
            {
                title: title,
                requirements: requirements,
                posted-by: employer,
                status: "open",
                created-at: block-height
            }
        )
        (var-set next-position-id (+ position-id u1))
        (ok position-id)
    )
)

(define-public (apply-for-position (candidate-id uint) (position-id uint))
    (let (
        (application-id (var-get next-application-id))
        (applicant tx-sender)
    )
        (asserts! (is-some (map-get? candidates { candidate-id: candidate-id })) err-not-found)
        (asserts! (is-some (map-get? job-positions { position-id: position-id })) err-not-found)
        (map-set candidate-applications
            { application-id: application-id }
            {
                candidate-id: candidate-id,
                position-id: position-id,
                status: "applied",
                applied-at: block-height
            }
        )
        (var-set next-application-id (+ application-id u1))
        (ok application-id)
    )
)

;; Read-only functions
(define-read-only (get-candidate (candidate-id uint))
    (map-get? candidates { candidate-id: candidate-id })
)

(define-read-only (get-job-position (position-id uint))
    (map-get? job-positions { position-id: position-id })
)

(define-read-only (get-application (application-id uint))
    (map-get? candidate-applications { application-id: application-id })
)
