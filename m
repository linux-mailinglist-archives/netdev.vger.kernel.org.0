Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E9F1213D565
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 08:54:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729949AbgAPHxn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 02:53:43 -0500
Received: from bilbo.ozlabs.org ([203.11.71.1]:52179 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726369AbgAPHxn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jan 2020 02:53:43 -0500
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 47yxK10bmwz9sR0;
        Thu, 16 Jan 2020 18:53:40 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1579161221;
        bh=2eh+uwNwDvUhUxNLg2JpB3vUs6JgfJkuR1WAnr4xO84=;
        h=Date:From:To:Cc:Subject:From;
        b=ThNU31zyY9UYR2aJPCTWjuElV3BvjcLwHIRq7/Upd43isufZ3dzakkH+WLkeoy+Ri
         F3GOd6EYrnhQJhdlm9M33+QGMPpewLAK30dfeF43Ma1S1mQgFxIdg8iThv06qXlZAM
         6a5dfxpo3eqY+pxRXNVpB+cKTOI2I9YfYWSRkSN5kTQNphSrymIs6L3OTxfJf/hwaP
         T9ZpaOjyf3hkGw04rx+S3jl2zekDvolxkajMFpaBU9ofd88Ig3NCkR8J8jtaZaNMHl
         CfyPdd8cOX9D2Hl63dS94TkGtwXpyI3oSwPrXgd4UTdtzVBcqRu+QseyWeAr9fStKR
         QQsUTbeTazCTQ==
Date:   Thu, 16 Jan 2020 18:53:37 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Niu Xilei <niu_xilei@163.com>
Subject: linux-next: build failure after merge of the net-next tree
Message-ID: <20200116185337.0fbb9398@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/M5mUyOn6EPnpQpaqCW7NB+N";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/M5mUyOn6EPnpQpaqCW7NB+N
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the net-next tree, today's linux-next build (sparc
defconfig) failed like this:

ERROR: "__umoddi3" [net/core/pktgen.ko] undefined!

Caused by commit

  7786a1af2a6b ("pktgen: Allow configuration of IPv6 source address range")

I have reverted that commit for today.

--=20
Cheers,
Stephen Rothwell

--Sig_/M5mUyOn6EPnpQpaqCW7NB+N
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl4gFoEACgkQAVBC80lX
0GzyhAf/eNWy0Osm+D+CO9u8W24eqUApYPrHEG8fpK7bV75sYmP0r0lkA4hzV54O
MEMf6JE3vAfCXZV6kiUJyrq04NrTD/z7dG47py2JoiNzaniwf9hFg7zj0hUd6aDt
cE1ObUBjESYFkOkMW95v4mgiJ2AWVf77peboG9M901OVMdZlVdnwkuuQdc78cTXc
VYwpdZgKN9p96Y+xFGuft+3DmmRcm2n83vdc14I4IOHSn+BNJAIFtW9pqpicMX5o
8O3I8XvfYUHvVU/hOJkEgwMCLi4qwtMPSDehTZ45b5DkaYFeL2UAxscGhQkM/dL0
4ICPQbRfHxTOQhy4vWM94aJyOmehKQ==
=3qld
-----END PGP SIGNATURE-----

--Sig_/M5mUyOn6EPnpQpaqCW7NB+N--
