Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0DDCD5FEE51
	for <lists+netdev@lfdr.de>; Fri, 14 Oct 2022 15:02:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229819AbiJNNCs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Oct 2022 09:02:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229774AbiJNNCr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Oct 2022 09:02:47 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95F611C8835
        for <netdev@vger.kernel.org>; Fri, 14 Oct 2022 06:02:46 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1ojKKX-0001M4-Io; Fri, 14 Oct 2022 15:02:25 +0200
Received: from pengutronix.de (unknown [IPv6:2a01:4f8:1c1c:29e9:22:41ff:fe00:1400])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (prime256v1) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id B2C2DFE29F;
        Fri, 14 Oct 2022 13:02:22 +0000 (UTC)
Date:   Fri, 14 Oct 2022 15:02:20 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Vivek Yadav <vivek.2311@samsung.com>
Cc:     rcsekar@samsung.com, wg@grandegger.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        pankaj.dubey@samsung.com, ravi.patel@samsung.com,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] can: mcan: Add support for handling DLEC error on CAN
 FD
Message-ID: <20221014130220.jfdldo644aq5x6ox@pengutronix.de>
References: <CGME20221014121257epcas5p3805649d1a77149ac4d3dd110fb808633@epcas5p3.samsung.com>
 <20221014114613.33369-1-vivek.2311@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="nsyareichhihttzn"
Content-Disposition: inline
In-Reply-To: <20221014114613.33369-1-vivek.2311@samsung.com>
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


--nsyareichhihttzn
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 14.10.2022 17:16:13, Vivek Yadav wrote:
> When a frame in CAN FD format has reached the data phase, the next
> CAN event (error or valid frame) will be shown in DLEC.
>=20
> Utilizes the dedicated flag (Data Phase Last Error Code: DLEC flag) to
> determine the type of last error that occurred in the data phase
> of a CAN FD frame and handle the bus errors.

Can you please test your code before sending it.

| drivers/net/can/m_can/m_can.c: In function =E2=80=98m_can_handle_bus_erro=
rs=E2=80=99:
| include/linux/build_bug.h:16:51: error: negative width in bit-field =E2=
=80=98<anonymous>=E2=80=99
|    16 | #define BUILD_BUG_ON_ZERO(e) ((int)(sizeof(struct { int:(-!!(e));=
 })))
[...]
| drivers/net/can/m_can/m_can.c:883:17: warning: ISO C90 forbids mixed decl=
arations and code [-Wdeclaration-after-statement]
|   883 |                 u8 dlec =3D FIELD_GET(PSR_DLEC_MASK, psr);
|       |                 ^~

regards,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--nsyareichhihttzn
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmNJXdkACgkQrX5LkNig
010E+ggAr4/hTIGmZRl7ym8KMWr1saLyszKV4xOnKcuQNMW9IR4eDH0jVoLnSIur
zfkSEEIfjZWMRJhHu4h2iIV6YnkBz0jZa5rMnDG63LSYJOl2UT1yBNzo1MBFjhhs
JSLdk069k9y1R2oAZ0Madks2vkHN42HHqOXG4/c7aa/vAMK8mHIws4z16nMonF0x
fsfwzm8QXhKSdzQ3vVJkbupFKoUe7a+FB5dOKlG1oOqTCXY2CEKz553qPP8le8Ql
w5mFYCOWBhy5ESxuIBFDQA0+MiCmeuFgGNZiULHQAd0dU1ROmBI9VKFTOkNXxeXU
XHZfHqoLfscfXRyzKOefhrBVb/X5jw==
=XetC
-----END PGP SIGNATURE-----

--nsyareichhihttzn--
