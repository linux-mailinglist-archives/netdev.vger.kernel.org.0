Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5F704F0D7F
	for <lists+netdev@lfdr.de>; Mon,  4 Apr 2022 04:28:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241665AbiDDCZR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Apr 2022 22:25:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241643AbiDDCZR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 Apr 2022 22:25:17 -0400
Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85B3732EED
        for <netdev@vger.kernel.org>; Sun,  3 Apr 2022 19:23:21 -0700 (PDT)
Received: from epcas1p2.samsung.com (unknown [182.195.41.46])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20220404022315epoutp04cd8f3169fe116b3c2e508621e7e9ee13~ikDrW2Imt2502525025epoutp04V
        for <netdev@vger.kernel.org>; Mon,  4 Apr 2022 02:23:15 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20220404022315epoutp04cd8f3169fe116b3c2e508621e7e9ee13~ikDrW2Imt2502525025epoutp04V
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1649038995;
        bh=3+1PjNGkzbazH4CYxD0j8uvUdMBAPRFiEZJ+o1nR5Bg=;
        h=Subject:Reply-To:From:To:Date:References:From;
        b=d1eYnecMDVWydqwssY9k62bKg94I3oNyyvP1LAV9A/o+AZAFfmvbxR+Z1U0McPVzX
         e5ryrskmgqKS+PN/MqfireOUKfeIBtuh3IA8vIu38VBo3E/r9Ilq7YH0HyD787GGzW
         W8yXDnPpIHZi1mCenBqE6fMgrpHbBurE1vxRgudA=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
        epcas1p2.samsung.com (KnoxPortal) with ESMTP id
        20220404022315epcas1p27f1ea97246e15152cc689044f1e477b8~ikDq8AyQl2282422824epcas1p2K;
        Mon,  4 Apr 2022 02:23:15 +0000 (GMT)
Received: from epsmges1p1.samsung.com (unknown [182.195.36.99]) by
        epsnrtp1.localdomain (Postfix) with ESMTP id 4KWvhL2FtQz4x9QQ; Mon,  4 Apr
        2022 02:23:14 +0000 (GMT)
X-AuditID: b6c32a35-9c3ff7000000fa55-4a-624a56929ea3
Received: from epcas1p3.samsung.com ( [182.195.41.47]) by
        epsmges1p1.samsung.com (Symantec Messaging Gateway) with SMTP id
        A3.FF.64085.2965A426; Mon,  4 Apr 2022 11:23:14 +0900 (KST)
Mime-Version: 1.0
Subject: Re: [PATCH] dt-bindings: net: snps: remove duplicate name
Reply-To: dj76.yang@samsung.com
Sender: Dong-Jin Yang <dj76.yang@samsung.com>
From:   Dong-Jin Yang <dj76.yang@samsung.com>
To:     "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "krzk+dt@kernel.org" <krzk+dt@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Dong-Jin Yang <dj76.yang@samsung.com>,
        Moon-Ki Jun <moonki.jun@samsung.com>
X-Priority: 3
X-Content-Kind-Code: NORMAL
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <20220404022313epcms1p6767800dd9ff1f238f2ff0b560a495316@epcms1p6>
Date:   Mon, 04 Apr 2022 11:23:13 +0900
X-CMS-MailID: 20220404022313epcms1p6767800dd9ff1f238f2ff0b560a495316
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
X-CPGSPASS: Y
X-CPGSPASS: Y
CMS-TYPE: 101P
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprPJsWRmVeSWpSXmKPExsWy7bCmvu6kMK8kg7+r+S1eHtK0mHO+hcVi
        /pFzrBa7Zyxnsng56x6bxd7XW9ktLmzrY7W4vGsOm8W5xZkWxxaIWXw7/YbRonXvEXYHHo8t
        K28yeWxa1cnmcefaHjaP9/uusnn0bVnF6PF5k1wAW1S2TUZqYkpqkUJqXnJ+SmZeuq2Sd3C8
        c7ypmYGhrqGlhbmSQl5ibqqtkotPgK5bZg7QhUoKZYk5pUChgMTiYiV9O5ui/NKSVIWM/OIS
        W6XUgpScAvMCveLE3OLSvHS9vNQSK0MDAyNToMKE7Iyr/Z/YCi6LVVw7P4O5gbFZrIuRk0NC
        wERi0cGHbF2MXBxCAjsYJR6ufgfkcHDwCghK/N0hDFIjLOAkseJ9HwtIWEhAXuLzxEqIsK7E
        rN/LmEBsNgFtiRWnJrKAjBERmMgicevndBaI+bwSM9qfQtnSEtuXb2WEsDUkfizrZYawRSVu
        rn7LDmO/PzYfqkZEovXeWagaQYkHP3dDxaUkHjUfgLKrJc6190L1NjBKbPuoCHKnhIC+xI7r
        xiBhXgFfiX8L9oGdwCKgKnF6yTWokS4S69bfAYszA92/bOFrZpBWZgFNifW79CGmKEscuQX3
        SMPG3+zobGYBPol3X3tYYeI75j1hgrCVJT43v4bqlZRYPHkm1FYPiVWHDrNNYFSchQjmWUhu
        mIVwwwJG5lWMYqkFxbnpqcWGBYbwmE3Oz93ECE6pWqY7GCe+/aB3iJGJg/EQowQHs5IIb06Q
        Z5IQb0piZVVqUX58UWlOavEhRlOg7ycyS4km5wOTel5JvKGJpYGJmZGpqaGBhYmSOO+qaacT
        hQTSE0tSs1NTC1KLYPqYODilGphOKEUrL2U0zjhjemhV2QPOyDSlbV8OBTxatfVpZXMGv0+Q
        QUvMk5fLHnP9lO78XL58WbV4hFM2c8unXY2lG876as78+jy94IHDDmm2KZKcTul6zosfzZa7
        +3liTD7T1Ftn5NOeTDu7POLVrb0bL3Ep70pbnTRpJqfrrBKhiZ+n3f9Y5NPeosNnldEjHBqY
        VXva2+hGcvibF7fljZn2G3aX27W9tPl1Z+ds27DHbaqKj1l8N8658jczbNP+3Y+aS40K+DK3
        Fpw90KEyr6DmfFq6kcbj3AflLoscec4byYu+rLy3qLThuveucxahot75vF8U2CyOiMRu9+5L
        LA64XcDVLmke73Yw61xT+bOoaiWW4oxEQy3mouJEAKFgdEgyBAAA
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220404022313epcms1p6767800dd9ff1f238f2ff0b560a495316
References: <CGME20220404022313epcms1p6767800dd9ff1f238f2ff0b560a495316@epcms1p6>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> On 01/04/2022 05:08, =EC=96=91=EB=8F=99=EC=A7=84=20wrote:=0D=0A>=20snps,d=
wmac=20has=20duplicated=20name=20for=20loongson,ls2k-dwmac=20and=0D=0A>=20l=
oongson,ls7a-dwmac.=0D=0A>=20=0D=0A>=20Your=20=22From=22=20name=20seems=20t=
o=20be=20different=20than=20Signed-off-by.=20These=20should=0D=0A>=20be=20t=
he=20same,=20so=20can=20you=20fix=20the=20commit=20author=20to=20be=20the=
=20same=20as=20SoB?=0D=0A>=0D=0A=20=0D=0ASorry,=20my=20email=20client=20put=
=20=22From=22=20as=20local=20language.=20Let=20me=20resend=20it.=0D=0A=0D=
=0A>>=20=0D=0A>>=20Signed-off-by:=20Dongjin=20Yang=20<dj76.yang=40samsung.c=
om>=0D=0A>=20=0D=0A>=20Fixes:=2068277749a013=20(=22dt-bindings:=20dwmac:=20=
Add=20bindings=20for=20new=20Loongson=0D=0A>=20SoC=20and=20bridge=20chip=22=
)=0D=0A>=20=0D=0A>>=20---=0D=0A>>=20=20Documentation/devicetree/bindings/ne=
t/snps,dwmac.yaml=20=7C=206=20++----=0D=0A>>=20=201=20file=20changed,=202=
=20insertions(+),=204=20deletions(-)=0D=0A>>=20=0D=0A>>=20diff=20--git=20a/=
Documentation/devicetree/bindings/net/snps,dwmac.yaml=20b/Documentation/dev=
icetree/bindings/net/snps,dwmac.yaml=0D=0A>>=20index=202d5248f..36c85eb=201=
00644=0D=0A>>=20---=20a/Documentation/devicetree/bindings/net/snps,dwmac.ya=
ml=0D=0A>>=20+++=20b/Documentation/devicetree/bindings/net/snps,dwmac.yaml=
=0D=0A>>=20=40=40=20-53,20=20+53,18=20=40=40=20properties:=0D=0A>>=20=20=20=
=20=20=20=20=20=20=20-=20allwinner,sun8i-r40-gmac=0D=0A>>=20=20=20=20=20=20=
=20=20=20=20-=20allwinner,sun8i-v3s-emac=0D=0A>>=20=20=20=20=20=20=20=20=20=
=20-=20allwinner,sun50i-a64-emac=0D=0A>>=20-=20=20=20=20=20=20=20=20-=20loo=
ngson,ls2k-dwmac=0D=0A>>=20-=20=20=20=20=20=20=20=20-=20loongson,ls7a-dwmac=
=0D=0A>>=20=20=20=20=20=20=20=20=20=20-=20amlogic,meson6-dwmac=0D=0A>>=20=
=20=20=20=20=20=20=20=20=20-=20amlogic,meson8b-dwmac=0D=0A>>=20=20=20=20=20=
=20=20=20=20=20-=20amlogic,meson8m2-dwmac=0D=0A>>=20=20=20=20=20=20=20=20=
=20=20-=20amlogic,meson-gxbb-dwmac=0D=0A>>=20=20=20=20=20=20=20=20=20=20-=
=20amlogic,meson-axg-dwmac=0D=0A>>=20-=20=20=20=20=20=20=20=20-=20loongson,=
ls2k-dwmac=0D=0A>>=20-=20=20=20=20=20=20=20=20-=20loongson,ls7a-dwmac=0D=0A=
>>=20=20=20=20=20=20=20=20=20=20-=20ingenic,jz4775-mac=0D=0A>>=20=20=20=20=
=20=20=20=20=20=20-=20ingenic,x1000-mac=0D=0A>>=20=20=20=20=20=20=20=20=20=
=20-=20ingenic,x1600-mac=0D=0A>>=20=20=20=20=20=20=20=20=20=20-=20ingenic,x=
1830-mac=0D=0A>>=20=20=20=20=20=20=20=20=20=20-=20ingenic,x2000-mac=0D=0A>>=
=20+=20=20=20=20=20=20=20=20-=20loongson,ls2k-dwmac=0D=0A>>=20+=20=20=20=20=
=20=20=20=20-=20loongson,ls7a-dwmac=0D=0A>>=20=20=20=20=20=20=20=20=20=20-=
=20rockchip,px30-gmac=0D=0A>>=20=20=20=20=20=20=20=20=20=20-=20rockchip,rk3=
128-gmac=0D=0A>>=20=20=20=20=20=20=20=20=20=20-=20rockchip,rk3228-gmac=0D=
=0A>=20=0D=0A>=20=0D=0A>=20Best=20regards,=0D=0A>=20Krzysztof=20=0D=0A=0D=
=0ABest=20regards,=0D=0ADongJin
