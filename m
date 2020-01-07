Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0F6BC13358E
	for <lists+netdev@lfdr.de>; Tue,  7 Jan 2020 23:13:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727344AbgAGWN4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jan 2020 17:13:56 -0500
Received: from mail-lf1-f65.google.com ([209.85.167.65]:32989 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727127AbgAGWN4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jan 2020 17:13:56 -0500
Received: by mail-lf1-f65.google.com with SMTP id n25so932710lfl.0;
        Tue, 07 Jan 2020 14:13:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=AQRu3w6AKDS4yIwvHaMqQSMXX3fkE0yn2fW50+FsyJY=;
        b=MakB0Ij7KZMS+Lh+PDtwFOJ7tVXxk4Fq88deYNxZ0n5QvtaneqTgeLbRac9DSML308
         9bwfOLY2QsEY5Cm4nzjapuLiuJ/+xVqr+rErFJ4DKwNurBrX//uJ5YcG7dEgYMfuwFHk
         IZwitekUaNvrMYH7htYbMQ5zbnQ2xZEEvrExlRwm9FgEsLrJdgxZn11p6WpvQdrGPVxK
         RVly77MFVvbvBR4HVQfaPNgfYRVW8Fn9SkFaNRllVE1TR/6k5Hev1EiD5YMPW3eH6Gb7
         liMznpjVU8nRHnpjrUFPBU0+syMwxcOI69mSzhXqOMHdNWaD0PkEeaE6dgqnjILg5anu
         ib5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=AQRu3w6AKDS4yIwvHaMqQSMXX3fkE0yn2fW50+FsyJY=;
        b=mlP0YF2KIIrsRPtQXS1l4YuajZskJ/1q8K/8unXdBrR6QtBrUag2jkOzmBT0RcGNKU
         yfiibvmVHz2dqHwhR1FYYOx5Gl8GH+HhbWuf2tIelvIyGobsHdttv1M0nq31SCZn02FT
         9tg8PYOOCQrQdZ2+CIOjAo/IugUeazzuXRokGf2WiipddyEIOjdaZt1lXstF2Dlh2aeN
         QKvzjSNE5RDrwPcIpWEPk+dV8mEg2zyECgx30Pr0sOC7tncGaHZG/PmOOqNgoHxjdAsn
         4+7TubuztyO8VA2yf5+AtjS92h/O7j89kKllGMNR8O8GlotySS2VYwfv7d3LSnbjKeHN
         ivYg==
X-Gm-Message-State: APjAAAUAPaDDGqiwvLympn+6v5NE3VU1Szw0akXn+xi51+2gadawBc3h
        womhcVgjiIr4rFOtIP3C29F69caa1QIcMo45AglxFDnH
X-Google-Smtp-Source: APXvYqxxy7PmTgRzudRO4bvEVpb7KSFT8gSUqBDU98q8KT7q7woxpKTSFej/Y/h4PbvVA9booIeDbf0uIEV2Etls2lw=
X-Received: by 2002:ac2:44d9:: with SMTP id d25mr983323lfm.15.1578435234170;
 Tue, 07 Jan 2020 14:13:54 -0800 (PST)
MIME-Version: 1.0
References: <20191229143740.29143-1-jolsa@kernel.org> <20191229143740.29143-3-jolsa@kernel.org>
 <20200106232719.nk4k27ijm4uuwwo3@ast-mbp> <20200107122513.GH290055@krava>
In-Reply-To: <20200107122513.GH290055@krava>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Tue, 7 Jan 2020 14:13:42 -0800
Message-ID: <CAADnVQKHPk=rcb_aV_SyL5iEyjxHtgv2XnTkDmeKFMHxgF0vbg@mail.gmail.com>
Subject: Re: [PATCH 2/5] bpf: Add bpf_perf_event_output_kfunc
To:     Jiri Olsa <jolsa@redhat.com>
Cc:     Jiri Olsa <jolsa@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Andrii Nakryiko <andriin@fb.com>,
        Yonghong Song <yhs@fb.com>, Martin KaFai Lau <kafai@fb.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        David Miller <davem@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 7, 2020 at 4:25 AM Jiri Olsa <jolsa@redhat.com> wrote:
>
> On Mon, Jan 06, 2020 at 03:27:21PM -0800, Alexei Starovoitov wrote:
> > On Sun, Dec 29, 2019 at 03:37:37PM +0100, Jiri Olsa wrote:
> > > Adding support to use perf_event_output in
> > > BPF_TRACE_FENTRY/BPF_TRACE_FEXIT programs.
> > >
> > > There are no pt_regs available in the trampoline,
> > > so getting one via bpf_kfunc_regs array.
> > >
> > > Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> > > ---
> > >  kernel/trace/bpf_trace.c | 67 ++++++++++++++++++++++++++++++++++++++++
> > >  1 file changed, 67 insertions(+)
> > >
> > > diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
> > > index e5ef4ae9edb5..1b270bbd9016 100644
> > > --- a/kernel/trace/bpf_trace.c
> > > +++ b/kernel/trace/bpf_trace.c
> > > @@ -1151,6 +1151,69 @@ raw_tp_prog_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
> > >     }
> > >  }
> > >
> > > +struct bpf_kfunc_regs {
> > > +   struct pt_regs regs[3];
> > > +};
> > > +
> > > +static DEFINE_PER_CPU(struct bpf_kfunc_regs, bpf_kfunc_regs);
> > > +static DEFINE_PER_CPU(int, bpf_kfunc_nest_level);
> >
> > Thanks a bunch for working on it.
> >
> > I don't understand why new regs array and nest level is needed.
> > Can raw_tp_prog_func_proto() be reused as-is?
> > Instead of patches 2,3,4 ?
>
> I thought that we might want to trace functions within the
> raw tracepoint call, which would be prevented if we used
> the same nest variable
>
> now I'm not sure if there's not some other issue with nesting
> bpf programs like that.. I'll need to check

but nesting is what bpf_raw_tp_nest_level suppose to solve, no?
I just realized that we already have three *_nest_level counters
in that file. Not sure why one is not enough.
There was an issue in the past when tracepoint, kprobe and skb
collided and we had nasty memory corruption, but that was before
_nest_level was introduced. Not sure how we got to three independent
counters.
