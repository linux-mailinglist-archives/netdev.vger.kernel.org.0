Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13B7A1C7B0A
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 22:16:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728659AbgEFUQo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 16:16:44 -0400
Received: from ozlabs.org ([203.11.71.1]:51295 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726538AbgEFUQn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 6 May 2020 16:16:43 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 49HSY1481kz9sRY;
        Thu,  7 May 2020 06:16:37 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1588796201;
        bh=XCFvNjeS2kjOQNihxDVpNQIvU0ggraBRLa25yNrgmPY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=BokniRZ7+PcvdLb7ypmiIA8wgN0IOJfe3dM8POjJgVycNSMpvg9Zn7kKU+ia7W5k6
         BqRL/Zs5TAbIF+20AYROSV9p+ixyBmhX9I4WI2p304ardBN3ljflftW6wzhmT4KRCf
         BwyypipOaS9qUy+8lST7hVeaKAaF08EKd2Yv79UNIO2xB8HjT+fQn0M+UL90nWresL
         FL2HBEXZNfdhXeeEDa2Mq7Pj+/yIUguFmpxUS/GcagrlRrzb0jB7fFnZV41xrp/xly
         kCjWVv6iX2xIESNojwW6Q8XrCoR19mZycXIzGD7KTt9KLfXjN6Qi6xVUMqrMtUEJvG
         vY1V0z56ckH1g==
Date:   Thu, 7 May 2020 06:16:35 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Qian Cai <cai@lca.pw>
Cc:     Dmitry Vyukov <dvyukov@google.com>,
        Amol Grover <frextrite@gmail.com>,
        Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>,
        syzbot <syzbot+1519f497f2f9f08183c6@syzkaller.appspotmail.com>,
        David Miller <davem@davemloft.net>, kuba@kernel.org,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Linux-Next Mailing List <linux-next@vger.kernel.org>,
        "paul E. McKenney" <paulmck@kernel.org>,
        "Joel Fernandes (Google)" <joel@joelfernandes.org>
Subject: Re: linux-next boot error: WARNING: suspicious RCU usage in
 ipmr_get_table
Message-ID: <20200507061635.449f9495@canb.auug.org.au>
In-Reply-To: <34558B83-103E-4205-8D3D-534978D5A498@lca.pw>
References: <000000000000df9a9805a455e07b@google.com>
        <CACT4Y+YnjK+kq0pfb5fe-q1bqe2T1jq_mvKHf--Z80Z3wkyK1Q@mail.gmail.com>
        <34558B83-103E-4205-8D3D-534978D5A498@lca.pw>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/YytghheW+C8MhpkfUUQolXM";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/YytghheW+C8MhpkfUUQolXM
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Qian,

On Tue, 28 Apr 2020 09:56:59 -0400 Qian Cai <cai@lca.pw> wrote:
>
> > On Apr 28, 2020, at 4:57 AM, Dmitry Vyukov <dvyukov@google.com> wrote: =
=20
> >> net/ipv4/ipmr.c:136 RCU-list traversed in non-reader section!! =20
>=20
> https://lore.kernel.org/netdev/20200222063835.14328-2-frextrite@gmail.com/
>=20
> Never been picked up for a few months due to some reasons. You could prob=
ably
> need to convince David, Paul, Steven or Linus to unblock the bot or carry=
 patches
> on your own?

Did you resubmit the patch series as Dave Miller asked you to (now that
net-next is based on v5.7-rc1+)?

--=20
Cheers,
Stephen Rothwell

--Sig_/YytghheW+C8MhpkfUUQolXM
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl6zGyMACgkQAVBC80lX
0GxkPAgAgtdMC+N8fp+9bijZVMliMNmdDUaF1yrYtfT6QMbxZ0GvHpootI5oO9nj
YyXZglK3aoFmMKvCkX2bf4MubylQ7dX6Xq4fnj+qY+8gjrvSlT5NUWNLReMDKnYy
7DkIlvXQMBW7UJ/KZ1kUqBfgG3CgA8bB5cL51GK3mpMb1pE0+Uf49U0Ep5EcmoJq
F1/fj4yGCv3OdC3romgceBDhd5twJdd0xatlM/6gTf5U3fHZZf07dVksUt4PwfPz
MK4m5LJQUDpBpknmNVAtVY/a/Ku3ym7js6Nlq8A0aUVg6SQPW8gMBu81Q2RjTLsl
Op+hURRi9SaJ/J4NDnnJ2GpuSYjlAA==
=4TP7
-----END PGP SIGNATURE-----

--Sig_/YytghheW+C8MhpkfUUQolXM--
