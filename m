Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 319E22F8E06
	for <lists+netdev@lfdr.de>; Sat, 16 Jan 2021 18:16:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728895AbhAPRNQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Jan 2021 12:13:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728390AbhAPRKo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 Jan 2021 12:10:44 -0500
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD144C06179F
        for <netdev@vger.kernel.org>; Sat, 16 Jan 2021 05:45:32 -0800 (PST)
Received: by mail-wr1-x42a.google.com with SMTP id a9so8569670wrt.5
        for <netdev@vger.kernel.org>; Sat, 16 Jan 2021 05:45:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=1zwgk9KjEr1hoio/pIKFu2r3UeQqskDclSUtmb+BJE0=;
        b=pT+YYFmxxQCvqijAFNBepGofwqtpVcAG2XpBENQYGE5R2eHGKCLcnWjU/VR2PUFpAF
         n3MNMQ1hUqdpDODIR961uL0ufWEhKCAbC6E/eY9fR8g1YGYUiPT9H7GVOLQNt1PLww91
         2USkMTl2p35UU3PxvFJ/MEz01A7AAWC8nLKaXYyGoJdRGaVE2n/muKZtpHU81UMSPccX
         /i8I3pNqge6sG6QPc5EkuQfuTe2n+7jcusRjGJD+BAuB+pVEmm3MJ/Jy42S+GKUsJcv/
         IQN35J+92+5zrHMlSDBurJb31EK7wG3xipB9x5/F4ewVXCjEOc+RdV53+BVWJZVN0Mex
         7YTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=1zwgk9KjEr1hoio/pIKFu2r3UeQqskDclSUtmb+BJE0=;
        b=pwViW4bM5t5AHx/VyHZzubRiBk9+QterY0mdJvfpT/iRZHm/uWvW8Aaeg6R21rulsQ
         bGEm+epxALqvcv7Dg2KJTGfslUmOgybez8p4aAZfvDrUE0zOA+cs522FkBx8Wfm+cMpv
         chhaXQePOCfkr2Gcs5hWLoPJ3TZKHmFOylM3EDdq62YSJxJAnPguo4vh6vsRzJ0F9xvV
         KbeaYZv8+6B0MRjqX9TrMl4NBfx0qYvv0Lrvs8KHJIf6nlXjG3EUgex1Oqv69f6HV74s
         w6EnLaC7HQPTW1rtjOKqO/olw+V0RoC37X+64W02F36XhJ3j8F55Q2LYUci1mh1Z9aUe
         vC4A==
X-Gm-Message-State: AOAM532SYLqtEgnu5wxirygPwH1tHZEmg5QCbDEBe6wK0H2kcAHYSTgI
        8ahje+GHNNVraMOpk0+uniFK06V8pUI=
X-Google-Smtp-Source: ABdhPJzjfHLZ6+48mGb0KtotHv9pe1ITOS/fuo5SvczuqKEOcDkpQS/KOC5llMqFEGb67xkniKA/rg==
X-Received: by 2002:adf:e60f:: with SMTP id p15mr17808143wrm.60.1610804731331;
        Sat, 16 Jan 2021 05:45:31 -0800 (PST)
Received: from ?IPv6:2003:ea:8f06:5500:5d83:6110:837c:5dcc? (p200300ea8f0655005d836110837c5dcc.dip0.t-ipconnect.de. [2003:ea:8f06:5500:5d83:6110:837c:5dcc])
        by smtp.googlemail.com with ESMTPSA id c18sm34479218wmk.0.2021.01.16.05.45.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 16 Jan 2021 05:45:30 -0800 (PST)
To:     Raju Rangoju <rajur@chelsio.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH net-next] cxgb4: remove bogus CHELSIO_VPD_UNIQUE_ID constant
Message-ID: <25339251-513a-75c6-e96e-c284d23eed0f@gmail.com>
Date:   Sat, 16 Jan 2021 14:45:25 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The comment is quite weird, there is no such thing as a vendor-specific
VPD id. 0x82 is the value of PCI_VPD_LRDT_ID_STRING. So what we are
doing here is simply checking whether the byte at VPD address VPD_BASE
is a valid string LRDT, same as what is done a few lines later in
the code.
LRDT = Large Resource Data Tag, see PCI 2.2 spec, VPD chapter

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/chelsio/cxgb4/t4_hw.c | 16 +++++-----------
 1 file changed, 5 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb4/t4_hw.c b/drivers/net/ethernet/chelsio/cxgb4/t4_hw.c
index 2c80371f9..48f20a6a0 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/t4_hw.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/t4_hw.c
@@ -2689,7 +2689,6 @@ void t4_get_regs(struct adapter *adap, void *buf, size_t buf_size)
 #define VPD_BASE           0x400
 #define VPD_BASE_OLD       0
 #define VPD_LEN            1024
-#define CHELSIO_VPD_UNIQUE_ID 0x82
 
 /**
  * t4_eeprom_ptov - translate a physical EEPROM address to virtual
@@ -2743,9 +2742,9 @@ int t4_seeprom_wp(struct adapter *adapter, bool enable)
  */
 int t4_get_raw_vpd_params(struct adapter *adapter, struct vpd_params *p)
 {
-	int i, ret = 0, addr;
+	int i, ret = 0, addr = VPD_BASE;
 	int ec, sn, pn, na;
-	u8 *vpd, csum;
+	u8 *vpd, csum, base_val = 0;
 	unsigned int vpdr_len, kw_offset, id_len;
 
 	vpd = vmalloc(VPD_LEN);
@@ -2755,17 +2754,12 @@ int t4_get_raw_vpd_params(struct adapter *adapter, struct vpd_params *p)
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
+	if (base_val != PCI_VPD_LRDT_ID_STRING)
+		addr = VPD_BASE_OLD;
 
 	ret = pci_read_vpd(adapter->pdev, addr, VPD_LEN, vpd);
 	if (ret < 0)
-- 
2.30.0

