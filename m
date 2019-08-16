Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 42FE7903FC
	for <lists+netdev@lfdr.de>; Fri, 16 Aug 2019 16:31:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727359AbfHPObe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Aug 2019 10:31:34 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:50135 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727245AbfHPObd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 16 Aug 2019 10:31:33 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4695Nd21HCz9sN1;
        Sat, 17 Aug 2019 00:31:29 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1565965890;
        bh=2iRYX7jfBSRcApAbDixoo0BxgKjwKEbNC9aG5ULUoZM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=tAerOc88l1hx8EFyxGITEtlqGZPIK9IJpG0gMQJWDwkAJBzqjfCGwIy62f0lXZUFc
         n3Rwr9Wz4pUWsBf5AK/qTBCvMm3Rvw0y99WMeMj7fG+OqsBzFk19LCCccMsBwEdo0h
         sDRftVk55z7faozAHOgDWixuaxYQbFZJsGuL2g1W3SNTq/T8lBuyNkyMTyz6DZiRbT
         oLEnAQdy8a3b1kUacZg4mpzNGYqjIRmF/6h8uk07UhDXJEq0GgnG70R61+7QWmoFLm
         ElGOw3zRYDluqdzP/D3DnBpwE5QjEx98q2u8alqPDq8K5EBlDJOQq1XUSBWfcGHqH2
         kkembZYmp74Xg==
Date:   Sat, 17 Aug 2019 00:31:24 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Gerd Rausch <gerd.rausch@oracle.com>
Cc:     Andy Grover <andy@groveronline.com>,
        David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>, Chris Mason <clm@fb.com>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andy Grover <andy.grover@oracle.com>,
        Chris Mason <chris.mason@oracle.com>
Subject: Re: linux-next: Signed-off-by missing for commits in the net-next
 tree
Message-ID: <20190817003124.0229ed5e@canb.auug.org.au>
In-Reply-To: <15078f1f-a036-2a54-1a07-9197f81bd58f@oracle.com>
References: <20190816075312.64959223@canb.auug.org.au>
        <8fd20efa-8e3d-eca2-8adf-897428a2f9ad@oracle.com>
        <e85146f3-93a0-b23f-6a6e-11e42815946d@groveronline.com>
        <15078f1f-a036-2a54-1a07-9197f81bd58f@oracle.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/tM.s=t/oyS.VH_y4PVWIpUJ";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/tM.s=t/oyS.VH_y4PVWIpUJ
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

On Fri, 16 Aug 2019 07:10:34 -0700 Gerd Rausch <gerd.rausch@oracle.com> wro=
te:
>
> On 16/08/2019 02.15, Andy Grover wrote:
> > On 8/16/19 3:06 PM, Gerd Rausch wrote: =20
> >>
> >> Just added the e-mail addresses I found using a simple "google search",
> >> in order to reach out to the original authors of these commits:
> >> Chris Mason and Andy Grover.
> >>
> >> I'm hoping they still remember their work from 7-8 years ago. =20
> >=20
> > Yes looks like what I was working on. What did you need from me? It's
> > too late to amend the commitlogs...

Yeah, Dave doesn't rebase his trees.

> I'll let Stephen or David respond to what (if any) action is necessary.
>=20
> The missing Signed-off-by was pointed out to me by Stephen yesterday.
>=20
> Hence I tried to locate you guys to pull you into the loop in order to
> not leave his concern unanswered.

It is OK for SOBs to be missing, I just wanted to make sure that it was
OK in this instance.  (Its better that I ask when its OK then not to
ask and find something has gone wrong.)

--=20
Cheers,
Stephen Rothwell

--Sig_/tM.s=t/oyS.VH_y4PVWIpUJ
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl1WvjwACgkQAVBC80lX
0GxkZgf+K+HspxKdrXDdlSTnUKcU7KW869GIDYqdUeVFdegpsUn1N+TKaQOMhPbP
R1YjmIBnC0R/9Q2hG9i2BIHy0e5zritvVCFg1j1cJ5zZJQ6e8WdIir8XX1AR76Z8
/olEI9gCgv4Njnm9O9NY4OG9eADGKg4teGyovvgQL8QNIzvIS+q8ebRwxajoE1+U
Ruz1NW2YZAkYH4xixfMpVNBhJ049dzueU3BuMT1VQ6+0r7phK38UHtdU7PJTPtbs
sBY9YVd5HWZyk9TJLOy6hn96E8pHgnz6OC5vNUH16W20eFxg2s4wwHB4vQIyuyrO
4LSBlLuDqTXYNqWiX0zCN/BdUgvDCw==
=/Q+q
-----END PGP SIGNATURE-----

--Sig_/tM.s=t/oyS.VH_y4PVWIpUJ--
