# Decentralized Human Resources Talent Acquisition System

A comprehensive blockchain-based HR system that manages the complete recruitment pipeline from recruiter verification to final hiring decisions using Clarity smart contracts on the Stacks blockchain.

## Overview

This system consists of 5 interconnected smart contracts that handle different aspects of the recruitment process:

1. **Recruiter Verification Contract** - Validates and manages talent recruiters
2. **Candidate Sourcing Contract** - Manages candidate profiles and job postings
3. **Screening Automation Contract** - Automates candidate screening processes
4. **Interview Coordination Contract** - Coordinates and manages interviews
5. **Hiring Decision Contract** - Manages final hiring decisions and offer letters

## Features

### 🔐 Recruiter Verification
- Register new recruiters with specializations
- Submit verification requests
- Admin approval system for recruiter verification
- Reputation scoring system
- Track successful hires

### 👥 Candidate Sourcing
- Candidate profile registration
- Recruiter-sourced candidate profiles
- Job position posting
- Application management
- Skills and experience tracking

### 🤖 Screening Automation
- Configurable screening criteria per position
- Automated candidate screening based on experience
- Custom automated tests
- Screening results and feedback tracking
- Pass/fail determination

### 📅 Interview Coordination
- Interview scheduling system
- Multiple interview types support
- Interviewer availability management
- Interview status tracking
- Feedback collection system

### ✅ Hiring Decision
- Structured hiring decision process
- Offer letter generation
- Multi-level approval system
- Salary and benefits management
- Decision tracking and reasoning

## Smart Contract Architecture

\`\`\`
┌─────────────────────┐    ┌─────────────────────┐
│ Recruiter           │    │ Candidate           │
│ Verification        │    │ Sourcing            │
└─────────┬───────────┘    └─────────┬───────────┘
│                          │
▼                          ▼
┌─────────────────────┐    ┌─────────────────────┐
│ Screening           │    │ Interview           │
│ Automation          │    │ Coordination        │
└─────────┬───────────┘    └─────────┬───────────┘
│                          │
└──────────┬─────────────────┘
▼
┌─────────────────────┐
│ Hiring              │
│ Decision            │
└─────────────────────┘
\`\`\`

## Getting Started

### Prerequisites
- Stacks CLI
- Clarinet (for local development)
- Node.js (for testing)

### Installation

1. Clone the repository:
   \`\`\`bash
   git clone <repository-url>
   cd decentralized-hr-system
   \`\`\`

2. Install dependencies:
   \`\`\`bash
   npm install
   \`\`\`

3. Run tests:
   \`\`\`bash
   npm test
   \`\`\`

### Deployment

Deploy the contracts in the following order:
1. recruiter-verification.clar
2. candidate-sourcing.clar
3. screening-automation.clar
4. interview-coordination.clar
5. hiring-decision.clar

## Usage Examples

### Register a Recruiter
\`\`\`clarity
(contract-call? .recruiter-verification register-recruiter "Software Engineering")
\`\`\`

### Post a Job Position
\`\`\`clarity
(contract-call? .candidate-sourcing post-job-position
"Senior Developer"
"5+ years experience in blockchain development")
\`\`\`

### Schedule an Interview
\`\`\`clarity
(contract-call? .interview-coordination schedule-interview
u1  ;; candidate-id
u1  ;; position-id
'SP123... ;; interviewer
u1000 ;; scheduled-time
u60   ;; duration
"technical")
\`\`\`

### Make Hiring Decision
\`\`\`clarity
(contract-call? .hiring-decision make-hiring-decision
u1  ;; candidate-id
u1  ;; position-id
"hired"
"Excellent technical skills and culture fit"
(some u75000)) ;; salary offer
\`\`\`

## Data Models

### Recruiter
- Principal address
- Verification status
- Reputation score
- Successful hires count
- Specialization

### Candidate
- Profile information
- Skills and experience
- Availability status
- Sourced by recruiter

### Job Position
- Title and requirements
- Posted by employer
- Status (open/closed)

### Interview
- Candidate and position IDs
- Interviewer and timing
- Type and status
- Feedback and ratings

### Hiring Decision
- Final decision and reasoning
- Salary offer
- Approval workflow

## Error Codes

- `u100` - Owner only operation
- `u101` - Record not found
- `u102` - Unauthorized access
- `u103` - Already exists/decided
- `u104` - Invalid status

## Contributing

1. Fork the repository
2. Create a feature branch
3. Write tests for new functionality
4. Ensure all tests pass
5. Submit a pull request

## License

MIT License - see LICENSE file for details

## Security Considerations

- All contracts include proper access controls
- Input validation on all public functions
- Error handling for edge cases
- Admin functions restricted to contract owner
- Immutable decision records for audit trail

## Roadmap

- [ ] Integration with external identity verification
- [ ] Advanced screening algorithms
- [ ] Multi-signature approval workflows
- [ ] Tokenized incentive system
- [ ] Mobile application interface
- [ ] Analytics and reporting dashboard
  \`\`\`

