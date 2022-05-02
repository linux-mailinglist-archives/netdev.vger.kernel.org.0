Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5865C51691B
	for <lists+netdev@lfdr.de>; Mon,  2 May 2022 03:16:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356392AbiEBBTQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 May 2022 21:19:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231254AbiEBBTO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 May 2022 21:19:14 -0400
Received: from gandalf.ozlabs.org (mail.ozlabs.org [IPv6:2404:9400:2221:ea00::3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3219911A25;
        Sun,  1 May 2022 18:15:45 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4Ks4sS4QPmz4xdK;
        Mon,  2 May 2022 11:15:39 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1651454141;
        bh=Jk7AExWT9OpK1U0dF6pKqW8jWAbfXyujcmahNjOhKxk=;
        h=Date:From:To:Cc:Subject:From;
        b=gttuS7JDBltC7uIehF4yyOjE/3mApywujCd66Wp5IzzfvUOZDdMCHkqRRCWQnAFJs
         5sWp93yniP2sU9DewQhV3PVX8qAhc6+7/n0qKHaX7kbrGCltYkoD70BlFWeRGviB8y
         6PDltBpWQ+0X9zsA9xPePcZWBFeB6EHQt6orykHMMppouZkFzMrCbnwkRSSB+XbACo
         vhqoXr++nqqI1K6lPKveI25wFl2CPaS52JGX0sxZZetLy0wtsivCZxBP/+8fu0+Ykf
         1H+RCLWe6s93O7TixDkHj+rk5X9Q1aRqEl1B88IAtWGVwfq0ZWIzFr6J4bLE5uQ1fX
         Vr/ghQhU2DaiQ==
Date:   Mon, 2 May 2022 11:15:39 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Hangbin Liu <liuhangbin@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Joachim Wiberg <troglobit@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: linux-next: manual merge of the net-next tree with the net tree
Message-ID: <20220502111539.0b7e4621@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/WYaI_2j9ow=s5DrQWb3PW8e";
 protocol="application/pgp-signature"; micalg=pgp-sha256
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/WYaI_2j9ow=s5DrQWb3PW8e
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the net-next tree got a conflict in:

  tools/testing/selftests/net/forwarding/Makefile

between commit:

  f62c5acc800e ("selftests/net/forwarding: add missing tests to Makefile")

from the net tree and commit:

  50fe062c806e ("selftests: forwarding: new test, verify host mdb entries")

from the net-next tree.

I fixed it up (see below) and can carry the fix as necessary. This
is now fixed as far as linux-next is concerned, but any non trivial
conflicts should be mentioned to your upstream maintainer when your tree
is submitted for merging.  You may also want to consider cooperating
with the maintainer of the conflicting tree to minimise any particularly
complex conflicts.

--=20
Cheers,
Stephen Rothwell

diff --cc tools/testing/selftests/net/forwarding/Makefile
index c87e674b61b1,ae80c2aef577..000000000000
--- a/tools/testing/selftests/net/forwarding/Makefile
+++ b/tools/testing/selftests/net/forwarding/Makefile
@@@ -2,7 -2,7 +2,8 @@@
 =20
  TEST_PROGS =3D bridge_igmp.sh \
  	bridge_locked_port.sh \
+ 	bridge_mdb.sh \
 +	bridge_mld.sh \
  	bridge_port_isolation.sh \
  	bridge_sticky_fdb.sh \
  	bridge_vlan_aware.sh \

--Sig_/WYaI_2j9ow=s5DrQWb3PW8e
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmJvMLsACgkQAVBC80lX
0Gy2Zwf+PfEcGvSUt8bqUHECfKbdzaRDWbpkHLpB0FWKiQxnW8dW/gQV/f4eVluh
sKEBu4ZCogom7qFMnKahaIwGn3pvsnx9JZ8pHGBi3lyLKDvM15RdspPH0n7yNI8S
PftiIJM6S/8LV6O/6fB1sUaU4Am/+7xRha/FgdPVZ2mDi2xPGKhfiisoTnsWvggu
blsRl7eBh7AYk+utRVjYFqbqp1Nqv8fzVnbVl1b8JW8nOqOcVK7v8hkfaY2w/jSA
tDkt+kUZgyf8S/wkGf/UFbkV1W00cGEhqw3hiPsrygDVP1OAGvGHgfgRriLTFasV
FyODnI2T3UpMfdEVlNwaaidRtIXESQ==
=35uy
-----END PGP SIGNATURE-----

--Sig_/WYaI_2j9ow=s5DrQWb3PW8e--
