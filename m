Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47539418B4A
	for <lists+netdev@lfdr.de>; Sun, 26 Sep 2021 23:42:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230292AbhIZVoc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Sep 2021 17:44:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230200AbhIZVoc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Sep 2021 17:44:32 -0400
X-Greylist: delayed 337 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sun, 26 Sep 2021 14:42:55 PDT
Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [IPv6:2404:9400:2:0:216:3eff:fee2:21ea])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D122C061570
        for <netdev@vger.kernel.org>; Sun, 26 Sep 2021 14:42:55 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4HHfHb6Rk6z4xZx;
        Mon, 27 Sep 2021 07:37:15 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1632692237;
        bh=n9YlnZFBhU2JLojFhUOraML2j9kRQQ0QlKAVMx4YlVA=;
        h=Date:From:To:Cc:Subject:From;
        b=phAEsfDshGwmHWmruTXnjwLlqGT37wiCLZX7TQ6YJ+GPYJDFS7KANuQsqcwdMNdWe
         EgowF7Ah27agPLxajmnmrbfski18bV1YvfMn/tO4JieJoFiWFC7DKxkc9HZDMo2emc
         rML4vdi0UD7HNJNaRa1V6aHcZdYiyxJumtj2I8osXVWXzoJX1zsKCFb7CRd6UrfmAA
         17whGLLxe9OD+N2MspP4jpcK69lpZ0LSn9eoW6UYfY5mWli1H/8WZPxAnStKNyMyz1
         RnzjvBfc8kolMkBYCcwX8+NNKLzrhvjY+XED85cqO9VDJmsgC/X3GLBoGg4XXgYXwQ
         MmuFNu2Z8l51g==
Date:   Mon, 27 Sep 2021 07:37:14 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Jiasheng Jiang <jiasheng@iscas.ac.cn>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: linux-next: Fixes tag needs some work in the net-next tree
Message-ID: <20210927073714.593e9fe0@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/1bZHdKK=hGo/SSXMzf8+PTm";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/1bZHdKK=hGo/SSXMzf8+PTm
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

In commit

  acde891c243c ("rxrpc: Fix _usecs_to_jiffies() by using usecs_to_jiffies()=
")

Fixes tag

  Fixes: c410bf01933e ("Fix the excessive initial retransmission timeout")

has these problem(s):

  - Subject does not match target commit subject
    Just use
	git log -1 --format=3D'Fixes: %h ("%s")'

So

Fixes: c410bf01933e ("rxrpc: Fix the excessive initial retransmission timeo=
ut")

--=20
Cheers,
Stephen Rothwell

--Sig_/1bZHdKK=hGo/SSXMzf8+PTm
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmFQ6AoACgkQAVBC80lX
0GywxQgAiBWga4pO2yZZJc6oUxsx2AVDX1tJ1LnSK6QeuVFgTnJxWdT/hnxqZElB
36qU4PRnbIDsdgkS1xB00UJ2LiM7nduRkTjlSMjJ06x+cA6NrR7kFeN7AIlHnI2p
De0JkWwz7joMB9Qq6cn1xYvyUdWEja17fMySYqOr/qKZZO0yX11vPRGElsC2j3Sm
vF6etGBfzTAvzVbHrnf7x/Ib6Xp0ZmYUunaiE/oiIkLBR9CAAZWHH9f7BhjbHrJG
Ic41T8wjz/TN1qwoLA19s51vO6A9p18H8Kx2kgr3W/ez1AKWbXYUC8cwpNqgdNAj
1mVCjCdIYNRi8qr36/i7rg50cLvN0g==
=U0Lu
-----END PGP SIGNATURE-----

--Sig_/1bZHdKK=hGo/SSXMzf8+PTm--
