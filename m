Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4A046D3AC0
	for <lists+netdev@lfdr.de>; Mon,  3 Apr 2023 00:03:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230307AbjDBWDy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Apr 2023 18:03:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230095AbjDBWDx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Apr 2023 18:03:53 -0400
Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3704176AD;
        Sun,  2 Apr 2023 15:03:51 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4PqShx66GRz4x1d;
        Mon,  3 Apr 2023 08:03:44 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1680473026;
        bh=lyTdpBxvcWbC3gXPMV4tnV29Qu+rdkooY4KmZorXOqU=;
        h=Date:From:To:Cc:Subject:From;
        b=JeckShSUcsXZgux4jhTCJN9VywRrPFHEmFG9kbtRaekJdgwn9iCMQPg18uHeU2pV4
         l8FojiXZ79GMqu+kFkBQVeyU6mhQpqdXUIsZ3Acr5Z6HYqmE5D7IbC30ktt5Q2yfV2
         TBecZGLbsqnZEza7L0cF7N3NdslGQsXu5H90lG7QVkjeNe9nAgRCT/t3q3GHcctx0V
         U3NEKO6EhwEBLzpy5K7p34AGPIBP1qcg5jh3opUwg5sOYOyQ6Uo7J3bamrKZwNlWww
         +wLpoYI5fZ8EXuOedPsFA4KJec1li03/I0b/mBsCpM6V+W/dydcadAVucwhZXkK0He
         i5ej2kT9l+vbw==
Date:   Mon, 3 Apr 2023 08:03:42 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>
Cc:     Networking <netdev@vger.kernel.org>,
        Gustav Ekelund <gustaek@axis.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: linux-next: Fixes tag needs some work in the net tree
Message-ID: <20230403080342.2fbbebe8@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/V3TH2rJPnCZFvZXD0w2BYSV";
 protocol="application/pgp-signature"; micalg=pgp-sha256
X-Spam-Status: No, score=-0.1 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,SPF_HELO_PASS,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/V3TH2rJPnCZFvZXD0w2BYSV
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

In commit

  089b91a0155c ("net: dsa: mv88e6xxx: Reset mv88e6393x force WD event bit")

Fixes tag

  Fixes: de776d0d316f ("net: dsa: mv88e6xxx: add support for mv88e6393x fam=
ily"

has these problem(s):

  - Subject has leading but no trailing parentheses

--=20
Cheers,
Stephen Rothwell

--Sig_/V3TH2rJPnCZFvZXD0w2BYSV
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmQp+78ACgkQAVBC80lX
0GyrWAgAg/6ihOQUEegWXQ96+pC4Y7LXK17qEfUinOrg7uer+MSTlDW4fYEViuDJ
orsqemvEaWzYY4CVj+n5hg3R22LjOG3vI1HCUSSAsSfBz4xpSoqy39mkjibehtob
dGrINs9OMfyTREBn6UtWUsS5t8E1/eADPw9SaccfrqsT1IequtQaolMmLXn2m4Lm
h5qjLmuHAoYkhjXhZQ+4/wt731sLCg3jk/lGGzTJorsst6ODaKIOVHpmRgHXz7KK
aiER5o8+yq3CUfrxd0N/m/ueB7/eNYg6ZBpbhZD0y39tOBdPqegf5iVvFFHQjVA/
WBLJMzYkFp1NTtr+EUkcxmOahKcHTA==
=xUrt
-----END PGP SIGNATURE-----

--Sig_/V3TH2rJPnCZFvZXD0w2BYSV--
