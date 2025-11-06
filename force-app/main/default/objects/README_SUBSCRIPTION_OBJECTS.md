Design summary (Part 1 footprint created so far)

- Custom Objects added:
  - Subscription\_\_c: core subscription master (status/dates/period/tax/rounding/MRR)
  - SubscriptionItem\_\_c: subscription line items (product/qty/price/discount)
  - Invoice\_\_c: invoices (status/date/tax/rounding/totals)
  - InvoiceLine\_\_c: invoice lines (qty/unit price/subtotals)
  - Payment\_\_c: payment outcomes (result/errors/attempts)
  - PaymentMethod\_\_c: tokenized payment methods per Account
  - BillingSchedule\_\_c: execution control for billing windows
  - DunningStep\_\_c: progression records for dunning execution
- Next in Part 1: Custom Metadata Types, Platform Events, Permission Sets, Tabs, Apex skeleton, minimal LWC shells.

Notes

- Objects use minimal fields to unblock Services/Batch scaffolding.
- Multi-currency compatibility preserved by avoiding hard custom currency handling for now; CurrencyIsoCode can be added to layouts for reporting.
- Follow-up tasks will add page layouts, tabs, permissions, and CMT-driven controls plus Apex/LWC.
