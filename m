Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F0B52531E8B
	for <lists+netdev@lfdr.de>; Tue, 24 May 2022 00:23:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231217AbiEWWXH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 May 2022 18:23:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229777AbiEWWXG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 May 2022 18:23:06 -0400
Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62BE07C17D;
        Mon, 23 May 2022 15:23:03 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4L6X014vHXz4xXj;
        Tue, 24 May 2022 08:22:57 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1653344578;
        bh=fiBBP1CwLxOOiEJzduELiG5+UCGaqySIgp41nnB4s84=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=fV92vlENlHuJ/QYqjGAOoE54AhITOz1ZMBUtx7JwoPdqvG5cSXnR10GKPe0T7icwE
         BIBcAqNb2K/bPAJPyLCtgqo8ZkD4vXnt1LqH0pPspg5pP0lb9367N54IyIMUyWenWc
         4NC/fyPqa89L6D43W4Ac7Oz38Okct59hpRoh5ux1IlqukIdSwGGlBvWDUs3M9Y5b5a
         PKq+t7zutTPM+2+MZXiRKKLihlnk1o8/nTaQHcixYGKJ5ZmeYvhSqweXrIlwmuh5CB
         2vQ1YN35aTEs1nLq6BboqAdKIhSQcsc1goBO0/cCZeJ8AHJbwEHimyjZ54/3G3Vc5X
         CbRMj8nWyTK/A==
Date:   Tue, 24 May 2022 08:22:56 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Yury Norov <yury.norov@gmail.com>
Cc:     Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Subject: Re: linux-next: build warning after merge of the bluetooth tree
Message-ID: <20220524082256.3b8033a9@canb.auug.org.au>
In-Reply-To: <20220516175757.6d9f47b3@canb.auug.org.au>
References: <20220516175757.6d9f47b3@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/zscRXC6yYxWnLTKDmeusqjf";
 protocol="application/pgp-signature"; micalg=pgp-sha256
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/zscRXC6yYxWnLTKDmeusqjf
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

On Mon, 16 May 2022 17:57:57 +1000 Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
>=20
> After merging the bluetooth tree, today's linux-next build (arm
> multi_v7_defconfig) produced this warning:
>=20
> In file included from include/linux/cpumask.h:12,
>                  from include/linux/mm_types_task.h:14,
>                  from include/linux/mm_types.h:5,
>                  from include/linux/buildid.h:5,
>                  from include/linux/module.h:14,
>                  from net/bluetooth/mgmt.c:27:
> In function 'bitmap_copy',
>     inlined from 'bitmap_copy_clear_tail' at include/linux/bitmap.h:270:2,
>     inlined from 'bitmap_from_u64' at include/linux/bitmap.h:622:2,
>     inlined from 'set_device_flags' at net/bluetooth/mgmt.c:4534:4:
> include/linux/bitmap.h:261:9: warning: 'memcpy' forming offset [4, 7] is =
out of the bounds [0, 4] of object 'flags' with type 'long unsigned int[1]'=
 [-Warray-bounds]
>   261 |         memcpy(dst, src, len);
>       |         ^~~~~~~~~~~~~~~~~~~~~
> In file included from include/linux/kasan-checks.h:5,
>                  from include/asm-generic/rwonce.h:26,
>                  from ./arch/arm/include/generated/asm/rwonce.h:1,
>                  from include/linux/compiler.h:248,
>                  from include/linux/build_bug.h:5,
>                  from include/linux/container_of.h:5,
>                  from include/linux/list.h:5,
>                  from include/linux/module.h:12,
>                  from net/bluetooth/mgmt.c:27:
> net/bluetooth/mgmt.c: In function 'set_device_flags':
> net/bluetooth/mgmt.c:4532:40: note: 'flags' declared here
>  4532 |                         DECLARE_BITMAP(flags, __HCI_CONN_NUM_FLAG=
S);
>       |                                        ^~~~~
> include/linux/types.h:11:23: note: in definition of macro 'DECLARE_BITMAP'
>    11 |         unsigned long name[BITS_TO_LONGS(bits)]
>       |                       ^~~~
>=20
> Introduced by commit
>=20
>   a9a347655d22 ("Bluetooth: MGMT: Add conditions for setting HCI_CONN_FLA=
G_REMOTE_WAKEUP")
>=20
> Bitmaps consist of unsigned longs (in this case 32 bits) ...
>=20
> (This warning only happens due to chnges in the bitmap tree.)

I still got this warning yesterday ...

--=20
Cheers,
Stephen Rothwell

--Sig_/zscRXC6yYxWnLTKDmeusqjf
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmKMCUAACgkQAVBC80lX
0Gzm/Af/c9T/h9Tg15i2XoL+FySraisx0potlPbWJtmaPxVay9I4VcEwikcJyyIr
b19gSux7jkvkPvhKEe0HY5qPZucDZi5mYutpphPx/wMkgCDfmamX4He/di2zlZtQ
OV0tJN0eiUTT9XQGmImzLywV8feb2Pe+rjuvXn9P2Y6MmI17axPvHXM9MOC7ViLr
7d8YXqyb2KLfmrSqwqeO8w918wom5Eb0HNYG1zWZHwgq/b/twN4fsQvAy6zJYweK
tXNFt2JLunfLsHqxqQiC0E5uPLbmd79ZOv6BZPAG+mqlE7W7T+A7xaHUhCWL4pbo
XVQiDcuwuxbRJwjPKVpg+ZrleAxjeQ==
=lsMX
-----END PGP SIGNATURE-----

--Sig_/zscRXC6yYxWnLTKDmeusqjf--
