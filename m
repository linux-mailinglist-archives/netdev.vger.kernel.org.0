Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F301F591ABA
	for <lists+netdev@lfdr.de>; Sat, 13 Aug 2022 15:44:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239562AbiHMNoL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 13 Aug 2022 09:44:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239466AbiHMNoJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 13 Aug 2022 09:44:09 -0400
Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F2D4DED8;
        Sat, 13 Aug 2022 06:44:08 -0700 (PDT)
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id C2CF11C000F; Sat, 13 Aug 2022 15:44:06 +0200 (CEST)
Date:   Sat, 13 Aug 2022 15:44:03 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Biju Das <biju.das.jz@bp.renesas.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>, wg@grandegger.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, mailhol.vincent@wanadoo.fr,
        stefan.maetje@esd.eu, socketcan@hartkopp.net,
        linux-can@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 4.9 08/12] can: sja1000: Add Quirk for RZ/N1
 SJA1000 CAN controller
Message-ID: <20220813134403.GC24517@duo.ucw.cz>
References: <20220811161144.1543598-1-sashal@kernel.org>
 <20220811161144.1543598-8-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="H8ygTp4AXg6deix2"
Content-Disposition: inline
In-Reply-To: <20220811161144.1543598-8-sashal@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NEUTRAL,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--H8ygTp4AXg6deix2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> As per Chapter 6.5.16 of the RZ/N1 Peripheral Manual, The SJA1000
> CAN controller does not support Clock Divider Register compared to
> the reference Philips SJA1000 device.
>=20
> This patch adds a device quirk to handle this difference.

I don't think this is suitable for stable (at least 5.10.X and older)
as we don't have user of the quirk queued up.

Best regards,
								Pavel
--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--H8ygTp4AXg6deix2
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCYveqowAKCRAw5/Bqldv6
8r8YAJ9Y7BnSBOz+McET0wttzNzYXrskHwCfY9PL8bFQVQIEjgCOwKuQARsWwpA=
=twIP
-----END PGP SIGNATURE-----

--H8ygTp4AXg6deix2--
