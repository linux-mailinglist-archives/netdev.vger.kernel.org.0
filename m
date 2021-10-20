Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18740435299
	for <lists+netdev@lfdr.de>; Wed, 20 Oct 2021 20:24:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231216AbhJTS0q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Oct 2021 14:26:46 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:17811 "EHLO
        mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230381AbhJTS0o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Oct 2021 14:26:44 -0400
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
        by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id 20211020182428euoutp0289b9ea88e7a1783260c32362187f8067~v0FiIII9n2775327753euoutp02U
        for <netdev@vger.kernel.org>; Wed, 20 Oct 2021 18:24:28 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com 20211020182428euoutp0289b9ea88e7a1783260c32362187f8067~v0FiIII9n2775327753euoutp02U
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1634754268;
        bh=HnitCYaja0dwcrAEA7k5MibO/pq6vQ+8ynA45vV9VFE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GFmrTD9mOKExnOLIbdQm4zTpPDinYWz+Yc1AHCVZ77e/5h8zRrMqpJx5tLleD3WfQ
         VqDu9e8hsMw/g8hleVyfyZRQvapdJUEU8Ht/TsoE9JTY9JciWw+f/m+77hK0je9BeT
         fULeQVE81c+Vtme0Bx/pbO8y+e51WyK4ZR6XvvPE=
Received: from eusmges1new.samsung.com (unknown [203.254.199.242]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTP id
        20211020182427eucas1p1d36495d23671b88bcf4d194d9d8182d6~v0Fhsaylf2022720227eucas1p14;
        Wed, 20 Oct 2021 18:24:27 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
        eusmges1new.samsung.com (EUCPMTA) with SMTP id 12.5F.45756.BDE50716; Wed, 20
        Oct 2021 19:24:27 +0100 (BST)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
        20211020182427eucas1p24d9415282c7310db08b449e4a9f431d1~v0FhPaiGt1699416994eucas1p2_;
        Wed, 20 Oct 2021 18:24:27 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
        eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20211020182427eusmtrp18d9fcb91f892d9c81d1cd1dd1eedada4~v0FhLj3vO2102421024eusmtrp1s;
        Wed, 20 Oct 2021 18:24:27 +0000 (GMT)
X-AuditID: cbfec7f2-7bdff7000002b2bc-36-61705edbd93f
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
        eusmgms1.samsung.com (EUCPMTA) with SMTP id 29.CE.31287.BDE50716; Wed, 20
        Oct 2021 19:24:27 +0100 (BST)
Received: from localhost (unknown [106.120.51.46]) by eusmtip1.samsung.com
        (KnoxPortal) with ESMTPA id
        20211020182427eusmtip19a8d4c2fa3ccb341c6d7f06410a9ac8d~v0Fg6DSZI2087820878eusmtip1d;
        Wed, 20 Oct 2021 18:24:27 +0000 (GMT)
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
Subject: [PATCH net-next v17 1/3] dt-bindings: vendor-prefixes: Add asix
 prefix
Date:   Wed, 20 Oct 2021 20:24:20 +0200
Message-Id: <20211020182422.362647-2-l.stelmach@samsung.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211020182422.362647-1-l.stelmach@samsung.com>
MIME-Version: 1.0
Organization: Samsung R&D Institute Poland
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrGKsWRmVeSWpSXmKPExsWy7djPc7q34woSDXbs0rM4f/cQs8XGGetZ
        Leacb2GxmH/kHKvFovczWC2uvb3DatH/+DWzxfnzG9gtLmzrY7W4eWgFo8Wmx9dYLS7vmsNm
        MeP8PiaLQ1P3MlqsPXKX3eLYAjGL1r1H2C3+79nB7iDkcfnaRWaPLStvMnnsnHWX3WPTqk42
        j81L6j127vjM5NG3ZRWjx+dNcgEcUVw2Kak5mWWpRfp2CVwZP6b8Yin4yVYxZ990tgbGn6xd
        jJwcEgImEhvan7F3MXJxCAmsYJR4tnIqlPOFUWJH92QmCOczo8S8qXeYYFq6mtayQSSWM0p8
        WfWTEcJ5zigx+/pjNpAqNgFHif6lJ1hBEiIC95glPh07DtbCLHCfUeLe89XMXYwcHMICgRKH
        F6WDNLAIqEp8mvMLrJlXwEbi/eTPzBDr5CXark9nBLE5BWwluhf1MkPUCEqcnPmEBcTmF9CS
        WNN0HcxmBqpv3jqbGWSXhMB+Tonmpd9ZIAa5SNy41AH1g7DEq+Nb2CFsGYnTk3tYQO6REKiX
        mDzJDKK3h1Fi25wfUL3WEnfOgRzHAbRAU2L9Ln2IsKPE4c1LmSFa+SRuvBWEOIFPYtK26VBh
        XomONiGIahWJdf17oAZKSfS+WsE4gVFpFpJnZiF5YBbCrgWMzKsYxVNLi3PTU4sN81LL9YoT
        c4tL89L1kvNzNzECk97pf8c/7WCc++qj3iFGJg7GQ4wSHMxKIry7K/IThXhTEiurUovy44tK
        c1KLDzFKc7AoifOumr0mXkggPbEkNTs1tSC1CCbLxMEp1cCUGyKZVOEfzOV0WKh2+ayV2+be
        3iPJ6b8pT0awv5v797XZHsHKEbeqnGdXOX/UE+x6dyO+78uur3a1+/NXO0py6H04wq03SU7n
        kNyvkyKzT0TqTLtwSS5tk+6VW8tKRHt2zb33ukft7nmGKLNn5Z2y8Z6pjNOL6+YwqX9802my
        +sUBz+LHkesu2/T1vPN5KZjp/Nz7Y1JBgeY7Nik71dCJHfzPf9YvME3xvPqWfTrLx4PTEwUX
        10nrq8xbatMp/+DEj/oFMt63Ht5f7XjvWbnMvGUKHi/8U0w6SpcoO0w6EeikJHzXCBjA1wP1
        /7xk+fjY8Px6peJf5VJcb2dWfLt0ciWvf9aqpHbxVu/ffEosxRmJhlrMRcWJAM85o2npAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrGIsWRmVeSWpSXmKPExsVy+t/xu7q34woSDfaf5bE4f/cQs8XGGetZ
        Leacb2GxmH/kHKvFovczWC2uvb3DatH/+DWzxfnzG9gtLmzrY7W4eWgFo8Wmx9dYLS7vmsNm
        MeP8PiaLQ1P3MlqsPXKX3eLYAjGL1r1H2C3+79nB7iDkcfnaRWaPLStvMnnsnHWX3WPTqk42
        j81L6j127vjM5NG3ZRWjx+dNcgEcUXo2RfmlJakKGfnFJbZK0YYWRnqGlhZ6RiaWeobG5rFW
        RqZK+nY2Kak5mWWpRfp2CXoZP6b8Yin4yVYxZ990tgbGn6xdjJwcEgImEl1Na9m6GLk4hASW
        Mkr8PzSDvYuRAyghJbFybjpEjbDEn2tdUDVPGSWe/upjA0mwCThK9C89ATZIROANs8TPXimQ
        ImaB+4wSvz69YARJCAv4S3z+PRvMZhFQlfg05xdYM6+AjcT7yZ+ZITbIS7Rdnw5WwylgK9G9
        qBcsLgRUc23Xeah6QYmTM5+wgBzHLKAusX6eEEiYX0BLYk3TdRYQmxloTPPW2cwTGIVmIemY
        hdAxC0nVAkbmVYwiqaXFuem5xYZ6xYm5xaV56XrJ+bmbGIERvu3Yz807GOe9+qh3iJGJg/EQ
        owQHs5II7+6K/EQh3pTEyqrUovz4otKc1OJDjKZAn01klhJNzgemmLySeEMzA1NDEzNLA1NL
        M2Mlcd6tc9fECwmkJ5akZqemFqQWwfQxcXBKNTDl/dj7beOeuMklaQrmPZIxDswHP+z4fTRG
        aemerdt7TY7UbP+0eE8ok7xOr9bu049zYmK0CvYY6E9uXbxZU/6i6MyihcvbKyLyJkpoNKg1
        r3x6cqv324kv9tjGe3dsq9z5aHPQqY0GB9JfK2mH2t56X36xVjXpsPSuV67znUNzBb7dcpn7
        O7jy1qqkycrv5aR1Oe663D2Uol38Ymml1vR9dxY9s3Yz/8bfbOyaV2bTs3y/7g9L58dJGzPC
        I6d5v9vf27U78+ThIzVxUiFd9s9cCspT8u6GeJesCcrw+dAv/HfBDcburSu4Di/sjXsbIhm3
        eX3uz7fzAnd9CfN5xbT0wnYeExfeRZIxvRkfXQyUWIozEg21mIuKEwEVD5UzeQMAAA==
X-CMS-MailID: 20211020182427eucas1p24d9415282c7310db08b449e4a9f431d1
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20211020182427eucas1p24d9415282c7310db08b449e4a9f431d1
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20211020182427eucas1p24d9415282c7310db08b449e4a9f431d1
References: <20211020182422.362647-1-l.stelmach@samsung.com>
        <CGME20211020182427eucas1p24d9415282c7310db08b449e4a9f431d1@eucas1p2.samsung.com>
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

