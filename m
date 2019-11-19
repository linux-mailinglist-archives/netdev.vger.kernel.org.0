Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7707B102DF6
	for <lists+netdev@lfdr.de>; Tue, 19 Nov 2019 22:08:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727474AbfKSVIF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Nov 2019 16:08:05 -0500
Received: from ozlabs.org ([203.11.71.1]:35565 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726711AbfKSVIF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 Nov 2019 16:08:05 -0500
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 47HdhH66V3z9sPV;
        Wed, 20 Nov 2019 08:07:59 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1574197682;
        bh=UFKuFkg1GaX5KZAenr7tXfFZ4CExJC6aoMjkZJhD+wg=;
        h=Date:From:To:Cc:Subject:From;
        b=oWvTSK62nbf5dxKRmbs1RdhvXADzsD8WWMcL06iJQSXq/7eSUS3O2wlUY2j2yIsvj
         IFZfANOpsa+P3DjKV3wEV6/OU9gDQb6MQcgWMuYHouWtlv6Wk51g9s/rdo4uwWf5db
         ixi4J9t11rbEnJpaX08E67kuuBdIjBA7q/ReTowIp4OGB3qzK9EqcLfgE1mSJfvYF8
         fYrpFmMCx8DyVSPibGCZhwdJEstAjUtZleMABwiuWpLRLz9gQKEZ6+/0aRTEFE+5aa
         LeHEi66BRpOBYsVRhJT6RkXqJpJOvADooIXJI8vlKIv7He0Jtstkb+aop7VQQDYMY4
         OdjU4O29JEcMw==
Date:   Wed, 20 Nov 2019 08:07:58 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Marek =?UTF-8?B?QmVow7pu?= <marek.behun@nic.cz>
Subject: linux-next: manual merge of the net tree with Linus' tree
Message-ID: <20191120080758.2e6548f6@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/XOr1DBCC1YjdLeUGUlNpk5o";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/XOr1DBCC1YjdLeUGUlNpk5o
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the net tree got a conflict in:

  drivers/net/phy/mdio_bus.c

between commit:

  fd8f64df9520 ("mdio_bus: Fix init if CONFIG_RESET_CONTROLLER=3Dn")

from Linus' tree and commit:

  075e238d12c2 ("mdio_bus: fix mdio_register_device when RESET_CONTROLLER i=
s disabled")

from the net tree.

I fixed it up (I just used the latter version) and can carry the fix as
necessary. This is now fixed as far as linux-next is concerned, but any
non trivial conflicts should be mentioned to your upstream maintainer
when your tree is submitted for merging.  You may also want to consider
cooperating with the maintainer of the conflicting tree to minimise any
particularly complex conflicts.



--=20
Cheers,
Stephen Rothwell

--Sig_/XOr1DBCC1YjdLeUGUlNpk5o
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl3UWa4ACgkQAVBC80lX
0GwAWAf8DYnt3VNiZgKlHMns/v4Mz/TI0ODruHfOr+Ood2//utwWitiT3OvWPxZW
Ef6a/LYzdncGPe+XAZSFbGU776RA05EkEr2U9PtTA14OppoFAXMv5rHRZ32Clxhy
KV5B9vE8BWjkjvgiJl/UqkAOSt2MVPUL4j0UNB9PvT2H271EDSMxRgc6kGB+GXxG
aadyloyFywlA/WWUbdnxCbUyODMR69oVven92t35Oh385hIpqCxGs13lUGI2mTHH
29rVPLnNMdH1k0P5hOtkjm9VcLSkb2bb5niIvX0Gs+b6obrl+cBUGltltxF90Z6C
Hqcb2I9wxapun3ttnGoV6vLLOBoxMw==
=/w5D
-----END PGP SIGNATURE-----

--Sig_/XOr1DBCC1YjdLeUGUlNpk5o--
