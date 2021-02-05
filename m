Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C0C6311149
	for <lists+netdev@lfdr.de>; Fri,  5 Feb 2021 20:36:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233162AbhBERxB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Feb 2021 12:53:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233404AbhBERs6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Feb 2021 12:48:58 -0500
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8187C06174A;
        Fri,  5 Feb 2021 11:30:41 -0800 (PST)
Received: by mail-wr1-x429.google.com with SMTP id l12so8969522wry.2;
        Fri, 05 Feb 2021 11:30:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=pl9PtiuMxl0Wa0UufjsEq2pee41iNKdi+j7uGSkuBlY=;
        b=IfxgEsxRHzDwf0VPajMqdgWOzgKlbswJui641E+CoHCfg8bJaIfTbZmjFTeWHZCtPm
         m7TwRkhEQ2G2hD6FBPtfU7o2Z2A/TOBj9ejDYqOjdYn4w7ZnHAdggIQ93eoRzNxLERY3
         FoKmrfwGvTDhP+bsgW3mZ3oVcO4+qyDSArBCYqMv0q3b4ivz/Wv/yLU1PWAFQc/22RMH
         YeWotIrdN7/Tr7Aufprp0Pa7B64LPjCSe2gWXtMPA/gyMq9v3MIYiwWyJwz6jPKt2JEb
         +8vaRzonDqNwtXalT/np03PLRbbFrpoNeol3SdfvpjlfNOiapDyLGJBo7L5BZ7/9bFWx
         KTvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=pl9PtiuMxl0Wa0UufjsEq2pee41iNKdi+j7uGSkuBlY=;
        b=XDZ5UW+qTvY4cpGYmp7w9M6INUidPrzwBSmnm4wKadAUficujhStJYKhCT6pBKgDnC
         2xVTks1Das6Ibe8tFa3ssMdg0+pT08QIj5NKShIZ8SnoAdMvaetHq1uOuO1Oo3Ts4Z6b
         2qixtd6w75OV4B+qCqXFZ2LX93wcJqP5QrVWMtSY+WEXz520DNWGYJ33WhV/jC0f6eNL
         CF2Cxzy0zStrR2sMTA175K0IiTQzl7ycbjpRhKLO7HkFXKW6LXc5Y768+5X62v9Nktne
         HzMEc1K0QOI4fiIojVvOAsX3RGLOqd4ov97qb4/JG5bZdX9mWEacfhBzKxKnVhzBBHte
         L6Sg==
X-Gm-Message-State: AOAM530zE6o7hDm9oVBnQQjJIFKatIXe9VkJ5/i+23F8hlqN8I4+ITmg
        UVC2yOncK3DzcDRmR7kS3Mv7uzjouiU03w==
X-Google-Smtp-Source: ABdhPJxJMVVa8ALR3exPSd/D48YBzIT0o/Z/rIZPCll7z9zmUWLbHmW87GahTyekq7RqOiLwVl5rMA==
X-Received: by 2002:adf:f8c1:: with SMTP id f1mr6682616wrq.76.1612553440248;
        Fri, 05 Feb 2021 11:30:40 -0800 (PST)
Received: from ?IPv6:2003:ea:8f1f:ad00:11de:46a1:319f:d28? (p200300ea8f1fad0011de46a1319f0d28.dip0.t-ipconnect.de. [2003:ea:8f1f:ad00:11de:46a1:319f:d28])
        by smtp.googlemail.com with ESMTPSA id d13sm12897926wrx.93.2021.02.05.11.30.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 05 Feb 2021 11:30:39 -0800 (PST)
Subject: [PATCH resend net-next v2 1/3] cxgb4: remove unused vpd_cap_addr
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Raju Rangoju <rajur@chelsio.com>, Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Bjorn Helgaas <bhelgaas@google.com>
Cc:     "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <6658af1a-88fc-1389-0126-77201b4af2b3@gmail.com>
Message-ID: <6feeeb18-2b4e-afce-ee25-21738223dced@gmail.com>
Date:   Fri, 5 Feb 2021 20:29:11 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <6658af1a-88fc-1389-0126-77201b4af2b3@gmail.com>
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



