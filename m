Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FEBA341738
	for <lists+netdev@lfdr.de>; Fri, 19 Mar 2021 09:18:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234339AbhCSIR6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Mar 2021 04:17:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234330AbhCSIRo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Mar 2021 04:17:44 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82CD9C06174A
        for <netdev@vger.kernel.org>; Fri, 19 Mar 2021 01:17:44 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1lNAK3-000401-Ru; Fri, 19 Mar 2021 09:17:31 +0100
Received: from pengutronix.de (unknown [IPv6:2a03:f580:87bc:d400:7ffa:65dd:d990:c71d])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 0A1135FA666;
        Fri, 19 Mar 2021 08:17:28 +0000 (UTC)
Date:   Fri, 19 Mar 2021 09:17:28 +0100
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Pankaj Sharma <pankj.sharma@samsung.com>
Cc:     linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, wg@grandegger.com,
        davem@davemloft.net, kuba@kernel.org, pankaj.dubey@samsung.com,
        rcsekar@samsung.com
Subject: Re: [PATCH] MAINTAINERS: Update MCAN MMIO device driver maintainer
Message-ID: <20210319081728.aleitkqigmq2kkim@pengutronix.de>
References: <CGME20210318112550epcas5p4ea94d6b6df15064aa2af53dc5c290e52@epcas5p4.samsung.com>
 <20210318112634.31149-1-pankj.sharma@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="ne4wqz5svgiyasy4"
Content-Disposition: inline
In-Reply-To: <20210318112634.31149-1-pankj.sharma@samsung.com>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--ne4wqz5svgiyasy4
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 18.03.2021 16:56:34, Pankaj Sharma wrote:
> Update Chandrasekar Ramakrishnan as maintainer for mcan mmio device drive=
r as I
> will be moving to a different role.

Applied to can-next/testing.

regards,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--ne4wqz5svgiyasy4
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEK3kIWJt9yTYMP3ehqclaivrt76kFAmBUXhUACgkQqclaivrt
76k9qAgAkZwz9JcQ4Fj3z5tV/ynmd0XRrbEEbCxolJ9cIEddszBbu+XsGz7nnOWW
LIcJx9uL1prNcB0AEHd5iSUckvcOPmeM5CmF4TIvs1bu0hyurPkxR6OlLtUhXkh6
V9ch83gKuQ+aLYbMjiPycJ84tA4ovbAwCnzGSKuoLWtc2O9XJBpq4iPt8jtHCDjr
VmAqRxEgEbUjGHK/+/HOxgmVis6tUUmF0WV9F8w4JePFBfJKjRga8D2gvoxNhyaW
QxwNJuU9DiNL3QlmWy7OyCEauvrevy8aquhZheKkA314YehUoBefaVCbogpDyfVR
MjhAfOZrmW8PAaC+8jKlHOaX9oZT3w==
=w8F1
-----END PGP SIGNATURE-----

--ne4wqz5svgiyasy4--
