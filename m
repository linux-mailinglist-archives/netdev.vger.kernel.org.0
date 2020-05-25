Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A96BF1E0E92
	for <lists+netdev@lfdr.de>; Mon, 25 May 2020 14:40:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390604AbgEYMkK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 May 2020 08:40:10 -0400
Received: from ozlabs.org ([203.11.71.1]:42251 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390488AbgEYMkJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 May 2020 08:40:09 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 49VxWV3Xlxz9sRK;
        Mon, 25 May 2020 22:40:06 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1590410407;
        bh=SIXnrJVGIYrpCA6xXe+g8H4GEg7e+3xj4JbzuCi7X78=;
        h=Date:From:To:Cc:Subject:From;
        b=Tx8W6wjSrI3PcZU0AdK1doXqNKoEVepAF7l+antr/CgiWl3JcjgmfmzAa7JdoIY21
         Tlhv0OGXS7lNzkltpfgtcAtokfO+XgltCt5RRFKNhfkBlDjTllJ45uTDrxKjg2dQhB
         QhdzteFMPTpvV8s+GZ2K39ZhQyet9ToQqp8GBHrAJW8ECnRcyiWvBLnRO5TP9n92VP
         8HEESvpB8d3ECVpm4oFyJNABitLF1QvUMHvErf3w2+aclWd+Hp9k/4FGr+PEBguoc7
         kUfPo9JZcGpZx61agIXqwFBJpMSmNGi1AMhc+feIQUy8KPSJfh97ERo59BgBE0I0+V
         G8Z7yt+5V9I8w==
Date:   Mon, 25 May 2020 22:40:04 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Vitaly Lifshits <vitaly.lifshits@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: linux-next: build warning after merge of the net-next tree
Message-ID: <20200525224004.799f54d4@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/zlsE2YCsTCA+CgfAxSH6Bx6";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/zlsE2YCsTCA+CgfAxSH6Bx6
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the net-next tree, today's linux-next build (sparc64
defconfig) produced this warning:

drivers/net/ethernet/intel/e1000e/netdev.c:137:13: warning: 'e1000e_check_m=
e' defined but not used [-Wunused-function]
 static bool e1000e_check_me(u16 device_id)
             ^~~~~~~~~~~~~~~

Introduced by commit

  e086ba2fccda ("e1000e: disable s0ix entry and exit flows for ME systems")

CONFIG_PM_SLEEP is not set for this build.

--=20
Cheers,
Stephen Rothwell

--Sig_/zlsE2YCsTCA+CgfAxSH6Bx6
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl7LvKQACgkQAVBC80lX
0GyZzgf8C+lkDVy18hMKiT6pA9n0fv25c81YhdcZ9S4WIf77Mx1Qtt155yfgr2qS
juqboOU1glbuqCGaZYV8pSeESe2nfLkN9RLMVvxREaiUkAT7b+EIMYXfQmkwu+mA
4sT6gzjumSeWzhXNb3EjVb+MowW/nRswbKaiOGdUQ0ZxUYQYPju8By3kN+I5iN1M
fAOQgsVa1gN4j88JrFdxuFLCuAizuituwIuc6+07F2ZdSF5lmzHZjpJXAE8RHpB7
hOcy9Cbxio56s2VNGppeyo6sTvIcxwzt6JwNVDyk+TH4JicVeIHEAkJ6hnDVf5Ii
CYFzldz0i9HaplbntKflrHddmRZHaw==
=M8lk
-----END PGP SIGNATURE-----

--Sig_/zlsE2YCsTCA+CgfAxSH6Bx6--
