Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E78705A48E
	for <lists+netdev@lfdr.de>; Fri, 28 Jun 2019 20:53:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726931AbfF1SxH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jun 2019 14:53:07 -0400
Received: from mga07.intel.com ([134.134.136.100]:56007 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726563AbfF1SxH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 28 Jun 2019 14:53:07 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 28 Jun 2019 11:53:06 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,428,1557212400"; 
   d="asc'?scan'208";a="314213610"
Received: from rarober1-mobl.amr.corp.intel.com ([10.251.157.137])
  by orsmga004.jf.intel.com with ESMTP; 28 Jun 2019 11:53:03 -0700
Message-ID: <fee5dd422d88806ee0b5a6b84f14cd6d50351343.camel@intel.com>
Subject: Re: [PATCH 24/39] docs: driver-model: move it to the driver-api book
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        Linus Walleij <linus.walleij@linaro.org>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Jean Delvare <jdelvare@suse.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Harry Wei <harryxiyou@gmail.com>,
        Alex Shi <alex.shi@linux.alibaba.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        David Kershner <david.kershner@unisys.com>,
        Julia Lawall <Julia.Lawall@lip6.fr>,
        Gilles Muller <Gilles.Muller@lip6.fr>,
        Nicolas Palix <nicolas.palix@imag.fr>,
        Michal Marek <michal.lkml@markovi.net>,
        linux-gpio@vger.kernel.org, linux-hwmon@vger.kernel.org,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        sparmaintainer@unisys.com, devel@driverdev.osuosl.org,
        cocci@systeme.lip6.fr
Date:   Fri, 28 Jun 2019 11:53:03 -0700
In-Reply-To: <920ff36c66233113b1825ab504fe675ed5a5bd7b.1561724493.git.mchehab+samsung@kernel.org>
References: <cover.1561724493.git.mchehab+samsung@kernel.org>
         <920ff36c66233113b1825ab504fe675ed5a5bd7b.1561724493.git.mchehab+samsung@kernel.org>
Content-Type: multipart/signed; micalg="pgp-sha512";
        protocol="application/pgp-signature"; boundary="=-K11StWmkFkExVL88vQz+"
User-Agent: Evolution 3.32.3 (3.32.3-1.fc30) 
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--=-K11StWmkFkExVL88vQz+
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2019-06-28 at 09:30 -0300, Mauro Carvalho Chehab wrote:
> The audience for the Kernel driver-model is clearly Kernel hackers.
>=20
> Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>

Acked-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>

For the 'ice' driver changes.

> ---
>  Documentation/{ =3D> driver-api}/driver-model/binding.rst       | 0
>  Documentation/{ =3D> driver-api}/driver-model/bus.rst           | 0
>  Documentation/{ =3D> driver-api}/driver-model/class.rst         | 0
>  .../{ =3D> driver-api}/driver-model/design-patterns.rst         | 0
>  Documentation/{ =3D> driver-api}/driver-model/device.rst        | 0
>  Documentation/{ =3D> driver-api}/driver-model/devres.rst        | 0
>  Documentation/{ =3D> driver-api}/driver-model/driver.rst        | 0
>  Documentation/{ =3D> driver-api}/driver-model/index.rst         | 2 --
>  Documentation/{ =3D> driver-api}/driver-model/overview.rst      | 0
>  Documentation/{ =3D> driver-api}/driver-model/platform.rst      | 0
>  Documentation/{ =3D> driver-api}/driver-model/porting.rst       | 2 +-
>  Documentation/driver-api/gpio/driver.rst                      | 2 +-
>  Documentation/driver-api/index.rst                            | 1 +
>  Documentation/eisa.txt                                        | 4 ++--
>  Documentation/filesystems/sysfs.txt                           | 2 +-
>  Documentation/hwmon/submitting-patches.rst                    | 2 +-
>  Documentation/translations/zh_CN/filesystems/sysfs.txt        | 2 +-
>  drivers/base/platform.c                                       | 2 +-
>  drivers/gpio/gpio-cs5535.c                                    | 2 +-
>  drivers/net/ethernet/intel/ice/ice_main.c                     | 2 +-
>  drivers/staging/unisys/Documentation/overview.txt             | 4 ++--
>  include/linux/device.h                                        | 2 +-
>  include/linux/platform_device.h                               | 2 +-
>  scripts/coccinelle/free/devm_free.cocci                       | 2 +-
>  24 files changed, 16 insertions(+), 17 deletions(-)
>  rename Documentation/{ =3D> driver-api}/driver-model/binding.rst (100%)
>  rename Documentation/{ =3D> driver-api}/driver-model/bus.rst (100%)
>  rename Documentation/{ =3D> driver-api}/driver-model/class.rst (100%)
>  rename Documentation/{ =3D> driver-api}/driver-model/design-patterns.rst
> (100%)
>  rename Documentation/{ =3D> driver-api}/driver-model/device.rst (100%)
>  rename Documentation/{ =3D> driver-api}/driver-model/devres.rst (100%)
>  rename Documentation/{ =3D> driver-api}/driver-model/driver.rst (100%)
>  rename Documentation/{ =3D> driver-api}/driver-model/index.rst (96%)
>  rename Documentation/{ =3D> driver-api}/driver-model/overview.rst (100%)
>  rename Documentation/{ =3D> driver-api}/driver-model/platform.rst (100%)
>  rename Documentation/{ =3D> driver-api}/driver-model/porting.rst (99%)


--=-K11StWmkFkExVL88vQz+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEiTyZWz+nnTrOJ1LZ5W/vlVpL7c4FAl0WYg8ACgkQ5W/vlVpL
7c71FA//aLp3imbzpY3ovZhJWfkCedgU23P55ANWPX+9LogGHwK/qtSXQlpOFKet
AKb3TrRqbgzziAdpNGCgC9phQ5qo56UwhI6PAf+WweUQV0Q1y5VX9Uvis12Zut4i
CiScVqBx3+Fgaj1KRXxoZKTmpdqsGCgQAr4BsqQUxYBWYk9al+iBz4YlqS2kQtyr
HClWQ4taQ6T6xaVHnCkIZA5NaSvOnaQClg33sPyvWTXrXbnlcBnJ3pXttlOKpXRA
ImO2jo16IYZFDpqCzlQpC1WjXz6vvFrHb2ukosXmYvNPBj33a//vD5PTvn6WUPkX
euZ5dRMaHjCY6XA9lZ5/KgHgckHO7TuzNzOP1VNCfit1lszA5M4p74nAFeL4XfYy
EKvosns0N5hrxl0M3VqtLfi4vqyC0S52SHeGzQ9Jugfi3Ey4f+RfGU1bqRlWu1SI
4g/JtpDavi2dT/jer5JSX55XMnSPpHEGl5I7M8osiMSqUx1wsnubuT4StxBu5U5y
MY11YSpOWwq1ufPph3M6Bd05gJxQxfY9mbQojyHl+gQm88PlF6tSvgKRyvFChfK1
eBb+uyphD9mFl06ZVtimDSW8C/X7uCylET5CPahyh6Cb/Z2QfRuh07V1t7Jr0nox
KZLcjeAWq2BLZnk+TBikfnYQZ+/29kyml3N+Dm/cP7JByhm53bo=
=wwuU
-----END PGP SIGNATURE-----

--=-K11StWmkFkExVL88vQz+--

