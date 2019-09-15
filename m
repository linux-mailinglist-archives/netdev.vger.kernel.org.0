Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A81C9B2F69
	for <lists+netdev@lfdr.de>; Sun, 15 Sep 2019 11:41:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727030AbfIOJlI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Sep 2019 05:41:08 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:40788 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726309AbfIOJlI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Sep 2019 05:41:08 -0400
Received: by mail-wr1-f67.google.com with SMTP id l3so13196615wru.7
        for <netdev@vger.kernel.org>; Sun, 15 Sep 2019 02:41:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=6atRngiS3o4XMnGxAIkfIONPEsJVLWE5JsQta6KJiwQ=;
        b=DX1EIQgxcqrEwCns1qc++4ob9Pz0LOcDRjpSrAecslbGc8OaHQo7CRcUQgCyaX3EcW
         xgBP35kL01SGfEJOpp5o5cP6CuOGOgDtKuFbPVkvIx+WmQXZvZwiQ05JjNiAUYZMTX70
         EYsb0bKGPq+LpzAWALVt2N/bvVzCwf3lywyF8aZAxKOK6qM7PR2cyE0rJ0TuPFnBI+tb
         MF53OoyW9DoKtl2HIkbx5UClqlhX1bH5RY13hbSialJGf8Pat7vZVJm6vblibbhaZSJ7
         NyP75MpKfsH6Y/WfLAR+b1GSsBN1307dXNLXjthw7nOPOukE7ZuBurq4TV+qvTv4Gklm
         vvKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=6atRngiS3o4XMnGxAIkfIONPEsJVLWE5JsQta6KJiwQ=;
        b=ednmRhgi8nRO1pM6RtilEO2iBIR7HnFN3aBsuPlar26HBdWxc+4t5N7PMCF6d248Lr
         GMVW2a0OX3uHHREDiS+OkE/8XSQNMDgBxDr7eqTPdsYN4T9n4V9f4c6bmbbMz5q4roXS
         lj5J4/6mfQ7/mIUIc6QnWeoaINo/MSyYcuwB3QcVL5z66Wxxfdsp8cTs0QUNW+pHr2zO
         1aJaX7g8YTu2JNydN/udxn0OxS8fidE+3sDZ7nZ3F8crjtt4hL8WvEIUBVr+QbsszE8w
         I8IhLNckOSXCLwOWtwKzfVrnlAyMWIc3hGFr/aza3Al+vgattisiqfwvVzddLYesaSGY
         gIQQ==
X-Gm-Message-State: APjAAAWvJQCnues9I8R3IRONt+BtDqCI8sebWsQ3iB9n/IYEiNpUMjfi
        WzhB0hGiEbLzg1HB21x+CQkU2w==
X-Google-Smtp-Source: APXvYqzeWfS3mz2Mw4nmmDuyQGkr1DoK2i4GTpjpvPhDdqWRqfWTR5Zn57I3q5w+tZbD1/BmRO4u3A==
X-Received: by 2002:a5d:4904:: with SMTP id x4mr12461091wrq.219.1568540466900;
        Sun, 15 Sep 2019 02:41:06 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id g73sm15615113wme.10.2019.09.15.02.41.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Sep 2019 02:41:06 -0700 (PDT)
Date:   Sun, 15 Sep 2019 11:41:05 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, idosch@mellanox.com,
        dsahern@gmail.com, jakub.kicinski@netronome.com,
        tariqt@mellanox.com, saeedm@mellanox.com, kuznet@ms2.inr.ac.ru,
        yoshfuji@linux-ipv6.org, shuah@kernel.org, mlxsw@mellanox.com
Subject: Re: [patch net-next 03/15] net: fib_notifier: propagate possible
 error during fib notifier registration
Message-ID: <20190915094105.GC2286@nanopsycho.orion>
References: <20190914064608.26799-1-jiri@resnulli.us>
 <20190914064608.26799-4-jiri@resnulli.us>
 <20190915081746.GB11194@splinter>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190915081746.GB11194@splinter>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sun, Sep 15, 2019 at 10:17:46AM CEST, idosch@idosch.org wrote:
>On Sat, Sep 14, 2019 at 08:45:56AM +0200, Jiri Pirko wrote:
>> From: Jiri Pirko <jiri@mellanox.com>
>> 
>> Unlike events for registered notifier, during the registration, the
>> errors that happened for the block being registered are not propagated
>> up to the caller. For fib rules, this is already present, but not for
>
>What do you mean by "already present" ? You added it below for rules as
>well...

Right, will fix.


>
>> fib entries. So make sure the error is propagated for those as well.
>> 
>> Signed-off-by: Jiri Pirko <jiri@mellanox.com>
>> ---
>>  include/net/ip_fib.h    |  2 +-
>>  net/core/fib_notifier.c |  2 --
>>  net/core/fib_rules.c    | 11 ++++++++---
>>  net/ipv4/fib_notifier.c |  4 +---
>>  net/ipv4/fib_trie.c     | 31 ++++++++++++++++++++++---------
>>  net/ipv4/ipmr_base.c    | 22 +++++++++++++++-------
>>  net/ipv6/ip6_fib.c      | 36 ++++++++++++++++++++++++------------
>>  7 files changed, 71 insertions(+), 37 deletions(-)
>> 
>> diff --git a/include/net/ip_fib.h b/include/net/ip_fib.h
>> index 4cec9ecaa95e..caae0fa610aa 100644
>> --- a/include/net/ip_fib.h
>> +++ b/include/net/ip_fib.h
>> @@ -229,7 +229,7 @@ int __net_init fib4_notifier_init(struct net *net);
>>  void __net_exit fib4_notifier_exit(struct net *net);
>>  
>>  void fib_info_notify_update(struct net *net, struct nl_info *info);
>> -void fib_notify(struct net *net, struct notifier_block *nb);
>> +int fib_notify(struct net *net, struct notifier_block *nb);
>>  
>>  struct fib_table {
>>  	struct hlist_node	tb_hlist;
>> diff --git a/net/core/fib_notifier.c b/net/core/fib_notifier.c
>> index b965f3c0ec9a..fbd029425638 100644
>> --- a/net/core/fib_notifier.c
>> +++ b/net/core/fib_notifier.c
>> @@ -65,8 +65,6 @@ static int fib_net_dump(struct net *net, struct notifier_block *nb)
>>  
>>  	rcu_read_lock();
>>  	list_for_each_entry_rcu(ops, &fn_net->fib_notifier_ops, list) {
>> -		int err;
>
>Looks like this should have been removed in previous patch

Correct, will move.


>
>> -
>>  		if (!try_module_get(ops->owner))
>>  			continue;
>>  		err = ops->fib_dump(net, nb);
>> diff --git a/net/core/fib_rules.c b/net/core/fib_rules.c
>> index 28cbf07102bc..592d8aef90e3 100644
>> --- a/net/core/fib_rules.c
>> +++ b/net/core/fib_rules.c
>> @@ -354,15 +354,20 @@ int fib_rules_dump(struct net *net, struct notifier_block *nb, int family)
>>  {
>>  	struct fib_rules_ops *ops;
>>  	struct fib_rule *rule;
>> +	int err = 0;
>>  
>>  	ops = lookup_rules_ops(net, family);
>>  	if (!ops)
>>  		return -EAFNOSUPPORT;
>> -	list_for_each_entry_rcu(rule, &ops->rules_list, list)
>> -		call_fib_rule_notifier(nb, FIB_EVENT_RULE_ADD, rule, family);
>> +	list_for_each_entry_rcu(rule, &ops->rules_list, list) {
>> +		err = call_fib_rule_notifier(nb, FIB_EVENT_RULE_ADD,
>> +					     rule, family);
>
>Here you add it for rules
>
>> +		if (err)
>> +			break;
>> +	}
>>  	rules_ops_put(ops);
>>  
>> -	return 0;
>> +	return err;
>>  }
>>  EXPORT_SYMBOL_GPL(fib_rules_dump);
