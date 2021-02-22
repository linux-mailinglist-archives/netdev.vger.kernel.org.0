Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69A973211F0
	for <lists+netdev@lfdr.de>; Mon, 22 Feb 2021 09:24:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230073AbhBVIXz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Feb 2021 03:23:55 -0500
Received: from bilbo.ozlabs.org ([203.11.71.1]:54257 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229863AbhBVIXv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Feb 2021 03:23:51 -0500
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4DkZtz2LX4z9sCD;
        Mon, 22 Feb 2021 19:23:07 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1613982188;
        bh=vy6vlrPPkz9MWvoO5Aid0v1nKjIi3Z7bJf5wfcFNjdU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=N+2gtoc8ZTYOplYDR5gdM3MY92ug7D1Rswk0LaIfRqxWlUng0J2ZgY4turxSEE49j
         UjGA/Xq8SOrD+AQn523peae9Dy+D3JEjQadDAtWcv29g/mQsgALKvIfIMfDyTTW0A/
         j0FCfXBpZv6Ia8JVDIBvXBwydz/DvvtaJnYZVkAJCKdd5mJn1nktUh63b/fm3rl0ov
         hOY/PycZQjng71vLIxd0xkVeNekQB0b3wWLiFYpenHaxXOm4vW4qQ9i8yuQWQdbZzy
         Y3IakFAnATxOkrEOMPHxvqGIqsEVgcmkAWm54W0H7P2YmDBglofh1tfJbmzEMajXmQ
         s4l6ocHXnTgVQ==
Date:   Mon, 22 Feb 2021 19:23:06 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Rob Herring <robherring2@gmail.com>,
        David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Grygorii Strashko <grygorii.strashko@ti.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Rob Herring <robh@kernel.org>
Subject: Re: linux-next: manual merge of the devicetree tree with the
 net-next tree
Message-ID: <20210222192306.400c6a50@canb.auug.org.au>
In-Reply-To: <20210215075321.0f3ea0de@canb.auug.org.au>
References: <20210121132645.0a9edc15@canb.auug.org.au>
        <20210215075321.0f3ea0de@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/OWt35p.fZyUW/F.mtvAbZHT";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/OWt35p.fZyUW/F.mtvAbZHT
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

On Mon, 15 Feb 2021 07:53:21 +1100 Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
>
> On Thu, 21 Jan 2021 13:26:45 +1100 Stephen Rothwell <sfr@canb.auug.org.au=
> wrote:
> >=20
> > Today's linux-next merge of the devicetree tree got a conflict in:
> >=20
> >   Documentation/devicetree/bindings/net/ti,k3-am654-cpsw-nuss.yaml
> >=20
> > between commit:
> >=20
> >   19d9a846d9fc ("dt-binding: net: ti: k3-am654-cpsw-nuss: update bindin=
gs for am64x cpsw3g")
> >=20
> > from the net-next tree and commit:
> >=20
> >   0499220d6dad ("dt-bindings: Add missing array size constraints")
> >=20
> > from the devicetree tree.
> >=20
> > I fixed it up (see below) and can carry the fix as necessary. This
> > is now fixed as far as linux-next is concerned, but any non trivial
> > conflicts should be mentioned to your upstream maintainer when your tree
> > is submitted for merging.  You may also want to consider cooperating
> > with the maintainer of the conflicting tree to minimise any particularly
> > complex conflicts.
> >=20
> > diff --cc Documentation/devicetree/bindings/net/ti,k3-am654-cpsw-nuss.y=
aml
> > index 3fae9a5f0c6a,097c5cc6c853..000000000000
> > --- a/Documentation/devicetree/bindings/net/ti,k3-am654-cpsw-nuss.yaml
> > +++ b/Documentation/devicetree/bindings/net/ti,k3-am654-cpsw-nuss.yaml
> > @@@ -72,7 -66,8 +72,8 @@@ properties
> >     dma-coherent: true
> >  =20
> >     clocks:
> > +     maxItems: 1
> >  -    description: CPSW2G NUSS functional clock
> >  +    description: CPSWxG NUSS functional clock
> >  =20
> >     clock-names:
> >       items: =20
>=20
> With the merge window about to open, this is a reminder that this
> conflict still exists.

This is now a conflict between the devicetree tree and Linus' tree.
--=20
Cheers,
Stephen Rothwell

--Sig_/OWt35p.fZyUW/F.mtvAbZHT
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmAzaeoACgkQAVBC80lX
0GxuIwf/fGpN/peyPS8n9aX6gg5gaXe5tjuvFc/AqEaYDOu1igOrSmuv8b9+3zT4
H7FS/XqrfVYEX4groto6wWcUcGc4g5sxWtfMulR5or0FV0aOPQiyGyg4C/RN8xlW
At2YeIE0aa6EY9C06fgU/To5oSaKyGxojwYKBxOC2AcBNRdbOX0HRdWyFKObZxUb
VIF/wKVyYTlVRzaVvssCVZcxAlFYpKT9seZ1je0mRfR83xaHmhFdkSVtDG5YGJlT
i9VH3BzQK0sa3mhi8SVQ4bVU3/9FTeRCdzw+s5f9drkQA7PVDluf+rp/rFOrPRNF
JZBB/kV3qN4a6u7xbg27rAil92MO8A==
=rQRT
-----END PGP SIGNATURE-----

--Sig_/OWt35p.fZyUW/F.mtvAbZHT--
