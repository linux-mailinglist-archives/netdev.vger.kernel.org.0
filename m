Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5F67A8F00E
	for <lists+netdev@lfdr.de>; Thu, 15 Aug 2019 18:04:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728348AbfHOQEZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Aug 2019 12:04:25 -0400
Received: from mga06.intel.com ([134.134.136.31]:14606 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726215AbfHOQEZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 15 Aug 2019 12:04:25 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 15 Aug 2019 09:01:31 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,389,1559545200"; 
   d="asc'?scan'208";a="179404699"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by orsmga003.jf.intel.com with ESMTP; 15 Aug 2019 09:01:30 -0700
Message-ID: <2feb81ee85228e38bb7abeeb3f14f04999190047.camel@intel.com>
Subject: Re: [PATCH net 1/2] igb: Enable media autosense for the i350.
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Reply-To: jeffrey.t.kirsher@intel.com
To:     Manfred Rudigier <manfred.rudigier@omicronenergy.com>,
        davem@davemloft.net
Cc:     carolyn.wyborny@intel.com, todd.fujinaka@intel.com,
        netdev@vger.kernel.org
Date:   Thu, 15 Aug 2019 09:01:30 -0700
In-Reply-To: <f50fd188-fe43-4bd7-aaa4-4c1c8cb022c3@EXC04-ATKLA.omicron.at>
References: <f50fd188-fe43-4bd7-aaa4-4c1c8cb022c3@EXC04-ATKLA.omicron.at>
Organization: Intel
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-8YxkGettdihYOc+MklJB"
User-Agent: Evolution 3.32.4 (3.32.4-1.fc30) 
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--=-8YxkGettdihYOc+MklJB
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2019-08-14 at 13:59 +0200, Manfred Rudigier wrote:
> This patch enables the hardware feature "Media Auto Sense" also on
> the
> i350. It works in the same way as on the 82850 devices. Hardware
> designs
> using dual PHYs (fiber/copper) can enable this feature by setting the
> MAS
> enable bits in the NVM_COMPAT register (0x03) in the EEPROM.
>=20
> Signed-off-by: Manfred Rudigier <manfred.rudigier@omicronenergy.com>
> ---
>  drivers/net/ethernet/intel/igb/e1000_82575.c | 2 +-
>  drivers/net/ethernet/intel/igb/igb_main.c    | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)

I will get this 2 patch series sent to intel-wired-lan@lists.osuosl.org
  list so that we can get these patches into review and test for
upstream inclusion.

--=-8YxkGettdihYOc+MklJB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEiTyZWz+nnTrOJ1LZ5W/vlVpL7c4FAl1VgdoACgkQ5W/vlVpL
7c5uyw//WReqEPjD8A8UyE0GH61NFZ/bs0nzxhAe2a5f7khyY+13dgOQDT0C9fpB
l78r6KcXxMNlCT5jrNhjUA5dNZR/fbG5BE56DSBGxjVR/1TCFFeshz3hNQcnWCDy
12RQgD40fsg9KFe3PTQbRNg2ykmptIGgJuDKMOZmaqyDusRTngBGZRftIqgBxwjF
ahtDmXKMe9piZAGShq3LBe+6/LrXHhBog2cKRi/cZFg6Msy5nkXbodPkDryUXhzx
0WJ2h3dy5v6qtTOlSRfZ6kiI8JBV0OhM6XQH64+Pb5l/AFHDT9/MFfihsQ9W/Eyw
qdFCXpHtn/q3HtBjBBFtFAexkFBNiwOtVG9bWcUpMk3GE7+A9445jLeOemDj90pN
N/b9UhTjVz+jwuY3aSjOFG5Ki2klB0TR3S20niYrD3olooirAYJtdjtUPxbmC797
tsbZN+KtfrQRtvFQwiZHvnj3ZVqhL8NGMjcc2C9OsNSwqIY9MisCUBhdHxkKgGx7
CnyDVidNNnDSbnSx0qoL2jTLcoXzFbHsBYHzhNyovWkLA0b0tXFEEcfsUlM4l/aU
IEZOesDqmdzl8f2YS7iqb+Iy63LJbyDw4YozUvzGrvr75yQnw51Fg15580CToqpu
HdVsDfSPN1xG0mzhpUblT7oz4gvayzAjYGMs9XkCvLxvyvEsQ8o=
=bWKP
-----END PGP SIGNATURE-----

--=-8YxkGettdihYOc+MklJB--

