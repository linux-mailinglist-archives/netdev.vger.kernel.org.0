Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 010DF64EAFE
	for <lists+netdev@lfdr.de>; Fri, 16 Dec 2022 12:56:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229905AbiLPL4Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Dec 2022 06:56:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229469AbiLPL4W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Dec 2022 06:56:22 -0500
Received: from phobos.denx.de (phobos.denx.de [85.214.62.61])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C31C433F;
        Fri, 16 Dec 2022 03:56:21 -0800 (PST)
Received: from wsk (85-222-111-42.dynamic.chello.pl [85.222.111.42])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: lukma@denx.de)
        by phobos.denx.de (Postfix) with ESMTPSA id 1ADD684CBD;
        Fri, 16 Dec 2022 12:56:20 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de;
        s=phobos-20191101; t=1671191780;
        bh=W2uwhnM1KnHLWHQOAr+kuaasVA13yupWdZfCcozE3jg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=P6Al+RuGcliK0ANlkmWfTIP7XF9QSHrti6BUfQknagNdCVrdkf63JJGRWBD9YjdFU
         roP5qqh1zX61St7RVBWXo/XW1KzlZRUe53w3zJQ6hxcQU0uu0kOK4MZcmqUR9SyLGa
         VMhFzmf1XSIsGx+vatpkkX23GPtRXtX+OFIqX+8Q1Hn7idf8kX7T+v7WwvXOIKE//0
         8vPB0GK6+AJRqj2OydXqGjx64y6Efk6qaoXKpr2djx5roBiFbQwdWN0BtBjmWPefLZ
         Gv2mOgj0ttuJc8Xx0804JyuYV64jqg1OHAksaTNwASo3XuDmDZaf7xR9LTiJfFHb97
         Sg+TnGwSpHzlQ==
Date:   Fri, 16 Dec 2022 12:56:12 +0100
From:   Lukasz Majewski <lukma@denx.de>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>, Vladimir Oltean <olteanv@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/3] dsa: marvell: Provide per device information
 about max frame size
Message-ID: <20221216125612.3183fe07@wsk>
In-Reply-To: <20221215202017.4432ef25@kernel.org>
References: <20221215144536.3810578-1-lukma@denx.de>
        <20221215202017.4432ef25@kernel.org>
Organization: denx.de
X-Mailer: Claws Mail 3.19.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/c3k.U7=FBMLow==QLU7n83=";
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

--Sig_/c3k.U7=FBMLow==QLU7n83=
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Jakub,

> On Thu, 15 Dec 2022 15:45:34 +0100 Lukasz Majewski wrote:
> > Different Marvell DSA switches support different size of max frame
> > bytes to be sent.
> >=20
> > For example mv88e6185 supports max 1632 bytes, which is now
> > in-driver standard value. On the other hand - mv88e6250 supports
> > 2048 bytes.
> >=20
> > As this value is internal and may be different for each switch IC,
> > new entry in struct mv88e6xxx_info has been added to store it. =20
>=20
> # Form letter - net-next is closed
>=20

I see....

> We have already submitted the networking pull request to Linus
> for v6.2 and therefore net-next is closed for new drivers, features,
> code refactoring and optimizations. We are currently accepting
> bug fixes only.

Ok.

>=20
> Please repost when net-next reopens after Jan 2nd.
>=20
> RFC patches sent for review only are obviously welcome at any time.

I hope that the discussion regarding those patches will be done by this
time.


Best regards,

Lukasz Majewski

--

DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany
Phone: (+49)-8142-66989-59 Fax: (+49)-8142-66989-80 Email: lukma@denx.de

--Sig_/c3k.U7=FBMLow==QLU7n83=
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCgAdFiEEgAyFJ+N6uu6+XupJAR8vZIA0zr0FAmOcXNwACgkQAR8vZIA0
zr0n1Af+MK+dO8fYjl5t/EZTNMXBCaqMjorxgNDdU61LEUhVXhSzyrizCIOIR7RB
zTAAMtJNvQBiN9xmCulYVwN9iBowwpEaVVUQrzgTJSBYxuLdc5RKa6cNpaWS2vgx
H8ciOO7KYJOeYtVw9FYRXQsvQLo4nE06rvQiyKXcW3p8oq1wiqB6kZ2OZ+EbiMPT
7mpIXZ0O4q50wYqv5i0m96xUyRpWtPncs6f/YeviMfkjkOssI3pTWXxobz2itbxK
OB5Gauf/MnHB5zRKOH7wMjeW7y8LCkageAEcPIRF40/CKvevVRd35G5vqOnXWaHp
2TXQmT4Skl9BagTMc4C7Y2CD3lViHA==
=+0+v
-----END PGP SIGNATURE-----

--Sig_/c3k.U7=FBMLow==QLU7n83=--
