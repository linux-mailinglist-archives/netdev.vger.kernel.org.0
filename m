Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D31455B391E
	for <lists+netdev@lfdr.de>; Fri,  9 Sep 2022 15:37:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230414AbiIINf5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Sep 2022 09:35:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231290AbiIINfz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Sep 2022 09:35:55 -0400
Received: from mail.zeus03.de (www.zeus03.de [194.117.254.33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 268EF11EA9D
        for <netdev@vger.kernel.org>; Fri,  9 Sep 2022 06:35:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple; d=sang-engineering.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=k1; bh=Xk82tRJQjykSFQkUPrfn3jt/YW+1
        CSEfjjTPsonnHho=; b=JDgOd/ZUV/i8CR0tK/yMq+067PBzloAHoo0PdRpzWw9a
        xaKcu5BF0w6QDgr8jjPAsPo/Qhtwp/JslkowD85xXwphc0EuuBEmQ9S/iVma/sQZ
        MQT1vTx5DZg2Byals6W/qnGaQgwKmpBPlL9UlVQJu4RYqTWsaja66e2NZ/oVmDk=
Received: (qmail 500212 invoked from network); 9 Sep 2022 15:35:51 +0200
Received: by mail.zeus03.de with ESMTPSA (TLS_AES_256_GCM_SHA384 encrypted, authenticated); 9 Sep 2022 15:35:51 +0200
X-UD-Smtp-Session: l3s3148p1@H+Lenz7oho8ucrSh
Date:   Fri, 9 Sep 2022 15:35:51 +0200
From:   Wolfram Sang <wsa+renesas@sang-engineering.com>
To:     Geert Uytterhoeven <geert+renesas@glider.be>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Sergey Shtylyov <s.shtylyov@omp.ru>,
        Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH 1/2] dt-bindings: net: renesas,etheravb: R-Car V3U is
 R-Car Gen4
Message-ID: <YxtBNzK4pxf6yA4X@shikoro>
Mail-Followup-To: Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Sergey Shtylyov <s.shtylyov@omp.ru>,
        Sergei Shtylyov <sergei.shtylyov@gmail.com>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-renesas-soc@vger.kernel.org
References: <cover.1662714607.git.geert+renesas@glider.be>
 <5355709e0744680d792d1e57e43441cb0b7b7611.1662714607.git.geert+renesas@glider.be>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="ceWgtDKGkpjjowgR"
Content-Disposition: inline
In-Reply-To: <5355709e0744680d792d1e57e43441cb0b7b7611.1662714607.git.geert+renesas@glider.be>
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--ceWgtDKGkpjjowgR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Sep 09, 2022 at 11:13:22AM +0200, Geert Uytterhoeven wrote:
> Despite the name, R-Car V3U is the first member of the R-Car Gen4
> family.  Hence move its compatible value to the R-Car Gen4 section.
>=20
> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>

Reviewed-by: Wolfram Sang <wsa+renesas@sang-engineering.com>


--ceWgtDKGkpjjowgR
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEOZGx6rniZ1Gk92RdFA3kzBSgKbYFAmMbQTYACgkQFA3kzBSg
KbbwXw/8D8AUJr+TXwX+aKCUwtdmESCJhfTZsRW5EVrJ1zNxT2QaeQ3utNl3PAyB
pTbEwfAh0TSinb6JgtyvoSVsseWUBmXfn0gSG5XwsoZ8vXuwhJQtzQomWiVmF3Jg
rnlNgPOoy7OSFcgzb/Ia/PF0UWUSpOu7vb7wso83cmeFfwjTpW0Lrk06pbm23aPK
Za5q0Td1csj1kmzDNELx2iS7VPYg8/ZQD3JI2ne1npZHZOnQ9Wx40sQIGvuXopoJ
HjFCZCMrMLMAF1SDJPkz6BkmAQzqAtt44h13Rb46X770/m+V6YcuUAnrrHmpnPSM
PyEegbnYX0miLGB31Q7QeHPDCefNfGGvhQz353H9E7b4dQE3ZAuT5jx6uoQ5zCWN
u5Y3yBXLc8ap/u39Iz2f7qUqxFDL2vp0Y4dZSt2e4VlZlCSReODFkLRyVjMbluCZ
wacP2JGfSbglFxkqfGgeZPX1c1sWDblaHWUaMrgXHwYsrju4202/vbyBkXpD7X+K
me40v8gLKxxTuSQM/oGp5wSYHzGuSBXf6D3xsVh8USosreBRfrv6Wgnrbzj0lzvI
StpsGPnN+MrO/PoGZ1bLMMR+7QDYVbgZeNwK3AVHstFirGc/E58eUbEUWKTWvlRm
YsT2fvYZG3rnQ4aBHceLDxkJnSDXOElzJYZRPEkL59Yv1mcZcWU=
=c59C
-----END PGP SIGNATURE-----

--ceWgtDKGkpjjowgR--
