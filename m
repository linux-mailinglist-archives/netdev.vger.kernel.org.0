Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 086B92D585B
	for <lists+netdev@lfdr.de>; Thu, 10 Dec 2020 11:40:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387506AbgLJKjK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Dec 2020 05:39:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726263AbgLJKjG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Dec 2020 05:39:06 -0500
Received: from ozlabs.org (ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42467C0613D6;
        Thu, 10 Dec 2020 02:38:26 -0800 (PST)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4Cs9PD0YcSz9sWR;
        Thu, 10 Dec 2020 21:38:24 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1607596704;
        bh=LfXiCxTtAcslkE8nWPtU0ldZUAFturQ0vHpoOyftGz4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=FrUyVFCbzaeBYFaTy6btJfKPzkP0O1w+U4SqHxkfWfa0U4IlRUOrk3oKzIN1By9IO
         BIrdZBeOVSvMk8eqViwq1SsD9gTnb+O9ld3VdIW78GWmXs2tWBIUUXi5Zu9FlQCyEk
         bMFVnhC7gixgQFRUuRkD7sgnYGC+bx9kzWIwKQ8hmwkjBxDhN5+7hwiELrTm3SXav5
         K7YM9YcgYumX//Jvt5lbu7K7bF/zMO26ggfpKJAjPNH/0mScgrAwf2UKiOGEbzcZV4
         fgsY2C/s3My7z549DcqXWNGVCS4v7xZxVlCZxYGwv78B2eSdenFMBBvbDUt76IduLL
         WFT+PIp5p9NyQ==
Date:   Thu, 10 Dec 2020 21:38:22 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: Re: linux-next: Signed-off-by missing for commit in the net-next
 tree
Message-ID: <20201210213822.4b8998cd@canb.auug.org.au>
In-Reply-To: <20201210213713.05fec230@canb.auug.org.au>
References: <20201210213713.05fec230@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/ennD_EM6VRN4E7B+BrSpvU.";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/ennD_EM6VRN4E7B+BrSpvU.
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

On Thu, 10 Dec 2020 21:37:13 +1100 Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
>
> Commit
>=20
>   5137d303659d ("net: flow_offload: Fix memory leak for indirect flow blo=
ck")
>=20
> is missing a Signed-off-by from its committer.

Sorry, that is in the net tree (not net-next).

--=20
Cheers,
Stephen Rothwell

--Sig_/ennD_EM6VRN4E7B+BrSpvU.
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl/R+p4ACgkQAVBC80lX
0Gzkawf+MkSP8nIEDpkyhlr39EBN65Ubi2lLe43q+8KbqcUp9xeARxlMq7NSCxI9
t2fvPpLHBBIcqHzvUA0CQjaSsspxlKqatiY1CZGKIdzHD++1gbHMdPjF7JoXRxZ5
vhWObcpsCBEDyVh0wB3Re96mxGGyVTKPZjtvbjvlFPm522DAJfh3/ZN09OTVnlnS
M12V14CHoBr2tYtu5tRGyhGQHnhefT4swA0lhi/u1NxPukgJydgPTznYUBbeUufI
4i77o2XCfVzYculJp8JqBGzGEWTij7n7dngvB26jEs7io438DVfecD68s/dRAlyR
oaHGoXuFz7QMxTPu63ysBRpcjb0lPQ==
=/2fi
-----END PGP SIGNATURE-----

--Sig_/ennD_EM6VRN4E7B+BrSpvU.--
