Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BF98B6AEE1
	for <lists+netdev@lfdr.de>; Tue, 16 Jul 2019 20:42:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388443AbfGPSmc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Jul 2019 14:42:32 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:39280 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728121AbfGPSmb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Jul 2019 14:42:31 -0400
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x6GIbOPh044018;
        Tue, 16 Jul 2019 14:40:29 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2tshrse3rr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 16 Jul 2019 14:40:29 -0400
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.27/8.16.0.27) with SMTP id x6GIbtZL046391;
        Tue, 16 Jul 2019 14:40:28 -0400
Received: from ppma04dal.us.ibm.com (7a.29.35a9.ip4.static.sl-reverse.com [169.53.41.122])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2tshrse3qn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 16 Jul 2019 14:40:28 -0400
Received: from pps.filterd (ppma04dal.us.ibm.com [127.0.0.1])
        by ppma04dal.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id x6GIdj1Z007954;
        Tue, 16 Jul 2019 18:40:26 GMT
Received: from b01cxnp22035.gho.pok.ibm.com (b01cxnp22035.gho.pok.ibm.com [9.57.198.25])
        by ppma04dal.us.ibm.com with ESMTP id 2trtmr1hct-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 16 Jul 2019 18:40:26 +0000
Received: from b01ledav003.gho.pok.ibm.com (b01ledav003.gho.pok.ibm.com [9.57.199.108])
        by b01cxnp22035.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x6GIePWI32375170
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 16 Jul 2019 18:40:25 GMT
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CF0C7B2066;
        Tue, 16 Jul 2019 18:40:25 +0000 (GMT)
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 77DC2B2072;
        Tue, 16 Jul 2019 18:40:25 +0000 (GMT)
Received: from paulmck-ThinkPad-W541 (unknown [9.80.225.134])
        by b01ledav003.gho.pok.ibm.com (Postfix) with ESMTP;
        Tue, 16 Jul 2019 18:40:25 +0000 (GMT)
Received: by paulmck-ThinkPad-W541 (Postfix, from userid 1000)
        id 8132716C9989; Tue, 16 Jul 2019 11:40:25 -0700 (PDT)
Date:   Tue, 16 Jul 2019 11:40:25 -0700
From:   "Paul E. McKenney" <paulmck@linux.ibm.com>
To:     "Joel Fernandes (Google)" <joel@joelfernandes.org>
Cc:     linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Borislav Petkov <bp@alien8.de>, c0d1n61at3@gmail.com,
        "David S. Miller" <davem@davemloft.net>, edumazet@google.com,
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
Subject: Re: [PATCH 5/9] driver/core: Convert to use built-in RCU list
 checking (v1)
Message-ID: <20190716184025.GG14271@linux.ibm.com>
Reply-To: paulmck@linux.ibm.com
References: <20190715143705.117908-1-joel@joelfernandes.org>
 <20190715143705.117908-6-joel@joelfernandes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190715143705.117908-6-joel@joelfernandes.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-16_04:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1907160228
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 15, 2019 at 10:37:01AM -0400, Joel Fernandes (Google) wrote:
> list_for_each_entry_rcu has built-in RCU and lock checking. Make use of
> it in driver core.
> 
> Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Signed-off-by: Joel Fernandes (Google) <joel@joelfernandes.org>

This one looks ready.

							Thanx, Paul

> ---
>  drivers/base/base.h          |  1 +
>  drivers/base/core.c          | 10 ++++++++++
>  drivers/base/power/runtime.c | 15 ++++++++++-----
>  3 files changed, 21 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/base/base.h b/drivers/base/base.h
> index b405436ee28e..0d32544b6f91 100644
> --- a/drivers/base/base.h
> +++ b/drivers/base/base.h
> @@ -165,6 +165,7 @@ static inline int devtmpfs_init(void) { return 0; }
>  /* Device links support */
>  extern int device_links_read_lock(void);
>  extern void device_links_read_unlock(int idx);
> +extern int device_links_read_lock_held(void);
>  extern int device_links_check_suppliers(struct device *dev);
>  extern void device_links_driver_bound(struct device *dev);
>  extern void device_links_driver_cleanup(struct device *dev);
> diff --git a/drivers/base/core.c b/drivers/base/core.c
> index da84a73f2ba6..85e82f38717f 100644
> --- a/drivers/base/core.c
> +++ b/drivers/base/core.c
> @@ -68,6 +68,11 @@ void device_links_read_unlock(int idx)
>  {
>  	srcu_read_unlock(&device_links_srcu, idx);
>  }
> +
> +int device_links_read_lock_held(void)
> +{
> +	return srcu_read_lock_held(&device_links_srcu);
> +}
>  #else /* !CONFIG_SRCU */
>  static DECLARE_RWSEM(device_links_lock);
>  
> @@ -91,6 +96,11 @@ void device_links_read_unlock(int not_used)
>  {
>  	up_read(&device_links_lock);
>  }
> +
> +int device_links_read_lock_held(void)
> +{
> +	return lock_is_held(&device_links_lock);
> +}
>  #endif /* !CONFIG_SRCU */
>  
>  /**
> diff --git a/drivers/base/power/runtime.c b/drivers/base/power/runtime.c
> index 952a1e7057c7..7a10e8379a70 100644
> --- a/drivers/base/power/runtime.c
> +++ b/drivers/base/power/runtime.c
> @@ -287,7 +287,8 @@ static int rpm_get_suppliers(struct device *dev)
>  {
>  	struct device_link *link;
>  
> -	list_for_each_entry_rcu(link, &dev->links.suppliers, c_node) {
> +	list_for_each_entry_rcu(link, &dev->links.suppliers, c_node,
> +				device_links_read_lock_held()) {
>  		int retval;
>  
>  		if (!(link->flags & DL_FLAG_PM_RUNTIME) ||
> @@ -309,7 +310,8 @@ static void rpm_put_suppliers(struct device *dev)
>  {
>  	struct device_link *link;
>  
> -	list_for_each_entry_rcu(link, &dev->links.suppliers, c_node) {
> +	list_for_each_entry_rcu(link, &dev->links.suppliers, c_node,
> +				device_links_read_lock_held()) {
>  		if (READ_ONCE(link->status) == DL_STATE_SUPPLIER_UNBIND)
>  			continue;
>  
> @@ -1640,7 +1642,8 @@ void pm_runtime_clean_up_links(struct device *dev)
>  
>  	idx = device_links_read_lock();
>  
> -	list_for_each_entry_rcu(link, &dev->links.consumers, s_node) {
> +	list_for_each_entry_rcu(link, &dev->links.consumers, s_node,
> +				device_links_read_lock_held()) {
>  		if (link->flags & DL_FLAG_STATELESS)
>  			continue;
>  
> @@ -1662,7 +1665,8 @@ void pm_runtime_get_suppliers(struct device *dev)
>  
>  	idx = device_links_read_lock();
>  
> -	list_for_each_entry_rcu(link, &dev->links.suppliers, c_node)
> +	list_for_each_entry_rcu(link, &dev->links.suppliers, c_node,
> +				device_links_read_lock_held())
>  		if (link->flags & DL_FLAG_PM_RUNTIME) {
>  			link->supplier_preactivated = true;
>  			refcount_inc(&link->rpm_active);
> @@ -1683,7 +1687,8 @@ void pm_runtime_put_suppliers(struct device *dev)
>  
>  	idx = device_links_read_lock();
>  
> -	list_for_each_entry_rcu(link, &dev->links.suppliers, c_node)
> +	list_for_each_entry_rcu(link, &dev->links.suppliers, c_node,
> +				device_links_read_lock_held())
>  		if (link->supplier_preactivated) {
>  			link->supplier_preactivated = false;
>  			if (refcount_dec_not_one(&link->rpm_active))
> -- 
> 2.22.0.510.g264f2c817a-goog
> 
