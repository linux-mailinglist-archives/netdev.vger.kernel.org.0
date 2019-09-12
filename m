Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EF374B127D
	for <lists+netdev@lfdr.de>; Thu, 12 Sep 2019 17:57:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732739AbfILP5q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Sep 2019 11:57:46 -0400
Received: from mga03.intel.com ([134.134.136.65]:25148 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725995AbfILP5q (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 12 Sep 2019 11:57:46 -0400
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 12 Sep 2019 08:57:45 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,497,1559545200"; 
   d="asc'?scan'208";a="215087372"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by fmsmga002.fm.intel.com with ESMTP; 12 Sep 2019 08:57:44 -0700
Message-ID: <2783711bae4ed87e2210894bcd980f8a3f052e94.camel@intel.com>
Subject: Re: [PATCH] ixgbe: Fix secpath usage for IPsec TX offload.
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Reply-To: jeffrey.t.kirsher@intel.com
To:     David Miller <davem@davemloft.net>, steffen.klassert@secunet.com
Cc:     intel-wired-lan@lists.osuosl.org, michael@michaelmarley.com,
        snelson@pensando.io, netdev@vger.kernel.org
Date:   Thu, 12 Sep 2019 08:57:44 -0700
In-Reply-To: <20190912.134359.345289288863944180.davem@davemloft.net>
References: <20190912110144.GS2879@gauss3.secunet.de>
         <20190912.134359.345289288863944180.davem@davemloft.net>
Organization: Intel
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-dLlFNIhBGHJp3KGXhmHo"
User-Agent: Evolution 3.32.4 (3.32.4-1.fc30) 
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--=-dLlFNIhBGHJp3KGXhmHo
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2019-09-12 at 13:43 +0200, David Miller wrote:
> From: Steffen Klassert <steffen.klassert@secunet.com>
> Date: Thu, 12 Sep 2019 13:01:44 +0200
>=20
> > The ixgbe driver currently does IPsec TX offloading
> > based on an existing secpath. However, the secpath
> > can also come from the RX side, in this case it is
> > misinterpreted for TX offload and the packets are
> > dropped with a "bad sa_idx" error. Fix this by using
> > the xfrm_offload() function to test for TX offload.
> >=20
> > Fixes: 592594704761 ("ixgbe: process the Tx ipsec offload")
> > Reported-by: Michael Marley <michael@michaelmarley.com>
> > Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
>=20
> I'll apply this directly and queue it up for -stable, thanks.

Thanks Dave!

--=-dLlFNIhBGHJp3KGXhmHo
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEiTyZWz+nnTrOJ1LZ5W/vlVpL7c4FAl16avgACgkQ5W/vlVpL
7c4+cg/+OLKEQa8bM0fQ8aiONJonrbUpkWedbvsxBlJuSneMuHM2ilv0kb2God07
PLdb8W+5GMZCfSDOA7OAYp9EqrWsfamsknqPt6Dva/BhpHU0n7/cfDiC/XIU+JAh
ZvLOargYmTSgDJ8HSSFzVoVFynz4liACyRaclp3Sb77bff4jNUwd48W/5q0b0PBm
H0eJnxreGKwc0ClppVsQqj+zjWjaFlzb+Iuj+ciiHx9tpipzQ+6lQHVvwWahAOtE
i01MvW/MsekbtgJ0PX5gaQnIrsJ3agVl24VFup+smFcZqUSSKwez4JcygrdRkNOR
hg9LksThjD7muk2HfQVis+PTocN9PVeOQpVrthr497KpiXMLUJ3OMJZ55t51CBr/
IjEmUkfnC+cSXwFr/1Qdo5YMG2AoplZp+TUFccV+ZF52DcxN7oUgAL2eu4hcOnld
IY6mhe/9HGv+bKdV+Vh5Rdrt9yGUnRtE/HddjFlChHhLcjpcxSjM2G4ASjVCifme
oVejEcsig6oD23b5xXdDuKSzbg9OlhAKHHpyrWHYCmsPtezi3qes2t9+xfhWoL7T
eS+zK256lZ41oKGvhXNduN838dExLXw7b6ED/Q+Umsk079alibZ0jEfo9QdijXya
nBHo/XjnBPCLuViuRbHcqHpJ9AA5Jo/rSYrrkfKfB218az4wIfQ=
=1KTM
-----END PGP SIGNATURE-----

--=-dLlFNIhBGHJp3KGXhmHo--

