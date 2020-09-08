Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BE28261C96
	for <lists+netdev@lfdr.de>; Tue,  8 Sep 2020 21:23:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731141AbgIHTW4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Sep 2020 15:22:56 -0400
Received: from dispatch1-us1.ppe-hosted.com ([148.163.129.52]:33938 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732025AbgIHTWi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Sep 2020 15:22:38 -0400
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.65.64])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 0FE646007D;
        Tue,  8 Sep 2020 19:22:35 +0000 (UTC)
Received: from us4-mdac16-50.ut7.mdlocal (unknown [10.7.66.17])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 0D8F8200A4;
        Tue,  8 Sep 2020 19:22:35 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.66.36])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 7B90E22005C;
        Tue,  8 Sep 2020 19:22:34 +0000 (UTC)
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 096A9B40056;
        Tue,  8 Sep 2020 19:22:34 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 8 Sep 2020
 20:22:28 +0100
From:   Edward Cree <ecree@solarflare.com>
Subject: [PATCH net-next] sfc: coding style cleanups in mcdi_port_common.c
To:     <linux-net-drivers@solarflare.com>, <davem@davemloft.net>
CC:     <kuba@kernel.org>, <netdev@vger.kernel.org>
Message-ID: <f0b8cbd8-ef52-a23a-2dca-41443203d2f1@solarflare.com>
Date:   Tue, 8 Sep 2020 20:22:19 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.17.20.203]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.6.1012-25652.007
X-TM-AS-Result: No-10.592500-8.000000-10
X-TMASE-MatchedRID: EHnJIs8Lfgsm7rIJPLyX6cn9tWHiLD2GcQ43DruBJVyDy8d72OLzYi9K
        xKOWRM488XVI39JCRnSjfNAVYAJRAq0iin8P0KjVPwKTD1v8YV5MkOX0UoduuRpX1zEL4nq3KKq
        yc9Qq8Xo77YAfpQmyVFBMneTPTCN+B/TKGEQxH0Wejeo11iW0N6KRkGOW2z9yUYvAleUDiYjlbM
        hsZmLJPSg3N6/Mq46hlIPOLuLWA1glPqZXjEJJlub3p4cnIXGNZ/rAPfrtWC1HZg0gWH5yURTjm
        soJ9VExfRvCo8kOueMH4jvnDtS/yk1+zyfzlN7ygxsfzkNRlfLdB/CxWTRRu25FeHtsUoHu3pFB
        1wZ7tGzRNK2NCjtWuC1o8tIvtO+YyNQe+dPerVMchXTZ3Wukbw==
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--10.592500-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.6.1012-25652.007
X-MDID: 1599592955-oK9MOV0SIMaT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The code recently moved into this file contained a number of coding style
 issues, about which checkpatch and xmastree complained.  Fix them.

Signed-off-by: Edward Cree <ecree@solarflare.com>
---
 drivers/net/ethernet/sfc/mcdi_port_common.c | 23 +++++++++++----------
 drivers/net/ethernet/sfc/mcdi_port_common.h |  2 +-
 2 files changed, 13 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/sfc/mcdi_port_common.c b/drivers/net/ethernet/sfc/mcdi_port_common.c
index c0e1c88a652c..4bd3ef8f3384 100644
--- a/drivers/net/ethernet/sfc/mcdi_port_common.c
+++ b/drivers/net/ethernet/sfc/mcdi_port_common.c
@@ -484,15 +484,15 @@ int efx_mcdi_phy_probe(struct efx_nic *efx)
 	if (rc != 0)
 		goto fail;
 	/* The MC indicates that LOOPBACK_NONE is a valid loopback mode,
-	 * but by convention we don't */
+	 * but by convention we don't
+	 */
 	efx->loopback_modes &= ~(1 << LOOPBACK_NONE);
 
 	/* Set the initial link mode */
-	efx_mcdi_phy_decode_link(
-		efx, &efx->link_state,
-		MCDI_DWORD(outbuf, GET_LINK_OUT_LINK_SPEED),
-		MCDI_DWORD(outbuf, GET_LINK_OUT_FLAGS),
-		MCDI_DWORD(outbuf, GET_LINK_OUT_FCNTL));
+	efx_mcdi_phy_decode_link(efx, &efx->link_state,
+				 MCDI_DWORD(outbuf, GET_LINK_OUT_LINK_SPEED),
+				 MCDI_DWORD(outbuf, GET_LINK_OUT_FLAGS),
+				 MCDI_DWORD(outbuf, GET_LINK_OUT_FCNTL));
 
 	/* Record the initial FEC configuration (or nearest approximation
 	 * representable in the ethtool configuration space)
@@ -798,7 +798,7 @@ static int efx_mcdi_bist(struct efx_nic *efx, unsigned int bist_mode,
 	return rc;
 }
 
-int efx_mcdi_phy_run_tests(struct efx_nic *efx, int *results, unsigned flags)
+int efx_mcdi_phy_run_tests(struct efx_nic *efx, int *results, unsigned int flags)
 {
 	struct efx_mcdi_phy_data *phy_cfg = efx->phy_data;
 	u32 mode;
@@ -813,7 +813,8 @@ int efx_mcdi_phy_run_tests(struct efx_nic *efx, int *results, unsigned flags)
 	}
 
 	/* If we support both LONG and SHORT, then run each in response to
-	 * break or not. Otherwise, run the one we support */
+	 * break or not. Otherwise, run the one we support
+	 */
 	mode = 0;
 	if (phy_cfg->flags & (1 << MC_CMD_GET_PHY_CFG_OUT_BIST_CABLE_SHORT_LBN)) {
 		if ((flags & ETH_TEST_FL_OFFLINE) &&
@@ -888,9 +889,9 @@ static int efx_mcdi_phy_get_module_eeprom_page(struct efx_nic *efx,
 {
 	MCDI_DECLARE_BUF(outbuf, MC_CMD_GET_PHY_MEDIA_INFO_OUT_LENMAX);
 	MCDI_DECLARE_BUF(inbuf, MC_CMD_GET_PHY_MEDIA_INFO_IN_LEN);
-	size_t outlen;
 	unsigned int payload_len;
 	unsigned int to_copy;
+	size_t outlen;
 	int rc;
 
 	if (offset > SFP_PAGE_SIZE)
@@ -925,8 +926,8 @@ static int efx_mcdi_phy_get_module_eeprom_byte(struct efx_nic *efx,
 					       unsigned int page,
 					       u8 byte)
 {
-	int rc;
 	u8 data;
+	int rc;
 
 	rc = efx_mcdi_phy_get_module_eeprom_page(efx, page, &data, byte, 1);
 	if (rc == 1)
@@ -1049,7 +1050,7 @@ int efx_mcdi_phy_get_module_info(struct efx_nic *efx, struct ethtool_modinfo *mo
 		 */
 		diag_type = efx_mcdi_phy_diag_type(efx);
 
-		if ((sff_8472_level == 0) ||
+		if (sff_8472_level == 0 ||
 		    (diag_type & SFF_DIAG_ADDR_CHANGE)) {
 			modinfo->type = ETH_MODULE_SFF_8079;
 			modinfo->eeprom_len = ETH_MODULE_SFF_8079_LEN;
diff --git a/drivers/net/ethernet/sfc/mcdi_port_common.h b/drivers/net/ethernet/sfc/mcdi_port_common.h
index f37e18adbc37..ed31690e591c 100644
--- a/drivers/net/ethernet/sfc/mcdi_port_common.h
+++ b/drivers/net/ethernet/sfc/mcdi_port_common.h
@@ -53,7 +53,7 @@ int efx_mcdi_phy_get_fecparam(struct efx_nic *efx, struct ethtool_fecparam *fec)
 int efx_mcdi_phy_set_fecparam(struct efx_nic *efx, const struct ethtool_fecparam *fec);
 int efx_mcdi_phy_test_alive(struct efx_nic *efx);
 int efx_mcdi_port_reconfigure(struct efx_nic *efx);
-int efx_mcdi_phy_run_tests(struct efx_nic *efx, int *results, unsigned flags);
+int efx_mcdi_phy_run_tests(struct efx_nic *efx, int *results, unsigned int flags);
 const char *efx_mcdi_phy_test_name(struct efx_nic *efx, unsigned int index);
 int efx_mcdi_phy_get_module_eeprom(struct efx_nic *efx, struct ethtool_eeprom *ee, u8 *data);
 int efx_mcdi_phy_get_module_info(struct efx_nic *efx, struct ethtool_modinfo *modinfo);
