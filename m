Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A7CF2EB757
	for <lists+netdev@lfdr.de>; Thu, 31 Oct 2019 19:40:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729304AbfJaSkR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Oct 2019 14:40:17 -0400
Received: from mga01.intel.com ([192.55.52.88]:31403 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729212AbfJaSkR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 31 Oct 2019 14:40:17 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 31 Oct 2019 11:40:16 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,252,1569308400"; 
   d="asc'?scan'208";a="351726904"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by orsmga004.jf.intel.com with ESMTP; 31 Oct 2019 11:40:15 -0700
Message-ID: <d092e42a96eb88640963a733b3b89e7c34c95c02.camel@intel.com>
Subject: Re: linux-next: Signed-off-by missing for commit in the net-next
 tree
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Reply-To: jeffrey.t.kirsher@intel.com
To:     David Miller <davem@davemloft.net>, sfr@canb.auug.org.au
Cc:     netdev@vger.kernel.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Thu, 31 Oct 2019 11:40:15 -0700
In-Reply-To: <20191031.104036.906328689737801166.davem@davemloft.net>
References: <20191031181044.0f96b16d@canb.auug.org.au>
         <20191031.104036.906328689737801166.davem@davemloft.net>
Organization: Intel
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-2Xo61JjhqjX4c4u1196P"
User-Agent: Evolution 3.32.4 (3.32.4-1.fc30) 
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--=-2Xo61JjhqjX4c4u1196P
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2019-10-31 at 10:40 -0700, David Miller wrote:
> From: Stephen Rothwell <sfr@canb.auug.org.au>
> Date: Thu, 31 Oct 2019 18:10:44 +1100
>=20
> > Commit
> >=20
> >    a7023819404a ("e1000e: Use rtnl_lock to prevent race conditions
> > between net and pci/pm")
> >=20
> > is missing a Signed-off-by from its committer.
>=20
> Ok Jeff, that's two pull requests I've taken from you this week where
> there were incorrect SHA1 IDs in Fixes tags or missing signoffs.
>=20
> Please use some scripts or other forms of automation to keep this
> from
> happening in the future.

Not sure what is going on to remove my SOB, since everything is
scripted, but I will look into it and I will add an additional check to
ensure future pull requests are not missing anything.  I apologize for
the missing SOB's.

--=-2Xo61JjhqjX4c4u1196P
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEiTyZWz+nnTrOJ1LZ5W/vlVpL7c4FAl27Ko8ACgkQ5W/vlVpL
7c4sWw//VwXUcFZglSZJwskM8AUS4ym0Lx9P2cp+P0nu2hCyAdBq+0TmUmKfk8Xy
dZF/xO0Uyemucj1carJ8e8XI0vB+ydeCFx5Dy5piwlW3mXv2j0cO0WaQJThueyr6
AHE0Qo+GkP/b9S2HMxvqOaUlwpeuvr7jnHws3OCbOfX+HaXVgNKMgLzX+MSsvF+g
Fz7Jjz30oDF5RTn+Jl9hH07l2zmjrfByEZDVvXIi+m0YbpsfRcuX7u08WSFPQ/BT
FWGEMG3zIQ/wnAlrnXHAs2BKI9W6b2EGuyzYxas8IpgiUSoDNFyDn7PdHT5n+cp8
cGxmvHhjOYRomUo5aS9nkmoSzIrlTPmpFEdcVGGjSpYdMLG6t08HXmXLgAp30fAJ
vS1WWIcFrD3LU0eyYFskBSKhxkLlrIEMJRwDS58AFMOXo13PIBUJylGBGXYS/qIQ
a+7tvwm3mtA3tfHRf+i+aoKQxOPBEFBVg2OhJYDOvyy1PkSoKzhst1cKLSNYrApe
gfdhi+A5dk3Dl6OfmFJ1cYkc4qfMWRt4I6Tu3wgWsEcAYMW3D06ANZmq7GHwsJee
ecAtZVuiBM4bmmxTyBDXpyt2lU93d0eU8tCD3zSLWI75uLb2hD5h8Zmho5Jdw2Me
Js6mXgD+mAdQsII+cRBQjaZYYp9CmHetBsZe98ViPu1wMMojtyc=
=Q3ho
-----END PGP SIGNATURE-----

--=-2Xo61JjhqjX4c4u1196P--

