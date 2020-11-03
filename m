Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 380E22A493A
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 16:17:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728397AbgKCPRk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 10:17:40 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:54951 "EHLO
        mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728365AbgKCPQD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Nov 2020 10:16:03 -0500
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
        by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id 20201103151541euoutp021dd5b87535007b4038bf63e11daab9a9~ECFgPYSlJ0580805808euoutp02X
        for <netdev@vger.kernel.org>; Tue,  3 Nov 2020 15:15:41 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com 20201103151541euoutp021dd5b87535007b4038bf63e11daab9a9~ECFgPYSlJ0580805808euoutp02X
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1604416541;
        bh=4fyCws4IJ/FYfmeubIZmsDv7F8YQu+sqPMRSahhjyO0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BxIOFZx6K2hFA9fnrG87m76ukSa+RVt3Q+eRxsDyjPJiSrorESsXPLd/ii4DDcx75
         SmTUaAmvNDgbtPKS0Zb6+YwDies7WqynHzTTVsh3MAUJRH1cHgFgNqFFtB9TelacEr
         5se7ft5gvukeQhfFRwCz08+aHvR5Js3M3wYo6oX4=
Received: from eusmges2new.samsung.com (unknown [203.254.199.244]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTP id
        20201103151541eucas1p1a0b2114127e88bf2b9636170b3edf115~ECFfyOlO22137521375eucas1p15;
        Tue,  3 Nov 2020 15:15:41 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
        eusmges2new.samsung.com (EUCPMTA) with SMTP id A1.0B.05997.C1471AF5; Tue,  3
        Nov 2020 15:15:41 +0000 (GMT)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
        20201103151540eucas1p1be7fe9add1ea297afa95e585be5234ae~ECFfbxJw92137621376eucas1p13;
        Tue,  3 Nov 2020 15:15:40 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
        eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20201103151540eusmtrp1ab5f201f4023b6e086820e898641dd3a~ECFfbCOO03261632616eusmtrp1N;
        Tue,  3 Nov 2020 15:15:40 +0000 (GMT)
X-AuditID: cbfec7f4-677ff7000000176d-a3-5fa1741ceb79
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
        eusmgms1.samsung.com (EUCPMTA) with SMTP id E9.B9.06314.C1471AF5; Tue,  3
        Nov 2020 15:15:40 +0000 (GMT)
Received: from localhost (unknown [106.120.51.46]) by eusmtip2.samsung.com
        (KnoxPortal) with ESMTPA id
        20201103151540eusmtip284d729c2779bf1bcf19f583560feae46~ECFfSBW8l1000810008eusmtip2M;
        Tue,  3 Nov 2020 15:15:40 +0000 (GMT)
From:   =?UTF-8?q?=C5=81ukasz=20Stelmach?= <l.stelmach@samsung.com>
To:     Andrew Lunn <andrew@lunn.ch>, jim.cromie@gmail.com,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Kukjin Kim <kgene@kernel.org>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org
Cc:     =?UTF-8?q?Bart=C5=82omiej=20=C5=BBolnierkiewicz?= 
        <b.zolnierkie@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        =?UTF-8?q?=C5=81ukasz=20Stelmach?= <l.stelmach@samsung.com>
Subject: [PATCH v5 5/5] ARM: defconfig: Enable ax88796c driver
Date:   Tue,  3 Nov 2020 16:15:36 +0100
Message-Id: <20201103151536.26472-6-l.stelmach@samsung.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201103151536.26472-1-l.stelmach@samsung.com>
MIME-Version: 1.0
Organization: Samsung R&D Institute Poland
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA02Sa0hTYRjHeXd2tuNqeZySD2qFw5CEtJv2QiIZRYcI6lNgYDbzeCFv7XjJ
        glxXTWxey3kpl3lLKs3mdKZCc2plOkOYGmqlVmiMIi3TonI7Sn57Lv/n93+el5ciZKOkGxUT
        n8Qq4xWxcpFEqO9e6N+6Ielu2DZdpwCbx4wEfqypJ3GZ+YoQl5v6SVzxRUNii3WUxDmTnwls
        NjeI8YBeTeIRYy3CjZMWEg+2lomwxtwhwMab7Qg/NI2Jcbd2Pb7abhLvdWIGLa8JRnd/RMAY
        SsbETGPddRHzpDKdMbTMChi1rg4xs40bj1LHJYERbGxMCqv0Czopic5+OiBKvOpwtiG3llCh
        X+Is5EABvQuK51VkFpJQMroWwbWHBgGfzCG4NTCE+GQWwcuMUtHKiP7vKyHfqEFQ+V4r4pNP
        CPKtJjtYRAdDTtVzO9iFHiegPuOdnUXQHQgM44VEFqIoZzoIyrLAFgrpzXCnOsQ2K6X3QJG6
        T8i7bYKMmma7swMdCKrCmwJe4wQviqfsGkfaBx5cGrLHxJL+clMpYbMCOo+ChXtmgY0P9H7I
        0fjzTGeY6dEtP4AH9BZkC3lJOhTkB/Cj2Qj0ZT+Xd9gDo/2LIpuGoLdAfasfXw6Gt6bZZfo6
        GLY68Rusg3x9EcGXpZB5TcarveBRTtsy0A1uzNSiXCQvWXVLyar9S/57aRFRh1zZZC4uiuV2
        xLOpvpwijkuOj/I9lRDXiJb+XO+fnrkW1Po73IhoCsnXSvey2jAZqUjh0uKMCChC7iLd19d7
        QiaNUKSdY5UJYcrkWJYzIndKKHeV7qyYDpXRUYok9jTLJrLKla6AcnBTIeUPl2pxgGSi0F16
        yW24+Zjrka8Xv90+yIW79HZRmibr5MWvjl3etxcPvLlwxrOu09PyvflPgKH8w8KhCY+K6cjS
        ltBO1aL4fFF60mHDM8ud1MzOog7HqozYNuWTbOtIiLuVWeM7WD//8XFCkL/u0cQiFemze8or
        byhYTTd7q+dT5UIuWrHdh1Byin94azWcbwMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrLIsWRmVeSWpSXmKPExsVy+t/xe7oyJQvjDfYs07A4f/cQs8XGGetZ
        Leacb2GxmH/kHKvFovczWC2uvb3DatH/+DWzxfnzG9gtLmzrY7W4eWgFo8Wmx9dYLS7vmsNm
        MeP8PiaLQ1P3MlqsPXKX3eLYAjGL1r1H2B0EPS5fu8jssWXlTSaPnbPusntsWtXJ5rF5Sb3H
        zh2fmTz6tqxi9Pi8SS6AI0rPpii/tCRVISO/uMRWKdrQwkjP0NJCz8jEUs/Q2DzWyshUSd/O
        JiU1J7MstUjfLkEvo2f3BbaCVs6KDRNWMDcw/mbvYuTkkBAwkdj2/wxLFyMXh5DAUkaJlyen
        AiU4gBJSEivnpkPUCEv8udbFBlHzlFGi88RtFpAEm4CjRP/SE6wgCRGBN8wSTffesoM4zAL7
        GCX2H10MNklYwE5iTpcEiMkioCoxb1kkSC+vgLXE9L6zLBAL5CXal29nA7E5BWwkGqZMZQKx
        hYBqdh3dwgZRLyhxcuYTFpAxzALqEuvnCYGE+QW0JNY0XQcbwww0pnnrbOYJjEKzkHTMQuiY
        haRqASPzKkaR1NLi3PTcYkO94sTc4tK8dL3k/NxNjMCo3nbs5+YdjJc2Bh9iFOBgVOLhdUhd
        EC/EmlhWXJl7iFGCg1lJhNfp7Ok4Id6UxMqq1KL8+KLSnNTiQ4ymQF9OZJYSTc4HJpy8knhD
        U0NzC0tDc2NzYzMLJXHeDoGDMUIC6YklqdmpqQWpRTB9TBycUg2Meudq3r/T+3dp3pXLj97a
        9RyT2CmfXzLxUHTW6vp+i0wLfaG1UdH/7x45wMFRw8Eow79IMTW9nDN9S6SaHNuTeVunN5Rt
        9t5pEhRTufou6+rlDx0kkjQYjJK6z8TyvzimUbDYti2qL6vtn+M8K5WMALeMZ0ocn4WF/LxO
        WnKt//ctK5W3droSS3FGoqEWc1FxIgA9HfTSAAMAAA==
X-CMS-MailID: 20201103151540eucas1p1be7fe9add1ea297afa95e585be5234ae
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20201103151540eucas1p1be7fe9add1ea297afa95e585be5234ae
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20201103151540eucas1p1be7fe9add1ea297afa95e585be5234ae
References: <20201103151536.26472-1-l.stelmach@samsung.com>
        <CGME20201103151540eucas1p1be7fe9add1ea297afa95e585be5234ae@eucas1p1.samsung.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Enable ax88796c driver for the ethernet chip on Exynos3250-based
ARTIK5 boards.

Signed-off-by: Łukasz Stelmach <l.stelmach@samsung.com>
---
 arch/arm/configs/exynos_defconfig   | 2 ++
 arch/arm/configs/multi_v7_defconfig | 2 ++
 2 files changed, 4 insertions(+)

diff --git a/arch/arm/configs/exynos_defconfig b/arch/arm/configs/exynos_defconfig
index cf82c9d23a08..1ee902d01eef 100644
--- a/arch/arm/configs/exynos_defconfig
+++ b/arch/arm/configs/exynos_defconfig
@@ -107,6 +107,8 @@ CONFIG_MD=y
 CONFIG_BLK_DEV_DM=y
 CONFIG_DM_CRYPT=m
 CONFIG_NETDEVICES=y
+CONFIG_NET_VENDOR_ASIX=y
+CONFIG_SPI_AX88796C=y
 CONFIG_SMSC911X=y
 CONFIG_USB_RTL8150=m
 CONFIG_USB_RTL8152=y
diff --git a/arch/arm/configs/multi_v7_defconfig b/arch/arm/configs/multi_v7_defconfig
index e731cdf7c88c..dad53846f58f 100644
--- a/arch/arm/configs/multi_v7_defconfig
+++ b/arch/arm/configs/multi_v7_defconfig
@@ -243,6 +243,8 @@ CONFIG_SATA_HIGHBANK=y
 CONFIG_SATA_MV=y
 CONFIG_SATA_RCAR=y
 CONFIG_NETDEVICES=y
+CONFIG_NET_VENDOR_ASIX=y
+CONFIG_SPI_AX88796C=m
 CONFIG_VIRTIO_NET=y
 CONFIG_B53_SPI_DRIVER=m
 CONFIG_B53_MDIO_DRIVER=m
-- 
2.26.2

