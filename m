Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF3704D0BEA
	for <lists+netdev@lfdr.de>; Tue,  8 Mar 2022 00:19:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245137AbiCGXUJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Mar 2022 18:20:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235279AbiCGXUH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Mar 2022 18:20:07 -0500
Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFF6133A2D;
        Mon,  7 Mar 2022 15:19:11 -0800 (PST)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4KCDtH6pLqz4xvZ;
        Tue,  8 Mar 2022 10:19:03 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1646695148;
        bh=f6lolPIC5IwKsskdbeaJLI6CQbyWlj670tBD1PrZiFU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=rtQsTnf2fM/PW6Yxqdh9+8bGgk+r0/Z7391IQU2irc2Fa2Jiwtndzx1uoOhhDoRqB
         OY0wy/oCebxT10Wh49bgOfAMeOUg+mFYO6WcSXH5MeZDKqyAEDVjyDFbQ1GwYQ3sKf
         nzcTKw8YzUetVNmaTGLh8313P1Ny2YBWXLMzZlVbwJFP02dSFrKLIxZ9GA9aHUZXDt
         uMesZneKQqo0Mha3JoeARnUnHTmeC0TjTeIN9kP1kp7updi5mf9AHWye9Kn/0pMlpL
         m7GJg6Wi+MbfxPCTrdAG9SoyHlZX4dN94zren4EuywTKQpzmvG4mpwbo/tkfqkydel
         d1TiTHqym+URQ==
Date:   Tue, 8 Mar 2022 10:19:03 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Marcel Holtmann <marcel@holtmann.org>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: Re: linux-next: Signed-off-by missing for commits in the net-next
 tree
Message-ID: <20220308101903.68e0ba72@canb.auug.org.au>
In-Reply-To: <20220307150248.388314c1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20220307072248.7435feed@canb.auug.org.au>
        <20220307150248.388314c1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/Reui66SgsK_ABwD5cryGsg6";
 protocol="application/pgp-signature"; micalg=pgp-sha256
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/Reui66SgsK_ABwD5cryGsg6
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Jakub,

On Mon, 7 Mar 2022 15:02:48 -0800 Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Mon, 7 Mar 2022 07:22:48 +1100 Stephen Rothwell wrote:
> >=20
> > Commits
> >=20
> >   c2b2a1a77f6b ("Bluetooth: Improve skb handling in mgmt_device_connect=
ed()")
> >   ba17bb62ce41 ("Bluetooth: Fix skb allocation in mgmt_remote_name() & =
mgmt_device_connected()")
> >   a6fbb2bf51ad ("Bluetooth: mgmt: Remove unneeded variable")
> >   8cd3c55c629e ("Bluetooth: hci_sync: fix undefined return of hci_disco=
nnect_all_sync()")
> >   3a0318140a6f ("Bluetooth: mgmt: Replace zero-length array with flexib=
le-array member")
> >=20
> > are missing a Signed-off-by from their committer. =20
>=20
> Would it be possible to add bluetooth trees to linux-next?
>=20
> Marcel, Luiz, Johan, would it help?

I already have

git://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth-next.git
branch master

in linux-next.  Those commits appeared in the bluetooth and net-next
trees on the same day (Monday) for me.
--=20
Cheers,
Stephen Rothwell

--Sig_/Reui66SgsK_ABwD5cryGsg6
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmImkucACgkQAVBC80lX
0GwWJggApMriWmXL058glg0rQD+d+Cgu/IvprAQpgcdBnaQDZ2xzH4hCZmTiBkj7
evCJlER5qAgEJXVSvrVB635a/J+TcVEO3/wKugyapSrUlYAOSBgedmne2Iy2kmeI
jjp1gVVlUs2ji2bEiCPcXH+rT6NKk3yHIUeShe8nTieW+6QLjHPyrSTif4rcz63S
C5+056XdwAkuWh5BxzIazNA6PLr1MFpCBSXd9hmSD35fUjj7B7XesAErN1jZl9w/
viq9gbc9qv0MqFDLXezbZ3pW+VE3yFLlFnvBsa6mGDXEWOTSszAtBigLr4St657k
Avzt67XP/dhaFDVmngoHkV4/2zvW8w==
=Z3y5
-----END PGP SIGNATURE-----

--Sig_/Reui66SgsK_ABwD5cryGsg6--
