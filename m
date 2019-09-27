Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2EE25C0C8A
	for <lists+netdev@lfdr.de>; Fri, 27 Sep 2019 22:18:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727965AbfI0USF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Sep 2019 16:18:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49362 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725815AbfI0USF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 27 Sep 2019 16:18:05 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 5C41910C094B;
        Fri, 27 Sep 2019 20:18:04 +0000 (UTC)
Received: from linux-ws.nc.xsintricity.com (ovpn-112-20.rdu2.redhat.com [10.10.112.20])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 1E16D5D9C3;
        Fri, 27 Sep 2019 20:18:02 +0000 (UTC)
Message-ID: <fd3c5fa7b4a4ec95762ffd358e5eaa249f34330d.camel@redhat.com>
Subject: Re: [RFC 20/20] RDMA/i40iw: Mark i40iw as deprecated
From:   Doug Ledford <dledford@redhat.com>
To:     "Saleem, Shiraz" <shiraz.saleem@intel.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
Cc:     Leon Romanovsky <leon@kernel.org>,
        "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        "jgg@mellanox.com" <jgg@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
Date:   Fri, 27 Sep 2019 16:18:00 -0400
In-Reply-To: <9DD61F30A802C4429A01CA4200E302A7AC70465F@fmsmsx123.amr.corp.intel.com>
References: <20190926164519.10471-1-jeffrey.t.kirsher@intel.com>
         <20190926164519.10471-21-jeffrey.t.kirsher@intel.com>
         <20190926174009.GD14368@unreal>
         <9DD61F30A802C4429A01CA4200E302A7AC702BDA@fmsmsx123.amr.corp.intel.com>
         <20190926195517.GA1743170@kroah.com>
         <9DD61F30A802C4429A01CA4200E302A7AC70465F@fmsmsx123.amr.corp.intel.com>
Organization: Red Hat, Inc.
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-349MnWMH84vVbtzERMIR"
User-Agent: Evolution 3.32.4 (3.32.4-1.fc30) 
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.66]); Fri, 27 Sep 2019 20:18:04 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--=-349MnWMH84vVbtzERMIR
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2019-09-27 at 14:28 +0000, Saleem, Shiraz wrote:
> > Subject: Re: [RFC 20/20] RDMA/i40iw: Mark i40iw as deprecated
> >=20
> > On Thu, Sep 26, 2019 at 07:49:44PM +0000, Saleem, Shiraz wrote:
> > > > Subject: Re: [RFC 20/20] RDMA/i40iw: Mark i40iw as deprecated
> > > >=20
> > > > On Thu, Sep 26, 2019 at 09:45:19AM -0700, Jeff Kirsher wrote:
> > > > > From: Shiraz Saleem <shiraz.saleem@intel.com>
> > > > >=20
> > > > > Mark i40iw as deprecated/obsolete.
> > > > >=20
> > > > > irdma is the replacement driver that supports X722.
> > > >=20
> > > > Can you simply delete old one and add MODULE_ALIAS() in new
> > > > driver?
> > > >=20
> > >=20
> > > Yes, but we thought typically driver has to be deprecated for a
> > > few cycles
> > before removing it.
> >=20
> > If you completely replace it with something that works the same, why
> > keep the old
> > one around at all?
>=20
> Agree. Thanks!
>=20
>=20
> > Unless you don't trust your new code?  :)
> >=20
> We do :)

I don't....

--=20
Doug Ledford <dledford@redhat.com>
    GPG KeyID: B826A3330E572FDD
    Fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD

--=-349MnWMH84vVbtzERMIR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEErmsb2hIrI7QmWxJ0uCajMw5XL90FAl2ObngACgkQuCajMw5X
L92NkQ//Wdl5eMZtMdMCckraPow4l2jmIM5aDxMOH1TTzao9YNnF4yRdoWBAL6bA
jta60sqR81DuwpIIHufavL1TJ+OsfY8nlm3gKOp6lwWdA55SFccma/teuIbbOj3O
ZHez+oa+95Ot0J7oeCS3w464g5MEiKSTE6TNUzmpF9KGoyzPC4eoYYXLp8aGpuTs
WKPiadGPO4nzKhYWo/e8y8eZHkhkGbPusWZz7CMmCiTfRODXziIP2w2FUpNXHpq8
fXLHbRAYgahgvVS3msRCQHCcTqFeoG4nFSTbCiUwqGoOaKgbuq64hsYmHe+ngT6E
OzXym/oQjlWnoPtG0JlwW+BCaTejdFZYGuqdYT894/0lDkJGYLhE5yBOs6TY4c0+
LFmm69xH4TYhTBj+8erVZEYzL3mF5GGr9dtxs3wDNkmyAxzULHc/Py1bvS46O5A9
hXQQGXR730ys2uCG1Pgtid8rnvGzLTslpsaULdaQMca6d95NFQx0UUQsQ/eoKwZd
u6ezOWnxnZr2ufzpZiZccxzrj+0U8/QjtQkR/g+eGY7Zbbe8WeVuorhtev2wWTbw
/kt84TG8urlvdgBKUGXuhsm2yXgQjf3M2AitSU1by5iV0ksZvWF7mqglKZ1c+wS6
5E9KrTgANskhpH4KOqJD2NbEDkY/vx0lYlN2k35LocdvpwiciC0=
=i7nI
-----END PGP SIGNATURE-----

--=-349MnWMH84vVbtzERMIR--

