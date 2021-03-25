Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BBC6348944
	for <lists+netdev@lfdr.de>; Thu, 25 Mar 2021 07:41:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229758AbhCYGk6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 02:40:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229533AbhCYGku (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Mar 2021 02:40:50 -0400
Received: from ozlabs.org (ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBD8FC06174A;
        Wed, 24 Mar 2021 23:40:49 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4F5b8Z6Rh6z9sSC;
        Thu, 25 Mar 2021 17:40:45 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1616654447;
        bh=g4TrAOvJgSqBt+vYztTkQx5gJSlLCKz4mDOXv1Cztuc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=YQTngpjkVncrPPxpHCJxMo4oylbcG9axkA3VQm/0CFWdEgAJ13O1+7db7jhp6qMeU
         QO0175xxe65uNee1popGk29zb/K/5g1r0iQsKDLLc+ryKAbNXO0qOqP0YNxTMRh7VG
         B+3hHkx6DPxn7RPAf8OVQxghT3yK2BkXslFy4r9KkFpo2iFEcOG+bG1nuom3J04/E1
         /mZ/aY98qUTvsR45BjonemdVTQ1suNzNzCN2H+ImYTa+zZUKNB53tj0uuohPhPV6xN
         NlDmraqjRsUMPjc73R7Nl3Jdzm19R/9wqEtRwVVDKK/YcSP+R4qt6GIvk150DfMudN
         qyDC5NXC9qCIg==
Date:   Thu, 25 Mar 2021 17:40:45 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: Re: linux-next: build warning after merge of the net-next tree
Message-ID: <20210325174045.7642367a@canb.auug.org.au>
In-Reply-To: <20210325172350.631fe2c0@canb.auug.org.au>
References: <20210325172350.631fe2c0@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/8961YR1Kr83SnsqOTorjWiL";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/8961YR1Kr83SnsqOTorjWiL
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

On Thu, 25 Mar 2021 17:23:50 +1100 Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
>
> After merging the net-next tree, today's linux-next build (htmldocs)
> produced this warning:
>=20
> Sphinx parallel build error:
> docutils.utils.SystemMessage: /home/sfr/next/next/Documentation/networkin=
g/nf_flowtable.rst:176: (SEVERE/4) Unexpected section title.
>=20
> }
> ...
>=20
> Introduced by commit
>=20
>   143490cde566 ("docs: nf_flowtable: update documentation with enhancemen=
ts")

This is actually a build error and fails the htmldocs build - well,
actually causes it to hang.

--=20
Cheers,
Stephen Rothwell

--Sig_/8961YR1Kr83SnsqOTorjWiL
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmBcMG0ACgkQAVBC80lX
0GzNwQgAnplmCzmGvZ3bL6bCX20P+u7FZzaDj55OVj68Fh3duYpj1eSs57nDSpyo
R38BYBJ50+KSHKCTlybk4y1e4I8m2AJkH2YIjJJ+SYLkDtqDlyjq7hPsifG1vnnc
G2T6r4sbT4o8om6hT0p2xNMq6F6q8zPpbaZv4Nj5Zi4LrSAY0JmU2ojDxYCX0ygt
f30j6Z+A37ow2x+vTAjXYdAcHc4JmKag2f6h92LGcQ3V+tbY3pJSHh92yu1wc7WP
digzzZMdA401ITgqK82otCPzx5DdgmHDK0fC2P/NevuAukBrg4YNCUj15m6fTQtE
Biwsj7LonUdxZW5mfwYw6ArTsujAzA==
=KL7X
-----END PGP SIGNATURE-----

--Sig_/8961YR1Kr83SnsqOTorjWiL--
