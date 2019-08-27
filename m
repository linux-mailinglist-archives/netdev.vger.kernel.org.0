Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CBD729F416
	for <lists+netdev@lfdr.de>; Tue, 27 Aug 2019 22:28:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731467AbfH0U15 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Aug 2019 16:27:57 -0400
Received: from mga02.intel.com ([134.134.136.20]:50575 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726871AbfH0U15 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 27 Aug 2019 16:27:57 -0400
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 27 Aug 2019 13:27:56 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,438,1559545200"; 
   d="asc'?scan'208";a="174685212"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by orsmga008.jf.intel.com with ESMTP; 27 Aug 2019 13:27:56 -0700
Message-ID: <3713e82a6f329df4674b279fdbeb49feb7e6a7ef.camel@intel.com>
Subject: Re: [PATCH] net: intel: Cleanup e1000 - add space between }}
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Reply-To: jeffrey.t.kirsher@intel.com
To:     Forrest Fleming <ffleming@gmail.com>, Joe Perches <joe@perches.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Tue, 27 Aug 2019 13:27:56 -0700
In-Reply-To: <CAE7kSDuHi3e_b0qyvXqocSVaNJrj3X7PPiawBWa68ZyrLSAZyA@mail.gmail.com>
References: <20190823191421.3318-1-ffleming@gmail.com>
         <c2279a78904b581924894b712403299903eacbfc.camel@intel.com>
         <877726fc009ee5ffde50e589d332db90c9695f06.camel@perches.com>
         <c40b4043424055fc4dae97771bb46c8ab15c6230.camel@intel.com>
         <b1ea77866e8736fa691cf4658a87ca2c1bf642d6.camel@perches.com>
         <CAE7kSDuHi3e_b0qyvXqocSVaNJrj3X7PPiawBWa68ZyrLSAZyA@mail.gmail.com>
Organization: Intel
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-tKIWyGIUEVgIXGAVIt0k"
User-Agent: Evolution 3.32.4 (3.32.4-1.fc30) 
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--=-tKIWyGIUEVgIXGAVIt0k
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2019-08-27 at 12:45 -0700, Forrest Fleming wrote:
> On Tue, Aug 27, 2019 at 12:07 PM Joe Perches <joe@perches.com> wrote:
> > On Tue, 2019-08-27 at 12:02 -0700, Jeff Kirsher wrote:
> > > On Mon, 2019-08-26 at 20:41 -0700, Joe Perches wrote:
> > > > On Mon, 2019-08-26 at 01:03 -0700, Jeff Kirsher wrote:
> > > > > On Fri, 2019-08-23 at 19:14 +0000, Forrest Fleming wrote:
> > > > > > suggested by checkpatch
> > > > > >=20
> > > > > > Signed-off-by: Forrest Fleming <ffleming@gmail.com>
> > > > > > ---
> > > > > >  .../net/ethernet/intel/e1000/e1000_param.c    | 28
> > > > > > +++++++++--
> > > > > > --------
> > > > > >  1 file changed, 14 insertions(+), 14 deletions(-)
> > > > >=20
> > > > > While I do not see an issue with this change, I wonder how
> > > > > important it is
> > > > > to make such a change.  Especially since most of the hardware
> > > > > supported by
> > > > > this driver is not available for testing.  In addition, this
> > > > > is one
> > > > > suggested change by checkpatch.pl that I personally do not
> > > > > agree
> > > > > with.
> > > >=20
> > > > I think checkpatch should allow consecutive }}.
> > >=20
> > > Agreed, have you already submitted a formal patch Joe with the
> > > suggested change below?
> >=20
> > No.
> >=20
> > >   If so, I will ACK it.
> >=20
> > Of course you can add an Acked-by:
> >=20
>=20
> Totally fair - I don't have strong feelings regarding the particular
> rule. I do
> feel strongly that we should avoid violating our rules as encoded by
> checkpatch,
> but I'm perfectly happy for the change to take the form of modifying
> checkpatch
> to allow a perfectly sensible (and readable) construct.
>=20
> I'm happy to withdraw this patch from consideration; I couldn't find
> anything
> about there being a formal procedure for so doing, so please let me
> know if
> there's anything more I need to do (or point me to the relevant
> docs).
>=20
> Thanks to everyone!

Nothing for you to do, I will drop the patch.

--=-tKIWyGIUEVgIXGAVIt0k
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEiTyZWz+nnTrOJ1LZ5W/vlVpL7c4FAl1lkkwACgkQ5W/vlVpL
7c55SQ//f2SxkdXNmAdM0JrA2pz5BmCM2IYesY6Ojy96yngPcvqum+AmDFwb5owY
hBEa8ZczB5ouFlX47NedltvtMwNb0zq5Shbpk6FdymBLnjj11uy32HuzBojpuVOA
AAy9qVjSPIf+sce7GIzEravYrIx5Gv+5E+RFgQsE4fl2cxUUZkiGSsvzauY+cAdq
dv3mKmIG72apgRdAHX6zGQVjCqJ/bH+EVdkIT015BAGaHnGY9yOv1umWtRVUZ6CP
7mU3vK+i96yM4szcZizh/aKIJ7mKjpSJtnWFsr8t+dEgZHpO64Jo+D6Wo1BT34vN
6GRYUEMi/hgvfHlZQrUe0QbXOFTtQ4BytLGD+zIISxeZ7hPybt9O17Bz2ETa1mt4
+EosUljssnYQrL6Z9YQ1GGzdzgG/mBZgDnNLk5AxsfXE3MNoc6URW7KCHAkPGhaD
f4DXDF1lDoe9KOYLovcrdrCZ1pAdX0hBDPfBCiJxgmyekkcItMlJ40o+jJ1UMpsX
KmScSliBJZ3ZTeaDKanCi3NvhLKiCPvxXlumSDmCYKY7NSP/X9Crk0Aqvu0FnlbX
2ov+ZF1IL9hGNPltstQhVwrNqpIh4mJypm1IemlR8D/Tc0kp0q1o+XPjDPKmPwwm
36mGRIfMACZhEAsyZYYarMjx6kVi86GV5udXzzSKcmOWC+03A60=
=G8tT
-----END PGP SIGNATURE-----

--=-tKIWyGIUEVgIXGAVIt0k--

