Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B1124E3312
	for <lists+netdev@lfdr.de>; Mon, 21 Mar 2022 23:48:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229891AbiCUWtx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Mar 2022 18:49:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229797AbiCUWtU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Mar 2022 18:49:20 -0400
Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF6453A7207;
        Mon, 21 Mar 2022 15:29:25 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4KMpbB31LYz4xc3;
        Tue, 22 Mar 2022 09:05:42 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1647900345;
        bh=gmYh7GMo3XiS2P6h/BZ+GHGO/dGum+YMp62zDLTtDtU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=UNqQg1QalL1tX0zvuuptb7aZrlkz+7F2pEf4x51k9xBVs6OisaV3HoMoEXhz3Uzat
         SVYSuK/xfxB8/08mO32OjWTJDoo8kc2lxGDQiAsYJrTCiGz8xsWIbtU7UkXySpiFVA
         OwfM8bsABe6ymCTzslPuakDymH+eMJ/DPiyb7ZuxOOt665cUSUlYJp1bAySmznO2qQ
         nKMdbMg4TCcnCDrMiorgFElL1Ffp2cpPTqSimXHza8kI4Wa6QAlu1H4dX5h5EULdiV
         rLfuC+q2ZNMFIh8DxxfeaNtQ3BIWWQyyl44hSghG57u1sos0jyP8nHSov+psZMcIeY
         rjvJQPocLwGPg==
Date:   Tue, 22 Mar 2022 09:05:41 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Peter Zijlstra <peterz@infradead.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Alexei Starovoitov <ast@kernel.org>,
        "H.J. Lu" <hjl.tools@gmail.com>,
        "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
        Mike Rapoport <rppt@kernel.org>,
        linux-toolchains <linux-toolchains@vger.kernel.org>,
        Andrew Cooper <Andrew.Cooper3@citrix.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: linux-next: build warnings after merge of the tip tree
Message-ID: <20220322090541.7d06c8cb@canb.auug.org.au>
In-Reply-To: <CAHk-=wguO61ACXPSz=hmCxNTzqE=mNr_bWLv6GH5jCVZLBL=qw@mail.gmail.com>
References: <20220321140327.777f9554@canb.auug.org.au>
        <Yjh11UjDZogc3foM@hirez.programming.kicks-ass.net>
        <Yjh3xZuuY3QcZ1Bn@hirez.programming.kicks-ass.net>
        <Yjh4xzSWtvR+vqst@hirez.programming.kicks-ass.net>
        <YjiBbF+K4FKZyn6T@hirez.programming.kicks-ass.net>
        <YjiZhRelDJeX4dfR@hirez.programming.kicks-ass.net>
        <YjidpOZZJkF6aBTG@hirez.programming.kicks-ass.net>
        <CAHk-=wigO=68WA8aMZnH9o8qRUJQbNJPERosvW82YuScrUTo7Q@mail.gmail.com>
        <YjirfOJ2HQAnTrU4@hirez.programming.kicks-ass.net>
        <CAHk-=wguO61ACXPSz=hmCxNTzqE=mNr_bWLv6GH5jCVZLBL=qw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/NW1DkACVm_Mf38+_y.WTVWm";
 protocol="application/pgp-signature"; micalg=pgp-sha256
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/NW1DkACVm_Mf38+_y.WTVWm
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

On Mon, 21 Mar 2022 09:52:58 -0700 Linus Torvalds <torvalds@linux-foundatio=
n.org> wrote:
>
> On Mon, Mar 21, 2022 at 9:45 AM Peter Zijlstra <peterz@infradead.org> wro=
te:
> > >
> > > It's presumably not in any of the pull requests I already have
> > > pending, but it would be nice if I saw some details of _what_ you are
> > > complaining about, and not just the complaint itself ;) =20
> >
> > Duh, right. It's this series:
> >
> >   https://lore.kernel.org/bpf/164757541675.26179.17727138330733641017.g=
it-patchwork-notify@kernel.org/
> >
> > That went into bpf-next last Friday. I just checked but haven't found a
> > pull for it yet. =20
>=20
> Thanks. I can confirm it's not in any of the pull requests I have
> pending, so I'll just start doing my normal work and try to remember
> to look out for this issue later.

The normal path for bpf-next code is via the net-next tree.  But the
above series has not yet been merged into the net-next tree so is only
in the bpf-next tree.

So, what am I to do?  Drop the bpf-next tree from linux-next until this
is resolved?  Some input from the BPF people would be useful.

Dave, Jakub, please do not merge the bpf-bext tree into the net-next
tree for now.

--=20
Cheers,
Stephen Rothwell

--Sig_/NW1DkACVm_Mf38+_y.WTVWm
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmI49rUACgkQAVBC80lX
0GyZSwf/YAF9koEMRaqDbLHeyzvHSVVuqJ5aiqYdatLo85YQJEjezT2PWUv4WlVH
iRC7bB9X+nzuwy+y9K2Cp0oC8a5XN/StPltylx+n6hCX/RLzJmiuLBzHu0RS8F9u
kZ/YQap95KE2cc92SR/UMoGzngXmCjBvem/S7CJw4VZaHlSQStjR/LcwKhKHi/gq
9S8zQhT5el5feN5dnJesUFLpiUqkhKP64L2pwmrMS0zG7ZksObEqEweal70AC0gV
vVk3yygoku4YYCQMVHSVDUSLt5esDWotFzWrmFI9//P7ot29u68i8C7MFxgUumcW
P3TwfTIEItlxQ46dt5Ip2Ob4HhFNWA==
=O/2P
-----END PGP SIGNATURE-----

--Sig_/NW1DkACVm_Mf38+_y.WTVWm--
