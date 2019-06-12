Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 54E67430F0
	for <lists+netdev@lfdr.de>; Wed, 12 Jun 2019 22:21:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388346AbfFLUVl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jun 2019 16:21:41 -0400
Received: from mga04.intel.com ([192.55.52.120]:3337 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727924AbfFLUVk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 12 Jun 2019 16:21:40 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 12 Jun 2019 13:21:39 -0700
X-ExtLoop1: 1
Received: from lcarlos-mobl.amr.corp.intel.com ([10.252.140.234])
  by orsmga007.jf.intel.com with ESMTP; 12 Jun 2019 13:21:39 -0700
Message-ID: <5e818fb4bf253fc69259093e7ff68122e4a4044c.camel@intel.com>
Subject: Re: [PATCH v1 09/31] docs: driver-model: convert docs to ReST and
 rename to *.rst
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        Linus Walleij <linus.walleij@linaro.org>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Jean Delvare <jdelvare@suse.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Julia Lawall <Julia.Lawall@lip6.fr>,
        Gilles Muller <Gilles.Muller@lip6.fr>,
        Nicolas Palix <nicolas.palix@imag.fr>,
        Michal Marek <michal.lkml@markovi.net>,
        linux-gpio@vger.kernel.org, linux-hwmon@vger.kernel.org,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        cocci@systeme.lip6.fr
Date:   Wed, 12 Jun 2019 13:21:38 -0700
In-Reply-To: <c90bb60d65aaba4ce5957894cc6890ebe5048d95.1560364494.git.mchehab+samsung@kernel.org>
References: <cover.1560364493.git.mchehab+samsung@kernel.org>
         <c90bb60d65aaba4ce5957894cc6890ebe5048d95.1560364494.git.mchehab+samsung@kernel.org>
Content-Type: multipart/signed; micalg="pgp-sha512";
        protocol="application/pgp-signature"; boundary="=-ty+pfSLvRBl9i77r2BhF"
User-Agent: Evolution 3.32.2 (3.32.2-1.fc30) 
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--=-ty+pfSLvRBl9i77r2BhF
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2019-06-12 at 15:38 -0300, Mauro Carvalho Chehab wrote:
> Convert the various documents at the driver-model, preparing
> them to be part of the driver-api book.
>=20
> The conversion is actually:
>   - add blank lines and identation in order to identify paragraphs;
>   - fix tables markups;
>   - add some lists markups;
>   - mark literal blocks;
>   - adjust title markups.
>=20
> At its new index.rst, let's add a :orphan: while this is not linked to
> the main index.rst file, in order to avoid build warnings.
>=20
> Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>

Acked-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>

For the ice driver comment change.

> ---
>  Documentation/driver-api/gpio/driver.rst      |   2 +-
>  .../driver-model/{binding.txt =3D> binding.rst} |  20 +-
>  .../driver-model/{bus.txt =3D> bus.rst}         |  69 ++--
>  .../driver-model/{class.txt =3D> class.rst}     |  74 ++--
>  ...esign-patterns.txt =3D> design-patterns.rst} | 106 +++---
>  .../driver-model/{device.txt =3D> device.rst}   |  57 +--
>  .../driver-model/{devres.txt =3D> devres.rst}   |  50 +--
>  .../driver-model/{driver.txt =3D> driver.rst}   | 112 +++---
>  Documentation/driver-model/index.rst          |  26 ++
>  .../{overview.txt =3D> overview.rst}            |  37 +-
>  .../{platform.txt =3D> platform.rst}            |  30 +-
>  .../driver-model/{porting.txt =3D> porting.rst} | 333 +++++++++---------
>  Documentation/eisa.txt                        |   4 +-
>  Documentation/hwmon/submitting-patches.rst    |   2 +-
>  drivers/base/platform.c                       |   2 +-
>  drivers/gpio/gpio-cs5535.c                    |   2 +-
>  drivers/net/ethernet/intel/ice/ice_main.c     |   2 +-
>  scripts/coccinelle/free/devm_free.cocci       |   2 +-
>  18 files changed, 489 insertions(+), 441 deletions(-)
>  rename Documentation/driver-model/{binding.txt =3D> binding.rst} (92%)
>  rename Documentation/driver-model/{bus.txt =3D> bus.rst} (76%)
>  rename Documentation/driver-model/{class.txt =3D> class.rst} (75%)
>  rename Documentation/driver-model/{design-patterns.txt =3D> design-
> patterns.rst} (59%)
>  rename Documentation/driver-model/{device.txt =3D> device.rst} (71%)
>  rename Documentation/driver-model/{devres.txt =3D> devres.rst} (93%)
>  rename Documentation/driver-model/{driver.txt =3D> driver.rst} (75%)
>  create mode 100644 Documentation/driver-model/index.rst
>  rename Documentation/driver-model/{overview.txt =3D> overview.rst} (90%)
>  rename Documentation/driver-model/{platform.txt =3D> platform.rst} (95%)
>  rename Documentation/driver-model/{porting.txt =3D> porting.rst} (62%)


--=-ty+pfSLvRBl9i77r2BhF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEiTyZWz+nnTrOJ1LZ5W/vlVpL7c4FAl0BXtIACgkQ5W/vlVpL
7c4pqBAAjI5ICv0jNPfnf/dx8MCYTQgnqe5o0zbkpxSHIeNyftE7ga/fAa4J66pK
yJP9+EJIO8IGMCFSZxybwq9AxxQOK2fzpm2zrm3AGZ3MFesW3u/zxqGzp88XgqBY
uaqSUJIuYPlDkVay8iLBiUKm5StnPJ25soquD3pRqHCStCU5HPM7ML9AFbK4UgSA
OMbmXcdKoJubrdWd/CPIgMdGwRBzHl0L072QPnapJLJBNfn8OwkeoO67N7mCvitG
o/I05rRyNIeunWTmiqmwVe6j+DQ8QzKPvXSKGGBM3Dl7QxP+fcV9jXkVulrjlpa6
HDOQMLdRX6T5+6JPGHDTnY5PfWXf/hsMIF+szh+iI9+ZaetLbA/OQYm12foIxcbr
2qu1iOn6RrRS4COcCFq6oTUEXRBBrlTI9iPVImuRF2Jt2+g/dQvfwK9U4XWCd0vG
s0BFVM5A4CGFCBMGI6jYrSm+Q8Z3IpvMC/l7CmzZW5YPhplS8mPud5eqllLmFfr/
8y0YyBAxXFpm9ajncxSc6m3TyBAmSevKYdvoL31TfZKLDN+W6ZyM47U1z1baDJBu
3RBxzmVNXxu+DScqKTxYKsW5UY06Grs3HuDWGthqSztzc2+H6gK7s7YfT2S2diKe
4vi2AzHXn4ghgp0OW4Kcg1YC5aeP7xdjVYDhaIeLEaaYaB6IiGw=
=Uy44
-----END PGP SIGNATURE-----

--=-ty+pfSLvRBl9i77r2BhF--

