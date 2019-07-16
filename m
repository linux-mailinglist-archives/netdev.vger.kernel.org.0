Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 772886AEA3
	for <lists+netdev@lfdr.de>; Tue, 16 Jul 2019 20:30:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388382AbfGPSac (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Jul 2019 14:30:32 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:9014 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725926AbfGPSac (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Jul 2019 14:30:32 -0400
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x6GIM497023335;
        Tue, 16 Jul 2019 14:22:42 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2tsjhm3684-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 16 Jul 2019 14:22:42 -0400
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.27/8.16.0.27) with SMTP id x6GIMfN2024987;
        Tue, 16 Jul 2019 14:22:41 -0400
Received: from ppma01wdc.us.ibm.com (fd.55.37a9.ip4.static.sl-reverse.com [169.55.85.253])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2tsjhm366p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 16 Jul 2019 14:22:41 -0400
Received: from pps.filterd (ppma01wdc.us.ibm.com [127.0.0.1])
        by ppma01wdc.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id x6GIEnSN000902;
        Tue, 16 Jul 2019 18:22:39 GMT
Received: from b01cxnp23032.gho.pok.ibm.com (b01cxnp23032.gho.pok.ibm.com [9.57.198.27])
        by ppma01wdc.us.ibm.com with ESMTP id 2tq6x614my-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 16 Jul 2019 18:22:39 +0000
Received: from b01ledav003.gho.pok.ibm.com (b01ledav003.gho.pok.ibm.com [9.57.199.108])
        by b01cxnp23032.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x6GIMcsr49807648
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 16 Jul 2019 18:22:38 GMT
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1EC40B206C;
        Tue, 16 Jul 2019 18:22:38 +0000 (GMT)
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AF59AB2067;
        Tue, 16 Jul 2019 18:22:37 +0000 (GMT)
Received: from paulmck-ThinkPad-W541 (unknown [9.80.225.134])
        by b01ledav003.gho.pok.ibm.com (Postfix) with ESMTP;
        Tue, 16 Jul 2019 18:22:37 +0000 (GMT)
Received: by paulmck-ThinkPad-W541 (Postfix, from userid 1000)
        id B6C1816C8F09; Tue, 16 Jul 2019 11:22:37 -0700 (PDT)
Date:   Tue, 16 Jul 2019 11:22:37 -0700
From:   "Paul E. McKenney" <paulmck@linux.ibm.com>
To:     "Joel Fernandes (Google)" <joel@joelfernandes.org>
Cc:     linux-kernel@vger.kernel.org,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Borislav Petkov <bp@alien8.de>, c0d1n61at3@gmail.com,
        "David S. Miller" <davem@davemloft.net>, edumazet@google.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Josh Triplett <josh@joshtriplett.org>, keescook@chromium.org,
        kernel-hardening@lists.openwall.com, kernel-team@android.com,
        Lai Jiangshan <jiangshanlai@gmail.com>,
        Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-pm@vger.kernel.org,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        neilb@suse.com, netdev@vger.kernel.org,
        Oleg Nesterov <oleg@redhat.com>, Pavel Machek <pavel@ucw.cz>,
        peterz@infradead.org, "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Rasmus Villemoes <rasmus.villemoes@prevas.dk>,
        rcu@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
        Tejun Heo <tj@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, will@kernel.org,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>
Subject: Re: [PATCH v2 2/9] rcu: Add support for consolidated-RCU reader
 checking
Message-ID: <20190716182237.GA22819@linux.ibm.com>
Reply-To: paulmck@linux.ibm.com
References: <20190712170024.111093-1-joel@joelfernandes.org>
 <20190712170024.111093-3-joel@joelfernandes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190712170024.111093-3-joel@joelfernandes.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-16_04:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1907160225
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 12, 2019 at 01:00:17PM -0400, Joel Fernandes (Google) wrote:
> This patch adds support for checking RCU reader sections in list
> traversal macros. Optionally, if the list macro is called under SRCU or
> other lock/mutex protection, then appropriate lockdep expressions can be
> passed to make the checks pass.
> 
> Existing list_for_each_entry_rcu() invocations don't need to pass the
> optional fourth argument (cond) unless they are under some non-RCU
> protection and needs to make lockdep check pass.
> 
> Signed-off-by: Joel Fernandes (Google) <joel@joelfernandes.org>

If you fold in the checks for extra parameters, I will take this
one and also 1/9.

							Thanx, Paul

> ---
>  include/linux/rculist.h  | 28 +++++++++++++++++++++++-----
>  include/linux/rcupdate.h |  7 +++++++
>  kernel/rcu/Kconfig.debug | 11 +++++++++++
>  kernel/rcu/update.c      | 14 ++++++++++++++
>  4 files changed, 55 insertions(+), 5 deletions(-)
> 
> diff --git a/include/linux/rculist.h b/include/linux/rculist.h
> index e91ec9ddcd30..1048160625bb 100644
> --- a/include/linux/rculist.h
> +++ b/include/linux/rculist.h
> @@ -40,6 +40,20 @@ static inline void INIT_LIST_HEAD_RCU(struct list_head *list)
>   */
>  #define list_next_rcu(list)	(*((struct list_head __rcu **)(&(list)->next)))
>  
> +/*
> + * Check during list traversal that we are within an RCU reader
> + */
> +
> +#ifdef CONFIG_PROVE_RCU_LIST
> +#define __list_check_rcu(dummy, cond, ...)				\
> +	({								\
> +	RCU_LOCKDEP_WARN(!cond && !rcu_read_lock_any_held(),		\
> +			 "RCU-list traversed in non-reader section!");	\
> +	 })
> +#else
> +#define __list_check_rcu(dummy, cond, ...) ({})
> +#endif
> +
>  /*
>   * Insert a new entry between two known consecutive entries.
>   *
> @@ -343,14 +357,16 @@ static inline void list_splice_tail_init_rcu(struct list_head *list,
>   * @pos:	the type * to use as a loop cursor.
>   * @head:	the head for your list.
>   * @member:	the name of the list_head within the struct.
> + * @cond:	optional lockdep expression if called from non-RCU protection.
>   *
>   * This list-traversal primitive may safely run concurrently with
>   * the _rcu list-mutation primitives such as list_add_rcu()
>   * as long as the traversal is guarded by rcu_read_lock().
>   */
> -#define list_for_each_entry_rcu(pos, head, member) \
> -	for (pos = list_entry_rcu((head)->next, typeof(*pos), member); \
> -		&pos->member != (head); \
> +#define list_for_each_entry_rcu(pos, head, member, cond...)		\
> +	for (__list_check_rcu(dummy, ## cond, 0),			\
> +	     pos = list_entry_rcu((head)->next, typeof(*pos), member);	\
> +		&pos->member != (head);					\
>  		pos = list_entry_rcu(pos->member.next, typeof(*pos), member))
>  
>  /**
> @@ -616,13 +632,15 @@ static inline void hlist_add_behind_rcu(struct hlist_node *n,
>   * @pos:	the type * to use as a loop cursor.
>   * @head:	the head for your list.
>   * @member:	the name of the hlist_node within the struct.
> + * @cond:	optional lockdep expression if called from non-RCU protection.
>   *
>   * This list-traversal primitive may safely run concurrently with
>   * the _rcu list-mutation primitives such as hlist_add_head_rcu()
>   * as long as the traversal is guarded by rcu_read_lock().
>   */
> -#define hlist_for_each_entry_rcu(pos, head, member)			\
> -	for (pos = hlist_entry_safe (rcu_dereference_raw(hlist_first_rcu(head)),\
> +#define hlist_for_each_entry_rcu(pos, head, member, cond...)		\
> +	for (__list_check_rcu(dummy, ## cond, 0),			\
> +	     pos = hlist_entry_safe (rcu_dereference_raw(hlist_first_rcu(head)),\
>  			typeof(*(pos)), member);			\
>  		pos;							\
>  		pos = hlist_entry_safe(rcu_dereference_raw(hlist_next_rcu(\
> diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
> index 922bb6848813..712b464ab960 100644
> --- a/include/linux/rcupdate.h
> +++ b/include/linux/rcupdate.h
> @@ -223,6 +223,7 @@ int debug_lockdep_rcu_enabled(void);
>  int rcu_read_lock_held(void);
>  int rcu_read_lock_bh_held(void);
>  int rcu_read_lock_sched_held(void);
> +int rcu_read_lock_any_held(void);
>  
>  #else /* #ifdef CONFIG_DEBUG_LOCK_ALLOC */
>  
> @@ -243,6 +244,12 @@ static inline int rcu_read_lock_sched_held(void)
>  {
>  	return !preemptible();
>  }
> +
> +static inline int rcu_read_lock_any_held(void)
> +{
> +	return !preemptible();
> +}
> +
>  #endif /* #else #ifdef CONFIG_DEBUG_LOCK_ALLOC */
>  
>  #ifdef CONFIG_PROVE_RCU
> diff --git a/kernel/rcu/Kconfig.debug b/kernel/rcu/Kconfig.debug
> index 0ec7d1d33a14..b20d0e2903d1 100644
> --- a/kernel/rcu/Kconfig.debug
> +++ b/kernel/rcu/Kconfig.debug
> @@ -7,6 +7,17 @@ menu "RCU Debugging"
>  config PROVE_RCU
>  	def_bool PROVE_LOCKING
>  
> +config PROVE_RCU_LIST
> +	bool "RCU list lockdep debugging"
> +	depends on PROVE_RCU
> +	default n
> +	help
> +	  Enable RCU lockdep checking for list usages. By default it is
> +	  turned off since there are several list RCU users that still
> +	  need to be converted to pass a lockdep expression. To prevent
> +	  false-positive splats, we keep it default disabled but once all
> +	  users are converted, we can remove this config option.
> +
>  config TORTURE_TEST
>  	tristate
>  	default n
> diff --git a/kernel/rcu/update.c b/kernel/rcu/update.c
> index bb961cd89e76..0cc7be0fb6b5 100644
> --- a/kernel/rcu/update.c
> +++ b/kernel/rcu/update.c
> @@ -294,6 +294,20 @@ int rcu_read_lock_bh_held(void)
>  }
>  EXPORT_SYMBOL_GPL(rcu_read_lock_bh_held);
>  
> +int rcu_read_lock_any_held(void)
> +{
> +	if (!debug_lockdep_rcu_enabled())
> +		return 1;
> +	if (!rcu_is_watching())
> +		return 0;
> +	if (!rcu_lockdep_current_cpu_online())
> +		return 0;
> +	if (lock_is_held(&rcu_lock_map) || lock_is_held(&rcu_sched_lock_map))
> +		return 1;
> +	return !preemptible();
> +}
> +EXPORT_SYMBOL_GPL(rcu_read_lock_any_held);
> +
>  #endif /* #ifdef CONFIG_DEBUG_LOCK_ALLOC */
>  
>  /**
> -- 
> 2.22.0.510.g264f2c817a-goog
> 
