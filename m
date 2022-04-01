Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A5A54EE685
	for <lists+netdev@lfdr.de>; Fri,  1 Apr 2022 05:10:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233290AbiDADKr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Mar 2022 23:10:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232935AbiDADKq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Mar 2022 23:10:46 -0400
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3DE619C5B3
        for <netdev@vger.kernel.org>; Thu, 31 Mar 2022 20:08:54 -0700 (PDT)
Received: from epcas1p2.samsung.com (unknown [182.195.41.46])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20220401030851epoutp03e8606dd8c10caa3508adc8a79965ae2e~hpvnwd8BZ0297402974epoutp037
        for <netdev@vger.kernel.org>; Fri,  1 Apr 2022 03:08:51 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20220401030851epoutp03e8606dd8c10caa3508adc8a79965ae2e~hpvnwd8BZ0297402974epoutp037
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1648782531;
        bh=DO7cgGgTHvQMHO2GGJ8drJXd4TGsXZIl9hBqmml2nKE=;
        h=Subject:Reply-To:From:To:CC:Date:References:From;
        b=SKuspWaoWO/DDa3RxqIbmvJTE942FdKHC6aJ0osoYC1tr0PkB24mZPeC70/psqFXJ
         H6c8FPgyDCtFZHUodAJxrSxi4lSGpo3S6e5pfdJZyedBB6lw2WbbBKNwBms0n+sppS
         GGking0PQvAvCMchJJMwevF/SIau4HNLOeJh4C08=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
        epcas1p4.samsung.com (KnoxPortal) with ESMTP id
        20220401030850epcas1p4a29779612173415005752b2b7eb5e06a~hpvm4b9mQ2568425684epcas1p4I;
        Fri,  1 Apr 2022 03:08:50 +0000 (GMT)
Received: from epsmges1p3.samsung.com (unknown [182.195.36.88]) by
        epsnrtp1.localdomain (Postfix) with ESMTP id 4KV4rJ3wM7z4x9Q2; Fri,  1 Apr
        2022 03:08:48 +0000 (GMT)
X-AuditID: b6c32a37-28fff70000002578-0a-62466cc01042
Received: from epcas1p2.samsung.com ( [182.195.41.46]) by
        epsmges1p3.samsung.com (Symantec Messaging Gateway) with SMTP id
        E7.2D.09592.0CC66426; Fri,  1 Apr 2022 12:08:48 +0900 (KST)
Mime-Version: 1.0
Subject: [PATCH] dt-bindings: net: snps: remove duplicate name
Reply-To: dj76.yang@samsung.com
Sender: =?UTF-8?B?7JaR64+Z7KeE?= <dj76.yang@samsung.com>
From:   =?UTF-8?B?7JaR64+Z7KeE?= <dj76.yang@samsung.com>
To:     "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "krzk+dt@kernel.org" <krzk+dt@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        =?UTF-8?B?7JaR64+Z7KeE?= <dj76.yang@samsung.com>,
        =?UTF-8?B?7KCE66y46riw?= <moonki.jun@samsung.com>
X-Priority: 3
X-Content-Kind-Code: NORMAL
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <20220401030847epcms1p8cf7a8e1d8cd7d325dacf30f78da36328@epcms1p8>
Date:   Fri, 01 Apr 2022 12:08:47 +0900
X-CMS-MailID: 20220401030847epcms1p8cf7a8e1d8cd7d325dacf30f78da36328
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
X-CPGSPASS: Y
X-CPGSPASS: Y
CMS-TYPE: 101P
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprGJsWRmVeSWpSXmKPExsWy7bCmnu6BHLckg+/tUhYvD2lazDnfwmIx
        /8g5VovdM5YzWbycdY/N4sK2PlaLy7vmsFmcW5xpcWyBmMW3028YLVr3HmF34PbYsvImk8em
        VZ1sHu/3XWXz6NuyitHj8ya5ANaobJuM1MSU1CKF1Lzk/JTMvHRbJe/geOd4UzMDQ11DSwtz
        JYW8xNxUWyUXnwBdt8wcoLuUFMoSc0qBQgGJxcVK+nY2RfmlJakKGfnFJbZKqQUpOQXmBXrF
        ibnFpXnpenmpJVaGBgZGpkCFCdkZ+8/2MxbM46qYNm0PUwPjPfYuRk4OCQETieN/ZjB2MXJx
        CAnsYJS4uvAyaxcjBwevgKDE3x3CIDXCAnYSD37+ZgMJCwnIS3yeWAkRtpCYfWwZI4jNJmAm
        8WvvHDaQMSICNxklpl44BzaTWWAOk8Sr//dYIJbxSsxofwplS0tsX76VEcLWkPixrJcZwhaV
        uLn6LTuM/f7YfKgaEYnWe2ehagSBDtoNFZeSeNR8AMquljjX3gvV28Aose2jIsjREgL6Ejuu
        G4OEeQV8Jc5/6WIDsVkEVCXWPfoGdY6LxMMrl8HGMwP9uP3tHGaQVmYBTYn1u/QhpihLHLkF
        90jDxt/s6GxmAT6Jd197WGHiO+Y9YYKwlSU+N7+G6pWUWDx5JvMERqVZiHCehWTvLIS9CxiZ
        VzGKpRYU56anFhsWGMOjNjk/dxMjOIFqme9gnPb2g94hRiYOxkOMEhzMSiK8V2Ndk4R4UxIr
        q1KL8uOLSnNSiw8xmgJ9PJFZSjQ5H5jC80riDU0sDUzMjExNDQ0sTJTEeVdNO50oJJCeWJKa
        nZpakFoE08fEwSnVwMTidMLEOXa6v5na2ckpDkZ/7knd5FkVIhfBoqy1ac9+tcoZ/3XNVQ/e
        fv1Lq/XXT5nzXWn/jRnsK2ZdyhRjWrvnx40l63/2e0h/ex4Tw7AqV4tlso9XEbN5IsvZm/pr
        tcSsch0+Je7Q88pfn+OZ56297Mi0DOmH+ZcCL5lJyaUl9H085WXeYN4np1f26ObaE5pruY7e
        LD3MX3K+7MPCmT53/p3+viRnKZNjS8oR25C+qFZP1ntMzHzPwx8eO1odw7Y23Kct0Ke60655
        dmLM9qszTEM3WLxX3Lz9istU3w1To/8EJwR+zv93beasqcfvv2Q+3SF64/fWG6yynNp9Reyf
        7CQDpO8qfsutuRh7RomlOCPRUIu5qDgRAKVhAEUpBAAA
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220401030847epcms1p8cf7a8e1d8cd7d325dacf30f78da36328
References: <CGME20220401030847epcms1p8cf7a8e1d8cd7d325dacf30f78da36328@epcms1p8>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

snps,dwmac has duplicated name for loongson,ls2k-dwmac and
loongson,ls7a-dwmac.

Signed-off-by: Dongjin Yang <dj76.yang@samsung.com>
---
 Documentation/devicetree/bindings/net/snps,dwmac.yaml | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/snps,dwmac.yaml b/Documentation/devicetree/bindings/net/snps,dwmac.yaml
index 2d5248f..36c85eb 100644
--- a/Documentation/devicetree/bindings/net/snps,dwmac.yaml
+++ b/Documentation/devicetree/bindings/net/snps,dwmac.yaml
@@ -53,20 +53,18 @@ properties:
         - allwinner,sun8i-r40-gmac
         - allwinner,sun8i-v3s-emac
         - allwinner,sun50i-a64-emac
-        - loongson,ls2k-dwmac
-        - loongson,ls7a-dwmac
         - amlogic,meson6-dwmac
         - amlogic,meson8b-dwmac
         - amlogic,meson8m2-dwmac
         - amlogic,meson-gxbb-dwmac
         - amlogic,meson-axg-dwmac
-        - loongson,ls2k-dwmac
-        - loongson,ls7a-dwmac
         - ingenic,jz4775-mac
         - ingenic,x1000-mac
         - ingenic,x1600-mac
         - ingenic,x1830-mac
         - ingenic,x2000-mac
+        - loongson,ls2k-dwmac
+        - loongson,ls7a-dwmac
         - rockchip,px30-gmac
         - rockchip,rk3128-gmac
         - rockchip,rk3228-gmac
-- 
2.9.5
