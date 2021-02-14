Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE11A31B323
	for <lists+netdev@lfdr.de>; Mon, 15 Feb 2021 00:01:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230104AbhBNXA5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Feb 2021 18:00:57 -0500
Received: from ozlabs.org ([203.11.71.1]:37295 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229793AbhBNXAz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 14 Feb 2021 18:00:55 -0500
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4Df2kh3sYvz9rx8;
        Mon, 15 Feb 2021 10:00:12 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1613343613;
        bh=skpc64AyD/88wgqYYquctav6U2Q3pruHhfRsZisKFpk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=r2Zt28EgFncNF4wZfQ7X25NkDtFoP6w+lGw8aEHnWYKZcNIspTga9AXcGSfo5QPPB
         rqBQtUXzu513qs0k9tOXmx8jsWzGbyAPbNuwVLsPQ8UHPwYhw4Wk8fdN9KSTeSS9OC
         tRDdr2EcMkemdggEwqgyl560AMWWysFfjIZeYqKFw80ggGUmsKK2Gn+lqyHafCd1t0
         ea1YgZaMrX9E/l5SMH5q40GLCaCZpBESY+Nz1rmu/AEL6vXRwLy6LrUqCSjS//lNCn
         Hp3cXq9FdcJNaQ28hmKmBbS4jYZjAaYlhPixTGLHYMfT5yca4TYQS104UzBFp3Pe+f
         au5YlWLfQyDQg==
Date:   Mon, 15 Feb 2021 10:00:11 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Arjun Roy <arjunroy@google.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Stanislav Fomichev <sdf@google.com>
Subject: Re: linux-next: manual merge of the bpf-next tree with the net-next
 tree
Message-ID: <20210215100011.4f1e3e44@canb.auug.org.au>
In-Reply-To: <CAOFY-A2sLGQHpBp79f2bQ-2hgQDbu04e+7uC9+E3vSo7Cqq5=A@mail.gmail.com>
References: <20210125111223.2540294c@canb.auug.org.au>
        <20210215081250.19bc8921@canb.auug.org.au>
        <CAOFY-A2sLGQHpBp79f2bQ-2hgQDbu04e+7uC9+E3vSo7Cqq5=A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/U8azvLZiM2aOMPL6IM1slh1";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/U8azvLZiM2aOMPL6IM1slh1
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Arjun,

On Sun, 14 Feb 2021 13:40:38 -0800 Arjun Roy <arjunroy@google.com> wrote:
>
> Sorry, I was confused from the prior email. Is any action required at
> the moment, or not?

No.  This is just something that the net-next and bpf-next maintainers
need to sort out when they merge their trees.

--=20
Cheers,
Stephen Rothwell

--Sig_/U8azvLZiM2aOMPL6IM1slh1
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmApq3sACgkQAVBC80lX
0GzUxAf+LxHFGPU3sM8rzN9+aUR18C+x40fPjSks1etMsQN4/1ZjLcKQBqc7kbLF
I9YvrSQGJN027Z1rklKYzjGLgHxJ+B1pljQZNaR2dLTSJMJH3Sh2IHBsWD7w+d3n
b5m4JqVyaMmmDjeej6y7I/WWNsXPK8NW596qARwsdLDNiW63ZUcFfyS2MqwVNbLI
k/43/HliE8JNi0WyLkaG6EfBqgZSBphd8CpIyhW/7z9GE7X0NCatkQAM0wVN7ic9
9+boQnISOp13eh7DIxOhvldLiVc/hLwa26bZpAFJ/zHMtwvLBlz/YBWiDNRdY2d7
onWWIstfqR7gdOotFjsEL5PI+OsKpA==
=k35n
-----END PGP SIGNATURE-----

--Sig_/U8azvLZiM2aOMPL6IM1slh1--
