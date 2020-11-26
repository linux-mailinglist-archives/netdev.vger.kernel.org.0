Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F8B42C4EE6
	for <lists+netdev@lfdr.de>; Thu, 26 Nov 2020 07:43:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727372AbgKZGlC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Nov 2020 01:41:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726417AbgKZGlC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Nov 2020 01:41:02 -0500
Received: from ozlabs.org (bilbo.ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B178C0613D4;
        Wed, 25 Nov 2020 22:41:02 -0800 (PST)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4ChSnk6p6pz9sRK;
        Thu, 26 Nov 2020 17:40:58 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1606372859;
        bh=jHqoz6QPKR8oEcPZi+KhlcgcjTok0fnVD34cOly/NgU=;
        h=Date:From:To:Cc:Subject:From;
        b=LcvKpcsqsXaOUiSd0fSsL0r2ueMvqT7X2HJyN1aQFJhYzXsAVPHWoVy5DHGfdZWfH
         ItaVPb1cD0t720qt6EcRwa2O6Ar4qapixH0THpNzSWOwjElOqPtP12w1ZX++04NE42
         WmurCIJllMw+O86+5mJMbItQksyuQUIIKvazOLPkEi8qM80xvTUgG/MW25jkhu0sbs
         jm9xZjih/zU/VEt6UGWw4eA8Uk0wBIWkO5uAxYYttHfK7kIKCJA0KsQKRB3leEQCxl
         RHlkt6ElX9aDCNgwRFqaos6dWYdCdS9Yzy0KCuT4vC3rNdz1qkL/g6JDM6DYuSYLLF
         1bOnmdemYRvSw==
Date:   Thu, 26 Nov 2020 17:40:57 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Ioana Ciornei <ioana.ciornei@nxp.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: linux-next: build warning after merge of the net-next tree
Message-ID: <20201126174057.0ac8d95b@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/Vufd.iS+ai17bJrXOVtFLmO";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/Vufd.iS+ai17bJrXOVtFLmO
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the net-next tree, today's linux-next build (htmldocs)
produced this warning:

include/linux/phy.h:869: warning: Function parameter or member 'config_intr=
' not described in 'phy_driver'

Introduced by commit

  6527b938426f ("net: phy: remove the .did_interrupt() and .ack_interrupt()=
 callback")

--=20
Cheers,
Stephen Rothwell

--Sig_/Vufd.iS+ai17bJrXOVtFLmO
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl+/TfkACgkQAVBC80lX
0GxWQwf+JMVkCS78ZP+b33PuwnN1x65yes9I48opNrbk7KseUCVsPSwoCE6SUm19
pACqAfhfp4iYdr1BBUn/ZhbEoksZKvChxBrksV3akE97oHlY7e188wwT6I72Sy0A
OFcV++DakuyOL2mCBM8UooYHjHRZEY4u84NintTMCGqQVilwiEXdBJe0+NwACNGK
a3Ibt8TshMhjL8JoAdU4niX/wyNXbTtDJGVkXtgfwrj5l6VzospYdsQ7Jxhs5OUD
FrKE08uztJHCItYIqrRw4U68XoudbEO/fXpJPHT5CVqVVkj4O0rCWQur5VjIcbFS
9LrTcUVEHXYRMC/hd7kIazMutrM3gg==
=Ahu5
-----END PGP SIGNATURE-----

--Sig_/Vufd.iS+ai17bJrXOVtFLmO--
