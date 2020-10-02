Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E81FA281BA2
	for <lists+netdev@lfdr.de>; Fri,  2 Oct 2020 21:22:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388528AbgJBTWZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Oct 2020 15:22:25 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:40115 "EHLO
        mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388474AbgJBTWW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Oct 2020 15:22:22 -0400
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
        by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id 20201002192218euoutp022e7e2d39fd0618d428243af1ded73581~6QzsFHT2_1063910639euoutp02B
        for <netdev@vger.kernel.org>; Fri,  2 Oct 2020 19:22:18 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com 20201002192218euoutp022e7e2d39fd0618d428243af1ded73581~6QzsFHT2_1063910639euoutp02B
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1601666538;
        bh=gd7YoCV7kMqP+MzczzH7033jKrGcHE5ydNMEk/LHvFg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ot9JnM16PcTpVlKv64yi0e6eCnz5/dXHFULxhPdeKGdLbybEbRJYkK1xupnOBZEFn
         B8IdOhJfqQjgDspWvKJQziTf5ds6p/y5XZoSEzIL8iNmS0Tit4p0D2M+SDiXx1ic+k
         fi/+xHj+Cu23cSW9nyNWO//rLV3vDKl7W6S/F0Po=
Received: from eusmges3new.samsung.com (unknown [203.254.199.245]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTP id
        20201002192217eucas1p229797112417bec5326ecd0e0e2b899e6~6QzrVYjk61780917809eucas1p2e;
        Fri,  2 Oct 2020 19:22:17 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
        eusmges3new.samsung.com (EUCPMTA) with SMTP id 7F.37.06318.9ED777F5; Fri,  2
        Oct 2020 20:22:17 +0100 (BST)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
        20201002192217eucas1p2357f80b100fb130d1ef1ac281042ff7c~6Qzq6z83f1780917809eucas1p2d;
        Fri,  2 Oct 2020 19:22:17 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
        eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20201002192216eusmtrp217d13b792d9dea8bd9054d90c28132ce~6Qzq6K-B43070930709eusmtrp29;
        Fri,  2 Oct 2020 19:22:16 +0000 (GMT)
X-AuditID: cbfec7f5-38bff700000018ae-25-5f777de98ddc
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
        eusmgms1.samsung.com (EUCPMTA) with SMTP id B7.3F.06314.8ED777F5; Fri,  2
        Oct 2020 20:22:16 +0100 (BST)
Received: from localhost (unknown [106.120.51.46]) by eusmtip1.samsung.com
        (KnoxPortal) with ESMTPA id
        20201002192216eusmtip13f6e70dce507beb65d8c668358369ef2~6QzqsiWMq0278102781eusmtip1G;
        Fri,  2 Oct 2020 19:22:16 +0000 (GMT)
From:   =?UTF-8?q?=C5=81ukasz=20Stelmach?= <l.stelmach@samsung.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Kukjin Kim <kgene@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>, jim.cromie@gmail.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org
Cc:     =?UTF-8?q?Bart=C5=82omiej=20=C5=BBolnierkiewicz?= 
        <b.zolnierkie@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        =?UTF-8?q?=C5=81ukasz=20Stelmach?= <l.stelmach@samsung.com>
Subject: [PATCH v2 4/4] ARM: defconfig: Enable ax88796c driver
Date:   Fri,  2 Oct 2020 21:22:10 +0200
Message-Id: <20201002192210.19967-5-l.stelmach@samsung.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201002192210.19967-1-l.stelmach@samsung.com>
MIME-Version: 1.0
Organization: Samsung R&D Institute Poland
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA01Se0hTURzm7N673a1mZ5vkTy2DVUgvLQw5pVhm1IX+KXpRpLbyopKvdjUz
        CMXeUllaacsoonCZpk1dbtTSIWWtnKL4CDVKKawka2WlvbZdo/77fud83/f7vsNhKXU3E8Am
        p2Xy+jRdilaqoM0PvzsXDR/Mjl/c2qQhzn47Re6UVjOkzHmYJleaWxnSNdLHkMLBdxRxOmtk
        pM18miG9diMipsEuhnRYy6Sk1GmTEPv5+4hUNffLyMOr08mR+82ylZjr6GqnuLqbvRLOYuiX
        caaKE1Ku9nouZ2lwSbjTdRWIc5mC1rPbFZEJfEryPl4fGrVTkdTtaJFlHJHv/1n4ms5DE7IC
        JGcBL4UXtk6mAClYNTYiqL/8ihKHzwieH3UgcXAhcFaVUH8lvy0NXrkalyMwdoSJpDcIyg53
        I8+FFEdD4Y0Wr68vNlPwvvYa7RkobENgGTjntmJZDY4Cy5OFHgGN50JzS55XrMQR0Nk+LhW3
        zYJj5Xe9WI4jwZpfIxM5Knh8cYj24Gl4PlTmd3sx5eYfqr/k7QD4BAsTlk9INFoNT186Jito
        4O2juskXmOGuc0XiyQM4F4qLwkXtSQTmsm+0yImAvlZPINa9YB5UW0NFejQMnF0rQh/oGVGJ
        CXygyFxCicdKOH5ULXrMgduF9yb9AuDUWyM6g7SG/7oY/stv+LfqKqIqkB+fJaQm8kJYGp8d
        IuhShay0xJDd6akm5P5ujl+PvjQg249ddoRZpJ2qZBdnx6sZ3T4hJ9WOgKW0vspVzxxxamWC
        LucAr0+P12el8IIdBbK01k8Zdm04Vo0TdZn8Hp7P4PV/byWsPCAPmTZtyN5VuUl4VaIhEQVT
        Nio0aOpIOw6vnrntjcnaY0CNF2y9nbcuWkYztwZ/tBZnLfCP3r/owHlXbaMjXOUflK5PiFu3
        GRljVR/WZJbsuNsU2Da6fG8kK/d5kDLxcllNT+meIRN7bGg2H+P6um5wCz8WNMaNMqqBmBWN
        MePB97S0kKRbMp/SC7o/iaLWjWoDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrJIsWRmVeSWpSXmKPExsVy+t/xu7ovasvjDZ6sMLc4f/cQs8XGGetZ
        Leacb2GxmH/kHKvFtbd3WC36H79mtjh/fgO7xYVtfawWNw+tYLTY9Pgaq8XlXXPYLGac38dk
        cWjqXkaLtUfuslscWyBm0br3CLuDgMflaxeZPbasvMnksXPWXXaPTas62Tw2L6n32LnjM5NH
        35ZVjB6fN8kFcETp2RTll5akKmTkF5fYKkUbWhjpGVpa6BmZWOoZGpvHWhmZKunb2aSk5mSW
        pRbp2yXoZVw/fYK9oJWz4m//M5YGxt/sXYycHBICJhL/d+4Asrk4hASWMkps2nqMsYuRAygh
        JbFybjpEjbDEn2tdbBA1Txkldj7fxQiSYBNwlOhfeoIVJCEicIhZ4tuTMywgDrPAPkaJ/UcX
        s4NMEhawk9h5SgekgUVAVeLIiQawZl4Ba4krF3+xQWyQl2hfvh3M5hSwkdjVtAHsOiGgmss3
        j0LVC0qcnPmEBWQks4C6xPp5QiBhfgEtiTVN11lAbGagMc1bZzNPYBSahaRjFkLHLCRVCxiZ
        VzGKpJYW56bnFhvqFSfmFpfmpesl5+duYgRG87ZjPzfvYLy0MfgQowAHoxIPb4JRebwQa2JZ
        cWXuIUYJDmYlEV6ns6fjhHhTEiurUovy44tKc1KLDzGaAr05kVlKNDkfmGjySuINTQ3NLSwN
        zY3Njc0slMR5OwQOxggJpCeWpGanphakFsH0MXFwSjUwzlzzt3WX6nse9wWtTlfuyf/+92nz
        itMS8Uvzqpx2XWO5fHpi1d2G2+JtdR3333sqmoR72egwSsnHqq27rWTvZHbXkO2h7aKNa449
        cjBtsGowtFRX8a50vl4n+3rx+fjV3S9aXNINZk3izdM0WyIS0vg7sKEsx0RVwvDTkataefLN
        d7TtJnkosRRnJBpqMRcVJwIAu8ZsyfwCAAA=
X-CMS-MailID: 20201002192217eucas1p2357f80b100fb130d1ef1ac281042ff7c
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20201002192217eucas1p2357f80b100fb130d1ef1ac281042ff7c
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20201002192217eucas1p2357f80b100fb130d1ef1ac281042ff7c
References: <20201002192210.19967-1-l.stelmach@samsung.com>
        <CGME20201002192217eucas1p2357f80b100fb130d1ef1ac281042ff7c@eucas1p2.samsung.com>
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
index 6e8b5ff0859c..82480b2bf545 100644
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
index e9e76e32f10f..a8b4e95d4148 100644
--- a/arch/arm/configs/multi_v7_defconfig
+++ b/arch/arm/configs/multi_v7_defconfig
@@ -241,6 +241,8 @@ CONFIG_SATA_HIGHBANK=y
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

