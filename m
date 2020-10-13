Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D057628C6F7
	for <lists+netdev@lfdr.de>; Tue, 13 Oct 2020 03:59:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728488AbgJMB7h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Oct 2020 21:59:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726168AbgJMB7h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Oct 2020 21:59:37 -0400
Received: from ozlabs.org (bilbo.ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E59FC0613D0;
        Mon, 12 Oct 2020 18:59:36 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4C9Jcj3CwXz9sTr;
        Tue, 13 Oct 2020 12:59:01 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1602554343;
        bh=pmgPJPvZsJLsw7I2sG6yosJYB3ZefjQHmA4yalF2CxY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=lnXelRUORBwPKUVDaYJLNzHEVeSKeZ2CCPNZvhZuLPcqef0EmZFaWEKVzBhKNbeWR
         GN7S+Fl0PdVbRdk/UA8x/E+5l/z69fpmjBdh/PZnNX2AOIXmiVkVA13WgQtl2kwM2f
         gKPP8e+gYfyMp7G5iTxX9WG6XRKAexIJtqIzQI6K6Tnem7l2a9845Lu1tsGxS3MUZ4
         TJoFx1Zld0cZknBNbHoNXvxIUrEsT5ym3plf273bn2wn3lwcaan71RBNP7HUTsnGa6
         UuB2vCFXctLX0pizx9Ptl91Zdclije6jFsj9dL9mZ1MaufOkobcZ3YYQwp91RymANP
         Mb3KDoF69jomA==
Date:   Tue, 13 Oct 2020 12:58:59 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: merge window is open. bpf-next is still open.
Message-ID: <20201013125859.1d694319@canb.auug.org.au>
In-Reply-To: <20201012210307.byn6jx7dxmsxq7dt@ast-mbp>
References: <CAADnVQ+ycd8T4nBcnAwr5FHX75_JhWmqdHzXEXwx5udBv8uwiQ@mail.gmail.com>
        <20201012110046.3b2c3c27@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CAADnVQKn=CxcOpjSWLsD+VC5rviC6sMfrhw5jrPCU60Bcx5Ssw@mail.gmail.com>
        <20201013075016.61028eee@canb.auug.org.au>
        <20201012210307.byn6jx7dxmsxq7dt@ast-mbp>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/qzu=3O5TsrkNFDVoYhuzU6W";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/qzu=3O5TsrkNFDVoYhuzU6W
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Alexei,

On Mon, 12 Oct 2020 14:03:07 -0700 Alexei Starovoitov <alexei.starovoitov@g=
mail.com> wrote:
>
> That is a great idea! I think that should work well for everyone.
> Let's do exactly that.
> Just pushed bpf-next/for-next branch.

=46rom now on I will only fetch the for-next branch.

Thanks.
--=20
Cheers,
Stephen Rothwell

--Sig_/qzu=3O5TsrkNFDVoYhuzU6W
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl+FCeMACgkQAVBC80lX
0GyKPAf+LIh0n3MhDh9RH4TK7Ym0sim29+Ng6FmUh3z8PJGj7vwS/B9GBmIY8Si2
gB1yGKMkBbwpVQyQnJ2rTrb9Xcu/aj7GTSE2RpK5n+dUIcJvTBUNS9a8Uyabix6k
ESeiXEZfXhMXgLJEKCICaGt7OAvxaiPZqaGdMoU2Y/5pM4m1NA+PC1UoQfrtfSMF
w1ZKcHV+lzv1bGqMKlRTmURQ8m9QB2G0zK/zh4nFxAiUil4pWFMjTg3rYdd9nS+F
74mGhiKCTsjrp0pTKVOX6SNEATPZcASqo490AuqH1bhh2zRrPXXpNE4cLxwzt+zV
/WhaIvk6Wym4mKPaKLTvfLU+gRu+aA==
=d+mu
-----END PGP SIGNATURE-----

--Sig_/qzu=3O5TsrkNFDVoYhuzU6W--
