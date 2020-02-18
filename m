Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1DAEC163579
	for <lists+netdev@lfdr.de>; Tue, 18 Feb 2020 22:50:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728000AbgBRVuA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Feb 2020 16:50:00 -0500
Received: from mga09.intel.com ([134.134.136.24]:18503 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726617AbgBRVuA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 18 Feb 2020 16:50:00 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 18 Feb 2020 13:49:59 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,458,1574150400"; 
   d="asc'?scan'208";a="434250424"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.76])
  by fmsmga005.fm.intel.com with ESMTP; 18 Feb 2020 13:49:59 -0800
Message-ID: <3f966849ef8a21343d5a96b1ef89b7ad00b65b80.camel@intel.com>
Subject: Re: [PATCH net-next v2 06/13] e1000(e): use new helper
 tcp_v6_gso_csum_prep
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Reply-To: jeffrey.t.kirsher@intel.com
To:     Heiner Kallweit <hkallweit1@gmail.com>,
        David Miller <davem@davemloft.net>,
        Alexander Duyck <alexander.h.duyck@linux.intel.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        intel-wired-lan <intel-wired-lan@lists.osuosl.org>
Date:   Tue, 18 Feb 2020 13:49:58 -0800
In-Reply-To: <47621909-1b75-e8d1-cf32-857c1601e0af@gmail.com>
References: <fffc8b6d-68ed-7501-18f1-94cf548821fb@gmail.com>
         <47621909-1b75-e8d1-cf32-857c1601e0af@gmail.com>
Organization: Intel
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-796u9qmPm7ptgG3w0PuR"
User-Agent: Evolution 3.34.3 (3.34.3-1.fc31) 
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--=-796u9qmPm7ptgG3w0PuR
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2020-02-18 at 21:05 +0100, Heiner Kallweit wrote:
> Use new helper tcp_v6_gso_csum_prep in additional network drivers.
>=20
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
> Reviewed-by: Alexander Duyck <alexander.h.duyck@linux.intel.com>

Acked-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>

> ---
>  drivers/net/ethernet/intel/e1000/e1000_main.c | 6 +-----
>  drivers/net/ethernet/intel/e1000e/netdev.c    | 5 +----
>  2 files changed, 2 insertions(+), 9 deletions(-)


--=-796u9qmPm7ptgG3w0PuR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEiTyZWz+nnTrOJ1LZ5W/vlVpL7c4FAl5MXAYACgkQ5W/vlVpL
7c7JJRAAja7gTuoCY8nLUTo/e7RixJCcGoY9h5CIHHGwnH2rgCX+uVtSwaLhprto
4w+ku8RVydlnA9dACtEMljTnC2jiC6Wdh13M9cvLO7BFTcvqTG06BjrRCKB8UQC8
fJRoC+JkNVNJ8Z4VQ7x6TRNTTZaHfzAVn5rqlmxZ67BWNeq9bsLgn4CBirXiR7BB
5rgc0/jUvFV6k1G9RTUfqecvjpkX2siOzL8OQAK5VK3B/FzqhcWjUhJGlzoNVAp2
3DA0h+mVkA6xfsjJFb6TC+Hbf0XyScSVUdh3mgwbNxDcqeHUlIk4hvoJMD4I83Uy
AMxzCXMeC9cRczdIlwqcB+5iyE02J/GtMxzeZTE2Tj2IYEMI0mo4jktWDMqY+TPD
2CJ8UyQP2jF7xZjDv8yNhZFPUiKOU4g+WQrnLqZ3cBCjE4qEJk3iTGRlaMrbnA3g
rIK+CDTeJ2FGmhj0f8kqRW+wAiaUD3b0AWHEhh5WlaxbK7116JGIQ67gWQ0mOnQX
8Gu6PlzVjgdf0ZYlc0DtuzeBdXI5qDMxmDMme2kASAhTVvcJOhKXUxPQ0ii7aEdo
KTUQtgRDegW31wH6gOnsZBOUZ2xIYgC8Co4Vrss84U2axHBHT8JXcDd1oHSIyKgt
tQBuSQ8iHDLHiyIInbLgc1yGmWShwOMupIJKLYw3qpsSwbdxF+M=
=bwIq
-----END PGP SIGNATURE-----

--=-796u9qmPm7ptgG3w0PuR--

