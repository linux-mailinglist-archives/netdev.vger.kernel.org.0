Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95F5F311555
	for <lists+netdev@lfdr.de>; Fri,  5 Feb 2021 23:32:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232748AbhBEW2l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Feb 2021 17:28:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231672AbhBEOVV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Feb 2021 09:21:21 -0500
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1125C061797;
        Fri,  5 Feb 2021 07:59:06 -0800 (PST)
Received: by mail-ed1-x52a.google.com with SMTP id y18so9287969edw.13;
        Fri, 05 Feb 2021 07:59:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=pl9PtiuMxl0Wa0UufjsEq2pee41iNKdi+j7uGSkuBlY=;
        b=ifXVpwXtvtBs/eY+e1RftosFX11LP0QgXLOAecM6RjNtp1MBBYfe6a8sGTnuqdGieD
         juOScMbSeZLQXpxrGmerKmCHw5Yxz5R463SwpcFnLdBUYk/Dbp2BBV+UqipuOVIWEjmc
         ex7dVgjYVCXS+My4kk1vGAhNGKmVJo2AqiFnskJRz7f0CPTKZ4Ryo3HUhsWI6gfrKcZk
         u83byyBo+QfqQdX9gcFSpExUFWWVBSX1qGmDUDfIfttdqTFRuuyumX8SPP2Bzvj7Mlmu
         5oncJjPirvf/h2CpokF8aU6yg1VrtZD/BM/JePBDSBBHowMzYdxH2k949bHlVrLMgrbw
         URGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=pl9PtiuMxl0Wa0UufjsEq2pee41iNKdi+j7uGSkuBlY=;
        b=eJoh3iYrODUxRZssg+oFB4yCxP7qLvGeOY0GW3TiyGGWVKOzBzk4IvXTevt5FMkMJ0
         m0KbPUXVX9mMbBcD09lT5Ub55pkMp6Q8AnIP1Xo8t1u5nx/Ay7vvOx1/p1RtnbEH90ld
         w66Z9fkwyEvfhIWHzNN1vi55Vc57Yn3Yzboj09HW2MJfRbRVdeBHKvKEYDHwMSkR8a2y
         re+IWJiKIt81ihDQG6Nmr3yE5lNO3pgyHTyKPiYT/qzonoLD1O6OzFH2BvDIBhEQeDDp
         ++cN4OlFeltouvhuPiVVgC7ybMv/Th6PqM0tBvb7FmhTE8sZ0qjQW4nn3PewaDQIzbaC
         v2GQ==
X-Gm-Message-State: AOAM533eSScaLiXrRXQuD5aTvBFjuJPlYlPIHLfpsJWfqVaGjWO0wdIU
        f0xJqcFNKXc2RPlemhE+Izk+8IFXx16uuA==
X-Google-Smtp-Source: ABdhPJwCCFXDZDrN4miU79NjOF7WAm1zKAMS0y2CG9OU6uhlmWNyiyQCgzq1BZAYb0iOFvxskCIJxg==
X-Received: by 2002:adf:ef03:: with SMTP id e3mr5519833wro.98.1612535136318;
        Fri, 05 Feb 2021 06:25:36 -0800 (PST)
Received: from ?IPv6:2003:ea:8f1f:ad00:9118:8653:7e7:879e? (p200300ea8f1fad009118865307e7879e.dip0.t-ipconnect.de. [2003:ea:8f1f:ad00:9118:8653:7e7:879e])
        by smtp.googlemail.com with ESMTPSA id 36sm13069342wrj.97.2021.02.05.06.25.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 05 Feb 2021 06:25:35 -0800 (PST)
Subject: [PATCH net-next v2 1/3] cxgb4: remove unused vpd_cap_addr
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Raju Rangoju <rajur@chelsio.com>, Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Bjorn Helgaas <bhelgaas@google.com>
Cc:     "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <8edfa4ae-1e78-249d-14fb-0e44a2c51864@gmail.com>
Message-ID: <e3eed002-7a86-1336-4530-c1b6ab5261bd@gmail.com>
Date:   Fri, 5 Feb 2021 15:25:33 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <8edfa4ae-1e78-249d-14fb-0e44a2c51864@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Supposedly this is a leftover from T3 driver heritage. cxgb4 uses the
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


