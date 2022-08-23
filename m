Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A79859CFB0
	for <lists+netdev@lfdr.de>; Tue, 23 Aug 2022 05:51:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240118AbiHWDtf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Aug 2022 23:49:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239380AbiHWDte (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Aug 2022 23:49:34 -0400
Received: from gandalf.ozlabs.org (mail.ozlabs.org [IPv6:2404:9400:2221:ea00::3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 369015B782;
        Mon, 22 Aug 2022 20:49:31 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4MBZwj1rPtz4x1P;
        Tue, 23 Aug 2022 13:49:24 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1661226566;
        bh=zwVDoxhDaKTAcllgTeGlBZohftHVRRInejxRQdHAIK8=;
        h=Date:From:To:Cc:Subject:From;
        b=UFN5Lbch7VC8nJCLxN/lR03xTpHadiyD81l7r0iexSYhWQBFj5wSZWYU/RXHPnkNF
         jMaBFEB364BoN2pLaCKkWjAg1qH/jpTkV7rDbs6XNmYJtPpKB7ebxZjmkImkx7rGwI
         3TXOj2I/KkX/dpEfjKLE8EdLNcudg1LNxSdtk+hDmmeu+2Ayklu0QGghLcHFrX5nh2
         NChSXHgQtZNfQYpEGuNuez5Q13WoaOaGLEfFRPvIQ7rG0e26JWKilbeU4fHpvdu3fD
         tcLxy6PHEDAIlho7vhbcpq9ZETuiCvfya1VPV1B4yS4CJUeRmiehfYdueTpGKhOuyj
         XFN3P88WV5L6w==
Date:   Tue, 23 Aug 2022 13:49:05 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: linux-next: build warning after merge of the net-next tree
Message-ID: <20220823134905.57ed08d5@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/EpyMkXV1ufNzVjgrnN.Xw7Q";
 protocol="application/pgp-signature"; micalg=pgp-sha256
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/EpyMkXV1ufNzVjgrnN.Xw7Q
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the net-next tree, today's linux-next build (htmldocs)
produced this warning:

Documentation/admin-guide/sysctl/net.rst:37: WARNING: Malformed table.
Text in column margin in table line 4.

=3D=3D=3D=3D=3D=3D=3D=3D=3D =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D =3D =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D =3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D
Directory Content               Directory  Content
=3D=3D=3D=3D=3D=3D=3D=3D=3D =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D =3D =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D =3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D
802       E802 protocol         mptcp     Multipath TCP
appletalk Appletalk protocol    netfilter Network Filter
ax25      AX25                  netrom     NET/ROM
bridge    Bridging              rose      X.25 PLP layer
core      General parameter     tipc      TIPC
ethernet  Ethernet protocol     unix      Unix domain sockets
ipv4      IP version 4          x25       X.25 protocol
ipv6      IP version 6
=3D=3D=3D=3D=3D=3D=3D=3D=3D =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D =3D =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D =3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D

Introduced by commit

  1202cdd66531 ("Remove DECnet support from kernel")

--=20
Cheers,
Stephen Rothwell

--Sig_/EpyMkXV1ufNzVjgrnN.Xw7Q
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmMETjEACgkQAVBC80lX
0GyVmQf9FdALQO+Cp+PfLxtWw6GatjoLFBtyepaauYStFYv6/oCbJwyvHvWK6+8f
dXe64LS9SGMKVH71yutiNT9uiy3rwBvn356VprYFaHq7fH0d+KMDh8PwAv0uqnhi
Y4NxI8eJQj0j3DkOFNGzYbVeja6hwDtkxL2D01YuCBr2ZtcExkRBi/7tW7H90Buw
pRkUtH5+rudCcMD1pcP2LSm+qmn5uxEDWc5GlWDoWokvScFr8nOEILWFhOOCLfWe
5xxQw2Bm60PqxwrPs5IYWyggAK0zpv1NyRIXjAe9M/weOMrvFbn6V6oseae9/Ttc
PGuDyP92vrWcXlX7N0uhTaHrtMjpJQ==
=E256
-----END PGP SIGNATURE-----

--Sig_/EpyMkXV1ufNzVjgrnN.Xw7Q--
