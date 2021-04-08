Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBF0D357A9C
	for <lists+netdev@lfdr.de>; Thu,  8 Apr 2021 05:02:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229813AbhDHDCO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Apr 2021 23:02:14 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:55135 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229514AbhDHDCN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 7 Apr 2021 23:02:13 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4FG5dh5ws9z9sTD;
        Thu,  8 Apr 2021 13:02:00 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1617850921;
        bh=1r5PLuw4igGSdd0tYUdtphOK7S3c6Y/7pFZ8m3CAb+Y=;
        h=Date:From:To:Cc:Subject:From;
        b=NG2/I7PPw/lHp/CX+1dbsVPNm9y7wpVIsEF1RaR/7bHlYJ2pTk36W8uzLWlb8r3tX
         bSa3ncYDzLXZFvO4X5+Z+UJE3H9e70UvYwF9M2P3w6XgcJlLGK/TPUmBGq6fDRVKbM
         jFsf3Jl0lLyFB6zSzF+1H78oRUTY1UTMZrEj1OVKKbFlK0BxIx12/hl2Sr5jbR2SXL
         onwHK4REp2vD4/x5vVy7L5Q9bJt7X6XDxhxasTjlPye3IuJmtbeEbuEujP3TIevC1a
         S9IVGTAbKookF5kBn35/cdD2u+qv42pPJLzuj7fU3MT9V2adX3ggayNQtHSq+cwjm8
         V/oqordRTyKdQ==
Date:   Thu, 8 Apr 2021 13:02:00 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Networking <netdev@vger.kernel.org>
Cc:     Cong Wang <cong.wang@bytedance.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: linux-next: manual merge of the net-next tree with the bpf tree
Message-ID: <20210408130200.32ec9d1e@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/5+MxEfGahklOEYEAz8dbwq2";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/5+MxEfGahklOEYEAz8dbwq2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the net-next tree got a conflict in:

  include/linux/skmsg.h

between commit:

  1c84b33101c8 ("bpf, sockmap: Fix sk->prot unhash op reset")

from the bpf tree and commit:

  8a59f9d1e3d4 ("sock: Introduce sk->sk_prot->psock_update_sk_prot()")

from the net-next tree.

I didn't know how to fixed it up so I just used the latter version or
today - a better solution would be appreciated. This is now fixed as
far as linux-next is concerned, but any non trivial conflicts should be
mentioned to your upstream maintainer when your tree is submitted for
merging.  You may also want to consider cooperating with the maintainer
of the conflicting tree to minimise any particularly complex conflicts.

--=20
Cheers,
Stephen Rothwell

--Sig_/5+MxEfGahklOEYEAz8dbwq2
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmBucigACgkQAVBC80lX
0GxcTAgAiV0BPzQ6ps/B13zV/LbivqRxby8Xy9YmMksTValHOfZHB4SkSNQLTO07
FM/OLGIhpxSeJB2STCqHUu3yq8qK2YfcT3LFpXeFNnJgO80r2Qoptqv6HaWoIlsf
Idcok9ICHqaGnxWJfjSWOG3rvClcx5cRKp+SoujNd816LScDwP7XUAziq2AJyf8X
VFQ5QGvB9Y0hVIiFFinA1TGWjot9ahIbZV9FzpkF9wVrLS4K78vxTZTqTKQ9Zlpf
6+ItmsKaNCYe/SnyPJqWLExJefwrJfGE9QkKJApmRZGtnznOtHBIojwup0RtZSvB
Xs3bmHPSttZGkcRQofOzDQ3Z1vhu3Q==
=Pfzh
-----END PGP SIGNATURE-----

--Sig_/5+MxEfGahklOEYEAz8dbwq2--
