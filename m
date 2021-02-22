Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DB6C322124
	for <lists+netdev@lfdr.de>; Mon, 22 Feb 2021 22:13:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231258AbhBVVNe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Feb 2021 16:13:34 -0500
Received: from ozlabs.org ([203.11.71.1]:42749 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230106AbhBVVNb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Feb 2021 16:13:31 -0500
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4Dkvz402Vrz9sVS;
        Tue, 23 Feb 2021 08:12:44 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1614028369;
        bh=4MOtbregBqGYfmDKCQXSURam+G+agXrc7zcpbGRavDY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=JutZQE2fy1Z5YFP8NYSTuxsU8OTo8tT3EFzwu6Y23WZ3ul9QVGACLf+VwPdbOn4C5
         hO1+/dsPSlhyLuodj7tm/gtPSPWrvcEQcF6HeOe85gqYHGHOC5itHDz2Qyii40S+XG
         Lh16zWw57cyKJBK9g2BkaNwlGbRil+4kvz+psTiub4meieVeqqZzGtMuVHbsCzR47S
         NGivgl/Lk1L4jKlGXDDaL2qpbQMKiq5EbLItuGAQmkGBP9fLdbYL48iTcI3/MxCHTv
         X68LQhD4RhQgu+jiOfP1j1fw/FmAdG9ZMIRn8Ad/5YV02/3qtQ1n6OlAbvFUH3xRIi
         CS2yyLvyp3bag==
Date:   Tue, 23 Feb 2021 08:12:43 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Grygorii Strashko <grygorii.strashko@ti.com>
Cc:     Rob Herring <robherring2@gmail.com>,
        David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Rob Herring <robh@kernel.org>
Subject: Re: linux-next: manual merge of the devicetree tree with the
 net-next tree
Message-ID: <20210223081243.09879290@canb.auug.org.au>
In-Reply-To: <bbddedcf-fa9b-95bd-1e10-5a46da88f305@ti.com>
References: <20210121132645.0a9edc15@canb.auug.org.au>
        <20210215075321.0f3ea0de@canb.auug.org.au>
        <20210222192306.400c6a50@canb.auug.org.au>
        <bbddedcf-fa9b-95bd-1e10-5a46da88f305@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/fwlYFeHpG7Lzp2MPF8+E4KS";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/fwlYFeHpG7Lzp2MPF8+E4KS
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Grygorii,

On Mon, 22 Feb 2021 12:35:10 +0200 Grygorii Strashko <grygorii.strashko@ti.=
com> wrote:
>
> Sorry for inconvenience, is there anything I can do to help resolve it?
> (Changes went through a different trees)

No, it is fine.

--=20
Cheers,
Stephen Rothwell

--Sig_/fwlYFeHpG7Lzp2MPF8+E4KS
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmA0HksACgkQAVBC80lX
0Gw/5gf/eiJhr3dwtGJG+sdgAT6aU3680kLWqD4YAB7RJnJzXPD4DonQKKPN3cZS
eysDhpot1P9arXbrx0Azw549M77ntLaQdZZtyaTenUZQ2gOwHuUJpG++3/JJuxy+
hb1v+qvUfDc1VvnpyJYVq04cIA1ltcYsNnWKOgOx6puQXpkTiy8i0t9uxR79VxWe
9vTR3bXIdnWxRv7a6/M6qDU4iuT5i1yPJlSQwyIt+GLV/WawnVIzMbedS55xbyQ0
8vgj5NC2iCw/uLCJLOXNND4fAKPvlpk6VALFNuspJR2AhNbr6i7s7Tz+gOQZsdLH
wnUPmDVnrVR9VlHOAMXooe0O9SY9hg==
=qNaf
-----END PGP SIGNATURE-----

--Sig_/fwlYFeHpG7Lzp2MPF8+E4KS--
