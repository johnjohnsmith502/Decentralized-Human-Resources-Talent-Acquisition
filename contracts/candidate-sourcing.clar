;; Hiring Decision Contract
;; Supports hiring decisions and manages the final hiring process

(define-constant contract-owner tx-sender)
(define-constant err-owner-only (err u100))
(define-constant err-not-found (err u101))
(define-constant err-unauthorized (err u102))
(define-constant err-already-decided (err u103))

;; Data structures
(define-map hiring-decisions
    { decision-id: uint }
    {
        candidate-id: uint,
        position-id: uint,
        decision: (string-ascii 20),
        decision-maker: principal,
        reasoning: (string-ascii 500),
        decided-at: uint,
        salary-offer: (optional uint)
    }
)

(define-map offer-letters
    { offer-id: uint }
    {
        candidate-id: uint,
        position-id: uint,
        salary: uint,
        start-date: uint,
        benefits: (string-ascii 300),
        status: (string-ascii 20),
        issued-by: principal,
        issued-at: uint
    }
)

(define-map hiring-approvals
    { approval-id: uint }
    {
        decision-id: uint,
        approver: principal,
        approved: bool,
        comments: (string-ascii 200),
        approved-at: uint
    }
)

(define-data-var next-decision-id uint u1)
(define-data-var next-offer-id uint u1)
(define-data-var next-approval-id uint u1)

;; Public functions
(define-public (make-hiring-decision (candidate-id uint) (position-id uint) (decision (string-ascii 20)) (reasoning (string-ascii 500)) (salary-offer (optional uint)))
    (let (
        (decision-id (var-get next-decision-id))
    )
        (map-set hiring-decisions
            { decision-id: decision-id }
            {
                candidate-id: candidate-id,
                position-id: position-id,
                decision: decision,
                decision-maker: tx-sender,
                reasoning: reasoning,
                decided-at: block-height,
                salary-offer: salary-offer
            }
        )
        (var-set next-decision-id (+ decision-id u1))
        (ok decision-id)
    )
)

(define-public (issue-offer-letter (candidate-id uint) (position-id uint) (salary uint) (start-date uint) (benefits (string-ascii 300)))
    (let (
        (offer-id (var-get next-offer-id))
    )
        (map-set offer-letters
            { offer-id: offer-id }
            {
                candidate-id: candidate-id,
                position-id: position-id,
                salary: salary,
                start-date: start-date,
                benefits: benefits,
                status: "pending",
                issued-by: tx-sender,
                issued-at: block-height
            }
        )
        (var-set next-offer-id (+ offer-id u1))
        (ok offer-id)
    )
)

(define-public (approve-hiring-decision (decision-id uint) (approved bool) (comments (string-ascii 200)))
    (let (
        (approval-id (var-get next-approval-id))
        (decision (unwrap! (map-get? hiring-decisions { decision-id: decision-id }) err-not-found))
    )
        (map-set hiring-approvals
            { approval-id: approval-id }
            {
                decision-id: decision-id,
                approver: tx-sender,
                approved: approved,
                comments: comments,
                approved-at: block-height
            }
        )
        (var-set next-approval-id (+ approval-id u1))
        (ok approval-id)
    )
)

(define-public (update-offer-status (offer-id uint) (new-status (string-ascii 20)))
    (let (
        (offer (unwrap! (map-get? offer-letters { offer-id: offer-id }) err-not-found))
    )
        (asserts! (is-eq tx-sender (get issued-by offer)) err-unauthorized)
        (map-set offer-letters
            { offer-id: offer-id }
            (merge offer { status: new-status })
        )
        (ok true)
    )
)

;; Read-only functions
(define-read-only (get-hiring-decision (decision-id uint))
    (map-get? hiring-decisions { decision-id: decision-id })
)

(define-read-only (get-offer-letter (offer-id uint))
    (map-get? offer-letters { offer-id: offer-id })
)

(define-read-only (get-hiring-approval (approval-id uint))
    (map-get? hiring-approvals { approval-id: approval-id })
)

(define-read-only (is-decision-approved (decision-id uint))
    (default-to false
        (get approved
            (map-get? hiring-approvals { approval-id: decision-id }))))
