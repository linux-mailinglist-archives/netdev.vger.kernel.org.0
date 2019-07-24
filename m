Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6B44174132
	for <lists+netdev@lfdr.de>; Thu, 25 Jul 2019 00:02:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729203AbfGXWCY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jul 2019 18:02:24 -0400
Received: from mga03.intel.com ([134.134.136.65]:45814 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726650AbfGXWCX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Jul 2019 18:02:23 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 24 Jul 2019 15:02:23 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,304,1559545200"; 
   d="asc'?scan'208";a="172441550"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by orsmga003.jf.intel.com with ESMTP; 24 Jul 2019 15:02:23 -0700
Message-ID: <8749f22284c5a557fe50a5dcc956c5d2c80037e2.camel@intel.com>
Subject: Re: [PATCH -next v2] net/ixgbevf: fix a compilation error of
 skb_frag_t
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Reply-To: jeffrey.t.kirsher@intel.com
To:     David Miller <davem@davemloft.net>
Cc:     cai@lca.pw, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Wed, 24 Jul 2019 15:02:15 -0700
In-Reply-To: <20190724.144143.2055459359936675888.davem@davemloft.net>
References: <1563985079-12888-1-git-send-email-cai@lca.pw>
         <4b5abf35a7b78ceae788ad7c2609d84dd33e5e9e.camel@intel.com>
         <20190724.144143.2055459359936675888.davem@davemloft.net>
Organization: Intel
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-Gz9UtU6Pj0HFK7rfLGou"
User-Agent: Evolution 3.32.4 (3.32.4-1.fc30) 
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--=-Gz9UtU6Pj0HFK7rfLGou
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2019-07-24 at 14:41 -0700, David Miller wrote:
> From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
> Date: Wed, 24 Jul 2019 09:39:26 -0700
>=20
> > Dave I will pick this up and add it to my queue.
>=20
> How soon will you get that to me?  The sooner this build fix is cured
> the
> better.

Go ahead and pick it up, I was able to get it through an initial round
of testing with no issues.  No need to wait for me to re-send it, I
will go ahead and ACK Qian's patch.

--=-Gz9UtU6Pj0HFK7rfLGou
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEiTyZWz+nnTrOJ1LZ5W/vlVpL7c4FAl041WcACgkQ5W/vlVpL
7c4fMA//S5prkLGo97EbfSUqrK04t0UnIyZSneQ9H15GLOTLfbiHKYXCmf19XVnZ
AudEDdX9roC0m0lV/BLW8TjgS2t2NIHZVFZ6QB+8ZIjmLfEJVXOU59o/f57MrUyA
rOVKLobh1olXgCI/u06polw05x0YUNZheWBl3DDlxndy4oG7pCy4xMp4d7clmulX
j0OB+V9mKtDziVu1PQDxvf0pBphCUjD16cAYFryns50S1/STnk0v01M2qwJOQ3O8
nrctw52HsQLcq+9hp2awaFihc0nu07apoV2VilKznofpq4Aw33YTXDJAmy+5+CKs
z0lThriYj0E/vfZVt24Hdhw+nu8kUQd6s1bDYXLEKS8UZfyS4uXtHem8LrJUXT5g
TOviLVWqceBgPJdhuyRrR2VsRlBOJkRR+Tyun87cN6+EJx1JW5OjaFETcP8Ln1FV
rbxw/BC6meLbFwcWWY5AffKjRiAPuCN9bVkU2iryhdzYBVYj1iVXes56UXej4nNL
W3u+LJTeh26Q3mGZzndBe4V/7x3TON4gaKzn+AiQeBHVAeUScFMVVIX7K9TqHWCq
3Dm8xfbNrKBaA2KwCpBBKNMicLVg0xZr7WemgJAZv2R/3U7YTKlMiON08rSleOmW
jYgrqJ60aetFxMuFaM5gVFeFKkEYbUpYkF1F+hSxQMNg3eJe7Js=
=67+g
-----END PGP SIGNATURE-----

--=-Gz9UtU6Pj0HFK7rfLGou--

