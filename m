Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F322D68E553
	for <lists+netdev@lfdr.de>; Wed,  8 Feb 2023 02:17:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230123AbjBHBRr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Feb 2023 20:17:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229598AbjBHBRq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Feb 2023 20:17:46 -0500
Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E4143BDB6;
        Tue,  7 Feb 2023 17:17:41 -0800 (PST)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4PBMYW5drMz4xFv;
        Wed,  8 Feb 2023 12:17:35 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1675819057;
        bh=dYHL607qD4Y5hhqCuRcTxAaY1QabKYCouRtj+G4BJcQ=;
        h=Date:From:To:Cc:Subject:From;
        b=jQyuQKv3TIqT2dHcrNWk7k1XLDsxZqeXao7Enx0n4N9vIMJrHiu2LvfEpsZ2noy/n
         IrEEkBYplxquBGJH3M9XHkqFFa+qa51kTkQli7U3wUHS6Kg3P8Urexr146yuXusjf/
         putet2Zrog4WPotv5DaEZThXRhjK5luxH2LsBniHaAPXk/vbNlHqpJANlm9tE7kCep
         tjd9A+SVcTLNiLDL+ppAz8LgBGswAxmgSaETfL4SPzWFKyNJ14CaUyKV8myaesErHF
         2qX3n5xtUMdhX9EBmIYxmNt1OuLzy3fMAIyGyfruFd6WOqyNgQx5wW5/NjWBYO++b/
         Mn7MhxxhSQ3Og==
Date:   Wed, 8 Feb 2023 12:17:34 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Greg KH <greg@kroah.com>, David Miller <davem@davemloft.net>
Cc:     Networking <netdev@vger.kernel.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: linux-next: duplicate patch in the usb tree
Message-ID: <20230208121734.37e45034@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/96l9e7VU5fn9z7SYWpimaAy";
 protocol="application/pgp-signature"; micalg=pgp-sha256
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/96l9e7VU5fn9z7SYWpimaAy
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

The following commit is also in the net tree tree as a different commit
(but the same patch):

  93fd565919cf ("net: USB: Fix wrong-direction WARNING in plusb.c")

This is commit

  811d581194f7 ("net: USB: Fix wrong-direction WARNING in plusb.c")

in the net tree.

--=20
Cheers,
Stephen Rothwell

--Sig_/96l9e7VU5fn9z7SYWpimaAy
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmPi+C4ACgkQAVBC80lX
0GyMZQf/adhYa01yhGLVE7G+Jn0y35VTeInHYuMXnh69qCmjwBFIoxOSRRVMf1W6
CgWAKNNez4ECbcStsWx2MdHapIEdHUDjsWBqY3t4UJKwWgMoSley9mu/0u9Gu2ku
zJSq3JeV/Qrt1Kwd0CrbrnLY/Bmh2VT98KBI8PL0tz+j9FRWvKdagm5tJaLMDqna
7g8443YNNdWTfl+G/bUugbu2VOpZSqgVZTgF+iktfW1/BftPkADXzwF0c2C4J+sQ
rgLbSEKQVnY70z8q0ZHULl7pAfQ5WnSc6nu0N5ubFpapc8pNXfEds6Z6gEP5fHDd
FZAr5v7FdKxfnCl5w/NBXILDzsVMBg==
=umPI
-----END PGP SIGNATURE-----

--Sig_/96l9e7VU5fn9z7SYWpimaAy--
