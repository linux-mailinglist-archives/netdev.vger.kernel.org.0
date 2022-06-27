Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A9B755D7B4
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 15:18:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234589AbiF0LXV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jun 2022 07:23:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234581AbiF0LXT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jun 2022 07:23:19 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D315A6579
        for <netdev@vger.kernel.org>; Mon, 27 Jun 2022 04:23:18 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1o5mpc-0008NY-20; Mon, 27 Jun 2022 13:23:04 +0200
Received: from pengutronix.de (p200300ea0f22910007affeaf77f41373.dip0.t-ipconnect.de [IPv6:2003:ea:f22:9100:7af:feaf:77f4:1373])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 855B4A0269;
        Mon, 27 Jun 2022 11:23:01 +0000 (UTC)
Date:   Mon, 27 Jun 2022 13:23:00 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Conor.Dooley@microchip.com
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        linux-can@vger.kernel.org, kernel@pengutronix.de,
        palmer@dabbelt.com, linux-riscv@lists.infradead.org
Subject: Re: [PATCH net-next 16/22] riscv: dts: microchip: add mpfs's CAN
 controllers
Message-ID: <20220627112300.sfohehohqynafpvm@pengutronix.de>
References: <20220625120335.324697-1-mkl@pengutronix.de>
 <20220625120335.324697-17-mkl@pengutronix.de>
 <ff40e50f-728d-dba3-6aa2-59db573d6f76@microchip.com>
 <20220627073001.2l6twpyt7fg252ul@pengutronix.de>
 <a1b84760-821f-a279-ca2c-b22d5f1a99fa@microchip.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="2cxa57jnpkpbd3uu"
Content-Disposition: inline
In-Reply-To: <a1b84760-821f-a279-ca2c-b22d5f1a99fa@microchip.com>
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


--2cxa57jnpkpbd3uu
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 27.06.2022 11:17:39, Conor.Dooley@microchip.com wrote:
> On 27/06/2022 08:30, Marc Kleine-Budde wrote:
> > EXTERNAL EMAIL: Do not click links or open attachments unless you know =
the content is safe
> > On 27.06.2022 07:12:47, Conor.Dooley@microchip.com wrote:
> >> On 25/06/2022 13:03, Marc Kleine-Budde wrote:
> >>> EXTERNAL EMAIL: Do not click links or open attachments unless you kno=
w the content is safe
> >>>
> >>> From: Conor Dooley <conor.dooley@microchip.com>
> >>>
> >>> PolarFire SoC has a pair of CAN controllers, but as they were
> >>> undocumented there were omitted from the device tree. Add them.
> >>>
> >>> Link: https://lore.kernel.org/all/20220607065459.2035746-3-conor.dool=
ey@microchip.com
> >>> Signed-off-by: Conor Dooley <conor.dooley@microchip.com>
> >>> Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
> >>
> >> Hey Marc,
> >> Not entirely familiar with the process here.
> >> Do I apply this patch when the rest of the series gets taken,
> >> or will this patch go through the net tree?
> >
> > Both patches:
> >
> >  38a71fc04895 riscv: dts: microchip: add mpfs's CAN controllers
> >  c878d518d7b6 dt-bindings: can: mpfs: document the mpfs CAN controller
> >
> > are on they way to mainline via the net-next tree. No further actions
> > needed on your side.
>=20
> dts through the netdev tree rater than via the arch? Seems a little odd,
> but it'd be via my tree anyway and I don't mind & unless Palmer objects:
> Acked-by: Conor Dooley <conor.dooley@microchip.com>

It was just applied to net-next/master. Drop me a note if something
should be reverted.

regards,
Marc
--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--2cxa57jnpkpbd3uu
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmK5kxIACgkQrX5LkNig
011J0gf/S2BHtQ4rY897eeP6Vqh/oPwhzmwUpeHHRofCMiYqgoiLpD/DFeso8YSi
KtfsiE2Fxp+cUSFGI5EX5OIwRx2AZFplh34ZMNN5/3HykYTnf7cPTX6lYXXVDJdN
9mYYnf9GNQ8z8Est9rM4omJbKMWecQ4Cwu9aYTvKWWF/62tIqGoIDnit7qzsvDrL
fIHlrPccrHMp8fVMjJPW1nca6d64zDbv5NEIxp9UU1MnRZiDkvcbna11AhaElN1B
sZT3Z6vcnmRD4zEsT8QH9HL7Vh8m3mjTvidnwW5QAQODHG4xnkGBw4Irj4RWbp/H
cMtYA3tKGuSOOg3jjoBwowRx72Tp6g==
=R9Ry
-----END PGP SIGNATURE-----

--2cxa57jnpkpbd3uu--
