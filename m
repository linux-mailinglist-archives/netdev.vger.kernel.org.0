Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3795853072B
	for <lists+netdev@lfdr.de>; Mon, 23 May 2022 03:37:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350596AbiEWBg6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 May 2022 21:36:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238435AbiEWBg5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 May 2022 21:36:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09E472FE52
        for <netdev@vger.kernel.org>; Sun, 22 May 2022 18:36:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9E76A60F90
        for <netdev@vger.kernel.org>; Mon, 23 May 2022 01:36:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9838C341C8
        for <netdev@vger.kernel.org>; Mon, 23 May 2022 01:36:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653269812;
        bh=L6h6qT+8nc10xaEUPypDDnsnQ4L6qOJI2IkYaR1N0QA=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=O/fVkXaQICAKI8TeLh/3g55975QrYytC9Zj8DgRPCvgtKljx0u5I6uvOuBSBA8+bQ
         4BjFse2W6uERi0GXiYtNbBiH7cJiej2DETjY8V+nFt03WAcsFqedhfgeld1YUDCGC4
         G5tbKz+hBO/hde9oUtaCbuYH0LjqR5Rh2Zr5VIOo00u6DWqvbNbmCN5XJYVKCa8dmg
         +DnbTnN7dDDaJhYfWwH0velWxUkKZKZT/7XyvsMi1ppdA+Tcs7vZ98ufHodArkXj2t
         UqoMfLbhgMWEzBQtAOxYyeKcaK5ilFq4kHmcGKRlT+a2iuzuUztB4gFCY8Z/3+1Hsg
         bj1ywxNlY1KUQ==
Received: by mail-lf1-f43.google.com with SMTP id br17so10795833lfb.2
        for <netdev@vger.kernel.org>; Sun, 22 May 2022 18:36:52 -0700 (PDT)
X-Gm-Message-State: AOAM532Jzw2KWISDbs9gLeLzWRfpgp+NBC8Uf0SMrO+DnVekegHXb5tr
        xHTFqAjXiV3ZoeOIGHlg37nKZJOKDp+vbxT4trmS1A==
X-Google-Smtp-Source: ABdhPJzNMfUSnjPL4tskSLO9/0qH0Iujngwr3hBiPy5ZdMwuNLZtASCMVPJR2EEsK4dUQC+cUo0tl+kZ2sYROe7TD1o=
X-Received: by 2002:a05:6512:3a84:b0:472:6384:4de0 with SMTP id
 q4-20020a0565123a8400b0047263844de0mr14237606lfu.456.1653269810602; Sun, 22
 May 2022 18:36:50 -0700 (PDT)
MIME-Version: 1.0
References: <20220518131638.3401509-1-xukuohai@huawei.com> <20220518131638.3401509-6-xukuohai@huawei.com>
In-Reply-To: <20220518131638.3401509-6-xukuohai@huawei.com>
From:   KP Singh <kpsingh@kernel.org>
Date:   Mon, 23 May 2022 03:36:39 +0200
X-Gmail-Original-Message-ID: <CACYkzJ7r=hP_w_brOv3_d1JAta1_Obi2-EvMu4TEQTyBQMSs6g@mail.gmail.com>
Message-ID: <CACYkzJ7r=hP_w_brOv3_d1JAta1_Obi2-EvMu4TEQTyBQMSs6g@mail.gmail.com>
Subject: Re: [PATCH bpf-next v5 5/6] bpf, arm64: bpf trampoline for arm64
To:     Xu Kuohai <xukuohai@huawei.com>
Cc:     bpf@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-kselftest@vger.kernel.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Zi Shen Lim <zlim.lnx@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        hpa@zytor.com, Shuah Khan <shuah@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Pasha Tatashin <pasha.tatashin@soleen.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Daniel Kiss <daniel.kiss@arm.com>,
        Steven Price <steven.price@arm.com>,
        Sudeep Holla <sudeep.holla@arm.com>,
        Marc Zyngier <maz@kernel.org>,
        Peter Collingbourne <pcc@google.com>,
        Mark Brown <broonie@kernel.org>,
        Delyan Kratunov <delyank@fb.com>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 18, 2022 at 3:54 PM Xu Kuohai <xukuohai@huawei.com> wrote:
>
> Add bpf trampoline support for arm64. Most of the logic is the same as
> x86.
>
> Tested on raspberry pi 4b and qemu with KASLR disabled (avoid long jump),
> result:
>  #9  /1     bpf_cookie/kprobe:OK
>  #9  /2     bpf_cookie/multi_kprobe_link_api:FAIL
>  #9  /3     bpf_cookie/multi_kprobe_attach_api:FAIL
>  #9  /4     bpf_cookie/uprobe:OK
>  #9  /5     bpf_cookie/tracepoint:OK
>  #9  /6     bpf_cookie/perf_event:OK
>  #9  /7     bpf_cookie/trampoline:OK
>  #9  /8     bpf_cookie/lsm:OK
>  #9         bpf_cookie:FAIL
>  #18 /1     bpf_tcp_ca/dctcp:OK
>  #18 /2     bpf_tcp_ca/cubic:OK
>  #18 /3     bpf_tcp_ca/invalid_license:OK
>  #18 /4     bpf_tcp_ca/dctcp_fallback:OK
>  #18 /5     bpf_tcp_ca/rel_setsockopt:OK
>  #18        bpf_tcp_ca:OK
>  #51 /1     dummy_st_ops/dummy_st_ops_attach:OK
>  #51 /2     dummy_st_ops/dummy_init_ret_value:OK
>  #51 /3     dummy_st_ops/dummy_init_ptr_arg:OK
>  #51 /4     dummy_st_ops/dummy_multiple_args:OK
>  #51        dummy_st_ops:OK
>  #55        fentry_fexit:OK
>  #56        fentry_test:OK
>  #57 /1     fexit_bpf2bpf/target_no_callees:OK
>  #57 /2     fexit_bpf2bpf/target_yes_callees:OK
>  #57 /3     fexit_bpf2bpf/func_replace:OK
>  #57 /4     fexit_bpf2bpf/func_replace_verify:OK
>  #57 /5     fexit_bpf2bpf/func_sockmap_update:OK
>  #57 /6     fexit_bpf2bpf/func_replace_return_code:OK
>  #57 /7     fexit_bpf2bpf/func_map_prog_compatibility:OK
>  #57 /8     fexit_bpf2bpf/func_replace_multi:OK
>  #57 /9     fexit_bpf2bpf/fmod_ret_freplace:OK
>  #57        fexit_bpf2bpf:OK
>  #58        fexit_sleep:OK
>  #59        fexit_stress:OK
>  #60        fexit_test:OK
>  #67        get_func_args_test:OK
>  #68        get_func_ip_test:OK
>  #104       modify_return:OK
>  #237       xdp_bpf2bpf:OK
>
> bpf_cookie/multi_kprobe_link_api and bpf_cookie/multi_kprobe_attach_api
> failed due to lack of multi_kprobe on arm64.
>
> Signed-off-by: Xu Kuohai <xukuohai@huawei.com>
> Acked-by: Song Liu <songliubraving@fb.com>

Acked-by: KP Singh <kpsingh@kernel.org>

Thanks! This is exciting.
