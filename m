Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2C87A11908A
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 20:23:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726100AbfLJTXe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 14:23:34 -0500
Received: from mga11.intel.com ([192.55.52.93]:42575 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725999AbfLJTXd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Dec 2019 14:23:33 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 10 Dec 2019 11:23:33 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,300,1571727600"; 
   d="asc'?scan'208";a="210482679"
Received: from dssnyder-mobl.amr.corp.intel.com ([10.254.45.55])
  by fmsmga007.fm.intel.com with ESMTP; 10 Dec 2019 11:23:33 -0800
Message-ID: <46ed855e75f9eda89118bfad9c6f7b16dd372c71.camel@intel.com>
Subject: Re: [net-next v3 00/20][pull request] Intel Wired LAN Driver
 Updates 2019-12-09
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     Jason Gunthorpe <jgg@ziepe.ca>
Cc:     davem@davemloft.net, gregkh@linuxfoundation.org,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com, parav@mellanox.com
Date:   Tue, 10 Dec 2019 11:23:32 -0800
In-Reply-To: <20191210191125.GG46@ziepe.ca>
References: <20191209224935.1780117-1-jeffrey.t.kirsher@intel.com>
         <20191210172233.GA46@ziepe.ca>
         <324a6a4c7553cea5225b6f94ff224e155a252b36.camel@intel.com>
         <20191210182543.GE46@ziepe.ca>
         <a13f11a31d5cafcc002d5e5ca73fe4a8e3744fb5.camel@intel.com>
         <20191210191125.GG46@ziepe.ca>
Content-Type: multipart/signed; micalg="pgp-sha512";
        protocol="application/pgp-signature"; boundary="=-tZfubLxVSXOIav0zaSqV"
User-Agent: Evolution 3.34.2 (3.34.2-1.fc31) 
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--=-tZfubLxVSXOIav0zaSqV
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2019-12-10 at 15:11 -0400, Jason Gunthorpe wrote:
> On Tue, Dec 10, 2019 at 10:41:54AM -0800, Jeff Kirsher wrote:
> > On Tue, 2019-12-10 at 14:25 -0400, Jason Gunthorpe wrote:
> > > On Tue, Dec 10, 2019 at 10:06:41AM -0800, Jeff Kirsher wrote:
> > > > > Please don't send new RDMA drivers in pull requests to net. This
> > > > > driver is completely unreviewed at this point.
> > > >=20
> > > > This was done because you requested a for a single pull request in
> > > > an
> > > > earlier submission 9 months ago.  I am fine with breaking up
> > > > submission,
> > > > even though the RDMA driver would be dependent upon the virtual bus
> > > > and
> > > > LAN
> > > > driver changes.
> > >=20
> > > If I said that I ment a single pull request *to RDMA* with Dave's
> > > acks
> > > on the net side, not a single pull request to net.
> > >=20
> > > Given the growth of the net side changes this may be better to use a
> > > shared branch methodology.
> >=20
> > I am open to any suggestions you have on submitting these changes that
> > has
> > the least amount of thrash for all the maintainers involved.
> >=20
> > My concerns for submitting the network driver changes to the RDMA tree
> > is
> > that it will cause David Miller a headache when taking additional LAN
> > driver changes that would be affected by the changes that were taken
> > into
> > the RDMA tree.
>=20
> If you send the PR to rdma then you must refrain from sending changes
> to net that would conflict with it.

Yeah, that will be tough, since we will have *literally* hundreds of
patches for the ice driver for the 5.6 kernel.

>=20
> I also do not want a headache with conflicts to a huge rdma driver in
> net, so you cannot send it to -net.

Agreed, I do not want to cause you or David Miller any headaches.  It was
not clear on what additional changes the RDMA team would have once their
driver got upstream.

> Mellanox uses a shared branch approach now, it is working well but
> requires discipline to execute.

Wouldn't a shared branch cause issues for either you or David Miller to
pull from, since it has changes from the RDMA and net-next tree's?

> You can also send your changes to net, wait a cycle then send the rdma
> changes. IIRC one of the other drivers is working this way.

This sounds like the best option currently, since there is still a lot of
work being done in the ice driver.  Since Greg wanted to see driver
examples, using the virtual bus, I can send the RDMA driver patches as RFC
in future submissions.  This way, we can make sure the implementation is
acceptable and will be ready for submission, once the virtual bus and LAN
driver changes are accepted.

--=-tZfubLxVSXOIav0zaSqV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEiTyZWz+nnTrOJ1LZ5W/vlVpL7c4FAl3v8LQACgkQ5W/vlVpL
7c6FTBAAii+BIZA2ydXAGXse2VctCkZb7mIAhsMKCzWneWelrgwPcwwfjt1iDH0H
SAFTuVSg7lZQ5pQupT5zZV9pc/jbYL0e3+DPp72yGkCIxhCprKExiBBSxYa7XrMc
tpdsWSCKXhMcJPGNq91dJM7Rbo377SB+tGKMhK1SfWwuW4aR4dqJVeHT4e4x/bx3
+EHcC4/RblwMdO3qyrgNG5Cak1XV5mhQiMSpNuWCRrE0Bxm5OGMZ0OwDzlRUn244
KOry1Zm5q4t7m5i1A6kuBbJJyfXnQ1WxPUIg03Di88JoCTfSfWvBcsi7RwiFcVqH
wbUGRu63sXTIjupsNM885+Sb1pbkNNmOvK9CpI6KESDZ+t2peePe5Pn6Vwp1Z1m8
IGU3aS7p3rDn+zbeMKvZShlhqg/Ta3uTJ9oSF+VUywOnNwAL4+u4KXR2KKYADroF
gvIkbuHLiiK4cppfgzQWE2O6B2yUqIjoQP5l9hWg8fEtnPxTwjlzXpFw8oHqQlFs
Xkn91djbnrJAIjKXYgHN+17lQzCNGFwjxv9lSWdtm/9puBAxsgDfqlc+kJtYLpL5
9yMFzR/okssFmMfETQA6S7Mymt6yAMOjW/7vc+ZM/s7XyPkfmInvTDd2tvpneIMn
r/pKkZK0ACgWtx/Chi0WeJT0fPMhQAbcPGw9qr1xTkKYtnoqnU8=
=CA2/
-----END PGP SIGNATURE-----

--=-tZfubLxVSXOIav0zaSqV--

