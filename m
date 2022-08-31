Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 03CEC5A76C2
	for <lists+netdev@lfdr.de>; Wed, 31 Aug 2022 08:38:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229488AbiHaGiy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Aug 2022 02:38:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230306AbiHaGie (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Aug 2022 02:38:34 -0400
Received: from gandalf.ozlabs.org (mail.ozlabs.org [IPv6:2404:9400:2221:ea00::3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D9B5BD77A;
        Tue, 30 Aug 2022 23:38:32 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4MHZJ26Syjz4xG9;
        Wed, 31 Aug 2022 16:38:25 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1661927907;
        bh=Mfa+WJavmZH755TJjYyiSYl3pOBeXXNV8JnJ6g3kaaM=;
        h=Date:From:To:Cc:Subject:From;
        b=UOCZwsQD+yhdDrElF4fEwZQNxMKQyoFvEIenZKcuQm5N56rgRTsOfruitdP6M5oN5
         RqEhz7KBkh/IUOKY9ChrFpByRTCxJGleKN7mpld9TUg+V27gNfMgm4+a3o2ainVUqr
         3MrEqSI87+QqLs1uFT1y1mgief5LHBHnNnLQhhMZz+vB1GKEdtTbFTbj53cfhgmDhn
         XZuyN3bwMm36vu/RqjgHd1pXfdYRDKIuq3RcNnCHdcYVlqZabcQiCGltJ4HIBHF6jW
         I9d9LZje8AXkIMdStMIe93lB1KMw9Wjqb7ui+AZu/8sxuCpr3AR3/u/0glk1UV21RB
         VMH7LPUdVXVEg==
Date:   Wed, 31 Aug 2022 16:38:24 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Lin Ma <linma@zju.edu.cn>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: linux-next: Fixes tag needs some work in the net tree
Message-ID: <20220831163824.03b1b61b@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/nyN5hq=.7V8DNzqSK.a3//E";
 protocol="application/pgp-signature"; micalg=pgp-sha256
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/nyN5hq=.7V8DNzqSK.a3//E
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

In commit

  afe7116f6d3b ("ieee802154/adf7242: defer destroy_workqueue call")

Fixes tag

  Fixes: 58e9683d1475 ("net: ieee802154: adf7242: Fix OCL calibration

has these problem(s):

  - Subject has leading but no trailing parentheses
  - Subject has leading but no trailing quotes

In the future, please do not split Fixes tags over more than one line.

--=20
Cheers,
Stephen Rothwell

--Sig_/nyN5hq=.7V8DNzqSK.a3//E
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmMPAeAACgkQAVBC80lX
0GyNJQf+P8i+jK3g5oALbtdvvIGDQdgVWWEo/zuXCBbWK2IvBfk4rJIuLgANIuJP
z+zDVLMHvSPLOaGXPp3vuDtFKhkRhaCzEO4cuw8zVNNaF/T/f0K2rP/2uwPcsxhI
aWipf1AhKWJ1XvbWHFHr0KxjkwsqJM8De2HEEzvrYgxG+mWTswd1LRNEuWLtCapG
m2jFnj0FKH802ECugohMWe6GWg1hDiv4fsvZVbAAtUMZqUjUjSyRIN0Xx0UikaSS
jqt34BQDHeCWnHiMkEQSm/6vU4hc34IAua3RUbT/PO3qmpvzEc9Yd5bnYmXpGubI
ACq6csofuhEysVnmyRPk4Q/yG3cLig==
=zAms
-----END PGP SIGNATURE-----

--Sig_/nyN5hq=.7V8DNzqSK.a3//E--
