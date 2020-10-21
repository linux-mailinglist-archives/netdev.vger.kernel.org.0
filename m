Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCDD5295478
	for <lists+netdev@lfdr.de>; Wed, 21 Oct 2020 23:50:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2506460AbgJUVuC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Oct 2020 17:50:02 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:57523 "EHLO
        mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2506450AbgJUVuC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Oct 2020 17:50:02 -0400
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
        by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id 20201021214945euoutp0299d725a83d306db78b7651d23377ae6e~AIE2c7ImK2062820628euoutp02s
        for <netdev@vger.kernel.org>; Wed, 21 Oct 2020 21:49:45 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com 20201021214945euoutp0299d725a83d306db78b7651d23377ae6e~AIE2c7ImK2062820628euoutp02s
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1603316985;
        bh=cA3Bofiv/v8PkhnuY5IxtSknNMGYNI7yHBAcfsXGw/4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cptx2KLOv5beiLs6ObevZtfXZJSzGDH6aJp7kMstzYynsUKHv+928YiZsIdHMYuLR
         1nr7KkcuZhqAEXqUNiatTocZA/hooYxmx1gRDZ8ZZsMbbkEUOa3bv7hDV+1LbOEEXY
         TCCxGOYrPT+9UmlMLGzSa8Dllger7jxtPpVp4Zds=
Received: from eusmges1new.samsung.com (unknown [203.254.199.242]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTP id
        20201021214933eucas1p1406a48e12b5516ebab2b762cc95d88c0~AIEr2lrMh1894518945eucas1p1r;
        Wed, 21 Oct 2020 21:49:33 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
        eusmges1new.samsung.com (EUCPMTA) with SMTP id 4F.ED.06456.DECA09F5; Wed, 21
        Oct 2020 22:49:33 +0100 (BST)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
        20201021214933eucas1p26e8ee82f237e977e8b3324145a929a1a~AIErRQng32698826988eucas1p2e;
        Wed, 21 Oct 2020 21:49:33 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
        eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20201021214933eusmtrp12aa83d8ed0e50992f8354579fcadb616~AIErQdWa41537015370eusmtrp1j;
        Wed, 21 Oct 2020 21:49:33 +0000 (GMT)
X-AuditID: cbfec7f2-809ff70000001938-3b-5f90aced32ae
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
        eusmgms2.samsung.com (EUCPMTA) with SMTP id 8A.E4.06017.CECA09F5; Wed, 21
        Oct 2020 22:49:32 +0100 (BST)
Received: from localhost (unknown [106.120.51.46]) by eusmtip1.samsung.com
        (KnoxPortal) with ESMTPA id
        20201021214932eusmtip1473138d9c22d5ce35592e7269967f114~AIErGPek71164811648eusmtip1X;
        Wed, 21 Oct 2020 21:49:32 +0000 (GMT)
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
Subject: [PATCH v3 1/5] dt-bindings: vendor-prefixes: Add asix prefix
Date:   Wed, 21 Oct 2020 23:49:06 +0200
Message-Id: <20201021214910.20001-2-l.stelmach@samsung.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201021214910.20001-1-l.stelmach@samsung.com>
MIME-Version: 1.0
Organization: Samsung R&D Institute Poland
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA01SfyyUYRzfc++9772s0+MYD7XorrbSImPt2ZiibNcm2eovW+nk9aM4dq+f
        rY1ESoVIhC0pHJMf50cYt3VJGTncIgv50aY0P3Jqhay7e6/lv8/n+/l8nu/nuz00IZoiHeko
        eTyjkMuixZQlv6339+Dhxbq8kCPV7yVYO6khcFNxA4nLtBl8/LhnkMQVy8UkHl2cIHHu3DcC
        a7WNAjzUlkPicY0SYNXcKIl1nWUULtaqeVhT2A3w855JAe4tt8OZ3T2C49ZS3egwIW2pGedJ
        O0omBVJV7W1K2vwsVdrRrudJc1pqgVSv2hNEB1t6hzHRUYmMws3nomVkurKRiiulkts32DRQ
        SWYDCxpBTzTQo+dnA0taBJUAfZrJMpM1gGrSx3kc0QNUuK4C/yIbVUNmodogDNSSHJkHaLn8
        NWV0UdAX5Va+NQm2cIpADVnTwEgIqAaoY+oBYXTZQH/09E+fCfPhfqTu7DWlhdALdb1MM1d0
        QlnVL0xzC+iNdEuNJOexRn2PPvONeCd0QXXpYyZMGPw3WksJ4zIE79NIuVlkLn4SLT/cNGMb
        tPCmRcDh3ai/4K4hTBtwKirIP8pl7wLUVvaLz3m80MTgOmX0EPAgauh048a+qDJvxRy1Qh8W
        rbkKVii/rYjgxkJ066aIc+9D9bld5gcd0b0FJcgD4pJtx5RsO6Dk/65yQNQCeyaBjYlgWHc5
        k+TKymLYBHmE66XYGBUw/Lr+rTer7eDHSKgGQBqIdwhXAvJCRKQskU2J0QBEE2Jbod+7/gsi
        YZgs5SqjiA1RJEQzrAbsovlie6FHxdfzIhghi2euMEwco/in8mgLxzQQpxMV90KnpKVzmcEr
        GaErQewr/9M4WbGYfiJ5oik8YKRR3SwJbJ3Z6zSWc2DI9ouDp706/8y17xI/B68a3fDyiPzQ
        nVNPhmoGwn/2wTOa2O9bnkEN3j7+a9PxM7p6x+sedilLZ1dn7fLnowNFxz5OzjhDqkrAWszq
        +wecJd6XxXw2UubuQihY2V93JDThcQMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrHIsWRmVeSWpSXmKPExsVy+t/xu7pv1kyIN1jw3Mbi/N1DzBYbZ6xn
        tZhzvoXFYv6Rc6wWi97PYLW49vYOq0X/49fMFufPb2C3uLCtj9Xi5qEVjBabHl9jtbi8aw6b
        xYzz+5gsDk3dy2ix9shddotjC8QsWvceYXcQ9Lh87SKzx5aVN5k8ds66y+6xaVUnm8fmJfUe
        O3d8ZvLo27KK0ePzJrkAjig9m6L80pJUhYz84hJbpWhDCyM9Q0sLPSMTSz1DY/NYKyNTJX07
        m5TUnMyy1CJ9uwS9jKYVG9gKZrNV7Phd3MC4lLWLkZNDQsBE4veyC0xdjFwcQgJLGSVWN38G
        cjiAElISK+emQ9QIS/y51sUGUfOUUeLDyhUsIAk2AUeJ/qUnWEESIgJvmCWa7r1lB3GYBfYx
        Suw/upgdpEpYwFVi8d+TzCA2i4CqxL5dx9hAbF4Ba4k9BxugzpCXaF++HSzOKWAjcfndBrC4
        EFDNpXeTGSHqBSVOznzCAnIds4C6xPp5QiBhfgEtiTVN18EOYgYa07x1NvMERqFZSDpmIXTM
        QlK1gJF5FaNIamlxbnpusZFecWJucWleul5yfu4mRmBcbzv2c8sOxq53wYcYBTgYlXh4P/hM
        iBdiTSwrrsw9xCjBwawkwut09nScEG9KYmVValF+fFFpTmrxIUZToDcnMkuJJucDU05eSbyh
        qaG5haWhubG5sZmFkjhvh8DBGCGB9MSS1OzU1ILUIpg+Jg5OqQZG5gNab4OXSr68tnlCftaL
        DV/fSgmzrU2o/i+c0RFy43t+a96PE3zzdUxmbwtl7xFJfG/7c7r28m/5MZtLtG+5rpnBWvhA
        Juq5RY207oGnxk/TGaU3pWgtnLRa3S11jvr7zSGCl9fN/mpwbeWSm+d5+80Dtjy6ebjgCn9P
        ic7jI6k65t9y/7rcU2Ipzkg01GIuKk4EAMpWqQ0BAwAA
X-CMS-MailID: 20201021214933eucas1p26e8ee82f237e977e8b3324145a929a1a
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20201021214933eucas1p26e8ee82f237e977e8b3324145a929a1a
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20201021214933eucas1p26e8ee82f237e977e8b3324145a929a1a
References: <20201021214910.20001-1-l.stelmach@samsung.com>
        <CGME20201021214933eucas1p26e8ee82f237e977e8b3324145a929a1a@eucas1p2.samsung.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add the prefix for ASIX Electronics Corporation

Signed-off-by: Łukasz Stelmach <l.stelmach@samsung.com>
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

