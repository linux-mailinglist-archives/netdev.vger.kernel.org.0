Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 431D12C253F
	for <lists+netdev@lfdr.de>; Tue, 24 Nov 2020 13:05:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733300AbgKXMD7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Nov 2020 07:03:59 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:42192 "EHLO
        mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733281AbgKXMD5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Nov 2020 07:03:57 -0500
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
        by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20201124120345euoutp01c0f2db34fadf2eb696d6ba92462a58c8~KcA62ibqj2795927959euoutp01O
        for <netdev@vger.kernel.org>; Tue, 24 Nov 2020 12:03:45 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20201124120345euoutp01c0f2db34fadf2eb696d6ba92462a58c8~KcA62ibqj2795927959euoutp01O
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1606219425;
        bh=2/xwxcxYv93eq31jsT80VcmPFIBIhKVvX8Jx5pcXie8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nhzouqYn17FfY6Y6xjhAXdz2YWT19B1reoPv5LmxYZ4y0Z31szVCYZsgjiD1B5nTa
         dB/cf7rg/qoOUKdyS78VpWGZfdVHqDnjLV2edTPNEZy3gxze0ZgxiMHmnZSCB4Jwx5
         xVIZil2hCCUWOwa4AwZkTFS2pTOGPy89z4ALXBy0=
Received: from eusmges3new.samsung.com (unknown [203.254.199.245]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTP id
        20201124120337eucas1p1c34dd9eea20642bc01f95b4eea6b8d0a~KcAy5Oos33235932359eucas1p1m;
        Tue, 24 Nov 2020 12:03:37 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
        eusmges3new.samsung.com (EUCPMTA) with SMTP id CC.9E.45488.896FCBF5; Tue, 24
        Nov 2020 12:03:36 +0000 (GMT)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
        20201124120336eucas1p2df4e6cc5f456a48f19a5c0e8ea91c662~KcAydYE9Y3269632696eucas1p2E;
        Tue, 24 Nov 2020 12:03:36 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
        eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20201124120336eusmtrp2611378615df75151c8693a6f86dd24ae~KcAyWnLjm3040030400eusmtrp2C;
        Tue, 24 Nov 2020 12:03:36 +0000 (GMT)
X-AuditID: cbfec7f5-c77ff7000000b1b0-48-5fbcf698a450
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
        eusmgms2.samsung.com (EUCPMTA) with SMTP id 99.2C.16282.896FCBF5; Tue, 24
        Nov 2020 12:03:36 +0000 (GMT)
Received: from localhost (unknown [106.120.51.46]) by eusmtip1.samsung.com
        (KnoxPortal) with ESMTPA id
        20201124120336eusmtip1fa28c5575ff6def3d8e29e37fc760d38~KcAyJGCsU1036710367eusmtip1C;
        Tue, 24 Nov 2020 12:03:36 +0000 (GMT)
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
Subject: [PATCH v7 1/3] dt-bindings: vendor-prefixes: Add asix prefix
Date:   Tue, 24 Nov 2020 13:03:28 +0100
Message-Id: <20201124120330.32445-2-l.stelmach@samsung.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201124120330.32445-1-l.stelmach@samsung.com>
MIME-Version: 1.0
Organization: Samsung R&D Institute Poland
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrKKsWRmVeSWpSXmKPExsWy7djPc7ozvu2JN3i53sbi/N1DzBYbZ6xn
        tZhzvoXFYv6Rc6wWi97PYLW49vYOq0X/49fMFufPb2C3uLCtj9Xi5qEVjBabHl9jtbi8aw6b
        xYzz+5gsDk3dy2ix9shddotjC8QsWvceYbf4v2cHu4OQx+VrF5k9tqy8yeSxc9Zddo9NqzrZ
        PDYvqffYueMzk0ffllWMHp83yQVwRHHZpKTmZJalFunbJXBlHN71nqXgJ1tF95nzrA2MP1m7
        GDk5JARMJP6sPg5kc3EICaxglJi8oI8ZwvnCKNH7opUJwvnMKLHxUzMLTMu5qx1MILaQwHJG
        ib0rYyCKnjNKHJu2F6yITcBRon/pCbC5IgL3mCXWtz9gBHGYBe4zStx7vpoZpEpYwFXi8aVf
        YDaLgKrEwzmdQDYHB6+AtcTttmiIbfIS7cu3s4HYnAI2Em1HboOV8woISpyc+QRsGb+AlsSa
        putgNjNQffPW2WA/SAgc5pToudbLDjHIReJP/0aoF4QlXh3fAhWXkfi/cz4TyF4JgXqJyZPM
        IHp7GCW2zfkBVW8tcefcLzaQGmYBTYn1u/Qhwo4SbaueMEO08knceCsIcQKfxKRt06HCvBId
        bUIQ1SoS6/r3QA2Ukuh9tYJxAqPSLCTPzELywCyEXQsYmVcxiqeWFuempxYb56WW6xUn5haX
        5qXrJefnbmIEprzT/45/3cG44tVHvUOMTByMhxglOJiVRHhb5XbGC/GmJFZWpRblxxeV5qQW
        H2KU5mBREufdtXVNvJBAemJJanZqakFqEUyWiYNTqoFp69c9AqVRTiXzvQ5eZFwkkJzwc1bc
        MWGOhOjLvEJvb1/dxbFr5qpdxorc5+262GJ3LXhpNfuR5YzShY+k0mTCzjsyb9g8K9D1oMOX
        rP6wkA9qQXP+rXszT6ahc69kbuANh5fXFyZvfvHe5M/F2Xta6ng1fkqse8oicHzK16SsVw+P
        /Fh41Hay1naP7PSsuLe8a9Lu3H6Ve6P959svd5t/q3ltKd7OISV3yjhrl6nj1pawz7l/tpVN
        m/lC2YGdubXj45aQ50tm1pq+U+PZfNogP6OVS/aL5a8DnYEfAtktk75mab50j7+Ybl32ueiT
        cnUm5yGZ9VYZXO9+2mssUai6Nk8yrK7n7WbrmZ8OVnltU2Ipzkg01GIuKk4EAI+4SWvoAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrGIsWRmVeSWpSXmKPExsVy+t/xu7ozvu2JN2ibL2lx/u4hZouNM9az
        Wsw538JiMf/IOVaLRe9nsFpce3uH1aL/8Wtmi/PnN7BbXNjWx2px89AKRotNj6+xWlzeNYfN
        Ysb5fUwWh6buZbRYe+Quu8WxBWIWrXuPsFv837OD3UHI4/K1i8weW1beZPLYOesuu8emVZ1s
        HpuX1Hvs3PGZyaNvyypGj8+b5AI4ovRsivJLS1IVMvKLS2yVog0tjPQMLS30jEws9QyNzWOt
        jEyV9O1sUlJzMstSi/TtEvQyDu96z1Lwk62i+8x51gbGn6xdjJwcEgImEueudjB1MXJxCAks
        ZZRYfmQfSxcjB1BCSmLl3HSIGmGJP9e62CBqnjJK9C7sYARJsAk4SvQvPcEKkhAReMMs0XTv
        LTuIwyxwn1Hi16cXYFXCAq4Sjy/9YgaxWQRUJR7O6WQG2cArYC1xuy0aYoO8RPvy7WwgNqeA
        jUTbkdtg5UJAJdtmH2IBsXkFBCVOznwCdhyzgLrE+nlCIGF+AS2JNU3XwUqYgcY0b53NPIFR
        aBaSjlkIHbOQVC1gZF7FKJJaWpybnltspFecmFtcmpeul5yfu4kRGOHbjv3csoNx5auPeocY
        mTgYDzFKcDArifC2yu2MF+JNSaysSi3Kjy8qzUktPsRoCvTYRGYp0eR8YIrJK4k3NDMwNTQx
        szQwtTQzVhLnNTmyJl5IID2xJDU7NbUgtQimj4mDU6qBaQKvhs7T/53O0mseN8rWFrsd9pNU
        jM5bXs9T0GHXeM5A3V95n4uDf+LOE13Hnm71Vf0its5n1wZ/GaNvUQbHF6ya9OHpzpd5025d
        LZVN/+q1I3HXzlPfWY8ft/FPsE2d/OS54XlBt48qjpJiRrEdesmCqdm6R+8E6jN3/t/PHqh2
        rG2mrnv+0+tyUy29ixgzlhX5qVxcUlZm1rF+fsqRLavd7mvcOPD58IevrafmHvedlPbptJRS
        t2b7lT9LOo84sdb4xkksUHoyf2bxnDNXvPd3ukadvbnnAkfzg4V1GgcZN8r2K0YyLwmbKaq5
        sDlxUuzaJE/TyJb7rh/Ws54UlnPT+rBGaJPzaQl/i5AdSizFGYmGWsxFxYkA/UNpUnkDAAA=
X-CMS-MailID: 20201124120336eucas1p2df4e6cc5f456a48f19a5c0e8ea91c662
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20201124120336eucas1p2df4e6cc5f456a48f19a5c0e8ea91c662
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20201124120336eucas1p2df4e6cc5f456a48f19a5c0e8ea91c662
References: <20201124120330.32445-1-l.stelmach@samsung.com>
        <CGME20201124120336eucas1p2df4e6cc5f456a48f19a5c0e8ea91c662@eucas1p2.samsung.com>
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

