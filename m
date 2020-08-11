Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2092524162D
	for <lists+netdev@lfdr.de>; Tue, 11 Aug 2020 08:02:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726424AbgHKGCN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Aug 2020 02:02:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726083AbgHKGCN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Aug 2020 02:02:13 -0400
Received: from mail-yb1-xb42.google.com (mail-yb1-xb42.google.com [IPv6:2607:f8b0:4864:20::b42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF44CC06174A;
        Mon, 10 Aug 2020 23:02:12 -0700 (PDT)
Received: by mail-yb1-xb42.google.com with SMTP id a34so6433992ybj.9;
        Mon, 10 Aug 2020 23:02:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=f72giXEo2Ev6K32+YRYkRawWKIMpKtvEahskzW79c/Y=;
        b=CdErWvnJAmK+G/DeOhxsWcr/qWeTqTKsmfBZTfBhXe6slvdDzMRh3cULy32VFmskTj
         xHGq3//Aj82NexgJi01dUCbuAQTGSn0pabIBkrtg8vN+N1GU34oh8EUksY+3JWGyajjp
         Q4/0w4qsZ7iCbVsbHEN7UMAUuzLrsxFuxFJAea53pSMP3LehfjXqvfkdud9YEPWEh03n
         6TqbUlvo3onVkkDfX9+PU1nqVTWsLptLPSFSrJBLCL4i2kUeBEGMXOX6KC4zex5BKURb
         wso7PEGL8JodtMeu5Cqlu28AVkU8kuG5hdEei/OiqxUbTzpIhmbWoZptUtSSA5AbSvzQ
         evDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=f72giXEo2Ev6K32+YRYkRawWKIMpKtvEahskzW79c/Y=;
        b=SUjbGcYIeBfhn5bz6knA1iL/yJu7zufsxAyo8NWIqxuIpFqUOxgDhHOSG6pgd54s3+
         4FOoXnBAzclI+3JJ5KwP+MNaYLoD2ZuvTufC8fzPYSa7u7yzegj/A5FkAvveNMyn6vC7
         dtIvPeueq3JNehHS/ntNFjy+YhWcr6EFS28qY0NjgOS+S4QGwI1N1/moMHcbOPL5gOOU
         6nd9cSHJZyUgQR7by6EegdPT8oQ1uxq/2MSxY12QLQobWFlIpoOi/TlDjOeQIWoKFUdY
         mvJCRnKwxdmNorgxepsE2Bb4XN+ZN4d+5WFi4+J8aG4UhKb+SVZWGTvdvBc0nzORsQ1B
         WV/Q==
X-Gm-Message-State: AOAM531KpZgByjts3yRjY3mpX2U37358zA8vpWIz+/Di6KmiYXtXyzfY
        2pwWHfYgxU03vjSyIEVMBzjWoB1MQL8BGdk4O3Y=
X-Google-Smtp-Source: ABdhPJywvhzxo5kO7ujgj2rTL6yQ/I3DYrQfhZ+D+AhBBNrXTrbNa2kpyNjWUN68bZnrpwbjB1Mw4Gv8uVKqQJyXV08=
X-Received: by 2002:a25:bc50:: with SMTP id d16mr9834708ybk.230.1597125732152;
 Mon, 10 Aug 2020 23:02:12 -0700 (PDT)
MIME-Version: 1.0
References: <20200809150302.686149-1-jolsa@kernel.org> <20200809150302.686149-9-jolsa@kernel.org>
In-Reply-To: <20200809150302.686149-9-jolsa@kernel.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 10 Aug 2020 23:02:01 -0700
Message-ID: <CAEf4BzZA_qgWEGma+APQZWs5qU07LdJKzKAxxusQThCGGfh2Vw@mail.gmail.com>
Subject: Re: [RFC PATCH v11 bpf-next 08/14] bpf: Add btf_struct_ids_match function
To:     Jiri Olsa <jolsa@kernel.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Martin KaFai Lau <kafai@fb.com>,
        David Miller <davem@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Wenbo Zhang <ethercflow@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Brendan Gregg <bgregg@netflix.com>,
        Florent Revest <revest@chromium.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Aug 9, 2020 at 8:05 AM Jiri Olsa <jolsa@kernel.org> wrote:
>
> Adding btf_struct_ids_match function to check if given address provided
> by BTF object + offset is also address of another nested BTF object.
>
> This allows to pass an argument to helper, which is defined via parent
> BTF object + offset, like for bpf_d_path (added in following changes):
>
>   SEC("fentry/filp_close")
>   int BPF_PROG(prog_close, struct file *file, void *id)
>   {
>     ...
>     ret = bpf_d_path(&file->f_path, ...
>
> The first bpf_d_path argument is hold by verifier as BTF file object
> plus offset of f_path member.
>
> The btf_struct_ids_match function will walk the struct file object and
> check if there's nested struct path object on the given offset.
>
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> ---

LGTM.

Acked-by: Andrii Nakryiko <andriin@fb.com>

>  include/linux/bpf.h   |  2 ++
>  kernel/bpf/btf.c      | 31 +++++++++++++++++++++++++++++++
>  kernel/bpf/verifier.c | 17 +++++++++++------
>  3 files changed, 44 insertions(+), 6 deletions(-)
>

[...]
