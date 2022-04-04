Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6AC744F0D89
	for <lists+netdev@lfdr.de>; Mon,  4 Apr 2022 04:34:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376901AbiDDCa6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Apr 2022 22:30:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237209AbiDDCa5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 Apr 2022 22:30:57 -0400
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 309B03A5DD
        for <netdev@vger.kernel.org>; Sun,  3 Apr 2022 19:29:02 -0700 (PDT)
Received: from epcas1p2.samsung.com (unknown [182.195.41.46])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20220404022900epoutp029eaaa5348ab6e7136362c7cd60cf7574~ikIr3t_aZ3128031280epoutp02a
        for <netdev@vger.kernel.org>; Mon,  4 Apr 2022 02:29:00 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20220404022900epoutp029eaaa5348ab6e7136362c7cd60cf7574~ikIr3t_aZ3128031280epoutp02a
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1649039340;
        bh=DO7cgGgTHvQMHO2GGJ8drJXd4TGsXZIl9hBqmml2nKE=;
        h=Subject:Reply-To:From:To:CC:Date:References:From;
        b=MYqdWOhx8hbOZ73orzX9YurUI567HMmbgIGfv4GB5QtPdvcqe4s4uPTJ4n4N+PWfY
         QBvvhmw8sRadPTupaUx6BzX3O6d4S1+RGnuYO0cd10A2bebW2GSDW56M5vT7XS7eeO
         jrs3TT9GEXfh9c4GlWDALtK9I7VILPZHs32oF8bA=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas1p2.samsung.com (KnoxPortal) with ESMTP id
        20220404022859epcas1p2534f9bb1d4f81265dd56e830c0bcaff5~ikIrRX2wq1815818158epcas1p23;
        Mon,  4 Apr 2022 02:28:59 +0000 (GMT)
Received: from epsmges1p4.samsung.com (unknown [182.195.36.70]) by
        epsnrtp2.localdomain (Postfix) with ESMTP id 4KWvpy10X0z4x9Q7; Mon,  4 Apr
        2022 02:28:58 +0000 (GMT)
X-AuditID: b6c32a38-93fff700000255ac-c8-624a57e90621
Received: from epcas1p4.samsung.com ( [182.195.41.48]) by
        epsmges1p4.samsung.com (Symantec Messaging Gateway) with SMTP id
        DB.BC.21932.9E75A426; Mon,  4 Apr 2022 11:28:58 +0900 (KST)
Mime-Version: 1.0
Subject: [PATCH] dt-bindings: net: snps: remove duplicate name
Reply-To: dj76.yang@samsung.com
Sender: Dongjin Yang <dj76.yang@samsung.com>
From:   Dongjin Yang <dj76.yang@samsung.com>
To:     "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "krzk+dt@kernel.org" <krzk+dt@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
CC:     Moon-Ki Jun <moonki.jun@samsung.com>,
        Dongjin Yang <dj76.yang@samsung.com>
X-Priority: 3
X-Content-Kind-Code: NORMAL
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <20220404022857epcms1p6e6af1a6a86569f339e50c318abde7d3c@epcms1p6>
Date:   Mon, 04 Apr 2022 11:28:57 +0900
X-CMS-MailID: 20220404022857epcms1p6e6af1a6a86569f339e50c318abde7d3c
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
X-CPGSPASS: Y
X-CPGSPASS: Y
CMS-TYPE: 101P
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprHJsWRmVeSWpSXmKPExsWy7bCmge6rcK8kg3tLmC1eHtK0mHO+hcVi
        /pFzrBa7Zyxnsng56x6bxd7XW9ktLmzrY7W4vGsOm8W5xZkWxxaIWXw7/YbRonXvEXYHHo8t
        K28yeWxa1cnmcefaHjaP9/uusnn0bVnF6PF5k1wAW1S2TUZqYkpqkUJqXnJ+SmZeuq2Sd3C8
        c7ypmYGhrqGlhbmSQl5ibqqtkotPgK5bZg7QhUoKZYk5pUChgMTiYiV9O5ui/NKSVIWM/OIS
        W6XUgpScAvMCveLE3OLSvHS9vNQSK0MDAyNToMKE7Iz9Z/sZC+ZxVUybtoepgfEeexcjJ4eE
        gInE92+L2UBsIYEdjBLLG1S7GDk4eAUEJf7uEAYJCwvYSTz4+ZsNJCwkIC/xeWIlRFhHouPt
        UxaQMJuAlsTs/sQuRi4OEYFDzBKzp/xiAqlhFgiQWLrzJxPEJl6JGe0g9SC2tMT25VsZIWwN
        iR/LepkhbFGJm6vfssPY74/Nh6oRkWi9dxaqRhDonN1QcSmJR80HoOxqiXPtvewgR0gINDBK
        HPy8EexmCQF9iR3XjUFqeAV8JaY1/mcFsVkEVCVOPl/ECtHrIjH/3UIWiJvlJba/ncMM0sos
        oCmxfpc+xBRliSO3WGA+adj4mx2dzSzAJ/Huaw8rTHzHvCdQnytLfG5+DdUrKbF48kzmCYxK
        sxDBPAvJ3lkIexcwMq9iFEstKM5NTy02LDCBR2xyfu4mRnBC1bLYwTj37Qe9Q4xMHIyHGCU4
        mJVEeHOCPJOEeFMSK6tSi/Lji0pzUosPMZoCfTyRWUo0OR+Y0vNK4g1NLA1MzIxMTQ0NLEyU
        xHl7p55OFBJITyxJzU5NLUgtgulj4uCUamCqV/6jk/7vv9evVN6DcZ5FD5x+ir6ui6tcqB78
        7NS/6FdJq7b9/n63P1LnEqsxi5VHdf4mkyBZqc1pqr8lw18y3DFyrzy9dK/vLS2hb2kV60sf
        LhbJ+8XyvnS2RtlWu2o+kzX1Gy69De8rX/n/+XXtPzdmy/w9N2+mR8G6AOUFZ26ePXawXLs5
        8M5jnZ8sMfV1z66LTlD9b6T/d4dkK8P2zNtsOydV3zC32nk4XTspfXda/q8dJcqhu1vO5uXK
        Mf/bXMh8U/exfMXuw1LSU3bEaM/6dWZNtcrv90ufbYzZr6VvXZuf8Pzo7eglPgvvnXJRVlnA
        t9fmXkCW5vx+7Vttjx7dT7n/6qv2ks3nNZzclViKMxINtZiLihMBFMumYjEEAAA=
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220404022857epcms1p6e6af1a6a86569f339e50c318abde7d3c
References: <CGME20220404022857epcms1p6e6af1a6a86569f339e50c318abde7d3c@epcms1p6>
X-Spam-Status: No, score=-5.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
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
