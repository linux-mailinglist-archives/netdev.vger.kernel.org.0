Return-Path: <netdev+bounces-4393-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7B1CA70C550
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 20:38:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3617828111B
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 18:38:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6520D14AA2;
	Mon, 22 May 2023 18:38:28 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59DF2BA3F
	for <netdev@vger.kernel.org>; Mon, 22 May 2023 18:38:28 +0000 (UTC)
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02399FE
	for <netdev@vger.kernel.org>; Mon, 22 May 2023 11:38:26 -0700 (PDT)
Received: from moin.white.stw.pengutronix.de ([2a0a:edc0:0:b01:1d::7b] helo=bjornoya.blackshift.org)
	by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
	(Exim 4.92)
	(envelope-from <mkl@pengutronix.de>)
	id 1q1APk-0003En-R1; Mon, 22 May 2023 20:37:48 +0200
Received: from pengutronix.de (unknown [172.20.34.65])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(Client did not present a certificate)
	(Authenticated sender: mkl-all@blackshift.org)
	by smtp.blackshift.org (Postfix) with ESMTPSA id D60801C9D42;
	Mon, 22 May 2023 18:37:45 +0000 (UTC)
Date: Mon, 22 May 2023 20:37:45 +0200
From: Marc Kleine-Budde <mkl@pengutronix.de>
To: Judith Mendez <jm@ti.com>
Cc: Chandrasekar Ramakrishnan <rcsekar@samsung.com>,
	linux-can@vger.kernel.org, Wolfgang Grandegger <wg@grandegger.com>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	Schuyler Patton <spatton@ti.com>, Tero Kristo <kristo@kernel.org>,
	Rob Herring <robh+dt@kernel.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
	linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
	Oliver Hartkopp <socketcan@hartkopp.net>,
	Conor Dooley <conor+dt@kernel.org>
Subject: Re: [PATCH v6 2/2] can: m_can: Add hrtimer to generate software
 interrupt
Message-ID: <20230522-manhunt-smooth-442d9d864f04-mkl@pengutronix.de>
References: <20230518193613.15185-1-jm@ti.com>
 <20230518193613.15185-3-jm@ti.com>
 <20230519-morbidity-directory-dbe704584aa3-mkl@pengutronix.de>
 <3859166d-fc78-f42d-1553-282e4140325a@ti.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="6gp3ppfjbjdh2fkv"
Content-Disposition: inline
In-Reply-To: <3859166d-fc78-f42d-1553-282e4140325a@ti.com>
X-SA-Exim-Connect-IP: 2a0a:edc0:0:b01:1d::7b
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net


--6gp3ppfjbjdh2fkv
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 22.05.2023 10:17:38, Judith Mendez wrote:
> > > diff --git a/drivers/net/can/m_can/m_can_platform.c b/drivers/net/can=
/m_can/m_can_platform.c
> > > index 94dc82644113..3e60cebd9d12 100644
> > > --- a/drivers/net/can/m_can/m_can_platform.c
> > > +++ b/drivers/net/can/m_can/m_can_platform.c
> > > @@ -5,6 +5,7 @@
> > >   //
> > >   // Copyright (C) 2018-19 Texas Instruments Incorporated - http://ww=
w.ti.com/
> > > +#include <linux/hrtimer.h>
> > >   #include <linux/phy/phy.h>
> > >   #include <linux/platform_device.h>
> > > @@ -96,12 +97,40 @@ static int m_can_plat_probe(struct platform_devic=
e *pdev)
> > >   		goto probe_fail;
> > >   	addr =3D devm_platform_ioremap_resource_byname(pdev, "m_can");
> > > -	irq =3D platform_get_irq_byname(pdev, "int0");
> > > -	if (IS_ERR(addr) || irq < 0) {
> > > -		ret =3D -EINVAL;
> > > +	if (IS_ERR(addr)) {
> > > +		ret =3D PTR_ERR(addr);
> > >   		goto probe_fail;
> > >   	}
> >=20
> > As we don't use an explicit "poll-interval" anymore, this needs some
> > cleanup. The flow should be (pseudo code, error handling omitted):
> >=20
> > if (device_property_present("interrupts") {
> >          platform_get_irq_byname();
> >          polling =3D false;
> > } else {
> >          hrtimer_init();
> >          polling =3D true;
> > }
>=20
> Ok.
>=20
> >=20
> > > +	irq =3D platform_get_irq_byname_optional(pdev, "int0");
> >=20
> > Remove the "_optional" and....
>=20
> On V2, you asked to add the _optional?.....
>=20
> >  	irq =3D platform_get_irq_byname(pdev, "int0");
>=20
> use platform_get_irq_byname_optional(), it doesn't print an error
> message.

ACK - I said that back in v2, when there was "poll-interval". But now we
don't use "poll-interval" anymore, but test if interrupt properties are
present.

See again pseudo-code I posted in my last mail:

| if (device_property_present("interrupts") {
|          platform_get_irq_byname();

If this throws an error, it's fatal, bail out.

|          polling =3D false;
| } else {
|          hrtimer_init();
|          polling =3D true;
| }


>=20
> >=20
> > > +	if (irq =3D=3D -EPROBE_DEFER) {
> > > +		ret =3D -EPROBE_DEFER;
> > > +		goto probe_fail;
> > > +	}
> > > +
> > > +	if (device_property_present(mcan_class->dev, "interrupts") ||
> > > +	    device_property_present(mcan_class->dev, "interrupt-names"))
> > > +		mcan_class->polling =3D false;
> >=20
> > ...move the platform_get_irq_byname() here
>=20
> ok,
>=20
> >=20
> > > +	else
> > > +		mcan_class->polling =3D true;
> > > +
> > > +	if (!mcan_class->polling && irq < 0) {
> > > +		ret =3D -ENXIO;
> > > +		dev_err_probe(mcan_class->dev, ret, "IRQ int0 not found, polling n=
ot activated\n");
> > > +		goto probe_fail;
> > > +	}
> >=20
> > Remove this check.
>=20
> Should we not go to 'probe fail' if polling is not activated and irq is n=
ot
> found?

If an interrupt property is present in the DT, we use it - if request
IRQ fails, something is broken and we've already bailed out. See above.
If there is no interrupt property we use polling.

>=20
> >=20
> > > +
> > > +	if (mcan_class->polling) {
> > > +		if (irq > 0) {
> > > +			mcan_class->polling =3D false;
> > > +			dev_info(mcan_class->dev, "Polling enabled, using hardware IRQ\n"=
);
> >=20
> > Remove this.
>=20
> Remove the dev_info?

ACK, this is not possible anymore - we cannot have polling enabled and
HW IRQs configured.

Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde          |
Embedded Linux                   | https://www.pengutronix.de |
Vertretung N=C3=BCrnberg              | Phone: +49-5121-206917-129 |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-9   |

--6gp3ppfjbjdh2fkv
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEDs2BvajyNKlf9TJQvlAcSiqKBOgFAmRrtnYACgkQvlAcSiqK
BOikhAgAlglWPWRwOfbeMII/Kgzzz+ITsLBkt/npQOZLLcPD4gVTd3jB/efH6X+C
f0qpnK4ykGqM2jIVsE8M6CEvy4DdjwU4te0gZfXj1jx24JRMe/0+lwNCbepWWZ+2
YHugjX93cpW7N8IuABIRpefFB8EdiwGXLkZOQ2xc30BI+/R9uiFhm93NG0wZ7P+O
ovVeUNwAGDv8IleqdWhG28sQ9UdL8fayODePpJcNgUCeWBg5WabqNmg7eZNPomx/
+A3nCmLwaIxpe+7FY3+hwxlUUs2ICHMMkylALz6c0NmvwPXnl0TAFa4KH1ncJxX3
M2eUJbvartsWfyPjSViEWYPij/+WLA==
=ZYYZ
-----END PGP SIGNATURE-----

--6gp3ppfjbjdh2fkv--

