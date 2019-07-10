Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6A54B64ED3
	for <lists+netdev@lfdr.de>; Thu, 11 Jul 2019 00:54:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727687AbfGJWyv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Jul 2019 18:54:51 -0400
Received: from mail-qk1-f193.google.com ([209.85.222.193]:43816 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726708AbfGJWyu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Jul 2019 18:54:50 -0400
Received: by mail-qk1-f193.google.com with SMTP id m14so3272323qka.10;
        Wed, 10 Jul 2019 15:54:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=OMTce4uk41CvcSeW3aJprFowTwfqRUUbVvoeW/CC9d4=;
        b=TH3MOwbYE72KvCgY+om5tR81aL+G3KJUqsGYPV4mtPJfCeZAhkilNtAPTtB4txgzWU
         qg53je6azA4gM0tQDiC0nve5f7V1ykObK71AK7syi+zj1Z0sj+BArXDLquh65+2Wtbm+
         heE1OqLlR7rnBynwLCbt20k0aRRdEN1EvxkYcdWuB6qfB5PfpXUnwlXL7dksAHgDTPNI
         QDh1GzJE/XMR+iFRlO/c/5JGNW+0rOjEtBbZOgPqBu5BzQiiAJbhk9XcrOb77zgznF8L
         D1+SSyTSn2VQomFctNFogYDbr8HOf95iwUvmSU4h8NOdVxIJDun2fambDyCSCPf87Erk
         lg8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=OMTce4uk41CvcSeW3aJprFowTwfqRUUbVvoeW/CC9d4=;
        b=fxXY93R4LrswndDDcHmRshnc6S0JTf1j0jo1Ibpp8BbYGr/sYmabIcUZNTbVM+ayUD
         qOgeOy5Q4gXyVjlzgyEDzcjS03jEvQw09dCnbfrpapp+0aWL6/wF4YuLlRgSFTeqoMp0
         RfU4DbXyKtCDcLjD6V1N5F22olXsV0KOC8uPTdHXMLfLaYGh2el0ukiMlGjItdJS+va/
         kpSUVoSMjk7s4Tur19unGI83GdI+2HarPVpVH3R/VEQrFM1nlGFk5fRo2lN78yKjqLaW
         YYbrDOdJspAXKiCXUmgx8Le6OEjo69ZiQDlTL4kzgkqesz7faSAmdj9EBuMYaYOL3ZLn
         1ozQ==
X-Gm-Message-State: APjAAAW3uFk2ESaq12MPUB7T939nhDrB5/43CVpCoGYFji7EhgUIuC7S
        CnUD+nLVoL09lN6ioLbRfm9za9h20wYV6PGbSwlgW87gIRXp1w==
X-Google-Smtp-Source: APXvYqx5E4TzO3qUGZsV5T0Cg3dkhXFryTcBWLIAusFIaV0GSfxCYIHt1c3RRwJJgNBqMpuRf6l6/t9mE3Vy9daJPao=
X-Received: by 2002:a37:660d:: with SMTP id a13mr578053qkc.36.1562799289177;
 Wed, 10 Jul 2019 15:54:49 -0700 (PDT)
MIME-Version: 1.0
References: <20190701115414.GA4452@harukaze> <68248069-bcf6-69dd-b0a9-f4ec11e50092@fb.com>
 <20190710100248.GA32281@harukaze> <CAEf4BzayQ+bEKFHcs8cUDcVnwPpQ2_2gzPaxX-j38r=AWDzVvg@mail.gmail.com>
In-Reply-To: <CAEf4BzayQ+bEKFHcs8cUDcVnwPpQ2_2gzPaxX-j38r=AWDzVvg@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 10 Jul 2019 15:54:38 -0700
Message-ID: <CAEf4Bzbtpqk-9ELnHFsHo278b5T4Z-2CgNnNbOqbD5Ocbuc-fg@mail.gmail.com>
Subject: Re: [RESEND] test_verifier #13 fails on arm64: "retval 65507 != -29"
To:     Paolo Pisati <p.pisati@gmail.com>
Cc:     Yonghong Song <yhs@fb.com>, Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>, Martin Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>, ak@linux.intel.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 10, 2019 at 3:52 PM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
>
> cc Andi Kleen re: refactoring, do you have any insight here?

OK, let's try again...

>
> On Wed, Jul 10, 2019 at 3:12 AM Paolo Pisati <p.pisati@gmail.com> wrote:
> >
> > On Mon, Jul 01, 2019 at 09:51:25PM +0000, Yonghong Song wrote:
> > >
> > > Below is the test case.
> > > {
> > >          "valid read map access into a read-only array 2",
> > >          .insns = {
> > >          BPF_ST_MEM(BPF_DW, BPF_REG_10, -8, 0),
> > >          BPF_MOV64_REG(BPF_REG_2, BPF_REG_10),
> > >          BPF_ALU64_IMM(BPF_ADD, BPF_REG_2, -8),
> > >          BPF_LD_MAP_FD(BPF_REG_1, 0),
> > >          BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, 0, 0,
> > > BPF_FUNC_map_lookup_elem),
> > >          BPF_JMP_IMM(BPF_JEQ, BPF_REG_0, 0, 6),
> > >
> > >          BPF_MOV64_REG(BPF_REG_1, BPF_REG_0),
> > >          BPF_MOV64_IMM(BPF_REG_2, 4),
> > >          BPF_MOV64_IMM(BPF_REG_3, 0),
> > >          BPF_MOV64_IMM(BPF_REG_4, 0),
> > >          BPF_MOV64_IMM(BPF_REG_5, 0),
> > >          BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, 0, 0,
> > >                       BPF_FUNC_csum_diff),
> > >          BPF_EXIT_INSN(),
> > >          },
> > >          .prog_type = BPF_PROG_TYPE_SCHED_CLS,
> > >          .fixup_map_array_ro = { 3 },
> > >          .result = ACCEPT,
> > >          .retval = -29,
> > > },
> > >
> > > The issue may be with helper bpf_csum_diff().
> > > Maybe you can check bpf_csum_diff() helper return value
> > > to confirm and take a further look at bpf_csum_diff implementations
> > > between x64 and amd64.
> >
> > Indeed, the different result comes from csum_partial() or, more precisely,
> > do_csum().
>
> I assume this is checksum used for ipv4 header checksum ([0]), right?
> It's defined as "16-bit one's complement of the one's complement sum
> of all 16-bit words", so at the end it has to be folded into 16-bit
> anyways.
>
> Reading csum_partial/csum_fold, seems like after calculation of
> checksum (so-called unfolded checksum), it is supposed to be passed
> into csum_fold() to convert it into 16-bit one and invert.
>
> So maybe that's what is missing from bpf_csum_diff()? Though I've
> never used it and don't even know exactly what is its purpose, so
> might be (and probably am) totally wrong here (e.g., it might be that
> BPF app is supposed to do that or something).
>
>   [0] https://en.wikipedia.org/wiki/IPv4_header_checksum
>
> >
> > x86-64 uses an asm optimized version residing in arch/x86/lib/csum-partial_64.c,
> > while the generic version is in lib/checksum.c.
> >
> > I replaced the x86-64 csum_partial() / do_csum() code, with the one in
> > lib/checksum.c and by doing so i reproduced the same error on x86-64 (thus, it's
> > not an arch dependent issue).
> >
> > I added some debugging to bpf_csum_diff(), and here are the results with different
> > checksum implementation code:
> >
> > http://paste.debian.net/1091037/
> >
> > lib/checksum.c:
> > ...
> > [  206.084537] ____bpf_csum_diff from_size: 1 to_size: 0
> > [  206.085274] ____bpf_csum_diff from[0]: 28
> > [  206.085276] ____bpf_csum_diff diff[0]: 4294967267
> > [  206.085277] ____bpf_csum_diff diff_size: 4 seed: 0
> >
> > After csum_partial() call:
> >
> > [  206.086059] ____bpf_csum_diff csum: 65507 - 0xffe3
> >
> > arch/x86/lib/csum-partial_64.c
> > ...
> > [   40.467308] ____bpf_csum_diff from_size: 1 to_size: 0
> > [   40.468141] ____bpf_csum_diff from[0]: 28
> > [   40.468143] ____bpf_csum_diff diff[0]: 4294967267
> > [   40.468144] ____bpf_csum_diff diff_size: 4 seed: 0
> >
> > After csum_partial() call:
> >
> > [   40.468937] ____bpf_csum_diff csum: -29 - 0xffffffe3
> >
> > One thing that i noticed, x86-64 csum-partial_64.c::do_csum() doesn't reduce the
> > calculated checksum to 16bit before returning it (unless the input value is
> > odd - *):
> >
> > arch/x86/lib/csum-partial_64.c::do_csum()
> >                 ...
> >         if (unlikely(odd)) {
> >                 result = from32to16(result);
> >                 result = ((result >> 8) & 0xff) | ((result & 0xff) << 8);
> >         }
> >         return result;
> > }
> >
> > contrary to all the other do_csum() implementations (that i could understand):
> >
> > lib/checksum.c::do_csum()
> > arch/alpha/lib/checksum.c::do_csum()
> > arch/parisc/lib/checksum.c::do_csum()
> >
> > Apparently even ia64 does the folding (arch/ia64/lib/do_csum.S see a comment right
> > before .do_csum_exit:), and arch/c6x/lib/csum_64plus.S too (see
> > arch/c6x/lib/csum_64plus.S).
> >
> > Funnily enough, if i change do_csum() for x86-64, folding the
> > checksum to 16 bit (following all the other implementations):
> >
> > --- a/arch/x86/lib/csum-partial_64.c
> > +++ b/arch/x86/lib/csum-partial_64.c
> > @@ -112,8 +112,8 @@ static unsigned do_csum(const unsigned char *buff, unsigned
> > len)
> >         if (len & 1)
> >                 result += *buff;
> >         result = add32_with_carry(result>>32, result & 0xffffffff);
> > +       result = from32to16(result);
> >         if (unlikely(odd)) {
> > -               result = from32to16(result);
> >                 result = ((result >> 8) & 0xff) | ((result & 0xff) << 8);
> >         }
> >         return result;
> >
> > then, the x86-64 result match the others: 65507 or 0xffe3.
> >
> > As a last attempt, i tried running the bpf test_verifier on an armhf platform,
> > and i got a completely different number:
> >
> > [   57.667999] ____bpf_csum_diff from_size: 1 to_size: 0
> > [   57.668016] ____bpf_csum_diff from[0]: 28
> > [   57.668028] ____bpf_csum_diff diff[0]: 4294967267
> > [   57.668039] ____bpf_csum_diff diff_size: 4 seed: 0
> >
> > After csum_partial() call:
> >
> > [   57.668052] ____bpf_csum_diff::2002 csum: 131042 - 0x0001ffe2
> >
> > Not sure what to make of these number, but i have a question: whats is the
> > correct checksum of the memory chunk passed to csum_partial()? Is it really -29?
> >
> > Because, at least 2 other implementations i tested (the arm assembly code and
> > the c implementation in lib/checksum.c) computes a different value, so either
> > there's a bug in checksum calcution (2 out of 3???), or we are interpreting the
> > returned value from csum_partial() somehow wrongly.
> >
> > *: originally, the x86-64 did the 16bit folding, but the logic was changed to
> > what we have today during a big rewrite - search for:
> >
> > commit 3ef076bb685a461bbaff37a1f06010fc4d7ce733
> > Author: Andi Kleen <ak@suse.de>
> > Date:   Fri Jun 13 04:27:34 2003 -0700
> >
> >     [PATCH] x86-64 merge
> >
> > in this historic repo:
> >
> > https://git.kernel.org/pub/scm/linux/kernel/git/tglx/history.git
> > --
> > bye,
> > p.
