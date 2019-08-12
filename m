Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 182178A2A0
	for <lists+netdev@lfdr.de>; Mon, 12 Aug 2019 17:49:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726267AbfHLPsz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Aug 2019 11:48:55 -0400
Received: from mga14.intel.com ([192.55.52.115]:47861 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725822AbfHLPsy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Aug 2019 11:48:54 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 12 Aug 2019 08:48:54 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,377,1559545200"; 
   d="asc'?scan'208";a="327390767"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by orsmga004.jf.intel.com with ESMTP; 12 Aug 2019 08:48:53 -0700
Message-ID: <016fd56f6128723b6112f1dfe938c9c641e422dc.camel@intel.com>
Subject: Re: [PATCH v3 15/17] i40e: no need to check return value of
 debugfs_create functions
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Reply-To: jeffrey.t.kirsher@intel.com
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        intel-wired-lan@lists.osuosl.org
Date:   Mon, 12 Aug 2019 08:48:53 -0700
In-Reply-To: <20190810101732.26612-16-gregkh@linuxfoundation.org>
References: <20190810101732.26612-1-gregkh@linuxfoundation.org>
         <20190810101732.26612-16-gregkh@linuxfoundation.org>
Organization: Intel
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-gpvAGt0BDOe1HuoxIctz"
User-Agent: Evolution 3.32.4 (3.32.4-1.fc30) 
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--=-gpvAGt0BDOe1HuoxIctz
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, 2019-08-10 at 12:17 +0200, Greg Kroah-Hartman wrote:
> When calling debugfs functions, there is no need to ever check the
> return value.  The function can work or not, but the code logic
> should
> never do something different based on this.
>=20
> Cc: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: intel-wired-lan@lists.osuosl.org
> Cc: netdev@vger.kernel.org
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

Acked-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>

> ---
>  .../net/ethernet/intel/i40e/i40e_debugfs.c    | 22 ++++-------------
> --
>  1 file changed, 4 insertions(+), 18 deletions(-)


--=-gpvAGt0BDOe1HuoxIctz
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEiTyZWz+nnTrOJ1LZ5W/vlVpL7c4FAl1RimUACgkQ5W/vlVpL
7c763Q/+OSDQpuPnOE7cSF2ADx/seyiELQQz1zWAMcP/cBXw05nyrDVp6OVnhzJt
eUQo902CfmFi2aLJwr4nv2V01/iiXPQigtq7zRXfAti6xcwq9o3bil7o9nsiIX9I
J+CzUySEe+8o2vnb9DmxncwKcwTamJ4Bm60sKO2IZ4L26kZWLk8IzExou6D9p01a
KCMnb/EkZOufqnB68mOe5Yss4hxqtPJIqY+UzjvmAoLEHmTASI8mNZ+dOjTOmpAE
4b/qg9T4LInDdUYjGHIQCpnh61vJLiU0R+VtAtLQwGDS9Q+Oxtndo4wsiAxYnfRR
GSjqbAFsIfy432PQG30EwFgGb7Vq9REPMHOMJYXViKuUeluVbF9voSMC9HVaJ/xg
7yDssWwIDb9ylkpjpiVAdoo5jCZ+NAqLUMCAnLcr5/u82O+A/hq8QCUfGZMYN10e
HVO7ZlUtJA1la81MU3ZxYcNprhcWtZK63Tvbg2h5TMmGJyolTVBlk1U4SFdsmDrl
9BPj5wjLDvcZymAIdBPK+oNUj4R7vyK3yoCqAsC7q4735L2tkcljkw38+BtTerRO
xWya/3J97ezf2U6fp61VfSbThI0Msqi2eVySxVDqUjiK3Kc+Ml1Ou0LsJa6nt9D/
h75LaxXiK1YIiSi7m6cJwrkcKt7JyZtr+XeiyCRJcmp9bpPEYbg=
=EyOA
-----END PGP SIGNATURE-----

--=-gpvAGt0BDOe1HuoxIctz--

