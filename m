Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A210D349E60
	for <lists+netdev@lfdr.de>; Fri, 26 Mar 2021 02:05:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230054AbhCZBE2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 21:04:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229733AbhCZBEQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Mar 2021 21:04:16 -0400
Received: from ozlabs.org (bilbo.ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F40CC06174A;
        Thu, 25 Mar 2021 18:04:13 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4F63dk4Z25z9sRf;
        Fri, 26 Mar 2021 12:04:10 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1616720651;
        bh=QO5xNJVgn8fdiTLRQQCrCp7L2rU2OWeJXJkdd/IV5cg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=LQTYPCSuigpLisD2U0xEeK7j9ZBojpuf2/2l4kMe5PNHHoE2jbGLvS6ACX3ths8SK
         RtdBChCwcYZM8I06Uz1RPQFzEeUFPMhB8DgymQzRB9Vdhgoaf6O39TLpzLyI65c97F
         HhtMt5TzBe//sPZjkHMtziROx7FXX390Ch8bqosxSSDbmLy8AgtTwxopEQ1dRdDfjn
         JFYWUJmE0mU7xSzt9EJRNTRuXPHKI8X4Zxzro5vB+W03srmV3vnqFzB38X0aM8EuZ0
         3gDCdSlSo2ZbJnR3WYP1v7wdK1AtL9A2/T4XMypCW3yuz2R72H13PDmsnKaXZLF4RE
         r2CghdP3fa1/w==
Date:   Fri, 26 Mar 2021 12:04:09 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, kuba@kernel.org
Subject: Re: [PATCH net-next] docs: nf_flowtable: fix compilation and
 warnings
Message-ID: <20210326120354.622089e9@elm.ozlabs.ibm.com>
In-Reply-To: <20210325211018.5548-1-pablo@netfilter.org>
References: <20210325211018.5548-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/qi8okD35u_F2N8iA8jH_7Fl";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/qi8okD35u_F2N8iA8jH_7Fl
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Pablo,

On Thu, 25 Mar 2021 22:10:16 +0100 Pablo Neira Ayuso <pablo@netfilter.org> =
wrote:
>
> ... cannot be used in block quote, it breaks compilation, remove it.
>=20
> Fix warnings due to missing blank line such as:
>=20
> net-next/Documentation/networking/nf_flowtable.rst:142: WARNING: Block qu=
ote ends without a blank line; unexpected unindent.
>=20
> Fixes: 143490cde566 ("docs: nf_flowtable: update documentation with enhan=
cements")
> Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> ---
>  Documentation/networking/nf_flowtable.rst | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
>=20
> diff --git a/Documentation/networking/nf_flowtable.rst b/Documentation/ne=
tworking/nf_flowtable.rst
> index d87f253b9d39..d757c21c10f2 100644
> --- a/Documentation/networking/nf_flowtable.rst
> +++ b/Documentation/networking/nf_flowtable.rst
> @@ -112,6 +112,7 @@ You can identify offloaded flows through the [OFFLOAD=
] tag when listing your
>  connection tracking table.
> =20
>  ::
> +
>  	# conntrack -L
>  	tcp      6 src=3D10.141.10.2 dst=3D192.168.10.2 sport=3D52728 dport=3D5=
201 src=3D192.168.10.2 dst=3D192.168.10.1 sport=3D5201 dport=3D52728 [OFFLO=
AD] mark=3D0 use=3D2
> =20
> @@ -138,6 +139,7 @@ allows the flowtable to define a fastpath bypass betw=
een the bridge ports
>  device (represented as eth0) in your switch/router.
> =20
>  ::
> +
>                        fastpath bypass
>                 .-------------------------.
>                /                           \
> @@ -168,12 +170,12 @@ connection tracking entry by specifying the counter=
 statement in your flowtable
>  definition, e.g.
> =20
>  ::
> +
>  	table inet x {
>  		flowtable f {
>  			hook ingress priority 0; devices =3D { eth0, eth1 };
>  			counter
>  		}
> -		...
>  	}
> =20
>  Counter support is available since Linux kernel 5.7.
> @@ -185,12 +187,12 @@ If your network device provides hardware offload su=
pport, you can turn it on by
>  means of the 'offload' flag in your flowtable definition, e.g.
> =20
>  ::
> +
>  	table inet x {
>  		flowtable f {
>  			hook ingress priority 0; devices =3D { eth0, eth1 };
>  			flags offload;
>  		}
> -		...
>  	}
> =20
>  There is a workqueue that adds the flows to the hardware. Note that a few

Thanks.

I will add this into linux-next today and will drop it when it (or
something similar) turns up in a tree.

--=20
Cheers,
Stephen Rothwell

--Sig_/qi8okD35u_F2N8iA8jH_7Fl
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmBdMwkACgkQAVBC80lX
0GwW7wf+L2B55xZsqVRw1SA0MWwZpNSA7R9e6VwLMAuNobkRBmckkR+bszDHRb9f
20hYGFOcjvnhfljiXWHpItDTqWgYrMk5Uu53RQo1u6dmYe8PILkp8x4yjCEhO7Xm
PmsrVTZGvOq5d6/xo0Yf53TdFBR4R0mil0u4i0t3jHjEFspzkxRX7Jad3V4lhWq/
NuJPywxEMqkgxr+nwmaO3IPSAFDT60DJNYk9Prn0Gr954kgdMPHIE3B+VsYqRM+r
l5rNkYqRADQechgXbnQqUD+sCwbEkQK4imBVXHFnZtn4HhfERH24ID1rKpQW6o+k
Qxm2gvM7MRhuVwyApWhb2VbdPguePQ==
=zPOU
-----END PGP SIGNATURE-----

--Sig_/qi8okD35u_F2N8iA8jH_7Fl--
