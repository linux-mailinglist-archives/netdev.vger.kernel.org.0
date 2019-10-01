Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 73A6FC3349
	for <lists+netdev@lfdr.de>; Tue,  1 Oct 2019 13:48:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732669AbfJALsA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Oct 2019 07:48:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:50458 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725839AbfJALr7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Oct 2019 07:47:59 -0400
Received: from localhost.localdomain (nat-pool-mxp-t.redhat.com [149.6.153.186])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9F54021920;
        Tue,  1 Oct 2019 11:47:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569930479;
        bh=r0AH0m7sGkMjVUf3KFX7VMraEdgm+Lq1IlONtPcyjC8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qKT1c5kbuINCo4NmwJEYNFCG226+C+QtcNBGYlU0q8w5odNJabdKUoTrpEPGc13iS
         GhRGtGUWFMkBto3H2Df9eDTXCZRgeQMcB3XCjFR7Wg9hRZxAkMaPc4R6Rhch7Li7c3
         Fid2KN3W6/4MOjCJAoidTWcKPQCetslX+nPGVxFU=
Date:   Tue, 1 Oct 2019 13:47:53 +0200
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>,
        Maciej Fijalkowski <maciejromanfijalkowski@gmail.com>,
        netdev@vger.kernel.org, thomas.petazzoni@bootlin.com,
        ilias.apalodimas@linaro.org, mcroce@redhat.com
Subject: Re: [RFC 3/4] net: mvneta: add basic XDP support
Message-ID: <20191001114753.GB30888@localhost.localdomain>
References: <cover.1569920973.git.lorenzo@kernel.org>
 <5119bf5e9c33205196cf0e8b6dc7cf0d69a7e6e9.1569920973.git.lorenzo@kernel.org>
 <20191001125246.0000230a@gmail.com>
 <87zhiku3lv.fsf@toke.dk>
 <20191001133048.108b056a@carbon>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="uQr8t48UFsdbeI+V"
Content-Disposition: inline
In-Reply-To: <20191001133048.108b056a@carbon>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--uQr8t48UFsdbeI+V
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> On Tue, 01 Oct 2019 13:06:36 +0200
> Toke H=F8iland-J=F8rgensen <toke@redhat.com> wrote:
>=20
> > Maciej Fijalkowski <maciejromanfijalkowski@gmail.com> writes:
> >=20
> > > On Tue,  1 Oct 2019 11:24:43 +0200
> > > Lorenzo Bianconi <lorenzo@kernel.org> wrote:
> > > =20
> > >> Add basic XDP support to mvneta driver for devices that rely on soft=
ware
> > >> buffer management. Currently supported verdicts are:
> > >> - XDP_DROP
> > >> - XDP_PASS
> > >> - XDP_REDIRECT =20
> > >
> > > You're supporting XDP_ABORTED as well :P any plans for XDP_TX? =20
> >=20
> > Wait, if you are supporting REDIRECT but not TX, that means redirect
> > only works to other, non-mvneta, devices, right? Maybe that should be
> > made clear in the commit message :)
>=20
> If you implemented XDP_REDIRECT, then it should be trivial to implement
> XDP_TX, as you can just convert the xdp_buff to xdp_frame and call your
> ndo_xdp_xmit function directly (and do the tail-flush).
>=20
> Or maybe you are missing a ndo_xdp_xmit function (as Toke indirectly
> points out).

Hi Jesper and Toke,

my plan is to add XDP_TX before posting a formal series (I am working on it=
).
I shared this RFC series to get some comments and share the current status.

Regards,
Lorenzo

>=20
> --=20
> Best regards,
>   Jesper Dangaard Brouer
>   MSc.CS, Principal Kernel Engineer at Red Hat
>   LinkedIn: http://www.linkedin.com/in/brouer

--uQr8t48UFsdbeI+V
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCXZM85wAKCRA6cBh0uS2t
rFjPAQC+PGzPdyOYNyRDU+5v2uP0elrQEcPbW45x0NI229AY6AEAkgvMx/bMJEKL
gV2ZEh7+KGN/zC0RGrdwXa/+fyT+9QM=
=sIoJ
-----END PGP SIGNATURE-----

--uQr8t48UFsdbeI+V--
