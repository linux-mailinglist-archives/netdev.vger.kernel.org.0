Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08FA92FCB7E
	for <lists+netdev@lfdr.de>; Wed, 20 Jan 2021 08:28:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728625AbhATH2Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jan 2021 02:28:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728554AbhATH2F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jan 2021 02:28:05 -0500
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45990C061575
        for <netdev@vger.kernel.org>; Tue, 19 Jan 2021 23:27:23 -0800 (PST)
Received: by mail-ej1-x633.google.com with SMTP id r12so20745044ejb.9
        for <netdev@vger.kernel.org>; Tue, 19 Jan 2021 23:27:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:subject:to:cc:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=LYqnuN/urQ7jIZN8Hhj7PzfLScFqo8gZlQTv03pVGe4=;
        b=H3x/RwxnMfGNtD5/nvFQlLaqWZMbGsWE2zdZPnPjWA6CPCYo/RfK98Om/L3AtZn2dY
         hmApRiCjVNcnneS3TcWWhVdhzxAcvcOdutNZ7jTS9uFX8I/p2/xgP+sM/Mi6ETBfn4nn
         hcxtu5ZBUwaXOIVVicpWTLOt9awlJFXYzf1WP+wp5aG5cIyJovk7G8n5tR6PzvmbXhNT
         pp9B53HOR+LRWdg2RVME5XMJGHOL75/CZzuNQIBm6AVv/kZuSsSSQh7lTANStWV836a/
         DAsF+Vwt2aIxFGIeOBcraAPLt5ravBygh/Awcv3BaZq1BXvhCYvhC8omzhFjjWGu5jJA
         Xzzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:cc:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=LYqnuN/urQ7jIZN8Hhj7PzfLScFqo8gZlQTv03pVGe4=;
        b=O7AdXyH38N1ollORUISr8Y/B1uZ4mTEVPl0XfJf6Fp/Ezhzw8AflTcmNlcZfXBmm8L
         Pn/A0tOFzoSyHr9iHkJ/kr8wR/zOvmwveU6ttJdIzF7MlyFQRlI4PV68C9FhlK2Ei6Q8
         Lau9iVn6FIT6RSgZzgjoM2fCtiQ0PiJmPoiaC8QtdAovZewP9ovXUxe0sEM9FkQI2Hth
         Y+VnqjArdsnSoEL8lOuze6RxCbRDh8qKkhydXS0AL/gcbn6iL0EevhhNNJub9pNyeD20
         8fif37K4DPfhp1JYebigcLn7iAFdT4KqXDUPJnFd5KjNLOgmiozjDZGYhwILxxu4VXaA
         kHhw==
X-Gm-Message-State: AOAM532mx4FciObxfnK7usi4YaJjV/1m2ypZh8k93UrHFMJTC3HxjrIP
        VUNeyTt8JzX6sexj3Y9/2Lx5AyEKPl0=
X-Google-Smtp-Source: ABdhPJwvKNA/LzJwnG8LJWzYQ1nt65nNlY/HDG0xwOFi6g1NeMbBrdJGKG1poeffhzOON3oesiBTzw==
X-Received: by 2002:a17:906:1c0c:: with SMTP id k12mr5487711ejg.354.1611127641796;
        Tue, 19 Jan 2021 23:27:21 -0800 (PST)
Received: from ?IPv6:2003:ea:8f06:5500:a490:e863:b4df:cade? (p200300ea8f065500a490e863b4dfcade.dip0.t-ipconnect.de. [2003:ea:8f06:5500:a490:e863:b4df:cade])
        by smtp.googlemail.com with ESMTPSA id r23sm485142ejd.56.2021.01.19.23.27.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 19 Jan 2021 23:27:21 -0800 (PST)
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH v2 net-next] cxgb4: remove bogus CHELSIO_VPD_UNIQUE_ID
 constant
To:     Raju Rangoju <rajur@chelsio.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Message-ID: <644ef22f-e86a-5cc1-0f27-f873ab165696@gmail.com>
Date:   Wed, 20 Jan 2021 08:27:14 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The comment is quite weird, there is no such thing as a vendor-specific
VPD id. 0x82 is the value of PCI_VPD_LRDT_ID_STRING. So what we are
doing here is simply checking whether the byte at VPD address VPD_BASE
is a valid string LRDT, same as what is done a few lines later in
the code.
LRDT = Large Resource Data Tag, see PCI 2.2 spec, VPD chapter

v2:
- don't set VPD_BASE / VPD_BASE_OLD separately

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/chelsio/cxgb4/t4_hw.c | 13 +++----------
 1 file changed, 3 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb4/t4_hw.c b/drivers/net/ethernet/chelsio/cxgb4/t4_hw.c
index 2c80371f9..ef5d10e1c 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/t4_hw.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/t4_hw.c
@@ -2689,7 +2689,6 @@ void t4_get_regs(struct adapter *adap, void *buf, size_t buf_size)
 #define VPD_BASE           0x400
 #define VPD_BASE_OLD       0
 #define VPD_LEN            1024
-#define CHELSIO_VPD_UNIQUE_ID 0x82
 
 /**
  * t4_eeprom_ptov - translate a physical EEPROM address to virtual
@@ -2745,7 +2744,7 @@ int t4_get_raw_vpd_params(struct adapter *adapter, struct vpd_params *p)
 {
 	int i, ret = 0, addr;
 	int ec, sn, pn, na;
-	u8 *vpd, csum;
+	u8 *vpd, csum, base_val = 0;
 	unsigned int vpdr_len, kw_offset, id_len;
 
 	vpd = vmalloc(VPD_LEN);
@@ -2755,17 +2754,11 @@ int t4_get_raw_vpd_params(struct adapter *adapter, struct vpd_params *p)
 	/* Card information normally starts at VPD_BASE but early cards had
 	 * it at 0.
 	 */
-	ret = pci_read_vpd(adapter->pdev, VPD_BASE, sizeof(u32), vpd);
+	ret = pci_read_vpd(adapter->pdev, VPD_BASE, 1, &base_val);
 	if (ret < 0)
 		goto out;
 
-	/* The VPD shall have a unique identifier specified by the PCI SIG.
-	 * For chelsio adapters, the identifier is 0x82. The first byte of a VPD
-	 * shall be CHELSIO_VPD_UNIQUE_ID (0x82). The VPD programming software
-	 * is expected to automatically put this entry at the
-	 * beginning of the VPD.
-	 */
-	addr = *vpd == CHELSIO_VPD_UNIQUE_ID ? VPD_BASE : VPD_BASE_OLD;
+	addr = base_val == PCI_VPD_LRDT_ID_STRING ? VPD_BASE : VPD_BASE_OLD;
 
 	ret = pci_read_vpd(adapter->pdev, addr, VPD_LEN, vpd);
 	if (ret < 0)
-- 
2.30.0

