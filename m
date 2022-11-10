Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5DA85624634
	for <lists+netdev@lfdr.de>; Thu, 10 Nov 2022 16:43:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231633AbiKJPmk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Nov 2022 10:42:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231618AbiKJPmj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Nov 2022 10:42:39 -0500
Received: from phobos.denx.de (phobos.denx.de [85.214.62.61])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7E182F3B6
        for <netdev@vger.kernel.org>; Thu, 10 Nov 2022 07:42:38 -0800 (PST)
Received: from wsk (85-222-111-42.dynamic.chello.pl [85.222.111.42])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: lukma@denx.de)
        by phobos.denx.de (Postfix) with ESMTPSA id 2998E84BD8;
        Thu, 10 Nov 2022 16:42:37 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de;
        s=phobos-20191101; t=1668094957;
        bh=K36Zj8eDjKhPQVgMdqljbh7cgu8pBBSAaZptk1ZsqVs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=MRQaR4ttchGFih9eHQZfGd57hg2hrvK0SlXuRu+Z52of3tk1l6EJUceJvjvZKIPX3
         KM5AL8ImdKohPHJn6Jq/mPYMZWQrrxco5wfWOSIz1SoM1khZz8i0n+nmr2mp6iplIs
         G7qX3eYlSD10KuzizwJHM7DIs21iioxhg00k023vJjJn03z1jOxcxdUNjzkk59V8A+
         Q9tGni7howPrrxNAuicLjQRxvQ8UgFCRvDKI1ZTbxjvdBSSVkZuQOrKw9DL7in/FIH
         EWucrqUyk2NqbxBWmJ4ltI+6ei1ac8xU+7ySkdR9zW40VyDVHVZupWIzVthPhkUGXC
         DPLrNMWGiKc7Q==
Date:   Thu, 10 Nov 2022 16:42:36 +0100
From:   Lukasz Majewski <lukma@denx.de>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Subject: Re: [PATCH 7/9] net: dsa: mv88e6071: Define max frame size (2048
 bytes)
Message-ID: <20221110164236.5d24383d@wsk>
In-Reply-To: <Y2pecZmradpWbtOn@lunn.ch>
References: <20221108082330.2086671-1-lukma@denx.de>
        <20221108082330.2086671-8-lukma@denx.de>
        <Y2pecZmradpWbtOn@lunn.ch>
Organization: denx.de
X-Mailer: Claws Mail 3.19.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/xn8.cyrL_Twa7bOEWzHj68a";
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

--Sig_/xn8.cyrL_Twa7bOEWzHj68a
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

> On Tue, Nov 08, 2022 at 09:23:28AM +0100, Lukasz Majewski wrote:
> > Accroding to the documentation - the mv88e6071 can support
> > frame size up to 2048 bytes. =20
>=20
> Since the mv88e6020 is in the same family, it probably is the same?

Yes it is 2048 B

> And what about the mv88e66220?

You mean mv88e6220 ?

IIRC they are from the same family of ICs, so my guess :-) is that they
also have the same value.

>=20
>     Andrew




Best regards,

Lukasz Majewski

--

DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany
Phone: (+49)-8142-66989-59 Fax: (+49)-8142-66989-80 Email: lukma@denx.de

--Sig_/xn8.cyrL_Twa7bOEWzHj68a
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCgAdFiEEgAyFJ+N6uu6+XupJAR8vZIA0zr0FAmNtG+wACgkQAR8vZIA0
zr1M1wf/eHEeeJevIM9BYQEeSCGlxvNqM+7RR1NlLPWq0w0y3gta0k/96hyfninr
SU6sREgtSK6NSKH89pAbhDlp7nIrL9tImQ2uwxSKfQb8lDUGeccKx0KerikcwZf5
To3SHyGxQ+BqCTUmVWme86UMFh6tVoMIVa1i+fUf2/88sQ98ECwbTJMO7x7/WFUT
IaIzmBTH9f/XF/YdLfQRvBDJdA89NAadJ0jbp81c8vgjQOnF3K1lpTtnph5p0vYf
zy1hxApgyORdg0G8iPW2yTAN3Nwsce5l1iVS6C4GeNJEIEkN5xbSIeXtZIfp+uVi
zfueuAxTTv3TBANp2ogME5A9JbYFFw==
=bstg
-----END PGP SIGNATURE-----

--Sig_/xn8.cyrL_Twa7bOEWzHj68a--
