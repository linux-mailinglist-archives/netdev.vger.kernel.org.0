Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFFA11C1719
	for <lists+netdev@lfdr.de>; Fri,  1 May 2020 16:10:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731067AbgEAN5c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 May 2020 09:57:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729683AbgEAN51 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 May 2020 09:57:27 -0400
Received: from mail-yb1-xb43.google.com (mail-yb1-xb43.google.com [IPv6:2607:f8b0:4864:20::b43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82261C061A0C
        for <netdev@vger.kernel.org>; Fri,  1 May 2020 06:57:27 -0700 (PDT)
Received: by mail-yb1-xb43.google.com with SMTP id b17so4968188ybq.13
        for <netdev@vger.kernel.org>; Fri, 01 May 2020 06:57:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Yycko2yGAA2WQc/maivh8jAW5wBECs8ae58+Ih2oBsc=;
        b=TgGZIGc4BIF3iLFN/L8luUjFW/q6Boya7dZ4T5Jqm+UmKLPLuutkvSht9HriOUd29U
         bqeLc4KpLuqvoekBySi8ZOGR05kTy8kyshxvSLquKcqJyuaClGZeYd1L4NYf3ed0Q2gI
         yirmQ2QMqoAqXThBcZqLkAJDQabNUnY7fMw8UyGJBa12y02cgpNI5PgIjLhTKQYaCigq
         TNs4W1KcxdX1AV1+gGUCVmYKmphRhJRd5LFE7t3ABT0ACvy7ATE/nQFboj0G73rF36Ea
         do8cRNmdqzM5/s10o9fZRM1RBUVBoTQWSkTeCRTCHgZJbd24M5u1bNHzshaSFIvmS1G8
         GkjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Yycko2yGAA2WQc/maivh8jAW5wBECs8ae58+Ih2oBsc=;
        b=eNzXXJQkWOuuiICTW66oE5uxiU+9A0kmSrlJT2OEfM8GIQ0pT/7L8NNCyKNLWRlqZ+
         cWkiktX5G/u1tTYfPTCOr/nCXjT39YZJijy2JfUiOLsVnVt+EAm6NiODvDnG0kGdo8QR
         HjR5T9ShO/0ng0QITqk4Jc5KaBuv8HzFLFwafsHxx3imqcfZ5usVAylyF14YASiBIWtq
         ImIfBjtwp33aoIIlZAfJkOPlrkZiNe1lFSu0pzsPVgEZew+Tkx2rpUNV2Q+nEv4m4vxS
         /hNNNFeuP/3sCReF0CG3P9BHzvP8ou5/j1sE/1C70kf1jxXyp1YYH9IkITgmlV1wdANE
         yUxQ==
X-Gm-Message-State: AGi0PubL0OKphXIY7Vgcw5gneusM++JoIGCaDfZ4/umlLQ1l8l3mxjuA
        0b9JLorGMemP9jglN3C6siWemXdqKQFlvEB/T8hql1wh
X-Google-Smtp-Source: APiQypIaotdoOeCL99heZXMw1dxNoGYF3qbubqrD2CbDsAid8KW0/0TbOrY3/lyhOhPwor3ySJ8e4QM5bmqlfalM0vU=
X-Received: by 2002:a25:71d5:: with SMTP id m204mr6972333ybc.101.1588341446442;
 Fri, 01 May 2020 06:57:26 -0700 (PDT)
MIME-Version: 1.0
References: <20200501055144.24346-1-edumazet@google.com> <202005011815.an8L9pEE%lkp@intel.com>
In-Reply-To: <202005011815.an8L9pEE%lkp@intel.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Fri, 1 May 2020 06:57:14 -0700
Message-ID: <CANn89i+5Qe1qC-YaxLFRWpYuHnL7ehaaig0WWmWuxGOUOOe0Aw@mail.gmail.com>
Subject: Re: [PATCH net-next] net_sched: sch_fq: add horizon attribute
To:     kbuild test robot <lkp@intel.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Willem de Bruijn <willemb@google.com>,
        kbuild-all@lists.01.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 1, 2020 at 3:43 AM kbuild test robot <lkp@intel.com> wrote:
>
> Hi Eric,
>
> I love your patch! Perhaps something to improve:
>
> [auto build test WARNING on net-next/master]
> [also build test WARNING on net/master linus/master v5.7-rc3 next-20200430]
> [if your patch is applied to the wrong git tree, please drop us a note to help
> improve the system. BTW, we also suggest to use '--base' option to specify the
> base tree in git format-patch, please see https://stackoverflow.com/a/37406982]
>
> url:    https://github.com/0day-ci/linux/commits/Eric-Dumazet/net_sched-sch_fq-add-horizon-attribute/20200501-135537
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git 37ecb5b8b8cd3156e739fd1c56a8e3842b72ebad
> config: i386-allmodconfig (attached as .config)
> compiler: gcc-7 (Ubuntu 7.5.0-6ubuntu2) 7.5.0
> reproduce:
>         # save the attached .config to linux build tree
>         make ARCH=i386
>
> If you fix the issue, kindly add following tag as appropriate
> Reported-by: kbuild test robot <lkp@intel.com>
>
> All warnings (new ones prefixed by >>):
>
>    net/sched/sch_fq.c: In function 'fq_init':
> >> net/sched/sch_fq.c:938:18: warning: integer overflow in expression [-Woverflow]
>      q->horizon = 10 * NSEC_PER_SEC; /* 10 seconds */

Thanks, I will use 10ULL in v2



>                      ^
>
> vim +938 net/sched/sch_fq.c
>
>    913
>    914  static int fq_init(struct Qdisc *sch, struct nlattr *opt,
>    915                     struct netlink_ext_ack *extack)
>    916  {
>    917          struct fq_sched_data *q = qdisc_priv(sch);
>    918          int err;
>    919
>    920          sch->limit              = 10000;
>    921          q->flow_plimit          = 100;
>    922          q->quantum              = 2 * psched_mtu(qdisc_dev(sch));
>    923          q->initial_quantum      = 10 * psched_mtu(qdisc_dev(sch));
>    924          q->flow_refill_delay    = msecs_to_jiffies(40);
>    925          q->flow_max_rate        = ~0UL;
>    926          q->time_next_delayed_flow = ~0ULL;
>    927          q->rate_enable          = 1;
>    928          q->new_flows.first      = NULL;
>    929          q->old_flows.first      = NULL;
>    930          q->delayed              = RB_ROOT;
>    931          q->fq_root              = NULL;
>    932          q->fq_trees_log         = ilog2(1024);
>    933          q->orphan_mask          = 1024 - 1;
>    934          q->low_rate_threshold   = 550000 / 8;
>    935
>    936          q->timer_slack = 10 * NSEC_PER_USEC; /* 10 usec of hrtimer slack */
>    937
>  > 938          q->horizon = 10 * NSEC_PER_SEC; /* 10 seconds */
>    939          q->horizon_drop = 1; /* by default, drop packets beyond horizon */
>    940
>    941          /* Default ce_threshold of 4294 seconds */
>    942          q->ce_threshold         = (u64)NSEC_PER_USEC * ~0U;
>    943
>    944          qdisc_watchdog_init_clockid(&q->watchdog, sch, CLOCK_MONOTONIC);
>    945
>    946          if (opt)
>    947                  err = fq_change(sch, opt, extack);
>    948          else
>    949                  err = fq_resize(sch, q->fq_trees_log);
>    950
>    951          return err;
>    952  }
>    953
>
> ---
> 0-DAY CI Kernel Test Service, Intel Corporation
> https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
