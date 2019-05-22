Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D5A1A270FA
	for <lists+netdev@lfdr.de>; Wed, 22 May 2019 22:46:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730169AbfEVUqh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 May 2019 16:46:37 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:40205 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729528AbfEVUqh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 May 2019 16:46:37 -0400
Received: by mail-qt1-f195.google.com with SMTP id k24so4122707qtq.7;
        Wed, 22 May 2019 13:46:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Zd1TjJMwIHLebilZ3EA+AYhLgqiu1OhCwXcMBwpNa/M=;
        b=jzUt0tlNjVVZx7Vtn3tflnxBzahK6q9gme77M8dOpvUkafMRv9oHmXJR/MwgAMfMtm
         BF4a372G+mNd5glfoG027uyFqcMQxabTJGM9ss9AD0nNiEqypJtJyKPTD+xcIMMNkZcw
         zMChZhdchitNLKyw0nYYyJyh9dP6Fy46d1XVnOxx/6nedBuTXJDF/4uU+QgKYuTijmxy
         AjU2sNLgzsbBJIomJz8zCqQuUFeecm8uWsi3gDAh+gY+QTLxVCiIyx1vfFY7j2x8hiGX
         0Uay6ASZ3HTq3YTie0kMiMZKWfVwE1dZZpFt/aYi02CcGhZr6AvpiG71n36XsO7iTIXw
         uCUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Zd1TjJMwIHLebilZ3EA+AYhLgqiu1OhCwXcMBwpNa/M=;
        b=cbzDaR/kkpNSfX3WQMWm4F+2ipxQhVbUi1y620pwbMWf7oejyUt/Z6BSiaudcJPIUN
         El6r9ZnBnAIl0UXHsxquv5t2krz1OF0kO3H3d0BSZyH3/VHeo+ouRsnx//uh83rrLxJ4
         MfIIyLu3s5+9dZVJeJ90Pnx1/6E3/ciiw1LRMJx0QaXddk5pDc0/fP15Oo22rkVgwZ1c
         8rR9nenPjN69QPN3AN+h02yxX/dJcH5hQHuI1ijhLJeRbWrrBxge2TmCjReXDe+YfYsD
         rxmunGOjcWOMucSCeyvw0Z075ZxbFGQDjXDjOkAM2EKA9AvTdNL5UONfP/Ain4JrCf3g
         Jn2Q==
X-Gm-Message-State: APjAAAUDLnMtLXXJibIvXBUrYLgvEsMM9+yulVI8OfWmrzAdOkkTGKFQ
        wWR1FM1RZ7CyAo6tc+WsM8gi4IjuQrolHfPgDVA=
X-Google-Smtp-Source: APXvYqwIkswoSVzVC3LoGBR/3fSEc2m7yf0cSjLPV5Hna4kzvq/XuE7adjkColyJCRj5ZRHzC8bl/zNtrHTcMZ2HPE0=
X-Received: by 2002:aed:21b8:: with SMTP id l53mr76689871qtc.36.1558557996401;
 Wed, 22 May 2019 13:46:36 -0700 (PDT)
MIME-Version: 1.0
References: <20190522092323.17435-1-bjorn.topel@gmail.com> <CAH3MdRWGeYZDCEPrw2HFpnq+8j+ehMj2uhNJS9HnFDw=LmK6PQ@mail.gmail.com>
In-Reply-To: <CAH3MdRWGeYZDCEPrw2HFpnq+8j+ehMj2uhNJS9HnFDw=LmK6PQ@mail.gmail.com>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Date:   Wed, 22 May 2019 22:46:24 +0200
Message-ID: <CAJ+HfNhR2UozhqTrhDTmZNntmjRCWFyPyU2AaRdo-E6sJUZCKg@mail.gmail.com>
Subject: Re: [PATCH bpf] selftests: bpf: add zero extend checks for ALU32 and/or/xor
To:     Y Song <ys114321@gmail.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 22 May 2019 at 20:13, Y Song <ys114321@gmail.com> wrote:
>
> On Wed, May 22, 2019 at 2:25 AM Bj=C3=B6rn T=C3=B6pel <bjorn.topel@gmail.=
com> wrote:
> >
> > Add three tests to test_verifier/basic_instr that make sure that the
> > high 32-bits of the destination register is cleared after an ALU32
> > and/or/xor.
> >
> > Signed-off-by: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@gmail.com>
>
> I think the patch intends for bpf-next, right? The patch itself looks
> good to me.
> Acked-by: Yonghong Song <yhs@fb.com>
>

Thank you. Actually, it was intended for the bpf tree, as a test
follow up for this [1] fix.


Cheers,
Bj=C3=B6rn

[1] https://lore.kernel.org/bpf/CAJ+HfNifkxKz8df7gLBuqWA6+t6awrrRK6oW6m1nAY=
ETJD+Vfg@mail.gmail.com/

> > ---
> >  .../selftests/bpf/verifier/basic_instr.c      | 39 +++++++++++++++++++
> >  1 file changed, 39 insertions(+)
> >
> > diff --git a/tools/testing/selftests/bpf/verifier/basic_instr.c b/tools=
/testing/selftests/bpf/verifier/basic_instr.c
> > index ed91a7b9a456..4d844089938e 100644
> > --- a/tools/testing/selftests/bpf/verifier/basic_instr.c
> > +++ b/tools/testing/selftests/bpf/verifier/basic_instr.c
> > @@ -132,3 +132,42 @@
> >         .prog_type =3D BPF_PROG_TYPE_SCHED_CLS,
> >         .result =3D ACCEPT,
> >  },
> > +{
> > +       "and32 reg zero extend check",
> > +       .insns =3D {
> > +       BPF_MOV64_IMM(BPF_REG_0, -1),
> > +       BPF_MOV64_IMM(BPF_REG_2, -2),
> > +       BPF_ALU32_REG(BPF_AND, BPF_REG_0, BPF_REG_2),
> > +       BPF_ALU64_IMM(BPF_RSH, BPF_REG_0, 32),
> > +       BPF_EXIT_INSN(),
> > +       },
> > +       .prog_type =3D BPF_PROG_TYPE_SCHED_CLS,
> > +       .result =3D ACCEPT,
> > +       .retval =3D 0,
> > +},
> > +{
> > +       "or32 reg zero extend check",
> > +       .insns =3D {
> > +       BPF_MOV64_IMM(BPF_REG_0, -1),
> > +       BPF_MOV64_IMM(BPF_REG_2, -2),
> > +       BPF_ALU32_REG(BPF_OR, BPF_REG_0, BPF_REG_2),
> > +       BPF_ALU64_IMM(BPF_RSH, BPF_REG_0, 32),
> > +       BPF_EXIT_INSN(),
> > +       },
> > +       .prog_type =3D BPF_PROG_TYPE_SCHED_CLS,
> > +       .result =3D ACCEPT,
> > +       .retval =3D 0,
> > +},
> > +{
> > +       "xor32 reg zero extend check",
> > +       .insns =3D {
> > +       BPF_MOV64_IMM(BPF_REG_0, -1),
> > +       BPF_MOV64_IMM(BPF_REG_2, 0),
> > +       BPF_ALU32_REG(BPF_XOR, BPF_REG_0, BPF_REG_2),
> > +       BPF_ALU64_IMM(BPF_RSH, BPF_REG_0, 32),
> > +       BPF_EXIT_INSN(),
> > +       },
> > +       .prog_type =3D BPF_PROG_TYPE_SCHED_CLS,
> > +       .result =3D ACCEPT,
> > +       .retval =3D 0,
> > +},
> > --
> > 2.20.1
> >
