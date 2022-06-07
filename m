Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 231E553FADB
	for <lists+netdev@lfdr.de>; Tue,  7 Jun 2022 12:09:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240641AbiFGKJi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jun 2022 06:09:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240633AbiFGKJh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jun 2022 06:09:37 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 956D1A206D
        for <netdev@vger.kernel.org>; Tue,  7 Jun 2022 03:09:36 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1nyW9O-0006iZ-7R; Tue, 07 Jun 2022 12:09:26 +0200
Received: from pengutronix.de (unknown [IPv6:2a01:4f8:1c1c:29e9:22:41ff:fe00:1400])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 0F22A8DAD8;
        Tue,  7 Jun 2022 10:09:23 +0000 (UTC)
Date:   Tue, 7 Jun 2022 12:09:23 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Dario Binacchi <dario.binacchi@amarulasolutions.com>
Cc:     linux-kernel@vger.kernel.org,
        Amarula patchwork <linux-amarula@amarulasolutions.com>,
        michael@amarulasolutions.com,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [RFC PATCH 07/13] can: slcan: set bitrate by CAN device driver
 API
Message-ID: <20220607100923.odtfxpoupz66zlku@pengutronix.de>
References: <20220607094752.1029295-1-dario.binacchi@amarulasolutions.com>
 <20220607094752.1029295-8-dario.binacchi@amarulasolutions.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="evlblvdpykbg7ppi"
Content-Disposition: inline
In-Reply-To: <20220607094752.1029295-8-dario.binacchi@amarulasolutions.com>
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


--evlblvdpykbg7ppi
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 07.06.2022 11:47:46, Dario Binacchi wrote:
> It allows to set the bitrate via ip tool, as it happens for the other
> CAN device drivers. It still remains possible to set the bitrate via
> slcand or slcan_attach utilities. In case the ip tool is used, the
> driver will send the serial command to the adapter.
>=20
> The struct can_bittiming_const and struct can_priv::clock.freq has been
> set with empirical values =E2=80=8B=E2=80=8Bthat allow you to get a corre=
ct bit timing, so
> that the slc_do_set_bittiming() can be called.

The CAN framework supports setting of fixed bit rates. Look for
can327_bitrate_const in

| https://lore.kernel.org/all/20220602213544.68273-1-max@enpas.org/

Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--evlblvdpykbg7ppi
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmKfI9AACgkQrX5LkNig
010NZwf+JWg6xvugVyjZcc5tcPU4ayE2K4Z9BcyeMSfFWwVCObD8APUzDwcQy+as
XH36+DPh0unr2XVGYKaaWV9SEeDAWTXkbchB5gH1LOBn1HnMY/kezSZY33FZRq1y
mwoorfFTiMDgvnnH3Je3+mDPVf7jyxrWbjYEjuicfhhD4ot/X3gDfWxLgT7jwfDR
AsOYRfpmvL/7YOB4suMSPS511xMjrBdjVoeuTzLv7O0lRa/UWDdK1RXQXIDqeWLK
6lMSmQD8hAjCk//jzMdbQqzCLpBtLe2ficPAOSy4FUd/qzl3/20AszoOXaSD5cAG
92g3AEgfHzKaHVSB1AHYDYrijMIL2g==
=49Aq
-----END PGP SIGNATURE-----

--evlblvdpykbg7ppi--
