Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C720C470147
	for <lists+netdev@lfdr.de>; Fri, 10 Dec 2021 14:06:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241434AbhLJNJ5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Dec 2021 08:09:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241422AbhLJNJ5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Dec 2021 08:09:57 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1776AC061746
        for <netdev@vger.kernel.org>; Fri, 10 Dec 2021 05:06:22 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1mvfbG-0004nA-Sw; Fri, 10 Dec 2021 14:06:10 +0100
Received: from pengutronix.de (2a03-f580-87bc-d400-5708-5a2a-1200-a3e0.ip6.dokom21.de [IPv6:2a03:f580:87bc:d400:5708:5a2a:1200:a3e0])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 9DAFF6C145E;
        Fri, 10 Dec 2021 13:06:08 +0000 (UTC)
Date:   Fri, 10 Dec 2021 14:06:07 +0100
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc:     linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Wolfgang Grandegger <wg@grandegger.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH v1 1/1] can: mcp251x: Get rid of duplicate of_node
 assignment
Message-ID: <20211210130607.rajkkzr7lf6l4tok@pengutronix.de>
References: <20211202205855.76946-1-andriy.shevchenko@linux.intel.com>
 <YbHvcDhtZFTyfThT@smile.fi.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="fb4ksewdxxpcboug"
Content-Disposition: inline
In-Reply-To: <YbHvcDhtZFTyfThT@smile.fi.intel.com>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--fb4ksewdxxpcboug
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 09.12.2021 13:58:40, Andy Shevchenko wrote:
> On Thu, Dec 02, 2021 at 10:58:55PM +0200, Andy Shevchenko wrote:
> > GPIO library does copy the of_node from the parent device of
> > the GPIO chip, there is no need to repeat this in the individual
> > drivers. Remove assignment here.
> >=20
> > For the details one may look into the of_gpio_dev_init() implementation.
>=20
> Marc, what do you think about this change?

LGTM, added to linux-can-next/testing.

regards,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--fb4ksewdxxpcboug
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEK3kIWJt9yTYMP3ehqclaivrt76kFAmGzUL0ACgkQqclaivrt
76k2agf/VDkthQ3EX6w8ojh5XG3RmQvB02hlee7wKWddkh9TAjodcKad1d/luhR2
MBPm2CBv/+1zNv2KCVltjPt8oQhugqTKu+SRJBjwWXZfWI39ITgxrZf9VNY/h8z1
XM1HVoKCrAT6KycD4B5ikx3wmZ+QkFO/JQDh9UjNI8VJqEMi/V7ThpO8sv4uFpR4
vzchtj/RmLgyPLfNvEUiQ0sVKBm0ry/CPC41qpRlA3pHVGJwU1oEbPtEwoGlAqsc
gYyC3ZCIVwCN8weKmHD5RT8JXPammO5fQDrvTeqkoXrrSjCepbIym5noMyaZ6Kw7
SXWWR08GGaibJcXKBthF/Z8dnKZ8Rg==
=eJaK
-----END PGP SIGNATURE-----

--fb4ksewdxxpcboug--
