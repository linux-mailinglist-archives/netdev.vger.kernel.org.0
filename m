Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 91DFC118FEB
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 19:41:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727685AbfLJSl5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 13:41:57 -0500
Received: from mga07.intel.com ([134.134.136.100]:59253 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727558AbfLJSl4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Dec 2019 13:41:56 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 10 Dec 2019 10:41:56 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,300,1571727600"; 
   d="asc'?scan'208";a="295979067"
Received: from dssnyder-mobl.amr.corp.intel.com ([10.254.45.55])
  by orsmga001.jf.intel.com with ESMTP; 10 Dec 2019 10:41:55 -0800
Message-ID: <a13f11a31d5cafcc002d5e5ca73fe4a8e3744fb5.camel@intel.com>
Subject: Re: [net-next v3 00/20][pull request] Intel Wired LAN Driver
 Updates 2019-12-09
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     Jason Gunthorpe <jgg@ziepe.ca>
Cc:     davem@davemloft.net, gregkh@linuxfoundation.org,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com, parav@mellanox.com
Date:   Tue, 10 Dec 2019 10:41:54 -0800
In-Reply-To: <20191210182543.GE46@ziepe.ca>
References: <20191209224935.1780117-1-jeffrey.t.kirsher@intel.com>
         <20191210172233.GA46@ziepe.ca>
         <324a6a4c7553cea5225b6f94ff224e155a252b36.camel@intel.com>
         <20191210182543.GE46@ziepe.ca>
Content-Type: multipart/signed; micalg="pgp-sha512";
        protocol="application/pgp-signature"; boundary="=-HSwg+Zlqy5W7tiJz9t8+"
User-Agent: Evolution 3.34.2 (3.34.2-1.fc31) 
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--=-HSwg+Zlqy5W7tiJz9t8+
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2019-12-10 at 14:25 -0400, Jason Gunthorpe wrote:
> On Tue, Dec 10, 2019 at 10:06:41AM -0800, Jeff Kirsher wrote:
> > > Please don't send new RDMA drivers in pull requests to net. This
> > > driver is completely unreviewed at this point.
> >=20
> > This was done because you requested a for a single pull request in an
> > earlier submission 9 months ago.  I am fine with breaking up
> > submission,
> > even though the RDMA driver would be dependent upon the virtual bus and
> > LAN
> > driver changes.
>=20
> If I said that I ment a single pull request *to RDMA* with Dave's acks
> on the net side, not a single pull request to net.
>=20
> Given the growth of the net side changes this may be better to use a
> shared branch methodology.

I am open to any suggestions you have on submitting these changes that has
the least amount of thrash for all the maintainers involved.

My concerns for submitting the network driver changes to the RDMA tree is
that it will cause David Miller a headache when taking additional LAN
driver changes that would be affected by the changes that were taken into
the RDMA tree.

We can hash this out later if need be, since it is clear there are changes
needed to the current series.

--=-HSwg+Zlqy5W7tiJz9t8+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEiTyZWz+nnTrOJ1LZ5W/vlVpL7c4FAl3v5vMACgkQ5W/vlVpL
7c6e/g/+IWJeyX2UD5AZsIZMxWYAd1qXHqCAc99mn2zhqgcW3SzjbSHWBPjfvi58
yHWb3irl+L7TFd4RuJYPfOlV6Z1DJ195HcULw0yX4s7wSRi30Xfn9eZPdkuejDHX
5mNAvqdMwPrtYQ2FpPx3v/oGL//WhSZCxfeCXybNFV/H0uDskcEAF+Ifu825cQmD
Hv41XV3Gnm/jk38FrksSe1lt7PQZippveheMTG7tIB08Eeh0mKo8+octZD/e3FsP
9U67u909D+KuFapCNfch/ojIk31dAj9gBKbIryQkEYgVZz+O//Hf75XWQoGdxpdj
8Ppf8fe8zeyjezWna+hM/8swX5x9qL4Dw93vtOsUjs8+c/DwkaNOJZpfSXufn7c0
XEEbhA0Nga2GVX0CbvT51jlliQn9ZwJg3XCZmXzYiGXBfW08tVuuic0Y/Gdx8FsQ
yEVeXfENjjbeJhK9EPfbFQ49lP4YEeaHgMX+aDa3LCHdfGZ4LwpqLhrn0AnMyNO5
fo8SFI6z+tZM5v0maMpnPCWLjlZQf04WCVboRKSLQqQ+lRsW1a/P6hXNDRByH30U
h47/0k8tugrUDACfRTuo4wjZz0UYeA+HpMO328jd2FNRn5ujfjmbOlaAfQ7Q8iLb
CEp4Zja2xXwaFMPmdcEQ7KPFhh8QYGNNawz//o0vKR/aBaWofaM=
=bCA3
-----END PGP SIGNATURE-----

--=-HSwg+Zlqy5W7tiJz9t8+--

