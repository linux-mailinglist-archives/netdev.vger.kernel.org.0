Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF4B853DF45
	for <lists+netdev@lfdr.de>; Mon,  6 Jun 2022 03:16:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351935AbiFFBQg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Jun 2022 21:16:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241008AbiFFBQg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Jun 2022 21:16:36 -0400
Received: from gandalf.ozlabs.org (mail.ozlabs.org [IPv6:2404:9400:2221:ea00::3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46D9B4E3A7;
        Sun,  5 Jun 2022 18:16:34 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4LGbDC4Cmwz4xDK;
        Mon,  6 Jun 2022 11:16:27 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1654478188;
        bh=NSfCInElj8gvzdEZsEIDFPfbLOUwPQ6wXjMgnxMr02Q=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=YO4+dWPAzlntVfpe/NOJ49qS2ouQbToF/7IeeMXNa7of6KWeUZ92oyJl/I4KNV9z+
         iv5+ZzBZFcGQSgAvSr/FP/YndTEBszgcg41kSy7r6bi5xJsQ00DoSDaY2FBoUlvqya
         V0En6YbhbgPL9QwzQ6jZyBL9JIw8WNZ8XO/TnM2pyIOTKvIVfolHwAHj22KYfJu2Uk
         VgbItbZiSW/Db8Yghh/If4owXMwyFRYONr9OJp1mrQvj4ieNHYNjzHgNxJM74tirbd
         VORqyzrZkwq/zgKvLnxKW6Dawp1q2M0+piKIB5Aotr3FqYpEPPp33Gv/Auhj4sHcMh
         FvWwdBN4vGR9A==
Date:   Mon, 6 Jun 2022 11:16:26 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Yury Norov <yury.norov@gmail.com>
Cc:     Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: linux-next: build warning after merge of the bluetooth tree
Message-ID: <20220606111531.00bc960a.sfr@canb.auug.org.au>
In-Reply-To: <Yp0w21pH4R6WaC1R@yury-laptop>
References: <20220516175757.6d9f47b3@canb.auug.org.au>
        <20220524082256.3b8033a9@canb.auug.org.au>
        <20220606080631.0c3014f2@canb.auug.org.au>
        <Yp0w21pH4R6WaC1R@yury-laptop>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/YzMUj8d/JLdDHO_PT6w4o6o";
 protocol="application/pgp-signature"; micalg=pgp-sha256
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/YzMUj8d/JLdDHO_PT6w4o6o
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Yury,

On Sun, 5 Jun 2022 15:40:27 -0700 Yury Norov <yury.norov@gmail.com> wrote:
>
> I completely forgot about this bug, and sent a quick fix when this
> was spotted by Sudip [1]. Linus proposed another fix [2] that drops
> bitmap API in net/bluetooth/mgmt.c.
>=20
> I would prefer Linus' version, and this is the way I already suggested
> to Luiz before in this thread.
>=20
> Thanks,
> Yury
>=20
> [1] https://lore.kernel.org/lkml/YpyJ9qTNHJzz0FHY@debian/t/
> [2] https://lore.kernel.org/lkml/CAHk-=3DwhqgEA=3DOOPQs7JF=3Dxps3VxjJ5uUn=
fXgzTv4gqTDhraZFA@mail.gmail.com/T/#mcf29754f405443ca7d2a18db863c7a20439bd5=
a0

Linus has applied his fix to his tree now (before -rc1), so it should
be all good.

--=20
Cheers,
Stephen Rothwell

--Sig_/YzMUj8d/JLdDHO_PT6w4o6o
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmKdVWoACgkQAVBC80lX
0Gxoqwf/TkPwfHFtuVTjt5YwKxTUZrA0kEaCCz+gHsxY3d9kw2Bltlbut5RH8pmZ
AMnFFadmlw1UKNihBXku7TucJ0kehZLfYi4nyac8nut50nThf7a1sQu20B1GO5nz
b1WEGnkVIbSfASBlQHz7m7l5JnRZf/9QofogsI7YfUEWpg6nZOL7hVX0F9pdjEIg
RoUNUmp0UVC3dJ1NX4/wPUzKYlIRQud7QVben4bVRbEyEcF/aJaGybMQeveBbTQF
PO8Of5lCHKpUUtw/7YZ8/kMQfuWQdhMKrcl1DK5pTpvA7yE7larfE99RQUi9ANd+
J/Mh2Z5a+up7GQbJ+bFz+rXoMpDiLg==
=TsjI
-----END PGP SIGNATURE-----

--Sig_/YzMUj8d/JLdDHO_PT6w4o6o--
