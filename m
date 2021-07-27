Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80F473D6FC1
	for <lists+netdev@lfdr.de>; Tue, 27 Jul 2021 08:54:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235659AbhG0Gyi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Jul 2021 02:54:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235504AbhG0Gyg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Jul 2021 02:54:36 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DFB2C061757
        for <netdev@vger.kernel.org>; Mon, 26 Jul 2021 23:54:37 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1m8Gys-0006Jm-P6; Tue, 27 Jul 2021 08:54:22 +0200
Received: from pengutronix.de (unknown [IPv6:2a03:f580:87bc:d400:ebcc:d5d8:601d:f340])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 07494658DBB;
        Tue, 27 Jul 2021 06:54:16 +0000 (UTC)
Date:   Tue, 27 Jul 2021 08:54:16 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Aswath Govindraju <a-govindraju@ti.com>
Cc:     Chandrasekar Ramakrishnan <rcsekar@samsung.com>,
        Rob Herring <robh+dt@kernel.org>, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Lokesh Vutla <lokeshvutla@ti.com>,
        Kishon Vijay Abraham I <kishon@ti.com>
Subject: Re: [PATCH v4 0/2] MCAN: Add support for implementing transceiver as
 a phy
Message-ID: <20210727065416.k2kye47iiuubkpoz@pengutronix.de>
References: <20210510052541.14168-1-a-govindraju@ti.com>
 <2c5b76f7-8899-ab84-736b-790482764384@ti.com>
 <20210616091709.n7x62wmvafz4rzs7@pengutronix.de>
 <218d6825-82c0-38f5-19ab-235f8e6f74a0@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="v2azx64h5w2k2b3r"
Content-Disposition: inline
In-Reply-To: <218d6825-82c0-38f5-19ab-235f8e6f74a0@ti.com>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--v2azx64h5w2k2b3r
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 19.07.2021 19:47:33, Aswath Govindraju wrote:
> I am planning on posting device tree patches to arm64 tree and
> Nishanth(maintainer of the tree) requested for an immutable tag if the
> dependent patches are not in master. So, after applying this patch
> series, can you please provide an immutable tag ?

The patches are included in my pull request with the tag
linux-can-next-for-5.15-20210725 [1], meanwhile they are in
net-next/master.

Hope that helps,
Marc

[1] https://git.kernel.org/pub/scm/linux/kernel/git/mkl/linux-can-next.git/=
log/?h=3Dlinux-can-next-for-5.15-20210725

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--v2azx64h5w2k2b3r
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEK3kIWJt9yTYMP3ehqclaivrt76kFAmD/rZUACgkQqclaivrt
76m3tAf/YPWX2pxQDaenuXAhziJe1b3a8dM/H5hQZNEPWEnHLNVUiPZMr2cdkEqi
n9H29B9DCjMijeGJNzvjLSPwazaPAopW9BAYkYJ1HW/Ou/V8eYag8icJdlU3CAM4
BTLtIusvbQ1CMrUZsU0y/qSlh9V2agH58I1naVROXXGFHFyTN7/+MUqrm1/GD5IA
/LWjOhGgA3OmZ7wxhzp8YL3PlXgONUAlMPpdPw7i5HOWaXB27DYK16tndyPWQnd9
CIT0cYxKsz5aT60YPuTKYo6+3HuToZRcuRvkKgXbX9IJisv3GLVedAb3SjdEto4y
zpEK+qakjxUwTdmMzaKmFvggvK5zkw==
=Ul5n
-----END PGP SIGNATURE-----

--v2azx64h5w2k2b3r--
