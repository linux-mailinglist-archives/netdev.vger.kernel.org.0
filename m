Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C496022C994
	for <lists+netdev@lfdr.de>; Fri, 24 Jul 2020 17:58:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726804AbgGXP6V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jul 2020 11:58:21 -0400
Received: from dispatch1-us1.ppe-hosted.com ([67.231.154.164]:37704 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726381AbgGXP6U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jul 2020 11:58:20 -0400
Received: from mx1-us1.ppe-hosted.com (unknown [10.110.50.143])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id B6E602008C;
        Fri, 24 Jul 2020 15:58:19 +0000 (UTC)
Received: from us4-mdac16-32.at1.mdlocal (unknown [10.110.49.216])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id B543E800A4;
        Fri, 24 Jul 2020 15:58:19 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.110.50.12])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 5163740076;
        Fri, 24 Jul 2020 15:58:19 +0000 (UTC)
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 1916840051;
        Fri, 24 Jul 2020 15:58:19 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 24 Jul
 2020 16:58:14 +0100
From:   Edward Cree <ecree@solarflare.com>
Subject: [PATCH v4 net-next 05/16] sfc_ef100: reset-handling stub
To:     <linux-net-drivers@solarflare.com>, <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>
References: <d224dbb2-ef20-dca9-d50b-7f583b45d859@solarflare.com>
Message-ID: <445f4898-5740-8328-f157-a924e7359af9@solarflare.com>
Date:   Fri, 24 Jul 2020 16:58:11 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <d224dbb2-ef20-dca9-d50b-7f583b45d859@solarflare.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.17.20.203]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.6.1012-25560.003
X-TM-AS-Result: No-7.879100-8.000000-10
X-TMASE-MatchedRID: Q/M1H33ihxgOvl7WFhImC6iUivh0j2Pv6VTG9cZxEjJwGpdgNQ0JrEAc
        6DyoS2rI5SReHH9+PHhvxyzh32mLRl+1yB6ph7kziuSat/QiCL90ZH0LS0ioj1VkJxysad/IIlw
        23V5SV9A9E0NJTA0NuNsy08+R0rkt8cAZ6VCgjfKKYdYQLbymTedppbZRNp/IkY8eITaSJPjd1F
        DAxsDME7FAGhpvijOfF0gvSKckVXq6wtuwih3AcQlpVkdtt3WufS0Ip2eEHny+qryzYw2E8Jkw8
        KdMzN86KrauXd3MZDVR33PFYWkZTQhOXFwv0D7iAvKIOUibxhdEMjdKgA1k6DdrLfxYlTf7
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--7.879100-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.6.1012-25560.003
X-MDID: 1595606299-FZ3qiClGVLzm
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We don't actually do the efx_mcdi_reset() because we don't have MCDI yet.

Signed-off-by: Edward Cree <ecree@solarflare.com>
---
 drivers/net/ethernet/sfc/ef100_nic.c | 50 ++++++++++++++++++++++++++++
 1 file changed, 50 insertions(+)

diff --git a/drivers/net/ethernet/sfc/ef100_nic.c b/drivers/net/ethernet/sfc/ef100_nic.c
index 7bb304bc148e..875bbbdf606c 100644
--- a/drivers/net/ethernet/sfc/ef100_nic.c
+++ b/drivers/net/ethernet/sfc/ef100_nic.c
@@ -26,6 +26,8 @@
 
 #define EF100_MAX_VIS 4096
 
+#define EF100_RESET_PORT ((ETH_RESET_MAC | ETH_RESET_PHY) << ETH_RESET_SHARED_SHIFT)
+
 /*	MCDI
  */
 static int ef100_get_warm_boot_count(struct efx_nic *efx)
@@ -75,6 +77,51 @@ static irqreturn_t ef100_msi_interrupt(int irq, void *dev_id)
 	return IRQ_HANDLED;
 }
 
+/*	Other
+ */
+
+static enum reset_type ef100_map_reset_reason(enum reset_type reason)
+{
+	if (reason == RESET_TYPE_TX_WATCHDOG)
+		return reason;
+	return RESET_TYPE_DISABLE;
+}
+
+static int ef100_map_reset_flags(u32 *flags)
+{
+	/* Only perform a RESET_TYPE_ALL because we don't support MC_REBOOTs */
+	if ((*flags & EF100_RESET_PORT)) {
+		*flags &= ~EF100_RESET_PORT;
+		return RESET_TYPE_ALL;
+	}
+	if (*flags & ETH_RESET_MGMT) {
+		*flags &= ~ETH_RESET_MGMT;
+		return RESET_TYPE_DISABLE;
+	}
+
+	return -EINVAL;
+}
+
+static int ef100_reset(struct efx_nic *efx, enum reset_type reset_type)
+{
+	int rc;
+
+	dev_close(efx->net_dev);
+
+	if (reset_type == RESET_TYPE_TX_WATCHDOG) {
+		netif_device_attach(efx->net_dev);
+		__clear_bit(reset_type, &efx->reset_pending);
+		rc = dev_open(efx->net_dev, NULL);
+	} else if (reset_type == RESET_TYPE_ALL) {
+		netif_device_attach(efx->net_dev);
+
+		rc = dev_open(efx->net_dev, NULL);
+	} else {
+		rc = 1;	/* Leave the device closed */
+	}
+	return rc;
+}
+
 /*	NIC level access functions
  */
 const struct efx_nic_type ef100_pf_nic_type = {
@@ -86,6 +133,9 @@ const struct efx_nic_type ef100_pf_nic_type = {
 	.irq_disable_non_ev = efx_port_dummy_op_void,
 	.push_irq_moderation = efx_channel_dummy_op_void,
 	.min_interrupt_mode = EFX_INT_MODE_MSIX,
+	.map_reset_reason = ef100_map_reset_reason,
+	.map_reset_flags = ef100_map_reset_flags,
+	.reset = ef100_reset,
 
 	.ev_probe = ef100_ev_probe,
 	.irq_handle_msi = ef100_msi_interrupt,

