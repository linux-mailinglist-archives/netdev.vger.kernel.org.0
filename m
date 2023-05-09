Return-Path: <netdev+bounces-1164-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D25676FC675
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 14:34:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9E4C428136A
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 12:34:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DCFCC8BE3;
	Tue,  9 May 2023 12:34:02 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1432196
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 12:34:02 +0000 (UTC)
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B0AA40D9
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 05:34:00 -0700 (PDT)
Received: from moin.white.stw.pengutronix.de ([2a0a:edc0:0:b01:1d::7b] helo=bjornoya.blackshift.org)
	by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
	(Exim 4.92)
	(envelope-from <mkl@pengutronix.de>)
	id 1pwMXF-0007bU-NH; Tue, 09 May 2023 14:33:41 +0200
Received: from pengutronix.de (unknown [172.20.34.65])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(Client did not present a certificate)
	(Authenticated sender: mkl-all@blackshift.org)
	by smtp.blackshift.org (Postfix) with ESMTPSA id 123EA1C0ED2;
	Tue,  9 May 2023 12:33:39 +0000 (UTC)
Date: Tue, 9 May 2023 14:33:38 +0200
From: Marc Kleine-Budde <mkl@pengutronix.de>
To: Dario Binacchi <dario.binacchi@amarulasolutions.com>
Cc: linux-kernel@vger.kernel.org, michael@amarulasolutions.com,
	Amarula patchwork <linux-amarula@amarulasolutions.com>,
	Alexandre Torgue <alexandre.torgue@foss.st.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
	Maxime Coquelin <mcoquelin.stm32@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>, Rob Herring <robh+dt@kernel.org>,
	Wolfgang Grandegger <wg@grandegger.com>, devicetree@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-can@vger.kernel.org,
	linux-stm32@st-md-mailman.stormreply.com, netdev@vger.kernel.org
Subject: Re: [PATCH v2 0/5] can: bxcan: add support for single peripheral
 configuration
Message-ID: <20230509-catering-haphazard-069d7e07dd1f-mkl@pengutronix.de>
References: <20230427204540.3126234-1-dario.binacchi@amarulasolutions.com>
 <20230427-retaining-deeply-fcff70098e7e-mkl@pengutronix.de>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="z2tkty3mos6fytzk"
Content-Disposition: inline
In-Reply-To: <20230427-retaining-deeply-fcff70098e7e-mkl@pengutronix.de>
X-SA-Exim-Connect-IP: 2a0a:edc0:0:b01:1d::7b
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net


--z2tkty3mos6fytzk
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 27.04.2023 23:08:57, Marc Kleine-Budde wrote:
> On 27.04.2023 22:45:35, Dario Binacchi wrote:
> >=20
> > The series adds support for managing bxCAN controllers in single periph=
eral
> > configuration.
> > Unlike stm32f4 SOCs, where bxCAN controllers are only in dual peripheral
> > configuration, stm32f7 SOCs contain three CAN peripherals, CAN1 and CAN2
> > in dual peripheral configuration and CAN3 in single peripheral
> > configuration:
> > - Dual CAN peripheral configuration:
> >  * CAN1: Primary bxCAN for managing the communication between a seconda=
ry
> >    bxCAN and the 512-byte SRAM memory.
> >  * CAN2: Secondary bxCAN with no direct access to the SRAM memory.
> >    This means that the two bxCAN cells share the 512-byte SRAM memory a=
nd
> >    CAN2 can't be used without enabling CAN1.
> > - Single CAN peripheral configuration:
> >  * CAN3: Primary bxCAN with dedicated Memory Access Controller unit and
> >    512-byte SRAM memory.
>=20
> This really looks good! Great work! Who takes the DT changes? I can take
> the whole series.

I've upstreamed the DT changes for the first bxCAN driver, so I'll take
them this time, too.

Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde          |
Embedded Linux                   | https://www.pengutronix.de |
Vertretung N=C3=BCrnberg              | Phone: +49-5121-206917-129 |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-9   |

--z2tkty3mos6fytzk
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEDs2BvajyNKlf9TJQvlAcSiqKBOgFAmRaPaAACgkQvlAcSiqK
BOhJDggAiHTwavVOD9cujYG2SgwoOLLgpy8Ylvw9/eeUQEH1Qg6N2ilNwzkHyEAE
Q6L0lhNcBy3VO0LyM12q68h/bIu4XmAQT2QxL402O/59g24vXkR2kdsZv1teTTgB
sRGMukvTADU+KOLNu2VtfYoLVraeGDk+Z6OfYznFlpilwK0QDNjVtItDP/vFUEjF
ejc0RZ4SoWPH43twlO6t5ggNZkKuQYEj4kUe9JP6QgxElkvsaaipOOnAkcXlN64g
O9WXHOfZuDiMwRJRwQ/OxVyN8Ra5ZkuLdAM7r1vzjYSQISh7tvpCjH/byB0pQMBW
8cZztkEv3Kzx69WmUDssu7VvwXTUqA==
=nqSC
-----END PGP SIGNATURE-----

--z2tkty3mos6fytzk--

