Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E3E1262AF22
	for <lists+netdev@lfdr.de>; Wed, 16 Nov 2022 00:10:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231735AbiKOXKb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Nov 2022 18:10:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229607AbiKOXKa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Nov 2022 18:10:30 -0500
Received: from gandalf.ozlabs.org (mail.ozlabs.org [IPv6:2404:9400:2221:ea00::3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9206F2B611;
        Tue, 15 Nov 2022 15:10:28 -0800 (PST)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4NBhjS6jt0z4xG5;
        Wed, 16 Nov 2022 10:10:20 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1668553822;
        bh=fhm8U/HFFB9ybOHcPNtA20Cg6w7QILs8MaHaUQL6Qos=;
        h=Date:From:To:Cc:Subject:From;
        b=uVTTlGGMy5A4Mcer6p1i5sBWxWgPw5knKjyZN15KZAbzKU9s7oALRyIiEOFvXfZ+8
         ZrHABKZ28mh82V5sV256/BXNoFlffBom9PhtRZH+jLRl2Sqxfc3lpcyiWeBJjygmt6
         mDS0EpbS7LD6VShO5Q0VjeUyUGY6p7SgKWiXYwN3ZhuhKogruDGSzPUb+LVc7QJ0AO
         HrqD33EmCOxkTs/iWAuF80pRgc8Lm1Lx4GzVgSSbawF3Y4ujn/WWRvOv5/GlkGRAXK
         EzUuyzmYDiFhXbR1Wmi5Cvb1ezYO1lYoSpns2hKYithZbuEKuxm/JlsjAPcwdhGXKX
         h2hnNkU4mOpWg==
Date:   Wed, 16 Nov 2022 10:10:17 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        David Miller <davem@davemloft.net>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Xu Kuohai <xukuohai@huawei.com>
Subject: linux-next: manual merge of the bpf-next tree with the net tree
Message-ID: <20221116101017.235b5952@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/Me5A8Qfxn+JpOkY3s_c5Lj3";
 protocol="application/pgp-signature"; micalg=pgp-sha256
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/Me5A8Qfxn+JpOkY3s_c5Lj3
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the bpf-next tree got a conflict in:

  include/linux/bpf.h

between commit:

  1f6e04a1c7b8 ("bpf: Fix offset calculation error in __copy_map_value and =
zero_map_value")

from the net tree and commit:

  e5feed0f64f7 ("bpf: Fix copy_map_value, zero_map_value")

from the bpf-next tree.

I fixed it up (I just used the latter) and can carry the fix as
necessary. This is now fixed as far as linux-next is concerned, but any
non trivial conflicts should be mentioned to your upstream maintainer
when your tree is submitted for merging.  You may also want to consider
cooperating with the maintainer of the conflicting tree to minimise any
particularly complex conflicts.

--=20
Cheers,
Stephen Rothwell

--Sig_/Me5A8Qfxn+JpOkY3s_c5Lj3
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmN0HFkACgkQAVBC80lX
0GxPWwf/S+gFmnq8yPPU3IaosmITk2dreuKKRhL3x8Vx7ijz4/MyVWFKx9ecDWZM
Js10zM5Z6T3Y732nRadIw/fbvmBTeuQtR3XBBr71ESzHdJ1oX8ZiLbWv/gMg2OIC
5FmF93MqMWKyI6RaACSyb8SIZ1jiFoIY6xcaPHB6KQi0vT5mRi6jG//CA4PVXALT
E29vL0DgR/Df72bBKCY1QLC1mmR1bnCbNA7TtgO/zHShdikDkUZjR2F0GHomY4sL
zx2TAXNecoeCvQFAq+x/waiRwiqza4EFWaSMWiMzCYLC2dm9dS3DfahBVgaalqab
9opeDbZvAbohl8197OI6f/EHbfLcJg==
=f23a
-----END PGP SIGNATURE-----

--Sig_/Me5A8Qfxn+JpOkY3s_c5Lj3--
