Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6B280C2692
	for <lists+netdev@lfdr.de>; Mon, 30 Sep 2019 22:37:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730607AbfI3Uhb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Sep 2019 16:37:31 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:39313 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726576AbfI3Uhb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Sep 2019 16:37:31 -0400
Received: by mail-wm1-f65.google.com with SMTP id v17so842926wml.4
        for <netdev@vger.kernel.org>; Mon, 30 Sep 2019 13:37:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=xEeTSsOV9wyMru8vENlrjscVZzAq7FJVd7XOiyijoUk=;
        b=jWRgWi4PYHfMRVAK6pGkyhU8fkcyRDEd42KiE0rBM0WVBUPcRnmtBYJiDOHIicgRGY
         NSOX9cfARSfCXktquzeTNJdLvP+P3Wfjg4O13AqzZkLETqRwDB92DecNfLQcaoR+SBYW
         lcovPfqz/o5BJXI2P1979wj3mmzf8Qe83WUnu/HirMA/VhJKLNXfTlhQQkgbE37TyLo6
         aBL5SCOiWQkp4SbJWA6OZbItSR9qgv/pPhL9qmS2Gqmw8+Rq2Z4BEf61LHGE2ZZOeprg
         SwkRx8dqsnnYYQ759zc5WNhdJvRVTEvqE3ZFMiP5N6XtW8VLPi3vCEfVo5u58FQ6tlEB
         hIew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=xEeTSsOV9wyMru8vENlrjscVZzAq7FJVd7XOiyijoUk=;
        b=aqybMeha0acKrvFbZAWLLEbqQhyHpTzIrC11OlGmpc23SVil/l3ZaOcLXRua+D3kYV
         9ZQcY0xNOctufFvSBXQ+KCXL6g32Iez9Ue5lOYaT4k87QMzaVpRUzNXcpCk4bCJdh3A0
         TWDaDfHPk3190tofeuJa4dKcg8Dghyl0+JEGnHeNc/P7barH8vm4HnJt9l7Zp6xhbQbd
         nd0rhetceZxY75PplWHxhlMD/Vvpuz2tCz2I5RYSAjTUmoC4GXi9huDvsbactDUzCOG4
         WnscCYs6i7gHy2vVcPy5VGXruRDmHLJhzCTXkl6akuae5h8aVxJXXQuR9WzUiGcCKuqb
         sSOQ==
X-Gm-Message-State: APjAAAXqynD5qS31yeYr5BIryyGtE/vkGvqB4QP9l5qIMJn9icuAFdFs
        I5UqhzRjf243PFtX2NxgoIlx+4c6Kpg=
X-Google-Smtp-Source: APXvYqwnsab52bY2fjejUnbOlgxImj9DEntYzS65R7ppvemP9hi0PmXyKpU8KBAmMHHbdzY/i+hqaw==
X-Received: by 2002:a7b:c088:: with SMTP id r8mr401296wmh.44.1569866476370;
        Mon, 30 Sep 2019 11:01:16 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id v16sm17074370wrt.12.2019.09.30.11.01.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Sep 2019 11:01:15 -0700 (PDT)
Date:   Mon, 30 Sep 2019 20:01:15 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, idosch@mellanox.com,
        pabeni@redhat.com, edumazet@google.com, petrm@mellanox.com,
        sd@queasysnail.net, f.fainelli@gmail.com,
        stephen@networkplumber.org, mlxsw@mellanox.com
Subject: Re: [patch net-next 2/3] net: introduce per-netns netdevice notifiers
Message-ID: <20190930180115.GB2235@nanopsycho>
References: <20190930081511.26915-1-jiri@resnulli.us>
 <20190930081511.26915-3-jiri@resnulli.us>
 <20190930133824.GA14745@lunn.ch>
 <20190930142349.GE2211@nanopsycho>
 <20190930153343.GE14745@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190930153343.GE14745@lunn.ch>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Mon, Sep 30, 2019 at 05:33:43PM CEST, andrew@lunn.ch wrote:
>On Mon, Sep 30, 2019 at 04:23:49PM +0200, Jiri Pirko wrote:
>> Mon, Sep 30, 2019 at 03:38:24PM CEST, andrew@lunn.ch wrote:
>> >>  static int call_netdevice_notifiers_info(unsigned long val,
>> >>  					 struct netdev_notifier_info *info)
>> >>  {
>> >> +	struct net *net = dev_net(info->dev);
>> >> +	int ret;
>> >> +
>> >>  	ASSERT_RTNL();
>> >> +
>> >> +	/* Run per-netns notifier block chain first, then run the global one.
>> >> +	 * Hopefully, one day, the global one is going to be removed after
>> >> +	 * all notifier block registrators get converted to be per-netns.
>> >> +	 */
>> >
>> >Hi Jiri
>> >
>> >Is that really going to happen? register_netdevice_notifier() is used
>> >in 130 files. Do you plan to spend the time to make it happen?
>> 
>> That's why I prepended the sentency with "Hopefully, one day"...
>> 
>> 
>> >
>> >> +	ret = raw_notifier_call_chain(&net->netdev_chain, val, info);
>> >> +	if (ret & NOTIFY_STOP_MASK)
>> >> +		return ret;
>> >>  	return raw_notifier_call_chain(&netdev_chain, val, info);
>> >>  }
>> >
>> >Humm. I wonder about NOTIFY_STOP_MASK here. These are two separate
>> >chains. Should one chain be able to stop the other chain? Are there
>> 
>> Well if the failing item would be in the second chain, at the beginning
>> of it, it would be stopped too. Does not matter where the stop happens,
>> the point is that the whole processing stops. That is why I added the
>> check here.
>> 
>> 
>> >other examples where NOTIFY_STOP_MASK crosses a chain boundary?
>> 
>> Not aware of it, no. Could you please describe what is wrong?
>
>You are expanding the meaning of NOTIFY_STOP_MASK. It now can stop
>some other chain. If this was one chain with a filter, i would not be

Well, it was originally a single chain, so the semantics stays intact.
Again, it is not some other independent chain. It's just netns one and
general one, both serve the same purpose.


>asking. But this is two different chains, and one chain can stop
>another? At minimum, i think this needs to be reviewed by the core
>kernel people.
>
>But i'm also wondering if you are solving the problem at the wrong
>level. Are there other notifier chains which would benefit from
>respecting name space boundaries? Would a better solution be to extend
>struct notifier_block with some sort of filter?

I mentioned my primary motivation in the cover letter. What I want to
avoid is need of taking &pernet_ops_rwsem during registration of tne
notifier and avoid deadlock in my usecase.

Plus it seems very clear that if a notifier knows what netns is he
interested in, he just registers in that particular netns chain.
Having one fat generic chain with filters is basically what we have
right now.


>
>Do you have some performance numbers? Where are you getting your
>performance gains from? By the fact you are doing NOTIFY_STOP_MASK
>earlier, so preventing a long chain being walked? I notice
>notifer_block has a priority field. Did you try using that to put your
>notified earlier on the chain?

It is not about stopping the chain earlier, not at all. It is the fact
that with many netdevices in many network namespaces you gat a lot of
wasted calls to notifiers registators that does not care.



>
>	 Andrew
