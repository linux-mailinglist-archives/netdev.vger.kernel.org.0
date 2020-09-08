Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64F3D262063
	for <lists+netdev@lfdr.de>; Tue,  8 Sep 2020 22:11:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732167AbgIHULu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Sep 2020 16:11:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729912AbgIHULs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Sep 2020 16:11:48 -0400
Received: from mail-yb1-xb43.google.com (mail-yb1-xb43.google.com [IPv6:2607:f8b0:4864:20::b43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 152F4C061573;
        Tue,  8 Sep 2020 13:11:48 -0700 (PDT)
Received: by mail-yb1-xb43.google.com with SMTP id x8so285753ybm.3;
        Tue, 08 Sep 2020 13:11:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hV6zoqmULS1E3oyPVTcV7U1rJmEEdrnsD/ct5UkT0mA=;
        b=dYazESUtYCknD9huVigz6CWWtQKbOOdAx2gCevzjOsYojCXinwCYqdrvFv12TOYesC
         HOYwYoLDSTbQDTZRVjbyihBiVAZPrBboerjcMIJWpaN2KhXaP7yI8KYJv9V6/zx/pUCS
         q31WuPLAFDfJ+oBYESrB6Ccl5pnXtMR+CHUBeUmN+ic/gCw8H2b89s2gK3CGRbdjnYgR
         9aCLLrTpzKieSOD8DsZHlyYSyFc2HACfsV1noapGn/DwfffmW2KTwLUZnTJzsc1/H+W5
         KBaJ13lrfBXOFWKGz1OMRWDGHWnAv3nhK6U9uS9kjb6IoAIi10RSBeHbtAPQ1hT6GDOj
         pIrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hV6zoqmULS1E3oyPVTcV7U1rJmEEdrnsD/ct5UkT0mA=;
        b=b1MO4YCoLm9+4Ijvtm6vdB8iOyteaHQYbEn0U39ZCe5+PhqVj/U2/hLUNoVFEJ8vGN
         dNKc0SMVoLzhSCj08GsEORDmcO31Ijb46WEGvJnNKAVsBc8PzNEfn6/V1EeassOowDDw
         WRa99HJbIe1Lc87pzKflLvFinIL7HkeTpGZh38K+THU6eizc3D94tYW1fK5RJZeJE9Hp
         A5jk0fGND+rzRlBoCHnBWRIYhfPapDWipnKvdTXok+sOw1OL0WkgyjUihTyr+dLIHwmc
         TW3EPemJ1ZRzJr+G2hwiCw1pGhUzVchNwiMLC0edGWG6245sEk+6XQzFs81l20UbYQM2
         HfmA==
X-Gm-Message-State: AOAM531YGF1DTIm/ALr5xWhdx3UYGrbS2V9h6jodGCGO2EldVuPOhuM2
        SMBFDFaXmlJta/ooZ4JX3pUoXHiVs+GMu+R9Omk=
X-Google-Smtp-Source: ABdhPJwvQHHV7sCmYuMMvkvORZSpFjuayQSAfKbpi2RLyPBRgNt/qhT9eeVFAhVE2DQpqVhgs/3VawM/tCjvEJi5Gs8=
X-Received: by 2002:a25:aa8f:: with SMTP id t15mr807730ybi.459.1599595907313;
 Tue, 08 Sep 2020 13:11:47 -0700 (PDT)
MIME-Version: 1.0
References: <20200907110237.1329532-1-jolsa@kernel.org>
In-Reply-To: <20200907110237.1329532-1-jolsa@kernel.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 8 Sep 2020 13:11:36 -0700
Message-ID: <CAEf4BzZpD2mjEA2Qo2cZ4Bp01fSwZkMPFAZOSw8VvOSAqOWNsA@mail.gmail.com>
Subject: Re: [PATCH] perf tools: Do not use deprecated bpf_program__title
To:     Jiri Olsa <jolsa@kernel.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 7, 2020 at 10:57 AM Jiri Olsa <jolsa@kernel.org> wrote:
>
> The bpf_program__title function got deprecated in libbpf,
> use the suggested alternative.
>
> Fixes: 521095842027 ("libbpf: Deprecate notion of BPF program "title" in favor of "section name"")
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> ---

Hey Jiri,

Didn't see your patch before I sent mine against bpf-next. I also
removed some unnecessary checks there. Please see [0]. I don't care
which one gets applied, btw.

  [0] https://patchwork.ozlabs.org/project/netdev/patch/20200908180127.1249-1-andriin@fb.com/

>  tools/perf/util/bpf-loader.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/tools/perf/util/bpf-loader.c b/tools/perf/util/bpf-loader.c
> index 2feb751516ab..73de3973c8ec 100644
> --- a/tools/perf/util/bpf-loader.c
> +++ b/tools/perf/util/bpf-loader.c
> @@ -328,7 +328,7 @@ config_bpf_program(struct bpf_program *prog)
>         probe_conf.no_inlines = false;
>         probe_conf.force_add = false;
>
> -       config_str = bpf_program__title(prog, false);
> +       config_str = bpf_program__section_name(prog);
>         if (IS_ERR(config_str)) {
>                 pr_debug("bpf: unable to get title for program\n");
>                 return PTR_ERR(config_str);
> @@ -454,7 +454,7 @@ preproc_gen_prologue(struct bpf_program *prog, int n,
>         if (err) {
>                 const char *title;
>
> -               title = bpf_program__title(prog, false);
> +               title = bpf_program__section_name(prog);
>                 if (!title)
>                         title = "[unknown]";
>
> --
> 2.26.2
>
