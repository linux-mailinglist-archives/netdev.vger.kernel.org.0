Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FE7A34B271
	for <lists+netdev@lfdr.de>; Sat, 27 Mar 2021 00:04:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230494AbhCZXDz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Mar 2021 19:03:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230465AbhCZXDe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Mar 2021 19:03:34 -0400
Received: from ozlabs.org (bilbo.ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC506C0613AA;
        Fri, 26 Mar 2021 16:03:33 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4F6cw24Bzcz9sRR;
        Sat, 27 Mar 2021 10:03:29 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1616799811;
        bh=oGsI+iyCmO62DOlPCWBz+yEM9Er6qmZ9DIaLppcrLcw=;
        h=Date:From:To:Cc:Subject:From;
        b=XdjBqPp0L+qKw3aCoGtVMP/6dJV14B6LPT8v+gxBXpOUKBrPAK74PbhXMPreqktSE
         vh7gTlnUHE/U+BD1WSaVMPr4tO4RERQJYORu48Z6yBK/skPIL14v6oqbYk29aMKwMd
         nKIlHurqd6I2XRNFYIy8QXnS4OlIRfHEVDLP0I0tueDdnYVjocqkiPwwozIQImmIsj
         qWCVB+l4eF0ISkPTu+/LlDWxkZfoZw3IJuQcf1rLrKzOB5apwn9BcR0+k1YDFkTVNN
         e2zHZ8QCToGkGUfTwmhQqmLtEPAZybf8P3/8ojwoW1qW57vbXHNe6GCd7c6cat6yip
         TZaCywQlszKjA==
Date:   Sat, 27 Mar 2021 10:03:28 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Mohammad Athari Bin Ismail <mohammad.athari.ismail@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: linux-next: Fixes tag needs some work in the net-next tree
Message-ID: <20210327100328.1f486e9e@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/fz1W8CjW9ZKjdjEM9sQ+mFU";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/fz1W8CjW9ZKjdjEM9sQ+mFU
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

In commit

  63c173ff7aa3 ("net: stmmac: Fix kernel panic due to NULL pointer derefere=
nce of fpe_cfg")

Fixes tag

  Fixes: 5a5586112b92 ("net: stmmac: support FPE link partner hand-shaking

has these problem(s):

  - Subject has leading but no trailing parentheses
  - Subject has leading but no trailing quotes

Please do not split Fixes tags over more than one line.

--=20
Cheers,
Stephen Rothwell

--Sig_/fz1W8CjW9ZKjdjEM9sQ+mFU
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmBeaEAACgkQAVBC80lX
0GxhHwgApM2BCTp73PRTSGiKAvGgnGAnOW0697Fm6c09hS8NXSZ5Oww2r73uzciJ
E62aMrQ5B5RRAkr6bA4M0/Vmr6qUDQtIJhSCz7KGrl1VQTJ6mcu05I03rekabZXK
LIVtHC/luSVboOaBbO70/vCMWgNBuf8qraDW/HfKZSEmauh66zt737GPO/XQ6+w1
ylBQDoDEbyn0WTRWHobVS5TjEcu8J4ODw2xmsn0GdQWi1b+q1aksdFHxW1AbU+nH
I1FnlOAvT4yEC/bQzjQxuDR0ga+XTlHRjTptiXmEETXKBOXxPDK4ayIlkjN3qViv
gbje6eTd9rtbRMWA62CfefHlGiZwTw==
=7+rM
-----END PGP SIGNATURE-----

--Sig_/fz1W8CjW9ZKjdjEM9sQ+mFU--
