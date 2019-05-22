Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B79AC26FBD
	for <lists+netdev@lfdr.de>; Wed, 22 May 2019 21:59:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730708AbfEVT6l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 May 2019 15:58:41 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:56123 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729565AbfEVT6j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 May 2019 15:58:39 -0400
Received: by mail-wm1-f67.google.com with SMTP id x64so3427869wmb.5;
        Wed, 22 May 2019 12:58:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=C4CpDQKXaTSWK266x4L54FFna7lnQA4Dh6pv535OwUk=;
        b=Ww/IA8ZeGY3Q177k7ssd5U53pRIf6TWG2NUBdLTxG8RRTY8aYyrz5zTyda4l2X92oH
         lr9JQg3pRSEIUvGgXYYy8y4yUsjjPxQIsNoIjcxR6+TJdfjjCs3soco11VajMuRrb1DX
         LyfwMXPPLlB/33YrKko2Kgw5rZec1ZAdCwZK35WgT91iyeHqSoK2zs3Smc+TAyDRN9kX
         1fMICw3s87isNGyQXlwllYSiYlZUg3/dAziaK3ki7jebjXIgqSQ0QytwfRUBx6b0TOlo
         NHg9RoROjuhsa5RNs6v3ygvFcFm1wFlZ3D/cIwAMFykh9n4HsqLgXRxjomEPNWEI67ho
         gyxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=C4CpDQKXaTSWK266x4L54FFna7lnQA4Dh6pv535OwUk=;
        b=aNjZpi/3mQK7iQp1IRbY9nuEzFnUJYSIFTNMCHLQKdDyL16VgTo1chWZgZudddMf/4
         z1lKdxeDSlHsv4u89uDNESNDiEtAOsosVDwUNexpzi+XILXybfDe9HstrurwB9lgm7C6
         286eiBmbdvA3s4VWRL3D5m6s/scmXOYSXAwnV2gsr2vGZLVXOvltMInVj03TJA2GHIYJ
         v8uApees5cijGv+M/tx+pvcQ/YBMYh+eIFJdZgXL6UReC+O9uQP6ZawLh2CFxShFz83Q
         D5VnT79unfysA8RxEhkVoLyh7KRoZw0Bp8dPcxdz61tydh6iWebiDsX9nqBb6mawi8RB
         Lzfw==
X-Gm-Message-State: APjAAAVPMg0/3AnRc/W464wSOzExOG62CJAcFJPHAvbLnT4UlRn5jVAi
        hL0siN8mHiS5VcnB/F1gJHHOfrsE
X-Google-Smtp-Source: APXvYqxGmLfjW4idvI28Xtos3cDOqZEsrTIjciSA10Zil7RN3IqnHOyBgzku7F2zTiraeYs0HyEhkw==
X-Received: by 2002:a1c:6783:: with SMTP id b125mr8715351wmc.41.1558555117740;
        Wed, 22 May 2019 12:58:37 -0700 (PDT)
Received: from ?IPv6:2003:ea:8bd4:5700:3029:8954:1431:dc1e? (p200300EA8BD45700302989541431DC1E.dip0.t-ipconnect.de. [2003:ea:8bd4:5700:3029:8954:1431:dc1e])
        by smtp.googlemail.com with ESMTPSA id y132sm12021821wmd.35.2019.05.22.12.58.36
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 22 May 2019 12:58:37 -0700 (PDT)
Subject: [PATCH net-next 1/2] net: phy: add interface mode
 PHY_INTERFACE_MODE_USXGMII
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Madalin-cristian Bucur <madalin.bucur@nxp.com>,
        Shawn Guo <shawnguo@kernel.org>, Li Yang <leoyang.li@nxp.com>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
References: <110a1e45-56a7-a646-7b63-f39fe3083c28@gmail.com>
Message-ID: <aca070f6-f56b-1b1f-180a-ddf52af91ecb@gmail.com>
Date:   Wed, 22 May 2019 21:57:16 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <110a1e45-56a7-a646-7b63-f39fe3083c28@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for interface mode PHY_INTERFACE_MODE_USXGMII.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 include/linux/phy.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/include/linux/phy.h b/include/linux/phy.h
index 073fb151b..7180b1d1e 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -103,6 +103,7 @@ typedef enum {
 	PHY_INTERFACE_MODE_XAUI,
 	/* 10GBASE-KR, XFI, SFI - single lane 10G Serdes */
 	PHY_INTERFACE_MODE_10GKR,
+	PHY_INTERFACE_MODE_USXGMII,
 	PHY_INTERFACE_MODE_MAX,
 } phy_interface_t;
 
@@ -178,6 +179,8 @@ static inline const char *phy_modes(phy_interface_t interface)
 		return "xaui";
 	case PHY_INTERFACE_MODE_10GKR:
 		return "10gbase-kr";
+	case PHY_INTERFACE_MODE_USXGMII:
+		return "usxgmii";
 	default:
 		return "unknown";
 	}
-- 
2.21.0


