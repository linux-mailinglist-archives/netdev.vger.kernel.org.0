Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02BC0263DDA
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 09:01:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730275AbgIJG76 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 02:59:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728207AbgIJG5j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Sep 2020 02:57:39 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B31FC061348
        for <netdev@vger.kernel.org>; Wed,  9 Sep 2020 23:55:13 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id a65so4458751wme.5
        for <netdev@vger.kernel.org>; Wed, 09 Sep 2020 23:55:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=oWmssmRDs9wD67bjPcBNZ7suDiU6o2jmm0CnpGzG4Gs=;
        b=o4RYptxuopBdft3ihpsYx4uNTDHkjdwyLoWFYKkz+MMLkgQpwIALHK6RxNTUhYmDSI
         VTAp3cMImohyS+WupMHc8DEf+ssuIzm5vexaUOMn4vNVhBVrTldZAHS3oz9JmCNpwjIR
         4U+VKxv5Pv31p/xMfChqv2xcwJviJGWlZe52OjrPZwBy7Jj9+zHAOgYg5fq97NrHHSHY
         XQd48xJG98SwPLWUVywGarl3ZX/vL4Om60vc+qmu5klQSsngbLM/AbWGNxfbdBon09sc
         JovnDUDNuuOtLNPJznaG6T6xwcL7j6c8bJN7DGnsvycgcJjtbYKlRWohuZK1nNC7cs0T
         HFJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=oWmssmRDs9wD67bjPcBNZ7suDiU6o2jmm0CnpGzG4Gs=;
        b=ppENgWn1RX74FM+CfLdZkk4phGxRMNeL5W/pgpEyAaBJQ+i9R0hc7ZPyS1vQlL6WAg
         f9FIymsR5z88Tkwu5p1dAVJMd4p6eLEpEiHCv1jXeNxoO9m0dkiXrhAyNMJWkSWXq0ov
         JL3huMNyfeTr/3O7KZHQ5gfRv+9hFFvdua2zGnzH5QTR+e3gMY0oQcH2VECSzimGu/Lt
         PggB2IVW4drUfU3eCCTpyxCGV1bq57xyEk6kqLLpe99ldJiIKw6QGm7sNq6nQqOYtdIa
         yTY+7EYXWN+aoOgwqckG34eXXoM0q4Kij2hzYmPbX70ruH8jxKPOv7T4wiYeXvAqhzsA
         AHQA==
X-Gm-Message-State: AOAM532jBNQo/lTCo2GOtQi8iuhs0FNS65AOABaRb96c3dV9R9p+zxuY
        ayIebMHOFV46EWakv9d2spWvng==
X-Google-Smtp-Source: ABdhPJxGOuIKK6/snCNwluZ6DgphR+vi68NV19yl/SqMT1q01pjsoFOL6VlnJMHMnkhojdj1+zUqAA==
X-Received: by 2002:a7b:c44b:: with SMTP id l11mr6833665wmi.52.1599720912025;
        Wed, 09 Sep 2020 23:55:12 -0700 (PDT)
Received: from dell.default ([91.110.221.246])
        by smtp.gmail.com with ESMTPSA id m3sm2444028wme.31.2020.09.09.23.55.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Sep 2020 23:55:11 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     kvalo@codeaurora.org, davem@davemloft.net, kuba@kernel.org
Cc:     linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, Lee Jones <lee.jones@linaro.org>,
        Maya Erez <merez@codeaurora.org>, wil6210@qti.qualcomm.com
Subject: [PATCH 16/29] wil6210: wmi: Fix formatting and demote non-conforming function headers
Date:   Thu, 10 Sep 2020 07:54:18 +0100
Message-Id: <20200910065431.657636-17-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200910065431.657636-1-lee.jones@linaro.org>
References: <20200910065431.657636-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fixes the following W=1 kernel build warning(s):

 drivers/net/wireless/ath/wil6210/wmi.c:52: warning: Incorrect use of kernel-doc format:  * Addressing - theory of operations
 drivers/net/wireless/ath/wil6210/wmi.c:70: warning: Incorrect use of kernel-doc format:  * @sparrow_fw_mapping provides memory remapping table for sparrow
 drivers/net/wireless/ath/wil6210/wmi.c:80: warning: cannot understand function prototype: 'const struct fw_map sparrow_fw_mapping[] = '
 drivers/net/wireless/ath/wil6210/wmi.c:107: warning: Cannot understand  * @sparrow_d0_mac_rgf_ext - mac_rgf_ext section for Sparrow D0
 drivers/net/wireless/ath/wil6210/wmi.c:115: warning: Cannot understand  * @talyn_fw_mapping provides memory remapping table for Talyn
 drivers/net/wireless/ath/wil6210/wmi.c:158: warning: Cannot understand  * @talyn_mb_fw_mapping provides memory remapping table for Talyn-MB
 drivers/net/wireless/ath/wil6210/wmi.c:236: warning: Function parameter or member 'x' not described in 'wmi_addr_remap'
 drivers/net/wireless/ath/wil6210/wmi.c:255: warning: Function parameter or member 'section' not described in 'wil_find_fw_mapping'
 drivers/net/wireless/ath/wil6210/wmi.c:278: warning: Function parameter or member 'wil' not described in 'wmi_buffer_block'
 drivers/net/wireless/ath/wil6210/wmi.c:278: warning: Function parameter or member 'ptr_' not described in 'wmi_buffer_block'
 drivers/net/wireless/ath/wil6210/wmi.c:278: warning: Function parameter or member 'size' not described in 'wmi_buffer_block'
 drivers/net/wireless/ath/wil6210/wmi.c:307: warning: Function parameter or member 'wil' not described in 'wmi_addr'
 drivers/net/wireless/ath/wil6210/wmi.c:307: warning: Function parameter or member 'ptr' not described in 'wmi_addr'
 drivers/net/wireless/ath/wil6210/wmi.c:1589: warning: Function parameter or member 'wil' not described in 'wil_find_cid_ringid_sta'
 drivers/net/wireless/ath/wil6210/wmi.c:1589: warning: Function parameter or member 'vif' not described in 'wil_find_cid_ringid_sta'
 drivers/net/wireless/ath/wil6210/wmi.c:1589: warning: Function parameter or member 'cid' not described in 'wil_find_cid_ringid_sta'
 drivers/net/wireless/ath/wil6210/wmi.c:1589: warning: Function parameter or member 'ringid' not described in 'wil_find_cid_ringid_sta'
 drivers/net/wireless/ath/wil6210/wmi.c:1876: warning: Function parameter or member 'vif' not described in 'wmi_evt_ignore'
 drivers/net/wireless/ath/wil6210/wmi.c:1876: warning: Function parameter or member 'id' not described in 'wmi_evt_ignore'
 drivers/net/wireless/ath/wil6210/wmi.c:1876: warning: Function parameter or member 'd' not described in 'wmi_evt_ignore'
 drivers/net/wireless/ath/wil6210/wmi.c:1876: warning: Function parameter or member 'len' not described in 'wmi_evt_ignore'
 drivers/net/wireless/ath/wil6210/wmi.c:2588: warning: Function parameter or member 'wil' not described in 'wmi_rxon'

Cc: Maya Erez <merez@codeaurora.org>
Cc: Kalle Valo <kvalo@codeaurora.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: linux-wireless@vger.kernel.org
Cc: wil6210@qti.qualcomm.com
Cc: netdev@vger.kernel.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/net/wireless/ath/wil6210/wmi.c | 36 +++++++++++---------------
 1 file changed, 15 insertions(+), 21 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/wmi.c b/drivers/net/wireless/ath/wil6210/wmi.c
index c7136ce567eea..421aebbb49e54 100644
--- a/drivers/net/wireless/ath/wil6210/wmi.c
+++ b/drivers/net/wireless/ath/wil6210/wmi.c
@@ -32,7 +32,7 @@ MODULE_PARM_DESC(led_id,
 #define WIL_WMI_PCP_STOP_TO_MS 5000
 
 /**
- * WMI event receiving - theory of operations
+ * DOC: WMI event receiving - theory of operations
  *
  * When firmware about to report WMI event, it fills memory area
  * in the mailbox and raises misc. IRQ. Thread interrupt handler invoked for
@@ -49,7 +49,7 @@ MODULE_PARM_DESC(led_id,
  */
 
 /**
- * Addressing - theory of operations
+ * DOC: Addressing - theory of operations
  *
  * There are several buses present on the WIL6210 card.
  * Same memory areas are visible at different address on
@@ -66,8 +66,7 @@ MODULE_PARM_DESC(led_id,
  * AHB address must be used.
  */
 
-/**
- * @sparrow_fw_mapping provides memory remapping table for sparrow
+/* sparrow_fw_mapping provides memory remapping table for sparrow
  *
  * array size should be in sync with the declaration in the wil6210.h
  *
@@ -103,16 +102,14 @@ const struct fw_map sparrow_fw_mapping[] = {
 	{0x800000, 0x804000, 0x940000, "uc_data", false, false},
 };
 
-/**
- * @sparrow_d0_mac_rgf_ext - mac_rgf_ext section for Sparrow D0
+/* sparrow_d0_mac_rgf_ext - mac_rgf_ext section for Sparrow D0
  * it is a bit larger to support extra features
  */
 const struct fw_map sparrow_d0_mac_rgf_ext = {
 	0x88c000, 0x88c500, 0x88c000, "mac_rgf_ext", true, true
 };
 
-/**
- * @talyn_fw_mapping provides memory remapping table for Talyn
+/* talyn_fw_mapping provides memory remapping table for Talyn
  *
  * array size should be in sync with the declaration in the wil6210.h
  *
@@ -154,8 +151,7 @@ const struct fw_map talyn_fw_mapping[] = {
 	{0x800000, 0x808000, 0xa78000, "uc_data", false, false},
 };
 
-/**
- * @talyn_mb_fw_mapping provides memory remapping table for Talyn-MB
+/* talyn_mb_fw_mapping provides memory remapping table for Talyn-MB
  *
  * array size should be in sync with the declaration in the wil6210.h
  *
@@ -229,7 +225,7 @@ u8 led_polarity = LED_POLARITY_LOW_ACTIVE;
 
 /**
  * return AHB address for given firmware internal (linker) address
- * @x - internal address
+ * @x: internal address
  * If address have no valid AHB mapping, return 0
  */
 static u32 wmi_addr_remap(u32 x)
@@ -247,7 +243,7 @@ static u32 wmi_addr_remap(u32 x)
 
 /**
  * find fw_mapping entry by section name
- * @section - section name
+ * @section: section name
  *
  * Return pointer to section or NULL if not found
  */
@@ -265,8 +261,9 @@ struct fw_map *wil_find_fw_mapping(const char *section)
 
 /**
  * Check address validity for WMI buffer; remap if needed
- * @ptr - internal (linker) fw/ucode address
- * @size - if non zero, validate the block does not
+ * @wil: driver data
+ * @ptr: internal (linker) fw/ucode address
+ * @size: if non zero, validate the block does not
  *  exceed the device memory (bar)
  *
  * Valid buffer should be DWORD aligned
@@ -300,9 +297,7 @@ void __iomem *wmi_buffer(struct wil6210_priv *wil, __le32 ptr_)
 	return wmi_buffer_block(wil, ptr_, 0);
 }
 
-/**
- * Check address validity
- */
+/* Check address validity */
 void __iomem *wmi_addr(struct wil6210_priv *wil, u32 ptr)
 {
 	u32 off;
@@ -1577,8 +1572,7 @@ wmi_evt_link_stats(struct wil6210_vif *vif, int id, void *d, int len)
 			     evt->payload, payload_size);
 }
 
-/**
- * find cid and ringid for the station vif
+/* find cid and ringid for the station vif
  *
  * return error, if other interfaces are used or ring was not found
  */
@@ -1868,8 +1862,7 @@ wmi_evt_link_monitor(struct wil6210_vif *vif, int id, void *d, int len)
 	cfg80211_cqm_rssi_notify(ndev, event_type, evt->rssi_level, GFP_KERNEL);
 }
 
-/**
- * Some events are ignored for purpose; and need not be interpreted as
+/* Some events are ignored for purpose; and need not be interpreted as
  * "unhandled events"
  */
 static void wmi_evt_ignore(struct wil6210_vif *vif, int id, void *d, int len)
@@ -2578,6 +2571,7 @@ int wmi_update_ft_ies(struct wil6210_vif *vif, u16 ie_len, const void *ie)
 
 /**
  * wmi_rxon - turn radio on/off
+ * @wil:	driver data
  * @on:		turn on if true, off otherwise
  *
  * Only switch radio. Channel should be set separately.
-- 
2.25.1

