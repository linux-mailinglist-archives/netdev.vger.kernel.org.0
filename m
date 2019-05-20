Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CCFB523B83
	for <lists+netdev@lfdr.de>; Mon, 20 May 2019 17:05:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387825AbfETPFP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 May 2019 11:05:15 -0400
Received: from sauhun.de ([88.99.104.3]:51558 "EHLO pokefinder.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730766AbfETPFP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 May 2019 11:05:15 -0400
Received: from localhost (p54B333DA.dip0.t-ipconnect.de [84.179.51.218])
        by pokefinder.org (Postfix) with ESMTPSA id 3853E2C2761;
        Mon, 20 May 2019 17:05:11 +0200 (CEST)
Date:   Mon, 20 May 2019 17:05:10 +0200
From:   Wolfram Sang <wsa@the-dreams.de>
To:     Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc:     Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        x86@kernel.org, linux-acpi@vger.kernel.org,
        linux-edac@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-amlogic@lists.infradead.org, linux-arm-msm@vger.kernel.org,
        linux-gpio@vger.kernel.org, linux-i2c@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, xen-devel@lists.xenproject.org,
        platform-driver-x86@vger.kernel.org, devel@driverdev.osuosl.org,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        devel@acpica.org, linux-mm@kvack.org,
        linux-security-module@vger.kernel.org,
        linux-kselftest@vger.kernel.org
Subject: Re: [PATCH 10/10] docs: fix broken documentation links
Message-ID: <20190520150510.GA2606@kunai>
References: <cover.1558362030.git.mchehab+samsung@kernel.org>
 <4fd1182b4a41feb2447c7ccde4d7f0a6b3c92686.1558362030.git.mchehab+samsung@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="6c2NcOVqGQ03X4Wi"
Content-Disposition: inline
In-Reply-To: <4fd1182b4a41feb2447c7ccde4d7f0a6b3c92686.1558362030.git.mchehab+samsung@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--6c2NcOVqGQ03X4Wi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, May 20, 2019 at 11:47:39AM -0300, Mauro Carvalho Chehab wrote:
> Mostly due to x86 and acpi conversion, several documentation
> links are still pointing to the old file. Fix them.
>=20
> Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>

Thanks, didn't notice that.

>  Documentation/i2c/instantiating-devices          |  2 +-

=2E..

> diff --git a/Documentation/i2c/instantiating-devices b/Documentation/i2c/=
instantiating-devices
> index 0d85ac1935b7..5a3e2f331e8c 100644
> --- a/Documentation/i2c/instantiating-devices
> +++ b/Documentation/i2c/instantiating-devices
> @@ -85,7 +85,7 @@ Method 1c: Declare the I2C devices via ACPI
>  -------------------------------------------
> =20
>  ACPI can also describe I2C devices. There is special documentation for t=
his
> -which is currently located at Documentation/acpi/enumeration.txt.
> +which is currently located at Documentation/firmware-guide/acpi/enumerat=
ion.rst.
> =20
> =20
>  Method 2: Instantiate the devices explicitly

For this I2C part:

Reviewed-by: Wolfram Sang <wsa@the-dreams.de>


--6c2NcOVqGQ03X4Wi
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEOZGx6rniZ1Gk92RdFA3kzBSgKbYFAlziwiIACgkQFA3kzBSg
Kbb/+hAArOEJ2RcuEqvOP7Ge80J7VxtEVTCR0sWRFg/7cpRGLnwf1qLSAUlfAJYj
fUhZ9ANfeB4Y4ZltOPwJ34KNtZy/kYzYyoy/WgiNfJUrf+s7auOF+dMXRvBe8VyX
v/pHpAMzTf8rtNkaESOahPExL1lgrI2dShZa3Mxofm2eb3Kam0OJRr6Cvj7mA/Rq
PHq1QUlG+Y3hZdvAHjQ6GN6wr+pNnhqeSSAd3BZg5MZQpPRiaK+C4tPkqOD/TNwX
9+iPJTMPhWsdei4UO1POHGCOclFatxkPOQm9JjsTD1h1lEJK7Afs1cTCd0crwpzW
nQuj+MSjKTqcOwQ4hF1x6PwlbJm4Hq/+r6b50UsnQYai6pt7Khp9OISmYTxPQhgI
8aXZbjsMB3k9ebYulULGdF0f3p/IPoqneTUf3yi5OxNbhJ8eyNcQ4l35MP9hEyYb
H/9a/G4GXP7CLyCtKd53OtNeE1tTF4zGKIhe7v9OInHolA3gLx1R1rxiBeQB+XyA
NO/4FdEIZ1QWAyl7m1aWBtYpar2uvFyEhZWG3sVhZYsA9dQNBfgzFSu60wus7hy4
D9FxYijaEnHZvPivrTwfcp8ittAvsIrM3xANcOhWXEU6eC6w0KX15QiiyPQUbssL
H3fPVUBxQlwicyY98Dvh7eJmnD1WEsMcDmDI5RqrAxhdD/bxbN0=
=b4+p
-----END PGP SIGNATURE-----

--6c2NcOVqGQ03X4Wi--
