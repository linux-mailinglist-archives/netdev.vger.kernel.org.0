Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E85E02DA65F
	for <lists+netdev@lfdr.de>; Tue, 15 Dec 2020 03:42:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727282AbgLOCYN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Dec 2020 21:24:13 -0500
Received: from bilbo.ozlabs.org ([203.11.71.1]:59811 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727175AbgLOCXt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 14 Dec 2020 21:23:49 -0500
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4Cw29Q0XTWz9s1l;
        Tue, 15 Dec 2020 13:23:06 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1607998987;
        bh=eId5oZC52tK4KiejMx9Sb2FQbEe9Ct3l7rQSdlOZqZI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=B+GwPaLP+AS428yj6TRvCsk23N31ZI061I9CDIiRXm2p9xXO//VB5W6EL5EYWEzKl
         WlA71rSp7RINIqr5rMSf5VbjcOgwTvhmxGzUtSD/6Pb/gTVLwgTcuQzR5shjuXwHJS
         dsMJNBoGdu29sGGeEAFQenMykY3cHb1tDSGoSniDOE5PMhVjnWkxTwOjQYTyfAGsfm
         kwx13YQkyuQmJTIkS5DZ5bp2GOyLOri4fkNuHIEHsnEXwQ1SQmEtB84yJh5bb0DzFR
         GaeCnqCO/IyyNcsvW9uL/RL/nmuNwH4zii0DWypiK9KEqcN8PHxJby60wcqwO4xH+U
         BkQePURGuMMjQ==
Date:   Tue, 15 Dec 2020 13:23:05 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Roman Gushchin <guro@fb.com>,
        David Miller <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alex Shi <alex.shi@linux.alibaba.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Shakeel Butt <shakeelb@google.com>
Subject: Re: linux-next: manual merge of the akpm-current tree with the
 bpf-next tree
Message-ID: <20201215132305.5f5a1c2b@canb.auug.org.au>
In-Reply-To: <20201214180629.4fee48ae@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20201204202005.3fb1304f@canb.auug.org.au>
        <20201215072156.1988fabe@canb.auug.org.au>
        <20201215012943.GA3079589@carbon.DHCP.thefacebook.com>
        <20201214174021.2dfc2fbd99ca3e72b3e4eb02@linux-foundation.org>
        <20201214180629.4fee48ae@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/Y._2ICox=dBWFXc9VQNNpAE";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/Y._2ICox=dBWFXc9VQNNpAE
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Jakub,

On Mon, 14 Dec 2020 18:06:29 -0800 Jakub Kicinski <kuba@kernel.org> wrote:
>
> AFAIU all we can do is tell Linus about the merge issue, and point=20
> at Stephen's resolution.

This is the correct response.

--=20
Cheers,
Stephen Rothwell

--Sig_/Y._2ICox=dBWFXc9VQNNpAE
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl/YHgkACgkQAVBC80lX
0Gw4pAgAi4awFlvffFlzIO8jDZlNVtxte5b/dM4GOGRk0QS/qSUswgO4sWKgY53a
6gWS8iQ2QmS9kiwUTU2jcojiq23YzWPQuaiw1C/DiZTg5ALZFFTrgy3ne3svvTh6
MGkwPOo5HxL5eDeCDA+IU2jVMaqOCfKEVQdMnOY1i5m5OVcVYVzd2Bp/HxCHr07H
q9+S052sbcdgBQcm/yUJqwZFn4pxCk8Xs61YqX5oq/9hGJbzB5I4SMdSwuUbo6GO
f6UIobubXpEHbRhAc2omI7gD+3Vf8XxdVitRllZKIXaYXSO4sEAvxXcCMCcKZtZQ
TNipvxwef437z5RCnfAxyBkRGBmy/A==
=AN7C
-----END PGP SIGNATURE-----

--Sig_/Y._2ICox=dBWFXc9VQNNpAE--
