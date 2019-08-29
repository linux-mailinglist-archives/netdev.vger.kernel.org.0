Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B7BF1A11C3
	for <lists+netdev@lfdr.de>; Thu, 29 Aug 2019 08:28:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727330AbfH2G2z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Aug 2019 02:28:55 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:35210 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725883AbfH2G2y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Aug 2019 02:28:54 -0400
Received: by mail-wm1-f67.google.com with SMTP id l2so2496785wmg.0
        for <netdev@vger.kernel.org>; Wed, 28 Aug 2019 23:28:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=via7k0F192tLxEBiPb+UrdXSiUb10YujMQHlauF+wMs=;
        b=CmzCbFaJphav9idnEplRaN+LCDoq3QbGxsGREgWBS2TATGmjWI20KUOj9alKJzfVBn
         K7cIYAokFw/w/wQX9+/B/XAgNtQFtQkpGDyXNfbdzgSbgaIvCSbM6hh/PgixU64zj1ka
         dXByK0kILb1PrZruDQV7kxsLRxNv5iGAWMwl0ggpbUvbmpJEjEnFTGLYWMezsOGn91bD
         jd3H45TQdqtCVvjva3RhmXx+u/3NglFhhuD4RkfIt0MIxRZny7PLq0nvp1jG0KhHzZ+1
         49Nx0Pj+7SprVkkHuxG6Jfa6T7wct1/1gz/KLWoKUfThjDkyDcKEVBennyrjFbMRvnV7
         yVOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=via7k0F192tLxEBiPb+UrdXSiUb10YujMQHlauF+wMs=;
        b=lz+CIBkDsL4DoykKI7/J3TFaVve+5D6kryV9RR8Qk13sb7qjNtQg7tiXniq59DVsBR
         p2og1rLNvUy3uJmwryNmnhQ6pc7LRh++o+NnPzjrM9dyYFVA1XS3UItQLJVY+FV1Xl7B
         Vo1F0OAoQMCri6Cf6R+sSpmgZq7pwVwO07wNKPlUBvxth0LsllTMe7PMUNfxVbyUvgwz
         N+1Ou2Kvb5NjZZtPlYu5GUVmsne7nOJNPUvEOWbaJyw6+ubVnBPjpGdRWv2rnBFW30u1
         RUisq8T7dIkvSIdbU79Xf3lGPoXADxfo3rlAg0esjNeF40JNTmOOu5V/OVv22Y02l1pR
         ZfLg==
X-Gm-Message-State: APjAAAXJ3vam2iSgxHCg/A8rGzhx52Ox7ungIImHisny/CydJSO4C5Cj
        kFq50h5T2EB/xSyjCWlOUaeA3g==
X-Google-Smtp-Source: APXvYqy9r0nGfkLOaxfeAsSTYoEJyF+FBd3kQ3oz5b4df+7JOy5jYxzHmHLc4AHGeqLtWh+XjwCFUg==
X-Received: by 2002:a1c:c706:: with SMTP id x6mr9489059wmf.104.1567060131292;
        Wed, 28 Aug 2019 23:28:51 -0700 (PDT)
Received: from localhost (ip-78-45-163-186.net.upcbroadband.cz. [78.45.163.186])
        by smtp.gmail.com with ESMTPSA id c1sm1274550wmc.40.2019.08.28.23.28.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Aug 2019 23:28:50 -0700 (PDT)
Date:   Thu, 29 Aug 2019 08:28:50 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     David Ahern <dsahern@gmail.com>
Cc:     David Ahern <dsahern@kernel.org>, davem@davemloft.net,
        netdev@vger.kernel.org
Subject: Re: [PATCH net] netdevsim: Restore per-network namespace accounting
 for fib entries
Message-ID: <20190829062850.GG2312@nanopsycho>
References: <20190806191517.8713-1-dsahern@kernel.org>
 <20190828103718.GF2312@nanopsycho>
 <2c561928-1052-4c33-848d-ed7b81e920cf@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2c561928-1052-4c33-848d-ed7b81e920cf@gmail.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wed, Aug 28, 2019 at 11:26:03PM CEST, dsahern@gmail.com wrote:
>On 8/28/19 4:37 AM, Jiri Pirko wrote:
>> Tue, Aug 06, 2019 at 09:15:17PM CEST, dsahern@kernel.org wrote:
>>> From: David Ahern <dsahern@gmail.com>
>>>
>>> Prior to the commit in the fixes tag, the resource controller in netdevsim
>>> tracked fib entries and rules per network namespace. Restore that behavior.
>> 
>> David, please help me understand. If the counters are per-device, not
>> per-netns, they are both the same. If we have device (devlink instance)
>> is in a netns and take only things happening in this netns into account,
>> it should count exactly the same amount of fib entries, doesn't it?
>
>if you are only changing where the counters are stored - net_generic vs
>devlink private - then yes, they should be equivalent.

Okay.

>
>> 
>> I re-thinked the devlink netns patchset and currently I'm going in
>> slightly different direction. I'm having netns as an attribute of
>> devlink reload. So all the port netdevices and everything gets
>> re-instantiated into new netns. Works fine with mlxsw. There we also
>> re-register the fib notifier.
>> 
>> I think that this can work for your usecase in netdevsim too:
>> 1) devlink instance is registering a fib notifier to track all fib
>>    entries in a namespace it belongs to. The counters are per-device -
>>    counting fib entries in a namespace the device is in.
>> 2) another devlink instance can do the same tracking in the same
>>    namespace. No problem, it's a separate counter, but the numbers are
>>    the same. One can set different limits to different devlink
>>    instances, but you can have only one. That is the bahaviour you have
>>    now.
>> 3) on devlink reload, netdevsim re-instantiates ports and re-registers
>>    fib notifier
>> 4) on devlink reload with netns change, all should be fine as the
>>    re-registered fib nofitier replays the entries. The ports are
>>    re-instatiated in new netns.
>> 
>> This way, we would get consistent behaviour between netdevsim and real
>> devices (mlxsw), correct devlink-netns implementation (you also
>> suggested to move ports to the namespace). Everyone should be happy.
>> 
>> What do you think?
>> 
>
>Right now, registering the fib notifier walks all namespaces. That is
>not a scalable solution. Are you changing that to replay only a given
>netns? Are you changing the notifiers to be per-namespace?

Eventually, that seems like good idea. Currently I want to do
if (net==nsim_dev->mynet)
	done
check at the beginning of the notifier.


>
>Also, you are still allowing devlink instances to be created within a
>namespace?

Yes, netdevsim is planned to be created directly in namespace.
