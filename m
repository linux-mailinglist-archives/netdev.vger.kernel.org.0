Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1305441C66A
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 16:09:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344457AbhI2OLN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 10:11:13 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:53907 "EHLO
        mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344395AbhI2OK5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Sep 2021 10:10:57 -0400
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
        by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id 20210929140913euoutp02e74d3a360352916da60413e17fe29aef~pUDrxxXzD2990729907euoutp02m
        for <netdev@vger.kernel.org>; Wed, 29 Sep 2021 14:09:13 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com 20210929140913euoutp02e74d3a360352916da60413e17fe29aef~pUDrxxXzD2990729907euoutp02m
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1632924554;
        bh=HnitCYaja0dwcrAEA7k5MibO/pq6vQ+8ynA45vV9VFE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FAdPLbWBwP6xgKVSMfNRICdsWXQRXPdl3/33831kcbSLGdTPLx+JzcWIiGXYqnfhA
         PkTTWyajryU+pBNDStnCDv+Wx47QuGOWOfthvzC/3v+BUoquTx+Ro8095xh04IRVkD
         YK4/FYFtvJPlkv3VHCc+p0js6OycyFUKGy2nsekc=
Received: from eusmges2new.samsung.com (unknown [203.254.199.244]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTP id
        20210929140913eucas1p2c2d20ce1bd469bf55a83d0727b545417~pUDrRj4680401204012eucas1p2b;
        Wed, 29 Sep 2021 14:09:13 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
        eusmges2new.samsung.com (EUCPMTA) with SMTP id 09.CB.42068.98374516; Wed, 29
        Sep 2021 15:09:13 +0100 (BST)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
        20210929140912eucas1p2a4a14d3f865dcfad98a21235fbc500bc~pUDqnyCfV0320203202eucas1p2P;
        Wed, 29 Sep 2021 14:09:12 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
        eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20210929140912eusmtrp1c6ce87773e74a41ea597bf0a2a28f68d~pUDqmrjzw3238732387eusmtrp1H;
        Wed, 29 Sep 2021 14:09:12 +0000 (GMT)
X-AuditID: cbfec7f4-c89ff7000002a454-ec-615473898988
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
        eusmgms2.samsung.com (EUCPMTA) with SMTP id C8.D0.20981.88374516; Wed, 29
        Sep 2021 15:09:12 +0100 (BST)
Received: from localhost (unknown [106.120.51.46]) by eusmtip2.samsung.com
        (KnoxPortal) with ESMTPA id
        20210929140912eusmtip200f1bcd3b1f8a1f1a43f1fa0c6ea3cca~pUDqYYsHX0328603286eusmtip2i;
        Wed, 29 Sep 2021 14:09:12 +0000 (GMT)
From:   =?UTF-8?q?=C5=81ukasz=20Stelmach?= <l.stelmach@samsung.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        jim.cromie@gmail.com, Heiner Kallweit <hkallweit1@gmail.com>,
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
        =?UTF-8?q?=C5=81ukasz=20Stelmach?= <l.stelmach@samsung.com>,
        Rob Herring <robh@kernel.org>
Subject: [PATCH net-next v16 1/3] dt-bindings: vendor-prefixes: Add asix
 prefix
Date:   Wed, 29 Sep 2021 16:08:52 +0200
Message-Id: <20210929140854.28535-2-l.stelmach@samsung.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210929140854.28535-1-l.stelmach@samsung.com>
MIME-Version: 1.0
Organization: Samsung R&D Institute Poland
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrOKsWRmVeSWpSXmKPExsWy7djPc7qdxSGJBisPiFqcv3uI2WLjjPWs
        FnPOt7BYzD9yjtVi0fsZrBbX3t5hteh//JrZ4vz5DewWF7b1sVrcPLSC0WLT42usFpd3zWGz
        mHF+H5PFoal7GS3WHrnLbnFsgZhF694j7Bb/9+xgdxDyuHztIrPHlpU3mTx2zrrL7rFpVSeb
        x+Yl9R47d3xm8ujbsorR4/MmuQCOKC6blNSczLLUIn27BK6MH1N+sRT8ZKuYs286WwPjT9Yu
        Rk4OCQETieYvn4FsLg4hgRWMEkumz2WCcL4wSrw88pENwvnMKLHy2BJmmJYt32ZBVS1nlJjZ
        sBCq/zmjxOIVa8Gq2AQcJfqXngBLiAjcY5b4dOw42CxmgfuMEveerwarEhYIlOj+9IkdxGYR
        UJW43T2HDcTmFbCWOPL4CBvEPnmJtuvTGUFsTgEbifd/DzBC1AhKnJz5hAXE5hfQkljTdB3M
        Zgaqb946mxlkmYTAfk6JvTv2QB3uIvHz8QKoocISr45vYYewZSROT+4BauYAsuslJk8yg+jt
        YZTYNucHC0SNtcSdc7/YQGqYBTQl1u/Shwg7Sqz72sAG0conceOtIMQJfBKTtk1nhgjzSnS0
        CUFUq0is698DNVBKovfVCsYJjEqzkDwzC8kDsxB2LWBkXsUonlpanJueWmyUl1quV5yYW1ya
        l66XnJ+7iRGY9k7/O/5lB+PyVx/1DjEycTAeYpTgYFYS4f0hHpwoxJuSWFmVWpQfX1Sak1p8
        iFGag0VJnDdpy5p4IYH0xJLU7NTUgtQimCwTB6dUAxPDDM+fjuuzT5m77GRbaP0rcvGdnxHC
        PQvrDqySb23ZwnHg3+Vy3R/TX7KKKvKa7t68eN/RAr5i34/N9lwfM6ewHnLrfJFQuT8/NuRe
        mn1L8KLLvP3Pqrot7afm+P6qCHip9ufSBM0p8xjP/rg5dc3n/acNeU0K5Xe8//Ft/85YhqCm
        z5PXzpHm3bmGwe395p9ub5hCm4V51XO5thYc+mEp0pbGzeWx1a9WOOWG3a62C4Y1PAJXG9fv
        eLHq8oPTV5yW9VW+DxYw/Db7wMWMxogCS11+z9vX7i/PVe3+9z+GP9v6jJnpPHXzqy3HvYyU
        Zz5N+2WzS/8M38w6K/XtbqYTpnd9bwnW2hslvmBBloQSS3FGoqEWc1FxIgB8GB+g6gMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrGIsWRmVeSWpSXmKPExsVy+t/xe7odxSGJBt9fq1ucv3uI2WLjjPWs
        FnPOt7BYzD9yjtVi0fsZrBbX3t5hteh//JrZ4vz5DewWF7b1sVrcPLSC0WLT42usFpd3zWGz
        mHF+H5PFoal7GS3WHrnLbnFsgZhF694j7Bb/9+xgdxDyuHztIrPHlpU3mTx2zrrL7rFpVSeb
        x+Yl9R47d3xm8ujbsorR4/MmuQCOKD2bovzSklSFjPziElulaEMLIz1DSws9IxNLPUNj81gr
        I1MlfTublNSczLLUIn27BL2MH1N+sRT8ZKuYs286WwPjT9YuRk4OCQETiS3fZjF1MXJxCAks
        ZZTYvukwSxcjB1BCSmLl3HSIGmGJP9e62CBqnjJKnDx8hBEkwSbgKNG/9ATYIBGBN8wSP3ul
        QIqYBe4zSvz69AKsSFjAX2JdxzqwIhYBVYnb3XPYQGxeAWuJI4+PsEFskJdouz4drJ5TwEbi
        /d8DYLYQUM3n5w2MEPWCEidnPgE7jllAXWL9PCGQML+AlsSapussIDYz0JjmrbOZJzAKzULS
        MQuhYxaSqgWMzKsYRVJLi3PTc4uN9IoTc4tL89L1kvNzNzECI3zbsZ9bdjCufPVR7xAjEwfj
        IUYJDmYlEd4f4sGJQrwpiZVVqUX58UWlOanFhxhNgT6byCwlmpwPTDF5JfGGZgamhiZmlgam
        lmbGSuK8JkfWxAsJpCeWpGanphakFsH0MXFwSjUwbTyyivu0xPbUy2+nfSxp9ryRxKI54Sbj
        idIJXaEhuvdfbmg5ruazRT9bp42v5bnxXi6DJXdWWfze4y1cu4dPaHPE/yUTtmxuf+359bV2
        e20Tb2hC4teYrwJ+W3nUkiXEThg6xBfJ/a35eu5vdA2LjbrU1tLDs1TifuidumzW9Ftkj8eT
        2nb3uhlTVI4dvssz30t2z1fXue7/l1k8MwkoFM9jSv/HtG6+6rYPhl1SWw8sXBug9PPzsxC1
        +L1zGTw6dz2/kKxVdPnvzA1b9vdfuTix2ZdnX+Z9AZkzhzmWrkyz6MjQ+vPG0Kr62aNXMr7/
        twc8N2+yld1RNdPx3mLGPY/bl1293/I98KuWQ+yRACWW4oxEQy3mouJEAFgqGwB5AwAA
X-CMS-MailID: 20210929140912eucas1p2a4a14d3f865dcfad98a21235fbc500bc
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20210929140912eucas1p2a4a14d3f865dcfad98a21235fbc500bc
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20210929140912eucas1p2a4a14d3f865dcfad98a21235fbc500bc
References: <20210929140854.28535-1-l.stelmach@samsung.com>
        <CGME20210929140912eucas1p2a4a14d3f865dcfad98a21235fbc500bc@eucas1p2.samsung.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add the prefix for ASIX Electronics Corporation.

Signed-off-by: Łukasz Stelmach <l.stelmach@samsung.com>
Reviewed-by: Krzysztof Kozlowski <krzk@kernel.org>
Acked-by: Rob Herring <robh@kernel.org>
---
 Documentation/devicetree/bindings/vendor-prefixes.yaml | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/devicetree/bindings/vendor-prefixes.yaml b/Documentation/devicetree/bindings/vendor-prefixes.yaml
index a867f7102c35..e2eb0c738f3a 100644
--- a/Documentation/devicetree/bindings/vendor-prefixes.yaml
+++ b/Documentation/devicetree/bindings/vendor-prefixes.yaml
@@ -131,6 +131,8 @@ patternProperties:
     description: Asahi Kasei Corp.
   "^asc,.*":
     description: All Sensors Corporation
+  "^asix,.*":
+    description: ASIX Electronics Corporation
   "^aspeed,.*":
     description: ASPEED Technology Inc.
   "^asus,.*":
-- 
2.30.2

