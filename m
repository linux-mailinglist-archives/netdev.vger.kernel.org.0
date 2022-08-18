Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99809598C64
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 21:12:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344522AbiHRTMA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 15:12:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240608AbiHRTL7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 15:11:59 -0400
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1808CC00CE
        for <netdev@vger.kernel.org>; Thu, 18 Aug 2022 12:11:55 -0700 (PDT)
Received: by mail-wm1-x336.google.com with SMTP id h204-20020a1c21d5000000b003a5b467c3abso3042094wmh.5
        for <netdev@vger.kernel.org>; Thu, 18 Aug 2022 12:11:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=UEM6xwL26wno309XpbhDNsg9frqzMJCiGi3REZwC0DM=;
        b=HeuOsZXmNcXgVKTTXFFcFjO113/PnINlhnItAs7AitwtBI6uKfgSxZnr23iW0cMQ2M
         qZe5Ce1QmdbYgYvOlxhFBGOL/XnFM1ot3f/gUC9tGtsFq2ysv1zb0hN0ysTow1YwW1JX
         FuQuCP1EjHzCbuuNrOvH8G45xwsXBGVar6TbfD2jxxryv0ItRyejdDxEdWv9ZetRjXZR
         i172u1ZhOfBz2fUdp4o/FFoOhkl/Ngb1Fs1BZcP8urMghqdSkkX+KEtVyclANwItuExU
         EVBDKeMoatrTl6DzQGsx4Kvzmt3UwBquZAlu99FB2BTx9Rrpf2tToJaAyg9pJbxAN0/T
         eRTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=UEM6xwL26wno309XpbhDNsg9frqzMJCiGi3REZwC0DM=;
        b=Rd//EqynSBuMMVvgqV1H3euXQtBEnVm7/b5zP6VntZUusFWlg0Q8gQ4CZ2rvGumUCd
         5/bsQ+VnXPldGgmHrVW8JiPnJIByfs91usRXWtd8H3SDNsPknXspj2SeEGrZlGuWhhZ2
         fYtigP9Z9N/C876taBVTy6bI8jcjvy+vIEajWvM278mDN0Qrnm6gtKnwfiGEQjEdW7dq
         f6Lw4gIxaXvwLg9mFf/hn+tQmBik2x30GCNEOX/sop/TyMfy0GnUHeslm7XTHycoAvW/
         0eJA7plS4IyozQcjnDQiKx5GuNgusVawBhjOUa80S8I9A8rotelSyloyf+NpXYgCu1Q3
         SaDw==
X-Gm-Message-State: ACgBeo3WiHjkeIegK+Azq8LcVw//5MxWnxVGoNEmVfkvEjdUUDWP2WPx
        zzuuQWDHEE1V+Dw/tc8koGt0B/Yr1SIlyVaafmyx+g==
X-Google-Smtp-Source: AA6agR7BuFOI5nYDP1+UNHdgYqJp5jObGk15uAmYt3qTDdh43G3F7FQNDBYYXQezeZ+H9BnmKo3qUC8aUKVndQuo1oM=
X-Received: by 2002:a7b:ce12:0:b0:3a5:4d8b:65df with SMTP id
 m18-20020a7bce12000000b003a54d8b65dfmr2718292wmc.27.1660849913483; Thu, 18
 Aug 2022 12:11:53 -0700 (PDT)
MIME-Version: 1.0
References: <20220818143118.17733-1-laoar.shao@gmail.com> <20220818143118.17733-2-laoar.shao@gmail.com>
In-Reply-To: <20220818143118.17733-2-laoar.shao@gmail.com>
From:   Yosry Ahmed <yosryahmed@google.com>
Date:   Thu, 18 Aug 2022 12:11:16 -0700
Message-ID: <CAJD7tkYGt9ej3ROWGAgG+9HFAN3fweRMtG9o+uhedJLRbUpFLA@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 01/12] cgroup: Update the comment on cgroup_get_from_fd
To:     Yafang Shao <laoar.shao@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        john fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Hao Luo <haoluo@google.com>, Jiri Olsa <jolsa@kernel.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Michal Hocko <mhocko@kernel.org>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Shakeel Butt <shakeelb@google.com>,
        Muchun Song <songmuchun@bytedance.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>,
        Cgroups <cgroups@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 18, 2022 at 7:31 AM Yafang Shao <laoar.shao@gmail.com> wrote:
>
> After commit f3a2aebdd6fb ("cgroup: enable cgroup_get_from_file() on cgroup1")
> we can open a cgroup1 dir as well. So let's update the comment.

I missed updating the comment in my change. Thanks for catching this.

>
> Cc: Yosry Ahmed <yosryahmed@google.com>
> Cc: Hao Luo <haoluo@google.com>
> Cc: Tejun Heo <tj@kernel.org>
> Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
> ---
>  kernel/cgroup/cgroup.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
> index 5f4502a..b7d2e55 100644
> --- a/kernel/cgroup/cgroup.c
> +++ b/kernel/cgroup/cgroup.c
> @@ -6625,7 +6625,7 @@ struct cgroup *cgroup_get_from_path(const char *path)
>
>  /**
>   * cgroup_get_from_fd - get a cgroup pointer from a fd
> - * @fd: fd obtained by open(cgroup2_dir)
> + * @fd: fd obtained by open(cgroup_dir)
>   *
>   * Find the cgroup from a fd which should be obtained
>   * by opening a cgroup directory.  Returns a pointer to the
> --
> 1.8.3.1
>
