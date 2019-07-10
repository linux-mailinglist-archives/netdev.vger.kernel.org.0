Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B4A9064ECF
	for <lists+netdev@lfdr.de>; Thu, 11 Jul 2019 00:53:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727565AbfGJWxL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Jul 2019 18:53:11 -0400
Received: from mail-qk1-f193.google.com ([209.85.222.193]:35771 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726708AbfGJWxL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Jul 2019 18:53:11 -0400
Received: by mail-qk1-f193.google.com with SMTP id r21so3320419qke.2;
        Wed, 10 Jul 2019 15:53:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=t1W8C6vN5RcrHi2jOOQoB722pR1Fx4Taf/VukoMjOvA=;
        b=BhVDenzNjOwrOQQR6CDej5kqdQ0fWPaAiPJcQ54GmscfBPtDUO6GDGXNsXiVkbqwvl
         QvnD95eeeEISzz11GBIAFXn8ZJ1pTWAE/42Cizz3+ViH2Q+itQd/4MZnJq1QMj3COtKr
         XCtchEzZmVZNDMAhbmLuSeDDznPTPTKenHbcfsJ26pfqjcc2LZF5dbZFtpIB3QcsFUER
         YpwOilM8w9l6hqZPdgW4CP7/k7GOclEJAR0FOOxAY04rWU65HN+Xa9AhMbVJIzqBaEyb
         cxETUS7X2S5rnvOTGSQ0kPrccNQ6qtbqvLqX4C4exbIio78t98QYF2GogL0dhtTHHkiq
         BtKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=t1W8C6vN5RcrHi2jOOQoB722pR1Fx4Taf/VukoMjOvA=;
        b=k9erWye7cEFAzIwUG64ZMCoUj1RyewRz638pJcgLwTg3PYusMP7xBvCNGQ2Ihx7zp/
         Y8tu2YztWkQ+11gR4oc1++Xum4ezsMx93ZutNHS1fQEhT/du1mUinbxBDcwFUK7Nx4mR
         r3mP8HLxD2n3NaNciSgWK5qcmPBsNga5YOcy+MGG+cRh5fOtoaoohLW+33sXuSPyG4Tl
         unQVX2i11MbqmwAhBpFizL1bOi0sMosFHgDC9jRj6gRgGdEkRuMou0BiyFVN0GtT2M7h
         ZqC5jo6zkSPcfYtht8Lf1gYFaie3wAJ/FJALFIeUy22BecQBYeMPMcg/9N3O+Cokt8l/
         UIsg==
X-Gm-Message-State: APjAAAUR1ZdKeyxthuMYrGnXK2v6SdzrPbn7+nVnf6H4Jq6vaVUs6aeZ
        0LOPz8aWVtZm7s6WT7/vGftAD+TQNYnt4LWu+Lw=
X-Google-Smtp-Source: APXvYqysTE7zp27M+jq6x0knDlMe0scLdNwuuTvloImJk5HuQhV9Xbyr+Jzn6RNq8fvpQ+jq3hDbf7ojSUXnkntZtUA=
X-Received: by 2002:a37:bf42:: with SMTP id p63mr527124qkf.437.1562799189521;
 Wed, 10 Jul 2019 15:53:09 -0700 (PDT)
MIME-Version: 1.0
References: <20190701115414.GA4452@harukaze> <68248069-bcf6-69dd-b0a9-f4ec11e50092@fb.com>
 <20190710100248.GA32281@harukaze>
In-Reply-To: <20190710100248.GA32281@harukaze>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 10 Jul 2019 15:52:58 -0700
Message-ID: <CAEf4BzayQ+bEKFHcs8cUDcVnwPpQ2_2gzPaxX-j38r=AWDzVvg@mail.gmail.com>
Subject: Re: [RESEND] test_verifier #13 fails on arm64: "retval 65507 != -29"
To:     Paolo Pisati <p.pisati@gmail.com>
Cc:     Yonghong Song <yhs@fb.com>, Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>, Martin Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>, ak@suse.de
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

cc Andi Kleen re: refactoring, do you have any insight here?

On Wed, Jul 10, 2019 at 3:12 AM Paolo Pisati <p.pisati@gmail.com> wrote:
>
> On Mon, Jul 01, 2019 at 09:51:25PM +0000, Yonghong Song wrote:
> >
> > Below is the test case.
> > {
> >          "valid read map access into a read-only array 2",
> >          .insns = {
> >          BPF_ST_MEM(BPF_DW, BPF_REG_10, -8, 0),
> >          BPF_MOV64_REG(BPF_REG_2, BPF_REG_10),
> >          BPF_ALU64_IMM(BPF_ADD, BPF_REG_2, -8),
> >          BPF_LD_MAP_FD(BPF_REG_1, 0),
> >          BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, 0, 0,
> > BPF_FUNC_map_lookup_elem),
> >          BPF_JMP_IMM(BPF_JEQ, BPF_REG_0, 0, 6),
> >
> >          BPF_MOV64_REG(BPF_REG_1, BPF_REG_0),
> >          BPF_MOV64_IMM(BPF_REG_2, 4),
> >          BPF_MOV64_IMM(BPF_REG_3, 0),
> >          BPF_MOV64_IMM(BPF_REG_4, 0),
> >          BPF_MOV64_IMM(BPF_REG_5, 0),
> >          BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, 0, 0,
> >                       BPF_FUNC_csum_diff),
> >          BPF_EXIT_INSN(),
> >          },
> >          .prog_type = BPF_PROG_TYPE_SCHED_CLS,
> >          .fixup_map_array_ro = { 3 },
> >          .result = ACCEPT,
> >          .retval = -29,
> > },
> >
> > The issue may be with helper bpf_csum_diff().
> > Maybe you can check bpf_csum_diff() helper return value
> > to confirm and take a further look at bpf_csum_diff implementations
> > between x64 and amd64.
>
> Indeed, the different result comes from csum_partial() or, more precisely,
> do_csum().

I assume this is checksum used for ipv4 header checksum ([0]), right?
It's defined as "16-bit one's complement of the one's complement sum
of all 16-bit words", so at the end it has to be folded into 16-bit
anyways.

Reading csum_partial/csum_fold, seems like after calculation of
checksum (so-called unfolded checksum), it is supposed to be passed
into csum_fold() to convert it into 16-bit one and invert.

So maybe that's what is missing from bpf_csum_diff()? Though I've
never used it and don't even know exactly what is its purpose, so
might be (and probably am) totally wrong here (e.g., it might be that
BPF app is supposed to do that or something).

  [0] https://en.wikipedia.org/wiki/IPv4_header_checksum

>
> x86-64 uses an asm optimized version residing in arch/x86/lib/csum-partial_64.c,
> while the generic version is in lib/checksum.c.
>
> I replaced the x86-64 csum_partial() / do_csum() code, with the one in
> lib/checksum.c and by doing so i reproduced the same error on x86-64 (thus, it's
> not an arch dependent issue).
>
> I added some debugging to bpf_csum_diff(), and here are the results with different
> checksum implementation code:
>
> http://paste.debian.net/1091037/
>
> lib/checksum.c:
> ...
> [  206.084537] ____bpf_csum_diff from_size: 1 to_size: 0
> [  206.085274] ____bpf_csum_diff from[0]: 28
> [  206.085276] ____bpf_csum_diff diff[0]: 4294967267
> [  206.085277] ____bpf_csum_diff diff_size: 4 seed: 0
>
> After csum_partial() call:
>
> [  206.086059] ____bpf_csum_diff csum: 65507 - 0xffe3
>
> arch/x86/lib/csum-partial_64.c
> ...
> [   40.467308] ____bpf_csum_diff from_size: 1 to_size: 0
> [   40.468141] ____bpf_csum_diff from[0]: 28
> [   40.468143] ____bpf_csum_diff diff[0]: 4294967267
> [   40.468144] ____bpf_csum_diff diff_size: 4 seed: 0
>
> After csum_partial() call:
>
> [   40.468937] ____bpf_csum_diff csum: -29 - 0xffffffe3
>
> One thing that i noticed, x86-64 csum-partial_64.c::do_csum() doesn't reduce the
> calculated checksum to 16bit before returning it (unless the input value is
> odd - *):
>
> arch/x86/lib/csum-partial_64.c::do_csum()
>                 ...
>         if (unlikely(odd)) {
>                 result = from32to16(result);
>                 result = ((result >> 8) & 0xff) | ((result & 0xff) << 8);
>         }
>         return result;
> }
>
> contrary to all the other do_csum() implementations (that i could understand):
>
> lib/checksum.c::do_csum()
> arch/alpha/lib/checksum.c::do_csum()
> arch/parisc/lib/checksum.c::do_csum()
>
> Apparently even ia64 does the folding (arch/ia64/lib/do_csum.S see a comment right
> before .do_csum_exit:), and arch/c6x/lib/csum_64plus.S too (see
> arch/c6x/lib/csum_64plus.S).
>
> Funnily enough, if i change do_csum() for x86-64, folding the
> checksum to 16 bit (following all the other implementations):
>
> --- a/arch/x86/lib/csum-partial_64.c
> +++ b/arch/x86/lib/csum-partial_64.c
> @@ -112,8 +112,8 @@ static unsigned do_csum(const unsigned char *buff, unsigned
> len)
>         if (len & 1)
>                 result += *buff;
>         result = add32_with_carry(result>>32, result & 0xffffffff);
> +       result = from32to16(result);
>         if (unlikely(odd)) {
> -               result = from32to16(result);
>                 result = ((result >> 8) & 0xff) | ((result & 0xff) << 8);
>         }
>         return result;
>
> then, the x86-64 result match the others: 65507 or 0xffe3.
>
> As a last attempt, i tried running the bpf test_verifier on an armhf platform,
> and i got a completely different number:
>
> [   57.667999] ____bpf_csum_diff from_size: 1 to_size: 0
> [   57.668016] ____bpf_csum_diff from[0]: 28
> [   57.668028] ____bpf_csum_diff diff[0]: 4294967267
> [   57.668039] ____bpf_csum_diff diff_size: 4 seed: 0
>
> After csum_partial() call:
>
> [   57.668052] ____bpf_csum_diff::2002 csum: 131042 - 0x0001ffe2
>
> Not sure what to make of these number, but i have a question: whats is the
> correct checksum of the memory chunk passed to csum_partial()? Is it really -29?
>
> Because, at least 2 other implementations i tested (the arm assembly code and
> the c implementation in lib/checksum.c) computes a different value, so either
> there's a bug in checksum calcution (2 out of 3???), or we are interpreting the
> returned value from csum_partial() somehow wrongly.
>
> *: originally, the x86-64 did the 16bit folding, but the logic was changed to
> what we have today during a big rewrite - search for:
>
> commit 3ef076bb685a461bbaff37a1f06010fc4d7ce733
> Author: Andi Kleen <ak@suse.de>
> Date:   Fri Jun 13 04:27:34 2003 -0700
>
>     [PATCH] x86-64 merge
>
> in this historic repo:
>
> https://git.kernel.org/pub/scm/linux/kernel/git/tglx/history.git
> --
> bye,
> p.
