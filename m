Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BFD804C9A34
	for <lists+netdev@lfdr.de>; Wed,  2 Mar 2022 01:56:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238769AbiCBA5d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Mar 2022 19:57:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231641AbiCBA5c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Mar 2022 19:57:32 -0500
Received: from gandalf.ozlabs.org (mail.ozlabs.org [IPv6:2404:9400:2221:ea00::3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 966D43AA42;
        Tue,  1 Mar 2022 16:56:49 -0800 (PST)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4K7bKq5CMZz4xmt;
        Wed,  2 Mar 2022 11:56:47 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1646182608;
        bh=SesFzBWRmlD+D61ZgRlZ9X8NwELykEcAwVUZ4QGvghM=;
        h=Date:From:To:Cc:Subject:From;
        b=bFNR9igU8M75ysTRd4DNEgsbynLgE6ugbaJ2okXP2Z86wGRPRf3c45LMpRNZVz2O8
         zb6NWQgDq6iBVvfqPJfoKCklaZHZkSV0hkM25OjqQI+5lhDFY3PVVE7lW/KrPUs7RC
         s4iQxJ2v1qtOnHFPjY9nU46DLgQulbvQ4u83A6gfj+iP85/harPccuQ5WgQzyNcvzz
         CMGbRj1nByTYoLIS0LS5GsSfcT2ZNIOp4sRicZRwIqAScXtn2E4qEe+LGVkcxapIdM
         /F8vsOJKohilr5laYXtihHXRGyWkAIlHQlNZ7qSzAyyUJxfcn5fmo6I+MPn7hporzK
         aIcGFmx1X9ICw==
Date:   Wed, 2 Mar 2022 11:56:46 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Dust Li <dust.li@linux.alibaba.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: linux-next: build failure after merge of the net-next tree
Message-ID: <20220302115646.422e29cd@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/==/b6bfPzf0Gtz9m8D4g_Ar";
 protocol="application/pgp-signature"; micalg=pgp-sha256
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/==/b6bfPzf0Gtz9m8D4g_Ar
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the net-next tree, today's linux-next build (x86_64
allmodconfig) failed like this:


Caused by commit

  12bbb0d163a9 ("net/smc: add sysctl for autocorking")

( or maybe commit

  dcd2cf5f2fc0 ("net/smc: add autocorking support")
)

I have used the net-next tree from next-20220301 for today.

--=20
Cheers,
Stephen Rothwell

--Sig_/==/b6bfPzf0Gtz9m8D4g_Ar
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmIewM4ACgkQAVBC80lX
0GyXIAf/bl55ucB1V6977F8yxBbMPXj0lAubSekevwQSXbnjZdig5EyFan+ONKIu
2XxDHPrMKlz3m1npOkMXTZTx3XKDN5VO08X8C/9TzVop8bdmClrTPejeTU6e/52w
nG4fhvUCDLPakwai+iSf8ad/cgMWOcv0uQKz5/DRYDmE9/0Oz0zkHjDT5Ya4FKXh
Raj9NukB2J9Bg4qA3NyI2Y7lLNiV4SiQy3wesAW05/ddYUEMzf4nV6LhbLdfM/hs
WtEMjdEvwAGjSpknC6Ris80AURynu2Sy+iNbDENl01nFesD90SiyBK0JCQeCbUSe
g176xiXr4w1MS2JzlQi2IHDd3g+LvA==
=IVky
-----END PGP SIGNATURE-----

--Sig_/==/b6bfPzf0Gtz9m8D4g_Ar--
