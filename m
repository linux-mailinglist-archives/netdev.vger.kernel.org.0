Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9662630EDB0
	for <lists+netdev@lfdr.de>; Thu,  4 Feb 2021 08:49:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234748AbhBDHst (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Feb 2021 02:48:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234332AbhBDHss (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Feb 2021 02:48:48 -0500
X-Greylist: delayed 346 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 03 Feb 2021 23:48:08 PST
Received: from dvalin.narfation.org (dvalin.narfation.org [IPv6:2a00:17d8:100::8b1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08C3CC061573
        for <netdev@vger.kernel.org>; Wed,  3 Feb 2021 23:48:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=narfation.org;
        s=20121; t=1612424496;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=G8fxAye0RXSpCFcWu/4DcBtwUbbvF2pEmgEMXyW4YF0=;
        b=NwRKlCjBe/IY00raVpJA0mkhgDftqrONbBgXDjL71YHyTk6oNzq8DUxB3d3afbHRGa6RjW
        K943sfAqJLSxewW80ahBmbCraLw4s9Mgxw8f524PSJL6gRmK4i1QZOz5F3P51VF75c2roQ
        qQrdj0Q2HASk3szVjtXGvZcK5vJMZus=
From:   Sven Eckelmann <sven@narfation.org>
To:     Simon Wunderlich <sw@simonwunderlich.de>,
        b.a.t.m.a.n@lists.open-mesh.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        b.a.t.m.a.n@lists.open-mesh.org, Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH 1/4] batman-adv: Start new development cycle
Date:   Thu, 04 Feb 2021 08:41:24 +0100
Message-ID: <2833533.ujcMDckppk@ripper>
In-Reply-To: <20210203163302.13e8a2a7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20210202174037.7081-1-sw@simonwunderlich.de> <20210202174037.7081-2-sw@simonwunderlich.de> <20210203163302.13e8a2a7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart3413650.uM9juBY1BO"; micalg="pgp-sha512"; protocol="application/pgp-signature"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--nextPart3413650.uM9juBY1BO
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"; protected-headers="v1"
From: Sven Eckelmann <sven@narfation.org>
To: Simon Wunderlich <sw@simonwunderlich.de>, b.a.t.m.a.n@lists.open-mesh.org
Cc: davem@davemloft.net, netdev@vger.kernel.org, b.a.t.m.a.n@lists.open-mesh.org, Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH 1/4] batman-adv: Start new development cycle
Date: Thu, 04 Feb 2021 08:41:24 +0100
Message-ID: <2833533.ujcMDckppk@ripper>
In-Reply-To: <20210203163302.13e8a2a7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20210202174037.7081-1-sw@simonwunderlich.de> <20210202174037.7081-2-sw@simonwunderlich.de> <20210203163302.13e8a2a7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>

On Thursday, 4 February 2021 01:33:02 CET Jakub Kicinski wrote:
[...]
> For just comment adjustments and the sizeof() change?

The process is basically:

1. update the version information for a development period
2. queue up whatever comes in during that time
3. send it to netdev for net-next when it seems to be ready

The first step is not influenced by the 2.+3. step. So the development 
effort is not reflected in the version number.

Kind regards,
	Sven
--nextPart3413650.uM9juBY1BO
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEF10rh2Elc9zjMuACXYcKB8Eme0YFAmAbpSQACgkQXYcKB8Em
e0aJQA/6A1TAaQ5N2HfD9Y0+CLbPpq7IREDN0a7qQiX8AIbFkaC9MQa8szAY/BEt
y0n4g7umhcBs+RT78lgqocXQc7HWDjeVwM5EFqR3FaAH6fWpDOtOTSsiNIP66QIe
97JeoZaZrchTIC5we6gG2NTlQqzj2Al0AzWpFq9UR+UPKHhrT7CHr7lZ8Qx1tZPU
fkVIPDr2cdK0Z5WoPf+cVo6EsBdPHNqBtU3pNnJ/BwWJgHGM2ABQMMfLWJMmVtvs
koiulH8k3dfrcHDxbaIzma2pwyB3JqZ8OKqPq4cpQ8b1QIvzLndrXVICBKv2wXfK
RVUZwfO4cLT1RuC1FnXUWJRpIcyrirmCxvUXz27SeMOD8SyMke2l3PhaU9Nz6G7P
pSPcZmLTofjVDByZ2NzZrMzneKCEj4z5kW1TvSXqzTBwsVyiWnW96SayE2txGaVE
pLwcCK4larojhyg6zAF1WoeOVPz8zZd9IRXrfQ/0tVD2UzZKJv5x//y5cVV0PvDM
ydPwlq2hJo6rrXG7L0ES5l0oaGEumf0aOLnkguxCNki3p04wuifGWtGq35pTh30c
Moe/4DslMD+H5s0y14UFDP+Kelda2TvMRB7attN2QhoOkPbi+q2Qh4scqOqlL3vr
N3PCY67t5DccynMz9YevRYt6KsFpkksu0r9ONrRgRhCvPJGyv/8=
=4QMF
-----END PGP SIGNATURE-----

--nextPart3413650.uM9juBY1BO--



