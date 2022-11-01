Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EBE5A614533
	for <lists+netdev@lfdr.de>; Tue,  1 Nov 2022 08:44:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229832AbiKAHn6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Nov 2022 03:43:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229475AbiKAHn4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Nov 2022 03:43:56 -0400
Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA564FD8;
        Tue,  1 Nov 2022 00:43:54 -0700 (PDT)
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 953E71C0049; Tue,  1 Nov 2022 08:43:52 +0100 (CET)
Date:   Tue, 1 Nov 2022 08:43:51 +0100
From:   Pavel Machek <pavel@denx.de>
To:     Biju Das <biju.das.jz@bp.renesas.com>
Cc:     Wolfgang Grandegger <wg@grandegger.com>,
        gregkh@linuxfoundation.org, Marc Kleine-Budde <mkl@pengutronix.de>,
        Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        Pavel Machek <pavel@denx.de>, Sasha Levin <sashal@kernel.org>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Chris Paterson <chris.paterson2@renesas.com>,
        linux-renesas-soc@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] can: rcar_canfd: rcar_canfd_handle_global_receive(): fix
 IRQ storm on global FIFO receive
Message-ID: <20221101074351.GA8310@amd>
References: <20221031143317.938785-1-biju.das.jz@bp.renesas.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="n8g4imXOkfNTN/H1"
Content-Disposition: inline
In-Reply-To: <20221031143317.938785-1-biju.das.jz@bp.renesas.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NEUTRAL autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--n8g4imXOkfNTN/H1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> Fixes: dd3bd23eb438 ("can: rcar_canfd: Add Renesas R-Car CAN FD driver")
> Suggested-by: Marc Kleine-Budde <mkl@pengutronix.de>
> Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
> Link: https://lore.kernel.org/all/20221025155657.1426948-2-biju.das.jz@bp=
=2Erenesas.com
> Cc: stable@vger.kernel.org#5.15.y
> [mkl: adjust commit message]

I got 7 or so copies of this, with slightly different Cc: lines.

AFAICT this is supposed to be stable kernel submission. In such case,
I'd expect [PATCH 4.14, 4.19, 5.10] in the subject line, and original
sign-off block from the mainline patch.

OTOH if it has Fixes tag (and it does) or Cc: stable (it has both),
normally there's no need to do separate submission to stable, as Greg
handles these automatically?

Thanks and best regards,
								Pavel
								=09
--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--n8g4imXOkfNTN/H1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAmNgzjcACgkQMOfwapXb+vIpCACeK57yqOvVkjX8PRmNZDqjjBmO
lfIAoMGRwF/DVFfw4s22pfZV3Swtz0YG
=DOYJ
-----END PGP SIGNATURE-----

--n8g4imXOkfNTN/H1--
