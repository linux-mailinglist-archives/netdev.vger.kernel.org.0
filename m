Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05F003D723B
	for <lists+netdev@lfdr.de>; Tue, 27 Jul 2021 11:43:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236153AbhG0Jnf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Jul 2021 05:43:35 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:54593 "EHLO
        mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235963AbhG0Jnc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Jul 2021 05:43:32 -0400
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
        by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id 20210727094331euoutp0281aba0069416338a98f521c1cfe2eb99~VnJbKrWJe0105401054euoutp02A
        for <netdev@vger.kernel.org>; Tue, 27 Jul 2021 09:43:31 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com 20210727094331euoutp0281aba0069416338a98f521c1cfe2eb99~VnJbKrWJe0105401054euoutp02A
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1627379011;
        bh=VErGY5qdV9zVaVkjQMdDQ5waCwYyh1jqVR+TGtLLEv0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tNsrPXoir4vW4zJ62yYvFCYNdIYm1f1kTEfxELfhWlizfgHPnTkbcIM0atH5He8Yd
         xbUe+RL0ms0euajobZfNzGiAtG9sJCa2HQ2T3hKtjwaFEgwPqEbbN48ZhbVnppkWvu
         CJv47yl5WhTMOQRqVM3YohZrroeArx3pvFWAzddU=
Received: from eusmges3new.samsung.com (unknown [203.254.199.245]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTP id
        20210727094330eucas1p20788a05ed30ffdc53106b083add3ddf2~VnJaY0Ol82664226642eucas1p2G;
        Tue, 27 Jul 2021 09:43:30 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
        eusmges3new.samsung.com (EUCPMTA) with SMTP id CF.60.56448.245DFF06; Tue, 27
        Jul 2021 10:43:30 +0100 (BST)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
        20210727094330eucas1p1b4de5e9ec74396bf381820025839fc30~VnJZ6Rf6y1958219582eucas1p1V;
        Tue, 27 Jul 2021 09:43:30 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
        eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20210727094330eusmtrp2dfe7f4baafa7f89d16284700d5275819~VnJZ5ePSs2985529855eusmtrp2D;
        Tue, 27 Jul 2021 09:43:30 +0000 (GMT)
X-AuditID: cbfec7f5-2e23aa800002dc80-30-60ffd5429682
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
        eusmgms2.samsung.com (EUCPMTA) with SMTP id 67.05.20981.245DFF06; Tue, 27
        Jul 2021 10:43:30 +0100 (BST)
Received: from localhost (unknown [106.120.51.46]) by eusmtip1.samsung.com
        (KnoxPortal) with ESMTPA id
        20210727094330eusmtip12e61f507af5235dbf90331f45312eb20~VnJZtOifC2613626136eusmtip1H;
        Tue, 27 Jul 2021 09:43:30 +0000 (GMT)
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
Subject: [PATCH net-next v15 1/3] dt-bindings: vendor-prefixes: Add asix
 prefix
Date:   Tue, 27 Jul 2021 11:43:23 +0200
Message-Id: <20210727094325.9189-2-l.stelmach@samsung.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210727094325.9189-1-l.stelmach@samsung.com>
MIME-Version: 1.0
Organization: Samsung R&D Institute Poland
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrCKsWRmVeSWpSXmKPExsWy7djP87pOV/8nGFz4aG5x/u4hZouNM9az
        Wsw538JiMf/IOVaLRe9nsFpce3uH1aL/8Wtmi/PnN7BbXNjWx2px89AKRotNj6+xWlzeNYfN
        Ysb5fUwWh6buZbRYe+Quu8WxBWIWrXuPsFv837OD3UHI4/K1i8weW1beZPLYOesuu8emVZ1s
        HpuX1Hvs3PGZyaNvyypGj8+b5AI4orhsUlJzMstSi/TtErgyZjx+yFTwk61i5bl3LA2MP1m7
        GDk4JARMJBbM4e9i5OIQEljBKNF46jM7hPOFUaKtuYkVwvnMKDHl+WS2LkZOsI45z7ZDJZYz
        Sjx8/ZEZwnnOKHHvwCJGkCo2AUeJ/qUnwKpEBO4xS6xvf8AI4jAL3Aeqer6aGaRKWCBQ4sb/
        qewgl7AIqEqcu6QGEuYVsJKYfest1Dp5ifbl28FsTgFriaauVnaIGkGJkzOfsIDY/AJaEmua
        roPZzED1zVtng10kIbCfU+L7keUsEINcJH58/8wIYQtLvDq+hR3ClpH4v3M+EyQ06iUmTzKD
        6O1hlNg25wdUr7XEnXO/2EBqmAU0Jdbv0ocod5SYPNkewuSTuPFWEOICPolJ26YzQ4R5JTra
        hCBmqEis698DNU9KovfVCsYJjEqzkPwyC8n9sxBWLWBkXsUonlpanJueWmycl1quV5yYW1ya
        l66XnJ+7iRGY8E7/O/51B+OKVx/1DjEycTAeYpTgYFYS4XVY8TtBiDclsbIqtSg/vqg0J7X4
        EKM0B4uSOO+urWvihQTSE0tSs1NTC1KLYLJMHJxSDUytLvfNjx1O+vvhr9a6pWukBLT9rs99
        MsnX/Z31l+biPwFzL7+UuMUs/+qD5l29OXoHjhtLMSW/V9n05LWcDcuFL+t8+tZfy6+wYX1j
        WPQqXuLE3Nvn65W877h/Xn9g+c2qOUE3PNkvnOetPKyxPbputnz6PvuQyU0TImWfhnGI/5D+
        r2WUx7hsm4DY3Zsa1/ybfUJPM9h6fLFxY7nzKM/lUxFjRuxUhnfBMqcj8nRcN3aZtdctca10
        bVJyu69ytjSoZYPf+c1/OhxNxX8fWvqEwUhvZfLC/llq19ycDcQSA2SD9ug3fXJkuHpWs3bR
        1J1sjZdamI6eVVM99CpoYvOu18qnV7eyf9uYu4VnywolluKMREMt5qLiRAB0OEqe5wMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrGIsWRmVeSWpSXmKPExsVy+t/xu7pOV/8nGEx9KWFx/u4hZouNM9az
        Wsw538JiMf/IOVaLRe9nsFpce3uH1aL/8Wtmi/PnN7BbXNjWx2px89AKRotNj6+xWlzeNYfN
        Ysb5fUwWh6buZbRYe+Quu8WxBWIWrXuPsFv837OD3UHI4/K1i8weW1beZPLYOesuu8emVZ1s
        HpuX1Hvs3PGZyaNvyypGj8+b5AI4ovRsivJLS1IVMvKLS2yVog0tjPQMLS30jEws9QyNzWOt
        jEyV9O1sUlJzMstSi/TtEvQyZjx+yFTwk61i5bl3LA2MP1m7GDk5JARMJOY82w5kc3EICSxl
        lLjT0sPWxcgBlJCSWDk3HaJGWOLPtS42iJqnjBK9Xz6ANbMJOEr0Lz0B1iwi8IZZouneW3YQ
        h1ngPqPEr08vGEGqhAX8Jc5tes0CMpVFQFXi3CU1kDCvgJXE7Ftv2SA2yEu0L98OZnMKWEs0
        dbWyg9hCQDUdXZdZIOoFJU7OfAI2hllAXWL9PCGQML+AlsSaputgJcxAY5q3zmaewCg0C0nH
        LISOWUiqFjAyr2IUSS0tzk3PLTbSK07MLS7NS9dLzs/dxAiM8G3Hfm7Zwbjy1Ue9Q4xMHIyH
        GCU4mJVEeB1W/E4Q4k1JrKxKLcqPLyrNSS0+xGgK9NhEZinR5HxgiskriTc0MzA1NDGzNDC1
        NDNWEuc1ObImXkggPbEkNTs1tSC1CKaPiYNTqoFp7/bLJamveQOK3kjMtzug3nbsYP3HmfuD
        V58vMdbfyvz1l2WwVFfJc+XD68yTWzP6+/d4ON24+c55UhODS8+KQisprpNtq/euzJDO23so
        tm3LRO4Vz92XLW1azKnI2RWU/HbH6r9eQrovBXW3qrpd8/nMz6KxXHZfA/vEB9Fx5xsfsgs4
        VKkUvjff2/5v8pKtG9YYrwz6Nfs4U68QT9Il8aO3DcoOJZVL7TCerbEr0bDGNdZKfoah/f2L
        221SvjwXmKlTflJaqt+/N63h4JUpL/Ql9kY+6Sr5843f6WugfLXnrgafq4c3inBsfTZfykLb
        KXwh6/93v36U3/Y58v1czhYZVn115miF/1w/prcpsRRnJBpqMRcVJwIAgfgQv3kDAAA=
X-CMS-MailID: 20210727094330eucas1p1b4de5e9ec74396bf381820025839fc30
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20210727094330eucas1p1b4de5e9ec74396bf381820025839fc30
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20210727094330eucas1p1b4de5e9ec74396bf381820025839fc30
References: <20210727094325.9189-1-l.stelmach@samsung.com>
        <CGME20210727094330eucas1p1b4de5e9ec74396bf381820025839fc30@eucas1p1.samsung.com>
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

