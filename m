Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9AC40487CEB
	for <lists+netdev@lfdr.de>; Fri,  7 Jan 2022 20:20:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231425AbiAGTUc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jan 2022 14:20:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231470AbiAGTUb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Jan 2022 14:20:31 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4099EC06173F
        for <netdev@vger.kernel.org>; Fri,  7 Jan 2022 11:20:31 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1n5umh-00036Z-Fo; Fri, 07 Jan 2022 20:20:19 +0100
Received: from pengutronix.de (2a03-f580-87bc-d400-a092-a409-034d-fe76.ip6.dokom21.de [IPv6:2a03:f580:87bc:d400:a092:a409:34d:fe76])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 90EC06D3397;
        Fri,  7 Jan 2022 19:20:15 +0000 (UTC)
Date:   Fri, 7 Jan 2022 20:20:14 +0100
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Dario Binacchi <dario.binacchi@amarulasolutions.com>
Cc:     linux-kernel@vger.kernel.org, linux-can@vger.kernel.org,
        Coiby Xu <coiby.xu@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        M Chetan Kumar <m.chetan.kumar@intel.com>,
        linux-doc@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [RFC PATCH 0/2] Add the first documentation for a CAN driver
Message-ID: <20220107192014.pyxgn22ztrppr7zx@pengutronix.de>
References: <20220107081306.3681899-1-dario.binacchi@amarulasolutions.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="fzbitevbj72paz57"
Content-Disposition: inline
In-Reply-To: <20220107081306.3681899-1-dario.binacchi@amarulasolutions.com>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--fzbitevbj72paz57
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 07.01.2022 09:13:04, Dario Binacchi wrote:
> The series was born from the need to document the enabling at runtime
> reception of RTR frames for the Flexcan CAN controller.
> For more details see https://lore.kernel.org/all/20220106105415.pdmrdgnx6=
p2tyff6@pengutronix.de/

Thanks for the work, looks good. I've added some more text and send a
v3.

regards,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--fzbitevbj72paz57
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEK3kIWJt9yTYMP3ehqclaivrt76kFAmHYkmsACgkQqclaivrt
76lebQf/fyVNMM16d957P9Z+Bc7bY0HlxfqFts6+IEQGJfc147sFPcsLbW2+5h2T
/pZ09W9ff2I3S3P5b9rIg/G1UyxGs3/IKrLQPB4cWSvjIC+9b3prQ/w3NKXKJjyR
JLrJDLr8qd8JuYIEhW/NMfbN6mJWZfmw6GCTHIpgaVaevcJpS92iQ74p9Eae43So
w1ihZ+8/kOc0sxvejJyRwWWmOvKCmTe02EpTFApAlJFhJR+jFf5WLmx3Z8lk7K/3
DwP03dLpYkDUuueUwgYfo4vVsnCS8qyBi+q43lR4ryvcnBt4xbxRh5QKOZzVdMf6
XjvvXYkZ5uYpgD6G2+ZT/km8hpP6Rw==
=MmDg
-----END PGP SIGNATURE-----

--fzbitevbj72paz57--
