Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5EE029D313
	for <lists+netdev@lfdr.de>; Wed, 28 Oct 2020 22:40:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727244AbgJ1Vkm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Oct 2020 17:40:42 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:34159 "EHLO
        mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727200AbgJ1Vkh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Oct 2020 17:40:37 -0400
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
        by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20201028214024euoutp01e994c6e632f60e32e7f782e4539b16b4~CRdsmdGRr3240832408euoutp01h
        for <netdev@vger.kernel.org>; Wed, 28 Oct 2020 21:40:24 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20201028214024euoutp01e994c6e632f60e32e7f782e4539b16b4~CRdsmdGRr3240832408euoutp01h
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1603921224;
        bh=2/xwxcxYv93eq31jsT80VcmPFIBIhKVvX8Jx5pcXie8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GsR950TPBL7SBapAT0ookvB4G3AN18MKpsRzrnz5HvNm0MAlQOcNdBcBWe/Yr9wyl
         Q4k70frBTstszZIQ/1S+bVewfAidaPA7sCz0pUxORiXMWXhM2/ZaHw8gXiVDFX2YFw
         PHAAaojgkAHlq9WseckyNZNMGe/gzs5QbfPhkS8M=
Received: from eusmges2new.samsung.com (unknown [203.254.199.244]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTP id
        20201028214016eucas1p2a66ef56297cc64b057451253e6cb19d9~CRdlPBpM72482524825eucas1p2a;
        Wed, 28 Oct 2020 21:40:16 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
        eusmges2new.samsung.com (EUCPMTA) with SMTP id 69.36.05997.045E99F5; Wed, 28
        Oct 2020 21:40:16 +0000 (GMT)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
        20201028214016eucas1p1257ca6d0eacfbb97a42d97a5e45e0370~CRdkh91LX2589725897eucas1p1z;
        Wed, 28 Oct 2020 21:40:16 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
        eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20201028214016eusmtrp1e15dd8933392ab113bffcd3ca3a73d05~CRdkhMQ633223832238eusmtrp1i;
        Wed, 28 Oct 2020 21:40:16 +0000 (GMT)
X-AuditID: cbfec7f4-677ff7000000176d-45-5f99e540f0ba
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
        eusmgms2.samsung.com (EUCPMTA) with SMTP id 06.7B.06017.045E99F5; Wed, 28
        Oct 2020 21:40:16 +0000 (GMT)
Received: from localhost (unknown [106.120.51.46]) by eusmtip1.samsung.com
        (KnoxPortal) with ESMTPA id
        20201028214015eusmtip1289b80e5ab717c0523127d8517aa6cec~CRdkVuJPh1418714187eusmtip1R;
        Wed, 28 Oct 2020 21:40:15 +0000 (GMT)
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
Subject: [PATCH v4 1/5] dt-bindings: vendor-prefixes: Add asix prefix
Date:   Wed, 28 Oct 2020 22:40:08 +0100
Message-Id: <20201028214012.9712-2-l.stelmach@samsung.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201028214012.9712-1-l.stelmach@samsung.com>
MIME-Version: 1.0
Organization: Samsung R&D Institute Poland
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA01Sa0hTYRju2zlnO45Wx6Pki4XBMigprxFfGqWlcH5FVH9Kai09qalTN7WU
        wNZNK3Mxk9RmiSXp8taypcsJLlPLywpLE6+kYhniD+1iReV2uvjved/n9n7w0QQ7RnnScapU
        Xq1SJsjFUtLcttCzOXSySOFv/R6A7cM2Aj8orKWwwX6exLdbeyhcNltI4b6ZIQrrxj8S2G6v
        k+CX5jwKD9gqEDaN91G412IQ40J7swjbCqwIV7cOS3Bb6Sp8wdoqwb+aGiShLNfb94rg6isH
        RFxj8bCEMxkvibmHd7O4xoY5EZdXb0TcnMlrL31Iuj2aT4hL59V+O45KY59aZsnkBfGpK112
        6gxaoC4jFxqYLWC+9UZyGUlplqlAMPO5VewgWGYewdc76wRiDkHLZPM/x6ecBlIg7iGwdlRR
        gmMKwUSbrwOLmTDQlXdQDpE7M0JAbfYYcgwEM4pgZOo+4VC5MRHQP9/txCSzHiqbq5zdMiYY
        xp99kwh1ayH73mPn3oUJgYn5J5SgcYXnRROkA69kfKDqbL8TE4v6c49uEo4yYEpoMOj0i2Z6
        cQgHrT5KyHSD6fb6P/lroDM/lxQkWZCv3ypYcxGYDV9JQRMCQz3fnDEEsxFqLX6CPAze92MB
        roC3M67CAStAb75BCGsZ5FxkhQxvqNE1/cnzhKvTFegakhcveUrxkvOL/1eVIsKIPPg0TWIM
        rwlU8Sd9NcpETZoqxjcqKdGEFv9d58/2+QZk+XHMhhgayZfLXg4WKVhKma7JSLQhoAm5u2xX
        d+cRVhatzMjk1UkKdVoCr7Gh1TQp95AFlX04zDIxylQ+nueTefVfVkS7eJ5B2/Qd71ylgarr
        7/yNU5Wb1nV2GQY3hKu9FEF1AS9C8ZybJcJYlW5KOphzYL+uNt9tQcsVpJRHiq9rR3eaRYpT
        3uVeJZHLcvxGX2dWf/JPMdwJtsazLSGrfU/4NM36KxIqv+yOPk74aAdfZc+O1ETZLu4r6JNP
        n9YOxe6Z3itWmeSkJlYZ4EOoNcrf8yZ3IHMDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrCIsWRmVeSWpSXmKPExsVy+t/xu7oOT2fGG7yfymZx/u4hZouNM9az
        Wsw538JiMf/IOVaLRe9nsFpce3uH1aL/8Wtmi/PnN7BbXNjWx2px89AKRotNj6+xWlzeNYfN
        Ysb5fUwWh6buZbRYe+Quu8WxBWIWrXuPsFv837OD3UHI4/K1i8weW1beZPLYOesuu8emVZ1s
        HpuX1Hvs3PGZyaNvyypGj8+b5AI4ovRsivJLS1IVMvKLS2yVog0tjPQMLS30jEws9QyNzWOt
        jEyV9O1sUlJzMstSi/TtEvQyDu96z1Lwk62i+8x51gbGn6xdjJwcEgImEl87drB0MXJxCAks
        ZZQ4desBUxcjB1BCSmLl3HSIGmGJP9e62CBqnjJKzD1zjgUkwSbgKNG/9AQrSEJE4A2zRNO9
        t+wgDrPAfUaJX59eMIJUCQu4Slz/cpYZxGYRUJVYuW8NG4jNK2Al8fjoL3aIFfIS7cu3g8U5
        BawlnnzZDXaeEFDNz29t7BD1ghInZz5hAbmOWUBdYv08IZAwv4CWxJqm62AHMQONad46m3kC
        o9AsJB2zEDpmIalawMi8ilEktbQ4Nz232EivODG3uDQvXS85P3cTIzDGtx37uWUHY9e74EOM
        AhyMSjy8F27PjBdiTSwrrsw9xCjBwawkwut09nScEG9KYmVValF+fFFpTmrxIUZToDcnMkuJ
        JucD009eSbyhqaG5haWhubG5sZmFkjhvh8DBGCGB9MSS1OzU1ILUIpg+Jg5OqQbGiqyI67KZ
        174Vz7nTuHEZj6H+Bmu1y6uXrdyVGRE8d55YfJpkceCP2gt8TxYuFFFf7yQRMXnRVPkV59n9
        s6+yq/yXEeWO+LIyfX9VxrktykwfDx1wVZrzJeG9xYRNhglnjQJ5FeIdyw8GuAl01K679CPN
        WdalQNlmgvrtkqfbPwmplKcsX3VDiaU4I9FQi7moOBEA7LtW9gcDAAA=
X-CMS-MailID: 20201028214016eucas1p1257ca6d0eacfbb97a42d97a5e45e0370
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20201028214016eucas1p1257ca6d0eacfbb97a42d97a5e45e0370
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20201028214016eucas1p1257ca6d0eacfbb97a42d97a5e45e0370
References: <20201028214012.9712-1-l.stelmach@samsung.com>
        <CGME20201028214016eucas1p1257ca6d0eacfbb97a42d97a5e45e0370@eucas1p1.samsung.com>
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

