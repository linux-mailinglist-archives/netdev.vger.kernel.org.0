Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E3B5C9F413
	for <lists+netdev@lfdr.de>; Tue, 27 Aug 2019 22:27:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731366AbfH0U1a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Aug 2019 16:27:30 -0400
Received: from mga03.intel.com ([134.134.136.65]:56114 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726871AbfH0U1a (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 27 Aug 2019 16:27:30 -0400
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 27 Aug 2019 13:27:29 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,438,1559545200"; 
   d="asc'?scan'208";a="171315729"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by orsmga007.jf.intel.com with ESMTP; 27 Aug 2019 13:27:29 -0700
Message-ID: <b85dcabca674255c806490db762bd4e8483db575.camel@intel.com>
Subject: Re: [PATCH] net: intel: Cleanup e1000 - add space between }}
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Reply-To: jeffrey.t.kirsher@intel.com
To:     Joe Perches <joe@perches.com>,
        Forrest Fleming <ffleming@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Tue, 27 Aug 2019 13:27:29 -0700
In-Reply-To: <877726fc009ee5ffde50e589d332db90c9695f06.camel@perches.com>
References: <20190823191421.3318-1-ffleming@gmail.com>
         <c2279a78904b581924894b712403299903eacbfc.camel@intel.com>
         <877726fc009ee5ffde50e589d332db90c9695f06.camel@perches.com>
Organization: Intel
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-YmTzQXEbwTH2qCEhzGh1"
User-Agent: Evolution 3.32.4 (3.32.4-1.fc30) 
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--=-YmTzQXEbwTH2qCEhzGh1
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2019-08-26 at 20:41 -0700, Joe Perches wrote:
> On Mon, 2019-08-26 at 01:03 -0700, Jeff Kirsher wrote:
> > On Fri, 2019-08-23 at 19:14 +0000, Forrest Fleming wrote:
> > > suggested by checkpatch
> > >=20
> > > Signed-off-by: Forrest Fleming <ffleming@gmail.com>
> > > ---
> > >  .../net/ethernet/intel/e1000/e1000_param.c    | 28 +++++++++--
> > > --------
> > >  1 file changed, 14 insertions(+), 14 deletions(-)
> >=20
> > While I do not see an issue with this change, I wonder how
> > important it is
> > to make such a change.  Especially since most of the hardware
> > supported by
> > this driver is not available for testing.  In addition, this is one
> > suggested change by checkpatch.pl that I personally do not agree
> > with.
>=20
> I think checkpatch should allow consecutive }}.

Acked-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>

>=20
> Maybe:
> ---
> diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
> index 287fe73688f0..ac5e0f06e1af 100755
> --- a/scripts/checkpatch.pl
> +++ b/scripts/checkpatch.pl
> @@ -4687,7 +4687,7 @@ sub process {
> =20
>  # closing brace should have a space following it when it has
> anything
>  # on the line
> -		if ($line =3D~ /}(?!(?:,|;|\)))\S/) {
> +		if ($line =3D~ /}(?!(?:,|;|\)|\}))\S/) {
>  			if (ERROR("SPACING",
>  				  "space required after that close
> brace '}'\n" . $herecurr) &&
>  			    $fix) {
>=20
>=20


--=-YmTzQXEbwTH2qCEhzGh1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEiTyZWz+nnTrOJ1LZ5W/vlVpL7c4FAl1lkjEACgkQ5W/vlVpL
7c70dA//TBdhCFVY4W6lcn7qyR2v4ZCGN7FL/v/TUItJZt5NFKWWTv8f5VuR281s
k1eCdRHzK0ZSibKg2cveB/ziqBJCy+xvZqxn+SrLl/viW5qEKZkf7cvr/z4+AaSv
ovU+aiUkeL23F+fiDCCprYHI/fA5hkcbcIzLS6t/Cn+1PhQTHc4RUqciKRTmu3c7
OIbPHEN0H5uFFYPSObCwJaGsVp02GsufyVu0hRvPVvhSx5hiIISO7PH5/6a5Ru3B
4xvhk6T+TxtkUW2/pZCT/6LlhPeBZZjjSn7BqE5fxSq0ZMiCksRDnDjR2kCxRYJp
T46pokeAR2r9x6FPCWuSJ/fe2UgNDrOLWRRNOsm3RsBLU435xJ8Riu2n5LMWfqCC
9rWOu/nNx4cjOyf3NR4GeIDUaVfzUIkfeUc8zV7yswJbu5Y3JWo5P4ApqS7rCxfM
ipOn5+ROL1oj0cGhGmcWlFJxLbGj/JKybuJswJXxkAaFQMby+ITGxhLiIfNPwx5P
XVu/HYCGPG/dEFCU+9vXEgkO1ZzkUFN/GUFQ/1a1mkvmwJYTymPkvOb3ssByNMTC
D8zhOp0Pv0qrgTTdfitYEsMa8gdrWX0mhLTjYVshC6cAWgEkVsmKgiyw2C6ryvwK
wsYciMmCHxGm8+RA6KoTFlFm2RBeLNAhBmKuBZtALV0SaPS1YC8=
=27iJ
-----END PGP SIGNATURE-----

--=-YmTzQXEbwTH2qCEhzGh1--

