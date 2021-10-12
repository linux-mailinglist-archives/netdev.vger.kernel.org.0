Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB25942A9AE
	for <lists+netdev@lfdr.de>; Tue, 12 Oct 2021 18:39:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231292AbhJLQla (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Oct 2021 12:41:30 -0400
Received: from out03.mta.xmission.com ([166.70.13.233]:51048 "EHLO
        out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229996AbhJLQl3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Oct 2021 12:41:29 -0400
Received: from in02.mta.xmission.com ([166.70.13.52]:39648)
        by out03.mta.xmission.com with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1maKoJ-00GROn-6Z; Tue, 12 Oct 2021 10:39:27 -0600
Received: from ip68-227-160-95.om.om.cox.net ([68.227.160.95]:59260 helo=email.xmission.com)
        by in02.mta.xmission.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1maKoH-00GiT7-59; Tue, 12 Oct 2021 10:39:26 -0600
From:   ebiederm@xmission.com (Eric W. Biederman)
To:     Alexander Kuznetsov <wwfq@yandex-team.ru>
Cc:     netdev@vger.kernel.org, zeil@yandex-team.ru, davem@davemloft.net,
        dmtrmonakhov@yandex-team.ru
References: <20211012073914.27775-1-wwfq@yandex-team.ru>
Date:   Tue, 12 Oct 2021 11:38:48 -0500
In-Reply-To: <20211012073914.27775-1-wwfq@yandex-team.ru> (Alexander
        Kuznetsov's message of "Tue, 12 Oct 2021 10:39:14 +0300")
Message-ID: <87fst642qv.fsf@disp2133>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1maKoH-00GiT7-59;;;mid=<87fst642qv.fsf@disp2133>;;;hst=in02.mta.xmission.com;;;ip=68.227.160.95;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX19Ou5pMtF/OWTffms9Ec9WCvQt4LlbTHJ8=
X-SA-Exim-Connect-IP: 68.227.160.95
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on sa02.xmission.com
X-Spam-Level: 
X-Spam-Status: No, score=0.5 required=8.0 tests=ALL_TRUSTED,BAYES_50,
        DCC_CHECK_NEGATIVE,T_TM2_M_HEADER_IN_MSG,T_TooManySym_01,XMSubLong
        autolearn=disabled version=3.4.2
X-Spam-Virus: No
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.4999]
        *  0.7 XMSubLong Long Subject
        *  0.0 T_TM2_M_HEADER_IN_MSG BODY: No description available.
        * -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
        *      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
        *  0.0 T_TooManySym_01 4+ unique symbols in subject
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Alexander Kuznetsov <wwfq@yandex-team.ru>
X-Spam-Relay-Country: 
X-Spam-Timing: total 1467 ms - load_scoreonly_sql: 0.04 (0.0%),
        signal_user_changed: 4.3 (0.3%), b_tie_ro: 2.9 (0.2%), parse: 1.24
        (0.1%), extract_message_metadata: 12 (0.8%), get_uri_detail_list: 3.4
        (0.2%), tests_pri_-1000: 4.1 (0.3%), tests_pri_-950: 1.16 (0.1%),
        tests_pri_-900: 0.82 (0.1%), tests_pri_-90: 56 (3.8%), check_bayes: 55
        (3.7%), b_tokenize: 7 (0.5%), b_tok_get_all: 7 (0.5%), b_comp_prob:
        1.76 (0.1%), b_tok_touch_all: 36 (2.5%), b_finish: 0.68 (0.0%),
        tests_pri_0: 1373 (93.6%), check_dkim_signature: 0.66 (0.0%),
        check_dkim_adsp: 2.6 (0.2%), poll_dns_idle: 0.57 (0.0%), tests_pri_10:
        2.8 (0.2%), tests_pri_500: 8 (0.5%), rewrite_mail: 0.00 (0.0%)
Subject: Re: [PATCH] ipv6: enable net.ipv6.route.max_size sysctl in network namespace
X-SA-Exim-Version: 4.2.1 (built Sat, 08 Feb 2020 21:53:50 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Alexander Kuznetsov <wwfq@yandex-team.ru> writes:

> We want to increase route cache size in network namespace
> created with user namespace. Currently ipv6 route settings
> are disabled for non-initial network namespaces.
>
> We want to allow to write this sysctl only for users
> from host(initial) user ns.

This is subtle, and arguably broken.  Having permission tests
inside write methods has been proven problematic over the years.

That is because it usually is pretty simple to fool some application
that has the appropriate permissions to write to a file descriptor
it did not open.


From what I can see you are doing this convoluted test to avoid
performing the analysis to see if it is safe to allow the route
cache size to be changed from inside the namespace.


Usually limits like this exist more as to catch it when things
go crazy rather than to limit resource consumption in general.

So I expect it is reasonable to relax this limit possibly after
ensuring you have memory cgroup annotation on the allocations.

I suspect the routing table can grow large enough memory cgroup
annotations need to be present already.


Eric


> Signed-off-by: Alexander Kuznetsov <wwfq@yandex-team.ru>
> Acked-by: Dmitry Yakunin <zeil@yandex-team.ru>
> Acked-by: Dmitry Monakhov <dmtrmonakhov@yandex-team.ru>
> ---
>  net/ipv6/route.c | 32 ++++++++++++++++++++------------
>  1 file changed, 20 insertions(+), 12 deletions(-)
>
> diff --git a/net/ipv6/route.c b/net/ipv6/route.c
> index dbc2240..2d96c9f 100644
> --- a/net/ipv6/route.c
> +++ b/net/ipv6/route.c
> @@ -6303,13 +6303,21 @@ static int ipv6_sysctl_rtcache_flush(struct ctl_table *ctl, int write,
>  	return 0;
>  }
>  
> +static int ipv6_sysctl_route_max_size(struct ctl_table *ctl, int write,
> +				       void *buffer, size_t *lenp, loff_t *ppos)
> +{
> +	if (write && current_user_ns() != &init_user_ns)
> +		return -EPERM;
> +
> +	return proc_dointvec(ctl, write, buffer, lenp, ppos);
> +}
>  static struct ctl_table ipv6_route_table_template[] = {
>  	{
> -		.procname	=	"flush",
> -		.data		=	&init_net.ipv6.sysctl.flush_delay,
> +		.procname	=	"max_size",
> +		.data		=	&init_net.ipv6.sysctl.ip6_rt_max_size,
>  		.maxlen		=	sizeof(int),
> -		.mode		=	0200,
> -		.proc_handler	=	ipv6_sysctl_rtcache_flush
> +		.mode		=	0644,
> +		.proc_handler	=	ipv6_sysctl_route_max_size,
>  	},
>  	{
>  		.procname	=	"gc_thresh",
> @@ -6319,11 +6327,11 @@ static struct ctl_table ipv6_route_table_template[] = {
>  		.proc_handler	=	proc_dointvec,
>  	},
>  	{
> -		.procname	=	"max_size",
> -		.data		=	&init_net.ipv6.sysctl.ip6_rt_max_size,
> +		.procname	=	"flush",
> +		.data		=	&init_net.ipv6.sysctl.flush_delay,
>  		.maxlen		=	sizeof(int),
> -		.mode		=	0644,
> -		.proc_handler	=	proc_dointvec,
> +		.mode		=	0200,
> +		.proc_handler	=	ipv6_sysctl_rtcache_flush
>  	},
>  	{
>  		.procname	=	"gc_min_interval",
> @@ -6395,10 +6403,10 @@ struct ctl_table * __net_init ipv6_route_sysctl_init(struct net *net)
>  			GFP_KERNEL);
>  
>  	if (table) {
> -		table[0].data = &net->ipv6.sysctl.flush_delay;
> -		table[0].extra1 = net;
> +		table[0].data = &net->ipv6.sysctl.ip6_rt_max_size;
>  		table[1].data = &net->ipv6.ip6_dst_ops.gc_thresh;
> -		table[2].data = &net->ipv6.sysctl.ip6_rt_max_size;
> +		table[2].data = &net->ipv6.sysctl.flush_delay;
> +		table[2].extra1 = net;
>  		table[3].data = &net->ipv6.sysctl.ip6_rt_gc_min_interval;
>  		table[4].data = &net->ipv6.sysctl.ip6_rt_gc_timeout;
>  		table[5].data = &net->ipv6.sysctl.ip6_rt_gc_interval;
> @@ -6410,7 +6418,7 @@ struct ctl_table * __net_init ipv6_route_sysctl_init(struct net *net)
>  
>  		/* Don't export sysctls to unprivileged users */
>  		if (net->user_ns != &init_user_ns)
> -			table[0].procname = NULL;
> +			table[1].procname = NULL;
>  	}
>  
>  	return table;
