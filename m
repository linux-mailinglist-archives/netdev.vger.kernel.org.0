Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61CE926E51F
	for <lists+netdev@lfdr.de>; Thu, 17 Sep 2020 21:13:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726598AbgIQTN1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Sep 2020 15:13:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726518AbgIQTNJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Sep 2020 15:13:09 -0400
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10D75C06178B
        for <netdev@vger.kernel.org>; Thu, 17 Sep 2020 12:12:59 -0700 (PDT)
Received: by mail-ej1-x642.google.com with SMTP id z22so4794815ejl.7
        for <netdev@vger.kernel.org>; Thu, 17 Sep 2020 12:12:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3LEPP0iVO4pOzmayuWFbUiTrC/zzrJHdmu9l66uZ3ww=;
        b=A8v+LFGmLAiO8xRtH9s3ZBA0ErXORvSRkCXdgySdxxbuOJB+chA7rl6b2sM/AI825O
         Duj98X4AUtCKr3G6eEUT0XjUWGnlWIKxlHKBnAnETBWPH492e2lWXygqMxF2mxj6qp3V
         29WHJr0FOv9xnowF0TTP/IZx7KBni2v04ANGLmndnlpXSmjQAO/gL+Y93X+C8GxZLcKr
         QHbPxm+Sy/tBBQyvrA1YiwkhB6EXXh1JJhsIGzjbIYDvesYwtwnYxldcZs7OkNdjeqLG
         QlfB9h7T6clAyJiCmitV6GggXDkLu4D2bSEUuO04R1kWjvEQ0524+xyPUOqr0N3IKtGS
         Gmmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3LEPP0iVO4pOzmayuWFbUiTrC/zzrJHdmu9l66uZ3ww=;
        b=IRLV6EVyZPsFD7qbpvXjkaX7WWGGyDX/SRBhP97q2wVOe+teOptJbfYFXrWFhM8kk4
         UtGWlIIPVfOcMjarODbDcoMlSU4+lE6APcH3Z8RSbbF9d9esxK54j/CvAqKIJAv97DLw
         4LP4aypXBy6+DRrb7kjhFQmEHFMAGySx9Fbi4nE73af6ApT5KtnNvXNGyEZlVhX2UFY+
         cGmDyerAWtwvag5wnLzJAuPT8agB4c+GoudXbeJTR5GO17Xps25aEiYj5xXzHRlwwwb8
         kubLxsakH+tp7Lbk7hdxHPXRqJUucHcte2adnkITvnjlGk42KPVOwpKXtTtt2O4YF9hC
         UikA==
X-Gm-Message-State: AOAM531MUMYtAPbnwMAU46DgeuUHcGodW5hv7yOR/SCbq3AKVhbBKzRM
        zD4IT/IGmzbC6ASLTnqYdlckdmydzRi9ZQV2WtmxAg==
X-Google-Smtp-Source: ABdhPJwQfuJiXhXQahr+dOg2pgt3CLLw7RBQj5IqI09dioBvbhiK8kYARiekAKmguXmiDhUnJ9irhoIyWQ2VuILnUQA=
X-Received: by 2002:a17:906:4553:: with SMTP id s19mr31491477ejq.475.1600369978174;
 Thu, 17 Sep 2020 12:12:58 -0700 (PDT)
MIME-Version: 1.0
References: <20200916223512.2885524-5-haoluo@google.com> <202009170943.rYEs5XMN%lkp@intel.com>
In-Reply-To: <202009170943.rYEs5XMN%lkp@intel.com>
From:   Hao Luo <haoluo@google.com>
Date:   Thu, 17 Sep 2020 12:12:47 -0700
Message-ID: <CA+khW7iDK+g_W30doEtjse1BSHmB62GcrtmkH3pMk7shymw=XA@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3 4/6] bpf: Introduce bpf_per_cpu_ptr()
To:     kernel test robot <lkp@intel.com>
Cc:     Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>, kbuild-all@lists.01.org,
        Shuah Khan <skhan@linuxfoundation.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andriin@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I need to cast the pointer to "const void __percpu *" before passing
into per_cpu_ptr. I will update and resend.

On Wed, Sep 16, 2020 at 6:14 PM kernel test robot <lkp@intel.com> wrote:
>
> Hi Hao,
>
> Thank you for the patch! Perhaps something to improve:
>
> [auto build test WARNING on bpf-next/master]
>
> url:    https://github.com/0day-ci/linux/commits/Hao-Luo/bpf-BTF-support-for-ksyms/20200917-064052
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git master
> config: powerpc-randconfig-s032-20200916 (attached as .config)
> compiler: powerpc64-linux-gcc (GCC) 9.3.0
> reproduce:
>         wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
>         chmod +x ~/bin/make.cross
>         # apt-get install sparse
>         # sparse version: v0.6.2-201-g24bdaac6-dirty
>         # save the attached .config to linux build tree
>         COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-9.3.0 make.cross C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__' ARCH=powerpc
>
> If you fix the issue, kindly add following tag as appropriate
> Reported-by: kernel test robot <lkp@intel.com>
>
>
> sparse warnings: (new ones prefixed by >>)
>
> >> kernel/bpf/helpers.c:631:31: sparse: sparse: incorrect type in initializer (different address spaces) @@     expected void const [noderef] __percpu *__vpp_verify @@     got void const * @@
> >> kernel/bpf/helpers.c:631:31: sparse:     expected void const [noderef] __percpu *__vpp_verify
> >> kernel/bpf/helpers.c:631:31: sparse:     got void const *
>
> # https://github.com/0day-ci/linux/commit/3f6ea3c1c73efe466a96ff7499219fe3b03b8f48
> git remote add linux-review https://github.com/0day-ci/linux
> git fetch --no-tags linux-review Hao-Luo/bpf-BTF-support-for-ksyms/20200917-064052
> git checkout 3f6ea3c1c73efe466a96ff7499219fe3b03b8f48
> vim +631 kernel/bpf/helpers.c
>
>    625
>    626  BPF_CALL_2(bpf_per_cpu_ptr, const void *, ptr, u32, cpu)
>    627  {
>    628          if (cpu >= nr_cpu_ids)
>    629                  return (unsigned long)NULL;
>    630
>  > 631          return (unsigned long)per_cpu_ptr(ptr, cpu);
>    632  }
>    633
>    634  const struct bpf_func_proto bpf_per_cpu_ptr_proto = {
>    635          .func           = bpf_per_cpu_ptr,
>    636          .gpl_only       = false,
>    637          .ret_type       = RET_PTR_TO_MEM_OR_BTF_ID_OR_NULL,
>    638          .arg1_type      = ARG_PTR_TO_PERCPU_BTF_ID,
>    639          .arg2_type      = ARG_ANYTHING,
>    640  };
>    641
>  > 642  const struct bpf_func_proto bpf_get_current_task_proto __weak;
>    643  const struct bpf_func_proto bpf_probe_read_user_proto __weak;
>    644  const struct bpf_func_proto bpf_probe_read_user_str_proto __weak;
>    645  const struct bpf_func_proto bpf_probe_read_kernel_proto __weak;
>    646  const struct bpf_func_proto bpf_probe_read_kernel_str_proto __weak;
>    647
>
> ---
> 0-DAY CI Kernel Test Service, Intel Corporation
> https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
