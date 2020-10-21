Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3068129548F
	for <lists+netdev@lfdr.de>; Wed, 21 Oct 2020 23:50:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2506539AbgJUVug (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Oct 2020 17:50:36 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:57568 "EHLO
        mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2506501AbgJUVuV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Oct 2020 17:50:21 -0400
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
        by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id 20201021214953euoutp020ba82305a4bf17293d3c65b750b02609~AIE_r-tbA1752017520euoutp02J
        for <netdev@vger.kernel.org>; Wed, 21 Oct 2020 21:49:53 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com 20201021214953euoutp020ba82305a4bf17293d3c65b750b02609~AIE_r-tbA1752017520euoutp02J
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1603316993;
        bh=4fyCws4IJ/FYfmeubIZmsDv7F8YQu+sqPMRSahhjyO0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=axCCmHjJ7OEt7FuZ0FdzGKqfImB2eh43g2H8URQhBVD5vP6lGnOZx7pYG9uRfPNRK
         pClRbO+R4bafjpI2IMwYY3iyPbRMZVBlS0XaX8nUOTaAFqPqC9QoNV3NJB7pys/Srz
         opWcAlSQtEMdb216Cm+7+g7Ht8zRLcnVgAh/bVu8=
Received: from eusmges3new.samsung.com (unknown [203.254.199.245]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTP id
        20201021214935eucas1p1f148e949b29a1c5c480a10aa3d499110~AIEth_NXj2935129351eucas1p1d;
        Wed, 21 Oct 2020 21:49:35 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
        eusmges3new.samsung.com (EUCPMTA) with SMTP id 11.9C.06318.FECA09F5; Wed, 21
        Oct 2020 22:49:35 +0100 (BST)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
        20201021214934eucas1p2d4acc48c40f37763c276d8d275fa9c15~AIEsqgsWh1618216182eucas1p2q;
        Wed, 21 Oct 2020 21:49:34 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
        eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20201021214934eusmtrp1efb67b1efe137dacb88fd856555ffccc~AIEsp5GPb1537015370eusmtrp1l;
        Wed, 21 Oct 2020 21:49:34 +0000 (GMT)
X-AuditID: cbfec7f5-371ff700000018ae-c8-5f90acef9fc5
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
        eusmgms2.samsung.com (EUCPMTA) with SMTP id CC.E4.06017.EECA09F5; Wed, 21
        Oct 2020 22:49:34 +0100 (BST)
Received: from localhost (unknown [106.120.51.46]) by eusmtip1.samsung.com
        (KnoxPortal) with ESMTPA id
        20201021214934eusmtip1bd463710d90630bc5f3d5abb9db7709d~AIEsd4jUo0629906299eusmtip1c;
        Wed, 21 Oct 2020 21:49:34 +0000 (GMT)
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
Subject: [PATCH v3 5/5] ARM: defconfig: Enable ax88796c driver
Date:   Wed, 21 Oct 2020 23:49:10 +0200
Message-Id: <20201021214910.20001-6-l.stelmach@samsung.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201021214910.20001-1-l.stelmach@samsung.com>
MIME-Version: 1.0
Organization: Samsung R&D Institute Poland
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA02Sa0hTYRjHeXd2tjNpdpyiTxYaI4sEtTL0DVNU+nCgIA2FEktXHlfopmxp
        2YcUy2umywvZHGVe0IZ5d94HDrPScoZmCSmS0cU0C4tyhuR2lPz2XH7/5/88Ly9FSKZJV+qS
        8jKrUsoSpQI7vmFoxey11KCJOTBlAWyeNhG4pbyJxDrzTT5+MDhK4qqlchJPLr4jcdHcVwKb
        zc1CPGYoJPGUqR7h1rlJEo/36AS43GzkYVNZP8KPB6eFeKjSGWf1DwqDHZjxyVcE0/5oisd0
        a6eFTKs+T8C01aQz3V3LPKawXY+Y5Va3MCrK7mgcm3gplVX5BMXaXSzoHRMkZ4muNmvqiQy0
        KsxHIgrowzCpfYjykR0loesR6EwrAi75iaDxllbIJcsIZi1PBJuSlU+fbbGErkNQ/WMvB31C
        ULvQz7c2BHQIFNU+I60NJ3qGgKacWZsJQRsRdM+UElbKkQ6CzCGDTcGnPaDYsGCri+kAqOha
        3bBzh5y6Tlssoo/C+LdmkmMc4Pm9DzbtdtoTGjLf2GJinb/RUUFYzYC+Q0H28BovH1HryTGY
        +H2Gm+kI80/bN15gF4yUFPA5JB1Kiv04aQECg+4Pn2MC4N2oRWBlCHo/NPX4cOUQqPncgDip
        PbxddOA2sF+/5C7BlcWQmy3h6D3QWNS3MdAVbs/XIw2Sarfcot2yv/a/VyUi9MiFTVEr5Kza
        V8le8VbLFOoUpdz7QpKiFa1/upG1p7+6kPHveROiKSTdJv5+QhMjIWWp6jSFCQFFSJ3EoS9H
        zknEcbK0a6wqKUaVksiqTWgnxZe6iH2rvpyV0HLZZTaBZZNZ1WaXR4lcM5B+NpX45e0fKZqX
        TxREeATGV/fGuqgGvNx2HLJkxp16fz3d+cZoZ/YBxvH+wnFGbhmOivccyFdWa8L8oltm5mry
        DLs9/PuQBtyNVbnG7iRFYHRhhyrTfKTtIx3cpjvpXHo6/LW+bJEKXXuR4BZZ3Tk45eK5Mzxi
        cSbFfZ8iXiflqy/KDnoSKrXsH1aueBpwAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrHIsWRmVeSWpSXmKPExsVy+t/xu7rv1kyIN5i6Xcbi/N1DzBYbZ6xn
        tZhzvoXFYv6Rc6wWi97PYLW49vYOq0X/49fMFufPb2C3uLCtj9Xi5qEVjBabHl9jtbi8aw6b
        xYzz+5gsDk3dy2ix9shddotjC8QsWvceYXcQ9Lh87SKzx5aVN5k8ds66y+6xaVUnm8fmJfUe
        O3d8ZvLo27KK0ePzJrkAjig9m6L80pJUhYz84hJbpWhDCyM9Q0sLPSMTSz1DY/NYKyNTJX07
        m5TUnMyy1CJ9uwS9jJ7dF9gKWjkrNkxYwdzA+Ju9i5GTQ0LAROLn8xdsILaQwFJGiVn/07sY
        OYDiUhIr56ZDlAhL/LnWBVTCBVTylFFi0Yz1YL1sAo4S/UtPsIIkRATeMEs03XvLDuIwC+xj
        lNh/dDFYlbCAnUTTsW0sIDaLgKrEpG1vmEFsXgFridk7frNBrJCXaF++HczmFLCRuPxuAyvE
        RdYSl95NZoSoF5Q4OfMJC8h1zALqEuvnCYGE+QW0JNY0XQcbzww0pnnrbOYJjEKzkHTMQuiY
        haRqASPzKkaR1NLi3PTcYiO94sTc4tK8dL3k/NxNjMC43nbs55YdjF3vgg8xCnAwKvHwfvCZ
        EC/EmlhWXJl7iFGCg1lJhNfp7Ok4Id6UxMqq1KL8+KLSnNTiQ4ymQG9OZJYSTc4Hppy8knhD
        U0NzC0tDc2NzYzMLJXHeDoGDMUIC6YklqdmpqQWpRTB9TBycUg2MG1fIXlhqHHDJ1v38ognv
        tqxwWu9pe3lfnfOZ/Kzzl00bvts+uzWJ1XHD9LXZNWlZto0WtpkZJx8+yFP1DTtTeWpu2//P
        UuLCmqH9KfmFPa6cXhfdTy6TcWDd0+Rx5+xH15gl65jldbfzGk2oOCl7dqfBWVndm+r3k/NN
        2ZfckGTzmau0SnSyEktxRqKhFnNRcSIAdD4W+AEDAAA=
X-CMS-MailID: 20201021214934eucas1p2d4acc48c40f37763c276d8d275fa9c15
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20201021214934eucas1p2d4acc48c40f37763c276d8d275fa9c15
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20201021214934eucas1p2d4acc48c40f37763c276d8d275fa9c15
References: <20201021214910.20001-1-l.stelmach@samsung.com>
        <CGME20201021214934eucas1p2d4acc48c40f37763c276d8d275fa9c15@eucas1p2.samsung.com>
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

