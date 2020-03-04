Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0C1B21798C0
	for <lists+netdev@lfdr.de>; Wed,  4 Mar 2020 20:16:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728278AbgCDTQz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Mar 2020 14:16:55 -0500
Received: from mga09.intel.com ([134.134.136.24]:17264 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726440AbgCDTQy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Mar 2020 14:16:54 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 04 Mar 2020 11:16:53 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,514,1574150400"; 
   d="asc'?scan'208";a="387258262"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by orsmga004.jf.intel.com with ESMTP; 04 Mar 2020 11:16:53 -0800
Message-ID: <6ae80c13890cb71f6e079393173b08c5b4bd9917.camel@intel.com>
Subject: Re: [PATCH net 0/1] e1000e: Stop tx/rx setup spinning for upwards
 of 300us.
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Reply-To: jeffrey.t.kirsher@intel.com
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     David Laight <David.Laight@ACULAB.COM>,
        Network Development <netdev@vger.kernel.org>,
        intel-wired-lan <intel-wired-lan@lists.osuosl.org>,
        "'bruce.w.allan@intel.com'" <bruce.w.allan@intel.com>,
        "'jeffrey.e.pieper@intel.com'" <jeffrey.e.pieper@intel.com>
Date:   Wed, 04 Mar 2020 11:16:53 -0800
In-Reply-To: <20200304111008.2c85f386@kicinski-fedora-PC1C0HJN>
References: <9e23756531794a5e8b3d7aa6e0a6e8b6@AcuMS.aculab.com>
         <32fd09495d86bb2800def5b19e782a6a91a74ed9.camel@intel.com>
         <20200304111008.2c85f386@kicinski-fedora-PC1C0HJN>
Organization: Intel
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-wq+fY5fqMTH9QTFXP/PF"
User-Agent: Evolution 3.34.4 (3.34.4-1.fc31) 
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--=-wq+fY5fqMTH9QTFXP/PF
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2020-03-04 at 11:10 -0800, Jakub Kicinski wrote:
> On Wed, 04 Mar 2020 10:02:08 -0800 Jeff Kirsher wrote:
> > Adding the intel-wired-lan@lists.osuosl.org mailing list, so that
> > the
> > developers you want feedback from will actually see your
> > patches/questions/comments.
>=20
> Is that list still moderated? I was going to CC it yesterday but=20
> I don't want to subject people who respond to moderation messages..

Yes, this is still moderated, helps keep the crap email out of peoples
inbox.

--=-wq+fY5fqMTH9QTFXP/PF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEiTyZWz+nnTrOJ1LZ5W/vlVpL7c4FAl5f/qUACgkQ5W/vlVpL
7c4/2A/9Hh2qTBx4p0PDED97hNsz7hNuhJMjIkQqTCViICTxSsw4O6NTpLwOWcOD
KqsxJZACSMsFdGZsJAmitg/ungAFpnC/hBHIArbI4XCqnf3tVJqgvfuI/klwrNe4
JSArked3Ifw31ICONW8uaNJs4C3OVD5VQR8h/FDE+HP1kJHo5jeIzDEOlKtONhum
NEhLLxYCc2ZOEKnxa21ryZSQrMcZgVlKAOgIebcQxZ2tnISxHIsYl6Ka5MNuDxDZ
ERyvzEGNMjGz0DzZKgIcKvxGJ/FA6iiXW/cFOkUzlN1qqBktiftA+rW1lQGAMmWi
qWaKXyaPFJ9QmJdHWPbcRUBAkTRvytrC+HKnwevSdRpPLt/1WoROWPRhzn8oK8lR
YQMw+tg+pSpXMBspEvm36OkDh3Rw/y0VN45KspkGbJCVae/EIRUmkdz2aSZCanEB
pmSEr4y8sij3k3kDluo1WSxxnRmiSuxRVb4F9rA//w4BlKAbj5wy9FeuW3gOoKBt
TvAnHjXXhfu9cjZgUvCkNGLwRr5GkXIbl2fk+WnjkHB7p09o9DrkUcD0/pRf4gDH
7F5aDzJKozzGBEhYHniKZVoK+IRfzMr75b7p3KGBtvuwu2q9zTJnuzQI1jnm6e3V
eHPNYZgn8bdvzbbDmVnL1mn0ULjWpy/ky2Oj+hnFjqjPURDa2Gk=
=VEjK
-----END PGP SIGNATURE-----

--=-wq+fY5fqMTH9QTFXP/PF--

