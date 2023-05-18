Return-Path: <netdev+bounces-3541-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 77F45707CF9
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 11:33:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A797F28189D
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 09:32:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AEA5F11C9B;
	Thu, 18 May 2023 09:32:57 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2F69AD46
	for <netdev@vger.kernel.org>; Thu, 18 May 2023 09:32:57 +0000 (UTC)
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A04F268C
	for <netdev@vger.kernel.org>; Thu, 18 May 2023 02:32:51 -0700 (PDT)
Received: from moin.white.stw.pengutronix.de ([2a0a:edc0:0:b01:1d::7b] helo=bjornoya.blackshift.org)
	by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
	(Exim 4.92)
	(envelope-from <mkl@pengutronix.de>)
	id 1pzZzx-0006ms-R8; Thu, 18 May 2023 11:32:37 +0200
Received: from pengutronix.de (unknown [172.20.34.65])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(Client did not present a certificate)
	(Authenticated sender: mkl-all@blackshift.org)
	by smtp.blackshift.org (Postfix) with ESMTPSA id C14F71C7B3D;
	Thu, 18 May 2023 09:32:36 +0000 (UTC)
Date: Thu, 18 May 2023 11:32:36 +0200
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
Subject: Re: [PATCH net-next v3 0/2] Fine-Tune Flow Control and Speed
 Configurations in Microchip KSZ8xxx DSA Driver
Message-ID: <20230518-tutu-wildland-b48f1bd3f79e-mkl@pengutronix.de>
References: <20230518092913.977705-1-o.rempel@pengutronix.de>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="vumhte6bwemi33ou"
Content-Disposition: inline
In-Reply-To: <20230518092913.977705-1-o.rempel@pengutronix.de>
X-SA-Exim-Connect-IP: 2a0a:edc0:0:b01:1d::7b
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net


--vumhte6bwemi33ou
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 18.05.2023 11:29:11, Oleksij Rempel wrote:
> changes v3:
> - remove half duplex flow control configuration
> - add comments
> - s/stram/stream
>=20
> changes v2:
> - split the patch to upstrean and downstream part
                              ^m
> - add comments
> - fix downstream register offset
> - fix cpu configuration
>=20
> This patch set focuses on enhancing the configurability of flow
> control, speed, and duplex settings in the Microchip KSZ8xxx DSA driver.
>=20
> The first patch allows more granular control over the CPU port's flow
> control, speed, and duplex settings. The second patch introduces a
> method for downstream port configurations, primarily concerning flow
> control based on duplex mode.

regards,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde          |
Embedded Linux                   | https://www.pengutronix.de |
Vertretung N=C3=BCrnberg              | Phone: +49-5121-206917-129 |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-9   |

--vumhte6bwemi33ou
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEDs2BvajyNKlf9TJQvlAcSiqKBOgFAmRl8LEACgkQvlAcSiqK
BOi9sAgAhMea8TDC3ZJkou+IQfm0QSmZAshM232Ma/QANCf/GPbaUXJ+u9nBHuHS
bvZd4jZ3v1mcYdTGoDjAk++lcSDgAMDi3QI7nup2oavzo86PAdFovS26/P/p6XZo
OUOq2O8jONQkB0KKZ3Oqgg4pd+/6gcl2EZxyu/Gn6zfpNHBw0G6PELsNEEHmbwJF
FQSkMonZ/iUj+a97mD8YacLHJDScCGCr8+YPGd2OnqB8QGgTmmE194M1gUSbZt6U
EPlclwzQeHiWwOMkJfh2t1qnS6qloDUNUe+nVBjtL0n/URs4BWvXrYeSxIWNXbcM
F9/1nKZWk6h9twgLYhu9M6AlcrN8DA==
=oRYF
-----END PGP SIGNATURE-----

--vumhte6bwemi33ou--

