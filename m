Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06A2430CD33
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 21:43:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232964AbhBBUk5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 15:40:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232223AbhBBUku (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Feb 2021 15:40:50 -0500
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5642BC06174A;
        Tue,  2 Feb 2021 12:40:10 -0800 (PST)
Received: by mail-wm1-x330.google.com with SMTP id f16so3639407wmq.5;
        Tue, 02 Feb 2021 12:40:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=qbvG1/4AK/H5qBhZoBN+xgCAiYBIeTeEr9eZF1c6zWg=;
        b=YV/cKDH4aEhl1g3iXkwK5cZuBr+bQ5s+IWFv6/g0n9+E5/28BimmXFisB4ooh4wzN2
         Ae5eFqhgX9NO8vZDv4x5Vf/xn5GhtwteCbG9yWrWfgQ8HWUtrfxXQVpzhKqkSPOtyU7n
         Tg60WjY239bNTjcrhuWBFglphDKJAHGWbhw/tdH6ZZadCj2wNEvsNWIGmesX85Nt2U8Z
         SPvkoYFbD+e1/r90qvm7HT14jRWmxjmry1sHwhn8KjwMlxAg3uHHwLZps8XS72KnJknP
         NKoUfyLg9+hNnxfRBUn9PXENn8G/q5dOxWpbwM3cnbgWLx8klAW3KYIIVGd7q1TFTWak
         hIYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=qbvG1/4AK/H5qBhZoBN+xgCAiYBIeTeEr9eZF1c6zWg=;
        b=bgXcaAVwRQ2IkooK+/auX+AeW8E1zDFpmjP4/018OdAOHr4KWqP/Jb3gxDYoZwUBKt
         g0RjnyGvT7Zt9p8yOG/Jn3FYCBJGubSsnNFIf5Ii8ofCw6ioI3a6dIT9jXXYhAmT56FL
         hdkE+eqZlfrwnJAvAah796r5UUtXmSkdgWVwSOqM8jr849UlDw95vod6sdwOpgNwkO4I
         OvoBXsPvSoyQ6hLIgBij+vUZpOAw6dQkiFBTzpzL6ddUqKBt8O5DEr3SjuBRZEY4MT8A
         Ns/0gHOc+G8t9Ex244D0rx4hXxHIEeEQ0ovKD60OIjDPnJJ26WtuTginY9RiVcd7gFg2
         hjXA==
X-Gm-Message-State: AOAM530jvx9BE1/tFwhpjFC1haPaFrkW7zqNCI+8A5evoM7ipEloTxMn
        RR/UwEjPFntUcztrGAx4WDG2/6LWfWg=
X-Google-Smtp-Source: ABdhPJyvWJYIp3jVW12fLvgFwZ7xaSWFVX3MmrIK4+jPc2QmMabau6IvZCs3aPi0b2iWQgV+gd2YKg==
X-Received: by 2002:a1c:40d4:: with SMTP id n203mr5188782wma.46.1612298408872;
        Tue, 02 Feb 2021 12:40:08 -0800 (PST)
Received: from ?IPv6:2003:ea:8f1f:ad00:e887:ce1a:5d1d:a96e? (p200300ea8f1fad00e887ce1a5d1da96e.dip0.t-ipconnect.de. [2003:ea:8f1f:ad00:e887:ce1a:5d1d:a96e])
        by smtp.googlemail.com with ESMTPSA id m24sm3809900wmi.24.2021.02.02.12.40.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 Feb 2021 12:40:08 -0800 (PST)
Subject: [PATCH net-next 2/4] cxgb4: remove unused vpd_cap_addr
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Raju Rangoju <rajur@chelsio.com>, Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Bjorn Helgaas <bhelgaas@google.com>
Cc:     "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <b07dc99d-7fd0-48c0-3fc4-89cda90ee5d7@gmail.com>
Message-ID: <19159db1-abe9-d265-c4f7-7e8db75ee5e5@gmail.com>
Date:   Tue, 2 Feb 2021 21:37:35 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <b07dc99d-7fd0-48c0-3fc4-89cda90ee5d7@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Presumably this is a leftover from T3 driver heritage. cxgb4 uses the
PCI core VPD access code that handles detection of VPD capabilities.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/chelsio/cxgb4/cxgb4.h      | 1 -
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c | 2 --
 2 files changed, 3 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4.h b/drivers/net/ethernet/chelsio/cxgb4/cxgb4.h
index 8e681ce72..314f8d806 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4.h
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4.h
@@ -414,7 +414,6 @@ struct pf_resources {
 };
 
 struct pci_params {
-	unsigned int vpd_cap_addr;
 	unsigned char speed;
 	unsigned char width;
 };
diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
index 9f1965c80..6264bc66a 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
@@ -3201,8 +3201,6 @@ static void cxgb4_mgmt_fill_vf_station_mac_addr(struct adapter *adap)
 	int err;
 	u8 *na;
 
-	adap->params.pci.vpd_cap_addr = pci_find_capability(adap->pdev,
-							    PCI_CAP_ID_VPD);
 	err = t4_get_raw_vpd_params(adap, &adap->params.vpd);
 	if (err)
 		return;
-- 
2.30.0


