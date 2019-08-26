Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B3D3C9CB39
	for <lists+netdev@lfdr.de>; Mon, 26 Aug 2019 10:03:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730203AbfHZIDf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Aug 2019 04:03:35 -0400
Received: from mga12.intel.com ([192.55.52.136]:48992 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726189AbfHZIDf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 26 Aug 2019 04:03:35 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 26 Aug 2019 01:03:34 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,431,1559545200"; 
   d="asc'?scan'208";a="196998739"
Received: from sjolley-mobl.amr.corp.intel.com ([10.254.178.147])
  by fmsmga001.fm.intel.com with ESMTP; 26 Aug 2019 01:03:34 -0700
Message-ID: <c2279a78904b581924894b712403299903eacbfc.camel@intel.com>
Subject: Re: [PATCH] net: intel: Cleanup e1000 - add space between }}
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     Forrest Fleming <ffleming@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Mon, 26 Aug 2019 01:03:33 -0700
In-Reply-To: <20190823191421.3318-1-ffleming@gmail.com>
References: <20190823191421.3318-1-ffleming@gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
        protocol="application/pgp-signature"; boundary="=-+SaW8iJuTsbssO2+QFx8"
User-Agent: Evolution 3.32.4 (3.32.4-1.fc30) 
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--=-+SaW8iJuTsbssO2+QFx8
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2019-08-23 at 19:14 +0000, Forrest Fleming wrote:
> suggested by checkpatch
>=20
> Signed-off-by: Forrest Fleming <ffleming@gmail.com>
> ---
>  .../net/ethernet/intel/e1000/e1000_param.c    | 28 +++++++++----------
>  1 file changed, 14 insertions(+), 14 deletions(-)

While I do not see an issue with this change, I wonder how important it is
to make such a change.  Especially since most of the hardware supported by
this driver is not available for testing.  In addition, this is one
suggested change by checkpatch.pl that I personally do not agree with.

This is not a hard NAK, but you have to explain how this change makes the
code more readable before I consider it.

--=-+SaW8iJuTsbssO2+QFx8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEiTyZWz+nnTrOJ1LZ5W/vlVpL7c4FAl1jklUACgkQ5W/vlVpL
7c7hHg/+NAXAeuMjDZxOZq/wxvvj915GMyFGhtxIHKvbyYMLDU1m2AMHXzvBamyb
qhYKGFYjTD5OsbqvHCKaZ4KxjMgiNGxfrDnLD3JPgyrEGKMICpU87Ec49tfRhLo7
Jj7+IetakkcwLGnNoi2ZeumsfybLvjrtJGZS+QC66QRXqD8TeIuoEDleRDSs9sMp
6CVb5m0ZGQAbEk0Kpso1CwdoEqQ0LdN27dQbTi8ix5wCcQ1HJnOjBUDvTzsfp2cS
L5TlNViQ4GhfJkkR2PDsI2Svh1XJd1w4U3PMDRHx4Bu6MajAFcKxGoFgfbizpP5C
CtGGiCN91RuI87eUfpWvpFsIOM4wm4EULYMSEgPn7TuUBB3CweNafpGJnDmtiqGD
dj2+AOYtmKoKFbatNBhl9zIEMU76vW54gshX5CaWToCFJeFAqagrgoWdrOM4vWIM
rMcz/hgTvxU40ad3ZJ0kCcSy+j/JTF8JRG9sBYaymoJnxMCT6jeFI6R9fIhRqMA3
QEpuEElGSnpvD7Up7z1Sd7oE4wJlLYbAEwZqn/+rwGIk6d0PZmHH3ZixFI/HYemt
qji8KltUM/QHM0jaXeLiPBq3RJlt/4qs6x8LV9k1zuLRL0GuXQs1Wu1PX2pNDLZU
jataaHMp0uFKLkWwR2metAyY9mwHKdJgV7pO2/MAb2AKVJF2HqA=
=pzql
-----END PGP SIGNATURE-----

--=-+SaW8iJuTsbssO2+QFx8--

