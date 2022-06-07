Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 786BE53FC83
	for <lists+netdev@lfdr.de>; Tue,  7 Jun 2022 12:56:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241076AbiFGK40 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jun 2022 06:56:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242662AbiFGK4C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jun 2022 06:56:02 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90F4EA500F
        for <netdev@vger.kernel.org>; Tue,  7 Jun 2022 03:52:43 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1nyWp1-00068N-Le; Tue, 07 Jun 2022 12:52:27 +0200
Received: from pengutronix.de (unknown [IPv6:2a01:4f8:1c1c:29e9:22:41ff:fe00:1400])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id C13678DBA9;
        Tue,  7 Jun 2022 10:52:25 +0000 (UTC)
Date:   Tue, 7 Jun 2022 12:52:25 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Dario Binacchi <dario.binacchi@amarulasolutions.com>
Cc:     linux-kernel@vger.kernel.org,
        Amarula patchwork <linux-amarula@amarulasolutions.com>,
        michael@amarulasolutions.com,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Jiri Slaby <jirislaby@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Wolfgang Grandegger <wg@grandegger.com>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [RFC PATCH 11/13] can: slcan: add ethtool support to reset
 adapter errors
Message-ID: <20220607105225.xw33w32en7fd4vmh@pengutronix.de>
References: <20220607094752.1029295-1-dario.binacchi@amarulasolutions.com>
 <20220607094752.1029295-12-dario.binacchi@amarulasolutions.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="iuaxzdq6irzebpfy"
Content-Disposition: inline
In-Reply-To: <20220607094752.1029295-12-dario.binacchi@amarulasolutions.com>
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


--iuaxzdq6irzebpfy
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 07.06.2022 11:47:50, Dario Binacchi wrote:
> This patch adds a private flag to the slcan driver to switch the
> "err-rst-on-open" setting on and off.
>=20
> "err-rst-on-open" on  - Reset error states on opening command
>=20
> "err-rst-on-open" off - Don't reset error states on opening command
>                         (default)
>=20
> The setting can only be changed if the interface is down:
>=20
>     ip link set dev can0 down
>     ethtool --set-priv-flags can0 err-rst-on-open {off|on}
>     ip link set dev can0 up
>=20
> Signed-off-by: Dario Binacchi <dario.binacchi@amarulasolutions.com>

I'm a big fan of bringing the device into a well known good state during
ifup. What would be the reasons/use cases to not reset the device?

Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--iuaxzdq6irzebpfy
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmKfLeYACgkQrX5LkNig
012aSQf/XyECEKk/TwoC1qpcrU6CZDRxLCJs8tO38g6r8u6mGtbNQEwIhtUIYwPZ
4bPJ+V4a3GaJ1QyY0uAQUZVvrJLergmgsAw+xXg4wYHFzwSG46M7gxtAFiHP7JE8
rT9u+6IYs7gnhDsp24FpscyE/B7PJ+DaJRvqXe6WO74cPR9hIYlNHgNX5NElUWcz
IT1rFeGbnYpuW481T0PELKvF7sx8QnGSMPFtrij3vxaNOE9iI5ikMaTiotYM3u2S
9rG8i3HKyN8xpGt5WXr4mDei4ZQrxSFrUdGQnl6bsDve27+3os44YrXWeFF/+Opa
T9DFUSWf/2gt3UrSmFM/Kfb6qvxL0Q==
=PcMi
-----END PGP SIGNATURE-----

--iuaxzdq6irzebpfy--
