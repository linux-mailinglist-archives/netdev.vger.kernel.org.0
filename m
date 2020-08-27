Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E29BA253F2B
	for <lists+netdev@lfdr.de>; Thu, 27 Aug 2020 09:32:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728084AbgH0HcH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Aug 2020 03:32:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726123AbgH0HcG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Aug 2020 03:32:06 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44C3FC061264
        for <netdev@vger.kernel.org>; Thu, 27 Aug 2020 00:32:05 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id s13so4207231wmh.4
        for <netdev@vger.kernel.org>; Thu, 27 Aug 2020 00:32:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=oWmssmRDs9wD67bjPcBNZ7suDiU6o2jmm0CnpGzG4Gs=;
        b=ONznxcdI1MGbvGzmRNdcYDYAVs6mY7gkmY9e7YtDnJMEHRT8M91v+bLycVxyFa+wrC
         WzvCTFFv+W1yjly4lOw9XQFk5ZKd1Y1eJlCpE7OJVTaACA7RTmKTJ6GNCHyYTXNmwPMP
         WmjprJlVYP1+JgodOTkp4xKCzCqPOjO2MoO993bBHZEK7NHbdrjs+NK2bvirPwltPatA
         9y0445ig36XZxU7hM203T54e+1jpEgWZSLprilrbfyrFDFhxSm4+nnK7q2QuUz8Mpo8J
         oKoMXncAskVpV3Bm/Hp6tpDd3P9HcLYKaZQTtWwIR9qBOFwmBtXBLZimVnqt3yXUfTJ/
         5xcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=oWmssmRDs9wD67bjPcBNZ7suDiU6o2jmm0CnpGzG4Gs=;
        b=dPWYdl2oABvI91OXiSpPnq2jYpfOk05FvTtNDd32tQks+hdrFpINy1JVkkk/sGIHxq
         3vqw7BY9QjAJ/B0M2yXW3HFKBixmIAB+syFjHUy2pHUH7cHSyKrMfnFWHBD9Ho/VutFf
         SKk3GLcgLzbn9V8V1NPGYBuBsL2Crt2znri6/Dv3+X5tiZ7rRuKOdNjwcFWYMnFr2aBM
         Pk6TovMhOM/Rgkb27nc6ln5q48EUoyBUT45ehWAUm4AfCJWxWdNrlDpWRyW0IqfjMd+f
         n25kfWT4ehbyDpt3uGepPI8es01c+OxMvSGH80UG1yROhYJN0GqxRn+xBQxm0Q2cHdLG
         vu1w==
X-Gm-Message-State: AOAM533ihP5Y7WtoNswOoWM6kPeeUyPG4sNkGsWP8wVGBe+aZrSRsCDA
        B0d19cMJNSHdGy8RMqxrHkkQ2Q==
X-Google-Smtp-Source: ABdhPJwGTYupZzQOjXH+NXlMiY0faCKb+66J/FyCau6Jp2F1Rt8K2iFMZhFEMMwOVElmzaJ7256RkQ==
X-Received: by 2002:a1c:2dcb:: with SMTP id t194mr10098326wmt.94.1598513523777;
        Thu, 27 Aug 2020 00:32:03 -0700 (PDT)
Received: from dell ([91.110.221.141])
        by smtp.gmail.com with ESMTPSA id f6sm4138720wro.5.2020.08.27.00.32.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Aug 2020 00:32:02 -0700 (PDT)
Date:   Thu, 27 Aug 2020 08:32:01 +0100
From:   Lee Jones <lee.jones@linaro.org>
To:     kvalo@codeaurora.org, davem@davemloft.net, kuba@kernel.org
Cc:     linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, Maya Erez <merez@codeaurora.org>,
        wil6210@qti.qualcomm.com
Subject: [PATCH v2 25/32] wireless: ath: wil6210: wmi: Fix formatting and
 demote non-conforming function headers
Message-ID: <20200827073201.GR3248864@dell>
References: <20200821071644.109970-1-lee.jones@linaro.org>
 <20200821071644.109970-26-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200821071644.109970-26-lee.jones@linaro.org>
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
