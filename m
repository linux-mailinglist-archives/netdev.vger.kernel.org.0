Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 71CF44CFC85
	for <lists+netdev@lfdr.de>; Mon,  7 Mar 2022 12:19:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235704AbiCGLUm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Mar 2022 06:20:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237682AbiCGLUP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Mar 2022 06:20:15 -0500
Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD5BB9D061;
        Mon,  7 Mar 2022 02:45:42 -0800 (PST)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4KBw901XDFz4y2M;
        Mon,  7 Mar 2022 21:45:40 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1646649940;
        bh=ylm8kxs+Wxdholtq0NrEb/HlCbp9bOD6c2ez6/kzWqI=;
        h=Date:From:To:Cc:Subject:From;
        b=E8eh6Dq2zgcEYBtb2791b+hWGe8PfPkZS22K5Fdjiik/PCVmjAKv84X3DQjhwRbgZ
         11ZTsePMhtQ516SHQgDeQ2kcUt5Z+D4e2N4Cr0yNHBRqbwak4thIqF+dl8FXi6HYvW
         rQBmrvmY9pdEePJGeCzaSoCdTPikpru95+nKjAAFaBR2CbamgCneX836cSajyNedZO
         jJSiJOzHM3pqY45UISPYHUgq3qEahNEAoknqf4NsJu04rzUSUFDCshQYv5XAQJVQ4K
         tBVF9vW8tB7OYGChwW4uwFBDAVJD7yDaILfXLwGl+NIsQlw8/umklGPPnDdmquJ7Dr
         DiFxXzDXrq5EA==
Date:   Mon, 7 Mar 2022 21:45:39 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Dimitris Michailidis <d.michailidis@fungible.com>,
        Dimitris Michailidis <dmichail@fungible.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: linux-next: build failure after merge of the net-next tree
Message-ID: <20220307214539.473d7563@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/tlUlvxIR639oW_1FuUEHh.n";
 protocol="application/pgp-signature"; micalg=pgp-sha256
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/tlUlvxIR639oW_1FuUEHh.n
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the net-next tree, today's linux-next build (powerpc
allmodconfig) failed like this:

ERROR: modpost: ".local_memory_node" [drivers/net/ethernet/fungible/funeth/=
funeth.ko] undefined!

Caused by commits

  ee6373ddf3a9 ("net/funeth: probing and netdev ops")
  db37bc177dae ("net/funeth: add the data path")

--=20
Cheers,
Stephen Rothwell

--Sig_/tlUlvxIR639oW_1FuUEHh.n
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmIl4lMACgkQAVBC80lX
0Gw1Fgf/eJ/Ve/3kKEP4hsKIF/wYHNTYuKFpdENejq3tLgBVjGEL1Uf5aGAymolG
E+v9JZ8v1xR/2rWbJDMIxUm4D5u/386SbO4978zHCE6ctYCSoME2X9/mXN2t73Ts
TZDf5VWBUA2lSkShgNSQso9wPzk83rMrTDJnwXmxmWPoUpuKE2nLYncso6+fKwRe
KapyqiK28rLmCQWTI5rtCPMnvnaCwNdgUeja0OZzdQk/bwsyMOoVUcmTWguwK+l5
Y2s1WmGFAawQb1JGvcB129JMTxr2zgBVgC9QJQh6jb6xpXm+knyYVozQ/LaBg0YP
Kxb3e/nJDDNQfHID7B/r0Cbg6fkUgw==
=6f9j
-----END PGP SIGNATURE-----

--Sig_/tlUlvxIR639oW_1FuUEHh.n--
