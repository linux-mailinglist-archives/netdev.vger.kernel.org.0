Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B41A4CB9E3
	for <lists+netdev@lfdr.de>; Thu,  3 Mar 2022 10:14:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231575AbiCCJOt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Mar 2022 04:14:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229930AbiCCJOr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Mar 2022 04:14:47 -0500
Received: from gandalf.ozlabs.org (mail.ozlabs.org [IPv6:2404:9400:2221:ea00::3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 931B7114FDC;
        Thu,  3 Mar 2022 01:14:00 -0800 (PST)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4K8QJy1TSWz4xPv;
        Thu,  3 Mar 2022 20:13:53 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1646298836;
        bh=Wvr6CMRqv+YOEInINIjaoz2aYxnUJDydnztIB1tsy0c=;
        h=Date:From:To:Cc:Subject:From;
        b=LN9xIEwMzeKgwT95lacBsKMlXN/nfha2UCXKOk5dI+LOWpy7iRAKKm7fB0BtoA0j+
         h/y12I9KDEUMHj0gWViWjou8uTdlihjv4zkhHx7htTWXg9Cuz7uCuUQwEz6xb0q/lo
         foZvCVOFML/YZEWW9VP11d4CpovjwpXdkBauQ8m5lzm3VrHgMhPY7ZNECMB1hNeMdd
         rpAFkG6a+ZQqlkxIDb5vkI+oCQ0HI9rIlqB1R/EEKmu5XjDO4oGUKWC1B+u6lxmgfz
         ToGPz630TztmBQT3Ta8SgVfuuedYy+WMhtig6WDYeH1rP3EsAz5qMmIN62X+eCLrkp
         5RnQcS6yZSmew==
Date:   Thu, 3 Mar 2022 20:13:52 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Dust Li <dust.li@linux.alibaba.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: linux-next: build warning after merge of the net-next tree
Message-ID: <20220303201352.43ea21a3@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/zjpJgtwnyLfLRNSa1T/FSQw";
 protocol="application/pgp-signature"; micalg=pgp-sha256
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/zjpJgtwnyLfLRNSa1T/FSQw
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the net-next tree, today's linux-next build (htmldocs)
produced this warning:

Documentation/networking/smc-sysctl.rst:3: WARNING: Title overline too shor=
t.

=3D=3D=3D=3D=3D=3D=3D=3D=3D
SMC Sysctl
=3D=3D=3D=3D=3D=3D=3D=3D=3D

Introduced by commit

  12bbb0d163a9 ("net/smc: add sysctl for autocorking")

--=20
Cheers,
Stephen Rothwell

--Sig_/zjpJgtwnyLfLRNSa1T/FSQw
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmIghtAACgkQAVBC80lX
0GwmhQf/SHQ1PVdRe5wKt9sPZ7t1uRlzJwbycdEGt7wW5pundPvFFY9BvT/pIz9i
WN6sPO1cEgPrYjvVzqYnk4fZH+LMYTfxBXnqgPg6jRDYxWC+h6vlWszbAabpjUHX
+7pnIovl2Q7/gV453Jlgq1Wi9aPR9lSjeKaC1DOXNlUjGE/YwCTkz75RCiBK4Zgx
kdg2jkCY+DAaIPulrSzm7zyAFoZkhyqpfcKBnnWk42DL8mLoDHex2pxO7ldsYH7m
JAcwsA3gc95yT4/7PPp8Qj7uZ/nfPDaooMnm28k5Sumxre27KXP1cvsjKrU3zPE0
uRKn8Z9gvv+Nb719iRi7GaeSLG33Ug==
=KAXw
-----END PGP SIGNATURE-----

--Sig_/zjpJgtwnyLfLRNSa1T/FSQw--
