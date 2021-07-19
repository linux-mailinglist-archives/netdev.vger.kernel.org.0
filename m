Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2DCE3CEDC2
	for <lists+netdev@lfdr.de>; Mon, 19 Jul 2021 22:31:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1386946AbhGSToP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Jul 2021 15:44:15 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:50750 "EHLO
        mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1385149AbhGSStM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Jul 2021 14:49:12 -0400
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
        by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20210719192915euoutp0139e24a484f9b39f18d36a49b760c0d6d~TR_irGzZG1234812348euoutp01F
        for <netdev@vger.kernel.org>; Mon, 19 Jul 2021 19:29:15 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20210719192915euoutp0139e24a484f9b39f18d36a49b760c0d6d~TR_irGzZG1234812348euoutp01F
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1626722955;
        bh=VErGY5qdV9zVaVkjQMdDQ5waCwYyh1jqVR+TGtLLEv0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eb0pAPbQrUeUEiznEevBp+9Y+JMqIbH2MZBfdRC1rb2GFKzX78dwf070lAlqNAD6/
         epUbUeuO1afjSqs+ZxGtbCchDuLbVSYnsk05jo7cFOZgZG8kYcZazAZTaWItQTVFlJ
         8Oh+3ToZqOiesksZPO/EAJCKzLLsJZNhsOj45X90=
Received: from eusmges2new.samsung.com (unknown [203.254.199.244]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTP id
        20210719192914eucas1p18dea0743056964fc25b3a531af154713~TR_iIlCj52584525845eucas1p1J;
        Mon, 19 Jul 2021 19:29:14 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
        eusmges2new.samsung.com (EUCPMTA) with SMTP id 11.12.42068.A82D5F06; Mon, 19
        Jul 2021 20:29:14 +0100 (BST)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
        20210719192913eucas1p1dfd7dff3ca85db20ce638c9355b41ada~TR_g7vEdY2582325823eucas1p1-;
        Mon, 19 Jul 2021 19:29:13 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
        eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20210719192913eusmtrp193c78bdbe26bf4d5d1896394569d04a2~TR_g6xnVy0947609476eusmtrp1s;
        Mon, 19 Jul 2021 19:29:13 +0000 (GMT)
X-AuditID: cbfec7f4-c89ff7000002a454-89-60f5d28a5cc2
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
        eusmgms1.samsung.com (EUCPMTA) with SMTP id 09.6B.31287.982D5F06; Mon, 19
        Jul 2021 20:29:13 +0100 (BST)
Received: from localhost (unknown [106.120.51.46]) by eusmtip1.samsung.com
        (KnoxPortal) with ESMTPA id
        20210719192912eusmtip1bf974b4d84ea2ba903394694db30d860~TR_gt5ON31435214352eusmtip1c;
        Mon, 19 Jul 2021 19:29:12 +0000 (GMT)
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
Subject: [PATCH net-next v14 1/3] dt-bindings: vendor-prefixes: Add asix
 prefix
Date:   Mon, 19 Jul 2021 21:28:50 +0200
Message-Id: <20210719192852.27404-2-l.stelmach@samsung.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210719192852.27404-1-l.stelmach@samsung.com>
MIME-Version: 1.0
Organization: Samsung R&D Institute Poland
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrGKsWRmVeSWpSXmKPExsWy7djPc7pdl74mGOzeLWFx/u4hZouNM9az
        Wsw538JiMf/IOVaLRe9nsFpce3uH1aL/8Wtmi/PnN7BbXNjWx2px89AKRotNj6+xWlzeNYfN
        Ysb5fUwWh6buZbRYe+Quu8WxBWIWrXuPsFv837OD3UHI4/K1i8weW1beZPLYOesuu8emVZ1s
        HpuX1Hvs3PGZyaNvyypGj8+b5AI4orhsUlJzMstSi/TtErgyZjx+yFTwk61i5bl3LA2MP1m7
        GDk5JARMJC6vmsgGYgsJrGCUeLHAqouRC8j+wihx9+IeJgjnM6NEy/xuZpiO7vvLWCASyxkl
        tlzcxArhPGeU2PRjElgVm4CjRP/SE2AJEYF7zBLr2x8wgjjMAvcZJe49Xw1WJSwQKDHr3Bkw
        m0VAVeLrrO8sIDavgLXEmQszWCD2yUu0L98OdiGngI3E3A9P2CBqBCVOznwCVsMvoCWxpuk6
        mM0MVN+8dTYzyDIJgcOcEvc2/2KHGOQicebPJyhbWOLV8S1QtozE6ck9QM0cQHa9xORJZhC9
        PYwS2+b8gDrCWuLOuV9sIDXMApoS63fpQ4QdJfb8/s4I0conceOtIMQJfBKTtk1nhgjzSnS0
        CUFUq0is698DNVBKovfVCsYJjEqzkDwzC8kDsxB2LWBkXsUonlpanJueWmyUl1quV5yYW1ya
        l66XnJ+7iRGY9E7/O/5lB+PyVx/1DjEycTAeYpTgYFYS4VUp+pogxJuSWFmVWpQfX1Sak1p8
        iFGag0VJnDdpy5p4IYH0xJLU7NTUgtQimCwTB6dUA5OQ3Nnrhiek5h00itHksFEt1udrft8e
        c9T1It/VsI0zUoSO3OqUX2ywcd/j96az1IWXdE8yXXSzcP3X4rji2gOKt+VLJRtX9kUzHHgW
        6vY+9UJ//M9Lj1RFOQ5+eB0+75Og0nfXxSzX225sCud8bbPZa5k5a37y3ldT+Sxu2s1KFHLb
        O/9Bp6Ipg75Y5qY1n1ev2ha10fuW6t9d4VdD3ebaZL0O2l/qlXb06u3y3NwWjwiTk4bWtyV/
        tRSe5J7z1UDLdsrtzgMvF3WmF7x8XrJK99p0heULbN1+RvduTbm2IqRwf+fV5zUV6zOWnGVZ
        GMv3ZtctmVdKfBUfLmsHpOTv38Twce791/1z9z1ufGWsxFKckWioxVxUnAgA3JE6X+kDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrGIsWRmVeSWpSXmKPExsVy+t/xu7qdl74mGFy9zmpx/u4hZouNM9az
        Wsw538JiMf/IOVaLRe9nsFpce3uH1aL/8Wtmi/PnN7BbXNjWx2px89AKRotNj6+xWlzeNYfN
        Ysb5fUwWh6buZbRYe+Quu8WxBWIWrXuPsFv837OD3UHI4/K1i8weW1beZPLYOesuu8emVZ1s
        HpuX1Hvs3PGZyaNvyypGj8+b5AI4ovRsivJLS1IVMvKLS2yVog0tjPQMLS30jEws9QyNzWOt
        jEyV9O1sUlJzMstSi/TtEvQyZjx+yFTwk61i5bl3LA2MP1m7GDk5JARMJLrvL2PpYuTiEBJY
        yijxbM1BoAQHUEJKYuXcdIgaYYk/17rYIGqeMkosO9rNApJgE3CU6F96ghUkISLwhlmi6d5b
        dhCHWeA+o8SvTy8YQaqEBfwlTtw4zgZiswioSnyd9R2sm1fAWuLMhRksECvkJdqXbwer4RSw
        kZj74QkbyBVCQDWrdwdAlAtKnJz5hAUkzCygLrF+nhBImF9AS2JN03WwKcxAU5q3zmaewCg0
        C0nHLISOWUiqFjAyr2IUSS0tzk3PLTbUK07MLS7NS9dLzs/dxAiM8G3Hfm7ewTjv1Ue9Q4xM
        HIyHGCU4mJVEeFWKviYI8aYkVlalFuXHF5XmpBYfYjQFemwis5Rocj4wxeSVxBuaGZgamphZ
        GphamhkrifNunbsmXkggPbEkNTs1tSC1CKaPiYNTqoGpTk+IXzR060d+EYPothBW/QfCh70Z
        Jm5fumlyQNrhdPXQLYGJi9XOOwUEXH6hfaxjSlBAvYpBgPW3N6+EwsOnrbN/wORqxbAman2c
        1V+ujMf8JRkL1wee9BfwyjsrrLX6bOMb85s+rcv/d35Kaapayq6oEnKP20T3chhrQrL9l5gX
        8ZV771lqJd1h+Z+4IzF61o78qU92h1q+4Gh85n7CUvCqnPqmkK87Vt4MOC7x/mdTRdXt70sv
        h9xq2/NtjaXaibjdJU48paefZJ5Per/CUr6fPURW688579WHdx8+9G9B2N649C0WqyqDUrRn
        J5vx1RZafZK219u376Cp7YfAtvhLaWqtgvouD99KPVdiKc5INNRiLipOBADHI3TxeQMAAA==
X-CMS-MailID: 20210719192913eucas1p1dfd7dff3ca85db20ce638c9355b41ada
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20210719192913eucas1p1dfd7dff3ca85db20ce638c9355b41ada
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20210719192913eucas1p1dfd7dff3ca85db20ce638c9355b41ada
References: <20210719192852.27404-1-l.stelmach@samsung.com>
        <CGME20210719192913eucas1p1dfd7dff3ca85db20ce638c9355b41ada@eucas1p1.samsung.com>
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
index 07fb0d25fc15..91b5e591746f 100644
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

