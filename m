Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3D3FF9F2D9
	for <lists+netdev@lfdr.de>; Tue, 27 Aug 2019 21:02:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731097AbfH0TCZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Aug 2019 15:02:25 -0400
Received: from mga07.intel.com ([134.134.136.100]:43553 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731077AbfH0TCY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 27 Aug 2019 15:02:24 -0400
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 27 Aug 2019 12:02:23 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,438,1559545200"; 
   d="asc'?scan'208";a="182883162"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by orsmga003.jf.intel.com with ESMTP; 27 Aug 2019 12:02:23 -0700
Message-ID: <c40b4043424055fc4dae97771bb46c8ab15c6230.camel@intel.com>
Subject: Re: [PATCH] net: intel: Cleanup e1000 - add space between }}
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Reply-To: jeffrey.t.kirsher@intel.com
To:     Joe Perches <joe@perches.com>,
        Forrest Fleming <ffleming@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Tue, 27 Aug 2019 12:02:23 -0700
In-Reply-To: <877726fc009ee5ffde50e589d332db90c9695f06.camel@perches.com>
References: <20190823191421.3318-1-ffleming@gmail.com>
         <c2279a78904b581924894b712403299903eacbfc.camel@intel.com>
         <877726fc009ee5ffde50e589d332db90c9695f06.camel@perches.com>
Organization: Intel
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-PzZZlzhczhl8y9zxLvXV"
User-Agent: Evolution 3.32.4 (3.32.4-1.fc30) 
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--=-PzZZlzhczhl8y9zxLvXV
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

Agreed, have you already submitted a formal patch Joe with the
suggested change below?  If so, I will ACK it.

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


--=-PzZZlzhczhl8y9zxLvXV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEiTyZWz+nnTrOJ1LZ5W/vlVpL7c4FAl1lfj8ACgkQ5W/vlVpL
7c42BA//Z9SlWegHrA18nOZaU+Swr64eNrhWPo/WZ7Gm0zFEVzWcLNtltCqD9Jtl
CfJUYiVbQpQRrJFUqAQkqo43yDNwykuwY8ephV6SYYC2aIdFZY+1XOWgfaFbMHA3
fdK06+voblQ3BpvqLnJqkEyxd+F2mkJe8EqKwcPXOqC7dusUxtn102tJzmoafSsS
gSicmyu+U0eUmZcntnshQrpLIwIFA6QkTyRr/tPXQ9vMYjdnTd+suskSAdK7KTvv
IS6IZg0csmaeyzqu9crXeSUgYcy2clM+Izogg83fyDOAB0VTg5dE/HWqp47osQEd
Xphj+7sYBuTjtW6zFUfydNUuHNQZw7gVj4+7W3LF7axLcusAanbJD8xrM/J4v7Rr
vHDnr04u9RTklkgVn0M2OskGqpHR4g4xwbkpYvQzU5yVPz7NrZDjpPQSJf02neBx
P2HW//gQL1+s7u2a9XWyJew3tbGrKbGsSH/xccUSSS/GoFEL5O4SK3fV1fQEwDGI
HGXsFQ1XEPndPix7srpRJRCMMOT/J3PmoOywkvEnNFr6xmhrdyyCkCAFDkCy6Db5
fNb6ypzROM0gXyiiBWUf/E42fLpL4t6t8R9k42XKAZtb39Uo5DIIWnfVmtw/1I9e
zaEr8EJ6pQ7qCgCYH8uzjnezC97IF8QluOaO+LYlyoVSj/G1MXk=
=Jk5o
-----END PGP SIGNATURE-----

--=-PzZZlzhczhl8y9zxLvXV--

