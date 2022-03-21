Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F50E4E26A6
	for <lists+netdev@lfdr.de>; Mon, 21 Mar 2022 13:35:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347357AbiCUMhB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Mar 2022 08:37:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236565AbiCUMhA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Mar 2022 08:37:00 -0400
Received: from gandalf.ozlabs.org (mail.ozlabs.org [IPv6:2404:9400:2221:ea00::3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5FAE1F619;
        Mon, 21 Mar 2022 05:35:34 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4KMYxG5SyMz4xNq;
        Mon, 21 Mar 2022 23:35:30 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1647866131;
        bh=NQKo9FIKqY9u7TjgkhyAI+6zVMUtISL0WDla4R4QnWY=;
        h=Date:From:To:Cc:Subject:From;
        b=RGe5FZYqDVS+g8AiLbzcC55LJJdJ2t7SweK6Z/nuzS5n11ncToziEunFnMQa7zFD1
         9qLabWGzHV8lU0dJfVKTQHJ/Ia7LdUOcRzuuhDD01Tn0Pfd1hbYKY2w1EDzi6/sRDL
         m9NX9OkM+2mMnJNfijhYfm+M+i6L3tbM69HdMBn2RxQQv314qvMfD0LEB1oX4vFEXR
         8kXU9qG3RY+dYJA29Nqd7svbPI5CzLSAybGaTj1Xm6/hrfz1raUb1VFRzZlVmHC6l+
         WwRZF332vH/Km8RAlRqgTpVHUBVyxuFEDm0Km508A0DK3wtj2oAkjLEMSCOSy3EuvJ
         sjP8kKpMpi4mg==
Date:   Mon, 21 Mar 2022 23:35:24 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: linux-next: run time failure after merge of the bpf-next tree
Message-ID: <20220321233524.5fdb66b6@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/o4KJpFsc9Wpo_db5+dCT+kq";
 protocol="application/pgp-signature"; micalg=pgp-sha256
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/o4KJpFsc9Wpo_db5+dCT+kq
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the bpf-next tree, today's linux-next qemu run (powerpc
pseries_le_defconfig) failed with a NULL dererence.

This has been fixed in the bpf-next tree after I merged it today, so I
have cherry-picked the fix patch into today's linux-next.

--=20
Cheers,
Stephen Rothwell

--Sig_/o4KJpFsc9Wpo_db5+dCT+kq
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmI4cQwACgkQAVBC80lX
0GziLAf9GiPXtltX35sPgenejdvmBoh/gRuPEaWzz2GbvgA1Ygk1n68yq40Sz21H
7xqzccfAvitHCAld45rky2CnnqlJN0zFv9wDlWNe8ew1Zw+Zl2Yn/YmuJRFU4itk
CYKmrxU3CumsDOBy8uGrjtyABg/OIEwVLOon13J6++fcEU4nEV4Sl6z2mkZ/ufDH
bB+OS1hMgPqFTZ4jY69ZAALZC1f6Qm0Qz16KNxOkz0BMT9+NPNgaMeYsIlL4uxCK
yENIRPQoLxs4B/XQopcsqwc7bYGxAyiIu/N3xMCxsTspy1PWzDZ//OqaZNyjWvVc
OoE9uZ43fH3Npv0XF6EgcAP8r+WVvQ==
=33je
-----END PGP SIGNATURE-----

--Sig_/o4KJpFsc9Wpo_db5+dCT+kq--
