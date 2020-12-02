Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 486182CC91E
	for <lists+netdev@lfdr.de>; Wed,  2 Dec 2020 22:51:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728340AbgLBVtG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Dec 2020 16:49:06 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:35749 "EHLO
        mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727084AbgLBVtF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Dec 2020 16:49:05 -0500
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
        by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20201202214722euoutp013ac5e83605332fb2d57e281550bdf689~NBIxGkHAo1827618276euoutp01D
        for <netdev@vger.kernel.org>; Wed,  2 Dec 2020 21:47:22 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20201202214722euoutp013ac5e83605332fb2d57e281550bdf689~NBIxGkHAo1827618276euoutp01D
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1606945642;
        bh=2/xwxcxYv93eq31jsT80VcmPFIBIhKVvX8Jx5pcXie8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rcUbz2az/GiRWlDbCVwLseEalZNAVzyf3cF8oF2hv9RxWsVJZUkPFd7DHEmm1Uu7i
         dfFvLLrC0p3q6X7jWaDfmQb2Da2CzP7Si5SMvUneHtsVk5pop1Yfzr7PO4b97eHjri
         ZF6JY+b3uClgkdjiLDsdEGhgAUh/M3+r4ue+Jq68=
Received: from eusmges2new.samsung.com (unknown [203.254.199.244]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTP id
        20201202214712eucas1p1d990b779581b54547db6d6f44294407a~NBIneBHR40134901349eucas1p1b;
        Wed,  2 Dec 2020 21:47:12 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
        eusmges2new.samsung.com (EUCPMTA) with SMTP id 8E.0A.44805.06B08CF5; Wed,  2
        Dec 2020 21:47:12 +0000 (GMT)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
        20201202214711eucas1p12888022f68f0d0ca2423c7ea7b7fef44~NBInD_uwQ0388303883eucas1p1T;
        Wed,  2 Dec 2020 21:47:11 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
        eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20201202214711eusmtrp26b3a5c2f2cf24fb208c870b70626a52d~NBInDM6tp2287322873eusmtrp2P;
        Wed,  2 Dec 2020 21:47:11 +0000 (GMT)
X-AuditID: cbfec7f4-b37ff7000000af05-d2-5fc80b600d73
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
        eusmgms2.samsung.com (EUCPMTA) with SMTP id 8F.1B.16282.F5B08CF5; Wed,  2
        Dec 2020 21:47:11 +0000 (GMT)
Received: from localhost (unknown [106.120.51.46]) by eusmtip1.samsung.com
        (KnoxPortal) with ESMTPA id
        20201202214711eusmtip168731cf9e75a6920453c0957d2111603~NBImzwNNm1114911149eusmtip1d;
        Wed,  2 Dec 2020 21:47:11 +0000 (GMT)
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
Subject: [PATCH v8 1/3] dt-bindings: vendor-prefixes: Add asix prefix
Date:   Wed,  2 Dec 2020 22:47:07 +0100
Message-Id: <20201202214709.16192-2-l.stelmach@samsung.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201202214709.16192-1-l.stelmach@samsung.com>
MIME-Version: 1.0
Organization: Samsung R&D Institute Poland
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrEKsWRmVeSWpSXmKPExsWy7djP87oJ3CfiDdbfYrc4f/cQs8XGGetZ
        Leacb2GxmH/kHKvFovczWC2uvb3DatH/+DWzxfnzG9gtLmzrY7W4eWgFo8Wmx9dYLS7vmsNm
        MeP8PiaLQ1P3MlqsPXKX3eLYAjGL1r1H2C3+79nB7iDkcfnaRWaPLStvMnnsnHWX3WPTqk42
        j81L6j127vjM5NG3ZRWjx+dNcgEcUVw2Kak5mWWpRfp2CVwZh3e9Zyn4yVbRfeY8awPjT9Yu
        Rk4OCQETiTnf9wPZXBxCAisYJW42NbKDJIQEvjBKbLofApH4zCix58o2ZpiO3f+fsEMkljNK
        vPx3lBWi4zlQ+1l3EJtNwFGif+kJsLEiAveYJda3P2AEcZgF7jNK3Hu+GmyUsICrxIvJa5m6
        GDk4WARUJT62BIGEeQWsJTZt3cIEsU1eon35djYQm1PARuLNi/OsEDWCEidnPmEBsfkFtCTW
        NF0Hs5mB6pu3zoa69BSnxILZtRC2i8SOtidsELawxKvjW9ghbBmJ/zvng50gIVAvMXmSGciZ
        EgI9jBLb5vxggaixlrhz7hcbSA2zgKbE+l36EOWOEt2nsiFMPokbbwUhDuCTmLRtOjNEmFei
        o00IYoaKxLr+PVDzpCR6X61gnMCoNAvJK7OQnD8LYdUCRuZVjOKppcW56anFRnmp5XrFibnF
        pXnpesn5uZsYgcnu9L/jX3YwLn/1Ue8QIxMH4yFGCQ5mJRFeln9H4oV4UxIrq1KL8uOLSnNS
        iw8xSnOwKInzJm1ZEy8kkJ5YkpqdmlqQWgSTZeLglGpgEpk8ycTx8iqtJx6TtisV5zhv2P6y
        6qTxyTf2uuUXQ+ZEG/7pFPpocOqt5KJIfola17uX7l/7ExHx/JnLrp1bPzV9TQhK7F27hKkh
        PSIl3/CQoVKg8Mk5btqMaveTdh0pumqTZKl4+FydedGk9Stdl3iy3u2Q3vi9+U1sVFiopPcp
        Ic79l161ZlY3t+sfzD0T9DrnXxGHWyizbfJ/LufPyi7LvBkf9N8JCrzok/hJ1VFlkcrMuoqH
        xZoK/1YznPp/ae9TqWhDdzGDe3+/Je8tKS4XePxN+U3638JF9z5/mDNH5/kFI5cnz1Y+LGvp
        Lef1eOZ8YWYLW3zNojVvFjW92ZWQyNTs8WON+Ryel9cnKrEUZyQaajEXFScCALHBzhLlAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrGIsWRmVeSWpSXmKPExsVy+t/xu7rx3CfiDS7/Vrc4f/cQs8XGGetZ
        Leacb2GxmH/kHKvFovczWC2uvb3DatH/+DWzxfnzG9gtLmzrY7W4eWgFo8Wmx9dYLS7vmsNm
        MeP8PiaLQ1P3MlqsPXKX3eLYAjGL1r1H2C3+79nB7iDkcfnaRWaPLStvMnnsnHWX3WPTqk42
        j81L6j127vjM5NG3ZRWjx+dNcgEcUXo2RfmlJakKGfnFJbZK0YYWRnqGlhZ6RiaWeobG5rFW
        RqZK+nY2Kak5mWWpRfp2CXoZh3e9Zyn4yVbRfeY8awPjT9YuRk4OCQETid3/n7B3MXJxCAks
        ZZQ4PbmXrYuRAyghJbFybjpEjbDEn2tdbBA1Txkljp0/wAiSYBNwlOhfeoIVJCEi8IZZoune
        W7BJzAL3GSV+fXoBViUs4CrxYvJaJpCpLAKqEh9bgkDCvALWEpu2bmGC2CAv0b58OxuIzSlg
        I/HmxXmw64SAava/WskIUS8ocXLmExaQMcwC6hLr5wmBhPkFtCTWNF1nAbGZgcY0b53NPIFR
        aBaSjlkIHbOQVC1gZF7FKJJaWpybnltspFecmFtcmpeul5yfu4kRGOHbjv3csoNx5auPeocY
        mTgYDzFKcDArifCy/DsSL8SbklhZlVqUH19UmpNafIjRFOixicxSosn5wBSTVxJvaGZgamhi
        ZmlgamlmrCTOa3JkTbyQQHpiSWp2ampBahFMHxMHp1QDk9b088qNE3d/aTcULnt7vuXl2037
        Zjx7ZDhRs3GZhPudtQtPf6hNbtW8vpj1ZrHUPz/Rv4o/vh7UvHpHYd/ze7PZDusby90ySni6
        6tEdEelQK7mSptDJIvc85Rj+lm/7/ljmyuSr9z9s1OHbumdCjP6f8NuBPb+XCX5n/hVUklUt
        5RHTe+/hznU7Ktbbby1boPyed1nrf9OkrxxWM5bXvWixvJkbemaD/cETodPvfn72Y94enQO7
        Nwf8dFhwo+VdguW8ztZDM+pqrB466HQ/1n6VmzR92q1jeo5smUe5jkfXiQYfjm06bPfs3I1J
        /toHVs0PT572/l3kxCSjgnnBl/uu8PVsDeJ02rtQ7uPb878+KbEUZyQaajEXFScCAH2OjAZ5
        AwAA
X-CMS-MailID: 20201202214711eucas1p12888022f68f0d0ca2423c7ea7b7fef44
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20201202214711eucas1p12888022f68f0d0ca2423c7ea7b7fef44
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20201202214711eucas1p12888022f68f0d0ca2423c7ea7b7fef44
References: <20201202214709.16192-1-l.stelmach@samsung.com>
        <CGME20201202214711eucas1p12888022f68f0d0ca2423c7ea7b7fef44@eucas1p1.samsung.com>
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

