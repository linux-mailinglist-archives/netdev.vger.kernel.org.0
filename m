Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4174B4F231F
	for <lists+netdev@lfdr.de>; Tue,  5 Apr 2022 08:29:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230218AbiDEGbw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Apr 2022 02:31:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230210AbiDEGbu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Apr 2022 02:31:50 -0400
Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D3FD4BFF7
        for <netdev@vger.kernel.org>; Mon,  4 Apr 2022 23:29:51 -0700 (PDT)
Received: from epcas1p2.samsung.com (unknown [182.195.41.46])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20220405062947epoutp04b38833e4649e9f1cbd5b9a86c321294a~i7ENyUmD40224802248epoutp04P
        for <netdev@vger.kernel.org>; Tue,  5 Apr 2022 06:29:47 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20220405062947epoutp04b38833e4649e9f1cbd5b9a86c321294a~i7ENyUmD40224802248epoutp04P
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1649140188;
        bh=3pRWzO6Xf/+EFDKbp+zs9H1SH94tZcH7lVI+Kk4Rq+8=;
        h=Subject:Reply-To:From:To:CC:In-Reply-To:Date:References:From;
        b=sa2grhab8uvJpE8IjG7L4LWs9y+B4fXOYyhxErhiBGj10ijHPaRKFUc4VenqTbutd
         ydIe1xvGTHLrZe2G8qjjHxYzjWPMnq8Vse9Qr0KlmpRT0/l0vulZRXPEjpAKSv8KGi
         HCDRHftlkQ2iNXXiNseAZqDOtC7fTDjJHC3XkWpI=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas1p3.samsung.com (KnoxPortal) with ESMTP id
        20220405062947epcas1p384012a5de7c0335626086cc06940c3d1~i7ENTk0Jl2146721467epcas1p3L;
        Tue,  5 Apr 2022 06:29:47 +0000 (GMT)
Received: from epsmges1p3.samsung.com (unknown [182.195.36.69]) by
        epsnrtp3.localdomain (Postfix) with ESMTP id 4KXd6K4P8Cz4x9Q2; Tue,  5 Apr
        2022 06:29:45 +0000 (GMT)
X-AuditID: b6c32a37-2a5ff70000002578-b0-624be1d9c358
Received: from epcas1p1.samsung.com ( [182.195.41.45]) by
        epsmges1p3.samsung.com (Symantec Messaging Gateway) with SMTP id
        71.7E.09592.9D1EB426; Tue,  5 Apr 2022 15:29:45 +0900 (KST)
Mime-Version: 1.0
Subject: [PATCH v2] dt-bindings: net: snps: remove duplicate name
Reply-To: dj76.yang@samsung.com
Sender: Dongjin Yang <dj76.yang@samsung.com>
From:   Dongjin Yang <dj76.yang@samsung.com>
To:     "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        "krzk+dt@kernel.org" <krzk+dt@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Moon-Ki Jun <moonki.jun@samsung.com>,
        Dongjin Yang <dj76.yang@samsung.com>,
        Sang Min Kim <hypmean.kim@samsung.com>
X-Priority: 3
X-Content-Kind-Code: NORMAL
In-Reply-To: <20220405061922.27343-1-dj76.yang@samsung.com>
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <20220405062945epcms1p7f9fad7f6bf10597e79c3948ba663c817@epcms1p7>
Date:   Tue, 05 Apr 2022 15:29:45 +0900
X-CMS-MailID: 20220405062945epcms1p7f9fad7f6bf10597e79c3948ba663c817
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
X-CPGSPASS: Y
X-CPGSPASS: Y
CMS-TYPE: 101P
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrCJsWRmVeSWpSXmKPExsWy7bCmru7Nh95JBovvyFm8PKRpMed8C4vF
        /CPnWC12z1jOZDFz6hlmi5ez7rFZ7H29ld3iwrY+VovLu+awWZxbnGlxbIGYxbfTbxgtWvce
        YXfg9diy8iaTx6ZVnWwed67tYfN4v+8qm0ffllWMHp83yQWwRWXbZKQmpqQWKaTmJeenZOal
        2yp5B8c7x5uaGRjqGlpamCsp5CXmptoqufgE6Lpl5gCdqaRQlphTChQKSCwuVtK3synKLy1J
        VcjILy6xVUotSMkpMC/QK07MLS7NS9fLSy2xMjQwMDIFKkzIzlj7qLRgvURF14NDLA2Md8W7
        GDk5JARMJN6e7WbpYuTiEBLYwSjxo287axcjBwevgKDE3x3CIDXCAo4Sl591soOEhQTkJT5P
        rIQI60h0vH3KAhJmE9CSmN2fCDJFRKCfSeLs29tsIA6zwGomicavW9ghdvFKzGgHaQCxpSW2
        L9/KCGJzClhL3Ow6xwwR15D4sawXyhaVuLn6LTuM/f7YfEYIW0Si9d5ZqBpBiQc/d0PFpSQe
        NR+AsqslzrX3soMcISHQwChx8PNGNpBLJQT0JXZcNwap4RXwlTja+RasnkVAVWL/3l9Qu1wk
        Tq69DzafWUBbYtnC18wgrcwCmhLrd+lDTFGWOHKLBearho2/2dHZzAJ8Eu++9rDCxHfMe8IE
        YStLfG5+zTKBUXkWIpxnIdk1C2HXAkbmVYxiqQXFuempxYYFxvCYTc7P3cQITq5a5jsYp739
        oHeIkYmD8RCjBAezkghvTpBnkhBvSmJlVWpRfnxRaU5q8SFGU6AvJzJLiSbnA9N7Xkm8oYml
        gYmZkampoYGFiZI476pppxOFBNITS1KzU1MLUotg+pg4OKUamNL1o25vnmza8/6oif207i9n
        S5dyrXPS/W9zJa1f1+H1Ea9ff3OZih18brAsZF4+K53/c9PWpJMLg3I8U27PvPk1wU8jaOdb
        kztzrP7W6k77dF8pt8erMzDF7VxxzY+Uey26H9UeRUp+U/w9/8//aL9ZUrbJvacq3/k9lzun
        /co/yI1nnsCU8OnGDjl3FAX+/F+35np62sXbTyyqw+1VQi89l67RelFk5Xhn6UuWM4umXZl3
        USLl9InJZUt6Oe9fVFtt+PL6IsVzgdJ3Y3/vKUu/x3jZQJnNdJ3/fRNJZVYp1nmOr37UcE1d
        /euCyMmg2TL5PG/WnlmQcL/oiK2ZSN2jO5FeK1z9j81m3xKblaXEUpyRaKjFXFScCAA3czBw
        NwQAAA==
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220405061903epcas2p345f2b2e656b3b1cbe5832e24dd4a67f3
References: <20220405061922.27343-1-dj76.yang@samsung.com>
        <CGME20220405061903epcas2p345f2b2e656b3b1cbe5832e24dd4a67f3@epcms1p7>
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

snps,dwmac=C2=A0has=C2=A0duplicated=C2=A0name=C2=A0for=C2=A0loongson,ls2k-d=
wmac=C2=A0and=0D=0Aloongson,ls7a-dwmac.=0D=0A=C2=A0=0D=0AFixes:=C2=A0682777=
49a013=C2=A0(=22dt-bindings:=C2=A0dwmac:=C2=A0Add=C2=A0bindings=C2=A0for=C2=
=A0new=C2=A0Loongson=C2=A0SoC=C2=A0and=C2=A0bridge=C2=A0chip=22)=0D=0ASigne=
d-off-by:=C2=A0Dongjin=C2=A0Yang=C2=A0<dj76.yang=40samsung.com>=0D=0A---=0D=
=0ANotes:=0D=0A=C2=A0=C2=A0=C2=A0=C2=A0v2:=C2=A0Update=C2=A0Fix=C2=A0tag=C2=
=A0and=C2=A0change=C2=A0history.=C2=A0=0D=0A=C2=A0=0D=0A=C2=A0Documentation=
/devicetree/bindings/net/snps,dwmac.yaml=C2=A0=7C=C2=A06=C2=A0++----=0D=0A=
=C2=A01=C2=A0file=C2=A0changed,=C2=A02=C2=A0insertions(+),=C2=A04=C2=A0dele=
tions(-)=0D=0A=C2=A0=0D=0Adiff=C2=A0--git=C2=A0a/Documentation/devicetree/b=
indings/net/snps,dwmac.yaml=C2=A0b/Documentation/devicetree/bindings/net/sn=
ps,dwmac.yaml=0D=0Aindex=C2=A02d5248f..36c85eb=C2=A0100644=0D=0A---=C2=A0a/=
Documentation/devicetree/bindings/net/snps,dwmac.yaml=0D=0A+++=C2=A0b/Docum=
entation/devicetree/bindings/net/snps,dwmac.yaml=0D=0A=40=40=C2=A0-53,20=C2=
=A0+53,18=C2=A0=40=40=C2=A0properties:=0D=0A=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0-=C2=A0allwinner,sun8i-r40-gmac=0D=0A=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0-=C2=A0allwinner,sun8i-v3s-emac=
=0D=0A=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0-=C2=A0allwinne=
r,sun50i-a64-emac=0D=0A-=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0-=
=C2=A0loongson,ls2k-dwmac=0D=0A-=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0-=C2=A0loongson,ls7a-dwmac=0D=0A=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0-=C2=A0amlogic,meson6-dwmac=0D=0A=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0-=C2=A0amlogic,meson8b-dwmac=0D=0A=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0-=C2=A0amlogic,meson8m2-dwmac=
=0D=0A=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0-=C2=A0amlogic,=
meson-gxbb-dwmac=0D=0A=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0-=C2=A0amlogic,meson-axg-dwmac=0D=0A-=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0-=C2=A0loongson,ls2k-dwmac=0D=0A-=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0-=C2=A0loongson,ls7a-dwmac=0D=0A=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0-=C2=A0ingenic,jz4775-mac=0D=0A=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0-=C2=A0ingenic,x1000-mac=0D=0A=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0-=C2=A0ingenic,x1600-=
mac=0D=0A=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0-=C2=A0ingen=
ic,x1830-mac=0D=0A=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0-=
=C2=A0ingenic,x2000-mac=0D=0A+=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0-=C2=A0loongson,ls2k-dwmac=0D=0A+=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0-=C2=A0loongson,ls7a-dwmac=0D=0A=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0-=C2=A0rockchip,px30-gmac=0D=0A=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0-=C2=A0rockchip,rk3128-gmac=0D=0A=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0-=C2=A0rockchip,rk3228-gmac=0D=
=0A--=C2=A0=0D=0A2.9.5
