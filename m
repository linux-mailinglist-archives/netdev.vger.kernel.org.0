Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A1B15583C8A
	for <lists+netdev@lfdr.de>; Thu, 28 Jul 2022 12:51:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236515AbiG1KvL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jul 2022 06:51:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236506AbiG1KvJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jul 2022 06:51:09 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC97B13D12
        for <netdev@vger.kernel.org>; Thu, 28 Jul 2022 03:51:08 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1oH16U-0001Zj-4S; Thu, 28 Jul 2022 12:50:54 +0200
Received: from pengutronix.de (unknown [IPv6:2a01:4f8:1c1c:29e9:22:41ff:fe00:1400])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id CE0EABCC4F;
        Thu, 28 Jul 2022 10:50:51 +0000 (UTC)
Date:   Thu, 28 Jul 2022 12:50:49 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Dario Binacchi <dario.binacchi@amarulasolutions.com>
Cc:     Max Staudt <max@enpas.org>, linux-kernel@vger.kernel.org,
        linux-can@vger.kernel.org,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        michael@amarulasolutions.com,
        Amarula patchwork <linux-amarula@amarulasolutions.com>,
        Jeroen Hofstee <jhofstee@victronenergy.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Wolfgang Grandegger <wg@grandegger.com>, netdev@vger.kernel.org
Subject: Re: [RFC PATCH v3 8/9] can: slcan: add support to set bit time
 register (btr)
Message-ID: <20220728105049.43gbjuctezxzmm4j@pengutronix.de>
References: <20220726210217.3368497-1-dario.binacchi@amarulasolutions.com>
 <20220726210217.3368497-9-dario.binacchi@amarulasolutions.com>
 <20220727113054.ffcckzlcipcxer2c@pengutronix.de>
 <20220727192839.707a3453.max@enpas.org>
 <20220727182414.3mysdeam7mtnqyfx@pengutronix.de>
 <CABGWkvoE8i--g_2cNU6ToAfZk9WE6uK-nLcWy7J89hU6RidLWw@mail.gmail.com>
 <20220728090228.nckgpmfe7rpnfcyr@pengutronix.de>
 <CABGWkvoYR67MMmqZ6bRLuL3szhVb-gMwuAy6Z4YMkaG0yw6Sdg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="uchmzozxirr27riu"
Content-Disposition: inline
In-Reply-To: <CABGWkvoYR67MMmqZ6bRLuL3szhVb-gMwuAy6Z4YMkaG0yw6Sdg@mail.gmail.com>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--uchmzozxirr27riu
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 28.07.2022 12:23:04, Dario Binacchi wrote:
> > > Does it make sense to use the device tree
> >
> > The driver doesn't support DT and DT only works for static serial
> > interfaces.

Have you seen my remarks about Device Tree?

> > > to provide the driver with those
> > > parameters required for the automatic calculation of the BTR (clock r=
ate,
> > > struct can_bittiming_const, ...) that depend on the connected
> > > controller?
> >
> > The device tree usually says it's a CAN controller compatible to X and
> > the following clock(s) are connected. The driver for CAN controller X
> > knows the bit timing const. Some USB CAN drivers query the bit timing
> > const from the USB device.
> >
> > > In this way the solution should be generic and therefore scalable. I
> > > think we should also add some properties to map the calculated BTR
> > > value on the physical register of the controller.
> >
> > The driver knows how to map the "struct can_bittiming" to the BTR
> > register values of the hardware.
> >
> > What does the serial protocol say to the BTR values? Are these standard
> > SJA1000 layout with 8 MHz CAN clock or are those adapter specific?
>=20
> I think they are adapter specific.

The BTR values depend on the used CAN controller, the clock rate, and on
the firmware, if it supports BTR at all.

> This is  what the can232_ver3_Manual.pdf reports:
>=20
> sxxyy[CR]         Setup with BTR0/BTR1 CAN bit-rates where xx and yy is a=
 hex
>                          value. This command is only active if the CAN
> channel is closed.
>=20
> xx     BTR0 value in hex
> yy     BTR1 value in hex
>=20
> Example:            s031C[CR]
>                            Setup CAN with BTR0=3D0x03 & BTR1=3D0x1C
>                            which equals to 125Kbit.
>=20
> But I think the example is misleading because IMHO it depends on the
> adapter's controller (0x31C -> 125Kbit).

I think the BTR in can232_ver3_Manual.pdf is compatible to a sja1000
controller with 8 MHz ref clock. See:

| Bit timing parameters for sja1000 with 8.000000 MHz ref clock using algo =
'v4.8'
|  nominal                                  real  Bitrt    nom   real  SampP
|  Bitrate TQ[ns] PrS PhS1 PhS2 SJW BRP  Bitrate  Error  SampP  SampP  Erro=
r   BTR0 BTR1
|  1000000    125   2    3    2   1   1  1000000   0.0%  75.0%  75.0%   0.0=
%   0x00 0x14
|   800000    125   3    4    2   1   1   800000   0.0%  80.0%  80.0%   0.0=
%   0x00 0x16
|   500000    125   6    7    2   1   1   500000   0.0%  87.5%  87.5%   0.0=
%   0x00 0x1c
|   250000    250   6    7    2   1   2   250000   0.0%  87.5%  87.5%   0.0=
%   0x01 0x1c
|   125000    500   6    7    2   1   4   125000   0.0%  87.5%  87.5%   0.0=
%   0x03 0x1c        <---
|   100000    625   6    7    2   1   5   100000   0.0%  87.5%  87.5%   0.0=
%   0x04 0x1c
|    50000   1250   6    7    2   1  10    50000   0.0%  87.5%  87.5%   0.0=
%   0x09 0x1c
|    20000   3125   6    7    2   1  25    20000   0.0%  87.5%  87.5%   0.0=
%   0x18 0x1c
|    10000   6250   6    7    2   1  50    10000   0.0%  87.5%  87.5%   0.0=
%   0x31 0x1c

> > > Or, use the device tree to extend the bittates supported by the contr=
oller
> > > to the fixed ones (struct can_priv::bitrate_const)?
> >
> > The serial protocol defines fixed bit rates, no need to describe them in
> > the DT:
> >
> > |           0            10 Kbit/s
> > |           1            20 Kbit/s
> > |           2            50 Kbit/s
> > |           3           100 Kbit/s
> > |           4           125 Kbit/s
> > |           5           250 Kbit/s
> > |           6           500 Kbit/s
> > |           7           800 Kbit/s
> > |           8          1000 Kbit/s
> >
> > Are there more bit rates?
>=20
> No, the manual can232_ver3_Manual.pdf does not contain any others.
>=20
> What about defining a device tree node for the slcan (foo adapter):
>=20
> slcan {
>     compatible =3D "can,slcan";
>                                      /* bit rate btr0btr1 */
>     additional-bitrates =3D < 33333  0x0123
>                                         80000  0x4567
>                                         83333  0x89ab
>                                       150000 0xcd10
>                                       175000 0x2345
>                                       200000 0x6789>
> };
>=20
> So that the can_priv::bitrate_cons array (dynamically created) will
> contain the bitrates
>            10000,
>            20000,
>            50000,
>          100000,
>          125000,
>          250000,
>          500000,
>          800000,
>         1000000 /* end of standards bitrates,  use S command */
>            33333,  /* use s command, btr 0x0123 */
>            80000,  /* use s command, btr 0x4567 */
>            83333,  /* use s command, btr 0x89ab */
>          150000,  /* use s command, btr 0xcd10 */
>          175000, /* use s command, btr 0x2345 */
>          200000  /* use s command, btr 0x6789 */
> };
>=20
> So if a standard bitrate is requested, the S command is used,
> otherwise the s command with the associated btr.

That would be an option. For proper DT support, the driver needs to be
extended to support serdev. But DT only supports "static" devices.

But if you can calculate BTR values you know the bit timing constants
(and frequency) and then it's better to have the bit timing in the
driver so that arbitrary bit rates can be calculated by the kernel.

regards,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--uchmzozxirr27riu
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmLiagcACgkQrX5LkNig
012fRAf/UPtRjnojGE75hAHeJLUPRk9CLvLZvjAaSg6D3Q+owJdNJ71fQuwrpXYA
1ji3HH97/G8hkTfNFHYfOzuNa7CFaeSUQEoMcjDkRlKthxdgG2tSARk3UeySPDqd
gdr1taEcID+6iL/rp95cv86mtngg/z4qLRbmFa3T56KTpzfIq/oBVVdgT+uAhrep
uEWkO+4SAr0SdfXpsR973ykdKmbEtRliPXQJR8j7ByxARJNATKD8AZxfuQnxDkE5
Ig+vGqHPHrR36iYlmLO9+1fskAt08wfKXObZ/D06dTRyBcZoKakJ0baEWYtf0VR7
ZcCG1ClWGyWwCXKPUg0KF9bgUB02mg==
=6G3L
-----END PGP SIGNATURE-----

--uchmzozxirr27riu--
