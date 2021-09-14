Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6936340BC23
	for <lists+netdev@lfdr.de>; Wed, 15 Sep 2021 01:26:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233774AbhINX10 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Sep 2021 19:27:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229746AbhINX1Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Sep 2021 19:27:25 -0400
Received: from mail-yb1-xb29.google.com (mail-yb1-xb29.google.com [IPv6:2607:f8b0:4864:20::b29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C3B8C061574;
        Tue, 14 Sep 2021 16:26:07 -0700 (PDT)
Received: by mail-yb1-xb29.google.com with SMTP id c6so1664536ybm.10;
        Tue, 14 Sep 2021 16:26:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8SPMZw7letZVOmwRFHSmDlggLNsURmXWVYspyUTzslg=;
        b=jD0s0TcvVq3Pej0Lhf7QoXgiu11fIqsMP7scn9mqJQ01rYqvm7LaCAoBIS8zZK64jp
         dS53GvTu+LWtfXg9aQAtbH7yW1Sah5QbYEahMeU6X1Jdi9kRNO/vkz4eo7sYBMSoKE+0
         85Sa9iFS2zeQkyHnTaQqnjUxGZY8xbPToxIQsC/wK3Y9KwfabT/4pVBaVxDQN4pTpdkO
         8I3aqw48UsmtmFHxt3sOejVVkw6AJbC1QQuLhA9MQ4qF0Phaxm8Wno8msPby9Ke2MmDv
         Vhkihy+/9grCsLqiCNBvx6k0/Qv7cCtc9Y7bqOCskOG4N/1v429JbClTN9v/0vc7395B
         WunQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8SPMZw7letZVOmwRFHSmDlggLNsURmXWVYspyUTzslg=;
        b=gDBLOG5Nji2YEdGQTCmSt4nwhBwzz5zSKGlK6p4z49/20yztdFGZ16T1UakaSjgRBd
         y/XsjGmlYHhhRoEUAFvAT3bz79In+qM57lo5GXiriH4veKngTdyYz1LI9BluqEndLiMg
         IcP2lyeaSpjA7xWO7j22ZB8rKP47dr/tNheS2+3K9yMlqhK4eeeXC3hQ4s3oLnAttdl2
         dTpmWlM46NvVGX8FI8ZzS0VFvsQ7gvjsY9RyOtMfdrZQocXFPWwyIT1Cpgh+ZE4TNAQ7
         PSWk3u5jpKAQkHqyYf9lMQRVQfl8GfmBtkdJGOXVJbAgpGNsFpcyB39Jg2Txa2SZ+xJl
         gUNg==
X-Gm-Message-State: AOAM53165m0VxRNtXBQ3Tb8B6J4/Nb8J6r9fj8kRRYk6Zv0DPTtPIzr3
        7UwbthejTgEbGAJ4+XwK4zaCjV+eXe67YCxXYkk=
X-Google-Smtp-Source: ABdhPJwnPFV/2T5qq53PN9HPlJLcY/YHs+64oSKb5MTMiB2xsie7BC8FAOhkz7IfL1nWchIFhS9UueAEhsiusdfCp2k=
X-Received: by 2002:a25:afcd:: with SMTP id d13mr2268759ybj.504.1631661966618;
 Tue, 14 Sep 2021 16:26:06 -0700 (PDT)
MIME-Version: 1.0
References: <20210914113730.74623156@canb.auug.org.au>
In-Reply-To: <20210914113730.74623156@canb.auug.org.au>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 14 Sep 2021 16:25:55 -0700
Message-ID: <CAEf4BzYt4XnHr=zxAEeA2=xF_LCNs_eqneO1R6j8=PMTBo5Z5w@mail.gmail.com>
Subject: Re: linux-next: build failure after merge of the bpf-next tree
To:     Stephen Rothwell <sfr@canb.auug.org.au>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Quentin Monnet <quentin@isovalent.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Jiri Olsa <jolsa@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 13, 2021 at 6:37 PM Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>
> Hi all,
>
> After merging the bpf-next tree, today's linux-next build (perf) failed
> like this:
>
> util/bpf-event.c: In function 'btf__load_from_kernel_by_id':
> util/bpf-event.c:27:8: error: 'btf__get_from_id' is deprecated: libbpf v0.6+: use btf__load_from_kernel_by_id instead [-Werror=deprecated-declarations]
>    27 |        int err = btf__get_from_id(id, &btf);
>       |        ^~~
> In file included from util/bpf-event.c:5:
> /home/sfr/next/next/tools/lib/bpf/btf.h:54:16: note: declared here
>    54 | LIBBPF_API int btf__get_from_id(__u32 id, struct btf **btf);
>       |                ^~~~~~~~~~~~~~~~
> cc1: all warnings being treated as errors
>
> Caused by commit
>
>   0b46b7550560 ("libbpf: Add LIBBPF_DEPRECATED_SINCE macro for scheduling API deprecations")

Should be fixed by [0], when applied to perf tree. Thanks for reporting!

  [0] https://patchwork.kernel.org/project/netdevbpf/patch/20210914170004.4185659-1-andrii@kernel.org/

>
> I have used the bpf-next tree from next-20210913 for today.
>
> --
> Cheers,
> Stephen Rothwell
