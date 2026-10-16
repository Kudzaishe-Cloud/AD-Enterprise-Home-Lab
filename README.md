# Enterprise Active Directory Home Lab

A complete enterprise Active Directory environment built from scratch on a single laptop, documented in five phases. It covers the full stack an IT and IAM team manages day to day: the domain controller and core network services, identity structure, endpoint policy, access control, and the identity lifecycle with audit evidence.

> **Why I built it:** I've managed Active Directory in production environments. This lab is a hands-on refresher that rebuilds every layer from the ground up and documents the reasoning behind each decision.

## Lab at a glance

| Component | Details |
|---|---|
| Hypervisor | Oracle VirtualBox on a Windows 11 Home host (16 GB RAM) |
| Domain controller | DC01 · Windows Server 2022 · AD DS, DNS, DHCP |
| Domain | `corp.kudzaishelab.local` |
| Network | Isolated NAT Network · `10.0.10.0/24` |
| Client | Windows 11 Enterprise workstation *(Phase 3)* |

## Phases

| Phase | Focus | Status |
|---|---|---|
| [1 · Lab foundation and domain controller](phase-1-foundation/) | Isolated network, DC promotion, DNS, DHCP | ✅ Published |
| 2 · Identity structure | OUs, AGDLP groups, bulk user provisioning, admin account separation | 🔜 Coming soon |
| 3 · Endpoint integration and Group Policy | Domain join, password and lockout policy, workstation hardening | 🔜 Coming soon |
| 4 · Access control | Group-based NTFS and share permissions, least privilege testing | 🔜 Coming soon |
| 5 · IAM lifecycle and auditing | Joiner/mover/leaver, helpdesk delegation, account recovery, security auditing | 🔜 Coming soon |

## Skills

Windows Server 2022 · Active Directory · DNS · DHCP · Group Policy · NTFS permissions · PowerShell · identity lifecycle management · security auditing · troubleshooting

---

**Kudzaishe Rutsinga** · M.S. Cybersecurity, Yeshiva University · [LinkedIn](https://www.linkedin.com/in/your-profile)
