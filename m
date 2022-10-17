Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 59CE2600F7E
	for <lists+netdev@lfdr.de>; Mon, 17 Oct 2022 14:50:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230421AbiJQMuK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Oct 2022 08:50:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229870AbiJQMuI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Oct 2022 08:50:08 -0400
Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4205C12605;
        Mon, 17 Oct 2022 05:50:06 -0700 (PDT)
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 9AEA01C0049; Mon, 17 Oct 2022 14:50:04 +0200 (CEST)
Date:   Mon, 17 Oct 2022 14:50:04 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Pavel Machek <pavel@denx.de>
Cc:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Nathan Huckleberry <nhuck@google.com>,
        Dan Carpenter <error27@gmail.com>, llvm@lists.linux.dev,
        Nathan Chancellor <nathan@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net,
        edumazet@google.com, pabeni@redhat.com, ndesaulniers@google.com,
        mkl@pengutronix.de, thomas.lendacky@amd.com, khalasa@piap.pl,
        wsa+renesas@sang-engineering.com, netdev@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 4.9 11/16] net: korina: Fix return type of
 korina_send_packet
Message-ID: <20221017125004.GC13227@duo.ucw.cz>
References: <20221009222713.1220394-1-sashal@kernel.org>
 <20221009222713.1220394-11-sashal@kernel.org>
 <20221017102503.GA15612@duo.ucw.cz>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="uXxzq0nDebZQVNAZ"
Content-Disposition: inline
In-Reply-To: <20221017102503.GA15612@duo.ucw.cz>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NEUTRAL autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--uXxzq0nDebZQVNAZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> > From: Nathan Huckleberry <nhuck@google.com>
> >=20
> > [ Upstream commit 106c67ce46f3c82dd276e983668a91d6ed631173 ]
> >=20
> > The ndo_start_xmit field in net_device_ops is expected to be of type
> > netdev_tx_t (*ndo_start_xmit)(struct sk_buff *skb, struct net_device *d=
ev).
> >=20
> > The mismatched return type breaks forward edge kCFI since the underlying
> > function definition does not match the function hook definition.
> >=20
> > The return type of korina_send_packet should be changed from int to
> > netdev_tx_t.
>=20
> Patches 4-6, 9-11: I see this is nice cleanup for mainline, but ... do
> we have CFI in 4.9 tree? This mismatch does not and can not cause any
> problems there, right?

Quoting Greg on very similar patch:

#kCFI showed up in 6.1, so this is not needed in any stable branches,
#please drop it from all.

#thanks,

#greg k-h

Best regards,
								Pavel

--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--uXxzq0nDebZQVNAZ
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCY01PfAAKCRAw5/Bqldv6
8tY5AJ9b7F/ay2J3mE1s6b7/h8pMNXRc4ACgrd4aUg4VSp01l0TLp+GhisK2cFg=
=/W9e
-----END PGP SIGNATURE-----

--uXxzq0nDebZQVNAZ--
