Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E83FA2AC5FC
	for <lists+netdev@lfdr.de>; Mon,  9 Nov 2020 21:32:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729913AbgKIUcL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Nov 2020 15:32:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726952AbgKIUcL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Nov 2020 15:32:11 -0500
Received: from mail-oi1-x241.google.com (mail-oi1-x241.google.com [IPv6:2607:f8b0:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D21DC0613CF;
        Mon,  9 Nov 2020 12:32:11 -0800 (PST)
Received: by mail-oi1-x241.google.com with SMTP id c80so11670371oib.2;
        Mon, 09 Nov 2020 12:32:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=etU+haCTxBNMIuMLogb6K0AULZgfd0XgNeiIr4QKckM=;
        b=gh0UowjAE095PB5kEbF1sghiVYQ7IlWhwl/KW91tTsyadK6Pv4BE1Dl7VyyaLg1S/L
         ekSYwwGNl7ODO5N36+sq/eeJeezzAUltURMmzZlw1kYGzj/gFzo0Jf9mgFdf8W+Rvr8r
         e6FZXLzOljkqdhvE4Yxeeev4iNq//LCRZcjj15P5glAJ6oBDWpuASXATzXNNG61d0OV0
         pzwP6mHvw1z32OyPUZVNFo6Jz52rpJUPcRHvQBsHb9dkVW4u++DehCBMv1kBiPsLmqwN
         tgKmBkwEd935tT4+el2UM/DQ/VEoFxsjpYQlcVcthara0ktx8IX7LBQw64opE7vNZdWO
         Fh3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=etU+haCTxBNMIuMLogb6K0AULZgfd0XgNeiIr4QKckM=;
        b=c/KxvShdn3/z72GileLRfZL+Je+VK3rkqmeo/XYip5b6jsUYZXgx0y1vnAYtt5LUx7
         jyjYp2egeeGogHLq+jSKFsI14eMXCHVjuvETMslEK2Gq4JGA2n5ClMv+X/20SsEDYBf/
         usNeqnfYKv1MqF64MhojvUJx6MkvPEoZ4rTizUqnUqA6GLg56PMDh8b3vdfThL65DPji
         T4Yh5v6UgJaDpFn1GXigkbf4PmD7rTb/EN6Tq3lQLuBGYAK5ipxLMqEggFYCRCgUTM6a
         tv16z4D2ANeWlsgaaiJ0mJYrfZQrbBpTucjoXQCKH5Cd8g9LQ6iUhfUcN3nsLWuPU/6u
         sSUQ==
X-Gm-Message-State: AOAM532s1oFoCcw1pEGtDVL4SiX9r9Bq4Slyrahmw8ojQ+BQ9f7Oniqh
        kcJq7gDdfutbiCwXQY9ugDM=
X-Google-Smtp-Source: ABdhPJyFJdSNCx8wdYDWH6W439ltyNTotemtlF+D8QdWBKQG0bQ43tkxtlMgMhccVvvM3KjKUdZfmQ==
X-Received: by 2002:aca:cc08:: with SMTP id c8mr593607oig.161.1604953930839;
        Mon, 09 Nov 2020 12:32:10 -0800 (PST)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id z19sm2759625otm.58.2020.11.09.12.32.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Nov 2020 12:32:09 -0800 (PST)
Date:   Mon, 09 Nov 2020 12:32:01 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        Networking <netdev@vger.kernel.org>
Message-ID: <5fa9a741dc362_8c0e20827@john-XPS-13-9370.notmuch>
In-Reply-To: <CAEf4BzbRXvWdEXC3GdT4Q_dYe6=VPymyDws5QV8wLkdnSONghQ@mail.gmail.com>
References: <20201106220750.3949423-1-kafai@fb.com>
 <20201106220803.3950648-1-kafai@fb.com>
 <CAEf4BzaQMcnALQ3rPErQJxVjL-Mi8zB8aSBkL8bkR8mtivro+g@mail.gmail.com>
 <20201107015225.o7hm7oxpndqueae4@kafai-mbp.dhcp.thefacebook.com>
 <CAEf4BzbRXvWdEXC3GdT4Q_dYe6=VPymyDws5QV8wLkdnSONghQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next 2/3] bpf: Allow using bpf_sk_storage in
 FENTRY/FEXIT/RAW_TP
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrii Nakryiko wrote:
> On Fri, Nov 6, 2020 at 5:52 PM Martin KaFai Lau <kafai@fb.com> wrote:
> >
> > On Fri, Nov 06, 2020 at 05:14:14PM -0800, Andrii Nakryiko wrote:
> > > On Fri, Nov 6, 2020 at 2:08 PM Martin KaFai Lau <kafai@fb.com> wrote:
> > > >
> > > > This patch enables the FENTRY/FEXIT/RAW_TP tracing program to use
> > > > the bpf_sk_storage_(get|delete) helper, so those tracing programs
> > > > can access the sk's bpf_local_storage and the later selftest
> > > > will show some examples.
> > > >
> > > > The bpf_sk_storage is currently used in bpf-tcp-cc, tc,
> > > > cg sockops...etc which is running either in softirq or
> > > > task context.
> > > >
> > > > This patch adds bpf_sk_storage_get_tracing_proto and
> > > > bpf_sk_storage_delete_tracing_proto.  They will check
> > > > in runtime that the helpers can only be called when serving
> > > > softirq or running in a task context.  That should enable
> > > > most common tracing use cases on sk.
> > > >
> > > > During the load time, the new tracing_allowed() function
> > > > will ensure the tracing prog using the bpf_sk_storage_(get|delete)
> > > > helper is not tracing any *sk_storage*() function itself.
> > > > The sk is passed as "void *" when calling into bpf_local_storage.
> > > >
> > > > Signed-off-by: Martin KaFai Lau <kafai@fb.com>
> > > > ---
> > > >  include/net/bpf_sk_storage.h |  2 +
> > > >  kernel/trace/bpf_trace.c     |  5 +++
> > > >  net/core/bpf_sk_storage.c    | 73 ++++++++++++++++++++++++++++++++++++
> > > >  3 files changed, 80 insertions(+)
> > > >
> > >
> > > [...]
> > >
> > > > +       switch (prog->expected_attach_type) {
> > > > +       case BPF_TRACE_RAW_TP:
> > > > +               /* bpf_sk_storage has no trace point */
> > > > +               return true;
> > > > +       case BPF_TRACE_FENTRY:
> > > > +       case BPF_TRACE_FEXIT:
> > > > +               btf_vmlinux = bpf_get_btf_vmlinux();
> > > > +               btf_id = prog->aux->attach_btf_id;
> > > > +               t = btf_type_by_id(btf_vmlinux, btf_id);
> > > > +               tname = btf_name_by_offset(btf_vmlinux, t->name_off);
> > > > +               return !strstr(tname, "sk_storage");
> > >
> > > I'm always feeling uneasy about substring checks... Also, KP just
> > > fixed the issue with string-based checks for LSM. Can we use a
> > > BTF_ID_SET of blacklisted functions instead?
> > KP one is different.  It accidentally whitelist-ed more than it should.
> >
> > It is a blacklist here.  It is actually cleaner and safer to blacklist
> > all functions with "sk_storage" and too pessimistic is fine here.
> 
> Fine for whom? Prefix check would be half-bad, but substring check is
> horrible. Suddenly "task_storage" (and anything related) would be also
> blacklisted. Let's do a prefix check at least.
> 

Agree, prefix check sounds like a good idea. But, just doing a quick
grep seems like it will need at least bpf_sk_storage and sk_storage to
catch everything.
