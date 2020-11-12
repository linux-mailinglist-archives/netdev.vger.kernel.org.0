Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 694FA2B047C
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 12:56:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728061AbgKLL4T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 06:56:19 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:42410 "EHLO
        mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728253AbgKLLvk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Nov 2020 06:51:40 -0500
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
        by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id 20201112115124euoutp02e3e5125ecb454fdd9b088be344998814~GwGtD7WYt2695026950euoutp02x
        for <netdev@vger.kernel.org>; Thu, 12 Nov 2020 11:51:24 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com 20201112115124euoutp02e3e5125ecb454fdd9b088be344998814~GwGtD7WYt2695026950euoutp02x
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1605181884;
        bh=2/xwxcxYv93eq31jsT80VcmPFIBIhKVvX8Jx5pcXie8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lZk8cLimGfUtbaz1nyWHg3yHsbjF27M0pNdZDV7pm1KCpu9Tsx6v+SIDbnWl8lrxG
         sfx24Vs26D9mhgIbx+2HzufiOO1Q9eK83OgYL1Gnck+TSizFXcE7mr0Yu2VTeLm9nK
         XY3ZPwNdEw0Sxy9zE8XSjCsGlTOQREkYlSZ2nbD0=
Received: from eusmges2new.samsung.com (unknown [203.254.199.244]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTP id
        20201112115108eucas1p249708a1b219be6711e7dfbbe18bd7a38~GwGetHEGj1353813538eucas1p2N;
        Thu, 12 Nov 2020 11:51:08 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
        eusmges2new.samsung.com (EUCPMTA) with SMTP id BA.BF.44805.CA12DAF5; Thu, 12
        Nov 2020 11:51:08 +0000 (GMT)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
        20201112115108eucas1p1de47b5b010868d039759c0042ba5faaf~GwGeLhZRR1142711427eucas1p1d;
        Thu, 12 Nov 2020 11:51:08 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
        eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20201112115108eusmtrp25d0f2f9941f0cb0d5eadfd9582f9a224~GwGeKmTJd2331023310eusmtrp2h;
        Thu, 12 Nov 2020 11:51:08 +0000 (GMT)
X-AuditID: cbfec7f4-b4fff7000000af05-68-5fad21ac1839
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
        eusmgms1.samsung.com (EUCPMTA) with SMTP id 3E.79.21957.CA12DAF5; Thu, 12
        Nov 2020 11:51:08 +0000 (GMT)
Received: from localhost (unknown [106.120.51.46]) by eusmtip2.samsung.com
        (KnoxPortal) with ESMTPA id
        20201112115107eusmtip2930bb54e55ccf2ffdc17dcc3c383cd13~GwGd_NDal0631006310eusmtip2V;
        Thu, 12 Nov 2020 11:51:07 +0000 (GMT)
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
Subject: [PATCH v6 1/5] dt-bindings: vendor-prefixes: Add asix prefix
Date:   Thu, 12 Nov 2020 12:51:02 +0100
Message-Id: <20201112115106.16224-2-l.stelmach@samsung.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201112115106.16224-1-l.stelmach@samsung.com>
MIME-Version: 1.0
Organization: Samsung R&D Institute Poland
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrOKsWRmVeSWpSXmKPExsWy7djP87prFNfGG+xcqWxx/u4hZouNM9az
        Wsw538JiMf/IOVaLRe9nsFpce3uH1aL/8Wtmi/PnN7BbXNjWx2px89AKRotNj6+xWlzeNYfN
        Ysb5fUwWh6buZbRYe+Quu8WxBWIWrXuPsFv837OD3UHI4/K1i8weW1beZPLYOesuu8emVZ1s
        HpuX1Hvs3PGZyaNvyypGj8+b5AI4orhsUlJzMstSi/TtErgyDu96z1Lwk62i+8x51gbGn6xd
        jJwcEgImEk0//7N1MXJxCAmsYJRY1/+MGcL5wijx7GsXE4TzmVHieudNdpiW/6+/sUMkljNK
        nH/VDVX1nFFi1YV/YFVsAo4S/UtPsIIkRATuMUusb3/ACOIwC9xnlLj3fDUzSJWwgKvE6h9N
        jCA2i4CqxLHV85hAbF4Ba4lz709D7ZOXaF++nQ3E5hSwkVh68yI7RI2gxMmZT1hAbH4BLYk1
        TdfBbGag+uats8G+kBA4zCkxY/oJFohBLhIbXndD/S0s8er4FqgFMhL/d84HWswBZNdLTJ5k
        BtHbwyixbc4PqF5riTvnfrGB1DALaEqs36UPEXaU+Hv/FStEK5/EjbeCECfwSUzaNp0ZIswr
        0dEmBFGtAgzfPVADpSR6X61gnMCoNAvJM7OQPDALYdcCRuZVjOKppcW56anFRnmp5XrFibnF
        pXnpesn5uZsYgWnv9L/jX3YwLn/1Ue8QIxMH4yFGCQ5mJRFeZYc18UK8KYmVValF+fFFpTmp
        xYcYpTlYlMR5k7YApQTSE0tSs1NTC1KLYLJMHJxSDUwliTzx0104vLTON5/4t5Sf1b9Xbcdq
        v4fV4ow8G2c11VsKeLY/qis//2zBhFUVaXELczqbZI8ZxGzPeDPbYlJO3M797txtF3fP+vpo
        0ppnl+au3jDltOt0Dtf9LuIXlPXe5lhOcJf7+X5b/kr+v5Ni5hu8kJw13d39XLirpYf8ea+v
        +UGHmL+d3LCy+fD3aKZqobnFv79fyeeJSsmaMtdCkOPOrbwm5bXOvkcPKq2SvvGkQv/Viajr
        6e9u394r/m33uxLBWt65B85my9Vlrmg3qi26cGniZc4X6tyyBseVI+5yeB7xWHXXxvGYdtmh
        DNfM+L+u7w2uX58ZvSnk0aOSH6U/Tq47bmrOrXHcaZ6IEktxRqKhFnNRcSIA7iKK4uoDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrOIsWRmVeSWpSXmKPExsVy+t/xe7prFNfGG/y5xWJx/u4hZouNM9az
        Wsw538JiMf/IOVaLRe9nsFpce3uH1aL/8Wtmi/PnN7BbXNjWx2px89AKRotNj6+xWlzeNYfN
        Ysb5fUwWh6buZbRYe+Quu8WxBWIWrXuPsFv837OD3UHI4/K1i8weW1beZPLYOesuu8emVZ1s
        HpuX1Hvs3PGZyaNvyypGj8+b5AI4ovRsivJLS1IVMvKLS2yVog0tjPQMLS30jEws9QyNzWOt
        jEyV9O1sUlJzMstSi/TtEvQyDu96z1Lwk62i+8x51gbGn6xdjJwcEgImEv9ff2PvYuTiEBJY
        yiix+Mwzli5GDqCElMTKuekQNcISf651sUHUPGWUOHNwCwtIgk3AUaJ/6QlWkISIwBtmiaZ7
        b8EmMQvcZ5T49ekFI0iVsICrxOofTWA2i4CqxLHV85hAbF4Ba4lz70+zQ6yQl2hfvp0NxOYU
        sJFYevMiWFwIqKZ15md2iHpBiZMzn4BdxyygLrF+nhBImF9AS2JN03Wwg5iBxjRvnc08gVFo
        FpKOWQgds5BULWBkXsUoklpanJueW2yoV5yYW1yal66XnJ+7iREY49uO/dy8g3Heq496hxiZ
        OBgPMUpwMCuJ8Co7rIkX4k1JrKxKLcqPLyrNSS0+xGgK9NlEZinR5HxgkskriTc0MzA1NDGz
        NDC1NDNWEufdOheoSSA9sSQ1OzW1ILUIpo+Jg1OqgUk6xf77he0y6y7VhnoXb7+4dF5gi4nm
        5u0PbaJWP29czDoxdF6besSZ9Nvzdq+5dmjH3zP72OYa73Y5zReT4s0lf1rM22RzmbPuo76p
        k18l3+7d6FA6v/C1hoZm1bPe2ly2lUo8rsF2nYdk0xSXfa4J6CuWzhe7yK8bo5QwccXGDL5Z
        5UsPxfgz2bQwJNzMvTVxn6BH6Ju931o/3bZ6nnPyeVitWey9J1vtxWNebfHOOrHdbH/PRV+D
        y4uDI5W67Qsl/uw61rndf5FcWr34gdcPLu7c1DJ3fffNb4vnnzukmFuUMendyfg09dm/Lqvm
        FXG63Q33X8nHPXv9X4/5wtx/v9hEuvkseuWhqnr44xElluKMREMt5qLiRADeRUFoegMAAA==
X-CMS-MailID: 20201112115108eucas1p1de47b5b010868d039759c0042ba5faaf
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20201112115108eucas1p1de47b5b010868d039759c0042ba5faaf
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20201112115108eucas1p1de47b5b010868d039759c0042ba5faaf
References: <20201112115106.16224-1-l.stelmach@samsung.com>
        <CGME20201112115108eucas1p1de47b5b010868d039759c0042ba5faaf@eucas1p1.samsung.com>
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

