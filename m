Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 48A9553DE8D
	for <lists+netdev@lfdr.de>; Mon,  6 Jun 2022 00:07:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351640AbiFEWGm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Jun 2022 18:06:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238038AbiFEWGl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Jun 2022 18:06:41 -0400
Received: from gandalf.ozlabs.org (mail.ozlabs.org [IPv6:2404:9400:2221:ea00::3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 899D441325;
        Sun,  5 Jun 2022 15:06:39 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4LGW154FhMz4xD5;
        Mon,  6 Jun 2022 08:06:33 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1654466794;
        bh=bDmkiPAmGxOxxf3MnbA7QTD5Tlj7f9n8KUNXNvkAsGA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=hY14ILY0xC+PglDjVpzkq6Zmuy2EoY7QxyxxT+/W9RWA6iX+FIvM4EB6z1SnHyGwd
         wOLBM54pl7cRWTncOSRh7mE62kKFvrAXiuKB3YtgTP0ozGUFCCmRh1kv0VBN3puadM
         U3P/x4W+aKF7o/JXJQ+w1BYD1zUeuwv86C6o801/8RJ5MNUR+g9p7K93F06WXlPge1
         YgT1zm7oWiSuAB+4YB9bdjZzTFGIFLoB+cghLRhrqNec+I940ksd+WM4yeoq0hxDxE
         XNb/PpdSzkLdqm2saAcf//N/vdAcC76LO9F7XxkXAQZhPf8iIN5wvFUHbQJ29IpXVh
         X7SS8PEmzk1hQ==
Date:   Mon, 6 Jun 2022 08:06:31 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Yury Norov <yury.norov@gmail.com>
Cc:     Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: linux-next: build warning after merge of the bluetooth tree
Message-ID: <20220606080631.0c3014f2@canb.auug.org.au>
In-Reply-To: <20220524082256.3b8033a9@canb.auug.org.au>
References: <20220516175757.6d9f47b3@canb.auug.org.au>
        <20220524082256.3b8033a9@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/NfK1QhUQelOcihP8s8I/Px9";
 protocol="application/pgp-signature"; micalg=pgp-sha256
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/NfK1QhUQelOcihP8s8I/Px9
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

On Tue, 24 May 2022 08:22:56 +1000 Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
>
> On Mon, 16 May 2022 17:57:57 +1000 Stephen Rothwell <sfr@canb.auug.org.au=
> wrote:
> >=20
> > After merging the bluetooth tree, today's linux-next build (arm
> > multi_v7_defconfig) produced this warning:
> >=20
> > In file included from include/linux/cpumask.h:12,
> >                  from include/linux/mm_types_task.h:14,
> >                  from include/linux/mm_types.h:5,
> >                  from include/linux/buildid.h:5,
> >                  from include/linux/module.h:14,
> >                  from net/bluetooth/mgmt.c:27:
> > In function 'bitmap_copy',
> >     inlined from 'bitmap_copy_clear_tail' at include/linux/bitmap.h:270=
:2,
> >     inlined from 'bitmap_from_u64' at include/linux/bitmap.h:622:2,
> >     inlined from 'set_device_flags' at net/bluetooth/mgmt.c:4534:4:
> > include/linux/bitmap.h:261:9: warning: 'memcpy' forming offset [4, 7] i=
s out of the bounds [0, 4] of object 'flags' with type 'long unsigned int[1=
]' [-Warray-bounds]
> >   261 |         memcpy(dst, src, len);
> >       |         ^~~~~~~~~~~~~~~~~~~~~
> > In file included from include/linux/kasan-checks.h:5,
> >                  from include/asm-generic/rwonce.h:26,
> >                  from ./arch/arm/include/generated/asm/rwonce.h:1,
> >                  from include/linux/compiler.h:248,
> >                  from include/linux/build_bug.h:5,
> >                  from include/linux/container_of.h:5,
> >                  from include/linux/list.h:5,
> >                  from include/linux/module.h:12,
> >                  from net/bluetooth/mgmt.c:27:
> > net/bluetooth/mgmt.c: In function 'set_device_flags':
> > net/bluetooth/mgmt.c:4532:40: note: 'flags' declared here
> >  4532 |                         DECLARE_BITMAP(flags, __HCI_CONN_NUM_FL=
AGS);
> >       |                                        ^~~~~
> > include/linux/types.h:11:23: note: in definition of macro 'DECLARE_BITM=
AP'
> >    11 |         unsigned long name[BITS_TO_LONGS(bits)]
> >       |                       ^~~~
> >=20
> > Introduced by commit
> >=20
> >   a9a347655d22 ("Bluetooth: MGMT: Add conditions for setting HCI_CONN_F=
LAG_REMOTE_WAKEUP")
> >=20
> > Bitmaps consist of unsigned longs (in this case 32 bits) ...
> >=20
> > (This warning only happens due to chnges in the bitmap tree.) =20
>=20
> I still got this warning yesterday ...

And today, I get this warning when build Linus' tree :-(
--=20
Cheers,
Stephen Rothwell

--Sig_/NfK1QhUQelOcihP8s8I/Px9
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmKdKOcACgkQAVBC80lX
0GwB5Af8DLzLF4VOEKyXegJuuaWyj/AqpNwlwrN61ssJ/o/z1E7WH8tiNqYhpQaq
VLE+ySXm+s69u3VjBZCSXDT4K+PynjOUXa/OnRyBp5I0wAMSVVu5fWsRMrWlwCaX
GKzBGwlirkA5QUgKkQkl3XWw3XTxU8C7mC3sbP2CJiAKBTcM/FpUmTzO1LjVFAUM
MDCWcvOqmKuRBGZjDKhIfJOeRnTWQMxYFgSYgoTqHVFTGanqjuLDSUldQs0/Rgp7
eSeY5retVHz3WvnmFdmd0Vf1MpMrGIEdbJNAmGUr+VtpsDTFulhVjfH6G5viIcdH
SLEEKVInn6qNOlXsJCeU1s//mCiItQ==
=q3BK
-----END PGP SIGNATURE-----

--Sig_/NfK1QhUQelOcihP8s8I/Px9--
