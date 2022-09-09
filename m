Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89D8C5B3917
	for <lists+netdev@lfdr.de>; Fri,  9 Sep 2022 15:37:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231326AbiIINgC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Sep 2022 09:36:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230460AbiIINgA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Sep 2022 09:36:00 -0400
Received: from mail.zeus03.de (www.zeus03.de [194.117.254.33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 978A612168F
        for <netdev@vger.kernel.org>; Fri,  9 Sep 2022 06:35:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple; d=sang-engineering.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=k1; bh=d07l+9icoAhW5M8YCAxkQQTAXsCT
        YpocxQfQ2osUfX0=; b=EMQF7bu4VopK5ivXXrgW0yGJsiDvG5UMaV6IIz1j2Be8
        FY+/lsv52L266/MKTUcYV+TK6hcoDaL8j1ZRWxEd/tFaSX5SiXUoW3nmMlTqwt82
        1HYoKGjrn2cw4764cuiEPlrPclrm/NWu56qfv1pvb6eFFsS/5pkliB4AP1dm/Yo=
Received: (qmail 500285 invoked from network); 9 Sep 2022 15:35:57 +0200
Received: by mail.zeus03.de with ESMTPSA (TLS_AES_256_GCM_SHA384 encrypted, authenticated); 9 Sep 2022 15:35:57 +0200
X-UD-Smtp-Session: l3s3148p1@m5AzoD7oO+AucrSh
Date:   Fri, 9 Sep 2022 15:35:56 +0200
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
Subject: Re: [PATCH 2/2] dt-bindings: net: renesas,etheravb: Add r8a779g0
 support
Message-ID: <YxtBPKg5zesFY3BE@shikoro>
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
 <cddb61cd9702ceefc702176bd8ff640c4ff59ffd.1662714607.git.geert+renesas@glider.be>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="lm72HkNFIToI4sx6"
Content-Disposition: inline
In-Reply-To: <cddb61cd9702ceefc702176bd8ff640c4ff59ffd.1662714607.git.geert+renesas@glider.be>
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--lm72HkNFIToI4sx6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Sep 09, 2022 at 11:13:23AM +0200, Geert Uytterhoeven wrote:
> Document support for the Renesas Ethernet AVB (EtherAVB-IF) block in the
> Renesas R-Car V4H (R8A779G0) SoC.
>=20
> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>

Reviewed-by: Wolfram Sang <wsa+renesas@sang-engineering.com>


--lm72HkNFIToI4sx6
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEOZGx6rniZ1Gk92RdFA3kzBSgKbYFAmMbQTwACgkQFA3kzBSg
KbaXYg/8CpZFPlX03GQFoX2v78TgVtUmEKVapnTyvJpgwQVsSVbl7Iozkai93L+P
cBbbBJK2i2M3gA3LdoYZf9mPSahJfLoF6a/Q7pnGkxWU1HK2Vax6+sMAH7fCVYYJ
WE1hJDqNj+ShFKvpgMaUCNGe6+WeLedP4l0HOoVkocFS4LKwjwxW0jMvNALB/w9w
GZo/cVuX3p1Z1gZseoGQaG//xbfpM3R8DYyqO2sqXqD4nTuCVQ1Czc/ROL8PxANp
XcleWmgAG67nen5KwmHyaRj4ToMLCevlOTRxgIWRUDGGKI4Pm2tCLKmIc7LuUMhw
fAkixwfTmHFUw+QbZXNJZC9cBvj3LzgF5HJJZoIcvadI0hMuEe6zidbq5MsSElxs
fRM0h1b0SaQuUVZGN80YRzn3G22Fyv6Rm4Mh6Of9MvMSS4n2KytMPpSH+5MFCH+B
kV+FJfyaAD5bS1nqV4G1WjFAIhHeXHj9TO9YFBeyNcBqBnieSi04QUoHzylkTgSm
v0BdDCg6u2WA+cE4akHlI9wE7nyMA/aYx87cw95YLUY8zNCXhqur6WuZNTb/nfGt
Co+cgWB84RJxqZ6n+uTJ5kb3A0nMqJsNmf8xawfcrc937/5Cf9s4YAfsfbHIaIVj
s7NBS1oO4XCGkfDzuGdZmLQ/ZCIHhY+8z5d5l2QHwK29BuQdqzg=
=Wjn8
-----END PGP SIGNATURE-----

--lm72HkNFIToI4sx6--
