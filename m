Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D400B285A2
	for <lists+netdev@lfdr.de>; Thu, 23 May 2019 20:09:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731278AbfEWSJY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 May 2019 14:09:24 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:56293 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731117AbfEWSJY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 May 2019 14:09:24 -0400
Received: by mail-wm1-f67.google.com with SMTP id x64so6789626wmb.5;
        Thu, 23 May 2019 11:09:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=sOizVTvn298iqjSRIp3glGwvPvP9G7hNhxiAnwHpvqc=;
        b=HT6PtgZ6wal7rH84TWBdE51xCeto45OrsGyFFDtrbFmNmcgEAA1B2EBwKF8VC5xOkb
         7uOUIKrnz9F1TSPHPVm5QQqW2woKrLheB47BUr/1eTGeohIB70SxmuuNFulA3gxrsl8F
         GYqzNO/3OiY/ilaAScYRcCRDuw9JURz/VR1IsMDW3t89JD/s2OqB5WUFuHi9M9n4ZLnh
         MYP1IPRAnvHuqovoQvzUHmqL0uHWn+m49qPR5c/9ErFB7lSnl2HHv8fYOTVRp6BkMVeK
         x71H1lKbrLZn8i8wOG2nTEZ/K9R+Em39arssLJ9d2Q8Na99qY74T3P32gWd7OXR2PzNi
         Z0cQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=sOizVTvn298iqjSRIp3glGwvPvP9G7hNhxiAnwHpvqc=;
        b=cNaT9tE2lUpuWUBO2oInRFzZpSs9rMUlZZpFAP8YOjEoF10aHy3FKAF82xIkxMdgnT
         WSeUG2faaJgswHxzcd8p7gK9UvPsKkYyConUWTo6dCSMdbqBQTq8SvEYQDlv+c9goLQM
         tyBiGVU/aq6Xa/7cbkLhIJGnLb5ppTrCEuU/hYxIAe8+sMXSL0rtiSfef8yTZ3CdwL30
         87ye4/xenpHpe/KNkpHTBZ+8uwQ9LuwuOqBYogdiaa7lgPQBlWit5Zt8qh5y5AMgIos2
         rEJArqplGXdt1hQ+6Fw3NqZTIR9mP3ONcnnpN9kIqZqJZJpRifS42au8fzQn/8+1/gY4
         tdaw==
X-Gm-Message-State: APjAAAWFkfcsLKNIA14bhGsEmQfhf19oE3yT+8mTXQeDBRscyvqCaHSl
        u6N1abdQhaFa2j3Yp0/uZ7DIM4LC
X-Google-Smtp-Source: APXvYqy147/NpI75h/2GI1OtYxZdgY6B6QxWwtQHLXxbCBDNL5Qo9H3CMyCRV+mfMbejpfCFouvBpA==
X-Received: by 2002:a1c:7dcf:: with SMTP id y198mr12219750wmc.94.1558634961344;
        Thu, 23 May 2019 11:09:21 -0700 (PDT)
Received: from ?IPv6:2003:ea:8be9:7a00:3cd1:e8fe:d810:b3f0? (p200300EA8BE97A003CD1E8FED810B3F0.dip0.t-ipconnect.de. [2003:ea:8be9:7a00:3cd1:e8fe:d810:b3f0])
        by smtp.googlemail.com with ESMTPSA id y10sm451116wmg.8.2019.05.23.11.09.20
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 23 May 2019 11:09:20 -0700 (PDT)
Subject: [PATCH net-next v2 1/3] net: phy: add interface mode
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
References: <9d284f4d-93ee-fb27-e386-80825f92adc8@gmail.com>
Message-ID: <10f0f749-ec92-2ec6-45bf-a4f40163a19a@gmail.com>
Date:   Thu, 23 May 2019 20:06:49 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <9d284f4d-93ee-fb27-e386-80825f92adc8@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for interface mode PHY_INTERFACE_MODE_USXGMII.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
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


