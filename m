Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0BCA3B148B
	for <lists+netdev@lfdr.de>; Thu, 12 Sep 2019 20:47:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727367AbfILSrs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Sep 2019 14:47:48 -0400
Received: from mga04.intel.com ([192.55.52.120]:7039 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726748AbfILSrs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 12 Sep 2019 14:47:48 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 12 Sep 2019 11:47:47 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,492,1559545200"; 
   d="asc'?scan'208";a="190076321"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by orsmga006.jf.intel.com with ESMTP; 12 Sep 2019 11:47:46 -0700
Message-ID: <1d831c0ee1800a972c177cc15720f43ed1a6703d.camel@intel.com>
Subject: Re: [PATCH] ixgbe: Fix secpath usage for IPsec TX offload.
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Reply-To: jeffrey.t.kirsher@intel.com
To:     Jonathan Tooker <jonathan@reliablehosting.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        intel-wired-lan@lists.osuosl.org
Cc:     Michael Marley <michael@michaelmarley.com>,
        Shannon Nelson <snelson@pensando.io>, netdev@vger.kernel.org
Date:   Thu, 12 Sep 2019 11:47:46 -0700
In-Reply-To: <9d94bd04-c6fa-d275-97bc-5d589304f038@reliablehosting.com>
References: <20190912110144.GS2879@gauss3.secunet.de>
         <9d94bd04-c6fa-d275-97bc-5d589304f038@reliablehosting.com>
Organization: Intel
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-PVY+GfDYV+4zQNHz3hBy"
User-Agent: Evolution 3.32.4 (3.32.4-1.fc30) 
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--=-PVY+GfDYV+4zQNHz3hBy
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2019-09-12 at 11:33 -0500, Jonathan Tooker wrote:
> On 9/12/2019 6:01 AM, Steffen Klassert wrote:
> > The ixgbe driver currently does IPsec TX offloading
> > based on an existing secpath. However, the secpath
> > can also come from the RX side, in this case it is
> > misinterpreted for TX offload and the packets are
> > dropped with a "bad sa_idx" error. Fix this by using
> > the xfrm_offload() function to test for TX offload.
> >=20
> Does this patch also need to be ported to the ixgbevf driver? I can=20
> replicate the bad sa_idx error using a VM that's using a VF & the=20
> ixgebvf  driver.
>=20

I am putting together a patch for ixgbevf right now.

--=-PVY+GfDYV+4zQNHz3hBy
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEiTyZWz+nnTrOJ1LZ5W/vlVpL7c4FAl16ktIACgkQ5W/vlVpL
7c49Rg/+LR4SKXAcAuyAVRSSF8I1PYvA5gKeeczoLXzOGmG4Z+8w4zL+zvQ8iWfZ
HoCyICZjmlwMRowvAf6T8lCOh3GxMZlRP/zLrEkbymuf8dv+n3pCBh2LdwkfRkmK
wIJTpyq2U826HK2vlMkFmt0xcFadNXYmM2jkFpZR6XTywQF6gOwEixn40qTHeaf4
nMIRroQ3U9e/2TfNfWnW+Y8bf03kXMSOKl0dlX0NMaP8xLqQ9zhRVD+21ABDFIUo
GCYtbwckSIgbGBBDG+9X2uvayfuBaUK4/kmbFmQd8s/wmj2X6CQNrIpdApJODLN5
TdosA2s2ZBC0LokSnjshljObnG4fwzpa8xOdvLSmwRAxsQFJ7EC5dem9eIECyX5w
svW0H9NGXrSakIK92ugTf7WXmN8zTDWH34KdcfIGIBL8vD8JFgAQu7F+3dz/Xzj7
9iiYOgDFKx+3KJI+vo2vcWguO/LPnPv1Z0jGroig/nRgwXyVSH3mB0+IDOvOXaAW
nM2BDdvUhRBpnZqOlXZzy6VANBJmcVU6WiQn6MVW+c+9ylBlVkYhE3Fp6YcZFtRR
eQdALIEgt7voSTMk+FJ5Ml28bsiPiAJt8fJLCBe+AC/xblY+yzGZE1WaDao7pCH3
wvKImJR8ov8Bgd6goh34PUUeANxc7tdslazcCFjCdserp9GdQvA=
=OYZ5
-----END PGP SIGNATURE-----

--=-PVY+GfDYV+4zQNHz3hBy--

