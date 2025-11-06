import { LightningElement, wire, track } from "lwc";
import getSubscriptions from "@salesforce/apex/AdminConsoleController.getSubscriptions";

export default class AdminConsole extends LightningElement {
  @track subscriptions = [];
  @track filteredSubscriptions = [];
  @track isLoading = false;
  @track searchKey = "";

  @wire(getSubscriptions, { searchKey: "$searchKey" })
  wiredSubscriptions({ error, data }) {
    if (data) {
      this.subscriptions = data;
      this.filteredSubscriptions = data;
    } else if (error) {
      console.error(error);
    }
  }

  handleSearch(event) {
    this.searchKey = event.target.value;
  }

  handleRefresh() {
    this.isLoading = true;
    // Re-fetching via wire adapter
    Promise.resolve().then(() => {
      this.isLoading = false;
    });
  }

  handleAction(event) {
    const action = event.detail.action;
    const subscription = event.detail.subscription;
    console.log(
      `Action ${action} triggered on subscription ${subscription.Id}`
    );
    // TODO: Implement action handlers (e.g., pause, cancel, etc.)
  }
}
