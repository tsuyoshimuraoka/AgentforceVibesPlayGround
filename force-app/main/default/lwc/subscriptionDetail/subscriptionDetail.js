import { LightningElement, api, track } from "lwc";

export default class SubscriptionDetail extends LightningElement {
  @api recordId;
  @track subscription;
  @track isLoading = false;

  connectedCallback() {
    this.loadSubscription();
  }

  loadSubscription() {
    this.isLoading = true;
    // TODO: Implement data loading from Apex
    Promise.resolve().then(() => {
      this.isLoading = false;
    });
  }

  handleRefresh() {
    this.loadSubscription();
  }
}
