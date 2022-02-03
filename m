Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70CA64A7EE6
	for <lists+netdev@lfdr.de>; Thu,  3 Feb 2022 06:20:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232969AbiBCFUq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Feb 2022 00:20:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229872AbiBCFUp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Feb 2022 00:20:45 -0500
Received: from mail-yb1-xb35.google.com (mail-yb1-xb35.google.com [IPv6:2607:f8b0:4864:20::b35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 781A5C061714
        for <netdev@vger.kernel.org>; Wed,  2 Feb 2022 21:20:45 -0800 (PST)
Received: by mail-yb1-xb35.google.com with SMTP id m6so5379743ybc.9
        for <netdev@vger.kernel.org>; Wed, 02 Feb 2022 21:20:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=iEaZO0Lxrcsj9Qc0hQDlkSp7ZeBkDExBuQ09dFvwpSM=;
        b=KwdAYuSWuxS/WR3nb2LdTfLhPuXiU4ol6CJQMs1+3e0xxSowe1u0gxGNPROgn51q0b
         XNioe/lMpPUbM+DrYIph3NzKW1ISolnaXA6KAc+rODxcCr96jJ2jZVgi/BETulLIRLWh
         Q1tNy3DpTayO8y55InBKaK0BLnY+BN0PCw7DfWW8PHQA5DW/zyxcjJ+OgxmMvvOEynQy
         KlRyHgj5UBdFagnc9ZyNYG7mYHoX7TuuvwNvQ8zQTRpGEn9K3vGXGP7B2IaBQ2oGS3Fw
         DVIXi4aFt6rifm5zcG4S3/pZs7LDM9rXosZHaduBxaGPrgU7OQYWnWrBZVWWfZFVhiHI
         Euhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=iEaZO0Lxrcsj9Qc0hQDlkSp7ZeBkDExBuQ09dFvwpSM=;
        b=TkBo9DlIAn6wIgr4EPl12qMGXEwxqDcHlgbmFN/2kRsFgyvHvjY4w2fyzYYoDSY8Mv
         /zCqLx2t8mKLiMo0eI3sHEzKY/QsO71TmFImKaa7/KY4YBatSO9SlyDxjZxpZjpmPDw1
         F5poMkpQPZKsYvIrqsCEu+g0hJOwNaMxAXFP4Xnoi8yIBpmmUa0xQCy/ULh6Lyxfg6PC
         riJHB8rIgr9hStcVUvcGKdTs3tWiyN+SvmYIXPxvujMW950RiMJKJGul5sJkNlhtLebk
         KkLCzFMz/BPGHD9x4eBnIPCQpRE1dOTJVvw3qOKixw8fdb7SHDb16qDjhR/PL7nNz1b8
         FyAw==
X-Gm-Message-State: AOAM531YbCAVB5Mu1sMhNjQfpD1JWB7qJ2RVhvhamXlwl+7PxksXvGlV
        x5SnNNl5E2sReS5AIPlyRjQ6QFNITYRbg88Pmx/uGA==
X-Google-Smtp-Source: ABdhPJzI7VkfGopKurfIdmXldpkPPYvur07XKyi0c9Q5vWaEhUxry6YyjFJbZndZslT2tvqVnj99N4A4alWeuhD4BX4=
X-Received: by 2002:a25:8885:: with SMTP id d5mr25561477ybl.383.1643865644399;
 Wed, 02 Feb 2022 21:20:44 -0800 (PST)
MIME-Version: 1.0
References: <20220203015140.3022854-10-eric.dumazet@gmail.com> <202202031206.1nNLT568-lkp@intel.com>
In-Reply-To: <202202031206.1nNLT568-lkp@intel.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Wed, 2 Feb 2022 21:20:32 -0800
Message-ID: <CANn89iJAkBXdmnU4FTO3MU2T+PxqkhFxKUpvp-q2uODurT6Wxw@mail.gmail.com>
Subject: Re: [PATCH net-next 09/15] net: increase MAX_SKB_FRAGS
To:     kernel test robot <lkp@intel.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, kbuild-all@lists.01.org,
        netdev <netdev@vger.kernel.org>, Coco Li <lixiaoyan@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 2, 2022 at 9:02 PM kernel test robot <lkp@intel.com> wrote:
>
> Hi Eric,
>
> I love your patch! Yet something to improve:
>
> [auto build test ERROR on net-next/master]
>
> url:    https://github.com/0day-ci/linux/commits/Eric-Dumazet/tcp-BIG-TCP-implementation/20220203-095336
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git 52dae93f3bad842c6d585700460a0dea4d70e096
> config: arc-randconfig-r043-20220130 (https://download.01.org/0day-ci/archive/20220203/202202031206.1nNLT568-lkp@intel.com/config)
> compiler: arc-elf-gcc (GCC) 11.2.0
> reproduce (this is a W=1 build):
>         wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
>         chmod +x ~/bin/make.cross
>         # https://github.com/0day-ci/linux/commit/64ec6b0260be94b2ed90ee6d139591bdbd49c82d
>         git remote add linux-review https://github.com/0day-ci/linux
>         git fetch --no-tags linux-review Eric-Dumazet/tcp-BIG-TCP-implementation/20220203-095336
>         git checkout 64ec6b0260be94b2ed90ee6d139591bdbd49c82d
>         # save the config file to linux build tree
>         mkdir build_dir
>         COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-11.2.0 make.cross O=build_dir ARCH=arc SHELL=/bin/bash kernel/bpf/
>
> If you fix the issue, kindly add following tag as appropriate
> Reported-by: kernel test robot <lkp@intel.com>
>
> All errors (new ones prefixed by >>):
>
>    In file included from include/linux/container_of.h:5,
>                     from include/linux/list.h:5,
>                     from include/linux/rculist.h:10,
>                     from include/linux/pid.h:5,
>                     from include/linux/sched.h:14,
>                     from include/linux/ptrace.h:6,
>                     from include/uapi/asm-generic/bpf_perf_event.h:4,
>                     from ./arch/arc/include/generated/uapi/asm/bpf_perf_event.h:1,
>                     from include/uapi/linux/bpf_perf_event.h:11,
>                     from kernel/bpf/btf.c:6:
> >> include/linux/build_bug.h:78:41: error: static assertion failed: "BITS_PER_LONG >= NR_MSG_FRAG_IDS"
>       78 | #define __static_assert(expr, msg, ...) _Static_assert(expr, msg)
>          |                                         ^~~~~~~~~~~~~~
>    include/linux/build_bug.h:77:34: note: in expansion of macro '__static_assert'
>       77 | #define static_assert(expr, ...) __static_assert(expr, ##__VA_ARGS__, #expr)
>          |                                  ^~~~~~~~~~~~~~~
>    include/linux/skmsg.h:41:1: note: in expansion of macro 'static_assert'
>       41 | static_assert(BITS_PER_LONG >= NR_MSG_FRAG_IDS);

Not clear why we have this assertion. Do we use a bitmap in an
"unsigned long" in skmsg ?

We could still use the old 17 limit for 32bit arches/builds.

>          | ^~~~~~~~~~~~~
>    kernel/bpf/btf.c: In function 'btf_seq_show':
>    kernel/bpf/btf.c:6049:29: warning: function 'btf_seq_show' might be a candidate for 'gnu_printf' format attribute [-Wsuggest-attribute=format]
>     6049 |         seq_vprintf((struct seq_file *)show->target, fmt, args);
>          |                             ^~~~~~~~
>    kernel/bpf/btf.c: In function 'btf_snprintf_show':
>    kernel/bpf/btf.c:6086:9: warning: function 'btf_snprintf_show' might be a candidate for 'gnu_printf' format attribute [-Wsuggest-attribute=format]
>     6086 |         len = vsnprintf(show->target, ssnprintf->len_left, fmt, args);
>          |         ^~~
>
>
> vim +78 include/linux/build_bug.h
>
> bc6245e5efd70c4 Ian Abbott       2017-07-10  60
> 6bab69c65013bed Rasmus Villemoes 2019-03-07  61  /**
> 6bab69c65013bed Rasmus Villemoes 2019-03-07  62   * static_assert - check integer constant expression at build time
> 6bab69c65013bed Rasmus Villemoes 2019-03-07  63   *
> 6bab69c65013bed Rasmus Villemoes 2019-03-07  64   * static_assert() is a wrapper for the C11 _Static_assert, with a
> 6bab69c65013bed Rasmus Villemoes 2019-03-07  65   * little macro magic to make the message optional (defaulting to the
> 6bab69c65013bed Rasmus Villemoes 2019-03-07  66   * stringification of the tested expression).
> 6bab69c65013bed Rasmus Villemoes 2019-03-07  67   *
> 6bab69c65013bed Rasmus Villemoes 2019-03-07  68   * Contrary to BUILD_BUG_ON(), static_assert() can be used at global
> 6bab69c65013bed Rasmus Villemoes 2019-03-07  69   * scope, but requires the expression to be an integer constant
> 6bab69c65013bed Rasmus Villemoes 2019-03-07  70   * expression (i.e., it is not enough that __builtin_constant_p() is
> 6bab69c65013bed Rasmus Villemoes 2019-03-07  71   * true for expr).
> 6bab69c65013bed Rasmus Villemoes 2019-03-07  72   *
> 6bab69c65013bed Rasmus Villemoes 2019-03-07  73   * Also note that BUILD_BUG_ON() fails the build if the condition is
> 6bab69c65013bed Rasmus Villemoes 2019-03-07  74   * true, while static_assert() fails the build if the expression is
> 6bab69c65013bed Rasmus Villemoes 2019-03-07  75   * false.
> 6bab69c65013bed Rasmus Villemoes 2019-03-07  76   */
> 6bab69c65013bed Rasmus Villemoes 2019-03-07  77  #define static_assert(expr, ...) __static_assert(expr, ##__VA_ARGS__, #expr)
> 6bab69c65013bed Rasmus Villemoes 2019-03-07 @78  #define __static_assert(expr, msg, ...) _Static_assert(expr, msg)
> 6bab69c65013bed Rasmus Villemoes 2019-03-07  79
>
> ---
> 0-DAY CI Kernel Test Service, Intel Corporation
> https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
