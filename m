Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE4E7444DD9
	for <lists+netdev@lfdr.de>; Thu,  4 Nov 2021 04:48:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230119AbhKDDuu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Nov 2021 23:50:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229913AbhKDDut (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Nov 2021 23:50:49 -0400
Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [IPv6:2404:9400:2:0:216:3eff:fee2:21ea])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0D22C061714;
        Wed,  3 Nov 2021 20:48:11 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4Hl8k155qdz4xcJ;
        Thu,  4 Nov 2021 14:48:09 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1635997690;
        bh=e0uKO/0bDXQPvox4UoHbpVSHa5HOliGsr11A8JCD1vo=;
        h=Date:From:To:Cc:Subject:From;
        b=tpQSWSfh3Qwd8iSCHU92fRsos2LuKds/iSvQ1mw39GCxMaN5qEbH81L9VdX+iqyJR
         bvmbmPPsoYSCyxIRRh9hvgMbVG7mqXAJKND8ABB39aiKH/tgbzdmmHlmB7a4oplZNd
         QRkqYRpfBH0Zx9IKRkFhLA4BVx7w9sNE+Fl37mcLVtppeto35JL0DeZgIIp0PobXjp
         3DceNQLAUhvn1szBRR68uMyhMRyzlxvpm8BG22DCTVtfTQysgtFN5oa9WmkFc9lqwK
         tczLNtky8sL2YnGjawUaeMU2BpGb71IhNY2ucQRZ30o7we3JxdiPZtBWLuT9kwojcQ
         pp/VTWUDCyRjg==
Date:   Thu, 4 Nov 2021 14:48:05 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Xin Long <lucien.xin@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: linux-next: build warnings after merge of the net tree
Message-ID: <20211104144805.72934736@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/waQ587_YUdS8C+r+L6eviwk";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/waQ587_YUdS8C+r+L6eviwk
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the net tree, today's linux-next build (htmldocs)
produced these warnings:

/home/sfr/next/next/Documentation/security/SCTP.rst:123: WARNING: Title und=
erline too short.

security_sctp_assoc_established()
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
/home/sfr/next/next/Documentation/security/SCTP.rst:273: WARNING: Title und=
erline too short.

security_sctp_assoc_established()
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Introduced by commit

  7c2ef0240e6a ("security: add sctp_assoc_established hook")

--=20
Cheers,
Stephen Rothwell

--Sig_/waQ587_YUdS8C+r+L6eviwk
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmGDV/UACgkQAVBC80lX
0Gy0ZwgAhvk5C70rYs1KiqrWw36kBrP4RLUM52WtzSRhtR9TjzAJwBZXBAwoQLwC
g5Sn8HOTM5U9txTLvdjUWABBrRbdH9bEZ28Rh9Ty/yuY9G5UdWo3+cYJZOLxMrz1
KuQUBCLQyFp4MaLQtXL83aWNJcAisBO+9DKgI27SsP3sxspGgXO17EP1HqLpnqJM
7P/bf3D9iq98Cg48rlF6gMxUYrKESOWycgb2nEEK29kj76vDGdyAou00fdmsPBMW
v725JQjR2gEzRKWqKAlvCX6taiv5pXNKqHoZTGXg40l30YJJ1DDZlLfhwgXYqjMp
q2BW+TN8XpypA28+vPQ1LoXRSt2+jA==
=0UcW
-----END PGP SIGNATURE-----

--Sig_/waQ587_YUdS8C+r+L6eviwk--
