Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 150B31DD6C7
	for <lists+netdev@lfdr.de>; Thu, 21 May 2020 21:11:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730167AbgEUTLM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 May 2020 15:11:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729856AbgEUTLM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 May 2020 15:11:12 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33819C061A0E;
        Thu, 21 May 2020 12:11:11 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id n15so3573977pjt.4;
        Thu, 21 May 2020 12:11:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=9QIhsGopa4M7tNFZalbxD5E1jKNa/x6AV8khESsAzfw=;
        b=XraSPReeOvuRLrCMQyMan2StG4J/4ANzvJuv+ESjC1cUhtAIyTk3y8OWZcTEWeUWIX
         TbAhlfUJGUW7Df2yOlYUyg70fh7luH8K1K4FvxcmxFCgdXNwU5s99Wz6iAea9Wq2ioVc
         9GP2sBTpDPqBxWHWM3SS11JzN3Z1KV+5LoAwVMTrs4G5hVBCwL95a7wkiglzgd2cDtby
         GkvSNYMvKIgPr/+zvXflFafqaOHFTyDghbtlvgHoQSOdHRPyRFNkOd2CNpA7ZAFwUWzN
         DFNLSgDOvD4kXB2o+OWxMCApyrf2OEJ2uv7+rOMe6bO0GO9cxe5bPe9/3M+LyrZgAmJ3
         CQqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=9QIhsGopa4M7tNFZalbxD5E1jKNa/x6AV8khESsAzfw=;
        b=oNKLi4wgfMFvUnhFioTY3HivtD3uzsxGjX240QZvx9i+XFuMk8YQhWn2FUej7Vr7m3
         zBSYLux/xVVBQ404RD2B48ATEiwXErpzlrYMux1BnW88+JifHvMe/3Aa/UOI3kh5JE7u
         7pe3HvxU+RBmdFwxdO/9B7YXibwIk5FZYgxID5Wr/HiLpUs5G8T6WEGqA74A7Jxmuvw3
         v2WeBo1UqMXkrJrdOxtgSCoTMm7R8c+niVHp4J9P1ctMSDz+3xcF11uAFNLKL1OduZUj
         tH7eIbh63YzzcXtHYlvxzDF8Rd9SBgtNgRZy5+SWHLox2KdBSZuuCWARDyqyxgUDsvVy
         Q1dg==
X-Gm-Message-State: AOAM531VP0PTp0VHQ4N77ejohyrzONI3sYLkCg4O95y4OXC0Npblbvio
        dZ2na/taKALQ61X7spfaY9I=
X-Google-Smtp-Source: ABdhPJyVqouICpvgSpmk7ixtdFpzyv9O1iyyQgOOwbCV7QbNrhwwZ0gz4B+K+QvD37sqLktLMNnHQQ==
X-Received: by 2002:a17:90a:9f02:: with SMTP id n2mr13658696pjp.173.1590088270772;
        Thu, 21 May 2020 12:11:10 -0700 (PDT)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id k3sm5187161pjc.38.2020.05.21.12.11.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 May 2020 12:11:09 -0700 (PDT)
Date:   Thu, 21 May 2020 12:11:03 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>
Cc:     Yonghong Song <yhs@fb.com>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Lorenz Bauer <lmb@cloudflare.com>, bpf <bpf@vger.kernel.org>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Networking <netdev@vger.kernel.org>
Message-ID: <5ec6d2473d523_7d832ae77617e5c07a@john-XPS-13-9370.notmuch>
In-Reply-To: <CAEf4BzYJRaY+tsa2TH5WoLAEo=ckd=D2XK5u4YFezkj4jfrZLQ@mail.gmail.com>
References: <159007153289.10695.12380087259405383510.stgit@john-Precision-5820-Tower>
 <159007177838.10695.12211214514015683724.stgit@john-Precision-5820-Tower>
 <CAEf4BzYJRaY+tsa2TH5WoLAEo=ckd=D2XK5u4YFezkj4jfrZLQ@mail.gmail.com>
Subject: Re: [bpf-next PATCH v3 5/5] bpf: selftests, test probe_* helpers from
 SCHED_CLS
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrii Nakryiko wrote:
> On Thu, May 21, 2020 at 7:36 AM John Fastabend <john.fastabend@gmail.com> wrote:
> >
> > Lets test using probe* in SCHED_CLS network programs as well just
> > to be sure these keep working. Its cheap to add the extra test
> > and provides a second context to test outside of sk_msg after
> > we generalized probe* helpers to all networking types.
> >
> > Signed-off-by: John Fastabend <john.fastabend@gmail.com>
> > ---

[...]

> > +++ b/tools/testing/selftests/bpf/progs/test_skb_helpers.c
> > @@ -0,0 +1,33 @@
> > +// SPDX-License-Identifier: GPL-2.0-only
> > +#include "vmlinux.h"
> > +#include <bpf/bpf_helpers.h>
> > +#include <bpf/bpf_endian.h>
> > +
> > +int _version SEC("version") = 1;
> 
> version is not needed
> 
> > +
> > +#define TEST_COMM_LEN 10
> 
> doesn't matter for this test, but it's 16 everywhere, let's stay consistent
> 
> > +
> > +struct bpf_map_def SEC("maps") cgroup_map = {
> > +       .type                   = BPF_MAP_TYPE_CGROUP_ARRAY,
> > +       .key_size               = sizeof(u32),
> > +       .value_size             = sizeof(u32),
> > +       .max_entries    = 1,
> > +};
> > +
> 
> Please use new BTF syntax for maps
> 
> > +char _license[] SEC("license") = "GPL";
> > +
> > +SEC("classifier/test_skb_helpers")
> > +int test_skb_helpers(struct __sk_buff *skb)
> > +{
> > +       struct task_struct *task;
> > +       char *comm[TEST_COMM_LEN];
> 
> this is array of pointer, not array of chars
> 
> > +       __u32 tpid;
> > +       int ctask;
> > +
> > +       ctask = bpf_current_task_under_cgroup(&cgroup_map, 0);
> 
> compiler might complain that ctask is written, but not read. Let's
> assign it to some global variable?

I'll do a read here and check the value then it should be fine.

Will fold in the above comments as well.

> > +       task = (struct task_struct *)bpf_get_current_task();
> > +
> > +       bpf_probe_read_kernel(&tpid , sizeof(tpid), &task->tgid);
> > +       bpf_probe_read_kernel_str(&comm, sizeof(comm), &task->comm);
> > +       return 0;
> > +}
> >
