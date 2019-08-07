Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9423B84C69
	for <lists+netdev@lfdr.de>; Wed,  7 Aug 2019 15:07:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387975AbfHGNHn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Aug 2019 09:07:43 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:34925 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387598AbfHGNHn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Aug 2019 09:07:43 -0400
Received: by mail-wm1-f67.google.com with SMTP id l2so79918258wmg.0
        for <netdev@vger.kernel.org>; Wed, 07 Aug 2019 06:07:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=96///dyulVXm/P/zA7HDixJRlIgBpTohZKVMypcj8rY=;
        b=M/1jWGm2vYK6Cjv6u2IaxenJyoJcVlX93F5SXrZkGYsdMbyW9T70VzCan1Jx8MQkcq
         zfD2aTZp//8P5vKyyn4OCKq66l6sYKxka0xd63tgw1TbGEN2Wxa4RRS9kRIYv6sNZwrL
         jLI4AjMvYMBURW43V7bBadJsVLSq538pXW6iIMxX7iHaM028bApJqoLcNt9kTxNRs7U2
         G75QiOVclH5DmT6BhI8OA/Wur+MhW6TKPqfs7rUtoP3S9aPrp7AvFthrsk5ejBrGd5P3
         dMSmbKX/QXz5aBfOieQxfpgKM8nzUW6qk/enUyofYK+kNxb2Sv70EpGwr/3Q7pWa30/E
         NWUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=96///dyulVXm/P/zA7HDixJRlIgBpTohZKVMypcj8rY=;
        b=ocCe+/FvZ5ny0rnVven+B3/lCSQPRQLlMgdebRG8EZ0QmAcbyXINI0LQB7eTm2ewKi
         ritX1JNTblLkyNSg1AEaPHbmdgt6mCK3j4DkY0mnh49E2zVFksRrS9COCRI8tep69ywH
         eTfmybEOTK+VYr5nnvSY+tR8b5l4foCUyBlFgbicvaQRJxLxhJkqXCXrTmdfGI4h8mct
         lNiroqDXzU3/3QdUCATCn7UZ9SeQ1I+DRdYnckHldm9LWK+cAOTNga3MehNmNNY9bJv7
         /Z19u8zXjoS8V1zXCtbBLfWI206QJ0gvqLNRtco+yOPmpaDe2/zWcFmqHt3iLd3MQI60
         WjAA==
X-Gm-Message-State: APjAAAVn0o8uA8SFPJbX/VuaSeszdPzvphJVVKDjP+cvty4UlYHBtO26
        XbHJr/Bfv09CrNZ1vZTGoi9edQ==
X-Google-Smtp-Source: APXvYqw3InEtCiF+dOePZ07khLVEjj5a+xfblmwsDBzdR1ncOZsrl97jh6+5vezPYX1tRXTCC0kxrA==
X-Received: by 2002:a1c:f418:: with SMTP id z24mr10834809wma.80.1565183261193;
        Wed, 07 Aug 2019 06:07:41 -0700 (PDT)
Received: from localhost (mail.chocen-mesto.cz. [85.163.43.2])
        by smtp.gmail.com with ESMTPSA id c6sm97673920wma.25.2019.08.07.06.07.40
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 07 Aug 2019 06:07:40 -0700 (PDT)
Date:   Wed, 7 Aug 2019 15:07:39 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     David Ahern <dsahern@gmail.com>
Cc:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        David Ahern <dsahern@kernel.org>, davem@davemloft.net,
        netdev@vger.kernel.org
Subject: Re: [PATCH net] netdevsim: Restore per-network namespace accounting
 for fib entries
Message-ID: <20190807130739.GA2201@nanopsycho>
References: <20190806191517.8713-1-dsahern@kernel.org>
 <20190806153214.25203a68@cakuba.netronome.com>
 <20190807062712.GE2332@nanopsycho.orion>
 <dd568650-d5e7-62ee-4fde-db7b68b8962d@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dd568650-d5e7-62ee-4fde-db7b68b8962d@gmail.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wed, Aug 07, 2019 at 02:39:56PM CEST, dsahern@gmail.com wrote:
>On 8/7/19 12:27 AM, Jiri Pirko wrote:
>> Wed, Aug 07, 2019 at 12:32:14AM CEST, jakub.kicinski@netronome.com wrote:
>>> On Tue,  6 Aug 2019 12:15:17 -0700, David Ahern wrote:
>>>> From: David Ahern <dsahern@gmail.com>
>>>>
>>>> Prior to the commit in the fixes tag, the resource controller in netdevsim
>>>> tracked fib entries and rules per network namespace. Restore that behavior.
>>>>
>>>> Fixes: 5fc494225c1e ("netdevsim: create devlink instance per netdevsim instance")
>>>> Signed-off-by: David Ahern <dsahern@gmail.com>
>>>
>>> Thanks.
>>>
>>> Let's see what Jiri says, but to me this patch seems to indeed restore
>>> the original per-namespace accounting when the more natural way forward
>>> may perhaps be to make nsim only count the fib entries where
>> 
>> I think that:
>> 1) netdevsim is a glorified dummy device for testing kernel api, not for
>>    configuring per-namespace resource limitation.
>> 2) If the conclusion os to use devlink instead of cgroups for resourse
>>    limitations, it should be done in a separate code, not in netdevsim.
>> 
>> I would definitelly want to wait what is the result of discussion around 2)
>> first. But one way or another netdevsim code should not do this, I would
>> like to cutout the fib limitations from it instead, just to expose the
>> setup resource limits through debugfs like the rest of the configuration
>> of netdevsim.
>> 
>> 
>
>This is the most incredulous response. You break code you don't
>understand and argue that it should be left broken in older releases and
>ripped out in later ones rather than fixed back to its intent.

Yeah. I believe it was a mistake to add it in the first place. Abuses
netdevsim for something it is not. I'm fine to use devlink the way you
want to after we conclude 2), but outside netdevsim.

Again, netdevsim is there for config api testing purposes. If things
got broken, it is not that bit deal. I broke the way it is
instantiated significantly for example (iplink->sysfs).


>
>Again, the devlink resource controller was added by me specifically to
>test the ability to fail in-kernel fib notifiers. When I add the nexthop
>in-kernel notifier, netdevsim again provides a simple means of testing it.
>
>It satisfies all of the conditions and intents of netdevsim - test
>kernel APIs without hardware.

Well, what you want to do is limit kernel sw resources per-namespace.
