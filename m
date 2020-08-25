Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F8F1251DCD
	for <lists+netdev@lfdr.de>; Tue, 25 Aug 2020 19:04:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726429AbgHYREB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Aug 2020 13:04:01 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:59739 "EHLO
        mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726747AbgHYRD1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Aug 2020 13:03:27 -0400
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
        by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20200825170324euoutp0167639521d5fc7ba5159f5fda13197f67~ukZkTBhiA1835518355euoutp01q
        for <netdev@vger.kernel.org>; Tue, 25 Aug 2020 17:03:24 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20200825170324euoutp0167639521d5fc7ba5159f5fda13197f67~ukZkTBhiA1835518355euoutp01q
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1598375004;
        bh=lT/pl1UqwgOneCVuz4KsAzjqeeKNXQsmCXwNe9O0dU4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=n5RLxxn4Kr0GUCoNLBbXVFwuI95z3WSkk5oRNzalIORTEAOWKm47Z62ZjpvMCw1ss
         NLgqeUFdcEMKbQtW/4lSxKc8QDxeGV8TN0/hdJeRZhzcLzH7r0oaEpT0YcRs5tYup6
         Bo4e4pK5xx9KdeiA0RNoAY5yBcnUo+CmiDPuiiJg=
Received: from eusmges3new.samsung.com (unknown [203.254.199.245]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTP id
        20200825170323eucas1p2d545dc9328a6145c1bca5dda5a65dcc2~ukZj2CgIj2589925899eucas1p2B;
        Tue, 25 Aug 2020 17:03:23 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
        eusmges3new.samsung.com (EUCPMTA) with SMTP id C6.99.06318.B54454F5; Tue, 25
        Aug 2020 18:03:23 +0100 (BST)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
        20200825170323eucas1p15f2bbfa460f7ef787069dd3459dd77b3~ukZjivK8g3202332023eucas1p14;
        Tue, 25 Aug 2020 17:03:23 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
        eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20200825170323eusmtrp1f5737ef6b130b74d4774840b86a12242~ukZjiCK210199301993eusmtrp1E;
        Tue, 25 Aug 2020 17:03:23 +0000 (GMT)
X-AuditID: cbfec7f5-371ff700000018ae-a3-5f45445b753a
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
        eusmgms2.samsung.com (EUCPMTA) with SMTP id 91.93.06017.B54454F5; Tue, 25
        Aug 2020 18:03:23 +0100 (BST)
Received: from localhost (unknown [106.120.51.46]) by eusmtip2.samsung.com
        (KnoxPortal) with ESMTPA id
        20200825170323eusmtip23d84fa8f7cffda9917febb8e4156b60f~ukZjYrn7G1936819368eusmtip2j;
        Tue, 25 Aug 2020 17:03:23 +0000 (GMT)
From:   =?UTF-8?q?=C5=81ukasz=20Stelmach?= <l.stelmach@samsung.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Kukjin Kim <kgene@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org
Cc:     m.szyprowski@samsung.com, b.zolnierkie@samsung.com,
        =?UTF-8?q?=C5=81ukasz=20Stelmach?= <l.stelmach@samsung.com>
Subject: [PATCH 3/3] ARM: defconfig: Enable ax88796c driver
Date:   Tue, 25 Aug 2020 19:03:11 +0200
Message-Id: <20200825170311.24886-3-l.stelmach@samsung.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200825170311.24886-1-l.stelmach@samsung.com>
MIME-Version: 1.0
Organization: Samsung R&D Institute Poland
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA02Sa0hTYRjHe3fOtrPl9DhFn6ZkzIIS8hp1SokspQV98EtERdnS07R0yo5a
        9iEta6ktNa20NdLU0MxLzrt5wTWvQ+cNTUmIDFO7UWbalZxHyW//9/n//s8FXgITt3MlRLgy
        hlYp5RFSnhCv7fhh3n4iIDDYsyrfm6rMqeBSOvM1nMo19nGp9Mn3GGU2P+NT/bVpXGrMUIwo
        /eQIlxpq1PGoHHMLhzLcbUZUmXGCT3XkOVDXm438fdayoZEBTFb9ZIwj05ek8GRVhQmytOoS
        JJvTbwziHRf6hdIR4XG0ymPvaWHYUH8DFt0rvFhmNHESUYUgFQkIIHfAvTv1eCoSEmKyGMEf
        dQ9iH98QtD9txtjHHIL8jhHOauRhYjafNYoQNGqer1DvEGQNzuIWikf6Q/rjLq7FsCcTMZi6
        aUIWAyNjQdNg4Fm0HekLGVe+8C0aJ7fA+CPtshYt1XW3F3B2nAvcKKpb5gWkH3ww1mAsYwvd
        998uMzakG5ReHcXZ/i6QVPNgeSMgZ/gwaVjA2EYB8LVHjVhtB7Od1XxWO4MpS7MUJpZ0AmRl
        7mSzGgS1usWVJXzhVd9PnoXByG1Q0ejBlv1hsU3NZaPW8PKjLbuCNWTWZmNsWQTJajFLb4by
        9KaVhhK4NVuMMpBUu+YY7ZoDtP9n5SGsBDnSsUykgmZ8lPQFd0YeycQqFe4hUZF6tPS5TH87
        5+tRy+8zBkQSSGolyuMFBou58jgmPtKAgMCk9qL9vaZTYlGoPP4SrYoKVsVG0IwBORG41FHk
        kz9zUkwq5DH0eZqOplWrLocQSBJR1WWXyfDxmbP0wIBrW0TraNeBwulPApOhdaA0O89WU1UQ
        PpXSRLo6B9X/8h7Wk6+r+cybo05xE6m6XJ3VoWTqoEJvo5AY0ffDwukCiX13wPh0gKcXQ23d
        AJWbXF80NAInZFfS4O7MI+t65td7ZN4/Fn+uy6FuuPyz0HbWPWePFGfC5F5umIqR/wNH+ygn
        WAMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrKIsWRmVeSWpSXmKPExsVy+t/xe7rRLq7xBn8WKlpsnLGe1WLO+RYW
        i/lHzrFa9D9+zWxx/vwGdosL2/pYLW4eWsFosenxNVaLy7vmsFnMOL+PyeLQ1L2MFmuP3GW3
        OLZAzKJ17xF2Bz6Py9cuMntsWXmTyWPTqk42j81L6j36tqxi9Pi8SS6ALUrPpii/tCRVISO/
        uMRWKdrQwkjP0NJCz8jEUs/Q2DzWyshUSd/OJiU1J7MstUjfLkEv4/KFncwFZ7kq1h45zdTA
        uJ6zi5GTQ0LARGJew3T2LkYuDiGBpYwSLyc+ZOxi5ABKSEmsnJsOUSMs8edaFxtEzVNGiXkX
        b7CBJNgEHCX6l55gBUmICHQxSxy5+BMswSxQLnFp1nN2EFtYwFpiQuNHMJtFQFXi1sJZYDYv
        UHzOxO8sEBvkJdqXbwfr5RSwkXhzZCsziC0EVNNz8BoTRL2gxMmZT1hAjmMWUJdYP08IJMwv
        oCWxpuk6C8RaeYnmrbOZJzAKzULSMQuhYxaSqgWMzKsYRVJLi3PTc4uN9IoTc4tL89L1kvNz
        NzECo3TbsZ9bdjB2vQs+xCjAwajEw7uAzTVeiDWxrLgy9xCjBAezkgiv09nTcUK8KYmVValF
        +fFFpTmpxYcYTYHenMgsJZqcD0wgeSXxhqaG5haWhubG5sZmFkrivB0CB2OEBNITS1KzU1ML
        Uotg+pg4OKUaGJUDj7JbLjFbwef8ZHqT+YtX0tbuTelVjLZBLL+FEh47nDP8z3916wf1Sdd+
        ixp9X+2p3pZRtO2WerOsvW9VQO9UhV8LDvreV+g4WH4vaEXcKaVjiy+JLdGP+u393K1HToL1
        3WmxsPkbvrDE3Dz8Zc2dm8milmebL1YtP6P2tojVw3NTtK2MmhJLcUaioRZzUXEiAAig+ejo
        AgAA
X-CMS-MailID: 20200825170323eucas1p15f2bbfa460f7ef787069dd3459dd77b3
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20200825170323eucas1p15f2bbfa460f7ef787069dd3459dd77b3
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20200825170323eucas1p15f2bbfa460f7ef787069dd3459dd77b3
References: <20200825170311.24886-1-l.stelmach@samsung.com>
        <CGME20200825170323eucas1p15f2bbfa460f7ef787069dd3459dd77b3@eucas1p1.samsung.com>
Sender: netdev-owner@vger.kernel.org
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

Please DO NOT merge before these two

  https://lore.kernel.org/lkml/20200821161401.11307-2-l.stelmach@samsung.com/
  https://lore.kernel.org/lkml/20200821161401.11307-3-l.stelmach@samsung.com/

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

