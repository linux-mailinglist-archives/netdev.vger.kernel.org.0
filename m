Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 73F1D4AD2DC
	for <lists+netdev@lfdr.de>; Tue,  8 Feb 2022 09:11:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348946AbiBHILN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Feb 2022 03:11:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348941AbiBHILM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Feb 2022 03:11:12 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 635C0C0401F5
        for <netdev@vger.kernel.org>; Tue,  8 Feb 2022 00:11:09 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1nHLaX-00062r-3f; Tue, 08 Feb 2022 09:11:01 +0100
Received: from pengutronix.de (unknown [195.138.59.174])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id E33242E206;
        Tue,  8 Feb 2022 08:10:58 +0000 (UTC)
Date:   Tue, 8 Feb 2022 09:10:55 +0100
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Oliver Hartkopp <socketcan@hartkopp.net>
Subject: Re: [PATCH v2 net-next 09/11] can: gw: switch cangw_pernet_exit() to
 batch mode
Message-ID: <20220208081055.cfy655uarxxdcfe2@pengutronix.de>
References: <20220208045038.2635826-1-eric.dumazet@gmail.com>
 <20220208045038.2635826-10-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="ayle4dle4rrls5g7"
Content-Disposition: inline
In-Reply-To: <20220208045038.2635826-10-eric.dumazet@gmail.com>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--ayle4dle4rrls5g7
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 07.02.2022 20:50:36, Eric Dumazet wrote:
> From: Eric Dumazet <edumazet@google.com>
>=20
> cleanup_net() is competing with other rtnl users.
>=20
> Avoiding to acquire rtnl for each netns before calling
> cgw_remove_all_jobs() gives chance for cleanup_net()
> to progress much faster, holding rtnl a bit longer.
>=20
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Acked-by: Oliver Hartkopp <socketcan@hartkopp.net>
> Cc: Marc Kleine-Budde <mkl@pengutronix.de>

Acked-by: Marc Kleine-Budde <mkl@pengutronix.de>

regards,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--ayle4dle4rrls5g7
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmICJYwACgkQrX5LkNig
011SdAf+MFKrheg/ItGTv6yfXfktMAdhanoEOx7OsvRh9gU7TZBSdjHLbEAQ5hjH
970LfdibcP/9of0BdReo/Ac8+79mxBNoHVUWhWr4GeObMFjW0Zk8CGXPAjNRUwTa
fjNjhRFR9Z/nMkOGL5Ig6490Ka31ktgfYvQcFjCzSrkmBTaSys+UV2tfX7Kx1wkd
5Qbebp4AMPXm2mkIBWrrrIBeKGMaWCdEOgzTwKY+2uvJ1DAMVVJ79myCUndt8+E2
0b5jlC48JdwtNVAUn5fgYhAM4Wa8+15EhQv/PRGvzngLbAcMiTKvvlbI+eEODBaD
jXv0VXO2Pf51tIszKpg+LxmdLFeGgQ==
=83GG
-----END PGP SIGNATURE-----

--ayle4dle4rrls5g7--
