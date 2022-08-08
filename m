Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ECCFB58C9AF
	for <lists+netdev@lfdr.de>; Mon,  8 Aug 2022 15:45:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243058AbiHHNpJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Aug 2022 09:45:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242651AbiHHNpI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Aug 2022 09:45:08 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCDDBBE39
        for <netdev@vger.kernel.org>; Mon,  8 Aug 2022 06:45:06 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id z17so10959389wrq.4
        for <netdev@vger.kernel.org>; Mon, 08 Aug 2022 06:45:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=xbARny34m6AaAfB3bQjFW271YXpbVtEoFE3ylaSXndU=;
        b=Ip/wMUk9fZpWB8Vx39YbgZNluU6LUE4mCmMT85P/E5VMoMYb/NOXVIIS1aBVRYGT2r
         pGV6HNKIi8M0U6B8ald7Onz7sce8o57JyO9SYCstCm5fiCQpUX3q8LiEymUuKdFkKQS+
         GwDvBbX6ZmiWyb5Rvi7AMO0kltmR5QSQRMXyeTNIlmVHVRptenOWEIg7y77zcpNVwbOr
         gLBEdYNVGWrvQrYW3wdSA5kvKr0/ueNVvxm/6Porn/8RGaaixS+1Q0oLHuAVMvrsH+1q
         9l9vWpH4pzO+qililXqz0bk+2chXWWCpd68y4savLFCupQPjpZisbeWF7mk9RxrRtBiv
         JD7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=xbARny34m6AaAfB3bQjFW271YXpbVtEoFE3ylaSXndU=;
        b=FNKMpBk5jVluoeraStchCNV4DhFOMIEJlLiws3JqbEt/FN3q6QRjNaGYkexJR95iRb
         dYgCtHyfBpiwFO7USh8Xt+dgXmEy4DniVVfxNRzesqEZT+zARaLCoxqn/NrwP9YzFa05
         KfWw5wCzE9wHveW5qo50WTQUyRzn+H1t6oqMyFRLVgPPDiMPWf8dQN9PMvEx/aiuMYsU
         hoFluGbEWi9KXGYLUZCNAfM1YyAFH7z/qks+yrV9e4GEAWtBepmnwLotsh5DLzgO7He/
         HXgcU2k6alXqHhg3I9VwaY7k5eOkX0UCh5aFGT2Kn5nlOLvFQI3ExemKpI2jN4cwSk/h
         vg8g==
X-Gm-Message-State: ACgBeo3iTl96s6ASr+UgbLoQvxyFOmCK+Lv2qp/r+wmryeEwuzaT08OG
        Mz6LkICOvyHOfNDHQyTrTSeRyQ==
X-Google-Smtp-Source: AA6agR4s0GVF2NYGmEeNlKfrNPGu9D7ml9GYPOYX9mj5oDwZqB0H7XfCkZ59uVurcQBrMdmUVvBlIw==
X-Received: by 2002:a5d:453a:0:b0:21e:cfb2:b325 with SMTP id j26-20020a5d453a000000b0021ecfb2b325mr11010730wra.540.1659966305381;
        Mon, 08 Aug 2022 06:45:05 -0700 (PDT)
Received: from [192.168.178.32] ([51.155.200.13])
        by smtp.gmail.com with ESMTPSA id u7-20020a05600c210700b003a3561d4f3fsm2625132wml.43.2022.08.08.06.45.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 Aug 2022 06:45:04 -0700 (PDT)
Message-ID: <9656fc7c-a5f6-8fa8-31c1-aeac07b765d8@isovalent.com>
Date:   Mon, 8 Aug 2022 14:45:03 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.1.0
Subject: Re: [PATCH bpf-next] libbpf: try to add a name for bpftool
 self-created maps
Content-Language: en-GB
To:     Hangbin Liu <liuhangbin@gmail.com>, netdev@vger.kernel.org
Cc:     Andrii Nakryiko <andrii@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Song Liu <song@kernel.org>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Hao Luo <haoluo@google.com>, Jiri Olsa <jolsa@kernel.org>,
        bpf@vger.kernel.org
References: <20220808093304.46291-1-liuhangbin@gmail.com>
From:   Quentin Monnet <quentin@isovalent.com>
In-Reply-To: <20220808093304.46291-1-liuhangbin@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 08/08/2022 10:33, Hangbin Liu wrote:
> As discussed before[1], the bpftool self-created maps can appear in final
> map show output due to deferred removal in kernel. These maps don't have
> a name, which would make users confused about where it comes from.
> 
> Adding names for these maps could make users know what these maps used for.
> It also could make some tests (like test_offload.py, which skip base maps
> without names as a workaround) filter them out.
> 
> As Quentin suggested, add a small wrapper to fall back with no name
> if kernel is not supported.
> 
> [1] https://lore.kernel.org/bpf/CAEf4BzY66WPKQbDe74AKZ6nFtZjq5e+G3Ji2egcVytB9R6_sGQ@mail.gmail.com/
> 
> Suggested-by: Quentin Monnet <quentin@isovalent.com>
> Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
> ---
>  tools/lib/bpf/libbpf.c | 22 +++++++++++++++++++---
>  1 file changed, 19 insertions(+), 3 deletions(-)
> 
> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> index 77e3797cf75a..db4f1a02b9e0 100644
> --- a/tools/lib/bpf/libbpf.c
> +++ b/tools/lib/bpf/libbpf.c
> @@ -4423,6 +4423,22 @@ static int probe_kern_prog_name(void)
>  	return probe_fd(ret);
>  }
>  
> +static int probe_kern_map_name(enum bpf_map_type map_type,
> +			       const char *map_name, __u32 key_size,
> +			       __u32 value_size, __u32 max_entries,
> +			       const struct bpf_map_create_opts *opts)
> +{
> +	int map;
> +
> +	map = bpf_map_create(map_type, map_name, key_size, value_size, max_entries, opts);
> +	if (map < 0 && errno == EINVAL) {
> +		/* Retry without name */
> +		map = bpf_map_create(map_type, NULL, key_size, value_size, max_entries, opts);
> +	}
> +
> +	return map;
> +}
> +
>  static int probe_kern_global_data(void)
>  {
>  	char *cp, errmsg[STRERR_BUFSIZE];
> @@ -4434,7 +4450,7 @@ static int probe_kern_global_data(void)
>  	};
>  	int ret, map, insn_cnt = ARRAY_SIZE(insns);
>  
> -	map = bpf_map_create(BPF_MAP_TYPE_ARRAY, NULL, sizeof(int), 32, 1, NULL);
> +	map = probe_kern_map_name(BPF_MAP_TYPE_ARRAY, "global_data", sizeof(int), 32, 1, NULL);

Thanks! Some comments on the naming: It reads strange here to "probe"
for the maps, given that we still need to compare the return value
below. Maybe use something else instead of "probe_kern_map_name()"?
Maybe "map_create_adjust_name()" or "map_create_compat()" (or something
else)?

Regarding "global_data": If the intent is to filter out these maps from
the output of bpftool for example, should we use a common prefix for the
three of them? "libbpf_" or "probe_"? Or even something shorter? I know
we're limited to 15 characters.

Quentin
