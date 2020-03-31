Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CAB8C198A64
	for <lists+netdev@lfdr.de>; Tue, 31 Mar 2020 05:11:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729949AbgCaDLM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Mar 2020 23:11:12 -0400
Received: from mail-pj1-f67.google.com ([209.85.216.67]:35008 "EHLO
        mail-pj1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727614AbgCaDLL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Mar 2020 23:11:11 -0400
Received: by mail-pj1-f67.google.com with SMTP id g9so486284pjp.0;
        Mon, 30 Mar 2020 20:11:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=88Mq5VBLJxKNb7gCZ5YeF16M/DgSjuBGtrWldue33Q8=;
        b=fKlCqB7M+/Wn5YcFbh8CeolrMj1q1VXSHTSsbL5kWWfY+FPgXaXZcL4OayMYVhixK3
         Pq2n5cMkSKUhKIT0z1Xwkf4G/w877eEzhSsFzDM2lu8rQ0Wq51cmGNHtItmX/M+ha0Pi
         diPYoW1wFLI0YC4/zDx2zwhwjqAiHGF7alddZcN7JdvXoNT6BYjcAQj5QrUTf3/73HKl
         90qJRYVxZF5YX+PTHwBsAMieHLbAy4EIPTFYTkv+AVtCCITdrJDqHtc9udkpwkL8khNa
         ehtYA4prC5jAMbgoQQJKY5rdhL84nqAM/7SRMfZ0ZYwNtsRUxeC70/yAUZtzzqkov8iS
         h8ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=88Mq5VBLJxKNb7gCZ5YeF16M/DgSjuBGtrWldue33Q8=;
        b=RFd9trKr27oNPq4mZFmd3g0/PSulGISWoe6jtiDb3HWQSqNszbIKovLPWz9KZtOPHp
         VnnMBPGFosBMagqdGrumsF/+KzOxLrZZA+TBGXdFCRiHlXyqyS2GeIBtm8ERp84tweUj
         7MUTtJfQing1Kk1lNnmPcktmay45bxjTNYb3fHDiqRaBIGUM69h/2XMo6u4HmHCKbamD
         ckBho+F8TY9rbGY6GdCPZ02zovbmu5GZvGxiJycfOgmr20JCih51cbTAU7i0xeZpSIRv
         HI3alB7JdIKE3bZNX44EQ3BHewTQGWUsMLRmQSxevx98xAYMUq6bd6yM6nSpwOOfDuwe
         u9+A==
X-Gm-Message-State: AGi0PuZaHvfqcc76lXExd19msPWVESaWWyuBrP7W09qdXJIUuovXUXRq
        +LvYbYj+jQ3Kt+ebCJix5e8=
X-Google-Smtp-Source: APiQypJ5gNEmLIfP28CKLHezZiuo00+bpMdQoCvvnXfFuzG4PCINrTu3BmN+dy/6IbvyQgA2AOzHew==
X-Received: by 2002:a17:90a:26ed:: with SMTP id m100mr1414267pje.130.1585624269947;
        Mon, 30 Mar 2020 20:11:09 -0700 (PDT)
Received: from ast-mbp ([2620:10d:c090:400::5:442d])
        by smtp.gmail.com with ESMTPSA id s22sm236483pfh.18.2020.03.30.20.11.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Mar 2020 20:11:09 -0700 (PDT)
Date:   Mon, 30 Mar 2020 20:11:05 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     David Miller <davem@davemloft.net>
Cc:     ast@kernel.org, daniel@iogearbox.net, netdev@vger.kernel.org,
        bpf@vger.kernel.org, kernel-team@fb.com
Subject: Re: pull-request: bpf-next 2020-03-30
Message-ID: <20200331031105.qxzwapskpykmeou2@ast-mbp>
References: <20200331012815.3258314-1-ast@kernel.org>
 <20200330.195400.784625163425445502.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200330.195400.784625163425445502.davem@davemloft.net>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 30, 2020 at 07:54:00PM -0700, David Miller wrote:
> From: Alexei Starovoitov <ast@kernel.org>
> Date: Mon, 30 Mar 2020 18:28:15 -0700
> 
> > The following pull-request contains BPF updates for your *net-next* tree.
> > 
> > We've added 73 non-merge commits during the last 14 day(s) which contain
> > a total of 107 files changed, 6086 insertions(+), 1728 deletions(-).
> > 
> > The main changes are:
>  ...
> > Please consider pulling these changes from:
> > 
> >   git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git
> 
> Pulled, there was a minor merge conflict in the cgroup changes, which I
> resolved like this:
> 
> @@@ -305,10 -418,9 +421,9 @@@ int __cgroup_bpf_attach(struct cgroup *
>         u32 saved_flags = (flags & (BPF_F_ALLOW_OVERRIDE | BPF_F_ALLOW_MULTI));
>         struct list_head *progs = &cgrp->bpf.progs[type];
>         struct bpf_prog *old_prog = NULL;
>  -      struct bpf_cgroup_storage *storage[MAX_BPF_CGROUP_STORAGE_TYPE],
>  -              *old_storage[MAX_BPF_CGROUP_STORAGE_TYPE] = {NULL};
>  +      struct bpf_cgroup_storage *storage[MAX_BPF_CGROUP_STORAGE_TYPE] = {};
>  +      struct bpf_cgroup_storage *old_storage[MAX_BPF_CGROUP_STORAGE_TYPE] = {};
> -       struct bpf_prog_list *pl, *replace_pl = NULL;
> -       enum bpf_cgroup_storage_type stype;
> +       struct bpf_prog_list *pl;

Right. Forgot to mention this merge conflict.
The resolution is correct.
Same as what Stephen did here:
https://lore.kernel.org/lkml/20200331114005.5e2fc6f7@canb.auug.org.au/

Thanks!
