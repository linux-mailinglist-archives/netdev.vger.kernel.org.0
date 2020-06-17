Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C95331FC664
	for <lists+netdev@lfdr.de>; Wed, 17 Jun 2020 08:49:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726582AbgFQGt3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jun 2020 02:49:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725773AbgFQGt3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Jun 2020 02:49:29 -0400
Received: from mail-il1-x144.google.com (mail-il1-x144.google.com [IPv6:2607:f8b0:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CA7CC061573;
        Tue, 16 Jun 2020 23:49:29 -0700 (PDT)
Received: by mail-il1-x144.google.com with SMTP id c75so1093663ila.8;
        Tue, 16 Jun 2020 23:49:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=4A3MtNFTe4w9BDypUAIy1seTZtwzWwLTKRoee1JE3PQ=;
        b=WbBb8vSsDhjdJXd4XuVwDnm+Z9MGNEi8xoJ6cfO6i5qLDcoskwZpfo3yxD10g1ik6i
         kfCLNlbxGZmSJLaHQwyViXewkmmdT/bsLV+otoxUNA0DrFCHhA7jpvkPjHbfAxwupgbk
         ocH7vswJZc3H1PVD57dRzr80idtrM/3mjJ0lXbZF7KL1MtOvnSjVo70dwNBcpEElhAdA
         aqNx28sb06PH7cX0VDYnexE2nm/WxCUL2yXmsoOx1qyyeM0vQJ3c8gcEhHCM25YfJBBJ
         409xEbYd5Y+E5FV78vHlhz8CSd4sRDtWahmXdovYJ3CEPBfUehxKaA11ICSCxJPjISoi
         hINg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=4A3MtNFTe4w9BDypUAIy1seTZtwzWwLTKRoee1JE3PQ=;
        b=M0BSZg25Tf/p4b4uWmjBkElHs/IAtSxaLbMmQ4zNT8Cc9Uoj5j3uwRE6psAPb09Z9K
         jaFSrDM8MAhQjuuwo79P5+2e7CaF1tAZ7YntD70LKixVjK060IWargmGRW41xBrBgqTi
         8Qeyho8s7bOqr0d+7jdlRsF2tPTh85hfvEI7aEuZEfM6jvYWTUjjD+UpzYxkyTXhfUIB
         PMUo93MtwKXq/U6tz+cZan7djs+wCTrV8UB6uNBXZ3qJprkxWuJOOcp0q3hVvr30hZ3Y
         EwtP7aGsblVuFcQ16r89B+QQI+CKH/hNMdbnx1Q79klV/jehQFSOfnJ9Oufvjnoep60s
         wmlQ==
X-Gm-Message-State: AOAM533JD8BGSvF5MMSx+n4RVsQlBv5EKRIgFQlCnjpPo0N72e4BRyYG
        GByw6yAaHqGMzfjKB/MgHdk=
X-Google-Smtp-Source: ABdhPJzoViRRgRiDo3oeUBmL8dkI1s+7DM8xGfda1WPyLBnSUCeb+71tbXgaNb2/tCUFXk5A5IMS4A==
X-Received: by 2002:a92:8bc7:: with SMTP id i190mr7017207ild.53.1592376568525;
        Tue, 16 Jun 2020 23:49:28 -0700 (PDT)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id w18sm11197128ili.19.2020.06.16.23.49.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Jun 2020 23:49:27 -0700 (PDT)
Date:   Tue, 16 Jun 2020 23:49:19 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        kernel-team <kernel-team@cloudflare.com>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        John Fastabend <john.fastabend@gmail.com>
Message-ID: <5ee9bcefda5a3_1d4a2af9b18625c4c0@john-XPS-13-9370.notmuch>
In-Reply-To: <CAADnVQLXEq5+ko_ojmuh1Oc84HiPrfLF-7Cdh1xwwm-PhoFwBQ@mail.gmail.com>
References: <20200612160141.188370-1-lmb@cloudflare.com>
 <CAADnVQ+owOvkZ03qyodmh+4NkZD=1LpgTN+YJqiKgr0_OKqRtA@mail.gmail.com>
 <CACAyw9-Jy+r2t5Yy83EEZ8GDnxEsGOPdrqr2JSfVqcC2E6dYmQ@mail.gmail.com>
 <CAADnVQJP_i+KsP771L=GwxousnE=w9o2KckZ7ZCbc064EqSq6w@mail.gmail.com>
 <CACAyw99Szs3nUTx=DSmh0x8iTBLNF9TTLGC0GQLZ=FifVnbzBA@mail.gmail.com>
 <CAADnVQLXEq5+ko_ojmuh1Oc84HiPrfLF-7Cdh1xwwm-PhoFwBQ@mail.gmail.com>
Subject: Re: [PATCH bpf 1/2] flow_dissector: reject invalid attach_flags
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Alexei Starovoitov wrote:
> On Tue, Jun 16, 2020 at 1:30 AM Lorenz Bauer <lmb@cloudflare.com> wrote:
> >
> > On Tue, 16 Jun 2020 at 04:55, Alexei Starovoitov
> > <alexei.starovoitov@gmail.com> wrote:
> > >
> > > On Mon, Jun 15, 2020 at 7:43 AM Lorenz Bauer <lmb@cloudflare.com> wrote:
> > > >
> > > > On Fri, 12 Jun 2020 at 23:36, Alexei Starovoitov
> > > > <alexei.starovoitov@gmail.com> wrote:
> > > > >
> > > > > On Fri, Jun 12, 2020 at 9:02 AM Lorenz Bauer <lmb@cloudflare.com> wrote:
> > > > > >
> > > > > > Using BPF_PROG_ATTACH on a flow dissector program supports neither flags
> > > > > > nor target_fd but accepts any value. Return EINVAL if either are non-zero.
> > > > > >
> > > > > > Signed-off-by: Lorenz Bauer <lmb@cloudflare.com>
> > > > > > Fixes: b27f7bb590ba ("flow_dissector: Move out netns_bpf prog callbacks")
> > > > > > ---
> > > > > >  kernel/bpf/net_namespace.c | 3 +++
> > > > > >  1 file changed, 3 insertions(+)
> > > > > >
> > > > > > diff --git a/kernel/bpf/net_namespace.c b/kernel/bpf/net_namespace.c
> > > > > > index 78cf061f8179..56133e78ae4f 100644
> > > > > > --- a/kernel/bpf/net_namespace.c
> > > > > > +++ b/kernel/bpf/net_namespace.c
> > > > > > @@ -192,6 +192,9 @@ int netns_bpf_prog_attach(const union bpf_attr *attr, struct bpf_prog *prog)
> > > > > >         struct net *net;
> > > > > >         int ret;
> > > > > >
> > > > > > +       if (attr->attach_flags || attr->target_fd)
> > > > > > +               return -EINVAL;
> > > > > > +
> > > > >
> > > > > In theory it makes sense, but how did you test it?
> > > >
> > > > Not properly it seems, sorry!
> > > >
> > > > > test_progs -t flow
> > > > > fails 5 tests.
> > > >
> > > > I spent today digging through this, and the issue is actually more annoying than
> > > > I thought. BPF_PROG_DETACH for sockmap and flow_dissector ignores
> > > > attach_bpf_fd. The cgroup and lirc2 attach point use this to make sure that the
> > > > program being detached is actually what user space expects. We actually have
> > > > tests that set attach_bpf_fd for these to attach points, which tells
> > > > me that this is
> > > > an easy mistake to make.

In sockmap case I didn't manage to think what multiple programs of the same type
on the same map would look like so we can just remove whatever program is there.
Is there a problem with this or is it that we just want the sanity check.

> > > >
> > > > Unfortunately I can't come up with a good fix that seems backportable:
> > > > - Making sockmap and flow_dissector have the same semantics as cgroup
> > > >   and lirc2 requires a bunch of changes (probably a new function for sockmap)
> > >
> > > making flow dissector pass prog_fd as cg and lirc is certainly my preference.
> > > Especially since tests are passing fd user code is likely doing the same,
> > > so breakage is unlikely. Also it wasn't done that long ago, so
> > > we can backport far enough.
> > > It will remove cap_net_admin ugly check in bpf_prog_detach()
> > > which is the only exception now in cap model.
> >
> > SGTM. What about sockmap though? The code for that has been around for ages.
> 
> you mean the second patch that enforces sock_map_get_from_fd doesn't
> use attach_flags?
> I think it didn't break anything, so enforcing is fine.

I'm ok with enforcing it.

> 
> or the detach part that doesn't use prog_fd ?
> I'm not sure what's the best here.
> At least from cap perspective it's fine because map_fd is there.
> 
> John, wdyt?

I think we can keep the current detach without the prog_fd as-is. And
then add logic so that if the prog_fd is included we check it?
