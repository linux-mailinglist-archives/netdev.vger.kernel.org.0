Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 023D22F5284
	for <lists+netdev@lfdr.de>; Wed, 13 Jan 2021 19:43:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728648AbhAMSl1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jan 2021 13:41:27 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:37584 "EHLO
        mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728444AbhAMSl0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jan 2021 13:41:26 -0500
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
        by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20210113184043euoutp012cace0aaa09a777ec7b4acfe30e991e5~Z3ryu3W-60644406444euoutp01U
        for <netdev@vger.kernel.org>; Wed, 13 Jan 2021 18:40:43 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20210113184043euoutp012cace0aaa09a777ec7b4acfe30e991e5~Z3ryu3W-60644406444euoutp01U
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1610563243;
        bh=2/xwxcxYv93eq31jsT80VcmPFIBIhKVvX8Jx5pcXie8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DP77KgYLHNlzE87yW2KDZQWZVaMboS6KNf8cRpBCEOs3eEEkAELiylsUyofDNKt66
         ut25YvraOytp3w+vKd71sRv4UWVVZg0JTfzBX7E7MXtTd6cE1YR2W4Pzj1dhgTl77O
         yM0yA9aJYWqzzaIRafrxcZk7jj+6R2Xh3i+ju174=
Received: from eusmges2new.samsung.com (unknown [203.254.199.244]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTP id
        20210113184043eucas1p21ebe48f5338fe4dbf22b2346f8d4c71b~Z3ryQipuj1707417074eucas1p2Z;
        Wed, 13 Jan 2021 18:40:43 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
        eusmges2new.samsung.com (EUCPMTA) with SMTP id 30.A3.44805.BAE3FFF5; Wed, 13
        Jan 2021 18:40:43 +0000 (GMT)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
        20210113184042eucas1p229cbf2f5e02893b7f1e60c87093aa423~Z3rxVfxZl1701117011eucas1p2o;
        Wed, 13 Jan 2021 18:40:42 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
        eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20210113184042eusmtrp150dd369d4ca8206fa058f8f0926c2ea8~Z3rxUw9rx2007620076eusmtrp1R;
        Wed, 13 Jan 2021 18:40:42 +0000 (GMT)
X-AuditID: cbfec7f4-b37ff7000000af05-89-5fff3eab372c
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
        eusmgms2.samsung.com (EUCPMTA) with SMTP id 59.B7.16282.AAE3FFF5; Wed, 13
        Jan 2021 18:40:42 +0000 (GMT)
Received: from localhost (unknown [106.120.51.46]) by eusmtip2.samsung.com
        (KnoxPortal) with ESMTPA id
        20210113184041eusmtip21d8bc379a2c23cc5fb39f908636f2cf5~Z3rxDukyv1789617896eusmtip2X;
        Wed, 13 Jan 2021 18:40:41 +0000 (GMT)
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
Subject: [PATCH v10 1/3] dt-bindings: vendor-prefixes: Add asix prefix
Date:   Wed, 13 Jan 2021 19:40:26 +0100
Message-Id: <20210113184028.4433-2-l.stelmach@samsung.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210113184028.4433-1-l.stelmach@samsung.com>
MIME-Version: 1.0
Organization: Samsung R&D Institute Poland
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrCKsWRmVeSWpSXmKPExsWy7djP87qr7f7HGyybyWZx/u4hZouNM9az
        Wsw538JiMf/IOVaLRe9nsFpce3uH1aL/8Wtmi/PnN7BbXNjWx2px89AKRotNj6+xWlzeNYfN
        Ysb5fUwWh6buZbRYe+Quu8WxBWIWrXuPsFv837OD3UHI4/K1i8weW1beZPLYOesuu8emVZ1s
        HpuX1Hvs3PGZyaNvyypGj8+b5AI4orhsUlJzMstSi/TtErgyDu96z1Lwk62i+8x51gbGn6xd
        jJwcEgImEudmfWYDsYUEVjBKzG4v7GLkArK/MEp0zZrODOF8ZpTYcKqTEaZj9okT7BCJ5YwS
        U9e/ZoFof84ocW9BFYjNJuAo0b/0BCtIkYjAPWaJ9e0PGEEcZoH7QEXPVzODVAkLuElMfPcR
        zGYRUJVY+bsNbAWvgJVEf/MxZoh18hLty7eDHcgpYC2x5kcvE0SNoMTJmU/ANvMLaEmsaboO
        ZjMD1TdvnQ3Vu59T4suEaAjbRWJlbzcbhC0s8er4FnYIW0bi9OQeoF4OILteYvIkM5A7JQR6
        GCW2zfnBAlFjLXHn3C82kBpmAU2J9bv0IcKOElsOXWaDaOWTuPFWEOICPolJ20AhBxLmleho
        E4KoVpFY178HaqCURO+rFYwTGJVmIfllFpL7ZyHsWsDIvIpRPLW0ODc9tdgoL7Vcrzgxt7g0
        L10vOT93EyMw4Z3+d/zLDsblrz7qHWJk4mA8xCjBwawkwlvU/TdeiDclsbIqtSg/vqg0J7X4
        EKM0B4uSOG/SljXxQgLpiSWp2ampBalFMFkmDk6pBqaiQMN7BwPm7Jv/3jbs6vyaCoent2VC
        JgS2r8rN3LH244xbrousDbdsWPtBy0Z1jXrKZO0WS4XlpqIyW22enlC7dqeM4Wh09ecPRyO6
        jrkGd106obGwhN3tyXnOY3INgY/m7LUu+/st22DdswOyLrPWzgMafPyQx4GOV48Y/1sErE3y
        f/LFhPM/M8tlHj+mBM3d/tZM1UFXY99P3srQVLWmOMStzyF4peLedW7RLyZ/69ifs1Os1qrl
        xRQbq/N+JhwdJ3N+7N1y+Oi842LMu31vbo+X13dQ/ujVMzvqZd5pNWXLvlbvSZ15OuenySZK
        FJ3+cHqKtVfNPE37iYKhlXXtx869XbbFxSaT5xCvjRJLcUaioRZzUXEiAG4CRRTnAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrGIsWRmVeSWpSXmKPExsVy+t/xe7qr7P7HG/z4x2xx/u4hZouNM9az
        Wsw538JiMf/IOVaLRe9nsFpce3uH1aL/8WugkvMb2C0ubOtjtbh5aAWjxabH11gtLu+aw2Yx
        4/w+JotDU/cyWqw9cpfd4tgCMYvWvUfYLf7v2cHuIORx+dpFZo8tK28yeeycdZfdY9OqTjaP
        zUvqPXbu+Mzk0bdlFaPH501yARxRejZF+aUlqQoZ+cUltkrRhhZGeoaWFnpGJpZ6hsbmsVZG
        pkr6djYpqTmZZalF+nYJehmHd71nKfjJVtF95jxrA+NP1i5GTg4JAROJ2SdOsHcxcnEICSxl
        lLj3YSNLFyMHUEJKYuXcdIgaYYk/17rYQGwhgaeMEme2cYLYbAKOEv1LT7CC9IoIvGGWaLr3
        FmwQs8B9Rolfn14wglQJC7hJTHz3kRnEZhFQlVj5uw0szitgJdHffIwZYoO8RPvy7WAbOAWs
        Jdb86GWC2GYl8WZhCwtEvaDEyZlPwI5jFlCXWD9PCCTML6AlsabpOlgJM9CY5q2zmScwCs1C
        0jELoWMWkqoFjMyrGEVSS4tz03OLjfSKE3OLS/PS9ZLzczcxAiN827GfW3Ywrnz1Ue8QIxMH
        4yFGCQ5mJRHeou6/8UK8KYmVValF+fFFpTmpxYcYTYE+m8gsJZqcD0wxeSXxhmYGpoYmZpYG
        ppZmxkrivCZH1sQLCaQnlqRmp6YWpBbB9DFxcEo1MJWXH5zm/KjroUy7p+RKlu/7ek3/aEXL
        ynMkrpBguv1D7hJTw8lJH8tEwxTlP52YdpO55va+xl1b4ufy6AoE2Rzw8jhhc3fq97/umzNa
        EzV385jmvdvvX+MuPD1xg75F1Yz8lFaB2nfPg1nKox7smNXSmp17NjemO+XulzbxQ9s67e4J
        2TzUeBSrPz3/1q8n+9+kWHFIM+55m7iCu+Lv/PPxEw53Hby488Mn2QUnl7168ljlk8hp8QO+
        Jnas6ZwnbDStww+Hs/NpSDHwV69YXFY885LCf6Xc3r6ptgtrNWM9Ap46FbSWvz2RwRx+o/D7
        Cn/u0A1nONMWy96eGzP585dfwjHWm2quxXBsmZz/VomlOCPRUIu5qDgRAPJwcUF5AwAA
X-CMS-MailID: 20210113184042eucas1p229cbf2f5e02893b7f1e60c87093aa423
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20210113184042eucas1p229cbf2f5e02893b7f1e60c87093aa423
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20210113184042eucas1p229cbf2f5e02893b7f1e60c87093aa423
References: <20210113184028.4433-1-l.stelmach@samsung.com>
        <CGME20210113184042eucas1p229cbf2f5e02893b7f1e60c87093aa423@eucas1p2.samsung.com>
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
index 2735be1a8470..ce3b3f6c9728 100644
--- a/Documentation/devicetree/bindings/vendor-prefixes.yaml
+++ b/Documentation/devicetree/bindings/vendor-prefixes.yaml
@@ -117,6 +117,8 @@ patternProperties:
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

