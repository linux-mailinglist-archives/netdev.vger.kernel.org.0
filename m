Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 738BE5AD72F
	for <lists+netdev@lfdr.de>; Mon,  5 Sep 2022 18:13:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229449AbiIEQML (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Sep 2022 12:12:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231553AbiIEQMD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Sep 2022 12:12:03 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE4FE5465F
        for <netdev@vger.kernel.org>; Mon,  5 Sep 2022 09:11:59 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1oVEhP-00077H-2H; Mon, 05 Sep 2022 18:11:47 +0200
Received: from pengutronix.de (unknown [IPv6:2a0a:edc0:0:701:b4c0:a600:5e68:1e31])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 25886DAE55;
        Mon,  5 Sep 2022 16:11:45 +0000 (UTC)
Date:   Mon, 5 Sep 2022 18:11:44 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     cgel.zte@gmail.com
Cc:     wg@grandegger.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, mailhol.vincent@wanadoo.fr,
        stefan.maetje@esd.eu, socketcan@hartkopp.net,
        biju.das.jz@bp.renesas.com, cui.jinpeng2@zte.com.cn,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Zeal Robot <zealci@zte.com.cn>
Subject: Re: [PATCH linux-next] can: sja1000: remove redundant variable ret
Message-ID: <20220905161144.drgnpb2fvweoerti@pengutronix.de>
References: <20220831161835.306079-1-cui.jinpeng2@zte.com.cn>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="xqfmf27xgyrd3o2i"
Content-Disposition: inline
In-Reply-To: <20220831161835.306079-1-cui.jinpeng2@zte.com.cn>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--xqfmf27xgyrd3o2i
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 31.08.2022 16:18:35, cgel.zte@gmail.com wrote:
> From: Jinpeng Cui <cui.jinpeng2@zte.com.cn>
>=20
> Return value directly from register_candev() instead of
> getting value from redundant variable ret.
>=20
> Reported-by: Zeal Robot <zealci@zte.com.cn>
> Signed-off-by: Jinpeng Cui <cui.jinpeng2@zte.com.cn>

Applied to linux-can-next.

Thanks,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--xqfmf27xgyrd3o2i
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmMWH74ACgkQrX5LkNig
011N8wgAjbGH8D7pQY+wACD4zGAst6TPnXv8eHdpyHK/Q3FPaMnuKtjX35Ma8S/r
xeaA9LJDGii5RVbxuMWiMxALuaxVXs6ClXaH8lvPYGWIXHhqzlaPNb9HHf5j9jL3
Wemb0822SbnYV7UhlOY5uIFrKAe3aNQDIn9v+ckaBjsuGcQp7o1k4vPnUPKzinh+
lyLEfRrni0ArQbClu4PJQrol+ezALkOUgcPboCofVcbVZ8ZklF9TZBaOBPkcD4o9
D9+pKQqTaNSZjCkcxRk9uefMsnVlcDnE/JYIRSSDumtkD/KqDT9glyEQMhwsDwix
zcTwmAUba08Bzm22royawOTjblDjRw==
=6yVC
-----END PGP SIGNATURE-----

--xqfmf27xgyrd3o2i--
