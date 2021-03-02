Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBA0832B38F
	for <lists+netdev@lfdr.de>; Wed,  3 Mar 2021 05:19:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1449723AbhCCECb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Mar 2021 23:02:31 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:46396 "EHLO
        mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1575675AbhCBPYG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Mar 2021 10:24:06 -0500
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
        by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20210302152253euoutp0122e815c9d6cd4cd3d2e46cf412eb7c2f~oj8we7mNi1031710317euoutp01C
        for <netdev@vger.kernel.org>; Tue,  2 Mar 2021 15:22:53 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20210302152253euoutp0122e815c9d6cd4cd3d2e46cf412eb7c2f~oj8we7mNi1031710317euoutp01C
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1614698573;
        bh=IFlB1ws4LuM5ICN3XgQN08EPvMv0h5PpaL58WYOIcAU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=taaGFCK5gTFlMSKHWQJDuRc1UdIvlCeUZiXi7LiZrm7RZb9XgLjBi8tvQRZKpd1UW
         BpghItdIZxMPGf/Wslt3pmWXGbTDqeBJ2OAOU0FL6aq/BrYPOF31Vv8jRQOg9eLvXK
         olA7YUyBJSg2zTLz1W0YLg9y+GB+xVXZ4xUQKzvI=
Received: from eusmges1new.samsung.com (unknown [203.254.199.242]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTP id
        20210302152252eucas1p25a88641ce102984d7e192fe5416f780b~oj8v-xKmw2148221482eucas1p2E;
        Tue,  2 Mar 2021 15:22:52 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
        eusmges1new.samsung.com (EUCPMTA) with SMTP id 91.DE.27958.C485E306; Tue,  2
        Mar 2021 15:22:52 +0000 (GMT)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
        20210302152252eucas1p15eb47b959fe36190286668071250d580~oj8vff3Yo2321123211eucas1p1Y;
        Tue,  2 Mar 2021 15:22:52 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
        eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20210302152252eusmtrp19741e546b115c72cb5649e0d2923a6f5~oj8veu6ku1781717817eusmtrp10;
        Tue,  2 Mar 2021 15:22:52 +0000 (GMT)
X-AuditID: cbfec7f2-f15ff70000006d36-0f-603e584c1b11
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
        eusmgms2.samsung.com (EUCPMTA) with SMTP id 69.25.16282.C485E306; Tue,  2
        Mar 2021 15:22:52 +0000 (GMT)
Received: from localhost (unknown [106.120.51.46]) by eusmtip2.samsung.com
        (KnoxPortal) with ESMTPA id
        20210302152251eusmtip29ed4fb134b54fdd73d6d075c9d321158~oj8vRMZ2N1864418644eusmtip2y;
        Tue,  2 Mar 2021 15:22:51 +0000 (GMT)
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
Subject: [RESEND PATCH v11 1/3] dt-bindings: vendor-prefixes: Add asix
 prefix
Date:   Tue,  2 Mar 2021 16:22:48 +0100
Message-Id: <20210302152250.27113-2-l.stelmach@samsung.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210302152250.27113-1-l.stelmach@samsung.com>
MIME-Version: 1.0
Organization: Samsung R&D Institute Poland
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrKKsWRmVeSWpSXmKPExsWy7djP87o+EXYJBku/a1icv3uI2WLjjPWs
        FnPOt7BYzD9yjtVi0fsZrBbX3t5hteh//JrZ4vz5DewWF7b1sVrcPLSC0WLT42usFpd3zWGz
        mHF+H5PFoal7GS3WHrnLbnFsgZhF694j7Bb/9+xgdxDyuHztIrPHlpU3mTx2zrrL7rFpVSeb
        x+Yl9R47d3xm8ujbsorR4/MmuQCOKC6blNSczLLUIn27BK6MGT8eMxb8ZKto7/7N1MD4k7WL
        kZNDQsBEYs/uD4xdjFwcQgIrGCWe/zrBBOF8YZRo2jqdBcL5zCix7tQ/dpiWX/P+QLUsZ5TY
        8XslWEJI4DmjxNLnSiA2m4CjRP/SE6wgRSIC95gl1rc/AOtgFrjPKHHv+WpmkCphAX+J7avO
        s4DYLAKqEoeXnASL8wpYSyx+e4cFYp28RPvy7WwgNqeAjcSGk+tYIGoEJU7OfAJm8wtoSaxp
        ug5mMwPVN2+dzQyyTELgMKfEi0NvgZo5gBwXiaVbNSBmCku8Or4F6h0ZidOTe1ggSuolJk8y
        g2jtYZTYNucH1A3WEnfO/QIbwyygKbF+lz5E2FHi2IVedohWPokbbwUhLuCTmLRtOjNEmFei
        o00IolpFYl3/HqiBUhK9r1YwTmBUmoXkl1lI7p+FsGsBI/MqRvHU0uLc9NRiw7zUcr3ixNzi
        0rx0veT83E2MwJR3+t/xTzsY5776qHeIkYmD8RCjBAezkgiv+EvbBCHelMTKqtSi/Pii0pzU
        4kOM0hwsSuK8q2aviRcSSE8sSc1OTS1ILYLJMnFwSjUwKU2rXMjQsKVbb9pF6Wu3Pj+Z9i/x
        18ZwxzsTvdRSjZkaCqdM445Ob9m72HZNfHGA9G25xRO0z1uxnLjSWfvvs1cy22WD/1oLpwr2
        npn530Hq5swkwV+7LwRzhcQbiH37kBDAW210rUXu5vcmw9zoXI9PatG73nSkWf/+dlxa8dSM
        vfOFPp/kKXxozxKQmsXt/1547+qdAs3e12ZHZy3qt1y7OWK/3IbzN5ZxiBY/vmCr5ZO4QPB9
        wdtfhdx2l3LmKDzLneHlvea//d9HJw+1vmHcdT7k5cmTxlz/JIMTarlCcxI+63X9/ZxzM+LQ
        jRfF3KKcbOKlB3lS/DauP5wbY9P0XLNh12OmbYfE7G3fKLEUZyQaajEXFScCANBIz17oAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrOIsWRmVeSWpSXmKPExsVy+t/xe7o+EXYJBjcXslmcv3uI2WLjjPWs
        FnPOt7BYzD9yjtVi0fsZrBbX3t5hteh//JrZ4vz5DewWF7b1sVrcPLSC0WLT42usFpd3zWGz
        mHF+H5PFoal7GS3WHrnLbnFsgZhF694j7Bb/9+xgdxDyuHztIrPHlpU3mTx2zrrL7rFpVSeb
        x+Yl9R47d3xm8ujbsorR4/MmuQCOKD2bovzSklSFjPziElulaEMLIz1DSws9IxNLPUNj81gr
        I1MlfTublNSczLLUIn27BL2MGT8eMxb8ZKto7/7N1MD4k7WLkZNDQsBE4te8P4xdjFwcQgJL
        GSWOv/gLlOAASkhJrJybDlEjLPHnWhcbRM1TRokt646CNbMJOEr0Lz3BCpIQEXjDLNF07y07
        iMMscJ9R4tenF4wgVcICvhKLZ8xlArFZBFQlDi85yQxi8wpYSyx+e4cFYoW8RPvy7WwgNqeA
        jcSGk+vA4kJANYvur2SHqBeUODnzCQvIdcwC6hLr5wmBhPkFtCTWNF0HK2cGGtO8dTbzBEah
        WUg6ZiF0zEJStYCReRWjSGppcW56brGRXnFibnFpXrpecn7uJkZgjG879nPLDsaVrz7qHWJk
        4mA8xCjBwawkwiv+0jZBiDclsbIqtSg/vqg0J7X4EKMp0GcTmaVEk/OBSSavJN7QzMDU0MTM
        0sDU0sxYSZzX5MiaeCGB9MSS1OzU1ILUIpg+Jg5OqQamxROnx6tGz7h548i7Lf2+qhFmtZPF
        5Roteiw+Ork7O/DwSPk8P9u2fQr/VdfjWww004NzD81m2XP2ZWr/DCOvZL6fG45t0RNKNpbl
        KTsoJz49QWB6iXVlb0Ja5oWSzyf4ApvKOPJb+jq97lqLfTRZqqRy2cdynozdinlMV1Sy2ooj
        Ha3n/1hoovElxJvjwDVXB+0NtxwtH143nzTjV5fcon8pBxdPa/Cd4WmU99jUL+tU22GtwKvT
        Vr5u5v1z65Y46xRpAwn1RYlGSiVKCR8UFdZwfjadnnU0JHsvyxrz/IBbJ9MmXOe6MNly3lPF
        1xe0Qmbq6S2cZWl3pe3t0i1xqYYHNZjZ/vLVcmw0MVViKc5INNRiLipOBADUfBqSegMAAA==
X-CMS-MailID: 20210302152252eucas1p15eb47b959fe36190286668071250d580
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20210302152252eucas1p15eb47b959fe36190286668071250d580
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20210302152252eucas1p15eb47b959fe36190286668071250d580
References: <20210302152250.27113-1-l.stelmach@samsung.com>
        <CGME20210302152252eucas1p15eb47b959fe36190286668071250d580@eucas1p1.samsung.com>
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
index f3134f44c80c..cd1712660b98 100644
--- a/Documentation/devicetree/bindings/vendor-prefixes.yaml
+++ b/Documentation/devicetree/bindings/vendor-prefixes.yaml
@@ -127,6 +127,8 @@ patternProperties:
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

