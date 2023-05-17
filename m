Return-Path: <netdev+bounces-3345-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7EE05706852
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 14:39:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3A2F5281682
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 12:39:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ED86818B03;
	Wed, 17 May 2023 12:38:56 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1D9A18AF7
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 12:38:56 +0000 (UTC)
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C6771FC4
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 05:38:54 -0700 (PDT)
Received: from moin.white.stw.pengutronix.de ([2a0a:edc0:0:b01:1d::7b] helo=bjornoya.blackshift.org)
	by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
	(Exim 4.92)
	(envelope-from <mkl@pengutronix.de>)
	id 1pzGQQ-0006A2-A0; Wed, 17 May 2023 14:38:38 +0200
Received: from pengutronix.de (unknown [172.20.34.65])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(Client did not present a certificate)
	(Authenticated sender: mkl-all@blackshift.org)
	by smtp.blackshift.org (Postfix) with ESMTPSA id 1246C1C716F;
	Wed, 17 May 2023 12:38:37 +0000 (UTC)
Date: Wed, 17 May 2023 14:38:35 +0200
From: Marc Kleine-Budde <mkl@pengutronix.de>
To: Oleksij Rempel <o.rempel@pengutronix.de>
Cc: "David S. Miller" <davem@davemloft.net>, Andrew Lunn <andrew@lunn.ch>,
	Eric Dumazet <edumazet@google.com>,
	Florian Fainelli <f.fainelli@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Vladimir Oltean <olteanv@gmail.com>,
	Woojung Huh <woojung.huh@microchip.com>,
	Arun Ramadoss <arun.ramadoss@microchip.com>,
	"Russell King (Oracle)" <linux@armlinux.org.uk>,
	UNGLinuxDriver@microchip.com, linux-kernel@vger.kernel.org,
	kernel@pengutronix.de, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v2 0/2] Fine-Tune Flow Control and Speed
 Configurations in Microchip KSZ8xxx DSA Driver
Message-ID: <20230517-flyer-quiver-79e2f624a460-mkl@pengutronix.de>
References: <20230517121034.3801640-1-o.rempel@pengutronix.de>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="t4ca6c4672tg6ybh"
Content-Disposition: inline
In-Reply-To: <20230517121034.3801640-1-o.rempel@pengutronix.de>
X-SA-Exim-Connect-IP: 2a0a:edc0:0:b01:1d::7b
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net


--t4ca6c4672tg6ybh
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 17.05.2023 14:10:32, Oleksij Rempel wrote:
> changes v2:
> - split the patch to upstrean and downstram part
                       upstream     downstream

In patches please fix spelling, too:
s/upstram/upstream/
s/downstram/downstream/

Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde          |
Embedded Linux                   | https://www.pengutronix.de |
Vertretung N=C3=BCrnberg              | Phone: +49-5121-206917-129 |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-9   |

--t4ca6c4672tg6ybh
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEDs2BvajyNKlf9TJQvlAcSiqKBOgFAmRkyskACgkQvlAcSiqK
BOj1eAf/bdH8oLih24Q4glFjP7ngLrOfL8iIK2nS2yTsCbqlr6x7wSuy3PxUnPhi
K+U53oJM152NYO/YTe0yQ7gYmeEibo0yHCauEo6ZoDgnQ8hAtTuyOgVNTeKFeEk9
cT4f14m6+KhdcttfWvmezO0ZrgeCaO3RrnHlLPOj3sCwk9UqQY0+1KCRKR5xfS8E
2hOGsTDqMVGG+AIfInh6ACOfTe3VxzGE3gDcBR8s/4d6ZXthiNcCC9zbdyh0uKgQ
/geD3UpybQRRtNhroMcaZlRSoKto8gyklT1oAdKy3/l2LCELED8XdpOQSheFBlXn
/l/J5fqqeGJnyxdWtdgBw5gMrfBJRg==
=1F0K
-----END PGP SIGNATURE-----

--t4ca6c4672tg6ybh--

