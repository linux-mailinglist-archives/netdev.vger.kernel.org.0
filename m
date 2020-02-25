Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DFB5416C1C8
	for <lists+netdev@lfdr.de>; Tue, 25 Feb 2020 14:10:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730324AbgBYNKv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Feb 2020 08:10:51 -0500
Received: from mail-pf1-f193.google.com ([209.85.210.193]:37149 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725788AbgBYNKu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Feb 2020 08:10:50 -0500
Received: by mail-pf1-f193.google.com with SMTP id p14so7168581pfn.4;
        Tue, 25 Feb 2020 05:10:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=NdIi3p1G+pK48BoZW2xQ7s8pQgL985dQmFMs11pogIQ=;
        b=SqRWDHUPS48bv05ymWTtEWbtaU6DtthfFLOZ1wsFsdOFONm1ay26GExnGv9Tl345Tl
         HVuFnYYTPNXOPMDICvlrv62A73Uw8gGvceNrRTsyT9bENOEKnCGiBRiJD4rImS8VRZPA
         VK19KMOxAJIclJoijNvCVwyIpuWLeQDqg6mPEGyPks+595xkaytNoCB6mBqGijGKkDvY
         Yv7a6pEVGsPGKn1a4KH6Y52oEjKVSZeJfaQmuuv5yfStcW+GPvEalRurj+W8FJ/gXbHo
         eXwEsLj+M9o/BPp7PtNkAg9zrZmlkSjdythQnWvnPPWKKSlXzpf5K91Z8mJ4NP8URcUP
         FKMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=NdIi3p1G+pK48BoZW2xQ7s8pQgL985dQmFMs11pogIQ=;
        b=Gw2HnRY90LtjDBLhqEURiUyYNhj2bQz8ORYVAIPVtscT1KSkLK1qSNxsN/80CXLt7K
         VvX1eudM5ll/4Q+CdGXNyPTGFzLg677gPzYfWDAqj8r2zU0Lx2N7RgFmnMeAAOPuwX/i
         1IxgB2vT/7lBPg01x3NlJeB4ue8gFix1u0yisto6Z5UVYlcrLqRvit1pv9C8TpJzh2Jl
         a3bi9Xqns8J6/nNjvmQ3pb3oMySo8nnR6WBNgPNNvn4XeN/kaUgJ5UvimQd0ysyzZyGf
         IcJAtVW5SaEUQn1ubt3Vta97wr5wXLimgRYtjz8gxkqT839mb6O/uAYbEkIh837HNieS
         3niA==
X-Gm-Message-State: APjAAAURgq0d9V0cg8b7Y3l8+AQmWO5gHAiuOMswAPBtMIxU2h8UrR6x
        okZ6bOW0fau0OywWKD2hWVQ=
X-Google-Smtp-Source: APXvYqym5rY6K9md/Bot2AiUakY1J+acKKuoxOz41x81VdMxJZeV6UGEPQhMOPZsxtH1Co4cyMHbnQ==
X-Received: by 2002:a63:1926:: with SMTP id z38mr56722083pgl.303.1582636250052;
        Tue, 25 Feb 2020 05:10:50 -0800 (PST)
Received: from workstation-portable ([103.87.56.186])
        by smtp.gmail.com with ESMTPSA id d1sm16084363pgi.63.2020.02.25.05.10.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Feb 2020 05:10:49 -0800 (PST)
Date:   Tue, 25 Feb 2020 18:40:41 +0530
From:   Amol Grover <frextrite@gmail.com>
To:     David Miller <davem@davemloft.net>
Cc:     kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        joel@joelfernandes.org, madhuparnabhowmik10@gmail.com,
        paulmck@kernel.org
Subject: Re: [PATCH 2/2] ipmr: Add lockdep expression to ipmr_for_each_table
 macro
Message-ID: <20200225131041.GA8660@workstation-portable>
References: <20200222063835.14328-1-frextrite@gmail.com>
 <20200222063835.14328-2-frextrite@gmail.com>
 <20200224.131801.2179562246092982372.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200224.131801.2179562246092982372.davem@davemloft.net>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 24, 2020 at 01:18:01PM -0800, David Miller wrote:
> From: Amol Grover <frextrite@gmail.com>
> Date: Sat, 22 Feb 2020 12:08:36 +0530
> 
> > ipmr_for_each_table() uses list_for_each_entry_rcu() for
> > traversing outside of an RCU read-side critical section but
> > under the protection of pernet_ops_rwsem. Hence add the
> > corresponding lockdep expression to silence the following
> > false-positive warning at boot:
> > 
> > [    0.645292] =============================
> > [    0.645294] WARNING: suspicious RCU usage
> > [    0.645296] 5.5.4-stable #17 Not tainted
> > [    0.645297] -----------------------------
> > [    0.645299] net/ipv4/ipmr.c:136 RCU-list traversed in non-reader section!!
> > 
> > Signed-off-by: Amol Grover <frextrite@gmail.com>
> 
> This patch series causes build problems, please fix and resubmit the entire
> series:
> 
> [davem@localhost net-next]$ make net/ipv4/ipmr.o 
>   CALL    scripts/checksyscalls.sh
>   CALL    scripts/atomic/check-atomics.sh
>   DESCEND  objtool
>   CC      net/ipv4/ipmr.o
> In file included from ./include/linux/rculist.h:11,
>                  from ./include/linux/pid.h:5,
>                  from ./include/linux/sched.h:14,
>                  from ./include/linux/uaccess.h:5,
>                  from net/ipv4/ipmr.c:24:
> net/ipv4/ipmr.c: In function ‘ipmr_get_table’:
> ./include/linux/rculist.h:63:25: warning: suggest parentheses around ‘&&’ within ‘||’ [-Wparentheses]
>   RCU_LOCKDEP_WARN(!cond && !rcu_read_lock_any_held(),  \
> ./include/linux/rcupdate.h:263:52: note: in definition of macro ‘RCU_LOCKDEP_WARN’
>    if (debug_lockdep_rcu_enabled() && !__warned && (c)) { \
>                                                     ^
> ./include/linux/rculist.h:381:7: note: in expansion of macro ‘__list_check_rcu’
>   for (__list_check_rcu(dummy, ## cond, 0),   \
>        ^~~~~~~~~~~~~~~~
> net/ipv4/ipmr.c:113:2: note: in expansion of macro ‘list_for_each_entry_rcu’
>   list_for_each_entry_rcu(mrt, &net->ipv4.mr_tables, list, \
>   ^~~~~~~~~~~~~~~~~~~~~~~
> net/ipv4/ipmr.c:138:2: note: in expansion of macro ‘ipmr_for_each_table’
>   ipmr_for_each_table(mrt, net) {
>   ^~~~~~~~~~~~~~~~~~~

This is a build warning due to incorrect operator precedence in
__list_check_rcu macro. This has already been reported and the patch
submitted [1]. Infact the patch is currently queued for v5.7.

[1] https://lore.kernel.org/patchwork/patch/1181886/

Thanks
Amol
