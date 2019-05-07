Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 49D8716129
	for <lists+netdev@lfdr.de>; Tue,  7 May 2019 11:39:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726834AbfEGJji (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 May 2019 05:39:38 -0400
Received: from mail.katalix.com ([82.103.140.233]:48166 "EHLO mail.katalix.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726399AbfEGJjh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 7 May 2019 05:39:37 -0400
Received: from localhost (82-69-49-219.dsl.in-addr.zen.co.uk [82.69.49.219])
        (Authenticated sender: tom)
        by mail.katalix.com (Postfix) with ESMTPSA id 88D33BC712;
        Tue,  7 May 2019 10:39:34 +0100 (BST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=katalix.com; s=mail;
        t=1557221974; bh=AzVaUEsvmxiwsCjoujMQyGb8OcZ2HYQaUqgVR8splY8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To;
        b=s6ESQk82S3k+rAw7rE3iBYExchUBOVQypiIaDMICk0NF3VUVQMnv8x1pcsQsTIg/6
         1KV9NcUl54jShx4456VdNih0ND+B3ASYU4dsE/IGx5kemuGdMJ6ivHF1oGGJ2z4x09
         ttD2XczwmWghxrdWjtnBiOUV4DEb5d6qZAbt1//w=
Date:   Tue, 7 May 2019 10:39:33 +0100
From:   Tom Parkin <tparkin@katalix.com>
To:     Matteo Croce <mcroce@redhat.com>
Cc:     linux-ppp@vger.kernel.org, netdev <netdev@vger.kernel.org>,
        Paul Mackerras <paulus@ozlabs.org>,
        Jo-Philipp Wich <jo@mein.io>
Subject: Re: [PATCH pppd v4] pppoe: custom host-uniq tag
Message-ID: <20190507093932.GB3561@jackdaw>
References: <20190504164853.4736-1-mcroce@redhat.com>
 <20190507091034.GA3561@jackdaw>
 <CAGnkfhwVvF4qcqoU6wC8tCb6vrvNipP0UG4MxqAd1--5fLmjQg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="mojUlQ0s9EVzWg2t"
Content-Disposition: inline
In-Reply-To: <CAGnkfhwVvF4qcqoU6wC8tCb6vrvNipP0UG4MxqAd1--5fLmjQg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--mojUlQ0s9EVzWg2t
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, May 07, 2019 at 11:32:27AM +0200, Matteo Croce wrote:
> On Tue, May 7, 2019 at 11:10 AM Tom Parkin <tparkin@katalix.com> wrote:
> >
> > Hi Matteo,
> >
> > On Sat, May 04, 2019 at 06:48:53PM +0200, Matteo Croce wrote:
> > > Add pppoe 'host-uniq' option to set an arbitrary
> > > host-uniq tag instead of the pppd pid.
> > > Some ISPs use such tag to authenticate the CPE,
> > > so it must be set to a proper value to connect.
> > >
> > > Signed-off-by: Matteo Croce <mcroce@redhat.com>
> > > Signed-off-by: Jo-Philipp Wich <jo@mein.io>
> > > ---
> > >  pppd/plugins/rp-pppoe/common.c          | 14 +++----
> > >  pppd/plugins/rp-pppoe/discovery.c       | 52 ++++++++++-------------=
--
> > >  pppd/plugins/rp-pppoe/plugin.c          | 15 ++++++-
> > >  pppd/plugins/rp-pppoe/pppoe-discovery.c | 41 ++++++++++++-------
> > >  pppd/plugins/rp-pppoe/pppoe.h           | 30 +++++++++++++-
> > >  5 files changed, 96 insertions(+), 56 deletions(-)
> > >
>=20
> Hi Tom,
>=20
> this was a known bug of the v3 patch, I've fixed it in the v4.
>=20
> Regards,

Cool, thanks for confirming.

Tom

--mojUlQ0s9EVzWg2t
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQEcBAEBAgAGBQJc0VJUAAoJEJSMBmUKuovQk2gH/03M5teO7cAoPudid8IIqTUU
Jo83T7encOHAU49AT2YwzCc90W9ilOHfuNgdXaEwgdL+BhyYHDyzpJ+YqKRCf7kZ
H+UHiI2nIiWPOyz/VeN2Wf/PdmSydx0SE2tsxy6vufWfrgKiMi0n3HZSAk32G8rc
yxdvlZaq6DjPiYg0nvrjtNVKxFT0c4FZYe1tiwplYHcNSNaKF7q82aA+DoXJdW9/
IDnijr2ghsrM7Z1jGX2vZRt5cfoNUgoNnFS/FZbjvDU2Sg/72PdZ0Mcam+/LLHQA
TQd/E4n0YDs4D4LeOg4rccRUZ8d623zvwT+WWP7pnj5UAc84b+mH7cJVD3KMCsE=
=myVL
-----END PGP SIGNATURE-----

--mojUlQ0s9EVzWg2t--
