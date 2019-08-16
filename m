Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2060B90912
	for <lists+netdev@lfdr.de>; Fri, 16 Aug 2019 21:57:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727577AbfHPT5q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Aug 2019 15:57:46 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:41941 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727548AbfHPT5q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Aug 2019 15:57:46 -0400
Received: by mail-wr1-f65.google.com with SMTP id j16so2606884wrr.8
        for <netdev@vger.kernel.org>; Fri, 16 Aug 2019 12:57:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=AEb2g9RDPllvEovcK65M0ILnvPGzBPuSPDAE1ig18ZQ=;
        b=c/veGNmEyerCTpA8k7bDJm+TJ1xgiT+8D2/J0HK8bgCzWZyg0EiGKVMWknBWlYShRv
         FJiv1dHiuMgaS9iO83+6XcaUv4ODqRAWteFH/OYxQY7oOzE59fiGdcAnE8Z8e/25s+2I
         FRHZHFcSV4kOBwL4igsRDRFmkWkTp47VFWv7OH1xHDxS52hkWEXQ4d98yQnHygvoaqJD
         m5BWmZiZxcy3ISCJrTauTURbIsq2xFBt3kBJeUevmCrlvwnR6P017IPjySApMrZ1WlEQ
         rHzjq8hee3lYaFg3e9aVpEAarGGpI6b9zrgOHfTFRvSEucP85TVPw3fOVv/+h56ouS/k
         i5Dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=AEb2g9RDPllvEovcK65M0ILnvPGzBPuSPDAE1ig18ZQ=;
        b=jfZOx1gJaD5v56QPI4lVAOEgr9Zz3UEmDsxmckssA+8V9SRoSBPtaV6M/k5vfFn0kI
         4f8hp1+eTgzSQSO2wOv3Z+KTrSb8akLfD648MOlWU0V5yuHeuUm9Fekos0Rjrjt3GzuI
         6ndOhbKF6BuzFZtMdM4MSRX9EBOuoczVVn8Ljn/WOMVeOSBleC0Xq2YNo524QROPk1vF
         NZA7V2Qbfns3KaB9ti7p7nCrMcTDAcgG6ArzNHj1Zu/SEfC84u6ErlcuErx0k7HsILSM
         Rdv8/2mhjg2aRyzO7hheueMR2rP8B0Sy7f2A5WwCCM2TmlG8P0QAQ+nu5CN/IUqdwpDo
         xq9g==
X-Gm-Message-State: APjAAAWMWXLGCO5P2v3VvDIOo/lEhK9kwJ0dkKGEBm6oqtDPctmdaoJf
        57LojurIPdb6CV0zHZ2UJBXFFZjg
X-Google-Smtp-Source: APXvYqyYvfmpRcbDlTTfZ0FlnYWdkL9m93dwoC3BJTkRgTT2Z6VmkOtS36M+KkuoVWcj5sixOQ4gyA==
X-Received: by 2002:adf:c7c7:: with SMTP id y7mr12512821wrg.44.1565985464230;
        Fri, 16 Aug 2019 12:57:44 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f2f:3200:4112:e131:7f21:ec09? (p200300EA8F2F32004112E1317F21EC09.dip0.t-ipconnect.de. [2003:ea:8f2f:3200:4112:e131:7f21:ec09])
        by smtp.googlemail.com with ESMTPSA id a84sm7951484wmf.29.2019.08.16.12.57.43
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 16 Aug 2019 12:57:43 -0700 (PDT)
Subject: [PATCH net-next 1/2] net: phy: add EEE-related constants
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <d2669c95-9861-df53-2e37-6ebfde11c4c9@gmail.com>
Message-ID: <45dc22c9-8da3-2540-25bf-6ca1603ce671@gmail.com>
Date:   Fri, 16 Aug 2019 21:56:27 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <d2669c95-9861-df53-2e37-6ebfde11c4c9@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add EEE-related constants. This includes the new MMD EEE registers for
NBase-T / 802.3bz.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 include/uapi/linux/mdio.h | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/include/uapi/linux/mdio.h b/include/uapi/linux/mdio.h
index 0a552061f..4bcb41c71 100644
--- a/include/uapi/linux/mdio.h
+++ b/include/uapi/linux/mdio.h
@@ -45,11 +45,14 @@
 #define MDIO_AN_ADVERTISE	16	/* AN advertising (base page) */
 #define MDIO_AN_LPA		19	/* AN LP abilities (base page) */
 #define MDIO_PCS_EEE_ABLE	20	/* EEE Capability register */
+#define MDIO_PCS_EEE_ABLE2	21	/* EEE Capability register 2 */
 #define MDIO_PMA_NG_EXTABLE	21	/* 2.5G/5G PMA/PMD extended ability */
 #define MDIO_PCS_EEE_WK_ERR	22	/* EEE wake error counter */
 #define MDIO_PHYXS_LNSTAT	24	/* PHY XGXS lane state */
 #define MDIO_AN_EEE_ADV		60	/* EEE advertisement */
 #define MDIO_AN_EEE_LPABLE	61	/* EEE link partner ability */
+#define MDIO_AN_EEE_ADV2	62	/* EEE advertisement 2 */
+#define MDIO_AN_EEE_LPABLE2	63	/* EEE link partner ability 2 */
 
 /* Media-dependent registers. */
 #define MDIO_PMA_10GBT_SWAPPOL	130	/* 10GBASE-T pair swap & polarity */
@@ -276,6 +279,13 @@
 #define MDIO_EEE_1000KX		0x0010	/* 1000KX EEE cap */
 #define MDIO_EEE_10GKX4		0x0020	/* 10G KX4 EEE cap */
 #define MDIO_EEE_10GKR		0x0040	/* 10G KR EEE cap */
+#define MDIO_EEE_40GR_FW	0x0100	/* 40G R fast wake */
+#define MDIO_EEE_40GR_DS	0x0200	/* 40G R deep sleep */
+#define MDIO_EEE_100GR_FW	0x1000	/* 100G R fast wake */
+#define MDIO_EEE_100GR_DS	0x2000	/* 100G R deep sleep */
+
+#define MDIO_EEE_2_5GT		0x0001	/* 2.5GT EEE cap */
+#define MDIO_EEE_5GT		0x0002	/* 5GT EEE cap */
 
 /* 2.5G/5G Extended abilities register. */
 #define MDIO_PMA_NG_EXTABLE_2_5GBT	0x0001	/* 2.5GBASET ability */
-- 
2.22.1


