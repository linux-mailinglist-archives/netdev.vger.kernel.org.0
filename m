Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A7831E9603
	for <lists+netdev@lfdr.de>; Sun, 31 May 2020 09:07:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387422AbgEaHGx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 31 May 2020 03:06:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387407AbgEaHGx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 31 May 2020 03:06:53 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12740C05BD43
        for <netdev@vger.kernel.org>; Sun, 31 May 2020 00:06:53 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id y17so8189282wrn.11
        for <netdev@vger.kernel.org>; Sun, 31 May 2020 00:06:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=lPMutBkJju6wyauV5k7LNnHuIgh2OD++KVtMrRBIPHQ=;
        b=JhhZpmLvZBUWgR40VS/139ETOgxSQa6asVF8ZtsrvxIptVjcXW08sF39c0buh6MViu
         fYEzMioD9dwE4JRWth0w0VBntvADmWFcyEp3wnivMe1wd00lVhpnpiGo9I1K162prOQS
         VsabitljIDac9wGpvuCc1IOwXLslQbaaFxPNg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=lPMutBkJju6wyauV5k7LNnHuIgh2OD++KVtMrRBIPHQ=;
        b=Ec+MeB/nSyixVcu2TX4zbMip81R8fZ6T1up2XQBtPtH0xFL9JtJwjggsjBIID2Q2RT
         GxZHHk/JzgRI+NW3lvsJ4Xps25fw7pPMT/14gJnND1F8vK9O5t+W7RFPeZxnfcLZXPKG
         G+vt84EdZCFV9d8KIG2e/dij8mIyXZon3U+vkX/vjKYbfrEHaTb/AeDZL0nhsCX3g2wl
         QcW0qo/C8XBc+cIfRLyhdC3h0GjDZxbWkJTb8wRPE0oc/v36SVeWDnHtKSRRm943XgTd
         o07B2HG5kH73p49zY/cAlLCymqDOyR/MEwaLZhksX/l9Py6XXXaY8pRRQdmLMs2YM5fR
         tyVA==
X-Gm-Message-State: AOAM533xApFmHD879o/y1p/15vJnm7rCYq8SCz+SZJ5cyS2Rv+FuKZY0
        +km/UHzTEoLU9eBOu2lFPjnWFQ==
X-Google-Smtp-Source: ABdhPJw/7U3twnCd7c1YsMkcq4aUp9/C1cmUQTxFjJNOXBbOfcA58aBAU3ZQ50mf3S4Txx0tm1vKPA==
X-Received: by 2002:adf:de84:: with SMTP id w4mr16649665wrl.54.1590908811613;
        Sun, 31 May 2020 00:06:51 -0700 (PDT)
Received: from lxpurley1.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id 5sm4828731wrr.5.2020.05.31.00.06.49
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 31 May 2020 00:06:51 -0700 (PDT)
From:   Vasundhara Volam <vasundhara-v.volam@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, michael.chan@broadcom.com,
        Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Subject: [PATCH v3 net-next 4/6] bnxt_en: Update firmware spec. to 1.10.1.40.
Date:   Sun, 31 May 2020 12:33:43 +0530
Message-Id: <1590908625-10952-5-git-send-email-vasundhara-v.volam@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1590908625-10952-1-git-send-email-vasundhara-v.volam@broadcom.com>
References: <1590908625-10952-1-git-send-email-vasundhara-v.volam@broadcom.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Major changes are to add additional flags to configure hot firmware
reset.

Signed-off-by: Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
Reviewed-by: Edwin Peer <edwin.peer@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt_hsi.h | 64 ++++++++++++++++-----------
 1 file changed, 37 insertions(+), 27 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_hsi.h b/drivers/net/ethernet/broadcom/bnxt/bnxt_hsi.h
index 7e9235c..0a6e60e 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_hsi.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_hsi.h
@@ -367,6 +367,8 @@ struct cmd_nums {
 	#define HWRM_TF_EXT_EM_OP                         0x2ddUL
 	#define HWRM_TF_EXT_EM_CFG                        0x2deUL
 	#define HWRM_TF_EXT_EM_QCFG                       0x2dfUL
+	#define HWRM_TF_EM_INSERT                         0x2e0UL
+	#define HWRM_TF_EM_DELETE                         0x2e1UL
 	#define HWRM_TF_TCAM_SET                          0x2eeUL
 	#define HWRM_TF_TCAM_GET                          0x2efUL
 	#define HWRM_TF_TCAM_MOVE                         0x2f0UL
@@ -391,6 +393,7 @@ struct cmd_nums {
 	#define HWRM_DBG_QCAPS                            0xff20UL
 	#define HWRM_DBG_QCFG                             0xff21UL
 	#define HWRM_DBG_CRASHDUMP_MEDIUM_CFG             0xff22UL
+	#define HWRM_NVM_REQ_ARBITRATION                  0xffedUL
 	#define HWRM_NVM_FACTORY_DEFAULTS                 0xffeeUL
 	#define HWRM_NVM_VALIDATE_OPTION                  0xffefUL
 	#define HWRM_NVM_FLUSH                            0xfff0UL
@@ -464,8 +467,8 @@ struct hwrm_err_output {
 #define HWRM_VERSION_MAJOR 1
 #define HWRM_VERSION_MINOR 10
 #define HWRM_VERSION_UPDATE 1
-#define HWRM_VERSION_RSVD 33
-#define HWRM_VERSION_STR "1.10.1.33"
+#define HWRM_VERSION_RSVD 40
+#define HWRM_VERSION_STR "1.10.1.40"
 
 /* hwrm_ver_get_input (size:192b/24B) */
 struct hwrm_ver_get_input {
@@ -1192,6 +1195,7 @@ struct hwrm_func_qcaps_output {
 	#define FUNC_QCAPS_RESP_FLAGS_EXT_ECN_MARK_SUPPORTED         0x1UL
 	#define FUNC_QCAPS_RESP_FLAGS_EXT_ECN_STATS_SUPPORTED        0x2UL
 	#define FUNC_QCAPS_RESP_FLAGS_EXT_EXT_HW_STATS_SUPPORTED     0x4UL
+	#define FUNC_QCAPS_RESP_FLAGS_EXT_HOT_RESET_IF_SUPPORT       0x8UL
 	u8	unused_1[3];
 	u8	valid;
 };
@@ -1226,6 +1230,7 @@ struct hwrm_func_qcfg_output {
 	#define FUNC_QCFG_RESP_FLAGS_TRUSTED_VF                   0x40UL
 	#define FUNC_QCFG_RESP_FLAGS_SECURE_MODE_ENABLED          0x80UL
 	#define FUNC_QCFG_RESP_FLAGS_PREBOOT_LEGACY_L2_RINGS      0x100UL
+	#define FUNC_QCFG_RESP_FLAGS_HOT_RESET_ALLOWED            0x200UL
 	u8	mac_address[6];
 	__le16	pci_id;
 	__le16	alloc_rsscos_ctx;
@@ -1352,30 +1357,32 @@ struct hwrm_func_cfg_input {
 	#define FUNC_CFG_REQ_FLAGS_NQ_ASSETS_TEST                 0x800000UL
 	#define FUNC_CFG_REQ_FLAGS_TRUSTED_VF_DISABLE             0x1000000UL
 	#define FUNC_CFG_REQ_FLAGS_PREBOOT_LEGACY_L2_RINGS        0x2000000UL
+	#define FUNC_CFG_REQ_FLAGS_HOT_RESET_IF_EN_DIS            0x4000000UL
 	__le32	enables;
-	#define FUNC_CFG_REQ_ENABLES_MTU                     0x1UL
-	#define FUNC_CFG_REQ_ENABLES_MRU                     0x2UL
-	#define FUNC_CFG_REQ_ENABLES_NUM_RSSCOS_CTXS         0x4UL
-	#define FUNC_CFG_REQ_ENABLES_NUM_CMPL_RINGS          0x8UL
-	#define FUNC_CFG_REQ_ENABLES_NUM_TX_RINGS            0x10UL
-	#define FUNC_CFG_REQ_ENABLES_NUM_RX_RINGS            0x20UL
-	#define FUNC_CFG_REQ_ENABLES_NUM_L2_CTXS             0x40UL
-	#define FUNC_CFG_REQ_ENABLES_NUM_VNICS               0x80UL
-	#define FUNC_CFG_REQ_ENABLES_NUM_STAT_CTXS           0x100UL
-	#define FUNC_CFG_REQ_ENABLES_DFLT_MAC_ADDR           0x200UL
-	#define FUNC_CFG_REQ_ENABLES_DFLT_VLAN               0x400UL
-	#define FUNC_CFG_REQ_ENABLES_DFLT_IP_ADDR            0x800UL
-	#define FUNC_CFG_REQ_ENABLES_MIN_BW                  0x1000UL
-	#define FUNC_CFG_REQ_ENABLES_MAX_BW                  0x2000UL
-	#define FUNC_CFG_REQ_ENABLES_ASYNC_EVENT_CR          0x4000UL
-	#define FUNC_CFG_REQ_ENABLES_VLAN_ANTISPOOF_MODE     0x8000UL
-	#define FUNC_CFG_REQ_ENABLES_ALLOWED_VLAN_PRIS       0x10000UL
-	#define FUNC_CFG_REQ_ENABLES_EVB_MODE                0x20000UL
-	#define FUNC_CFG_REQ_ENABLES_NUM_MCAST_FILTERS       0x40000UL
-	#define FUNC_CFG_REQ_ENABLES_NUM_HW_RING_GRPS        0x80000UL
-	#define FUNC_CFG_REQ_ENABLES_CACHE_LINESIZE          0x100000UL
-	#define FUNC_CFG_REQ_ENABLES_NUM_MSIX                0x200000UL
-	#define FUNC_CFG_REQ_ENABLES_ADMIN_LINK_STATE        0x400000UL
+	#define FUNC_CFG_REQ_ENABLES_MTU                      0x1UL
+	#define FUNC_CFG_REQ_ENABLES_MRU                      0x2UL
+	#define FUNC_CFG_REQ_ENABLES_NUM_RSSCOS_CTXS          0x4UL
+	#define FUNC_CFG_REQ_ENABLES_NUM_CMPL_RINGS           0x8UL
+	#define FUNC_CFG_REQ_ENABLES_NUM_TX_RINGS             0x10UL
+	#define FUNC_CFG_REQ_ENABLES_NUM_RX_RINGS             0x20UL
+	#define FUNC_CFG_REQ_ENABLES_NUM_L2_CTXS              0x40UL
+	#define FUNC_CFG_REQ_ENABLES_NUM_VNICS                0x80UL
+	#define FUNC_CFG_REQ_ENABLES_NUM_STAT_CTXS            0x100UL
+	#define FUNC_CFG_REQ_ENABLES_DFLT_MAC_ADDR            0x200UL
+	#define FUNC_CFG_REQ_ENABLES_DFLT_VLAN                0x400UL
+	#define FUNC_CFG_REQ_ENABLES_DFLT_IP_ADDR             0x800UL
+	#define FUNC_CFG_REQ_ENABLES_MIN_BW                   0x1000UL
+	#define FUNC_CFG_REQ_ENABLES_MAX_BW                   0x2000UL
+	#define FUNC_CFG_REQ_ENABLES_ASYNC_EVENT_CR           0x4000UL
+	#define FUNC_CFG_REQ_ENABLES_VLAN_ANTISPOOF_MODE      0x8000UL
+	#define FUNC_CFG_REQ_ENABLES_ALLOWED_VLAN_PRIS        0x10000UL
+	#define FUNC_CFG_REQ_ENABLES_EVB_MODE                 0x20000UL
+	#define FUNC_CFG_REQ_ENABLES_NUM_MCAST_FILTERS        0x40000UL
+	#define FUNC_CFG_REQ_ENABLES_NUM_HW_RING_GRPS         0x80000UL
+	#define FUNC_CFG_REQ_ENABLES_CACHE_LINESIZE           0x100000UL
+	#define FUNC_CFG_REQ_ENABLES_NUM_MSIX                 0x200000UL
+	#define FUNC_CFG_REQ_ENABLES_ADMIN_LINK_STATE         0x400000UL
+	#define FUNC_CFG_REQ_ENABLES_HOT_RESET_IF_SUPPORT     0x800000UL
 	__le16	mtu;
 	__le16	mru;
 	__le16	num_rsscos_ctxs;
@@ -7620,7 +7627,8 @@ struct hwrm_dbg_ring_info_get_input {
 	#define DBG_RING_INFO_GET_REQ_RING_TYPE_L2_CMPL 0x0UL
 	#define DBG_RING_INFO_GET_REQ_RING_TYPE_TX      0x1UL
 	#define DBG_RING_INFO_GET_REQ_RING_TYPE_RX      0x2UL
-	#define DBG_RING_INFO_GET_REQ_RING_TYPE_LAST   DBG_RING_INFO_GET_REQ_RING_TYPE_RX
+	#define DBG_RING_INFO_GET_REQ_RING_TYPE_NQ      0x3UL
+	#define DBG_RING_INFO_GET_REQ_RING_TYPE_LAST   DBG_RING_INFO_GET_REQ_RING_TYPE_NQ
 	u8	unused_0[3];
 	__le32	fw_ring_id;
 };
@@ -7633,7 +7641,8 @@ struct hwrm_dbg_ring_info_get_output {
 	__le16	resp_len;
 	__le32	producer_index;
 	__le32	consumer_index;
-	u8	unused_0[7];
+	__le32	cag_vector_ctrl;
+	u8	unused_0[3];
 	u8	valid;
 };
 
@@ -7922,6 +7931,7 @@ struct hwrm_nvm_install_update_input {
 	#define NVM_INSTALL_UPDATE_REQ_FLAGS_ERASE_UNUSED_SPACE     0x1UL
 	#define NVM_INSTALL_UPDATE_REQ_FLAGS_REMOVE_UNUSED_PKG      0x2UL
 	#define NVM_INSTALL_UPDATE_REQ_FLAGS_ALLOWED_TO_DEFRAG      0x4UL
+	#define NVM_INSTALL_UPDATE_REQ_FLAGS_VERIFY_ONLY            0x8UL
 	u8	unused_0[2];
 };
 
-- 
1.8.3.1

