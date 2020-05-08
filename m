Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18BAB1C9F74
	for <lists+netdev@lfdr.de>; Fri,  8 May 2020 02:10:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726906AbgEHAJt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 May 2020 20:09:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726480AbgEHAJt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 May 2020 20:09:49 -0400
Received: from ozlabs.org (ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 008D4C05BD43;
        Thu,  7 May 2020 17:09:48 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 49J9gQ5vwMz9sRf;
        Fri,  8 May 2020 10:09:38 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1588896584;
        bh=WDqhae7Ab8W4fXqtBnAwD7cR+fAGtYIOV34MrIuWCvI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=f5MPnWtxV0DIpOBEN2pabWfXuecF506lk9fBE8KY+Ksev2Aq5vOymSbZNWU3qrpy4
         2WOKXg5T3jbgy4kSBUIzEDEdmCkxNwRoyYHRXYCNm4VUlH76OC1SJHP3idEtVexVHa
         3RUaQ0DSMeSEsmDNxxL4xNxPAd1qtAA4wfNvA0f0Ko9TcYAk3RXE5M/Xtv80KOEoxt
         +7dAR7vDvxIIB/+gf8INq1gqOaPuARQxXbnizMbPmQLhT1JK2jTwAWFuBO1HVHPWXV
         e7j9Ul7e/IR5aSiJdzXm5471JCENpBFWHX6pPUFXPr+iuOzURnK+m37+60Xc5NWalI
         T4mtuXvQu6/zg==
Date:   Fri, 8 May 2020 10:09:37 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>
Cc:     Qian Cai <cai@lca.pw>, Amol Grover <frextrite@gmail.com>,
        syzbot <syzbot+761cff389b454aa387d2@syzkaller.appspotmail.com>,
        Linux-Next Mailing List <linux-next@vger.kernel.org>,
        David Miller <davem@davemloft.net>, kuba@kernel.org,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Dmitry Vyukov <dvyukov@google.com>
Subject: Re: linux-next boot error: WARNING: suspicious RCU usage in
 ip6mr_get_table
Message-ID: <20200508100937.5741a0b2@canb.auug.org.au>
In-Reply-To: <20200507232402.GB2103@madhuparna-HP-Notebook>
References: <00000000000003dc8f05a50b798e@google.com>
        <CACT4Y+bzRtZdLSzHTp-kJZo4Qg7QctXNVEY9=kbAzfMck9XxAA@mail.gmail.com>
        <DB6FF2E0-4605-40D1-B368-7D813518F6F7@lca.pw>
        <20200507232402.GB2103@madhuparna-HP-Notebook>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/AdHfQVEA2P3mCVq+71eBmF1";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/AdHfQVEA2P3mCVq+71eBmF1
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Madhuparna,

On Fri, 8 May 2020 04:54:02 +0530 Madhuparna Bhowmik <madhuparnabhowmik10@g=
mail.com> wrote:
>
> On Thu, May 07, 2020 at 08:50:55AM -0400, Qian Cai wrote:
> >=20
> >  =20
> > > On May 7, 2020, at 5:32 AM, Dmitry Vyukov <dvyukov@google.com> wrote:
> > >=20
> > > On Thu, May 7, 2020 at 11:26 AM syzbot
> > > <syzbot+761cff389b454aa387d2@syzkaller.appspotmail.com> wrote: =20
> > >>=20
> > >> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D
> > >> WARNING: suspicious RCU usage
> > >> 5.7.0-rc4-next-20200507-syzkaller #0 Not tainted
> > >> -----------------------------
> > >> security/integrity/evm/evm_main.c:231 RCU-list traversed in non-read=
er section!!
> > >>  =20
> Here is the patch for this one:
> https://lore.kernel.org/patchwork/patch/1233836/

Thanks, I will apply that one to linux-next today.

--=20
Cheers,
Stephen Rothwell

--Sig_/AdHfQVEA2P3mCVq+71eBmF1
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl60o0EACgkQAVBC80lX
0GyCRwf7BNJehjp4Z3cmnHrtcI82Kvztr8wVo90JvBmG1QZtbn09vWd1u7zNVnxA
3U3jeHnfxIGR1qVZvddFTiEISk0jwHOq3TWLQZRh3cDWF386qwfk752f647hLUPe
+cl1SwK9SND3Fsxr0VxjPVEjR6lkNBpxmx55atV2//nzUu4xokibTl6k2gGIIIy9
eu7igtiuPRn16v+ylKyOJ2VBwTCetYlX+m11wSx+GMfcfdYiH5ZzkkGkgPEW75nh
ndlCEHf5E3cyfKjlKa7B3iSeJj4qk5Hu8TiTdkiibnRtkRddiKE39OEf/+w/wwWK
KbbnAIqUEEYrgcS8R1V+Lf9neAP1lw==
=084q
-----END PGP SIGNATURE-----

--Sig_/AdHfQVEA2P3mCVq+71eBmF1--
