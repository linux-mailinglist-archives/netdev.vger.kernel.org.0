Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D38354886C1
	for <lists+netdev@lfdr.de>; Sat,  8 Jan 2022 23:29:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234876AbiAHW3T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Jan 2022 17:29:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229899AbiAHW3S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 Jan 2022 17:29:18 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93A52C06173F
        for <netdev@vger.kernel.org>; Sat,  8 Jan 2022 14:29:18 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1n6KD1-0001CP-Q9; Sat, 08 Jan 2022 23:29:11 +0100
Received: from pengutronix.de (2a03-f580-87bc-d400-6624-65e0-1d16-9a67.ip6.dokom21.de [IPv6:2a03:f580:87bc:d400:6624:65e0:1d16:9a67])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 469416D3B84;
        Sat,  8 Jan 2022 22:29:10 +0000 (UTC)
Date:   Sat, 8 Jan 2022 23:29:04 +0100
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Brian Silverman <brian.silverman@bluerivertech.com>
Cc:     Brian Silverman <bsilver16384@gmail.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        "open list:CAN NETWORK DRIVERS" <linux-can@vger.kernel.org>,
        "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] can: gs_usb: Zero-initialize flags
Message-ID: <20220108222904.plwxywgmnwrwpvmt@pengutronix.de>
References: <20220106002952.25883-1-brian.silverman@bluerivertech.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="pjxvzi7v3h4aeqoz"
Content-Disposition: inline
In-Reply-To: <20220106002952.25883-1-brian.silverman@bluerivertech.com>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--pjxvzi7v3h4aeqoz
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 05.01.2022 16:29:50, Brian Silverman wrote:
> No information is deliberately sent here in host->device communications,
> but the open-source candleLight firmware echoes it back, which can
> result in the GS_CAN_FLAG_OVERFLOW flag being set and generating
> spurious ERRORFRAMEs.
>=20
> Signed-off-by: Brian Silverman <brian.silverman@bluerivertech.com>

Applied to linux-can/testing + opened an issue on github:
https://github.com/candle-usb/candleLight_fw/issues/87

Thanks,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--pjxvzi7v3h4aeqoz
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEK3kIWJt9yTYMP3ehqclaivrt76kFAmHaECsACgkQqclaivrt
76mXDgf/b4ClkCbm/lky9poV+sXGbqtEc05wazrWOw32rg1valAD6Ev7Cqjhb93A
EKD7l4l7XiSu8MQpnkc795zinvDb59c7TOM7TQ7VCahku9yppJYVynVD0/J4Ktu4
jr6HnipC70NOqZoEpXpWaklfL/Hynl3//42quNvdOOA6mKr8SvtvM8WSIZ6pYA3/
y5cJ7I7nPaM9LdKEiUOqnV0g+gz6/rXTsc9Oh8uXrzNpYKA4q1fdoRCRFU0nG6zO
jfxoqNfLIZ09xlcRMsyn1hVIqrr7S0C75aE9rUX6mptI3Pkrtf6Y55/l97i7UESD
d5XBoofpzs9GZ8ZpBKQy/uI9bJDdvQ==
=PeL/
-----END PGP SIGNATURE-----

--pjxvzi7v3h4aeqoz--
