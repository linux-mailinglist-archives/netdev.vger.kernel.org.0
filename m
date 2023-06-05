Return-Path: <netdev+bounces-7936-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9087772229E
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 11:52:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4B6D7281237
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 09:52:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 96343154A3;
	Mon,  5 Jun 2023 09:52:06 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A8F7134BB
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 09:52:06 +0000 (UTC)
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19A6BBD
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 02:52:05 -0700 (PDT)
Received: from moin.white.stw.pengutronix.de ([2a0a:edc0:0:b01:1d::7b] helo=bjornoya.blackshift.org)
	by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
	(Exim 4.92)
	(envelope-from <mkl@pengutronix.de>)
	id 1q66sU-0008L4-6J; Mon, 05 Jun 2023 11:51:54 +0200
Received: from pengutronix.de (unknown [172.20.34.65])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(Client did not present a certificate)
	(Authenticated sender: mkl-all@blackshift.org)
	by smtp.blackshift.org (Postfix) with ESMTPSA id 854A51D235F;
	Mon,  5 Jun 2023 09:51:52 +0000 (UTC)
Date: Mon, 5 Jun 2023 11:51:52 +0200
From: Marc Kleine-Budde <mkl@pengutronix.de>
To: =?utf-8?B?Q3PDs2vDoXM=?= Bence <csokas.bence@prolan.hu>
Cc: netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
	Richard Cochran <richardcochran@gmail.com>, qiangqing.zhang@nxp.com,
	kernel@pengutronix.de, Jakub Kicinski <kuba@kernel.org>,
	"David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH resubmit] net: fec: Refactor: rename `adapter` to `fep`
Message-ID: <20230605-surfboard-implosive-d1700e274b20-mkl@pengutronix.de>
References: <20230605094402.85071-1-csokas.bence@prolan.hu>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="eykfxuvow6vmx724"
Content-Disposition: inline
In-Reply-To: <20230605094402.85071-1-csokas.bence@prolan.hu>
X-SA-Exim-Connect-IP: 2a0a:edc0:0:b01:1d::7b
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net


--eykfxuvow6vmx724
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 05.06.2023 11:44:03, Cs=C3=B3k=C3=A1s Bence wrote:
> Signed-off-by: Cs=C3=B3k=C3=A1s Bence <csokas.bence@prolan.hu>

You probably want to add a patch description.

regards,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde          |
Embedded Linux                   | https://www.pengutronix.de |
Vertretung N=C3=BCrnberg              | Phone: +49-5121-206917-129 |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-9   |

--eykfxuvow6vmx724
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEDs2BvajyNKlf9TJQvlAcSiqKBOgFAmR9sDUACgkQvlAcSiqK
BOjJaggAjjb+njE4gPJSl6to+duJbNhmdpk3nPnYuaC7iVwPpHenmI1P2iyN670o
C197LKGLQ8J5XYtW5wQlxQfBgc/J7RwNOuxbWLDaxmBHoOFUNkb4hFSHn8J+7HiC
hTybL2JseQppXvcoryWvEUe//bPKTRkml7Gve8oJzALy+eEoVJos0nTBAwF3AIxR
40ooQqIyKsSsMOHCWwMRXNx8fwtCSVeHyDPYroGuIp9HJFhp/+NoSF4aNoEM8vJw
2PJCchLQHYmqmJT3XxqnVVU+ga1KMjgmhPwlf8NPLpAigZLKJHt5HXhykk6XT8yV
dIrXQKVfUJf/pnsy/L54xAQAgBJqOg==
=qIac
-----END PGP SIGNATURE-----

--eykfxuvow6vmx724--

