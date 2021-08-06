Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E9BB3E28C1
	for <lists+netdev@lfdr.de>; Fri,  6 Aug 2021 12:36:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245208AbhHFKhF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Aug 2021 06:37:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245108AbhHFKhD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Aug 2021 06:37:03 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51227C061798
        for <netdev@vger.kernel.org>; Fri,  6 Aug 2021 03:36:48 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1mBxDX-0000xn-9c; Fri, 06 Aug 2021 12:36:43 +0200
Received: from pengutronix.de (unknown [IPv6:2a02:810a:8940:aa0:66f0:974b:98ab:a2fd])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 48280661E12;
        Fri,  6 Aug 2021 10:36:41 +0000 (UTC)
Date:   Fri, 6 Aug 2021 12:36:39 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Andrejs Cainikovs <andrejs.cainikovs@gmail.com>
Cc:     ezequiel@collabora.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-can@vger.kernel.org,
        Dario Binacchi <dariobin@libero.it>
Subject: Re: [PATCH 0/2] D_CAN RX buffer size improvements
Message-ID: <20210806103639.q3xim42zcispv6ak@pengutronix.de>
References: <20190208132954.28166-1-andrejs.cainikovs@netmodule.com>
 <4da667f3-899a-459c-2cca-6514135a1918@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="ljdw7bteqjpthojv"
Content-Disposition: inline
In-Reply-To: <4da667f3-899a-459c-2cca-6514135a1918@gmail.com>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--ljdw7bteqjpthojv
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 06.08.2021 12:16:26, Andrejs Cainikovs wrote:
> Sorry for a late reply. I'm the author of this patch set, and I will
> have a look at this after I obtain the hardware. I hope this is still
> relevant.

Dario (Cc'ed) created a proper patch series to support 64 message
objects. The series has been mainlined in:

https://git.kernel.org/linus/132f2d45fb2302a582aef617ea766f3fa52a084c

Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--ljdw7bteqjpthojv
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEK3kIWJt9yTYMP3ehqclaivrt76kFAmENELUACgkQqclaivrt
76n1bAf+Jf09YVSpTXhDggE8e/L/5sth+tbUq8M6PRmZmTP/U+ZXCHFhgKCp/09+
3ua8CL7EwGSsiEsmFmt/QCIdtn9ruIHkgZ8s4uCXhUM45YSKqC7OyPGLEf8n+DZT
cctJyMFAj5rVDswh7nGET3SyrelJWByKYvRbasK2dT3ivhXt+Fr9AUbrq3BXdazh
Ib/Yy5SJfLkOMRj7qHZHp9AKn9vmZ39x3uI2klfQv/gHRt1MCAplU4UH4BKQ1v+R
j1aGme/ITy6QcprlwtXW+Asb6oQ8nV6KGbj9XdfSy1GuM57fK17fFQolizXMAvTC
ErWUrtA1vRq+vdoTUTYDd+Y9aDPR6Q==
=O5oe
-----END PGP SIGNATURE-----

--ljdw7bteqjpthojv--
