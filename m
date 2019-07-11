Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9C05E65099
	for <lists+netdev@lfdr.de>; Thu, 11 Jul 2019 05:16:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727838AbfGKDQG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Jul 2019 23:16:06 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:52599 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725977AbfGKDQG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Jul 2019 23:16:06 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 45kh5v73Qrz9sDB;
        Thu, 11 Jul 2019 13:16:03 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1562814964;
        bh=vRUTtWdpBuMzNVFWQu6sVkEqeMrSM/smM8cYnj9YkJ4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=nWAOXp2cFO1vnrkyOudRlKtTeo925tV/Xnh2ajWm8rV7tjLOqKjd58j1MOcbi0bgo
         sO6bnOtrsaVuwkiKzinoLZrPk7mDWgJ0BJN9mBoLsIysEzVeGTDZdTbox9KYR/Mp3M
         CteH6qFOL/HK52TcE12ndZO7d+ekqSWE/KLmzoIMyTX8mZDlCZtqDuutaoH0XMI9JS
         bEx43pPkouGSi2VVJ0bO25qWVn2lPPs8bm7zW9q2bTxt/X1dhbIbpE/Gqd/MMEjMZf
         UhFOR3A2MexAAn4GQdEGPx/hTcsPw45n7o/AiYFmcIas5pc651kUydDAGZTXovxQuQ
         hc5W+3oL/Z81w==
Date:   Thu, 11 Jul 2019 13:16:03 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Jason Gunthorpe <jgg@mellanox.com>
Cc:     Leon Romanovsky <leon@kernel.org>,
        Bernard Metzler <bmt@zurich.ibm.com>,
        Doug Ledford <dledford@redhat.com>,
        David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: build failure after merge of the net-next tree
Message-ID: <20190711131603.6b11b831@canb.auug.org.au>
In-Reply-To: <20190711131344.452fc064@canb.auug.org.au>
References: <20190709135636.4d36e19f@canb.auug.org.au>
        <20190709064346.GF7034@mtr-leonro.mtl.com>
        <20190710175212.GM2887@mellanox.com>
        <20190711115054.7d7f468c@canb.auug.org.au>
        <20190711015854.GC22409@mellanox.com>
        <20190711131344.452fc064@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/v=_kHvKDD7EhV76GN9sVn0W"; protocol="application/pgp-signature"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/v=_kHvKDD7EhV76GN9sVn0W
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

On Thu, 11 Jul 2019 13:13:44 +1000 Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
>
> On Thu, 11 Jul 2019 02:26:27 +0000 Jason Gunthorpe <jgg@mellanox.com> wro=
te:
> >
> > On Thu, Jul 11, 2019 at 11:50:54AM +1000, Stephen Rothwell wrote:
> >  =20
> > > So today this failed to build after I merged the rdma tree (previously
> > > it didn;t until after the net-next tree was merged (I assume a
> > > dependency changed).  It failed because in_dev_for_each_ifa_rcu (and
> > > in_dev_for_each_ifa_rtnl) is only defined in a commit in the net-next
> > > tree :-(   =20
> >=20
> > ? I'm confused..=20
> >=20
> > rdma.git builds fine stand alone (I hope!) =20
>=20
> I have "Fixup to build SIW issue" from Leon (which switches to using
> in_dev_for_each_ifa_rcu) included in the rmda tree merge commit because
> without that the rdma tree would not build for me.  Are you saying that
> I don't need that at all, now?

Actually , I get it now, "Fixup to build SIW issue" is really just a
fixup for the net-next and rdma trees merge ... OK, I will fix that up
tomorrow.  Sorry for my confusion.

--=20
Cheers,
Stephen Rothwell

--Sig_/v=_kHvKDD7EhV76GN9sVn0W
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl0mqfMACgkQAVBC80lX
0Gz6SggAnbzQymEWzUF1Y27nGfuhZ+ENQ2ey4pG4HodqT59xsGZe8uZ4OdsnfFM5
IOzTm1qLRUc+FfHyBg6KYqZuM0rVUba9btbs8KJZ0uczUrNU+Jclb4OsqRC/QRuQ
SftH1NOB/m9sb+Th+nYTfxbdlGZBg5OU7EeMIWM4YO1CC2dBWmKQKliX+Ag1eoMp
MO7NJemUgL661F9S3PlZigNFYGMardF6FIOECxOQgPXNOaDvwNcqOwcBj04UWhN1
qAJTL/CuFHDkYO68OzeqwRKmMBYG0sDjibOO5Q5rrJbMEFatrCR6MHW+poj8LGDM
K0OSovkphRFhc4PH1EnNs63lpJIQiw==
=lbSx
-----END PGP SIGNATURE-----

--Sig_/v=_kHvKDD7EhV76GN9sVn0W--
