Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C77646145A6
	for <lists+netdev@lfdr.de>; Tue,  1 Nov 2022 09:27:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229937AbiKAI1I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Nov 2022 04:27:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230003AbiKAI1H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Nov 2022 04:27:07 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11C59183B2
        for <netdev@vger.kernel.org>; Tue,  1 Nov 2022 01:27:06 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1opmbq-0006ee-4a; Tue, 01 Nov 2022 09:26:58 +0100
Received: from pengutronix.de (unknown [IPv6:2a01:4f8:1c1c:29e9:22:41ff:fe00:1400])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (prime256v1) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id A30FD10FCD5;
        Tue,  1 Nov 2022 08:26:55 +0000 (UTC)
Date:   Tue, 1 Nov 2022 09:26:54 +0100
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        netdev@vger.kernel.org, davem@davemloft.net,
        linux-can@vger.kernel.org, kernel@pengutronix.de
Subject: Re: [PATCH net-next 0/14] pull-request: can-next 2022-10-31
Message-ID: <20221101082654.t77t7tb3fextcoh5@pengutronix.de>
References: <20221031154406.259857-1-mkl@pengutronix.de>
 <20221031202714.1eada551@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="hm4i4doa466ayupn"
Content-Disposition: inline
In-Reply-To: <20221031202714.1eada551@kernel.org>
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


--hm4i4doa466ayupn
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 31.10.2022 20:27:14, Jakub Kicinski wrote:
> On Mon, 31 Oct 2022 16:43:52 +0100 Marc Kleine-Budde wrote:
> > The first 7 patches are by Stephane Grosjean and Lukas Magel and
> > target the peak_usb driver. Support for flashing a user defined device
> > ID via the ethtool flash interface is added. A read only sysfs
>=20
> nit: ethtool eeprom set !=3D ethtool flash

Right, the driver uses the eeprom callbacks of ethtool.

> > attribute for that value is added to distinguish between devices via
> > udev.
>=20
> So the user can write an arbitrary u32 value into flash which then
> persistently pops up in sysfs across reboots (as a custom attribute
> called "user_devid")?

ACK - Some devices support a u32, others only a u8.

> I don't know.. the whole thing strikes me as odd. Greg do you have any
> feelings about such.. solutions?
>=20
> patches 5 and 6 here:
> https://lore.kernel.org/all/20221031154406.259857-1-mkl@pengutronix.de/

Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--hm4i4doa466ayupn
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmNg2EQACgkQrX5LkNig
012HsQf/UGAj1oyEw0VixDg3M6/jny9LMKolvNH7GDMe2RivJ82+VTyYAy2pkSxu
SXeCXmXMR2cqwKQNe8Q9rYL7XFn0Iokpb9sWFHhiI78bAXf2o3K8bnG8OrvKkQVZ
cRc+uIBYkqfcs3oE36Ix6NcLsSCHcrSDdLyMpM1gbthUUHPjb0YhaoIwn9OTV+zF
lAOV3WKixbxmgXYRTwYKScLgShuAn7Rs5hYovzGNPdimIwnYkQ2S8CpTpikWpTb1
4PdFr3sss34QVGjzEZjJnmrPL5hPoX+CaXbnfoCd+yHTnN2ctdGPGpGl985J6iRR
dpF6gZAZ3rmR9PyMa8xvEe5tIhj/Rw==
=h6BQ
-----END PGP SIGNATURE-----

--hm4i4doa466ayupn--
