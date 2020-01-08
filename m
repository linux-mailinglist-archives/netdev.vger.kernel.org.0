Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 32C2B13474E
	for <lists+netdev@lfdr.de>; Wed,  8 Jan 2020 17:12:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727841AbgAHQL5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jan 2020 11:11:57 -0500
Received: from dispatch1-us1.ppe-hosted.com ([148.163.129.52]:46504 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726186AbgAHQL5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jan 2020 11:11:57 -0500
X-Virus-Scanned: Proofpoint Essentials engine
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us3.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id C83E1480097;
        Wed,  8 Jan 2020 16:11:55 +0000 (UTC)
Received: from amm-opti7060.uk.solarflarecom.com (10.17.20.147) by
 ukex01.SolarFlarecom.com (10.17.10.4) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Wed, 8 Jan 2020 16:11:49 +0000
From:   "Alex Maftei (amaftei)" <amaftei@solarflare.com>
Subject: [PATCH net-next 06/14] sfc: move some device reset code
To:     <netdev@vger.kernel.org>, <davem@davemloft.net>
CC:     <linux-net-drivers@solarflare.com>, <scrum-linux@solarflare.com>
References: <a0cfb828-b98e-3a63-15d9-592675e81b5f@solarflare.com>
Message-ID: <077eafab-8c33-8c12-d9b2-29a0c08c1315@solarflare.com>
Date:   Wed, 8 Jan 2020 16:11:46 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <a0cfb828-b98e-3a63-15d9-592675e81b5f@solarflare.com>
Content-Type: text/plain; charset="windows-1252"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.17.20.147]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1010-25154.003
X-TM-AS-Result: No-6.820900-8.000000-10
X-TMASE-MatchedRID: NRXuyqgiqGkCs1JL6zcjxRouoVvF2i0ZAf1C358hdK9jLp8Cm8vwFwoe
        RRhCZWIBnvBWG5GT8Jdw5T4Iaj538mJZXQNDzktSGjzBgnFZvQ4Qtuqs6BbPJ58TZJWHqTM8zHU
        ZBlJiIJcaEIxiUoPdLx8dLzBRS5b1sz/yBXbG+DdC4WIP7GtYLN1eFEoaE12nMTkWY9HYyZEyyy
        fr0UIbOYYFGTrTbnHnM0v0qdFfgIUx8mf5Szr6KUf49ONH0RaSdQbBMo+jd6WtyIlQ9jhSMWyuN
        axLNX09fXbyT9/TnYkt4c78JOvk9j99VOuv+/DjUPktDdOX0fvVLWM3sYUOfznZfxjBVQRb1mwi
        z5WhcjT3zpQCE1ys/idWGNeDxvoBMvu44h/tYPcjRwcsjqWGAudppbZRNp/IfE7unL5EELwK/Gq
        AMST36/xRYvlIka/iaFNCiX4IOVTDDpxXTlwoXcGNvKPnBgOa56ZiKymUcU41Z0DEBOIiJUPBKj
        2tpM4OYKGJzLOZyQSmCsrK53xgEUL5qYNMJ0izvoQkZKo949MvsOOmgOo1mSdcFmaShWFJM6KP1
        fFjVRW6/xa0MoJu7vEZXTnjP2GbWhGKUaUS+phbUzvsaHW6BmKA1HVKZBuTvGAx/1ATZ5vYnVNI
        SjHqWyiIeL9Ckv5pLgjs0Uv5Ssq+zVeD5435mhaon88GOG1afXRAc+s3RFdXiLrvhpKLfKJFmbm
        fOdw3sZlS4sU6vZWbKItl61J/ycnjLTA/UDoAGL0faaTpb9b3FLeZXNZS4EZLVcXaUbdi4N18eL
        Y835VvUf4+rrqhywPxWdOhW1Usnkb7aOtOcGaeqD9WtJkSIw==
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--6.820900-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1010-25154.003
X-MDID: 1578499916-Ba8zlnjT1AdS
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The rest of the reset code will be moved later.
Small code styling fixes included.

Signed-off-by: Alexandru-Mihai Maftei <amaftei@solarflare.com>
---
 drivers/net/ethernet/sfc/efx.c        | 227 ------------------------
 drivers/net/ethernet/sfc/efx_common.c | 237 ++++++++++++++++++++++++++
 2 files changed, 237 insertions(+), 227 deletions(-)

diff --git a/drivers/net/ethernet/sfc/efx.c b/drivers/net/ethernet/sfc/efx.c
index 988687a80abe..40d1e8ef672d 100644
--- a/drivers/net/ethernet/sfc/efx.c
+++ b/drivers/net/ethernet/sfc/efx.c
@@ -2483,184 +2483,6 @@ static void efx_unregister_netdev(struct efx_nic *efx)
  *
  **************************************************************************/
 
-/* Tears down the entire software state and most of the hardware state
- * before reset.  */
-void efx_reset_down(struct efx_nic *efx, enum reset_type method)
-{
-	EFX_ASSERT_RESET_SERIALISED(efx);
-
-	if (method == RESET_TYPE_MCDI_TIMEOUT)
-		efx->type->prepare_flr(efx);
-
-	efx_stop_all(efx);
-	efx_disable_interrupts(efx);
-
-	mutex_lock(&efx->mac_lock);
-	down_write(&efx->filter_sem);
-	mutex_lock(&efx->rss_lock);
-	if (efx->port_initialized && method != RESET_TYPE_INVISIBLE &&
-	    method != RESET_TYPE_DATAPATH)
-		efx->phy_op->fini(efx);
-	efx->type->fini(efx);
-}
-
-/* This function will always ensure that the locks acquired in
- * efx_reset_down() are released. A failure return code indicates
- * that we were unable to reinitialise the hardware, and the
- * driver should be disabled. If ok is false, then the rx and tx
- * engines are not restarted, pending a RESET_DISABLE. */
-int efx_reset_up(struct efx_nic *efx, enum reset_type method, bool ok)
-{
-	int rc;
-
-	EFX_ASSERT_RESET_SERIALISED(efx);
-
-	if (method == RESET_TYPE_MCDI_TIMEOUT)
-		efx->type->finish_flr(efx);
-
-	/* Ensure that SRAM is initialised even if we're disabling the device */
-	rc = efx->type->init(efx);
-	if (rc) {
-		netif_err(efx, drv, efx->net_dev, "failed to initialise NIC\n");
-		goto fail;
-	}
-
-	if (!ok)
-		goto fail;
-
-	if (efx->port_initialized && method != RESET_TYPE_INVISIBLE &&
-	    method != RESET_TYPE_DATAPATH) {
-		rc = efx->phy_op->init(efx);
-		if (rc)
-			goto fail;
-		rc = efx->phy_op->reconfigure(efx);
-		if (rc && rc != -EPERM)
-			netif_err(efx, drv, efx->net_dev,
-				  "could not restore PHY settings\n");
-	}
-
-	rc = efx_enable_interrupts(efx);
-	if (rc)
-		goto fail;
-
-#ifdef CONFIG_SFC_SRIOV
-	rc = efx->type->vswitching_restore(efx);
-	if (rc) /* not fatal; the PF will still work fine */
-		netif_warn(efx, probe, efx->net_dev,
-			   "failed to restore vswitching rc=%d;"
-			   " VFs may not function\n", rc);
-#endif
-
-	if (efx->type->rx_restore_rss_contexts)
-		efx->type->rx_restore_rss_contexts(efx);
-	mutex_unlock(&efx->rss_lock);
-	efx->type->filter_table_restore(efx);
-	up_write(&efx->filter_sem);
-	if (efx->type->sriov_reset)
-		efx->type->sriov_reset(efx);
-
-	mutex_unlock(&efx->mac_lock);
-
-	efx_start_all(efx);
-
-	if (efx->type->udp_tnl_push_ports)
-		efx->type->udp_tnl_push_ports(efx);
-
-	return 0;
-
-fail:
-	efx->port_initialized = false;
-
-	mutex_unlock(&efx->rss_lock);
-	up_write(&efx->filter_sem);
-	mutex_unlock(&efx->mac_lock);
-
-	return rc;
-}
-
-/* Reset the NIC using the specified method.  Note that the reset may
- * fail, in which case the card will be left in an unusable state.
- *
- * Caller must hold the rtnl_lock.
- */
-int efx_reset(struct efx_nic *efx, enum reset_type method)
-{
-	int rc, rc2;
-	bool disabled;
-
-	netif_info(efx, drv, efx->net_dev, "resetting (%s)\n",
-		   RESET_TYPE(method));
-
-	efx_device_detach_sync(efx);
-	efx_reset_down(efx, method);
-
-	rc = efx->type->reset(efx, method);
-	if (rc) {
-		netif_err(efx, drv, efx->net_dev, "failed to reset hardware\n");
-		goto out;
-	}
-
-	/* Clear flags for the scopes we covered.  We assume the NIC and
-	 * driver are now quiescent so that there is no race here.
-	 */
-	if (method < RESET_TYPE_MAX_METHOD)
-		efx->reset_pending &= -(1 << (method + 1));
-	else /* it doesn't fit into the well-ordered scope hierarchy */
-		__clear_bit(method, &efx->reset_pending);
-
-	/* Reinitialise bus-mastering, which may have been turned off before
-	 * the reset was scheduled. This is still appropriate, even in the
-	 * RESET_TYPE_DISABLE since this driver generally assumes the hardware
-	 * can respond to requests. */
-	pci_set_master(efx->pci_dev);
-
-out:
-	/* Leave device stopped if necessary */
-	disabled = rc ||
-		method == RESET_TYPE_DISABLE ||
-		method == RESET_TYPE_RECOVER_OR_DISABLE;
-	rc2 = efx_reset_up(efx, method, !disabled);
-	if (rc2) {
-		disabled = true;
-		if (!rc)
-			rc = rc2;
-	}
-
-	if (disabled) {
-		dev_close(efx->net_dev);
-		netif_err(efx, drv, efx->net_dev, "has been disabled\n");
-		efx->state = STATE_DISABLED;
-	} else {
-		netif_dbg(efx, drv, efx->net_dev, "reset complete\n");
-		efx_device_attach_if_not_resetting(efx);
-	}
-	return rc;
-}
-
-/* Try recovery mechanisms.
- * For now only EEH is supported.
- * Returns 0 if the recovery mechanisms are unsuccessful.
- * Returns a non-zero value otherwise.
- */
-int efx_try_recovery(struct efx_nic *efx)
-{
-#ifdef CONFIG_EEH
-	/* A PCI error can occur and not be seen by EEH because nothing
-	 * happens on the PCI bus. In this case the driver may fail and
-	 * schedule a 'recover or reset', leading to this recovery handler.
-	 * Manually call the eeh failure check function.
-	 */
-	struct eeh_dev *eehdev = pci_dev_to_eeh_dev(efx->pci_dev);
-	if (eeh_dev_check_failure(eehdev)) {
-		/* The EEH mechanisms will handle the error and reset the
-		 * device if necessary.
-		 */
-		return 1;
-	}
-#endif
-	return 0;
-}
-
 static void efx_wait_for_bist_end(struct efx_nic *efx)
 {
 	int i;
@@ -2714,55 +2536,6 @@ static void efx_reset_work(struct work_struct *data)
 	rtnl_unlock();
 }
 
-void efx_schedule_reset(struct efx_nic *efx, enum reset_type type)
-{
-	enum reset_type method;
-
-	if (efx->state == STATE_RECOVERY) {
-		netif_dbg(efx, drv, efx->net_dev,
-			  "recovering: skip scheduling %s reset\n",
-			  RESET_TYPE(type));
-		return;
-	}
-
-	switch (type) {
-	case RESET_TYPE_INVISIBLE:
-	case RESET_TYPE_ALL:
-	case RESET_TYPE_RECOVER_OR_ALL:
-	case RESET_TYPE_WORLD:
-	case RESET_TYPE_DISABLE:
-	case RESET_TYPE_RECOVER_OR_DISABLE:
-	case RESET_TYPE_DATAPATH:
-	case RESET_TYPE_MC_BIST:
-	case RESET_TYPE_MCDI_TIMEOUT:
-		method = type;
-		netif_dbg(efx, drv, efx->net_dev, "scheduling %s reset\n",
-			  RESET_TYPE(method));
-		break;
-	default:
-		method = efx->type->map_reset_reason(type);
-		netif_dbg(efx, drv, efx->net_dev,
-			  "scheduling %s reset for %s\n",
-			  RESET_TYPE(method), RESET_TYPE(type));
-		break;
-	}
-
-	set_bit(method, &efx->reset_pending);
-	smp_mb(); /* ensure we change reset_pending before checking state */
-
-	/* If we're not READY then just leave the flags set as the cue
-	 * to abort probing or reschedule the reset later.
-	 */
-	if (READ_ONCE(efx->state) != STATE_READY)
-		return;
-
-	/* efx_process_channel() will no longer read events once a
-	 * reset is scheduled. So switch back to poll'd MCDI completions. */
-	efx_mcdi_mode_poll(efx);
-
-	efx_queue_reset_work(efx);
-}
-
 /**************************************************************************
  *
  * List of NICs we support
diff --git a/drivers/net/ethernet/sfc/efx_common.c b/drivers/net/ethernet/sfc/efx_common.c
index 445340c903b1..813ebdda50f6 100644
--- a/drivers/net/ethernet/sfc/efx_common.c
+++ b/drivers/net/ethernet/sfc/efx_common.c
@@ -429,3 +429,240 @@ int efx_reconfigure_port(struct efx_nic *efx)
 
 	return rc;
 }
+
+/**************************************************************************
+ *
+ * Device reset and suspend
+ *
+ **************************************************************************/
+
+/* Try recovery mechanisms.
+ * For now only EEH is supported.
+ * Returns 0 if the recovery mechanisms are unsuccessful.
+ * Returns a non-zero value otherwise.
+ */
+int efx_try_recovery(struct efx_nic *efx)
+{
+#ifdef CONFIG_EEH
+	/* A PCI error can occur and not be seen by EEH because nothing
+	 * happens on the PCI bus. In this case the driver may fail and
+	 * schedule a 'recover or reset', leading to this recovery handler.
+	 * Manually call the eeh failure check function.
+	 */
+	struct eeh_dev *eehdev = pci_dev_to_eeh_dev(efx->pci_dev);
+	if (eeh_dev_check_failure(eehdev)) {
+		/* The EEH mechanisms will handle the error and reset the
+		 * device if necessary.
+		 */
+		return 1;
+	}
+#endif
+	return 0;
+}
+
+/* Tears down the entire software state and most of the hardware state
+ * before reset.
+ */
+void efx_reset_down(struct efx_nic *efx, enum reset_type method)
+{
+	EFX_ASSERT_RESET_SERIALISED(efx);
+
+	if (method == RESET_TYPE_MCDI_TIMEOUT)
+		efx->type->prepare_flr(efx);
+
+	efx_stop_all(efx);
+	efx_disable_interrupts(efx);
+
+	mutex_lock(&efx->mac_lock);
+	down_write(&efx->filter_sem);
+	mutex_lock(&efx->rss_lock);
+	if (efx->port_initialized && method != RESET_TYPE_INVISIBLE &&
+	    method != RESET_TYPE_DATAPATH)
+		efx->phy_op->fini(efx);
+	efx->type->fini(efx);
+}
+
+/* This function will always ensure that the locks acquired in
+ * efx_reset_down() are released. A failure return code indicates
+ * that we were unable to reinitialise the hardware, and the
+ * driver should be disabled. If ok is false, then the rx and tx
+ * engines are not restarted, pending a RESET_DISABLE.
+ */
+int efx_reset_up(struct efx_nic *efx, enum reset_type method, bool ok)
+{
+	int rc;
+
+	EFX_ASSERT_RESET_SERIALISED(efx);
+
+	if (method == RESET_TYPE_MCDI_TIMEOUT)
+		efx->type->finish_flr(efx);
+
+	/* Ensure that SRAM is initialised even if we're disabling the device */
+	rc = efx->type->init(efx);
+	if (rc) {
+		netif_err(efx, drv, efx->net_dev, "failed to initialise NIC\n");
+		goto fail;
+	}
+
+	if (!ok)
+		goto fail;
+
+	if (efx->port_initialized && method != RESET_TYPE_INVISIBLE &&
+	    method != RESET_TYPE_DATAPATH) {
+		rc = efx->phy_op->init(efx);
+		if (rc)
+			goto fail;
+		rc = efx->phy_op->reconfigure(efx);
+		if (rc && rc != -EPERM)
+			netif_err(efx, drv, efx->net_dev,
+				  "could not restore PHY settings\n");
+	}
+
+	rc = efx_enable_interrupts(efx);
+	if (rc)
+		goto fail;
+
+#ifdef CONFIG_SFC_SRIOV
+	rc = efx->type->vswitching_restore(efx);
+	if (rc) /* not fatal; the PF will still work fine */
+		netif_warn(efx, probe, efx->net_dev,
+			   "failed to restore vswitching rc=%d;"
+			   " VFs may not function\n", rc);
+#endif
+
+	if (efx->type->rx_restore_rss_contexts)
+		efx->type->rx_restore_rss_contexts(efx);
+	mutex_unlock(&efx->rss_lock);
+	efx->type->filter_table_restore(efx);
+	up_write(&efx->filter_sem);
+	if (efx->type->sriov_reset)
+		efx->type->sriov_reset(efx);
+
+	mutex_unlock(&efx->mac_lock);
+
+	efx_start_all(efx);
+
+	if (efx->type->udp_tnl_push_ports)
+		efx->type->udp_tnl_push_ports(efx);
+
+	return 0;
+
+fail:
+	efx->port_initialized = false;
+
+	mutex_unlock(&efx->rss_lock);
+	up_write(&efx->filter_sem);
+	mutex_unlock(&efx->mac_lock);
+
+	return rc;
+}
+
+/* Reset the NIC using the specified method.  Note that the reset may
+ * fail, in which case the card will be left in an unusable state.
+ *
+ * Caller must hold the rtnl_lock.
+ */
+int efx_reset(struct efx_nic *efx, enum reset_type method)
+{
+	bool disabled;
+	int rc, rc2;
+
+	netif_info(efx, drv, efx->net_dev, "resetting (%s)\n",
+		   RESET_TYPE(method));
+
+	efx_device_detach_sync(efx);
+	efx_reset_down(efx, method);
+
+	rc = efx->type->reset(efx, method);
+	if (rc) {
+		netif_err(efx, drv, efx->net_dev, "failed to reset hardware\n");
+		goto out;
+	}
+
+	/* Clear flags for the scopes we covered.  We assume the NIC and
+	 * driver are now quiescent so that there is no race here.
+	 */
+	if (method < RESET_TYPE_MAX_METHOD)
+		efx->reset_pending &= -(1 << (method + 1));
+	else /* it doesn't fit into the well-ordered scope hierarchy */
+		__clear_bit(method, &efx->reset_pending);
+
+	/* Reinitialise bus-mastering, which may have been turned off before
+	 * the reset was scheduled. This is still appropriate, even in the
+	 * RESET_TYPE_DISABLE since this driver generally assumes the hardware
+	 * can respond to requests.
+	 */
+	pci_set_master(efx->pci_dev);
+
+out:
+	/* Leave device stopped if necessary */
+	disabled = rc ||
+		method == RESET_TYPE_DISABLE ||
+		method == RESET_TYPE_RECOVER_OR_DISABLE;
+	rc2 = efx_reset_up(efx, method, !disabled);
+	if (rc2) {
+		disabled = true;
+		if (!rc)
+			rc = rc2;
+	}
+
+	if (disabled) {
+		dev_close(efx->net_dev);
+		netif_err(efx, drv, efx->net_dev, "has been disabled\n");
+		efx->state = STATE_DISABLED;
+	} else {
+		netif_dbg(efx, drv, efx->net_dev, "reset complete\n");
+		efx_device_attach_if_not_resetting(efx);
+	}
+	return rc;
+}
+
+void efx_schedule_reset(struct efx_nic *efx, enum reset_type type)
+{
+	enum reset_type method;
+
+	if (efx->state == STATE_RECOVERY) {
+		netif_dbg(efx, drv, efx->net_dev,
+			  "recovering: skip scheduling %s reset\n",
+			  RESET_TYPE(type));
+		return;
+	}
+
+	switch (type) {
+	case RESET_TYPE_INVISIBLE:
+	case RESET_TYPE_ALL:
+	case RESET_TYPE_RECOVER_OR_ALL:
+	case RESET_TYPE_WORLD:
+	case RESET_TYPE_DISABLE:
+	case RESET_TYPE_RECOVER_OR_DISABLE:
+	case RESET_TYPE_DATAPATH:
+	case RESET_TYPE_MC_BIST:
+	case RESET_TYPE_MCDI_TIMEOUT:
+		method = type;
+		netif_dbg(efx, drv, efx->net_dev, "scheduling %s reset\n",
+			  RESET_TYPE(method));
+		break;
+	default:
+		method = efx->type->map_reset_reason(type);
+		netif_dbg(efx, drv, efx->net_dev,
+			  "scheduling %s reset for %s\n",
+			  RESET_TYPE(method), RESET_TYPE(type));
+		break;
+	}
+
+	set_bit(method, &efx->reset_pending);
+	smp_mb(); /* ensure we change reset_pending before checking state */
+
+	/* If we're not READY then just leave the flags set as the cue
+	 * to abort probing or reschedule the reset later.
+	 */
+	if (READ_ONCE(efx->state) != STATE_READY)
+		return;
+
+	/* efx_process_channel() will no longer read events once a
+	 * reset is scheduled. So switch back to poll'd MCDI completions.
+	 */
+	efx_mcdi_mode_poll(efx);
+
+	efx_queue_reset_work(efx);
+}
-- 
2.20.1


