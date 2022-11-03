Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 904BA618BA4
	for <lists+netdev@lfdr.de>; Thu,  3 Nov 2022 23:38:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231355AbiKCWiJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Nov 2022 18:38:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231205AbiKCWiH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Nov 2022 18:38:07 -0400
Received: from mail-il1-x133.google.com (mail-il1-x133.google.com [IPv6:2607:f8b0:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E21B21263;
        Thu,  3 Nov 2022 15:38:06 -0700 (PDT)
Received: by mail-il1-x133.google.com with SMTP id x16so1820938ilm.5;
        Thu, 03 Nov 2022 15:38:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=n/t1QpuYGHmjAu6dJiu/PChAZGU9N6vHDNe293KYEKg=;
        b=VjI8+xBVnmxg8YwdltVKRQP3gbaBNpKLQMs0G1a7hAssRQchnhhZNcwC6qtmeXhkcD
         cAF6PArcmw3SffnHcFqHc3Mk1ggVb7V4hak55iZrfXvIhXHvmI7UGSNkz0bG1M1KLD0f
         jFOSuiEWOKV5kyggb+l0oQ6+msrvJPKOfmSA9scWFqJx3Fd6FOCOPCl7h01pTPWfpOlz
         BZFDjfETIbyiIsFj4Ue12jbkOLhRkfnSoGVZoeY627txHFh78O1srSHDw7NBOCqidDt+
         rq6n565n+Ebb+3e2T2ertqwWXxxlIA+A3207RiF6idjGSL5Welq3+wY74RT6FOcbhlzN
         cSDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=n/t1QpuYGHmjAu6dJiu/PChAZGU9N6vHDNe293KYEKg=;
        b=axAhfXc/v73o+/FyZa2XFc4k84V8lEzr8BIS9g51VhmT0NvH5iZETBbGo3s5xGBqLC
         RVRwOdfm5UfJJiJpEwOqDzKxmLN+KB28DIXWJA6zd9e5Qkc2cUDZzO0PlZHSS0kjQzSY
         1R42h3+2SmB43DFFNgXfiZdDSByf/C/yVIbhR516HrVt2PNsM9X1+uPY9Bkzlv4uNGxB
         ICpG8ReczQpwrVo/mqLX7YRjLFTpd16RKChj/l2ZTX/mrsOcqdmenx/2UHieePJHJH1s
         UAc0qjM+lktxOJ43YcotJo85ZjIsFAShhlaKDiV391y68XIy12U29iMCXYW5KC41mHSS
         ar4w==
X-Gm-Message-State: ACrzQf3JuhF/NoE25ddyRaVj1ccaYcWPaItv4EXy5Cr96Kw/oRjOYW8m
        Xgxp+9bnfhAgIL2pzM9sDGo=
X-Google-Smtp-Source: AMsMyM4JowYYx6kYKPONyukV2RPMcEKLyA1l+4PKc3pecw+8cbd8R468vbfzMHb1YW0InkHPRs1AxA==
X-Received: by 2002:a92:da89:0:b0:300:c5a3:2fa0 with SMTP id u9-20020a92da89000000b00300c5a32fa0mr9264176iln.78.1667515085229;
        Thu, 03 Nov 2022 15:38:05 -0700 (PDT)
Received: from ?IPV6:2601:282:800:dc80:a10c:23e5:6dc3:8e07? ([2601:282:800:dc80:a10c:23e5:6dc3:8e07])
        by smtp.googlemail.com with ESMTPSA id o1-20020a022201000000b00374da9c6e37sm617653jao.123.2022.11.03.15.38.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Nov 2022 15:38:02 -0700 (PDT)
Message-ID: <49fbb357-ea22-2647-25d0-a2993cd5ad32@gmail.com>
Date:   Thu, 3 Nov 2022 16:38:00 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.13.1
Subject: Re: [PATCH net-next v2] netconsole: Enable live renaming for network
 interfaces used by netconsole
Content-Language: en-US
To:     Ido Schimmel <idosch@idosch.org>, Jakub Kicinski <kuba@kernel.org>
Cc:     Roman Gushchin <roman.gushchin@linux.dev>,
        Andrew Lunn <andrew@lunn.ch>,
        Andy Ren <andy.ren@getcruise.com>, netdev@vger.kernel.org,
        richardbgobert@gmail.com, davem@davemloft.net,
        wsa+renesas@sang-engineering.com, edumazet@google.com,
        petrm@nvidia.com, pabeni@redhat.com, corbet@lwn.net,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Stephen Hemminger <sthemmin@microsoft.com>
References: <20221102002420.2613004-1-andy.ren@getcruise.com>
 <Y2G+SYXyZAB/r3X0@lunn.ch> <20221101204006.75b46660@kernel.org>
 <Y2KlfhfijyNl8yxT@P9FQF9L96D.corp.robot.car>
 <20221102125418.272c4381@kernel.org> <Y2P/33wfWmQ/xC3n@shredder>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <Y2P/33wfWmQ/xC3n@shredder>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/3/22 11:52 AM, Ido Schimmel wrote:
> On Wed, Nov 02, 2022 at 12:54:18PM -0700, Jakub Kicinski wrote:
>> On Wed, 2 Nov 2022 10:14:38 -0700 Roman Gushchin wrote:
>>>> Agreed. BTW I wonder if we really want to introduce a netconsole
>>>> specific uAPI for this or go ahead with something more general.  
>>>
>>> Netconsole is a bit special because it brings an interface up very early.
>>> E.g. in our case without the netconsole the renaming is happening before
>>> the interface is brought up.
>>>
>>> I wonder if the netconsole-specific flag should allow renaming only once.
>>>  
>>>> A sysctl for global "allow UP rename"?  
>>>
>>> This will work for us, but I've no idea what it will break for other users
>>> and how to check it without actually trying to break :) And likely we won't
>>> learn about it for quite some time, asssuming they don't run net-next.
>>
>> Then again IFF_LIVE_RENAME_OK was added in 5.2 so quite a while back.
>>
>>>> We added the live renaming for failover a while back and there were 
>>>> no reports of user space breaking as far as I know. So perhaps nobody
>>>> actually cares and we should allow renaming all interfaces while UP?
>>>> For backwards compat we can add a sysctl as mentioned or a rtnetlink 
>>>> "I know what I'm doing" flag? 
>>>>
>>>> Maybe print an info message into the logs for a few releases to aid
>>>> debug?
>>>>
>>>> IOW either there is a reason we don't allow rename while up, and
>>>> netconsole being bound to an interface is immaterial. Or there is 
>>>> no reason and we should allow all.  
>>>
>>> My understanding is that it's not an issue for the kernel, but might be
>>> an issue for some userspace apps which do not expect it.
>>
>> There are in-kernel notifier users which could cache the name on up /
>> down. But yes, the user space is the real worry.
>>
>>> If you prefer to go with the 'global sysctl' approach, how the path forward
>>> should look like?
>>
>> That's the question. The sysctl would really just be to cover our back
>> sides, and be able to tell the users "you opted in by setting that
>> sysctl, we didn't break backward compat". But practically speaking, 
>> its a different entity that'd be flipping the sysctl (e.g. management
>> daemon) and different entity that'd be suffering (e.g. routing daemon).
>> So the sysctl doesn't actually help anyone :/
>>
>> So maybe we should just risk it and wonder about workarounds once
>> complains surface, if they do. Like generate fake down/up events.
>> Or create some form of "don't allow live renames now" lock-like
>> thing a process could take.
>>
>> Adding a couple more CCs and if nobody screams at us I vote we just
>> remove the restriction instead of special casing.
> 
> Tried looking at history.git to understand the reasoning behind this
> restriction. I guess it's because back then it was only possible via
> IOCTL and user space wouldn't be notified about such a change. Nowadays
> user space gets a notification regardless of the administrative state of
> the netdev (see rtnetlink_event()). At least in-kernel listeners to
> NETDEV_CHANGENAME do not seem to care if the netdev is administratively
> up or not. So, FWIW, the suggested approach sounds sane to me.

+1
