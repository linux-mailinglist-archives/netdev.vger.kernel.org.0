Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3BDFC6A04C3
	for <lists+netdev@lfdr.de>; Thu, 23 Feb 2023 10:27:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233729AbjBWJ1a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Feb 2023 04:27:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233253AbjBWJ13 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Feb 2023 04:27:29 -0500
Received: from gandalf.ozlabs.org (mail.ozlabs.org [IPv6:2404:9400:2221:ea00::3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF5D13B85F;
        Thu, 23 Feb 2023 01:27:27 -0800 (PST)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4PMnjj5JdLz4x7s;
        Thu, 23 Feb 2023 20:27:21 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1677144442;
        bh=w6iPW4WhwcbH0XSafbFocLwM4VdQ80W+0qYJi1TJx2I=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=AUh9HNys5xsavyoA8u6//YrgqyqLBRKTp58XK4cpdSmdWPcChijJb3hpBn3qR4AC5
         1WSK+b/ugJn89w7rD2V6W4SbNMdM3ZnSSpO3EClXrpv0oTLOmA3UlYbURstPF0q6sB
         6gssL1Wyzk1XWiafGltuCxC3YHVAf1iMQRr3Qt/OgeIm+KboBi4H2FD8tcC7ggjBv1
         0IE6RJoskngzhts6DZhjlmlbW+d/njzbtfTUn+yJJ1Ap9Vi893E50VCm0oiP/FExH6
         NfoiPKZUYgUHyHG/wT68KdlpEwIjx2+pPOwE8luupQZ3spF4QT1DM+ORoU8HGgkkxs
         poozQFf1cc/Sw==
Date:   Thu, 23 Feb 2023 20:27:19 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Geert Uytterhoeven <geert@linux-m68k.org>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>
Subject: Re: linux-next: Tree for Feb 23
Message-ID: <20230223202719.4b3b7d6f@canb.auug.org.au>
In-Reply-To: <CAMuHMdUa+RiSx1SdKSbYb6mCbQHY6V2oer=awkaWCuHuk1cayQ@mail.gmail.com>
References: <20230223145519.11eb6515@canb.auug.org.au>
        <CAMuHMdUa+RiSx1SdKSbYb6mCbQHY6V2oer=awkaWCuHuk1cayQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/VKCI/Uq++vb3t5G1ZgLg/lC";
 protocol="application/pgp-signature"; micalg=pgp-sha256
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/VKCI/Uq++vb3t5G1ZgLg/lC
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi Geert,

On Thu, 23 Feb 2023 09:22:50 +0100 Geert Uytterhoeven <geert@linux-m68k.org=
> wrote:
>
> On Thu, Feb 23, 2023 at 5:18 AM Stephen Rothwell <sfr@canb.auug.org.au> w=
rote:
> > Merging net/master (5b7c4cabbb65 Merge tag 'net-next-6.3' of git://git.=
kernel.org/pub/scm/linux/kernel/git/netdev/net-next) =20
>=20
> > Merging net-next/master (5b7c4cabbb65 Merge tag 'net-next-6.3' of git:/=
/git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next) =20
>=20
> Niklas S=C3=B6derlund has just made me aware of the following "private"
> netdev announcement, which you seem to have missed:
> "[ANN] netdev master branches going away tomorrow!"
> https://lore.kernel.org/netdev/20230222102946.7912b1b9@kernel.org

Nice to be kept informed :-)  I have updated my repo to use the "main"
branches.

Thanks for letting me know.
--=20
Cheers,
Stephen Rothwell

--Sig_/VKCI/Uq++vb3t5G1ZgLg/lC
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmP3MXcACgkQAVBC80lX
0GzdQwgAigrvJUzvtmMMDeS2S/CEyuH+kVD/+oU8kHDpNu9eX2JgUc+59bTqeQzK
zOBKmfhznK2taMLzyrjMDzP+s7n7mDnJDerxgT5ucU8LxN4NE1rTgw6Z/5OkIClt
abzJMSb1V880VpqTySm1FsroZ8Fjj8dChVOoPSNsrZNL+TUY56Vdy+DjemRSCmp6
h5VyU4HXRj7ksk7zDeiZXwqDHilBHPEU3FrTnERMTvGVm2KHiqzcB0VDKaYvM+/2
oTajGfYVUBh0HDWK+Lp4+vT6wRYWhqtna4u7Mo5d+X/HKK+0UICwB6M3TpFwY7pq
0GxqTCuIptJCezNSeCEEfnzm++xPcg==
=oNR0
-----END PGP SIGNATURE-----

--Sig_/VKCI/Uq++vb3t5G1ZgLg/lC--
