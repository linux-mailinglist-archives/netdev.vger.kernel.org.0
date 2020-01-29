Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C379114C54A
	for <lists+netdev@lfdr.de>; Wed, 29 Jan 2020 05:39:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726620AbgA2EjJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jan 2020 23:39:09 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:56780 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726401AbgA2EjI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jan 2020 23:39:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        Content-Type:In-Reply-To:MIME-Version:Date:Message-ID:From:Cc:References:To:
        Subject:Sender:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=9eFMSk3kiCUa/opxi1hhhRm+z30AIL9ELkBjRpgDmH8=; b=ETMJ+lxnbv1/0PpjOHPJQhHrJ
        2B321fseH1jxkU5+aEt3ZZdf+9dKJUFN4Hc+JwxwFJqCJgA4r7u1PjIegyHafhtp6hn18/0fWi9QH
        PBXG6TpgcZreAubvDGWD9PpEcKig4P0GdONKtxDtwlD+FIEL0PJ1Jg+j+n4vky+5bGMpKpRyDrpk2
        7iGYIOnZiFP7298y/LrM7hYtQ3MHLsgnyMO4iUmFEzN5r5sxB5fgJ4yVUroJuVdNs5Y7+pEgX7KDm
        rr0Byk0px9Zc0t5rIcQhMZs6JUrBVVWlJCPoG2waou3rPK1CPmbg4qbV2ZgAqca0SW0h6/31hiuaO
        Tf/Z8ZTdw==;
Received: from [2601:1c0:6280:3f0:897c:6038:c71d:ecac]
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iwf85-0000gu-2Q; Wed, 29 Jan 2020 04:39:05 +0000
Subject: Re: mmotm 2020-01-28-20-05 uploaded (net/mptcp/subflow.c)
To:     akpm@linux-foundation.org, broonie@kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linux-next@vger.kernel.org, mhocko@suse.cz,
        mm-commits@vger.kernel.org, sfr@canb.auug.org.au,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <20200129040640.6PNuz0vcp%akpm@linux-foundation.org>
Cc:     mptcp@lists.01.org,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <71437ed1-e8b6-83bc-04b2-4c82fb313370@infradead.org>
Date:   Tue, 28 Jan 2020 20:39:03 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200129040640.6PNuz0vcp%akpm@linux-foundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/28/20 8:06 PM, akpm@linux-foundation.org wrote:
> The mm-of-the-moment snapshot 2020-01-28-20-05 has been uploaded to
> 
>    http://www.ozlabs.org/~akpm/mmotm/
> 
> mmotm-readme.txt says
> 
> README for mm-of-the-moment:
> 
> http://www.ozlabs.org/~akpm/mmotm/
> 
> This is a snapshot of my -mm patch queue.  Uploaded at random hopefully
> more than once a week.
> 

Lots of build errors when CONFIG_PROC_FS is not set/enabled:

(truncation of around 500 lines of errors & warnings:)

In file included from ../include/asm-generic/percpu.h:7:0,
                 from ../arch/x86/include/asm/percpu.h:556,
                 from ../arch/x86/include/asm/preempt.h:6,
                 from ../include/linux/preempt.h:78,
                 from ../include/linux/spinlock.h:51,
                 from ../include/linux/seqlock.h:36,
                 from ../include/linux/time.h:6,
                 from ../include/linux/stat.h:19,
                 from ../include/linux/module.h:13,
                 from ../net/mptcp/subflow.c:10:
../net/mptcp/subflow.c: In function ‘mptcp_subflow_create_socket’:
../net/mptcp/subflow.c:624:25: error: ‘struct netns_core’ has no member named ‘sock_inuse’
  this_cpu_add(*net->core.sock_inuse, 1);
                         ^
../include/linux/percpu-defs.h:219:47: note: in definition of macro ‘__verify_pcpu_ptr’
  const void __percpu *__vpp_verify = (typeof((ptr) + 0))NULL; \
                                               ^~~
../include/linux/percpu-defs.h:509:33: note: in expansion of macro ‘__pcpu_size_call’
 #define this_cpu_add(pcp, val)  __pcpu_size_call(this_cpu_add_, pcp, val)
                                 ^~~~~~~~~~~~~~~~
../net/mptcp/subflow.c:624:2: note: in expansion of macro ‘this_cpu_add’
  this_cpu_add(*net->core.sock_inuse, 1);
  ^~~~~~~~~~~~
../net/mptcp/subflow.c:624:25: error: ‘struct netns_core’ has no member named ‘sock_inuse’
  this_cpu_add(*net->core.sock_inuse, 1);
                         ^
../include/linux/percpu-defs.h:376:16: note: in definition of macro ‘__pcpu_size_call’
  switch(sizeof(variable)) {     \
                ^~~~~~~~
../net/mptcp/subflow.c:624:2: note: in expansion of macro ‘this_cpu_add’
  this_cpu_add(*net->core.sock_inuse, 1);
  ^~~~~~~~~~~~
In file included from ../arch/x86/include/asm/preempt.h:6:0,
                 from ../include/linux/preempt.h:78,
                 from ../include/linux/spinlock.h:51,
                 from ../include/linux/seqlock.h:36,
                 from ../include/linux/time.h:6,
                 from ../include/linux/stat.h:19,
                 from ../include/linux/module.h:13,
                 from ../net/mptcp/subflow.c:10:
../net/mptcp/subflow.c:624:25: error: ‘struct netns_core’ has no member named ‘sock_inuse’
  this_cpu_add(*net->core.sock_inuse, 1);
                         ^
../arch/x86/include/asm/percpu.h:129:17: note: in definition of macro ‘percpu_add_op’
  typedef typeof(var) pao_T__;     \
                 ^~~
../include/linux/percpu-defs.h:377:11: note: in expansion of macro ‘this_cpu_add_1’
   case 1: stem##1(variable, __VA_ARGS__);break;  \
           ^~~~
../include/linux/percpu-defs.h:509:33: note: in expansion of macro ‘__pcpu_size_call’
 #define this_cpu_add(pcp, val)  __pcpu_size_call(this_cpu_add_, pcp, val)
                                 ^~~~~~~~~~~~~~~~
../net/mptcp/subflow.c:624:2: note: in expansion of macro ‘this_cpu_add’
  this_cpu_add(*net->core.sock_inuse, 1);
  ^~~~~~~~~~~~
../net/mptcp/subflow.c:624:25: error: ‘struct netns_core’ has no member named ‘sock_inuse’
  this_cpu_add(*net->core.sock_inuse, 1);
                         ^
../arch/x86/include/asm/percpu.h:138:17: note: in definition of macro ‘percpu_add_op’
  switch (sizeof(var)) {      \
                 ^~~
../include/linux/percpu-defs.h:377:11: note: in expansion of macro ‘this_cpu_add_1’
   case 1: stem##1(variable, __VA_ARGS__);break;  \
           ^~~~
../include/linux/percpu-defs.h:509:33: note: in expansion of macro ‘__pcpu_size_call’
 #define this_cpu_add(pcp, val)  __pcpu_size_call(this_cpu_add_, pcp, val)
                                 ^~~~~~~~~~~~~~~~
../net/mptcp/subflow.c:624:2: note: in expansion of macro ‘this_cpu_add’
  this_cpu_add(*net->core.sock_inuse, 1);
  ^~~~~~~~~~~~
../net/mptcp/subflow.c:624:25: error: ‘struct netns_core’ has no member named ‘sock_inuse’
  this_cpu_add(*net->core.sock_inuse, 1);
                         ^
../arch/x86/include/asm/percpu.h:141:45: note: in definition of macro ‘percpu_add_op’
    asm qual ("incb "__percpu_arg(0) : "+m" (var)); \
                                             ^~~
../include/linux/percpu-defs.h:377:11: note: in expansion of macro ‘this_cpu_add_1’
   case 1: stem##1(variable, __VA_ARGS__);break;  \
           ^~~~
../include/linux/percpu-defs.h:509:33: note: in expansion of macro ‘__pcpu_size_call’
 #define this_cpu_add(pcp, val)  __pcpu_size_call(this_cpu_add_, pcp, val)
                                 ^~~~~~~~~~~~~~~~
../net/mptcp/subflow.c:624:2: note: in expansion of macro ‘this_cpu_add’
  this_cpu_add(*net->core.sock_inuse, 1);
  ^~~~~~~~~~~~
../net/mptcp/subflow.c:624:25: error: ‘struct netns_core’ has no member named ‘sock_inuse’
  this_cpu_add(*net->core.sock_inuse, 1);
                         ^
../arch/x86/include/asm/percpu.h:143:45: note: in definition of macro ‘percpu_add_op’
    asm qual ("decb "__percpu_arg(0) : "+m" (var)); \
                                             ^~~
../include/linux/percpu-defs.h:377:11: note: in expansion of macro ‘this_cpu_add_1’
   case 1: stem##1(variable, __VA_ARGS__);break;  \
           ^~~~
../include/linux/percpu-defs.h:509:33: note: in expansion of macro ‘__pcpu_size_call’
 #define this_cpu_add(pcp, val)  __pcpu_size_call(this_cpu_add_, pcp, val)
                                 ^~~~~~~~~~~~~~~~
../net/mptcp/subflow.c:624:2: note: in expansion of macro ‘this_cpu_add’
  this_cpu_add(*net->core.sock_inuse, 1);
  ^~~~~~~~~~~~
../net/mptcp/subflow.c:624:25: error: ‘struct netns_core’ has no member named ‘sock_inuse’
  this_cpu_add(*net->core.sock_inuse, 1);
                         ^




-- 
~Randy
Reported-by: Randy Dunlap <rdunlap@infradead.org>
