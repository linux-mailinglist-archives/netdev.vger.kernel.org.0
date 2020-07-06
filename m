Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F2C421624C
	for <lists+netdev@lfdr.de>; Tue,  7 Jul 2020 01:30:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727099AbgGFXad (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jul 2020 19:30:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726883AbgGFXac (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jul 2020 19:30:32 -0400
Received: from mail-qv1-xf42.google.com (mail-qv1-xf42.google.com [IPv6:2607:f8b0:4864:20::f42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B089C061755;
        Mon,  6 Jul 2020 16:30:32 -0700 (PDT)
Received: by mail-qv1-xf42.google.com with SMTP id el4so13953534qvb.13;
        Mon, 06 Jul 2020 16:30:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=sEYAnl7prQHprAtPmbvkOLzh+EIfJl1q1qPEd73ZF90=;
        b=IaEooQ+HtW5/ixteRvdLrim36x/MJPp2A+EpNKz+MwgPVivK+J4Hy5O6nsp0hvmDRz
         4Poe/DwVBR8rM/jt5hdQgW3JIAFwelIdR6jC1Bt58D032G7YXOM/PRq1xkjfk08qi0UU
         2J6MitC5W2WsA8TuJXdtxgFwDPCpbSur55hEx+KUeYt/RbjtNr9Wvx+BSqErGMcVZwgE
         kQ5gJRybYt7q4AA1ItTtdnVgdiimbkhoc+9QFva2cgEbcKu+CrnYJDGTUl/o7vNjbbTY
         7LqQhz+IpgPou5mGkL8UqDrKfFSxkPRABc07a63zZxswBkDggLrz2R1r8D7e0NLedBs8
         0DIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=sEYAnl7prQHprAtPmbvkOLzh+EIfJl1q1qPEd73ZF90=;
        b=qheDGAcXbHY7q5h3fJbkIK0g1aVOZLv5vmjepGfotFLMjDQc999s+jJgl5YLRXDuos
         NyfeD0vGvnV0tqgiAee2/BI1I8eWOAYqgiElfFkUQxsQYNGvn8vhbzh+2RhJHA+3J5NN
         qZa7ZusI3CxKPsFuBQJLhJQuYsVbMy9jWdfeHWv9V5qiP+emQJVEl9PgmyttJhCWjOur
         ZcRtZ6SB3CF34kg9iX7dJ4OZAAUNXWyedX7YOlL9FqwuOBgbfc57YYfnT+fuKGPYrliL
         yfuUs1ybj6Q5X+wsXFRjX7YACE1yXLhp/Zl6uL8ZLT9BRQ5OoK1As7gCx6ZAnUhh+7/g
         gGaQ==
X-Gm-Message-State: AOAM531K+5iRvB8V9ZbrxmOBs02u7iJs6Xr2bvOETdOBdvpUroSQeFis
        Y85soRXRRuCypYCMZPqMUPDmM+d3l5vHaJQKzSI=
X-Google-Smtp-Source: ABdhPJzhi3dXMW2wLnhMZTfNDYvtRvQbwopLobSphC8nOA8mplWldKl87o5czG0BeCBJUDgXBB9nTglkEeUv/Y+DaBQ=
X-Received: by 2002:a05:6214:bce:: with SMTP id ff14mr48906742qvb.196.1594078231585;
 Mon, 06 Jul 2020 16:30:31 -0700 (PDT)
MIME-Version: 1.0
References: <159371070880.18158.837974429614447605.stgit@john-XPS-13-9370>
In-Reply-To: <159371070880.18158.837974429614447605.stgit@john-XPS-13-9370>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 6 Jul 2020 16:30:20 -0700
Message-ID: <CAEf4BzYXxrmT3oBF470WvqDX0pv5RUnuuFb+S0kxzXzEs4nq_w@mail.gmail.com>
Subject: Re: [bpf-next PATCH] bpf: fix bpftool without skeleton code enabled
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     Andrii Nakryiko <andriin@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 2, 2020 at 10:25 AM John Fastabend <john.fastabend@gmail.com> wrote:
>
> Fix segfault from bpftool by adding emit_obj_refs_plain when skeleton
> code is disabled.
>
> Tested by deleting BUILD_BPF_SKELS in Makefile.
>
> # ./bpftool prog show
> Error: bpftool built without PID iterator support
> 3: cgroup_skb  tag 7be49e3934a125ba  gpl
>         loaded_at 2020-07-01T08:01:29-0700  uid 0
> Segmentation fault
>
> Signed-off-by: John Fastabend <john.fastabend@gmail.com>
> ---

My bad, thanks for the fix!

Acked-by: Andrii Nakryiko <andriin@fb.com>

>  tools/bpf/bpftool/pids.c |    1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/tools/bpf/bpftool/pids.c b/tools/bpf/bpftool/pids.c
> index 2709be4de2b1..7d5416667c85 100644
> --- a/tools/bpf/bpftool/pids.c
> +++ b/tools/bpf/bpftool/pids.c
> @@ -19,6 +19,7 @@ int build_obj_refs_table(struct obj_refs_table *table, enum bpf_obj_type type)
>         return -ENOTSUP;
>  }
>  void delete_obj_refs_table(struct obj_refs_table *table) {}
> +void emit_obj_refs_plain(struct obj_refs_table *table, __u32 id, const char *prefix) {}
>
>  #else /* BPFTOOL_WITHOUT_SKELETONS */
>
>
