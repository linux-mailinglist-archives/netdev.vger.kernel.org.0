Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 89AA8CB465
	for <lists+netdev@lfdr.de>; Fri,  4 Oct 2019 08:19:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388306AbfJDGTS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Oct 2019 02:19:18 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:38416 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730408AbfJDGTS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Oct 2019 02:19:18 -0400
Received: by mail-wr1-f66.google.com with SMTP id w12so5567029wro.5
        for <netdev@vger.kernel.org>; Thu, 03 Oct 2019 23:19:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=38VhovQ63ttC8pB+Wb9y0LRU9yJHOXMwqbbQjFKZqQQ=;
        b=llFPRZ8ZhXmelEHvx4V83dGru2HHg0CAZXtIAvZs3OrostGglK6jO/6nBQhQBV9qyN
         8kYO8OmVgU6o2VuRt4eCiw9ziQy9PahlvdetVjgz4pi9P7t4nsSp7Ri3HkExISZRpQrU
         qYcJZlWn3jz8qBKAA42J4c0SEyDab+WVWlncqHItCKC5CesdjOhA8CZl8xmFDUK9uSIX
         W6OVMwjMmHmI0YhCwDowAak4sv6Lg7EmEUnNjyeZE7GUYjbp0B2jTSR6kQn1WTsvPhz0
         pXt58d+aTi3jyy8Zh1rTA0eUsiQOSa6cDGFcAVOgaU/yAlFEXdPuoQGoDJaszsAfVaSL
         hpLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=38VhovQ63ttC8pB+Wb9y0LRU9yJHOXMwqbbQjFKZqQQ=;
        b=cHPSELPpfcIqLpL0tIsJhLLmjLvUq0RKRz3UYwlO8rZpJexogUmbgPpZVMh7XJ2Qxw
         KG3e+Gj2jKzi1U1eOQhanvJaN22yYjHNYtfqlw5POgzn+nELIU87VbnebKwWZQvzW+Ns
         mJ6K0LQth28V0B+cqeYEPRAsUQJAIccAhNS24IDFFO3/z5mJqowItBIswnTyvE7wdARv
         1E7NZJPteYo/m46luZ++xt2mkcp3e98Q3z1ESqYYnnY7mWeypen9zZ6XXTL9UL47akVp
         ZBw7+WCz743cDJwwZhJttlxPrf2WbGK1DN3/cqflKc4nAHGxSQDzugsR9TOO4OMXfsnC
         ciCQ==
X-Gm-Message-State: APjAAAUVIc80fW3a4hB2F8iulgJBslE/FigGRfe/PvfGEfe8SBYbdI12
        ochOsG6HFUAGo8qerjuuGxyaSh49z9c=
X-Google-Smtp-Source: APXvYqzCv4CeKsGw/3eYmZGGR+3CGtdMzhtxbF0FmgESe7nq5JWgUF2ATfp6fU0eQW+p8TfwO02SBQ==
X-Received: by 2002:a5d:4385:: with SMTP id i5mr9731494wrq.353.1570169955937;
        Thu, 03 Oct 2019 23:19:15 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id g4sm6579828wrw.9.2019.10.03.23.19.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Oct 2019 23:19:15 -0700 (PDT)
Date:   Fri, 4 Oct 2019 08:19:14 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, idosch@mellanox.com,
        dsahern@gmail.com, tariqt@mellanox.com, saeedm@mellanox.com,
        kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org, shuah@kernel.org,
        mlxsw@mellanox.com
Subject: Re: [patch net-next v3 11/15] netdevsim: implement proper devlink
 reload
Message-ID: <20191004061914.GA2264@nanopsycho>
References: <20191003094940.9797-1-jiri@resnulli.us>
 <20191003094940.9797-12-jiri@resnulli.us>
 <20191003161730.6c61b48c@cakuba.hsd1.ca.comcast.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191003161730.6c61b48c@cakuba.hsd1.ca.comcast.net>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fri, Oct 04, 2019 at 01:17:30AM CEST, jakub.kicinski@netronome.com wrote:
>On Thu,  3 Oct 2019 11:49:36 +0200, Jiri Pirko wrote:
>> From: Jiri Pirko <jiri@mellanox.com>
>> 
>> During devlink reload, all driver objects should be reinstantiated with
>> the exception of devlink instance and devlink resources and params.
>> Move existing devlink_resource_size_get() calls into fib_create() just
>> before fib notifier is registered. Also, make sure that extack is
>> propagated down to fib_notifier_register() call.
>> 
>> Signed-off-by: Jiri Pirko <jiri@mellanox.com>
>
>Acked-by: Jakub Kicinski <jakub.kicinski@netronome.com>
>
>> diff --git a/drivers/net/netdevsim/fib.c b/drivers/net/netdevsim/fib.c
>> index d2aeac0f4c2c..fdc682f3a09a 100644
>> --- a/drivers/net/netdevsim/fib.c
>> +++ b/drivers/net/netdevsim/fib.c
>> @@ -63,12 +63,10 @@ u64 nsim_fib_get_val(struct nsim_fib_data *fib_data,
>>  	return max ? entry->max : entry->num;
>>  }
>>  
>> -int nsim_fib_set_max(struct nsim_fib_data *fib_data,
>> -		     enum nsim_resource_id res_id, u64 val,
>> -		     struct netlink_ext_ack *extack)
>> +static void nsim_fib_set_max(struct nsim_fib_data *fib_data,
>> +			     enum nsim_resource_id res_id, u64 val)
>>  {
>>  	struct nsim_fib_entry *entry;
>> -	int err = 0;
>>  
>>  	switch (res_id) {
>>  	case NSIM_RESOURCE_IPV4_FIB:
>> @@ -84,20 +82,10 @@ int nsim_fib_set_max(struct nsim_fib_data *fib_data,
>>  		entry = &fib_data->ipv6.rules;
>>  		break;
>>  	default:
>> -		return 0;
>> -	}
>> -
>> -	/* not allowing a new max to be less than curren occupancy
>> -	 * --> no means of evicting entries
>> -	 */
>> -	if (val < entry->num) {
>> -		NL_SET_ERR_MSG_MOD(extack, "New size is less than current occupancy");
>> -		err = -EINVAL;
>
>This change in behaviour should perhaps be mentioned in the commit
>message. The reload will no longer fail if the resources are
>insufficient. 

Reload is going to fail if the resources are insufficient. I have a
selftest for that, please see the last patch.

>
>Since we want to test reload more widely than just for the FIB limits
>that does make sense to me. Is that the thinking?
>
>> -	} else {
>> -		entry->max = val;
>> +		WARN_ON(1);
>> +		return;
>>  	}
>> -
>> -	return err;
>> +	entry->max = val;
>>  }
>>  
>>  static int nsim_fib_rule_account(struct nsim_fib_entry *entry, bool add,
