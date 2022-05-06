Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1365251E205
	for <lists+netdev@lfdr.de>; Sat,  7 May 2022 01:40:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1444773AbiEFW3U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 May 2022 18:29:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1444769AbiEFW3O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 May 2022 18:29:14 -0400
Received: from mail-io1-xd36.google.com (mail-io1-xd36.google.com [IPv6:2607:f8b0:4864:20::d36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AADA5F9F;
        Fri,  6 May 2022 15:25:27 -0700 (PDT)
Received: by mail-io1-xd36.google.com with SMTP id f4so9543866iov.2;
        Fri, 06 May 2022 15:25:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=NKngyg6H4LzHGgY5WX93en+mLYjHn5tEgpXL8XPGins=;
        b=UIsyoBtmGjQUf/J6PDrp0yL7O2eyyFWhQX8HMurJ4yoiwlXKR7JWg12h0zLkuP/KR/
         7JxDrhGQzSMS5nqtKb71urWhTXjHBkzUadFMLMJGI5zhaCqjRLhuIibJcRRHf88Pl3oB
         f2Maq0ax/4STkl0iBZ82j7W+r2RqIZZouLAUCFoQZAs5L0ITDosusKhsPbZ5QJAfIJYO
         4jcMLfdlS6WYZv3tfaoc3/3NwoNBfbCWw++UrShOeGR7fGBA7i3HOQ+QVcZ3V1VqhBLG
         p2bkhZRTHAa7q1/QSthBzYzCN4d+J/9Xf9WYI5u7S11r0fwS3G2YiRHaKaml51sOhrtp
         MG+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NKngyg6H4LzHGgY5WX93en+mLYjHn5tEgpXL8XPGins=;
        b=5cIORzRmE2qvNTSVQ2FinQK5VTaTxvkrRz/ePew8xChob4KSdjatZOkd+rHn0ZU397
         HQXJtMiHvPsqXhwPdyWxwlFY+tYpYiaubnruXMafBL2lsc7U+yaX3p8vQz0+SZxKxbH1
         G+6sc7mYrgd3w2IGt6Gd4ZQNzwmTBrav0MPYQ2U4V782FytzKJ4wvn/W15rK2tRQihG0
         gFHw/1aftJ9MZ4yU4L0iyrQbDaAw7rAIyT84IZDfUVZq9rIDEPbswgiXrkuzeCNr9x5g
         U5w5EDDiLS7kH3wyXRBtP5IbJ1KeqPJSoM3R5hqGr6x0UtG/rC20CLL2vfycxRYiM/o4
         CbBw==
X-Gm-Message-State: AOAM531al03TVgn7Misad+S5LpWxxWf6mT/LDoyIN6pkSIgk+Asw/ibO
        vNtbCdAxqntMBb0rz9BktAkJUCel8g3srnoSgmY=
X-Google-Smtp-Source: ABdhPJzed2737G/RT9aiyHxZPSSu/yCRp9JOQeTbZw7imv2nbuSKOKUw41GLFxPxw99fJQHr2ZFSmig6pZLeoA9/foU=
X-Received: by 2002:a05:6638:533:b0:32a:d418:b77b with SMTP id
 j19-20020a056638053300b0032ad418b77bmr2392102jar.237.1651875926938; Fri, 06
 May 2022 15:25:26 -0700 (PDT)
MIME-Version: 1.0
References: <20220502211235.142250-1-mathew.j.martineau@linux.intel.com> <20220502211235.142250-4-mathew.j.martineau@linux.intel.com>
In-Reply-To: <20220502211235.142250-4-mathew.j.martineau@linux.intel.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 6 May 2022 15:25:16 -0700
Message-ID: <CAEf4BzYKYtQLxHFk7cbGA47JNX7ND4cYEqaoDMiQLBttXYd5+w@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3 3/8] selftests: bpf: Enable
 CONFIG_IKCONFIG_PROC in config
To:     Mat Martineau <mathew.j.martineau@linux.intel.com>
Cc:     Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Geliang Tang <geliang.tang@suse.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, mptcp@lists.linux.dev
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

On Mon, May 2, 2022 at 2:12 PM Mat Martineau
<mathew.j.martineau@linux.intel.com> wrote:
>
> From: Geliang Tang <geliang.tang@suse.com>
>
> CONFIG_IKCONFIG_PROC is required by BPF selftests, otherwise we get
> errors like this:
>
>  libbpf: failed to open system Kconfig
>  libbpf: failed to load object 'kprobe_multi'
>  libbpf: failed to load BPF skeleton 'kprobe_multi': -22
>
> It's because /proc/config.gz is opened in bpf_object__read_kconfig_file()
> in tools/lib/bpf/libbpf.c:
>
>         file = gzopen("/proc/config.gz", "r");
>
> So this patch enables CONFIG_IKCONFIG and CONFIG_IKCONFIG_PROC in
> tools/testing/selftests/bpf/config.
>
> Suggested-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
> Signed-off-by: Geliang Tang <geliang.tang@suse.com>
> Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
> ---

Acked-by: Andrii Nakryiko <andrii@kernel.org>

>  tools/testing/selftests/bpf/config | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/tools/testing/selftests/bpf/config b/tools/testing/selftests/bpf/config
> index 763db63a3890..8d7faff33c54 100644
> --- a/tools/testing/selftests/bpf/config
> +++ b/tools/testing/selftests/bpf/config
> @@ -53,3 +53,5 @@ CONFIG_NF_DEFRAG_IPV4=y
>  CONFIG_NF_DEFRAG_IPV6=y
>  CONFIG_NF_CONNTRACK=y
>  CONFIG_USERFAULTFD=y
> +CONFIG_IKCONFIG=y
> +CONFIG_IKCONFIG_PROC=y
> --
> 2.36.0
>
