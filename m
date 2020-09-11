Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FF7526760B
	for <lists+netdev@lfdr.de>; Sat, 12 Sep 2020 00:41:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725961AbgIKWlO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Sep 2020 18:41:14 -0400
Received: from dispatch1-us1.ppe-hosted.com ([148.163.129.52]:47534 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725849AbgIKWlF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Sep 2020 18:41:05 -0400
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.65.61])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id A425860073;
        Fri, 11 Sep 2020 22:41:04 +0000 (UTC)
Received: from us4-mdac16-15.ut7.mdlocal (unknown [10.7.65.239])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id A14168009E;
        Fri, 11 Sep 2020 22:41:04 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.66.36])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 22C1080051;
        Fri, 11 Sep 2020 22:41:04 +0000 (UTC)
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id AC39BB4005D;
        Fri, 11 Sep 2020 22:41:03 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 11 Sep
 2020 23:40:45 +0100
From:   Edward Cree <ecree@solarflare.com>
Subject: [PATCH v2 net-next 7/7] sfc: advertise encapsulated offloads on EF10
To:     <linux-net-drivers@solarflare.com>, <davem@davemloft.net>
CC:     <kuba@kernel.org>, <netdev@vger.kernel.org>
References: <27a1329b-fe09-d8e0-1d43-2e53e2793748@solarflare.com>
Message-ID: <c890b093-4e16-63e1-b859-6dfb5eb0aaba@solarflare.com>
Date:   Fri, 11 Sep 2020 23:40:41 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <27a1329b-fe09-d8e0-1d43-2e53e2793748@solarflare.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.17.20.203]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.6.1012-25660.000
X-TM-AS-Result: No-5.891700-8.000000-10
X-TMASE-MatchedRID: 1qIE4CfpJ4xoF68z966sx6iUivh0j2Pv6VTG9cZxEjJwGpdgNQ0JrHIo
        zGa69omdrdoLblq9S5ra/g/NGTW3MmXzZ5RuLtFbZacDbE73ZSk1X1Ls767cplxnmzUvfrc7FfQ
        L8ZvDsiMHdFivjELuQ1+iKn//TlZw0X+0CFhNLNdqVGpA+EcxPqLwP+jjbL9KUjFJwpdmcrTDw2
        sknbo+ZWY/Frvur14inulf0N/GAGC/kNGHVZrslvbta0OAYFzyRwDU669267z3iJLIrb0ZaNXfa
        kMEIQ7HX2n/b4hEGTRn66S9KOi4wiYR+ngAfRMXaDCzqDR7DPZrTWaGefu3pAQsw9A3PIlLSHgU
        VMoIv2E4dbc1eLhrATdL+HhRCWgg7igYWrzLr2NyFiJvyj8nUDB4tWHctlhIC/U4++8MvOzk16J
        BEHxOhVA2CaMMg7qOduwXxn1y+zSJwG3AT4IH9dqCJFwujpdAq3wlNvsYBNgOkJQR4QWbsFuE36
        pB6+0bIfqPF9C+GOge3NMhq0+LXpH0YXYnbGozOX/V8P8ail1yZ8zcONpAscRB0bsfrpPIx1FPl
        NAAmcD9x1Lx1MwN2a+/IlbyyNnPQao+NLGP7Qk6H4hUkSowRp6oP1a0mRIj
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--5.891700-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.6.1012-25660.000
X-MDID: 1599864064-mjPs2OdFGucN
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Necessitates an .ndo_features_check, as the EF10 datapath has several
 limitations on what it can handle.

Signed-off-by: Edward Cree <ecree@solarflare.com>
---
 drivers/net/ethernet/sfc/ef10.c       | 16 +++++
 drivers/net/ethernet/sfc/efx.c        |  1 +
 drivers/net/ethernet/sfc/efx_common.c | 84 +++++++++++++++++++++++++++
 drivers/net/ethernet/sfc/efx_common.h |  3 +
 4 files changed, 104 insertions(+)

diff --git a/drivers/net/ethernet/sfc/ef10.c b/drivers/net/ethernet/sfc/ef10.c
index 4775b822519d..c9df2e96ebe4 100644
--- a/drivers/net/ethernet/sfc/ef10.c
+++ b/drivers/net/ethernet/sfc/ef10.c
@@ -1304,6 +1304,7 @@ static void efx_ef10_fini_nic(struct efx_nic *efx)
 static int efx_ef10_init_nic(struct efx_nic *efx)
 {
 	struct efx_ef10_nic_data *nic_data = efx->nic_data;
+	netdev_features_t hw_enc_features = 0;
 	int rc;
 
 	if (nic_data->must_check_datapath_caps) {
@@ -1348,6 +1349,21 @@ static int efx_ef10_init_nic(struct efx_nic *efx)
 		nic_data->must_restore_piobufs = false;
 	}
 
+	/* add encapsulated checksum offload features */
+	if (efx_has_cap(efx, VXLAN_NVGRE) && !efx_ef10_is_vf(efx))
+		hw_enc_features |= NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM;
+	/* add encapsulated TSO features */
+	if (efx_has_cap(efx, TX_TSO_V2_ENCAP)) {
+		netdev_features_t encap_tso_features;
+
+		encap_tso_features = NETIF_F_GSO_UDP_TUNNEL | NETIF_F_GSO_GRE |
+			NETIF_F_GSO_UDP_TUNNEL_CSUM | NETIF_F_GSO_GRE_CSUM;
+
+		hw_enc_features |= encap_tso_features | NETIF_F_TSO;
+		efx->net_dev->features |= encap_tso_features;
+	}
+	efx->net_dev->hw_enc_features = hw_enc_features;
+
 	/* don't fail init if RSS setup doesn't work */
 	rc = efx->type->rx_push_rss_config(efx, false,
 					   efx->rss_context.rx_indir_table, NULL);
diff --git a/drivers/net/ethernet/sfc/efx.c b/drivers/net/ethernet/sfc/efx.c
index 58b043f946b4..718308076341 100644
--- a/drivers/net/ethernet/sfc/efx.c
+++ b/drivers/net/ethernet/sfc/efx.c
@@ -596,6 +596,7 @@ static const struct net_device_ops efx_netdev_ops = {
 	.ndo_set_mac_address	= efx_set_mac_address,
 	.ndo_set_rx_mode	= efx_set_rx_mode,
 	.ndo_set_features	= efx_set_features,
+	.ndo_features_check	= efx_features_check,
 	.ndo_vlan_rx_add_vid	= efx_vlan_rx_add_vid,
 	.ndo_vlan_rx_kill_vid	= efx_vlan_rx_kill_vid,
 #ifdef CONFIG_SFC_SRIOV
diff --git a/drivers/net/ethernet/sfc/efx_common.c b/drivers/net/ethernet/sfc/efx_common.c
index 80a23def96ad..c256db241570 100644
--- a/drivers/net/ethernet/sfc/efx_common.c
+++ b/drivers/net/ethernet/sfc/efx_common.c
@@ -11,6 +11,7 @@
 #include "net_driver.h"
 #include <linux/module.h>
 #include <linux/netdevice.h>
+#include <net/gre.h>
 #include "efx_common.h"
 #include "efx_channels.h"
 #include "efx.h"
@@ -1287,6 +1288,89 @@ const struct pci_error_handlers efx_err_handlers = {
 	.resume		= efx_io_resume,
 };
 
+/* Determine whether the NIC will be able to handle TX offloads for a given
+ * encapsulated packet.
+ */
+static bool efx_can_encap_offloads(struct efx_nic *efx, struct sk_buff *skb)
+{
+	struct gre_base_hdr *greh;
+	__be16 dst_port;
+	u8 ipproto;
+
+	/* Does the NIC support encap offloads?
+	 * If not, we should never get here, because we shouldn't have
+	 * advertised encap offload feature flags in the first place.
+	 */
+	if (WARN_ON_ONCE(!efx->type->udp_tnl_has_port))
+		return false;
+
+	/* Determine encapsulation protocol in use */
+	switch (skb->protocol) {
+	case htons(ETH_P_IP):
+		ipproto = ip_hdr(skb)->protocol;
+		break;
+	case htons(ETH_P_IPV6):
+		/* If there are extension headers, this will cause us to
+		 * think we can't offload something that we maybe could have.
+		 */
+		ipproto = ipv6_hdr(skb)->nexthdr;
+		break;
+	default:
+		/* Not IP, so can't offload it */
+		return false;
+	}
+	switch (ipproto) {
+	case IPPROTO_GRE:
+		/* We support NVGRE but not IP over GRE or random gretaps.
+		 * Specifically, the NIC will accept GRE as encapsulated if
+		 * the inner protocol is Ethernet, but only handle it
+		 * correctly if the GRE header is 8 bytes long.  Moreover,
+		 * it will not update the Checksum or Sequence Number fields
+		 * if they are present.  (The Routing Present flag,
+		 * GRE_ROUTING, cannot be set else the header would be more
+		 * than 8 bytes long; so we don't have to worry about it.)
+		 */
+		if (skb->inner_protocol_type != ENCAP_TYPE_ETHER)
+			return false;
+		if (ntohs(skb->inner_protocol) != ETH_P_TEB)
+			return false;
+		if (skb_inner_mac_header(skb) - skb_transport_header(skb) != 8)
+			return false;
+		greh = (struct gre_base_hdr *)skb_transport_header(skb);
+		return !(greh->flags & (GRE_CSUM | GRE_SEQ));
+	case IPPROTO_UDP:
+		/* If the port is registered for a UDP tunnel, we assume the
+		 * packet is for that tunnel, and the NIC will handle it as
+		 * such.  If not, the NIC won't know what to do with it.
+		 */
+		dst_port = udp_hdr(skb)->dest;
+		return efx->type->udp_tnl_has_port(efx, dst_port);
+	default:
+		return false;
+	}
+}
+
+netdev_features_t efx_features_check(struct sk_buff *skb, struct net_device *dev,
+				     netdev_features_t features)
+{
+	struct efx_nic *efx = netdev_priv(dev);
+
+	if (skb->encapsulation) {
+		if (features & NETIF_F_GSO_MASK)
+			/* Hardware can only do TSO with at most 208 bytes
+			 * of headers.
+			 */
+			if (skb_inner_transport_offset(skb) >
+			    EFX_TSO2_MAX_HDRLEN)
+				features &= ~(NETIF_F_GSO_MASK);
+		if (features & (NETIF_F_GSO_MASK | NETIF_F_CSUM_MASK))
+			if (!efx_can_encap_offloads(efx, skb))
+				features &= ~(NETIF_F_GSO_MASK |
+					      NETIF_F_CSUM_MASK);
+	}
+	return features;
+}
+
 int efx_get_phys_port_id(struct net_device *net_dev,
 			 struct netdev_phys_item_id *ppid)
 {
diff --git a/drivers/net/ethernet/sfc/efx_common.h b/drivers/net/ethernet/sfc/efx_common.h
index 4056f68f04e5..65513fd0cf6c 100644
--- a/drivers/net/ethernet/sfc/efx_common.h
+++ b/drivers/net/ethernet/sfc/efx_common.h
@@ -105,6 +105,9 @@ int efx_change_mtu(struct net_device *net_dev, int new_mtu);
 
 extern const struct pci_error_handlers efx_err_handlers;
 
+netdev_features_t efx_features_check(struct sk_buff *skb, struct net_device *dev,
+				     netdev_features_t features);
+
 int efx_get_phys_port_id(struct net_device *net_dev,
 			 struct netdev_phys_item_id *ppid);
 
