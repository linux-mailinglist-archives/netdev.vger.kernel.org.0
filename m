Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 64A4813211C
	for <lists+netdev@lfdr.de>; Tue,  7 Jan 2020 09:14:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727277AbgAGIOI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jan 2020 03:14:08 -0500
Received: from mail-qk1-f194.google.com ([209.85.222.194]:38080 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725987AbgAGIOI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jan 2020 03:14:08 -0500
Received: by mail-qk1-f194.google.com with SMTP id k6so41928607qki.5;
        Tue, 07 Jan 2020 00:14:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=akW4UWcOdP6Grp2KonZlQcBnfvoYSwriz8j1t5Jkqsc=;
        b=bwwjdTWn07UYSehfmFp9lXNZC24KgC9QAy12z2S2u1lZBdj13/bm4d6XXe3pYuUf/t
         CEj1OTDObiRuzXXlhrVP26ofMrwaJJsjbXfpkuEj2JXgDI1h69BPWLTP1QoM7YoUVE0P
         VxwgCqzfjFhrUqd++O79MhTVv1KM0jcQtMO/D4Azgpz4n0MHdqZn5qY8nUCJpdQZyfMv
         GF1/udulvUP+3WPiKoP+h4XX71z1aBrcBh0UKCsYhscb/Di3O4fCHXRGyOp6iDbamCqv
         JJ+78i+6xp5i8/1SvT5mnlCJ5MeNM45ttLClkLYXGdV147/NKVOV0JFujb4C+ehp3lPi
         Jubw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=akW4UWcOdP6Grp2KonZlQcBnfvoYSwriz8j1t5Jkqsc=;
        b=shaN5QHCTAaLuSwe+BsIyjQWQQkIf0CSwq55l+/aChyK70objwzq9mcaxBzXfjOMnu
         pcXYuO3qgYpWRAuhaPuieXTHnEmCjl1535rpLF1M8eTqeaF1SKAak5WWVSyN2zfj8wOQ
         wMnn+Nyp27NlMUGjiAVrRLJhrdEU2YsEZ9NaJXmVSCkMPVSPjOsgbbhMVQcLsU+E7W2Z
         E6CLaCjUeFzCSf+wvTl9UkgUwOU08YYz3sJyAARf8XYkkkrXUABTi5iheysyfVSTs1dI
         Z94RkIVhnx/qZaiy8eUs7UPaBQLgNJtL0588qOnKShcbZasiXGdVl00dsWj44GhEmCUQ
         Cdpg==
X-Gm-Message-State: APjAAAVJeNLXxR+YiAmWKsey8Iekr2K+Is0YmA/XQAlvm6p1iZ8peGBr
        oUysGH+8NupvmG6prMs4EzkG97EZRAmiCZoHvCM=
X-Google-Smtp-Source: APXvYqzWFUk7QyJ3Tpw6LqkcUf8FNEwTpCYweqa0ESJaK3f6n2P2SGGbBoxMUIMqV1Q2T354z2gOCnCjI/oeb9i8fvo=
X-Received: by 2002:a05:620a:14a4:: with SMTP id x4mr86046437qkj.493.1578384847200;
 Tue, 07 Jan 2020 00:14:07 -0800 (PST)
MIME-Version: 1.0
References: <20191216091343.23260-1-bjorn.topel@gmail.com> <20191216091343.23260-3-bjorn.topel@gmail.com>
 <mhng-6be38b2a-78df-4016-aaea-f35aa0acd7e0@palmerdabbelt-glaptop>
In-Reply-To: <mhng-6be38b2a-78df-4016-aaea-f35aa0acd7e0@palmerdabbelt-glaptop>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Date:   Tue, 7 Jan 2020 09:13:56 +0100
Message-ID: <CAJ+HfNjoO2ihHMh2NHMQfxG8X1zLdzEq6Ywr=b2qD0tNwXreFA@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 2/9] riscv, bpf: add support for far branching
To:     Palmer Dabbelt <palmerdabbelt@google.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Netdev <netdev@vger.kernel.org>, linux-riscv@lists.infradead.org,
        Luke Nelson <lukenels@cs.washington.edu>,
        bpf <bpf@vger.kernel.org>, Xi Wang <xi.wang@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Back from the holidays; Sorry about the delayed reply.

On Mon, 23 Dec 2019 at 19:03, Palmer Dabbelt <palmerdabbelt@google.com> wro=
te:
>
> On Mon, 16 Dec 2019 01:13:36 PST (-0800), Bjorn Topel wrote:
> > This commit adds branch relaxation to the BPF JIT, and with that
[...]
> > @@ -1557,6 +1569,7 @@ struct bpf_prog *bpf_int_jit_compile(struct bpf_p=
rog *prog)
> >  {
> >       bool tmp_blinded =3D false, extra_pass =3D false;
> >       struct bpf_prog *tmp, *orig_prog =3D prog;
> > +     int pass =3D 0, prev_ninsns =3D 0, i;
> >       struct rv_jit_data *jit_data;
> >       struct rv_jit_context *ctx;
> >       unsigned int image_size;
> > @@ -1596,15 +1609,25 @@ struct bpf_prog *bpf_int_jit_compile(struct bpf=
_prog *prog)
> >               prog =3D orig_prog;
> >               goto out_offset;
> >       }
> > +     for (i =3D 0; i < prog->len; i++) {
> > +             prev_ninsns +=3D 32;
> > +             ctx->offset[i] =3D prev_ninsns;
> > +     }
>
> It feels like the first-order implementation is the same as binutils here=
: the
> first round is worst cased, after which things can be more exact.  We're =
only
> doing one pass in binutils because most of the relaxation happens in the
> linker, but this approach seems reasonable to me.  I'd be interested in s=
eeing
> some benchmarks, as it may be worth relaxing these in the binutils linker=
 as
> well -- I can certainly come up with contrived test cases that aren't rel=
axed,
> but I'm not sure how common this is.
>

Ah, interesting! Let me try to pull out some branch relaxation
statistics/benchmarks for the BPF selftests.

> My only worry is that that invariant should be more explicit.  Specifical=
ly,
> I'm thinking that every time offset is updated there should be some sort =
of
> assertion that the offset is shrinking.  This is enforced structurally in=
 the
> binutils code because we only generate code once and then move it around,=
 but
> since you're generating code every time it'd be easy for a bug to sneak i=
n as
> the JIT gets more complicated.
>

Hmm, yes. Maybe use a checksum for the program in addition to the
length invariant, and converge condition would then be prev_len =3D=3D len
&& prev_crc =3D=3D crc?

> Since most of the branches should be forward, you'll probably end up with=
 way
> fewer iterations if you do the optimization passes backwards.
>

Good idea!

> > -     /* First pass generates the ctx->offset, but does not emit an ima=
ge. */
> > -     if (build_body(ctx, extra_pass)) {
> > -             prog =3D orig_prog;
> > -             goto out_offset;
> > +     for (i =3D 0; i < 16; i++) {
> > +             pass++;
> > +             ctx->ninsns =3D 0;
> > +             if (build_body(ctx, extra_pass)) {
> > +                     prog =3D orig_prog;
> > +                     goto out_offset;
>
> Isn't this returning a broken program if build_body() errors out the firs=
t time
> through?
>

Hmm, care to elaborate? I don't see how?

> > +             }
> > +             build_prologue(ctx);
> > +             ctx->epilogue_offset =3D ctx->ninsns;
> > +             build_epilogue(ctx);
> > +             if (ctx->ninsns =3D=3D prev_ninsns)
> > +                     break;
> > +             prev_ninsns =3D ctx->ninsns;
>
> IDK how important the performance of the JIT is, but you could probably g=
et
> away with skipping an iteration by keeping track of some simple metric th=
at
> determines if it would be possible to
>

...to? Given that the programs are getting larger, performance of the
JIT is important. So, any means the number of passes can be reduced is
a good thing!


Thanks for the review/suggestions!
Bj=C3=B6rn
