Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC14230284E
	for <lists+netdev@lfdr.de>; Mon, 25 Jan 2021 17:59:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729504AbhAYQ5K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jan 2021 11:57:10 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:56903 "EHLO
        mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728737AbhAYQ4C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jan 2021 11:56:02 -0500
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
        by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id 20210125165423euoutp0223f823a3355b9cf4535f05c47c72751a~dh_Xu-ljb1284012840euoutp02F
        for <netdev@vger.kernel.org>; Mon, 25 Jan 2021 16:54:23 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com 20210125165423euoutp0223f823a3355b9cf4535f05c47c72751a~dh_Xu-ljb1284012840euoutp02F
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1611593663;
        bh=1G3u1jT+Nh0xSBwzdrr/0Z5HtSD8zq/pIwITlYIiVC4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=S36j5tna5mkcowOcAym83NH98VIh4MkaeziBzu4lL8uSr7LRh3rb/q36A0/3M4Qqn
         8biK19PRR3h6h146VtX2g1dkw7UgiEcIiEruVCkxEJvByuiXeNsnmFwQeO7FyIdU6M
         dIeV8W5WDeh/0seMmeq4mBB+zUri3up4hRI1R8G8=
Received: from eusmges2new.samsung.com (unknown [203.254.199.244]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTP id
        20210125165422eucas1p2dbe4fea61410bc343a30c4d1e16d586b~dh_W5vDDh0474404744eucas1p2N;
        Mon, 25 Jan 2021 16:54:22 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
        eusmges2new.samsung.com (EUCPMTA) with SMTP id BC.BF.44805.EB7FE006; Mon, 25
        Jan 2021 16:54:22 +0000 (GMT)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
        20210125165421eucas1p1e35b229fc823c74088e9be55bec36ec7~dh_WAiZEw2390323903eucas1p1G;
        Mon, 25 Jan 2021 16:54:21 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
        eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20210125165421eusmtrp2fe836402e78b3afc63d76ca859b2cd86~dh_V-xwq90209902099eusmtrp2D;
        Mon, 25 Jan 2021 16:54:21 +0000 (GMT)
X-AuditID: cbfec7f4-b37ff7000000af05-d3-600ef7beaae6
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
        eusmgms1.samsung.com (EUCPMTA) with SMTP id DB.D5.21957.DB7FE006; Mon, 25
        Jan 2021 16:54:21 +0000 (GMT)
Received: from localhost (unknown [106.120.51.46]) by eusmtip1.samsung.com
        (KnoxPortal) with ESMTPA id
        20210125165421eusmtip1e1e6752f319d2aed8e53cfac40e43d15~dh_Vx5KSK0626706267eusmtip1W;
        Mon, 25 Jan 2021 16:54:21 +0000 (GMT)
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
Subject: [PATCH v11 1/3] dt-bindings: vendor-prefixes: Add asix prefix
Date:   Mon, 25 Jan 2021 17:54:04 +0100
Message-Id: <20210125165406.9692-2-l.stelmach@samsung.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210125165406.9692-1-l.stelmach@samsung.com>
MIME-Version: 1.0
Organization: Samsung R&D Institute Poland
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrOKsWRmVeSWpSXmKPExsWy7djP87r7vvMlGBxawWdx/u4hZouNM9az
        Wsw538JiMf/IOVaLRe9nsFpce3uH1aL/8Wtmi/PnN7BbXNjWx2px89AKRotNj6+xWlzeNYfN
        Ysb5fUwWh6buZbRYe+Quu8WxBWIWrXuPsFv837OD3UHI4/K1i8weW1beZPLYOesuu8emVZ1s
        HpuX1Hvs3PGZyaNvyypGj8+b5AI4orhsUlJzMstSi/TtErgyVt86zlzwk63i8u7n7A2MP1m7
        GDk5JARMJD4sPcDUxcjFISSwglFi94EprBDOF0aJ6Qc2skA4nxklTh5fCddyaOpzqKrljBKN
        Z/oYIZznjBIrZlxlBKliE3CU6F96AqxKROAes8T69gdgVcwC9xkl7j1fzQxSJSzgJjHjxhc2
        EJtFQFXi5tmDYDt4Bawk5qyYwAaxT16iffl2MJtTwFriyeH5TBA1ghInZz5hAbH5BbQk1jRd
        B7OZgeqbt85mBlkmIXCYU+LO351MEINcJJ6d2Qj1hLDEq+Nb2CFsGYn/O0GGcgDZ9RKTJ5lB
        9PYwSmyb84MFosZa4s65X2wgNcwCmhLrd+lDhB0lnt3+A9XKJ3HjrSDECXwSk7ZNZ4YI80p0
        tAlBVKtIrOvfAzVQSqL31QrGCYxKs5A8MwvJA7MQdi1gZF7FKJ5aWpybnlpslJdarlecmFtc
        mpeul5yfu4kRmPZO/zv+ZQfj8lcf9Q4xMnEwHmKU4GBWEuHdrceTIMSbklhZlVqUH19UmpNa
        fIhRmoNFSZw3acuaeCGB9MSS1OzU1ILUIpgsEwenVAOTkah26+sz+sZObqlBXIvsnGIWMSjv
        lfq8zvn1vCmH7p3+PlPp+c5J9r8OufUatv2P/VQS4qR78e2iXCn56vSAHR+YjPv8+J2X3xTg
        tjjqe8Zb4r/auWX3Ds3deFuw57l/xsT49qWtcQu+691JfGMvw6ObUzv9RPWj9UdPLakw0l60
        Y52W/oTnNocmKF0M3COZxCRgWLi3l6OuMEzM/G7ipXJefUuBOEnLxQdjHhcG7nizL3xV0rS0
        xJcLehUZvYub9s1izdHq3je/+bpCI+cj9W3GV3U4XzrO3Oev/yf2/nz7Pf8avKdM3ra2SzI2
        /PqZy3OvWq58dv1nxua1NsYbPcXKfz7ZrFqaUZKwSiJIiaU4I9FQi7moOBEAo9QfEuoDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrOIsWRmVeSWpSXmKPExsVy+t/xu7p7v/MlGMxdI2Jx/u4hZouNM9az
        Wsw538JiMf/IOVaLRe9nsFpce3uH1aL/8Wtmi/PnN7BbXNjWx2px89AKRotNj6+xWlzeNYfN
        Ysb5fUwWh6buZbRYe+Quu8WxBWIWrXuPsFv837OD3UHI4/K1i8weW1beZPLYOesuu8emVZ1s
        HpuX1Hvs3PGZyaNvyypGj8+b5AI4ovRsivJLS1IVMvKLS2yVog0tjPQMLS30jEws9QyNzWOt
        jEyV9O1sUlJzMstSi/TtEvQyVt86zlzwk63i8u7n7A2MP1m7GDk5JARMJA5NfQ5kc3EICSxl
        lDh2cjpLFyMHUEJKYuXcdIgaYYk/17rYIGqeMkqs2XuTESTBJuAo0b/0BFiziMAbZomme2/Z
        QRxmgfuMEr8+vQCrEhZwk5hx4wsbiM0ioCpx8+xBsNW8AlYSc1ZMYINYIS/Rvnw7mM0pYC3x
        5PB8JhBbCKjm/MtvbBD1ghInZz4Bu45ZQF1i/TwhkDC/gJbEmqbrLCA2M9CY5q2zmScwCs1C
        0jELoWMWkqoFjMyrGEVSS4tz03OLDfWKE3OLS/PS9ZLzczcxAmN827Gfm3cwznv1Ue8QIxMH
        4yFGCQ5mJRHe3Xo8CUK8KYmVValF+fFFpTmpxYcYTYE+m8gsJZqcD0wyeSXxhmYGpoYmZpYG
        ppZmxkrivFvnrokXEkhPLEnNTk0tSC2C6WPi4JRqYEpiuZo/KV2nZSnv1jDRzqA1rXuOX5fb
        lVggsXdThcwae9knxRJyeXqXYr7bP5p6d+FbiVWr9x8pv7E4RKXh05l3k+ZPDCqZFC6uvL+3
        gOPzot6J/qXGMyslO06fu9N1vdZJYFnutjueXyqyQnepbFm8rXjKxpYTT2/UhAtZeXedPsR8
        XGpywpec4phDNxdU7jz0/pEzf/H1qFXWMxqYtFNLSv3E//qlX/L+dmh1e26Gt/M9z38Lju5a
        O3F38GoZ3zc3NgtZ9VwP2id1/PuqgNcGZ33jd7Iq3GibpKb2Q1N71eldtcV1u/r6TDadq5Ze
        2bL52NOeXz8UXiY1dEdosEs6WT9/zLJ19knbgLpF1nuVWIozEg21mIuKEwE6dyoWegMAAA==
X-CMS-MailID: 20210125165421eucas1p1e35b229fc823c74088e9be55bec36ec7
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20210125165421eucas1p1e35b229fc823c74088e9be55bec36ec7
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20210125165421eucas1p1e35b229fc823c74088e9be55bec36ec7
References: <20210125165406.9692-1-l.stelmach@samsung.com>
        <CGME20210125165421eucas1p1e35b229fc823c74088e9be55bec36ec7@eucas1p1.samsung.com>
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
index e8c773478f54..b962f852ccaf 100644
--- a/Documentation/devicetree/bindings/vendor-prefixes.yaml
+++ b/Documentation/devicetree/bindings/vendor-prefixes.yaml
@@ -125,6 +125,8 @@ patternProperties:
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

