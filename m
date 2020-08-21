Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F6F824CED7
	for <lists+netdev@lfdr.de>; Fri, 21 Aug 2020 09:18:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728381AbgHUHSz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Aug 2020 03:18:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728255AbgHUHSS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Aug 2020 03:18:18 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B51E8C06137F
        for <netdev@vger.kernel.org>; Fri, 21 Aug 2020 00:17:20 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id w13so694082wrk.5
        for <netdev@vger.kernel.org>; Fri, 21 Aug 2020 00:17:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=TTQGsHQRzFX5OAR8V7RVO6NwsFWRtOx1Iv9gHAn+3hk=;
        b=H0If4VwMwvIezRg61jCDmEaLuOIKow/xxH3vRIk99/Excx7uuv8ZG+iiXbt91W245W
         lwEX5Jdr82u9cSH/oyc8DLIIg12nSWtSV16z8lS/JQ9YM738s0VrfDwPdtpnypTqi4qj
         0KeTPTduHoy3Y95RNToIJoQHmgTP2FILxLDN21vDRuFja0kAoEM3hLVauutoJyNwaE5D
         G6zs8cuyZ8Lbm3zMOTAlgp1ODGPDfK9xM6U9lEYqI6ffKXbnkNenysk9t7Rcjx1YdIlq
         JqM+wuLlWzBCKNpRcwi4v3CXX+iGEwKyYMjda+lXCSS19yGDAnZQkVvOjtnIL5k8Bhag
         74Ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=TTQGsHQRzFX5OAR8V7RVO6NwsFWRtOx1Iv9gHAn+3hk=;
        b=QY5ifqsptMAIy89ltM9V62jMyC+dAFNx+/W0hkXcxL4luUpJT2IlcT/RVVXFEE3m/D
         7iVB8q0wy8taGvmma4d5wvnsVlgrtUAp8iPy8p9RkSTJ6x7dLqMPdTiCsMd0f5ZqNFVz
         HB8xX4/NGaBl1EPXcnqZGD78Aw7k/8/paV4pVmaIG1T7tvoTfcN8Uj8i0d3r1use/V2X
         cofTzL83KINj+h3h8BHNrNQzd/6ixFPDoR61RHoIs05u16W/BZtjTgVtOwulWuFZ5tw3
         kDsPHxq+ziDZbUkgoweweQW3eL7c4hc0slt3HPd0Gjup71I/bs/AS7OruAsE0ZBNtB2C
         +XIQ==
X-Gm-Message-State: AOAM533nLHqprmLPlZaJc57iiiKNyzCkpH6s9PkL7VNCAlXrJhGy45f0
        cQJi2PYHdrlHAD+WFfBJhM+SvmrM8XqFyw==
X-Google-Smtp-Source: ABdhPJypR6JBvvKzIdB7X4ufqTk4XMzIbEfdEi/wes3RLIoRYZC6RVUejM/6zRFBlzDuEnIWHyal3Q==
X-Received: by 2002:adf:de8d:: with SMTP id w13mr1361499wrl.129.1597994239297;
        Fri, 21 Aug 2020 00:17:19 -0700 (PDT)
Received: from dell.default ([95.149.164.62])
        by smtp.gmail.com with ESMTPSA id y24sm2667957wmi.17.2020.08.21.00.17.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Aug 2020 00:17:18 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     kvalo@codeaurora.org, davem@davemloft.net, kuba@kernel.org
Cc:     linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, Lee Jones <lee.jones@linaro.org>,
        Maya Erez <merez@codeaurora.org>, wil6210@qti.qualcomm.com
Subject: [PATCH 25/32] wireless: ath: wil6210: wmi: Fix formatting and demote non-conforming function headers
Date:   Fri, 21 Aug 2020 08:16:37 +0100
Message-Id: <20200821071644.109970-26-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200821071644.109970-1-lee.jones@linaro.org>
References: <20200821071644.109970-1-lee.jones@linaro.org>
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
 drivers/net/wireless/ath/wil6210/wmi.c | 28 ++++++++++++++------------
 1 file changed, 15 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/wmi.c b/drivers/net/wireless/ath/wil6210/wmi.c
index c7136ce567eea..3a6ee85acf6c7 100644
--- a/drivers/net/wireless/ath/wil6210/wmi.c
+++ b/drivers/net/wireless/ath/wil6210/wmi.c
@@ -31,7 +31,7 @@ MODULE_PARM_DESC(led_id,
 #define WIL_WAIT_FOR_SUSPEND_RESUME_COMP 200
 #define WIL_WMI_PCP_STOP_TO_MS 5000
 
-/**
+/*
  * WMI event receiving - theory of operations
  *
  * When firmware about to report WMI event, it fills memory area
@@ -48,7 +48,7 @@ MODULE_PARM_DESC(led_id,
  * won't be completed because of blocked IRQ thread.
  */
 
-/**
+/*
  * Addressing - theory of operations
  *
  * There are several buses present on the WIL6210 card.
@@ -66,7 +66,7 @@ MODULE_PARM_DESC(led_id,
  * AHB address must be used.
  */
 
-/**
+/*
  * @sparrow_fw_mapping provides memory remapping table for sparrow
  *
  * array size should be in sync with the declaration in the wil6210.h
@@ -103,7 +103,7 @@ const struct fw_map sparrow_fw_mapping[] = {
 	{0x800000, 0x804000, 0x940000, "uc_data", false, false},
 };
 
-/**
+/*
  * @sparrow_d0_mac_rgf_ext - mac_rgf_ext section for Sparrow D0
  * it is a bit larger to support extra features
  */
@@ -111,7 +111,7 @@ const struct fw_map sparrow_d0_mac_rgf_ext = {
 	0x88c000, 0x88c500, 0x88c000, "mac_rgf_ext", true, true
 };
 
-/**
+/*
  * @talyn_fw_mapping provides memory remapping table for Talyn
  *
  * array size should be in sync with the declaration in the wil6210.h
@@ -154,7 +154,7 @@ const struct fw_map talyn_fw_mapping[] = {
 	{0x800000, 0x808000, 0xa78000, "uc_data", false, false},
 };
 
-/**
+/*
  * @talyn_mb_fw_mapping provides memory remapping table for Talyn-MB
  *
  * array size should be in sync with the declaration in the wil6210.h
@@ -229,7 +229,7 @@ u8 led_polarity = LED_POLARITY_LOW_ACTIVE;
 
 /**
  * return AHB address for given firmware internal (linker) address
- * @x - internal address
+ * @x: internal address
  * If address have no valid AHB mapping, return 0
  */
 static u32 wmi_addr_remap(u32 x)
@@ -247,7 +247,7 @@ static u32 wmi_addr_remap(u32 x)
 
 /**
  * find fw_mapping entry by section name
- * @section - section name
+ * @section: section name
  *
  * Return pointer to section or NULL if not found
  */
@@ -265,8 +265,9 @@ struct fw_map *wil_find_fw_mapping(const char *section)
 
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
@@ -300,7 +301,7 @@ void __iomem *wmi_buffer(struct wil6210_priv *wil, __le32 ptr_)
 	return wmi_buffer_block(wil, ptr_, 0);
 }
 
-/**
+/*
  * Check address validity
  */
 void __iomem *wmi_addr(struct wil6210_priv *wil, u32 ptr)
@@ -1577,7 +1578,7 @@ wmi_evt_link_stats(struct wil6210_vif *vif, int id, void *d, int len)
 			     evt->payload, payload_size);
 }
 
-/**
+/*
  * find cid and ringid for the station vif
  *
  * return error, if other interfaces are used or ring was not found
@@ -1868,7 +1869,7 @@ wmi_evt_link_monitor(struct wil6210_vif *vif, int id, void *d, int len)
 	cfg80211_cqm_rssi_notify(ndev, event_type, evt->rssi_level, GFP_KERNEL);
 }
 
-/**
+/*
  * Some events are ignored for purpose; and need not be interpreted as
  * "unhandled events"
  */
@@ -2578,6 +2579,7 @@ int wmi_update_ft_ies(struct wil6210_vif *vif, u16 ie_len, const void *ie)
 
 /**
  * wmi_rxon - turn radio on/off
+ * @wil:	driver data
  * @on:		turn on if true, off otherwise
  *
  * Only switch radio. Channel should be set separately.
-- 
2.25.1

