Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A8E930E97E
	for <lists+netdev@lfdr.de>; Thu,  4 Feb 2021 02:34:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234439AbhBDBeS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Feb 2021 20:34:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231132AbhBDBeR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Feb 2021 20:34:17 -0500
Received: from ozlabs.org (ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B0FCC061573;
        Wed,  3 Feb 2021 17:33:36 -0800 (PST)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4DWLfj17YWz9sWw;
        Thu,  4 Feb 2021 12:33:32 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1612402413;
        bh=6jjp+6nyWR2jPo5XxH6xsste0b+M2ZEy5UVWQVAwZpI=;
        h=Date:From:To:Cc:Subject:From;
        b=n5Z63ogthijkPYxZgua3pq+a8Qu8cebuAl5hZUgHHTUFpdS7fmqeSTzK9ji+TltnN
         0r7UooVcb+uSc3jrPt9V5GkV+BwLHp8F0Q/px3C7ePsIkhbK+HTeWifjS5Y3dN4eCi
         SsjWPnTN99F7FnAkR4vJ6wWCbExGo2Xn666S4i9wSzAjOC/LKbr5W2ate+Kb7vTvND
         5lfTcrYWWecySTx4k1L2czyHqFPiafW4/B4lHHD2hO28ShM2xXkwyoqMWfLtNM6qkQ
         /j8SpoR6Z84rWCOnDOVvqnfch8bzZBPO6Ha8Jdg7ziVLHWzIcBYmIP/8o+39uu/JdK
         IoO695Vw2FoIg==
Date:   Thu, 4 Feb 2021 12:33:31 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Brian Vazquez <brianvv@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: linux-next: build failure after merge of the net-next tree
Message-ID: <20210204123331.21e4598b@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/uVh/AA+aBi57gbE1=4imCt3";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/uVh/AA+aBi57gbE1=4imCt3
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the net-next tree, today's linux-next build (powerpc
ppc64_defconfig) failed like this:

ERROR: modpost: "ip6_dst_check" [vmlinux] is a static EXPORT_SYMBOL
ERROR: modpost: "ipv4_dst_check" [vmlinux] is a static EXPORT_SYMBOL
ERROR: modpost: "ipv4_mtu" [vmlinux] is a static EXPORT_SYMBOL
ERROR: modpost: "ip6_mtu" [vmlinux] is a static EXPORT_SYMBOL

Caused by commits

  f67fbeaebdc0 ("net: use indirect call helpers for dst_mtu")
  bbd807dfbf20 ("net: indirect call helpers for ipv4/ipv6 dst_check functio=
ns")

I have used the net-next tree from next-20210203 fot today.

--=20
Cheers,
Stephen Rothwell

--Sig_/uVh/AA+aBi57gbE1=4imCt3
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmAbTusACgkQAVBC80lX
0GwoxQf/Q5hK1sQNw652R+7Zy0UO8Dk6qtLelVaYFYBMUq3ATf1eAFyZO2ANcLVB
TajdYhl0sbeWIP8Xxv3iP+rMpVR7I6QDbSm4uOZtMyL5IxidFIDADDklkItPl1A+
Wsv4awlLJXebnF88al+mBPNJRz7v1KbHLjyCEGPhQDjVMOvXXZRmW7VMegESEvxp
URqoB+plYGIfaqJJM0FBN/pQj1sqYaGuvW3wprpoZjJQ/OQmpn3RyYd/UjQfi5BP
oyvEV1qMxUznDWDlmCNCxpek3fhkoPA22gx5CdSe0Cdsz4K3SvDiP07lBaRLJ6RM
EkWxtary5Be5u2uIROHHa28b99Armw==
=o7Kc
-----END PGP SIGNATURE-----

--Sig_/uVh/AA+aBi57gbE1=4imCt3--
