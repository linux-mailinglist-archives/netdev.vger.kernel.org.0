Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C75633EBDD0
	for <lists+netdev@lfdr.de>; Fri, 13 Aug 2021 23:27:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234790AbhHMVXe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Aug 2021 17:23:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234716AbhHMVXd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Aug 2021 17:23:33 -0400
Received: from mail-qk1-x74a.google.com (mail-qk1-x74a.google.com [IPv6:2607:f8b0:4864:20::74a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 393DEC0617AD
        for <netdev@vger.kernel.org>; Fri, 13 Aug 2021 14:23:06 -0700 (PDT)
Received: by mail-qk1-x74a.google.com with SMTP id b4-20020a3799040000b02903b899a4309cso8279029qke.14
        for <netdev@vger.kernel.org>; Fri, 13 Aug 2021 14:23:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=O+a+kJqxjsCgYqIdwgvSL+Ilv4hJngYXbJtEdzYwooo=;
        b=TTEK0RsM0JDQzLJzTTKgdUZ1jeQNd6jO75zKxOU8a8zbe5n8WmbMyrhc9HDAyjpcEA
         xUWHjMiUoEGprRniwj2eZm29N7S47LSxajYvw5aRs5leok81CT6EbTzRoM9vB9WrK3Xu
         OrHhiqL+3TzpX++Bd4qzr054j6Ta/n0Fpmh/H3Xm2h041up4xo2pqioaaBoytzee0U6D
         QkKnyYhek5UitBG66xSSkeuQx7Ew7lemNTw1nzfveoYAIq8KIok1nQjXzHLBUstzL5gU
         BB+RV1J9OIJ0dOUMem1HZQLdT/WdDtTSRh7z5gJDWmqvxFfBISa5sroz6FswMcUuuJIu
         1XUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=O+a+kJqxjsCgYqIdwgvSL+Ilv4hJngYXbJtEdzYwooo=;
        b=mT65yq+Cq8Op37N28BFkHUr8F/kMdPk1t+NLeug2h/9vmT4LxU99dZmHj30US4Xb0L
         4eK/J17sKo0jhRc0gmXLnWLesac187f2PAJYl2oY/mQKKaNyzgopvYe5fYKkbkrmD+K/
         Yu1RF7fDeNRvVhWihPF0qipIC6ro62cSRLr0JiW0j1Aohl3lMPDfCEbog38kQ385JubX
         RXgcAlhc/x6F/SCZqtmsvNveQWlu+xdIXqflj723uPemUGIMt6x5XrXpclubMIXbW8VL
         H0v4l4YlCJlBgzydDeLEpcVY9FCkYiGcN34LR2akX1IqyfICuryUw8C8tZB57GHf/tg5
         eqWQ==
X-Gm-Message-State: AOAM532kLzyikYKVVYmlxV5/K4F3xSpdcLyMkJ78zAKO2Bp2fAfP7GQB
        W1pxolgmyrXgU8yO3deEX6GrZWY=
X-Google-Smtp-Source: ABdhPJzaBi3DhigOdVcaLGyPU08xbaff8xdPewdHsDYx0sxO6SOeJkpVzOE8JZtHc9VrLl+L6SQymuU=
X-Received: from sdf2.svl.corp.google.com ([2620:15c:2c4:201:f73:a375:cbb9:779b])
 (user=sdf job=sendgmr) by 2002:a05:6214:e62:: with SMTP id
 jz2mr4654757qvb.54.1628889785281; Fri, 13 Aug 2021 14:23:05 -0700 (PDT)
Date:   Fri, 13 Aug 2021 14:23:02 -0700
In-Reply-To: <20210813195802.r67s62f5iwvnlmv4@kafai-mbp>
Message-Id: <YRbittzJQjF/KqKU@google.com>
Mime-Version: 1.0
References: <20210812153011.983006-1-sdf@google.com> <20210812153011.983006-2-sdf@google.com>
 <20210813195802.r67s62f5iwvnlmv4@kafai-mbp>
Subject: Re: [PATCH bpf-next v2 1/2] bpf: Allow bpf_get_netns_cookie in BPF_PROG_TYPE_CGROUP_SOCKOPT
From:   sdf@google.com
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 08/13, Martin KaFai Lau wrote:
> On Thu, Aug 12, 2021 at 08:30:10AM -0700, Stanislav Fomichev wrote:
> > This is similar to existing BPF_PROG_TYPE_CGROUP_SOCK
> > and BPF_PROG_TYPE_CGROUP_SOCK_ADDR.
> >
> > Signed-off-by: Stanislav Fomichev <sdf@google.com>
> > ---
> >  kernel/bpf/cgroup.c | 19 +++++++++++++++++++
> >  1 file changed, 19 insertions(+)
> >
> > diff --git a/kernel/bpf/cgroup.c b/kernel/bpf/cgroup.c
> > index b567ca46555c..ca5af8852260 100644
> > --- a/kernel/bpf/cgroup.c
> > +++ b/kernel/bpf/cgroup.c
> > @@ -1846,11 +1846,30 @@ const struct bpf_verifier_ops  
> cg_sysctl_verifier_ops = {
> >  const struct bpf_prog_ops cg_sysctl_prog_ops = {
> >  };
> >
> > +#ifdef CONFIG_NET
> > +BPF_CALL_1(bpf_get_netns_cookie_sockopt, struct bpf_sockopt_kern *,  
> ctx)
> > +{
> > +	struct sock *sk = ctx ? ctx->sk : NULL;
> > +	const struct net *net = sk ? sock_net(sk) : &init_net;
> A nit.

> ctx->sk can not be NULL here, so it only depends on ctx is NULL or not.

> If I read it correctly, would it be less convoluted to directly test ctx
> and use ctx->sk here, like:

> 	const struct net *net = ctx ? sock_net(ctx->sk) : &init_net;

> and the previous "struct sock *sk = ctx ? ctx->sk : NULL;" statement
> can also be removed.
Agreed, makes sense. Let me also add bpf_get_netns_cookie to some
existing BPF prog to make sure it's executed. That ctx.c isn't
really running the prog..
