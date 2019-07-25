Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 58BB175B3E
	for <lists+netdev@lfdr.de>; Fri, 26 Jul 2019 01:28:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726968AbfGYX2E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jul 2019 19:28:04 -0400
Received: from mail-lf1-f65.google.com ([209.85.167.65]:41110 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726870AbfGYX2E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Jul 2019 19:28:04 -0400
Received: by mail-lf1-f65.google.com with SMTP id 62so30879284lfa.8;
        Thu, 25 Jul 2019 16:28:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=IvQXzyeCa3p3byzTKli2BP4z8dHBMqmq8NdHFvVh0U8=;
        b=hc0q+KhAY1GRDsuGFoP13QGQ0nPLcs7EGSQZzF/lWDFSSuQkONUofveTolVejME0tq
         +X47CHVvzb91H8m2pkKFBUSmPAU60WtxJgFQEreRcffGWG2DmJfNYEAs2J1vJELGFohJ
         yz73EspzniZo5zvmvEU5QHTdnkiNeIDP54MhZQMLirGTP22nea/hhVKtaqIkh4C8e/lN
         CF8sBkCAlRYgVFydqet9ya9LtCmwpe5a7sgIdJftZbZbknnZUR6+gC8YUlT3LPZiCx81
         X6t0Ao9YDe2U7t9biE3XjZhJ62b7Pgb1MfXZFrVKAXr5VBCrD1pnaEKKLqbsMli6VHoP
         Gi9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=IvQXzyeCa3p3byzTKli2BP4z8dHBMqmq8NdHFvVh0U8=;
        b=aF0uTNDG1yvqjos8lvg39A9kbvjQVTcEjaBzi+jG0SooqUyikzHKtXrifGpOG5GFgP
         jSYxzNlT3zG79ZFpq+5FJdVzqX6W9tN97nBMETA+WTUwoVukloXyG4ntMVTwB8ub+8Mc
         n2g6aT8vUPeiC2YJ4+53YTsjroflvujvj56NUWFoBtW+jpg5Z9QphFCDudXxSbrHadZs
         j4Q6RTFOvjZN8v3EYtmhGIBbX7Z/2xT1MkLU4/qX/2CPk05+66LtHzsERbb5r+vyogSB
         PNWr9xRXLrLnwAcEn7IvhrQSKY5IxNT0x22DQdCUP345lELw1AlOHoI/x4OAeCr1ccK5
         bNbA==
X-Gm-Message-State: APjAAAWDgq+k5eehZOpt4fTmmq40SuK2tRr9PmpaiTyLQWv9uMK9c21+
        BZe4hzvyh/mLA9uIaug4DiHfSuZZZnAdaFNCOWA=
X-Google-Smtp-Source: APXvYqwvvhfAjdJijFNp+iGRcHsIzZ7JbiZ1gfiM9Gp9IzOtUIqtGmCW2TJUHg5F214INMamEyCizCrxRRfVgbqIFYs=
X-Received: by 2002:a05:6512:288:: with SMTP id j8mr46403495lfp.181.1564097282215;
 Thu, 25 Jul 2019 16:28:02 -0700 (PDT)
MIME-Version: 1.0
References: <20190724165803.87470-1-brianvv@google.com> <20190724165803.87470-4-brianvv@google.com>
 <CAEf4BzaCUBA40DKUYm6rSa0v-jQMK7aPu867oYkZhfZGB4wiSA@mail.gmail.com>
In-Reply-To: <CAEf4BzaCUBA40DKUYm6rSa0v-jQMK7aPu867oYkZhfZGB4wiSA@mail.gmail.com>
From:   Brian Vazquez <brianvv.kernel@gmail.com>
Date:   Thu, 25 Jul 2019 16:27:51 -0700
Message-ID: <CABCgpaVVO=6yRDpgs9wqsb7uj8qOw-X1xL16eEqCtiJh0B77dg@mail.gmail.com>
Subject: Re: [PATCH bpf-next 3/6] bpf: keep bpf.h in sync with tools/
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Brian Vazquez <brianvv@google.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S . Miller" <davem@davemloft.net>,
        Stanislav Fomichev <sdf@google.com>,
        Willem de Bruijn <willemb@google.com>,
        Petar Penkov <ppenkov@google.com>,
        open list <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 24, 2019 at 4:10 PM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
>
> On Wed, Jul 24, 2019 at 10:10 AM Brian Vazquez <brianvv@google.com> wrote:
> >
> > Adds bpf_attr.dump structure to libbpf.
> >
> > Suggested-by: Stanislav Fomichev <sdf@google.com>
> > Signed-off-by: Brian Vazquez <brianvv@google.com>
> > ---
> >  tools/include/uapi/linux/bpf.h | 9 +++++++++
> >  tools/lib/bpf/libbpf.map       | 2 ++
> >  2 files changed, 11 insertions(+)
> >
> > diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
> > index 4e455018da65f..e127f16e4e932 100644
> > --- a/tools/include/uapi/linux/bpf.h
> > +++ b/tools/include/uapi/linux/bpf.h
> > @@ -106,6 +106,7 @@ enum bpf_cmd {
> >         BPF_TASK_FD_QUERY,
> >         BPF_MAP_LOOKUP_AND_DELETE_ELEM,
> >         BPF_MAP_FREEZE,
> > +       BPF_MAP_DUMP,
> >  };
> >
> >  enum bpf_map_type {
> > @@ -388,6 +389,14 @@ union bpf_attr {
> >                 __u64           flags;
> >         };
> >
> > +       struct { /* struct used by BPF_MAP_DUMP command */
> > +               __aligned_u64   prev_key;
> > +               __aligned_u64   buf;
> > +               __aligned_u64   buf_len; /* input/output: len of buf */
> > +               __u64           flags;
> > +               __u32           map_fd;
> > +       } dump;
> > +
> >         struct { /* anonymous struct used by BPF_PROG_LOAD command */
> >                 __u32           prog_type;      /* one of enum bpf_prog_type */
> >                 __u32           insn_cnt;
> > diff --git a/tools/lib/bpf/libbpf.map b/tools/lib/bpf/libbpf.map
> > index f9d316e873d8d..cac3723d5c45c 100644
> > --- a/tools/lib/bpf/libbpf.map
> > +++ b/tools/lib/bpf/libbpf.map
> > @@ -183,4 +183,6 @@ LIBBPF_0.0.4 {
>
> LIBBPF_0.0.4 is closed, this needs to go into LIBBPF_0.0.5.

Sorry my bad, I didn't closely look at the rebase so this got it wrong.

>
> >                 perf_buffer__new;
> >                 perf_buffer__new_raw;
> >                 perf_buffer__poll;
> > +               bpf_map_dump;
> > +               bpf_map_dump_flags;
>
> As the general rule, please keep those lists of functions in alphabetical order.

right.

I will fix it in next version, thanks for reviewing it!
