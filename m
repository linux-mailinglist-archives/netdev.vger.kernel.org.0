Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9807916047A
	for <lists+netdev@lfdr.de>; Sun, 16 Feb 2020 16:23:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728355AbgBPPW7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Feb 2020 10:22:59 -0500
Received: from dvalin.narfation.org ([213.160.73.56]:58292 "EHLO
        dvalin.narfation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726171AbgBPPW6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Feb 2020 10:22:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=narfation.org;
        s=20121; t=1581866575;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=cpdOcA58injpURGtSPsNzFe0grHOYuzlAQi9FRcp3jo=;
        b=HW6kDIwYOmPotOs48kEhWYO6IC8mZ4g7oYDcPbeZ5p5A78FImbNhEKtyOqVoKz4Fz+zSaj
        F4i1vN0uJyypV2ECTLzN7RO4t2SSlFVaib0Ksp6iNROmpNDeGMOlRjbRKWfuSVck4cU0xg
        aTlFELlnV5CmO2IQlr1kvQ83MYofsQ8=
From:   Sven Eckelmann <sven@narfation.org>
To:     madhuparnabhowmik10@gmail.com
Cc:     mareklindner@neomailbox.ch, sw@simonwunderlich.de, a@unstable.cc,
        davem@davemloft.net, b.a.t.m.a.n@lists.open-mesh.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        joel@joelfernandes.org, frextrite@gmail.com,
        linux-kernel-mentees@lists.linuxfoundation.org
Subject: Re: [PATCH] net: batman-adv: Use built-in RCU list checking
Date:   Sun, 16 Feb 2020 16:22:51 +0100
Message-ID: <3655191.udZcvKk8tv@sven-edge>
In-Reply-To: <20200216144718.2841-1-madhuparnabhowmik10@gmail.com>
References: <20200216144718.2841-1-madhuparnabhowmik10@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart4752270.j9do8LSKhE"; micalg="pgp-sha512"; protocol="application/pgp-signature"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--nextPart4752270.j9do8LSKhE
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

On Sunday, 16 February 2020 15:47:18 CET madhuparnabhowmik10@gmail.com wrote:
> From: Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>
> 
> hlist_for_each_entry_rcu() has built-in RCU and lock checking.
> 
> Pass cond argument to hlist_for_each_entry_rcu() to silence
> false lockdep warnings when CONFIG_PROVE_RCU_LIST is enabled
> by default.
> 
> Signed-off-by: Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>
> ---
>  net/batman-adv/translation-table.c | 12 ++++++++----
>  1 file changed, 8 insertions(+), 4 deletions(-)

Added with alignment and line length codingstyle fixes [1].

Can you tell us how you've identified these four hlist_for_each_entry_rcu?

Thanks,
	Sven

[1] https://git.open-mesh.org/linux-merge.git/commit/967709ec53a07d1bccbc3716f7e979d3103bd7c5

--nextPart4752270.j9do8LSKhE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEF10rh2Elc9zjMuACXYcKB8Eme0YFAl5JXksACgkQXYcKB8Em
e0ZGNBAAxAZydcMX765z0LHHxzM2VVRThEsnS17DaDQDU7oTIinL6xe83lBPbQuh
zQDyZUlFlz5UDRbHnq2w/UMmq/haEXfp47se+S4GOsg7M4R38P8XC97XC1BlTOGu
oXyJjOp2d3G3awn6GD4G1P8AVCkVc8gVp6pDFNFy7OVfJwXvYbMaCtH8xXhS2pcK
c3oO+roFvXtBMCb44e8lc0xHRrBUiTBBIKoLcJSbPUmDRSOg70Rojk5AmiMIZ7Ts
UbNC1faFYh2HJlc+b/b7jDx69eopdxRMQOxZeypmDtu3HnJTQEK/5b/gB00Ajs4e
RDJyOimN1ri/2DI5hMWpJyYts/uutSDHDwRwXytVsoUS3vMVE17LWTn/mTBu5m2n
qodGmZbrbLKM2aMYU9b5aCtJlAoZ5osEd3UbL0zDE0TZG+x8orzffsQagMaihcez
Ybny70xUDlZgGBzTCuCGNhBN7CkREdHiBUNg+Ff02xx5uQTvpN9Pxgo4g+bXXlPs
rDspCwY+EC+KWURxdnVPO4x5tSRmzq4gKvL0dMBeiz06m+u1zK+DCQ0lodV76bY1
ILPm/EwMGiMdO8h5IlwJh5w7T+Kgl+PnT8vwRLXFjfgpYf24D3ihw/1uDLGk7t4Q
W1mipeOUSdpfDYNF8mTqJ48vhSlJf0zICr9iY0p+hmwAnPcCEfA=
=2x+h
-----END PGP SIGNATURE-----

--nextPart4752270.j9do8LSKhE--



