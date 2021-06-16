Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 261FD3A97C9
	for <lists+netdev@lfdr.de>; Wed, 16 Jun 2021 12:39:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232356AbhFPKlv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Jun 2021 06:41:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232306AbhFPKlu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Jun 2021 06:41:50 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A397C061574
        for <netdev@vger.kernel.org>; Wed, 16 Jun 2021 03:39:44 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1ltSxP-0003BW-Cu; Wed, 16 Jun 2021 12:39:39 +0200
Received: from pengutronix.de (unknown [IPv6:2a03:f580:87bc:d400:27:4a54:dbae:b593])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 85D0663D222;
        Wed, 16 Jun 2021 10:39:38 +0000 (UTC)
Date:   Wed, 16 Jun 2021 12:39:37 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Yang Yingliang <yangyingliang@huawei.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-can@vger.kernel.org
Subject: Re: [PATCH -next] can: m_can: use
 devm_platform_ioremap_resource_byname
Message-ID: <20210616103937.asp3i7t3coci6nuq@pengutronix.de>
References: <20210603073441.2983497-1-yangyingliang@huawei.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="l7v6zfm4t6tus7bd"
Content-Disposition: inline
In-Reply-To: <20210603073441.2983497-1-yangyingliang@huawei.com>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--l7v6zfm4t6tus7bd
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 03.06.2021 15:34:41, Yang Yingliang wrote:
> Use the devm_platform_ioremap_resource_byname() helper instead of
> calling platform_get_resource_byname() and devm_ioremap_resource()
> separately.
>=20
> Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>

Applied to linux-can-next/testing.

Tnx,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--l7v6zfm4t6tus7bd
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEK3kIWJt9yTYMP3ehqclaivrt76kFAmDJ1OcACgkQqclaivrt
76nz6QgAhAWqi3kOw4mMppX3AK5PU1ptApiRfF960KYMTP5fn7pDacgWLsDJFlw+
DYlzGwbny9/c1iCwx/SxWj/+MsvsfqtEjgkZPLGfqIH0+3kynhsM4d59Y3LHybXJ
K1cJ0mwXaGuCpb0JexsjWYml2n8dkN4l2QYYyHkoSRQ3eZtt6WBcxMwQNgXHhD6D
9y1/4tuaaJP1pWDb8mpmPuVTQuhIf/d4NX7kh+I1RdPhmDwyAV3kjUA+AdAqjeXY
S3xioRNV2xmwo1KNPgG690A4TDrwBZ7UuCh2SaA7euR8YpGCRit0UCax1NlxKLbi
l/aSV7uuas/fgKi13yr/zvDd5JtjUA==
=geAl
-----END PGP SIGNATURE-----

--l7v6zfm4t6tus7bd--
