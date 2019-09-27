Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2CECEC0C87
	for <lists+netdev@lfdr.de>; Fri, 27 Sep 2019 22:17:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727273AbfI0URT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Sep 2019 16:17:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57646 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725815AbfI0URT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 27 Sep 2019 16:17:19 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id E07E13090FD4;
        Fri, 27 Sep 2019 20:17:18 +0000 (UTC)
Received: from linux-ws.nc.xsintricity.com (ovpn-112-20.rdu2.redhat.com [10.10.112.20])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 9CA7510013A7;
        Fri, 27 Sep 2019 20:17:17 +0000 (UTC)
Message-ID: <bc18503dcace47150d5f45e8669d7978e18a38f9.camel@redhat.com>
Subject: Re: [RFC 20/20] RDMA/i40iw: Mark i40iw as deprecated
From:   Doug Ledford <dledford@redhat.com>
To:     "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "Saleem, Shiraz" <shiraz.saleem@intel.com>
Cc:     Leon Romanovsky <leon@kernel.org>,
        "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        "jgg@mellanox.com" <jgg@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
Date:   Fri, 27 Sep 2019 16:17:15 -0400
In-Reply-To: <20190926195517.GA1743170@kroah.com>
References: <20190926164519.10471-1-jeffrey.t.kirsher@intel.com>
         <20190926164519.10471-21-jeffrey.t.kirsher@intel.com>
         <20190926174009.GD14368@unreal>
         <9DD61F30A802C4429A01CA4200E302A7AC702BDA@fmsmsx123.amr.corp.intel.com>
         <20190926195517.GA1743170@kroah.com>
Organization: Red Hat, Inc.
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-s1Ee7myzZbv2hqZTGRLp"
User-Agent: Evolution 3.32.4 (3.32.4-1.fc30) 
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.43]); Fri, 27 Sep 2019 20:17:19 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--=-s1Ee7myzZbv2hqZTGRLp
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2019-09-26 at 21:55 +0200, gregkh@linuxfoundation.org wrote:
> On Thu, Sep 26, 2019 at 07:49:44PM +0000, Saleem, Shiraz wrote:
> > > Subject: Re: [RFC 20/20] RDMA/i40iw: Mark i40iw as deprecated
> > >=20
> > > On Thu, Sep 26, 2019 at 09:45:19AM -0700, Jeff Kirsher wrote:
> > > > From: Shiraz Saleem <shiraz.saleem@intel.com>
> > > >=20
> > > > Mark i40iw as deprecated/obsolete.
> > > >=20
> > > > irdma is the replacement driver that supports X722.
> > >=20
> > > Can you simply delete old one and add MODULE_ALIAS() in new
> > > driver?
> > >=20
> >=20
> > Yes, but we thought typically driver has to be deprecated for a few
> > cycles before removing it.
>=20
> If you completely replace it with something that works the same, why
> keep the old one around at all?
>=20
> Unless you don't trust your new code?  :)

I have yet to see, in over 20 years of kernel experience, a new driver
replace an old driver and not initially be more buggy and troublesome
than the old driver.  It takes time and real world usage for the final
issues to get sorted out.  During that time, the fallback is often
necessary for those real world users.

--=20
Doug Ledford <dledford@redhat.com>
    GPG KeyID: B826A3330E572FDD
    Fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD

--=-s1Ee7myzZbv2hqZTGRLp
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEErmsb2hIrI7QmWxJ0uCajMw5XL90FAl2ObksACgkQuCajMw5X
L90Lyg//b3ptE8AoVBijWhVsfB2qYdpGB3S01vv1ScJMLqT+yPXHRa9otvBhoe5e
TKNkxE75neJMlK4y7bzPesDEcYYHjbz7T3KEOOuUOdNn0Ba6WkhmabobMYFh5vfi
Kf8YYC9HjoHTdTq5roakoZOo+/+fYPTgPkafH7FSQp+3YYxf4NAszQATPw3+gVQf
C58CRGg4oDMb61cXgDmtPAK/ralxbEw1AKcJ8qrdrzWARn/kcj5NLtmjByy250BB
Nbp8h4f2erSgbqmAuMq7JnPSsTtkARmQmb1dcQpby8c1V37iyIKC2+Q9Ea32w3Tl
zf2MWYIFX9hO7hwsLDO8HqM8Aq1FunLyruMckgz8b68MDTkBB140053gGzJQGa0l
SiTWI17mChXcikhsDtm7SKhubbjn15MvmkNPunE0lKb9Hp4v6IfeC66Qg2hnPEW4
FDtTR5WwpQkWjXeT2BFcTJSOppWemYemh3+F/ZogCDc7ebI8My3wBFxIjfmGS445
mbyzjD3vicKve8zTaeLIBXIlDcGcd4HONCzXxChIlhyVv7K0xvkuM+4hghQC1olg
lTQ0TeTdHkdtIqUF59HVzKeM/PrVw3kNOmYfvwv5zlDWkOBsnFxsK2iHCRxMF/so
E06Yaj8eJDEr9bXRNmReD1jT8OFJIXRSoUgRbe3DcHG23zpodFs=
=I6hj
-----END PGP SIGNATURE-----

--=-s1Ee7myzZbv2hqZTGRLp--

