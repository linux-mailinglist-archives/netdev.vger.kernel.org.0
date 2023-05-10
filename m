Return-Path: <netdev+bounces-1343-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 40BEF6FD810
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 09:22:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 88E88281408
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 07:21:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4B26E612B;
	Wed, 10 May 2023 07:21:53 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F2D680C
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 07:21:53 +0000 (UTC)
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 805E410FA
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 00:21:50 -0700 (PDT)
Received: from moin.white.stw.pengutronix.de ([2a0a:edc0:0:b01:1d::7b] helo=bjornoya.blackshift.org)
	by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
	(Exim 4.92)
	(envelope-from <mkl@pengutronix.de>)
	id 1pwe8X-0005sl-SQ; Wed, 10 May 2023 09:21:21 +0200
Received: from pengutronix.de (unknown [172.20.34.65])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(Client did not present a certificate)
	(Authenticated sender: mkl-all@blackshift.org)
	by smtp.blackshift.org (Postfix) with ESMTPSA id F32F11C161B;
	Wed, 10 May 2023 07:21:16 +0000 (UTC)
Date: Wed, 10 May 2023 09:21:16 +0200
From: Marc Kleine-Budde <mkl@pengutronix.de>
To: Judith Mendez <jm@ti.com>
Cc: Chandrasekar Ramakrishnan <rcsekar@samsung.com>,
	Wolfgang Grandegger <wg@grandegger.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	linux-can@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, Schuyler Patton <spatton@ti.com>,
	Nishanth Menon <nm@ti.com>, Vignesh Raghavendra <vigneshr@ti.com>,
	Tero Kristo <kristo@kernel.org>, Rob Herring <robh+dt@kernel.org>,
	linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
	Oliver Hartkopp <socketcan@hartkopp.net>,
	Simon Horman <simon.horman@corigine.com>
Subject: Re: [PATCH v4 2/4] can: m_can: Add hrtimer to generate software
 interrupt
Message-ID: <20230510-salad-decaf-009b9da48271-mkl@pengutronix.de>
References: <20230501224624.13866-1-jm@ti.com>
 <20230501224624.13866-3-jm@ti.com>
 <20230502-twiddling-threaten-d032287d4630-mkl@pengutronix.de>
 <84e5b09e-f8b9-15ae-4871-e5e4c4f4a470@ti.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="tgwyxm4pxdq37yhh"
Content-Disposition: inline
In-Reply-To: <84e5b09e-f8b9-15ae-4871-e5e4c4f4a470@ti.com>
X-SA-Exim-Connect-IP: 2a0a:edc0:0:b01:1d::7b
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net


--tgwyxm4pxdq37yhh
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 09.05.2023 17:18:06, Judith Mendez wrote:
[...]
> >> +	if (!mcan_class->polling && irq < 0) {
> >> +		ret =3D -ENXIO;
> >> +		dev_err_probe(mcan_class->dev, ret, "IRQ int0 not found and polling=
 not activated\n");
> >> +		goto probe_fail;
> >> +	}
> >> +
> >> +	if (mcan_class->polling) {
> >> +		if (irq > 0) {
> >> +			mcan_class->polling =3D 0;
> >=20
> > false
> >=20
> >> +			dev_dbg(mcan_class->dev, "Polling enabled and hardware IRQ found, =
use hardware IRQ\n");
> >=20
> > "...using hardware IRQ"
> >=20
> > Use dev_info(), as there is something not 100% correct with the DT.
>=20
> Is it dev_info or dev_dbg?

dev_info() - But without an explicit "poll-interval' in the DT, this
code path doesn't exist anymore.

> I used to have dev_info since it was nice to see when polling was
> enabled.

Re-read your code, this is not about enabling polling. This message
handles the case where an IRQ was given _and_ "poll-interval" was
specified. So there is something not 100% correct with the DT (IRQ _and_
polling), but this is obsolete now.

> Also, I had seen this print and the next as informative prints, hence the=
 dev_info().

We don't print messages when IRQs are enabled, so enabling polling
should be a dev_dbg(), too.

> However, I was told in this review process to change to dev_dbg. Which is=
 correct?

Driver works correct -> dev_dbg()
Something is strange -> dev_info()

Hope that helps,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde          |
Embedded Linux                   | https://www.pengutronix.de |
Vertretung N=C3=BCrnberg              | Phone: +49-5121-206917-129 |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-9   |

--tgwyxm4pxdq37yhh
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEDs2BvajyNKlf9TJQvlAcSiqKBOgFAmRbRekACgkQvlAcSiqK
BOjwCAgAmXS2tX60jeg2eu2tekN4V/d3zC53gUFzN/gnfNR1Oz4uTP6sM3ObU3CF
ETu1+QlIsia8XdOJUMBypXq46rgD8phoaqYdn2VHLnmMw71eVYzY8h+WjRpBtYHl
XkYefEOT38d5hJNwP33EQqYJIaESnqoaQvPFwDSVut1eFHm1VPk49cH53xtz62io
0u+Fd28sRI/kpECKExrE8HG6ZSNbsDPwErbLjO/GLLnAq6rIh+2K7Ko0wF+Jt/in
+ss89O+LfuEal4weTPImYXWC3XDoO9H3mmcAbX3WIONVvXGS6qrvzY5fp5whrsCc
H+0cmOuFijJuo3iGkzhlYhV8vS5zQw==
=++ID
-----END PGP SIGNATURE-----

--tgwyxm4pxdq37yhh--

