Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D91721FDEB
	for <lists+netdev@lfdr.de>; Tue, 14 Jul 2020 21:55:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729655AbgGNTzD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jul 2020 15:55:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729465AbgGNTzD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jul 2020 15:55:03 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20754C061755;
        Tue, 14 Jul 2020 12:55:03 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id m9so8042681pfh.0;
        Tue, 14 Jul 2020 12:55:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=JYMRhwsu+Sb7OdIXTr+m2jcY6PaVT0jbYkR2hlBIQac=;
        b=fs4fvydGVNvlk5nD87KZFP08JqelxL90HPPkjS2E4M1OFRJ8jvE23FFOO6XgUs+EdC
         zz9EDAHIdKWW9SjezQFxrX2LzMxaOS4r37lvUaibE+hLSWKbTDdQHf1S3c2Rk3Y2aDch
         +IqWejNVTpOIfjj6tqwlzSI+JD2dkDI93kixcYJznNmSlHmV91Cw93Okv4rBTTW2I0fp
         9pDNi7fAjNtQfnPsnSaFVAT0D9iS6Af5T/vm+E1a2ZX2rTZiv3AxUGPm2QrOZMM7Grhi
         OZ0e7UrNfkMAFwrkALZm3hpOPt02D8g6TC9uOoOBDqQIlI8pfED8r5BnDPx3S9CRblfR
         Oysw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=JYMRhwsu+Sb7OdIXTr+m2jcY6PaVT0jbYkR2hlBIQac=;
        b=e9i+INIaY2rubZ9/4OdgVVqLOdhxecESmOIxQptklGoowMiTN60z0KqwJgwbBVTcwg
         QRyFkTp9gT876c1O2NhZ40jqeXo7XxuRqMB4Od3H3IR//iiYek6yfN555/jZLYVFRwCh
         OM8jB9ijI2uwdkBQhCUfnuYGfxAPqf7hqgQh/UKssi89ekKgxEYaUAau3xb/ZLhPMuiD
         UaDqU/IkzqgcUScuxqDO9JZqBNkciSI9vrpvisjL/k3CxPAfxSPHd/FRsGbJIq3lA+kJ
         pb8+ACWv+214imWrT+dhHPtTOjcGnf+UBpN0CC3qlfN8fqSc3/Wz2h18jCUZK5ehGxp3
         swgQ==
X-Gm-Message-State: AOAM53285KV4RdfCVuv2Pf+lWhHprioMsisrLK+08hAJWKompqngdp5d
        P/1huMnfNaHNH1KW5zL5ZTIXkJ/A803auQ==
X-Google-Smtp-Source: ABdhPJw/oO8x2DZghTsWUoMl473fHwCIUH5VYDjbimv6MY0MoeAVVAqLzc8Q/q4VrjOK+4DFIOHUgA==
X-Received: by 2002:a05:6a00:2292:: with SMTP id f18mr5729482pfe.192.1594756502680;
        Tue, 14 Jul 2020 12:55:02 -0700 (PDT)
Received: from blackclown ([103.88.82.145])
        by smtp.gmail.com with ESMTPSA id e20sm13898pfl.212.2020.07.14.12.54.59
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 14 Jul 2020 12:55:01 -0700 (PDT)
Date:   Wed, 15 Jul 2020 01:24:56 +0530
From:   Suraj Upadhyay <usuraj35@gmail.com>
To:     Joe Perches <joe@perches.com>
Cc:     Dan Carpenter <dan.carpenter@oracle.com>,
        GR-Linux-NIC-Dev@marvell.com, gregkh@linuxfoundation.org,
        devel@driverdev.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/6] staging: qlge: qlge_ethtool: Remove one byte memset.
Message-ID: <20200714195456.GB14742@blackclown>
References: <cover.1594642213.git.usuraj35@gmail.com>
 <b5eb87576cef4bf1b968481d6341013e6c7e9650.1594642213.git.usuraj35@gmail.com>
 <20200713141749.GU2549@kadam>
 <a323c1e47e8de871ff7bb72289740cb0bc2d27f8.camel@perches.com>
 <20200714190602.GA14742@blackclown>
 <ce637b26b496dd99be8f272e6ec82333338321dc.camel@perches.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="1LKvkjL3sHcu1TtY"
Content-Disposition: inline
In-Reply-To: <ce637b26b496dd99be8f272e6ec82333338321dc.camel@perches.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--1LKvkjL3sHcu1TtY
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 14, 2020 at 12:22:05PM -0700, Joe Perches wrote:
> On Wed, 2020-07-15 at 00:36 +0530, Suraj Upadhyay wrote:
> > On Tue, Jul 14, 2020 at 11:57:23AM -0700, Joe Perches wrote:
> > > On Mon, 2020-07-13 at 17:17 +0300, Dan Carpenter wrote:
> > > > On Mon, Jul 13, 2020 at 05:52:22PM +0530, Suraj Upadhyay wrote:
> > > > > Use direct assignment instead of using memset with just one byte =
as an
> > > > > argument.
> > > > > Issue found by checkpatch.pl.
> > > > >=20
> > > > > Signed-off-by: Suraj Upadhyay <usuraj35@gmail.com>
> > > > > ---
> > > > > Hii Maintainers,
> > > > > 	Please correct me if I am wrong here.
> > > > > ---
> > > > >=20
> > > > >  drivers/staging/qlge/qlge_ethtool.c | 4 ++--
> > > > >  1 file changed, 2 insertions(+), 2 deletions(-)
> > > > >=20
> > > > > diff --git a/drivers/staging/qlge/qlge_ethtool.c b/drivers/stagin=
g/qlge/qlge_ethtool.c
> > > > > index 16fcdefa9687..d44b2dae9213 100644
> > > > > --- a/drivers/staging/qlge/qlge_ethtool.c
> > > > > +++ b/drivers/staging/qlge/qlge_ethtool.c
> > > > > @@ -516,8 +516,8 @@ static void ql_create_lb_frame(struct sk_buff=
 *skb,
> > > > >  	memset(skb->data, 0xFF, frame_size);
> > > > >  	frame_size &=3D ~1;
> > > > >  	memset(&skb->data[frame_size / 2], 0xAA, frame_size / 2 - 1);
> > > > > -	memset(&skb->data[frame_size / 2 + 10], 0xBE, 1);
> > > > > -	memset(&skb->data[frame_size / 2 + 12], 0xAF, 1);
> > > > > +	skb->data[frame_size / 2 + 10] =3D (unsigned char)0xBE;
> > > > > +	skb->data[frame_size / 2 + 12] =3D (unsigned char)0xAF;
> > > >=20
> > > > Remove the casting.
> > > >=20
> > > > I guess this is better than the original because now it looks like
> > > > ql_check_lb_frame().  It's still really weird looking though.
> > >=20
> > > There are several of these in the intel drivers too:
> > >=20
> > > drivers/net/ethernet/intel/e1000/e1000_ethtool.c:       memset(&skb->=
data[frame_size / 2 + 10], 0xBE, 1);
> > > drivers/net/ethernet/intel/e1000/e1000_ethtool.c:       memset(&skb->=
data[frame_size / 2 + 12], 0xAF, 1);
> > > drivers/net/ethernet/intel/e1000e/ethtool.c:    memset(&skb->data[fra=
me_size / 2 + 10], 0xBE, 1);
> > > drivers/net/ethernet/intel/e1000e/ethtool.c:    memset(&skb->data[fra=
me_size / 2 + 12], 0xAF, 1);
> > > drivers/net/ethernet/intel/igb/igb_ethtool.c:   memset(&skb->data[fra=
me_size + 10], 0xBE, 1);
> > > drivers/net/ethernet/intel/igb/igb_ethtool.c:   memset(&skb->data[fra=
me_size + 12], 0xAF, 1);
> > > drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c:       memset(&skb->=
data[frame_size + 10], 0xBE, 1);
> > > drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c:       memset(&skb->=
data[frame_size + 12], 0xAF, 1);
> > > drivers/staging/qlge/qlge_ethtool.c:    memset(&skb->data[frame_size =
/ 2 + 10], 0xBE, 1);
> > > drivers/staging/qlge/qlge_ethtool.c:    memset(&skb->data[frame_size =
/ 2 + 12], 0xAF, 1);
> >=20
> > Thanks to point this out,
> > 	I will be sending a patchset for that soon.
>=20
>=20
> It _might_ be useful to create and use a standard
> mechanism for the loopback functions:
>=20
> 	<foo>create_lbtest_frame
> and
> 	<foo>check_lbtest_frame
>=20
> Maybe use something like:
>=20
> 	ether_loopback_frame_create
> and
> 	ether_loopback_frame_check
>=20
I thought about it=A0 but then again the fram_size is sometimes divided by =
two

e.g. `frame_size /=3D 2;` or `frame_size >>=3D 1;`.

and sometimes it is subtracted by one. i.e. `frame_size &=3D ~1;`.

Anyway, I sent my layman patchset to the lkml and intel maintainers.

Forgive my brevity.

Thanks,=A0

Suraj Upadhyay.=20

--1LKvkjL3sHcu1TtY
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEE7AbCa0kOsMJ4cx0j+gRsbIfe744FAl8ODYgACgkQ+gRsbIfe
744oCRAAqrqADv/xB4JVPjjXz492plNFNWc8LGb+FfE8WO/fXyAdP6QlihH6yTK/
wf77xEFSJOao6VFX501O5KqklsWkNZ+FFs49mMcDdo6qXjlezHp0/4J6NFI+bn5g
OXjshxMZpjyGI4wT03QHxP2dvhIVxEt+2FY44DzOT/vtsVYRKInLK3nTjS4f7Wdp
yqgSmI831AWcoPYZd3PkZLneXDbFi2CSPBBMREmiP1N735WfXSZqEACPYRtKVj2f
62QgFz6S8AWb0OYB/I67OUDFDDnufchuGa22SJNmv3HxYbMpF9QlhovCK2XfUT6/
30UzieYqCPd+IIccn1iWtbFhMl5wa0bTTZRL3D8Zt7P3J7dxrb9wHZyjkt2baqhj
+n+GW4nfSoCVCDqJMr/AopOfIL0FS2eqvmkVsohOpneuElfYf6M+1AcH0kprADHW
js9OomrTXRkanNAk1fjxPhItfVqqka8sT+dmYsVmfZMTDuytS6nxx55zwGSFuuzA
BgTLJ0fNLrS7E7hrPyoc9/O2xktZ4DsWuFZYiB8SMz5F8nH1hG2VGsYOGjs+L7WS
bFAau0a0f+GNRYj2TztM3Jq2Y393xBNBquUMaOAA6MXNd5InFZBb39L5dGuLmaXQ
UyObb7g20JD6D8bJCBA+Jx4G4vGR3Qqvu9kbabnC6mINzK1AzyY=
=iZ2l
-----END PGP SIGNATURE-----

--1LKvkjL3sHcu1TtY--
