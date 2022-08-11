Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64A885908AB
	for <lists+netdev@lfdr.de>; Fri, 12 Aug 2022 00:16:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235925AbiHKWPQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Aug 2022 18:15:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234432AbiHKWPO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Aug 2022 18:15:14 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DF56F11;
        Thu, 11 Aug 2022 15:15:13 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id w3so24693968edc.2;
        Thu, 11 Aug 2022 15:15:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=GpkSAd5yp+o2V/ng0LUPLViC1LjKZGkkoE60oiq7pIo=;
        b=EK1oU4BSbea8oi/JCqaloOaeCcySjMIUUROEfoQGWbwArQsiZc/idhb0kl3iLMp4Fa
         zETxQp0exBPfN5lCqU2N55klBaB5zIhhgxd711XAHWEaQXuOOm7UHPjWu7oY1gdA4C7p
         lp27cxq4/VLPnmFjzlM+34uu+h5wCNqXwW5Yois5SUDQeSOvsAsZBtkr/QP3nXPLBtto
         C4Eg7PWh8swwEbGPCQFaMxUtpcuRJt66NoFUuhkwUV8KwCXEy0TiADQPa7w3j2q0cuXW
         S2B0D8pGxnAXNSF1t/1Od7Z151FKOEYuDsQ1IiZLztSVCngTHtUZjRA8QW6s3p0EdqD9
         9ZCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=GpkSAd5yp+o2V/ng0LUPLViC1LjKZGkkoE60oiq7pIo=;
        b=Z5P/dfyYdM0qMNOTxqefkmAg7q1Nn9ppq9Luid/BejWa9mrESuoLrVOzQslmadjdJ+
         +4W7PbCpGI4BqekZ26ANK6hlzG/RL59d8ERVPQOYWkJS6nTH/IeIdwA4oSxE2g/IFyl2
         zxs5AMjcgk6c/z9qQb2QM9mAgmZgYbIv+Yi30/t+c00YImrUOf+n1ZQaZut9rfKh56nV
         SZB2gw4tJThv3X8jHmo6naP9Gob2vanPRKuXJ8R4xxWP+LO3EmkimBy7hsmRjR1T51c6
         +j1X9LEq0jdDM20cLHCNmEbT8k5klvCXdbPqra5X34Y/4WxiOn4mL7ozPCgyXD+JjpEs
         srnQ==
X-Gm-Message-State: ACgBeo0SWXs16P5jdR4pw1Bzw3hOVAnP43DzHi4RT+bc3mZNoEsupbjP
        TuArMFCpixQGZQ8FNZNBlvIFcADq5anvZv7keD2khl3etN0=
X-Google-Smtp-Source: AA6agR4EV6f9uJu1I4TmO5WFxgW8WIozbu1n0/TVeJVLuwWfZ5yNAKqMCADuWau9UAix3/Hv3tPjmdluaw+aGYn2dww=
X-Received: by 2002:a50:ed82:0:b0:43d:5334:9d19 with SMTP id
 h2-20020a50ed82000000b0043d53349d19mr1029062edr.232.1660256111994; Thu, 11
 Aug 2022 15:15:11 -0700 (PDT)
MIME-Version: 1.0
References: <20220811034020.529685-1-liuhangbin@gmail.com>
In-Reply-To: <20220811034020.529685-1-liuhangbin@gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 11 Aug 2022 15:15:00 -0700
Message-ID: <CAEf4Bzb+vfjrZv+3fmg8wmDQc5iBXO+xubKCdL-4BsgxGmuyOg@mail.gmail.com>
Subject: Re: [PATCHv3 bpf-next] libbpf: Add names for auxiliary maps
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     netdev@vger.kernel.org, Quentin Monnet <quentin@isovalent.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Song Liu <song@kernel.org>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Hao Luo <haoluo@google.com>, Jiri Olsa <jolsa@kernel.org>,
        bpf@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 10, 2022 at 8:40 PM Hangbin Liu <liuhangbin@gmail.com> wrote:
>
> The bpftool self-created maps can appear in final map show output due to
> deferred removal in kernel. These maps don't have a name, which would make
> users confused about where it comes from.
>
> With a libbpf_ prefix name, users could know who created these maps.
> It also could make some tests (like test_offload.py, which skip base maps
> without names as a workaround) filter them out.
>
> Kernel adds bpf prog/map name support in the same merge
> commit fadad670a8ab ("Merge branch 'bpf-extend-info'"). So we can also use
> kernel_supports(NULL, FEAT_PROG_NAME) to check if kernel supports map name.
>
> As disscussed[1], Let's make bpf_map_create accept non-null
> name string, and silently ignore the name if kernel doesn't support.
>
> [1] https://lore.kernel.org/bpf/CAEf4BzYL1TQwo1231s83pjTdFPk9XWWhfZC5=KzkU-VO0k=0Ug@mail.gmail.com/
>
> Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
> ---
> v3: let bpf_map_create ignore the name if kernel doesn't support
> v2: rename the wrapper with proper name
> ---

Applied to bpf-next. But let's also do the same for bpf_prog_load().
We can make probe_kern_prog_name() use sys_bpf_prog_load() directly
and avoid calling bpf_prog_load() and thus avoiding circular
dependency.

Will you be able to do this change?


>  tools/lib/bpf/bpf.c    | 2 +-
>  tools/lib/bpf/libbpf.c | 6 +++---
>  2 files changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/tools/lib/bpf/bpf.c b/tools/lib/bpf/bpf.c
> index efcc06dafbd9..6a96e665dc5d 100644
> --- a/tools/lib/bpf/bpf.c
> +++ b/tools/lib/bpf/bpf.c
> @@ -183,7 +183,7 @@ int bpf_map_create(enum bpf_map_type map_type,
>                 return libbpf_err(-EINVAL);
>
>         attr.map_type = map_type;
> -       if (map_name)
> +       if (map_name && kernel_supports(NULL, FEAT_PROG_NAME))
>                 libbpf_strlcpy(attr.map_name, map_name, sizeof(attr.map_name));
>         attr.key_size = key_size;
>         attr.value_size = value_size;
> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> index f7364ea82ac1..a075211b3730 100644
> --- a/tools/lib/bpf/libbpf.c
> +++ b/tools/lib/bpf/libbpf.c
> @@ -4432,7 +4432,7 @@ static int probe_kern_global_data(void)
>         };
>         int ret, map, insn_cnt = ARRAY_SIZE(insns);
>
> -       map = bpf_map_create(BPF_MAP_TYPE_ARRAY, NULL, sizeof(int), 32, 1, NULL);
> +       map = bpf_map_create(BPF_MAP_TYPE_ARRAY, "libbpf_global", sizeof(int), 32, 1, NULL);
>         if (map < 0) {
>                 ret = -errno;
>                 cp = libbpf_strerror_r(ret, errmsg, sizeof(errmsg));
> @@ -4565,7 +4565,7 @@ static int probe_kern_array_mmap(void)
>         LIBBPF_OPTS(bpf_map_create_opts, opts, .map_flags = BPF_F_MMAPABLE);
>         int fd;
>
> -       fd = bpf_map_create(BPF_MAP_TYPE_ARRAY, NULL, sizeof(int), sizeof(int), 1, &opts);
> +       fd = bpf_map_create(BPF_MAP_TYPE_ARRAY, "libbpf_mmap", sizeof(int), sizeof(int), 1, &opts);
>         return probe_fd(fd);
>  }
>
> @@ -4612,7 +4612,7 @@ static int probe_prog_bind_map(void)
>         };
>         int ret, map, prog, insn_cnt = ARRAY_SIZE(insns);
>
> -       map = bpf_map_create(BPF_MAP_TYPE_ARRAY, NULL, sizeof(int), 32, 1, NULL);
> +       map = bpf_map_create(BPF_MAP_TYPE_ARRAY, "libbpf_det_bind", sizeof(int), 32, 1, NULL);
>         if (map < 0) {
>                 ret = -errno;
>                 cp = libbpf_strerror_r(ret, errmsg, sizeof(errmsg));
> --
> 2.35.3
>
