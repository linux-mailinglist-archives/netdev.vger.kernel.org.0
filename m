Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EBFB7CF98E
	for <lists+netdev@lfdr.de>; Tue,  8 Oct 2019 14:13:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731290AbfJHMMR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Oct 2019 08:12:17 -0400
Received: from mail-qk1-f196.google.com ([209.85.222.196]:36839 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731286AbfJHMMP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Oct 2019 08:12:15 -0400
Received: by mail-qk1-f196.google.com with SMTP id y189so16457172qkc.3
        for <netdev@vger.kernel.org>; Tue, 08 Oct 2019 05:12:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=IGvvHnavveQviSwQMzfSZGK8FLUUVfOi0cgRdPIEaCM=;
        b=l2850QRtPeCjdqbUlcWzrIQI2jExFmmh/iOoeKvElv23jQNld44eAxOWXLxRV+uyMD
         kfTWo83AOLgravitdkom4IKUY76K/cPo2nBDgZD8h/W/Yh+CSDAWxKlVJ46N03Ki71Pe
         0gfVJrpm5s62UYKSIriErKO21i6zXmX7XPNLk077iDuE98Z5JheL6V0jsOLUmzbQ3a/D
         FIwRv6jJ3WH2wFPhhCLfqp0iNOvBfsMHweBsuCzraHcuBhXRF5bRKVHkz2PxznuYETq0
         trhl17N9iiVLAU06y00jt69nP98ztyGdh/ZBOrSoSZcINnaaVZIViagumVTDZMtuUVvj
         cJQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=IGvvHnavveQviSwQMzfSZGK8FLUUVfOi0cgRdPIEaCM=;
        b=p9lLzVlOQVQKTTmfHd/nXZT2MweHmpZm3rhLWLNDUMWVQ3trNEVdJ65YnoH65zZqOm
         gfsV/JGJCfOr3RQH6LVlw6grIn6EETeOmdT97p5+43cBSuZw/KACDmG2/58uDnMSwp+5
         4kfKTApxU0HZVCrJdB87vrJH4pdTo8U0ODRvdi8JVF/HZPkohhToPiczSDj54hsKmxic
         LitBISnMjXLDxBk5jRqcX+jy2pAZoVdRD3a1LuFZJ+QEed8rgv8oeqUu9MY3Q5hIUi0s
         i5Bb/wEnQsiN5bK+jAse4cRXL2eG05n5Ri+T1Boin7Inhee/hMsSltORhR27WMg2kBNw
         pVWQ==
X-Gm-Message-State: APjAAAUuOnAuS07Ls2GZf5+DZp0WXs+HI0jdzEGLc3nI9pKUB/CG+69p
        T3eNCs8VcJ66sIUxNXSrleo=
X-Google-Smtp-Source: APXvYqw7/1b0Y3A2geejRO8N1nqYcZzctvW3QAD6O4LSNPQw0qRg3uY+kvksCQB2C7Ai4hMR9ppE7g==
X-Received: by 2002:a37:a083:: with SMTP id j125mr30125598qke.329.1570536734605;
        Tue, 08 Oct 2019 05:12:14 -0700 (PDT)
Received: from localhost.localdomain ([177.220.176.151])
        by smtp.gmail.com with ESMTPSA id w73sm9388056qkb.111.2019.10.08.05.12.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Oct 2019 05:12:13 -0700 (PDT)
Received: by localhost.localdomain (Postfix, from userid 1000)
        id 1FA45C07B5; Tue,  8 Oct 2019 09:12:11 -0300 (-03)
Date:   Tue, 8 Oct 2019 09:12:11 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     netdev@vger.kernel.org, Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>
Subject: Re: [Patch net] net_sched: fix backward compatibility for TCA_KIND
Message-ID: <20191008121211.GQ3431@localhost.localdomain>
References: <20191007202629.32462-1-xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191007202629.32462-1-xiyou.wangcong@gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 07, 2019 at 01:26:28PM -0700, Cong Wang wrote:
> Marcelo noticed a backward compatibility issue of TCA_KIND
> after we move from NLA_STRING to NLA_NUL_STRING, so it is probably
> too late to change it.
> 
> Instead, to make everyone happy, we can just insert a NUL to
> terminate the string with nla_strlcpy() like we do for TC actions.
> 
> Fixes: 62794fc4fbf5 ("net_sched: add max len check for TCA_KIND")
> Reported-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>

Reviewed-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>

> Cc: Jamal Hadi Salim <jhs@mojatatu.com>
> Cc: Jiri Pirko <jiri@resnulli.us>
> Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
> ---
>  net/sched/cls_api.c | 36 +++++++++++++++++++++++++++++++++---
>  net/sched/sch_api.c |  3 +--
>  2 files changed, 34 insertions(+), 5 deletions(-)
> 
> diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
> index 64584a1df425..8717c0b26c90 100644
> --- a/net/sched/cls_api.c
> +++ b/net/sched/cls_api.c
> @@ -162,11 +162,22 @@ static inline u32 tcf_auto_prio(struct tcf_proto *tp)
>  	return TC_H_MAJ(first);
>  }
>  
> +static bool tcf_proto_check_kind(struct nlattr *kind, char *name)
> +{
> +	if (kind)
> +		return nla_strlcpy(name, kind, IFNAMSIZ) >= IFNAMSIZ;
> +	memset(name, 0, IFNAMSIZ);
> +	return false;
> +}
> +
>  static bool tcf_proto_is_unlocked(const char *kind)
>  {
>  	const struct tcf_proto_ops *ops;
>  	bool ret;
>  
> +	if (strlen(kind) == 0)
> +		return false;
> +
>  	ops = tcf_proto_lookup_ops(kind, false, NULL);
>  	/* On error return false to take rtnl lock. Proto lookup/create
>  	 * functions will perform lookup again and properly handle errors.
> @@ -1843,6 +1854,7 @@ static int tc_new_tfilter(struct sk_buff *skb, struct nlmsghdr *n,
>  {
>  	struct net *net = sock_net(skb->sk);
>  	struct nlattr *tca[TCA_MAX + 1];
> +	char name[IFNAMSIZ];
>  	struct tcmsg *t;
>  	u32 protocol;
>  	u32 prio;
> @@ -1899,13 +1911,19 @@ static int tc_new_tfilter(struct sk_buff *skb, struct nlmsghdr *n,
>  	if (err)
>  		return err;
>  
> +	if (tcf_proto_check_kind(tca[TCA_KIND], name)) {
> +		NL_SET_ERR_MSG(extack, "Specified TC filter name too long");
> +		err = -EINVAL;
> +		goto errout;
> +	}
> +
>  	/* Take rtnl mutex if rtnl_held was set to true on previous iteration,
>  	 * block is shared (no qdisc found), qdisc is not unlocked, classifier
>  	 * type is not specified, classifier is not unlocked.
>  	 */
>  	if (rtnl_held ||
>  	    (q && !(q->ops->cl_ops->flags & QDISC_CLASS_OPS_DOIT_UNLOCKED)) ||
> -	    !tca[TCA_KIND] || !tcf_proto_is_unlocked(nla_data(tca[TCA_KIND]))) {
> +	    !tcf_proto_is_unlocked(name)) {
>  		rtnl_held = true;
>  		rtnl_lock();
>  	}
> @@ -2063,6 +2081,7 @@ static int tc_del_tfilter(struct sk_buff *skb, struct nlmsghdr *n,
>  {
>  	struct net *net = sock_net(skb->sk);
>  	struct nlattr *tca[TCA_MAX + 1];
> +	char name[IFNAMSIZ];
>  	struct tcmsg *t;
>  	u32 protocol;
>  	u32 prio;
> @@ -2102,13 +2121,18 @@ static int tc_del_tfilter(struct sk_buff *skb, struct nlmsghdr *n,
>  	if (err)
>  		return err;
>  
> +	if (tcf_proto_check_kind(tca[TCA_KIND], name)) {
> +		NL_SET_ERR_MSG(extack, "Specified TC filter name too long");
> +		err = -EINVAL;
> +		goto errout;
> +	}
>  	/* Take rtnl mutex if flushing whole chain, block is shared (no qdisc
>  	 * found), qdisc is not unlocked, classifier type is not specified,
>  	 * classifier is not unlocked.
>  	 */
>  	if (!prio ||
>  	    (q && !(q->ops->cl_ops->flags & QDISC_CLASS_OPS_DOIT_UNLOCKED)) ||
> -	    !tca[TCA_KIND] || !tcf_proto_is_unlocked(nla_data(tca[TCA_KIND]))) {
> +	    !tcf_proto_is_unlocked(name)) {
>  		rtnl_held = true;
>  		rtnl_lock();
>  	}
> @@ -2216,6 +2240,7 @@ static int tc_get_tfilter(struct sk_buff *skb, struct nlmsghdr *n,
>  {
>  	struct net *net = sock_net(skb->sk);
>  	struct nlattr *tca[TCA_MAX + 1];
> +	char name[IFNAMSIZ];
>  	struct tcmsg *t;
>  	u32 protocol;
>  	u32 prio;
> @@ -2252,12 +2277,17 @@ static int tc_get_tfilter(struct sk_buff *skb, struct nlmsghdr *n,
>  	if (err)
>  		return err;
>  
> +	if (tcf_proto_check_kind(tca[TCA_KIND], name)) {
> +		NL_SET_ERR_MSG(extack, "Specified TC filter name too long");
> +		err = -EINVAL;
> +		goto errout;
> +	}
>  	/* Take rtnl mutex if block is shared (no qdisc found), qdisc is not
>  	 * unlocked, classifier type is not specified, classifier is not
>  	 * unlocked.
>  	 */
>  	if ((q && !(q->ops->cl_ops->flags & QDISC_CLASS_OPS_DOIT_UNLOCKED)) ||
> -	    !tca[TCA_KIND] || !tcf_proto_is_unlocked(nla_data(tca[TCA_KIND]))) {
> +	    !tcf_proto_is_unlocked(name)) {
>  		rtnl_held = true;
>  		rtnl_lock();
>  	}
> diff --git a/net/sched/sch_api.c b/net/sched/sch_api.c
> index 81d58b280612..1047825d9f48 100644
> --- a/net/sched/sch_api.c
> +++ b/net/sched/sch_api.c
> @@ -1390,8 +1390,7 @@ check_loop_fn(struct Qdisc *q, unsigned long cl, struct qdisc_walker *w)
>  }
>  
>  const struct nla_policy rtm_tca_policy[TCA_MAX + 1] = {
> -	[TCA_KIND]		= { .type = NLA_NUL_STRING,
> -				    .len = IFNAMSIZ - 1 },
> +	[TCA_KIND]		= { .type = NLA_STRING },
>  	[TCA_RATE]		= { .type = NLA_BINARY,
>  				    .len = sizeof(struct tc_estimator) },
>  	[TCA_STAB]		= { .type = NLA_NESTED },
> -- 
> 2.21.0
> 
