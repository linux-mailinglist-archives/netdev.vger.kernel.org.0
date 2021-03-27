Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6C2034B985
	for <lists+netdev@lfdr.de>; Sat, 27 Mar 2021 22:27:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230411AbhC0V1H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Mar 2021 17:27:07 -0400
Received: from ozlabs.org ([203.11.71.1]:48485 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230372AbhC0V0t (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 27 Mar 2021 17:26:49 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4F7Bjt4xsNz9sVt;
        Sun, 28 Mar 2021 08:26:42 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1616880407;
        bh=acqgKxCeO7hqTrXVeIMMyhTANXyE6FspskuhoHoabeI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=VTK1Wur+ztX/rjZhjerfEtw5jDfJg1L0kSK7tpi5PoQvX0CakzIYjrlBH+JW+T8oq
         ax8PWaa+rluZstWR1suGQ1y85Akrt75Jt+a6MpZLuLKz8WKX89JXSSfr30ZP1UT79Y
         K0xvO0x4qTC9sMnflkqfxVARvXF9dCgJcmG5ywUW5xt3reyYfwrSqCThdphVetFJ/D
         OLKBdPUg7tkvJdjoLZduZapFFjXtX6KZSjzqE2zvXL5rwe7WOV6y9EWCMbif6Rm8D0
         PSOzVxniWak9g84aT//smz5o8TrSytJrVSc1/K8TK2hspnJTimAFxLaFV0VXYRzN8x
         V2RYBuRlvp6fw==
Date:   Sun, 28 Mar 2021 08:26:41 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Sedat Dilek <sedat.dilek@gmail.com>
Cc:     Borislav Petkov <bp@suse.de>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>,
        David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: Re: linux-next: build failure after merge of the tip tree
Message-ID: <20210328082641.7afcb938@canb.auug.org.au>
In-Reply-To: <CA+icZUVGvo7jVxMHoCYdU6Y1x=q3n6hVW4EoU_AsGvzozQLG5w@mail.gmail.com>
References: <20210322143714.494603ed@canb.auug.org.au>
        <20210322090036.GB10031@zn.tnic>
        <CA+icZUVkE73_31m0UCo-2mHOHY5i1E54_zMb7yp18UQmgN5x+A@mail.gmail.com>
        <20210326131101.GA27507@zn.tnic>
        <CA+icZUVGvo7jVxMHoCYdU6Y1x=q3n6hVW4EoU_AsGvzozQLG5w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/nk1dXU/2q6Bom9V335gGlVC";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/nk1dXU/2q6Bom9V335gGlVC
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Sedat,

On Sat, 27 Mar 2021 12:50:55 +0100 Sedat Dilek <sedat.dilek@gmail.com> wrot=
e:
>
> I wonder why Stephen's fixup-patch was not carried in recent
> Linux-next releases.

It is part of the tip tree merge commit.  So it is not an explicit
commit on its own, but the needed change is there.

> Wild speculation - no random-config with x86(-64) plus CONFIG_BPF_JIT=3Dy?

I detected it with an X86_64 allmodconfig build (which I do all day).

--=20
Cheers,
Stephen Rothwell

--Sig_/nk1dXU/2q6Bom9V335gGlVC
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmBfoxEACgkQAVBC80lX
0GzmwQf/evaG3lEgE8Y63F70vODeFxpDYZeNvb+TMW8giGd04pBDi3JHjhYb0T1N
DiaCiO+g4uiUwkahozzptlu2Ms5vDOYj2T88nh+S51TCHiBS9Jt7/JoSI8JVbUUp
HEp3zJ+8DYEUJcUQFIU+N91pwWrteHrpYM+xznrMiWnjP42bMLxehD9ccOa2tu8b
6mJLcB1CqAWUP6eZorOfhmk7NBiyyLtSmIgXbMgV/r0F4UQqZh4YaNAwln8Mc+FK
Qn8+gPpooqVA4wZeW7baqJc6ppg60X7tf2mMgW8huCNUtpbc9Am9Jq1jz69SsMql
6W5tKtqG8IJtKCTmn8WNwa1rgEvEGw==
=g84u
-----END PGP SIGNATURE-----

--Sig_/nk1dXU/2q6Bom9V335gGlVC--
