Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E112627824
	for <lists+netdev@lfdr.de>; Mon, 14 Nov 2022 09:51:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229689AbiKNIvt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Nov 2022 03:51:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236037AbiKNIvr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Nov 2022 03:51:47 -0500
Received: from phobos.denx.de (phobos.denx.de [85.214.62.61])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 922BA1C913
        for <netdev@vger.kernel.org>; Mon, 14 Nov 2022 00:51:46 -0800 (PST)
Received: from wsk (85-222-111-42.dynamic.chello.pl [85.222.111.42])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: lukma@denx.de)
        by phobos.denx.de (Postfix) with ESMTPSA id 089A382162;
        Mon, 14 Nov 2022 09:51:43 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de;
        s=phobos-20191101; t=1668415904;
        bh=/jelVlPPk5LMZxTTuuUSrpw8X9VTuLmHEK4GIqqLpRE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=R9U839ZjUX2mt7mSpuTo35K93rUa/JwZ4qwv8Rh2/7dPQ+6+RgQXNA8OY4gb3k7sB
         OqTWjOwVvNR6RXW4mGi9Y6DLfOkqPDPI1lQ/Id/EH4UY8rDFYp8hbztEUAtMnEe2F/
         tK8LwINW1JRrzKij11Jgjas5/6PaLbhym+R8PcVWGAV9ZjhIOerFad7OmIHaFXESKr
         avVQYO1DHfofX9oKltFH36l+CHs2hVsJEJUkOjYE+ZfV0PCOvBfxDLN3H8XkHACH5K
         gU1aGUkbT8i5lxcIUH3549Mg4qlqw+lHLH+N/odqb27258bZ4LIBdOTqFHN+CW3TPB
         Re3jLYzBPiy3g==
Date:   Mon, 14 Nov 2022 09:51:36 +0100
From:   Lukasz Majewski <lukma@denx.de>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        Matthias Schiffer <matthias.schiffer@ew.tq-group.com>
Subject: Re: [PATCH 1/9] net: dsa: allow switch drivers to override default
 slave PHY addresses
Message-ID: <20221114095136.2d83ee74@wsk>
In-Reply-To: <Y211tK/kjSAL4qKb@lunn.ch>
References: <20221108082330.2086671-1-lukma@denx.de>
        <20221108082330.2086671-2-lukma@denx.de>
        <Y2pX0qrLs/OCQOFr@lunn.ch>
        <20221110163425.7b4974d5@wsk>
        <Y211tK/kjSAL4qKb@lunn.ch>
Organization: denx.de
X-Mailer: Claws Mail 3.19.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/l=D+D3eyIB.iakEZcnEKuHZ";
 protocol="application/pgp-signature"; micalg=pgp-sha512
X-Virus-Scanned: clamav-milter 0.103.6 at phobos.denx.de
X-Virus-Status: Clean
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/l=D+D3eyIB.iakEZcnEKuHZ
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

> > It depends if the HW designer set this bootstrap pin low or high :-)
> > (often this pin is not concerned until mainline/BSP driver is not
> > working :-) )
> >=20
> > As it costs $ to fix this - it is easier to add "quirk" to the
> > code. =20
>=20
> Can you read the strapping configuration via the scratch registers?
> Then you can detect it at probe time and do the right thing.
>=20

This is how I do it, yes. My impression is that some DTS descriptions
have this hardcoded instead.

>      Andrew




Best regards,

Lukasz Majewski

--

DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany
Phone: (+49)-8142-66989-59 Fax: (+49)-8142-66989-80 Email: lukma@denx.de

--Sig_/l=D+D3eyIB.iakEZcnEKuHZ
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCgAdFiEEgAyFJ+N6uu6+XupJAR8vZIA0zr0FAmNyAZgACgkQAR8vZIA0
zr3LUAgA1Xi3WwrR1Oje9C1KzJGb2XrS8Q04zY0Ai3CcorXrADaH96ZKoa015SU9
pUjFntaQeX3vQUAsC9O6y/86/G2GQ+hZFNVDTrE3jRDLukWRVT0vualyCgJQRx27
kAlS+MAZMg1meaVCEJXIuRdWBM9AIz3RyDCQzPRel56htYCORMpA/aY3WDVAaxBv
xiM6HaW7jqXw2/cn/S/C0qBb4vh+TYBEsdl3fqIxQO2l+0yEWC+MED34q8nP06BQ
0kVlUXKYzggAjNlUrc8Cfe8G1Td3Jm9bPO6vSjYGESOnvIm9DxgkCIi0TMQhDWao
it5mig2sEY9yDYZ7nTgQPPwPcFUDtg==
=q1az
-----END PGP SIGNATURE-----

--Sig_/l=D+D3eyIB.iakEZcnEKuHZ--
