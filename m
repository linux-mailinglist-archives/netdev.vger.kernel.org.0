Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4639E453EA9
	for <lists+netdev@lfdr.de>; Wed, 17 Nov 2021 03:52:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232712AbhKQCzt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Nov 2021 21:55:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229915AbhKQCzs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Nov 2021 21:55:48 -0500
Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [IPv6:2404:9400:2:0:216:3eff:fee2:21ea])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEF98C061570;
        Tue, 16 Nov 2021 18:52:50 -0800 (PST)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4Hv6t860vyz4xbC;
        Wed, 17 Nov 2021 13:52:48 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1637117569;
        bh=J5Vha3z9A2FjPz72jV3eLA7gPdVWNqXgCLsOZTZKdfY=;
        h=Date:From:To:Cc:Subject:From;
        b=htQKTZVOO3pzHyKtc8456gSEVZ7lcrMfMAhiyccAxkg8wyvXyBuWmnsWte/N9CCQt
         mNa2KAFIOIgo/ZBaWyxRotDoZjM2N62ecQ/VEdJYr4gaZPNz66e/pQQadQfYL5jXOh
         avmRZGStF9CEOxko1vvfpIzGP4SFaEt/tHgtShfkjAjPnk4/wPYDbHMIayxoy4UyuJ
         JDXT2KHSuVyEHF2oLnyVqeERPU62rjZe/SQNbhp+9raHBd/qY9lrX/ZoCi/QX7YSIv
         9+yKdyaPuXvGf4ttLr6YDc/9NR/acmWfO3ebvuaAxjnaSPNjO93/ZYmnTPLuUDGD1R
         RQJOwago7wEZA==
Date:   Wed, 17 Nov 2021 13:52:47 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Eric Dumazet <edumazet@google.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: linux-next: build warning after merge of the net-next tree
Message-ID: <20211117135247.6c8177ad@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/LHIUd3O0C8b4p.S++Oe9CyM";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/LHIUd3O0C8b4p.S++Oe9CyM
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the net-next tree, today's linux-next build (htmldocs)
produced this warning:

include/linux/skbuff.h:953: warning: Function parameter or member 'll_node'=
 not described in 'sk_buff'

Introduced by commit

  f35f821935d8 ("tcp: defer skb freeing after socket lock is released")

--=20
Cheers,
Stephen Rothwell

--Sig_/LHIUd3O0C8b4p.S++Oe9CyM
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmGUbn8ACgkQAVBC80lX
0GxfrAf9HrJhyRAQU3UdbtgorkEeIX8MZW8LK1jf0OygeXEGH1xQnIEMN3agSKZa
tJcc7lXPhnkrvswDn2/5wD3sp4+Bv7r2zilCGJhwFZcnmkdgYkuUKTfXVuWqNmr0
qeuvultveIY5+/kITT78Ba50VU62UpaD8ZpbyE16FvweF5rJ4NQ7/+Y4RYBxScCp
w8uOHBYpt8jYVYhAPfZr4LyrM/llRptC94A+lLv0QZR7kZ48PLIUS86NAmWVdygy
oWe4TdVSrYtrNE2cJ4XBJK7dOmImN/XBksemFZlhDcJQ+iayyzvzioGFblaLSuAO
XkqFwqLmh5opT14u6H/DN79eamzh1w==
=CzZ4
-----END PGP SIGNATURE-----

--Sig_/LHIUd3O0C8b4p.S++Oe9CyM--
