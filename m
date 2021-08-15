Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E35CC3EC826
	for <lists+netdev@lfdr.de>; Sun, 15 Aug 2021 10:26:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236614AbhHOI04 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Aug 2021 04:26:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236425AbhHOI04 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Aug 2021 04:26:56 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 191AAC061764
        for <netdev@vger.kernel.org>; Sun, 15 Aug 2021 01:26:26 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id x10so12881792wrt.8
        for <netdev@vger.kernel.org>; Sun, 15 Aug 2021 01:26:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:subject:to:cc:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=wAjKS1vt9FTQkfUmOoQMRGLzVP3/rY0bv0rum+XWJAo=;
        b=B3OGTIEkBLYXJlCGkdJ91ZxKazMcUTGmbfFIQiNsOb8oFdOjbbX6dhs/KWkcYUTwk6
         XyvGv+vslXYgGm7yxRCjBvyRfmUpHlArF/C5feh8y96adj8AEmx0kGJE2v6yQKRPwWtl
         Srg7NUosBsScTvAQlbK6UxfqIljirf/3PsUBczPdWcVz+zlyT7a6svpHVXn6/qiyvoGd
         hVFIn9pvor0k1Q6LJo9db4CBkp9Qmrzz9fSFcOamoGlQ3/5VYdEzp/DB6s4Gyb4Wgc4R
         tuiHKqE90kBCx6k4YzC49iDOFfarQnJXnFgOHKB6RxeqiTQBB+zC4iG9uthhkfDfI/eM
         BRrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:cc:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=wAjKS1vt9FTQkfUmOoQMRGLzVP3/rY0bv0rum+XWJAo=;
        b=WASXxiDpi9pvIhzwxVu2ZvOlCZGMPhontslAx/07LedJC/sMPzQzNio6etT/Z2UVi4
         6Jxc7106PNZfDBYXRi33tVnPGkVpx3DLttbth+NzZ4LdY8HV7MD4G/uu8oNSg7ojN10m
         hop2EzdXnbpXXJb+JF5ZOF98q0KGAM8igDQcvAImA/UoLj5VEgizdDT+zMLx9hl2G/MN
         nlK4ffz0TRjCx0ZqhyMI/MhScKnZv3u0MPVkThc8DiTMJREaBTBvG3pXOPXVuGOidrqF
         x/Jwws0MZzY7A18kMy75MG+i25TkGErs6G1L+fepSeMumXo7Ks+hS6o/Wal+OKmyg6lC
         q5wg==
X-Gm-Message-State: AOAM532LS+4RFC7RD/n3nkT3YKaQnvF4qzO6tpmkQWqfyisPYnRVJpns
        ZCoFSSDSYbuwAvi50tuPaPu3WfS6goYoqw==
X-Google-Smtp-Source: ABdhPJxehdYnEPxD8UKpWSn/jCzcXiDCZpZRVRd4z+CBHYH1wCxlcZftnlct7RfA+pxfJ9gGHHxF7A==
X-Received: by 2002:adf:8287:: with SMTP id 7mr12254430wrc.360.1629015983905;
        Sun, 15 Aug 2021 01:26:23 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f10:c200:9c51:2de3:1074:2bd7? (p200300ea8f10c2009c512de310742bd7.dip0.t-ipconnect.de. [2003:ea:8f10:c200:9c51:2de3:1074:2bd7])
        by smtp.googlemail.com with ESMTPSA id t14sm7090954wmj.2.2021.08.15.01.26.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 15 Aug 2021 01:26:23 -0700 (PDT)
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH resend net-next] r8169: rename rtl_csi_access_enable to
 rtl_set_aspm_entry_latency
To:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Message-ID: <1b34d82a-534f-f736-e54f-6814b0ff7112@gmail.com>
Date:   Sun, 15 Aug 2021 10:26:18 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Rename the function to reflect what it's doing. Also add a description
of the register values as kindly provided by Realtek.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 2c643ec36..7a69b4685 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -2598,7 +2598,7 @@ static u32 rtl_csi_read(struct rtl8169_private *tp, int addr)
 		RTL_R32(tp, CSIDR) : ~0;
 }
 
-static void rtl_csi_access_enable(struct rtl8169_private *tp, u8 val)
+static void rtl_set_aspm_entry_latency(struct rtl8169_private *tp, u8 val)
 {
 	struct pci_dev *pdev = tp->pci_dev;
 	u32 csi;
@@ -2606,6 +2606,8 @@ static void rtl_csi_access_enable(struct rtl8169_private *tp, u8 val)
 	/* According to Realtek the value at config space address 0x070f
 	 * controls the L0s/L1 entrance latency. We try standard ECAM access
 	 * first and if it fails fall back to CSI.
+	 * bit 0..2: L0: 0 = 1us, 1 = 2us .. 6 = 7us, 7 = 7us (no typo)
+	 * bit 3..5: L1: 0 = 1us, 1 = 2us .. 6 = 64us, 7 = 64us
 	 */
 	if (pdev->cfg_size > 0x070f &&
 	    pci_write_config_byte(pdev, 0x070f, val) == PCIBIOS_SUCCESSFUL)
@@ -2619,7 +2621,8 @@ static void rtl_csi_access_enable(struct rtl8169_private *tp, u8 val)
 
 static void rtl_set_def_aspm_entry_latency(struct rtl8169_private *tp)
 {
-	rtl_csi_access_enable(tp, 0x27);
+	/* L0 7us, L1 16us */
+	rtl_set_aspm_entry_latency(tp, 0x27);
 }
 
 struct ephy_info {
@@ -3502,8 +3505,8 @@ static void rtl_hw_start_8106(struct rtl8169_private *tp)
 	RTL_W8(tp, MCU, RTL_R8(tp, MCU) | EN_NDP | EN_OOB_RESET);
 	RTL_W8(tp, DLLPR, RTL_R8(tp, DLLPR) & ~PFM_EN);
 
-	/* The default value is 0x13. Change it to 0x2f */
-	rtl_csi_access_enable(tp, 0x2f);
+	/* L0 7us, L1 32us - needed to avoid issues with link-up detection */
+	rtl_set_aspm_entry_latency(tp, 0x2f);
 
 	rtl_eri_write(tp, 0x1d0, ERIAR_MASK_0011, 0x0000);
 
-- 
2.32.0

