Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B432139B671
	for <lists+netdev@lfdr.de>; Fri,  4 Jun 2021 12:02:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230109AbhFDKDu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Jun 2021 06:03:50 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:54968 "EHLO
        mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229668AbhFDKDr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Jun 2021 06:03:47 -0400
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
        by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id 20210604100200euoutp026246f6c7615f5f0a510534d894549916~FWNbcmxW20916909169euoutp02Z
        for <netdev@vger.kernel.org>; Fri,  4 Jun 2021 10:02:00 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com 20210604100200euoutp026246f6c7615f5f0a510534d894549916~FWNbcmxW20916909169euoutp02Z
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1622800920;
        bh=H1CAXRkMFIGh4uSgtiCGeps9TafORWbw3bMUdu6yMKs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eBYK9/xL87OClhCzzRkwa4fRTUWPqNmfXpcxUNNtAoAZBIpLsvKsYtthcKUp3/t+s
         nqaBnntOK5JJdetW4GIYMBylh4ZTbW436LTWJIIPR5WlquYpixTHAiwum+68wttlaI
         +TzX8drdBGeLDBg+kxCJZIG8cy44RPaV6D5WdC+U=
Received: from eusmges1new.samsung.com (unknown [203.254.199.242]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTP id
        20210604100200eucas1p1dfd4b6e0f687c4ea3abd9f8bdd2521f7~FWNa9tfrb0541805418eucas1p1s;
        Fri,  4 Jun 2021 10:02:00 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
        eusmges1new.samsung.com (EUCPMTA) with SMTP id F6.7D.09452.71AF9B06; Fri,  4
        Jun 2021 11:01:59 +0100 (BST)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
        20210604100159eucas1p2834b960ee67a9ebd6057c7cef6dd5650~FWNajXV9z1011610116eucas1p2o;
        Fri,  4 Jun 2021 10:01:59 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
        eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20210604100159eusmtrp20eb62aa45f151101e0e6977f68f53f69~FWNaihh0u1054110541eusmtrp2F;
        Fri,  4 Jun 2021 10:01:59 +0000 (GMT)
X-AuditID: cbfec7f2-ab7ff700000024ec-fc-60b9fa1773d2
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
        eusmgms1.samsung.com (EUCPMTA) with SMTP id 89.A7.08705.71AF9B06; Fri,  4
        Jun 2021 11:01:59 +0100 (BST)
Received: from localhost (unknown [106.120.51.46]) by eusmtip1.samsung.com
        (KnoxPortal) with ESMTPA id
        20210604100159eusmtip13e5e7a2ac76d91494bb69e25342d472b~FWNaS-30F1379313793eusmtip1q;
        Fri,  4 Jun 2021 10:01:59 +0000 (GMT)
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
        =?UTF-8?q?=C5=81ukasz=20Stelmach?= <l.stelmach@samsung.com>,
        Rob Herring <robh@kernel.org>
Subject: [PATCH 1/3] dt-bindings: vendor-prefixes: Add asix prefix
Date:   Fri,  4 Jun 2021 12:01:46 +0200
Message-Id: <20210604100148.17177-2-l.stelmach@samsung.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210604100148.17177-1-l.stelmach@samsung.com>
MIME-Version: 1.0
Organization: Samsung R&D Institute Poland
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrGKsWRmVeSWpSXmKPExsWy7djPc7riv3YmGFz4YGNx/u4hZouNM9az
        Wsw538JiMf/IOVaLRe9nsFpce3uH1aL/8Wtmi/PnN7BbXNjWx2px89AKRotNj6+xWlzeNYfN
        Ysb5fUwWh6buZbRYe+Quu8WxBWIWrXuPsFv837OD3UHI4/K1i8weW1beZPLYOesuu8emVZ1s
        HpuX1Hvs3PGZyaNvyypGj8+b5AI4orhsUlJzMstSi/TtErgyTk0QL/jJVrHo8BHGBsafrF2M
        nBwSAiYSF+8sY+ti5OIQEljBKHGkaTozhPOFUeLT7UmMEM5nRon771YywbTcvfQPKrGcUWLL
        yttMEM5zRon2H6+ZQarYBBwl+peeYAVJiAjcY5ZY3/4ArIVZ4D6jxL3nq8GqhAWcJE7en8QO
        YrMIqErM7/nFAmLzClhLzHm7jg1in7xE+/LtYDangI3EnNn/WCFqBCVOznwCVs8voCWxpuk6
        mM0MVN+8dTbYFxICpzglZm46yQwxyEVi396nUE8IS7w6voUdwpaR+L9zPlCcA8iul5g8yQyi
        t4dRYtucHywQNdYSd879YgOpYRbQlFi/Sx8i7Cix99A3ZohWPokbbwUhTuCTmLRtOlSYV6Kj
        TQiiWkViXf8eqIFSEr2vVjBOYFSaheSZWUgemIWwawEj8ypG8dTS4tz01GLDvNRyveLE3OLS
        vHS95PzcTYzApHf63/FPOxjnvvqod4iRiYPxEKMEB7OSCO8etR0JQrwpiZVVqUX58UWlOanF
        hxilOViUxHlXzV4TLySQnliSmp2aWpBaBJNl4uCUamDi/29x1/qflNm09eqrznxQszsZk115
        yPnjV/lLLfOObEqXZdS+sbsx6oGq5LLLQg8eqWiuW/vvuG1466lPjwzcXNdm5Zxc/ODfjd1m
        bybbVf+e+EzYTzEncIP1vBMHr3x02+Cm8FtqQgPTmrWTfiXeYjxk+bl+7jylzN07QiO8E5R2
        CHJcKPQWvxe7eJKr/cuS5Qocv3QTTm99LGCS93BHCg/3pBtsTCtWzUz0mxibvearNNdj2Veb
        k7v9H7Xpqldb7X+s5PxUln/53+hrrWyMEZrhf1bZGPeaf/aUydwRM3HFwYMBOpuPPZnRKF7R
        VfhGu6F+VUmnN8e5mEUF/7MMK35VaSW6T1BrzPNb/KFBiaU4I9FQi7moOBEAAp5WD+kDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrKIsWRmVeSWpSXmKPExsVy+t/xu7riv3YmGKyaJWdx/u4hZouNM9az
        Wsw538JiMf/IOVaLRe9nsFpce3uH1aL/8Wtmi/PnN7BbXNjWx2px89AKRotNj6+xWlzeNYfN
        Ysb5fUwWh6buZbRYe+Quu8WxBWIWrXuPsFv837OD3UHI4/K1i8weW1beZPLYOesuu8emVZ1s
        HpuX1Hvs3PGZyaNvyypGj8+b5AI4ovRsivJLS1IVMvKLS2yVog0tjPQMLS30jEws9QyNzWOt
        jEyV9O1sUlJzMstSi/TtEvQyTk0QL/jJVrHo8BHGBsafrF2MnBwSAiYSdy/9Y+xi5OIQEljK
        KPG4+xpbFyMHUEJKYuXcdIgaYYk/17rYQGwhgaeMEt97uEBsNgFHif6lJ1hBekUE3jBLNN17
        yw7iMAvcZ5T49ekFI0iVsICTxMn7k9hBbBYBVYn5Pb9YQGxeAWuJOW/XsUFskJdoX74dzOYU
        sJGYM/sfK8Q2a4kDy34yQtQLSpyc+YQF5DhmAXWJ9fOEQML8AloSa5qug41kBhrTvHU28wRG
        oVlIOmYhdMxCUrWAkXkVo0hqaXFuem6xoV5xYm5xaV66XnJ+7iZGYHxvO/Zz8w7Gea8+6h1i
        ZOJgPMQowcGsJMK7R21HghBvSmJlVWpRfnxRaU5q8SFGU6DPJjJLiSbnAxNMXkm8oZmBqaGJ
        maWBqaWZsZI479a5a+KFBNITS1KzU1MLUotg+pg4OKUamDauDXiQ8fTGzH+a1/ydys8L6vuV
        X9qQvs/0y6YtLJveygg+iU0yUwxQvTRvUbqTnRN/qYbon+Pe0nEeucvOr15tvyJGdA1XldRt
        G8YzC7Zs6P1gzu9YYqw4qUv/whXHecxs5/s/fciPO/H5Z/zRbetOvpsbbT/9avv0JXwa6b/u
        /dnzL2LxtRX8WW8PyZudtVwu2HzJIuPwteI5ehILZXVcpxpaalV/iijY38ShkHA8P15uKstr
        vilcr/Ytljszzf+ol6heD+8qV4EJUS8yOh/zd5dtV9/9+dCu4GTOpHaxpaUJ3uwrXiUZH5/1
        bNXGwB0hzXF2Xrs+dmrVHfr5TeaidFxy4ekp/as78spe1SixFGckGmoxFxUnAgCMjeZSeAMA
        AA==
X-CMS-MailID: 20210604100159eucas1p2834b960ee67a9ebd6057c7cef6dd5650
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20210604100159eucas1p2834b960ee67a9ebd6057c7cef6dd5650
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20210604100159eucas1p2834b960ee67a9ebd6057c7cef6dd5650
References: <20210604100148.17177-1-l.stelmach@samsung.com>
        <CGME20210604100159eucas1p2834b960ee67a9ebd6057c7cef6dd5650@eucas1p2.samsung.com>
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
index b868cefc7c55..cff3ed74bd80 100644
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
2.26.2

