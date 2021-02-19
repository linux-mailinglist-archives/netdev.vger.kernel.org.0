Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16B3931F5FF
	for <lists+netdev@lfdr.de>; Fri, 19 Feb 2021 09:45:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229678AbhBSIpE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Feb 2021 03:45:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229535AbhBSIpC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Feb 2021 03:45:02 -0500
Received: from ozlabs.org (ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C164C061574;
        Fri, 19 Feb 2021 00:44:22 -0800 (PST)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4DhlVn7345z9rx6;
        Fri, 19 Feb 2021 19:44:17 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1613724258;
        bh=4BapS1el1ETtYK5WiLl3IlqzC/Pr2SGDvP1xSBSHyOs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=hBkRE2c0hw6NSGB91QFhifgv1G9sRhP7GtWBtgvLsofdNgwmW473xIdAmH2SNBBxT
         VQCitaO7JU0RjzVTR3zu7MOLogOva+TG71ejEzxzmavf4zMCNtlEe2OYImCW+engaY
         hSrfdr651qc1IiGFeSWc/9/2WN/KCGEkFeYuXJnw57Cz65v9zf7P5/UTqzCfJYKVeJ
         UJhUwLUprdQ0K5v/Qg/MY1esH04+VMGbY+Tx7/tEq63VoVWyq7Zt8nlRItHyIbWswL
         +K6O36HCUKNXUJlz0oyNyr82jCuJYDvnAaptUgWZ/oi1617RzzmZODdWdtNdRcp//o
         Qm0wfreFRwHqA==
Date:   Fri, 19 Feb 2021 19:44:16 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Brendan Jackman <jackmanb@google.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: Re: linux-next: build warnings after merge of the net-next tree
Message-ID: <20210219194416.3376050f@canb.auug.org.au>
In-Reply-To: <20210219075256.7af60fb0@canb.auug.org.au>
References: <20210219075256.7af60fb0@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/VByKzbH0ZeQ=HuP+Hq1sdfU";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/VByKzbH0ZeQ=HuP+Hq1sdfU
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

On Fri, 19 Feb 2021 07:52:56 +1100 Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
>
> After merging the net-next tree, today's linux-next build (htmldocs)
> produced these warnings:
>=20
> Documentation/networking/filter.rst:1053: WARNING: Inline emphasis start-=
string without end-string.
> Documentation/networking/filter.rst:1053: WARNING: Inline emphasis start-=
string without end-string.
> Documentation/networking/filter.rst:1053: WARNING: Inline emphasis start-=
string without end-string.
> Documentation/networking/filter.rst:1053: WARNING: Inline emphasis start-=
string without end-string.
>=20
> Introduced by commit
>=20
>   91c960b00566 ("bpf: Rename BPF_XADD and prepare to encode other atomics=
 in .imm")
>=20
> Sorry that I missed these earlier.

These have been fixed in the net-next tree, actually.  I was fooled
because an earlier part of the net-next tree has been included in the
wireless-drivers (not -next) tree today so these warnings popped up
earlier, but are gone one the rest of the net-next tree is merged.

Sorry for the noise.

--=20
Cheers,
Stephen Rothwell

--Sig_/VByKzbH0ZeQ=HuP+Hq1sdfU
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmAvemAACgkQAVBC80lX
0Gw3/Af/e7nrgmgNA0GHpXwOFzCMf9r/2u6687YTfQkqF4O68mVzHayOeUn+ZXp6
JMMZm/XLzppLKcynmG6uLfc/sASDxPT2LX8qWhi5y/R+1tr/wJd4/63QT3aUJrUE
vzl5GqdExygAJKcYXwwkg0wSmME8fy2Mia5RvnzFxvcn06xnQXTcrP2X/kdPPFT8
82HSjaRjPjDEDFz/rmRKMz1B46TI4pRhPa2sjL56pyUL5c+FmbjfMVc+8oOKH7vf
TC8hjCza2lDXCydzUFceEZfQCla5kUwIcZmSkYApXJWvYUFjxtjZ+1kyzEEV59CC
2PbRVYm/vZINkgZqb2ZnHdHKSA7QNQ==
=lvwL
-----END PGP SIGNATURE-----

--Sig_/VByKzbH0ZeQ=HuP+Hq1sdfU--
