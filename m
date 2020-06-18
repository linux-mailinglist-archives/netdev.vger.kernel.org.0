Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5EC011FFEA2
	for <lists+netdev@lfdr.de>; Fri, 19 Jun 2020 01:31:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727070AbgFRXbJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jun 2020 19:31:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725829AbgFRXbI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jun 2020 19:31:08 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47333C06174E;
        Thu, 18 Jun 2020 16:31:08 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id d10so1252562pls.5;
        Thu, 18 Jun 2020 16:31:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=dbj3gSF1DajBfQal0C+Z7eSluHmswk4vZ+39x5+Knfo=;
        b=LQEO3doHW70KeRhiigHF66bm9yrCws1QwYdMVCHd5brVC3OQ3eVhBtTqNlkTQVsCGm
         RzI7dQrnGah6ESi3PjVkeGsG/RzZrzBckuSoPn53VIYpIO08cSXZFHdYKW93blOVVNbt
         GfNXXJGNcTXabTRNkL40rbARSBLtYuYOGsBIg4Rojz0vNUKRT5OAPwW3DhPNXSa8jJSh
         vvJtU9x481Npz2DmOgLsrdk7/LBvLp7L547hqOqHuqLMowgh/SY84Oa30bXlXHnTwmDE
         6OOQPMvpesogjjvWFhF9LjIdPPby/vgemr9I5SnbaYVCRClmItCcWTUk65IvVBIBbYGK
         H2uA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=dbj3gSF1DajBfQal0C+Z7eSluHmswk4vZ+39x5+Knfo=;
        b=M/5mbuJeiJvwpCzrrrOOK3Ml1ydQpOJEsPDNpseBf3XEVbSDLhbkbF9c07n+x+0se5
         UOqx0v7bgz1744Dsa1O2XUzTIl0MEEcVh5/rcXGuWNx/J72+rRzmYIAhqGBKMeyu/4iR
         QFyvKrUColosD6EDoPUUqKFqrkwGABSNM4Tk6xw/TxxZyTnU0S36nRlcy1BimRuZdi1W
         mjQNzkMkHodJiQSx2cUU6z0yJkUke2Bs2t6wQf1Xe2yrt/7s31FmABlSNGmK5X7E8fOB
         K+NZ8EGY2lfDCryViPyAAhoFBqTELNQfzhbNu+AQ/2Zq5FjrrwKAsi+bvgrPxMIOiht0
         SbVQ==
X-Gm-Message-State: AOAM530znMQfd8EGpTl0OVGZDRO5dvMBxkAh/J6VIZ/MssbErLA/qP0s
        Y1JoRJVxKOR7g68AFnxzSlld6aYyoYM=
X-Google-Smtp-Source: ABdhPJzy9xVTwzzxnyjmzJWc1f+286/scs4XITGlvC5OGqhIuofCsesMVl3vrblxZdU/1NPgDz0+DQ==
X-Received: by 2002:a17:90a:36d0:: with SMTP id t74mr660446pjb.27.1592523067324;
        Thu, 18 Jun 2020 16:31:07 -0700 (PDT)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id 187sm4030469pfv.53.2020.06.18.16.31.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Jun 2020 16:31:06 -0700 (PDT)
Date:   Thu, 18 Jun 2020 16:30:58 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Message-ID: <5eebf9321e11a_519a2abc9795c5bc21@john-XPS-13-9370.notmuch>
In-Reply-To: <CAEf4BzZmWO=hO0kmtwkACEfHZm+H7+FZ+5moaLie2=13U3xU=g@mail.gmail.com>
References: <20200617202112.2438062-1-andriin@fb.com>
 <5eeb0e5dcb010_8712abba49be5bc91@john-XPS-13-9370.notmuch>
 <CAEf4BzZi5pMTC9Fq53Mi_mXUm-EQZDyqS_pxEYuGoc0J1ETGUA@mail.gmail.com>
 <5eebb95299a20_6d292ad5e7a285b835@john-XPS-13-9370.notmuch>
 <CAEf4BzZmWO=hO0kmtwkACEfHZm+H7+FZ+5moaLie2=13U3xU=g@mail.gmail.com>
Subject: Re: [PATCH bpf-next 1/2] bpf: switch most helper return values from
 32-bit int to 64-bit long
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrii Nakryiko wrote:
> On Thu, Jun 18, 2020 at 11:58 AM John Fastabend
> <john.fastabend@gmail.com> wrote:
> >
> > Andrii Nakryiko wrote:
> > > On Wed, Jun 17, 2020 at 11:49 PM John Fastabend
> > > <john.fastabend@gmail.com> wrote:
> > > >
> > > > Andrii Nakryiko wrote:
> > > > > Switch most of BPF helper definitions from returning int to long. These
> > > > > definitions are coming from comments in BPF UAPI header and are used to
> > > > > generate bpf_helper_defs.h (under libbpf) to be later included and used from
> > > > > BPF programs.
> > > > >
> > > > > In actual in-kernel implementation, all the helpers are defined as returning
> > > > > u64, but due to some historical reasons, most of them are actually defined as
> > > > > returning int in UAPI (usually, to return 0 on success, and negative value on
> > > > > error).
> > > >
> > > > Could we change the helpers side to return correct types now? Meaning if the
> > > > UAPI claims its an int lets actually return the int.
> > >
> > > I'm not sure how exactly you see this being done. BPF ABI dictates
> > > that the helper's result is passed in a full 64-bit r0 register. Are
> > > you suggesting that in addition to RET_ANYTHING we should add
> > > RET_ANYTHING32 and teach verifier that higher 32 bits of r0 are
> > > guaranteed to be zero? And then make helpers actually return 32-bit
> > > values without up-casting them to u64?
> >
> > Yes this is what I was thinking, having a RET_ANYTHING32 but I would
> > assume the upper 32-bits could be anything not zeroed. For +alu32
> > and programmer using correct types I would expect clang to generate
> > good code here and mostly not need to zero upper bits.
> >
> > I think this discussion can be independent of your changes though and
> > its not at the top of my todo list so probably wont get to investigating
> > more for awhile.
> 
> I'm confused. If the verifier doesn't make any assumptions about upper
> 32-bits for RET_ANYTHING32, how is it different from RET_ANYTHING and
> today's logic? What you described is exactly what is happening when
> bpf_helpers_def.h has BPF helpers defined as returning int.
> 

Agreed. I recall it helping the 32-bit bounds on the verifier side
somewhere. But lets drop it maybe it really is not useful. I'll go
try and recall the details later.

[...] Aggressively pruning

> >
> > Agreed. Sorry for the confusion on my side. Poked at this a bit more this
> > morning trying to see why I don't hit the same pattern when we have many
> > cases very similar to above.
> >
> > In your C code you never check for negative return codes? Oops, this
> > means you can walk backwards off the front of payload? This is probably
> > not valid either from program logic side and/or verifier will probably
> > yell. Commented where I think you want a <0 check here,
> 
> You are missing that I'm using unsigned u64. So (s64)-1 ==
> (u64)0xFFFFFFFFFFFFFFFF. So negative errors are effectively turned
> into too large length and I filter them out with the same (len >
> MAX_SZ) check. This allows to do just one comparison instead of two,
> and also helps avoid some Clang optimizations that Yonghong is trying
> to undo right now (if (a > X && a < Y) turned into if (x < Y - X),
> with assembly that verifier can't verify). So no bug there, very
> deliberate choice of types.

I caught it just after I sent above ;) In our codebase we do need to
handle errors and truncated strings differently so really do need the
two conditions. I guess we could find some clever way around it but
in practice on latest kernels we've not seen much trouble around
these with +alu32.

Interesting about the optimization I've not seen that one yet.  

[...]

> See above. In practice (it might be no-ALU32-only thing, don't know),
> doing two ifs is both less efficient and quite often leads to
> unverifiable code. Users have to do hacks to complicate control flow
> enough to prevent Clang from doing Hi/Lo combining. I learned a new
> inlined assembly trick recently to prevent this, but either way it's
> unpleasant and unnecessary.

In the end we also run on ancient kernels so have lots of tricks.

[...] more pruning

> > > My point was that this int -> long switch doesn't degrade ALU32 and
> > > helps no-ALU32, and thus is good :)
> >
> > With the long vs int I do see worse code when using the <0 check.
> > Using C function below which I took from some real code and renamed
> > variables.
> >
> > int myfunc(void *a, void *b, void *c) {
> >         void *payload = a;
> >         int len;
> >
> >         len = probe_read_str(payload, 1000, a);
> >         if (len < 0) return len;
> >         if (len <= 1000) {
> >                 payload += len;
> >         }
> >         len = probe_read_str(payload, 1000, b);
> >         if (len <= 1000) {
> >                 payload += len;
> >         }
> >         return 1;
> > }
> >
> > Then here is the side-by-side of generated code, with +ALU32.
> >
> >   int BPF_FUNC(probe_read, ...                  long BPF_FUNC(probe_read, ...
> > -------------------------------                ---------------------------------
> >        0:       r6 = r2                         0:      r6 = r2
> >        1:       r7 = r1                         1:      r7 = r1
> >        2:       w2 = 1000                       2:      w2 = 1000
> >        3:       r3 = r7                         3:      r3 = r7
> >        4:       call 45                         4:      call 45
> >        5:       if w0 s< 0 goto +9 <LBB0_4>     5:      r2 = r0
> >        6:       w2 = w0                         6:      if w0 s< 0 goto +10 <LBB0_4>
> >        7:       r1 = r7                         7:      r2 <<= 32
> >        8:       r1 += r2                        8:      r2 s>>= 32
> >        9:       if w0 s< 1001 goto +1 <LBB0_3>  9:      r1 = r7
> >       10:       r1 = r7                        10:      r1 += r2
> >       11:       w2 = 1000                      11:      if w0 s< 1001 goto +1 <LBB0_3>
> >       12:       r3 = r6                        12:      r1 = r7
> >       13:       call 45                        13:      w2 = 1000
> >       14:       w0 = 1                         14:      r3 = r6
> >       15:       exit                           15:      call 45
> >                                                16:      w0 = 1
> >                                                17:      exit
> >
> > So a couple extra instruction, but more concerning we created a
> > <<=,s>> pattern. I'll need to do some more tests but my concern
> > is that could break verifier for real programs we have. I guess
> > it didn't in the selftests? Surely, this thread has at least
> > pointed out some gaps in our test cases. I guess I _could_ make
> > len a u64 type to remove the sext but then <0 check on a u64?!
> 
> I addressed <0 check above. As for <<=,s>>=, I wish Clang was a bit
> smarter and just did w2 = w2 or something like that, given we just
> checked that w0 is non-negative. But then again, I wouldn't do two ifs
> and wouldn't use signed int for len.

It is smart enough once you get all the types aligned. So after pulling
in int->long change ideally we would change codebase to use long types as
well. Maybe we should modify the tests in selftests as well OTOH
its nice to test what happens when folks leave the return types as int.

> 
> >
> > >
> > > Overall, long as a return type matches reality and BPF ABI
> > > specification. BTW, one of the varlen programs from patch 2 doesn't
> > > even validate successfully on latest kernel with latest Clang right
> > > now, if helpers return int, even though it's completely correct code.
> > > That's a real problem we have to deal with in few major BPF
> > > applications right now, and we have to use inline assembly to enforce
> > > Clang to do the right thing. A bunch of those problems are simply
> > > avoided with correct return types for helpers.
> >
> > Do the real programs check <0? Did I miss something? I'll try
> > applying your patch to our real code base and see what happens.
> 
> That would be great. Self-tests do work, but having more testing with
> real-world application would certainly help as well.

Thanks for all the follow up.

I ran the change through some CI on my side and it passed so I can
complain about a few shifts here and there or just update my code or
just not change the return types on my side but I'm convinced its OK
in most cases and helps in some so...

Acked-by: John Fastabend <john.fastabend@gmail.com>
