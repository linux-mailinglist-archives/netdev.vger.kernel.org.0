Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CC3B2A4931
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 16:17:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728474AbgKCPRZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 10:17:25 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:54991 "EHLO
        mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728410AbgKCPQJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Nov 2020 10:16:09 -0500
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
        by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id 20201103151545euoutp0209d7ef9d429f42e46df53812a7e3a0fd~ECFjgnmdv0612006120euoutp02U
        for <netdev@vger.kernel.org>; Tue,  3 Nov 2020 15:15:45 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com 20201103151545euoutp0209d7ef9d429f42e46df53812a7e3a0fd~ECFjgnmdv0612006120euoutp02U
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1604416545;
        bh=2/xwxcxYv93eq31jsT80VcmPFIBIhKVvX8Jx5pcXie8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=loeU75X0Mm0/JcllwslWENvzBevvKD0z11/e7az4qVew2vlVXEvWy0l7TursbUr+e
         ls5ului8tnl9VA/CBFihtLp6nIE/mmixDQHyrDDyBscabfL6w1KDZHrygIcYZ84eYk
         4LA3PmRA9MGcd+baCDBSz1Rb1h8p8fXuiHHuZdwg=
Received: from eusmges3new.samsung.com (unknown [203.254.199.245]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTP id
        20201103151539eucas1p275507f6669d14d30d93e316ccadec1a1~ECFej6myP3058430584eucas1p2v;
        Tue,  3 Nov 2020 15:15:39 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
        eusmges3new.samsung.com (EUCPMTA) with SMTP id E1.D7.06318.B1471AF5; Tue,  3
        Nov 2020 15:15:39 +0000 (GMT)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
        20201103151539eucas1p197086bea2450e8a11dde42650d1db6db~ECFeGkDLV2137621376eucas1p10;
        Tue,  3 Nov 2020 15:15:39 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
        eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20201103151539eusmtrp23e23696228643198d0b1683d63e14583~ECFeF2Pq20549405494eusmtrp2g;
        Tue,  3 Nov 2020 15:15:39 +0000 (GMT)
X-AuditID: cbfec7f5-371ff700000018ae-de-5fa1741b12cc
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
        eusmgms2.samsung.com (EUCPMTA) with SMTP id 5F.8D.06017.B1471AF5; Tue,  3
        Nov 2020 15:15:39 +0000 (GMT)
Received: from localhost (unknown [106.120.51.46]) by eusmtip1.samsung.com
        (KnoxPortal) with ESMTPA id
        20201103151539eusmtip1579a831a0f562551a13bc394786d6fc7~ECFd3yaW21813418134eusmtip17;
        Tue,  3 Nov 2020 15:15:38 +0000 (GMT)
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
Subject: [PATCH v5 1/5] dt-bindings: vendor-prefixes: Add asix prefix
Date:   Tue,  3 Nov 2020 16:15:32 +0100
Message-Id: <20201103151536.26472-2-l.stelmach@samsung.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201103151536.26472-1-l.stelmach@samsung.com>
MIME-Version: 1.0
Organization: Samsung R&D Institute Poland
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA02Sa0xSYRiA+zgcOLDQE7n8IssNy5WVXWjt23Slrdb5kVv/umyGWGfmEjQO
        VrYVzEyLSprGVFIzZkpWWGgkps2QvGSK3dQ2NVd2syzLbpbLgEPLf8/7vc972z4CEw/hEiJZ
        paHVKkWKlCfk2lsmupbP01yUryzpDEfuASeGbhRW46jYncVFF1xdODJ/KsRRz2g/jgwv32PI
        7b7OR932XBw9c1oAsr3swdHj+mIeKnTf4SCnsRGga64BPmopm4OON7r4aKqhjh8jph73PMSo
        2svPOJTDNMCnbFUneVRNuZZy1I1zqNzaKkCN2xZsJXYKo/fQKckHaPWKdQnCvc31n7hpE7xD
        px64cR2YwPWAICC5Bk61afVASIhJC4AFxmFMDwSe4CuAY9lHWB738PB8L3v9RxXNfLagEkBH
        Vi/GBm8AfFjxw1fNI2Oh4VIb7k0EkYMYrM4ZAt4AI58DOPjmis+aTW6CHy+7gJe55CJ4/3MT
        7mURGQUv1n3hsvNCYU7lLZ6XBWQ01J0zclhnFmwvGvY5gWQEvJrZ62PM4x+7ed63EiSLCPh0
        0Oo/dCPsLl3C9pwNR1pr+SyHwCnHBQ6raGF+3lq29DSA9uKf/h2iYH/XL57XwcglsLp+Bfsc
        C/vMv/3dA2Df6Cx2gwCYZy/A2GcRPJEtZu2F0Gpo8DeUwDMjFnAWSE3TbjFN29/0f1YZwKpA
        MJ3OKJNoRqaiD0YyCiWTrkqK3J2qtAHPv+v40/qtDtyZTHQCkgDSmaIYukwuxhUHmAylE0AC
        kwaJNnR27BKL9igyDtPqVLk6PYVmnGAewZUGi2Tmd/FiMkmhoffRdBqt/pflEAKJDhyWtY5t
        DnMJdrjG1CEJTaXao4LR72fOts2ontxvjheuVi6OHzGENm6Pe9LG+b0Nacas2i2TTZJyw6u4
        6PxJR/+LxObdjoWPspfiRbcWocy5b3VGS8G9ZeuHtOn3hLjM+uG1TB8eeXtU8rUkOliTnJn7
        KyOnhvl+tz3fFBYYckou5TJ7FasiMDWj+AsCWSntcwMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrCIsWRmVeSWpSXmKPExsVy+t/xu7rSJQvjDdas5bQ4f/cQs8XGGetZ
        Leacb2GxmH/kHKvFovczWC2uvb3DatH/+DWzxfnzG9gtLmzrY7W4eWgFo8Wmx9dYLS7vmsNm
        MeP8PiaLQ1P3MlqsPXKX3eLYAjGL1r1H2C3+79nB7iDkcfnaRWaPLStvMnnsnHWX3WPTqk42
        j81L6j127vjM5NG3ZRWjx+dNcgEcUXo2RfmlJakKGfnFJbZK0YYWRnqGlhZ6RiaWeobG5rFW
        RqZK+nY2Kak5mWWpRfp2CXoZh3e9Zyn4yVbRfeY8awPjT9YuRk4OCQETiUvLDrN3MXJxCAks
        ZZRYtm0dWxcjB1BCSmLl3HSIGmGJP9e62CBqnjJKbDtzgQkkwSbgKNG/9AQrSEJE4A2zRNO9
        t2CTmAXuM0r8+vSCEaRKWMBV4t3KI2A2i4CqxKmPB8BW8wpYSyzc8YkFYoW8RPvy7WwgNqeA
        jUTDlKlgG4SAanYd3cIGUS8ocXLmExaQ65gF1CXWzxMCCfMLaEmsaboONoYZaEzz1tnMExiF
        ZiHpmIXQMQtJ1QJG5lWMIqmlxbnpucVGesWJucWleel6yfm5mxiBMb7t2M8tOxi73gUfYhTg
        YFTi4XVIXRAvxJpYVlyZe4hRgoNZSYTX6ezpOCHelMTKqtSi/Pii0pzU4kOMpkBvTmSWEk3O
        B6afvJJ4Q1NDcwtLQ3Njc2MzCyVx3g6BgzFCAumJJanZqakFqUUwfUwcnFINjKf+lmWlCDHl
        nz57kstnjlb2wtu+grc8/5WpG11938rQ+9GG8VO0duYp9wsTzbmmpx8wCvjhNWHDhTNrn2ba
        9AQ/jWp79G3X3ObJaaetcg58cshc5HREuE0qaO7fcpYF9n12Sw5dOHHT/ePO5R/YHjbt0plf
        LSEe9C3J8vfedzK1ESGcHvLBRUosxRmJhlrMRcWJAPJJeyoHAwAA
X-CMS-MailID: 20201103151539eucas1p197086bea2450e8a11dde42650d1db6db
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20201103151539eucas1p197086bea2450e8a11dde42650d1db6db
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20201103151539eucas1p197086bea2450e8a11dde42650d1db6db
References: <20201103151536.26472-1-l.stelmach@samsung.com>
        <CGME20201103151539eucas1p197086bea2450e8a11dde42650d1db6db@eucas1p1.samsung.com>
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

