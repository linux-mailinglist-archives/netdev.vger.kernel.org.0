Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AC865B2F29
	for <lists+netdev@lfdr.de>; Sun, 15 Sep 2019 10:17:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726264AbfIOIRw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Sep 2019 04:17:52 -0400
Received: from new1-smtp.messagingengine.com ([66.111.4.221]:59347 "EHLO
        new1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725497AbfIOIRw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Sep 2019 04:17:52 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailnew.nyi.internal (Postfix) with ESMTP id 5A9FF20FA;
        Sun, 15 Sep 2019 04:17:50 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Sun, 15 Sep 2019 04:17:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=yY1YAZ
        vs4gdNm1mNiEobOOdscOXM3+JMuw/X/bEvR+0=; b=zYr9JD16bnCMXRf+TockWa
        6S2gycjUGKoO6gK01V/A1qM7s2RSr5dOvSC86NxJelgp8qZLvS3FT3cV6mU9r91Q
        /sV9diCqBPkPB70/pYe5htNm6dPcRXk+V5f7K5zLExultC7UwthzRD1YCo9a1NIy
        e9VIFW+b/KeyJ2/O8gnpuKKT4yFCh2kxIbklcdBrpozi9vyC5gV036NYh6eMa+ox
        0qtdvqdCabGQrGG1at4SRT2DvE5JkRo1V7pQkXLbRkA8yfe/zaU8Jw7FAvSx88a3
        cla+UuMRlvYjj0e/mJKS7gwsB3rGHmgk188jswpUSDLX60oYyQeeAddgSDgjvu+g
        ==
X-ME-Sender: <xms:rPN9XWPVu6cJCjUA0SMQD4nKc3BMiRKjx1iS50sY-2NE2UtE12Fmtw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedruddugddtfecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujggfsehttdertddtredvnecuhfhrohhmpefkughoucfu
    tghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucfkphepudelfe
    drgeejrdduieehrddvhedunecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhes
    ihguohhstghhrdhorhhgnecuvehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:rPN9XTcLe50sEPgdCp187NgFz2hkfZOf8tRdlLxfRgEQMlLrttxK5Q>
    <xmx:rPN9XUFMJxggfrvEhjy5_1FoRMJGtQYDQmfR6pSqbmEvPgOk8G4vag>
    <xmx:rPN9XWspkBL5jU9g5FVxBYz9q0dB0GB4fsfyyt6QzQRnPYi8Vw06AA>
    <xmx:rvN9XZGBOyIc-iSoyd4pjs0hcNQJjaYpDsm1qqTQtU3rKX5vm-WOIw>
Received: from localhost (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 52782D6005E;
        Sun, 15 Sep 2019 04:17:48 -0400 (EDT)
Date:   Sun, 15 Sep 2019 11:17:46 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, idosch@mellanox.com,
        dsahern@gmail.com, jakub.kicinski@netronome.com,
        tariqt@mellanox.com, saeedm@mellanox.com, kuznet@ms2.inr.ac.ru,
        yoshfuji@linux-ipv6.org, shuah@kernel.org, mlxsw@mellanox.com
Subject: Re: [patch net-next 03/15] net: fib_notifier: propagate possible
 error during fib notifier registration
Message-ID: <20190915081746.GB11194@splinter>
References: <20190914064608.26799-1-jiri@resnulli.us>
 <20190914064608.26799-4-jiri@resnulli.us>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190914064608.26799-4-jiri@resnulli.us>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Sep 14, 2019 at 08:45:56AM +0200, Jiri Pirko wrote:
> From: Jiri Pirko <jiri@mellanox.com>
> 
> Unlike events for registered notifier, during the registration, the
> errors that happened for the block being registered are not propagated
> up to the caller. For fib rules, this is already present, but not for

What do you mean by "already present" ? You added it below for rules as
well...

> fib entries. So make sure the error is propagated for those as well.
> 
> Signed-off-by: Jiri Pirko <jiri@mellanox.com>
> ---
>  include/net/ip_fib.h    |  2 +-
>  net/core/fib_notifier.c |  2 --
>  net/core/fib_rules.c    | 11 ++++++++---
>  net/ipv4/fib_notifier.c |  4 +---
>  net/ipv4/fib_trie.c     | 31 ++++++++++++++++++++++---------
>  net/ipv4/ipmr_base.c    | 22 +++++++++++++++-------
>  net/ipv6/ip6_fib.c      | 36 ++++++++++++++++++++++++------------
>  7 files changed, 71 insertions(+), 37 deletions(-)
> 
> diff --git a/include/net/ip_fib.h b/include/net/ip_fib.h
> index 4cec9ecaa95e..caae0fa610aa 100644
> --- a/include/net/ip_fib.h
> +++ b/include/net/ip_fib.h
> @@ -229,7 +229,7 @@ int __net_init fib4_notifier_init(struct net *net);
>  void __net_exit fib4_notifier_exit(struct net *net);
>  
>  void fib_info_notify_update(struct net *net, struct nl_info *info);
> -void fib_notify(struct net *net, struct notifier_block *nb);
> +int fib_notify(struct net *net, struct notifier_block *nb);
>  
>  struct fib_table {
>  	struct hlist_node	tb_hlist;
> diff --git a/net/core/fib_notifier.c b/net/core/fib_notifier.c
> index b965f3c0ec9a..fbd029425638 100644
> --- a/net/core/fib_notifier.c
> +++ b/net/core/fib_notifier.c
> @@ -65,8 +65,6 @@ static int fib_net_dump(struct net *net, struct notifier_block *nb)
>  
>  	rcu_read_lock();
>  	list_for_each_entry_rcu(ops, &fn_net->fib_notifier_ops, list) {
> -		int err;

Looks like this should have been removed in previous patch

> -
>  		if (!try_module_get(ops->owner))
>  			continue;
>  		err = ops->fib_dump(net, nb);
> diff --git a/net/core/fib_rules.c b/net/core/fib_rules.c
> index 28cbf07102bc..592d8aef90e3 100644
> --- a/net/core/fib_rules.c
> +++ b/net/core/fib_rules.c
> @@ -354,15 +354,20 @@ int fib_rules_dump(struct net *net, struct notifier_block *nb, int family)
>  {
>  	struct fib_rules_ops *ops;
>  	struct fib_rule *rule;
> +	int err = 0;
>  
>  	ops = lookup_rules_ops(net, family);
>  	if (!ops)
>  		return -EAFNOSUPPORT;
> -	list_for_each_entry_rcu(rule, &ops->rules_list, list)
> -		call_fib_rule_notifier(nb, FIB_EVENT_RULE_ADD, rule, family);
> +	list_for_each_entry_rcu(rule, &ops->rules_list, list) {
> +		err = call_fib_rule_notifier(nb, FIB_EVENT_RULE_ADD,
> +					     rule, family);

Here you add it for rules

> +		if (err)
> +			break;
> +	}
>  	rules_ops_put(ops);
>  
> -	return 0;
> +	return err;
>  }
>  EXPORT_SYMBOL_GPL(fib_rules_dump);
