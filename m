Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0824024C0B1
	for <lists+netdev@lfdr.de>; Thu, 20 Aug 2020 16:35:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728002AbgHTOfe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Aug 2020 10:35:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726854AbgHTOf3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Aug 2020 10:35:29 -0400
Received: from mail-qt1-x844.google.com (mail-qt1-x844.google.com [IPv6:2607:f8b0:4864:20::844])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C447C061385
        for <netdev@vger.kernel.org>; Thu, 20 Aug 2020 07:35:29 -0700 (PDT)
Received: by mail-qt1-x844.google.com with SMTP id w9so1317615qts.6
        for <netdev@vger.kernel.org>; Thu, 20 Aug 2020 07:35:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=M8QM/qskJXUX9BeMIuxtZv/Hcfn9bADRRMMg+nYUcNU=;
        b=VTjSFVEM567GpcmA5BgcCfWSJxYGdFokZuEV2EqmWSrAgQ1nqoy3kLFmjPyc5Qr7Ct
         4v7S+DqByThB3xWr16JO5U/itiNWzE2qVSvd5F6qRTFdXZZweLrE7BsQTfKYkbmotMXO
         wlelmnwrrSTP0mWs77DTaxIyau9WiM0Kv58ZYOrA1aDZFZHGm2Kb7ic5Gtin8HOP5T1o
         oiTM5hjZNDGkfQD/F0p5JE3dpcNXGOCpfZtSLRzPmxII4lygugvKjnIJhcUrKP9NTDCe
         nkiXaicMBzanZmKRLRRAEzhFpvM2xC3D2Rsx4bvfKzUwyvZYpkDeTeg074HyTvhw3fbH
         vJ6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=M8QM/qskJXUX9BeMIuxtZv/Hcfn9bADRRMMg+nYUcNU=;
        b=mFNSRRbb9/EPwimo/SsdMJhXvu+MjyHb1cM85N6hygaM7ZIMbsPleFfIFdL4x1XKBw
         F4GQftqE8M7+HXtBM+j9dMATVIClfHEJL64YAl4RIEh7rK0RxaJMPRBW3kxQcNq2lMc8
         F/Ej5Y30KcnTzamSRY6erSJP9/XU83RHzdszwnVzMS3OpzIF59YWeXPNhqlOw/97aZII
         yREtzMsKhv2P+ov2xpkDhnUBc9uw+NeufMOiFVwXzREQJNp4yolXP2KPKA4xrpaWL+J1
         leYaia0jHXnscxZCErHQmRtchzL4jQx2Op9OHX4vo3bbYP/F7bx0ywYha3rShaGPbhV1
         s9PQ==
X-Gm-Message-State: AOAM532okZLwJeLHq4h6GqDEIUTR+kW4sO/B3o2O9QcRskgXh4BK6Y2p
        p/+QfVY07qJrG1s7lcPq1K0=
X-Google-Smtp-Source: ABdhPJwtm/FpMhE5IUQtkFdkq1baZ/izKbaB1jk8w2idglaWtrCgdK7UvWTcHrXVvjwJYCS65ylgAw==
X-Received: by 2002:ac8:6e87:: with SMTP id c7mr3089806qtv.62.1597934128406;
        Thu, 20 Aug 2020 07:35:28 -0700 (PDT)
Received: from ?IPv6:2601:282:803:7700:4452:db16:7f2f:e7bf? ([2601:282:803:7700:4452:db16:7f2f:e7bf])
        by smtp.googlemail.com with ESMTPSA id p26sm2393448qkm.23.2020.08.20.07.35.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 20 Aug 2020 07:35:27 -0700 (PDT)
Subject: Re: [RFC PATCH net-next 0/6] devlink: Add device metric support
To:     Jakub Kicinski <kuba@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>
Cc:     Ido Schimmel <idosch@idosch.org>, netdev@vger.kernel.org,
        davem@davemloft.net, jiri@nvidia.com, amcohen@nvidia.com,
        danieller@nvidia.com, mlxsw@nvidia.com, roopa@nvidia.com,
        andrew@lunn.ch, vivien.didelot@gmail.com, tariqt@nvidia.com,
        ayal@nvidia.com, mkubecek@suse.cz, Ido Schimmel <idosch@nvidia.com>
References: <20200817125059.193242-1-idosch@idosch.org>
 <20200818172419.5b86801b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <58a0356d-3e15-f805-ae52-dc44f265661d@gmail.com>
 <20200818203501.5c51e61a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <55e40430-a52f-f77b-0d1e-ef79386a0a53@gmail.com>
 <20200819091843.33ddd113@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <e4fd9b1c-5f7c-d560-9da0-362ddf93165c@gmail.com>
 <20200819110725.6e8744ce@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <d0c24aad-b7f3-7fd9-0b34-c695686e3a86@gmail.com>
Date:   Thu, 20 Aug 2020 08:35:25 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200819110725.6e8744ce@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/19/20 12:07 PM, Jakub Kicinski wrote:
> On Wed, 19 Aug 2020 10:20:08 -0700 Florian Fainelli wrote:
>>> I'm trying to find a solution which will not require a policeman to
>>> constantly monitor the compliance. Please see my effort to ensure
>>> drivers document and use the same ethtool -S stats in the TLS offload
>>> implementations. I've been trying to improve this situation for a long
>>> time, and it's getting old.  
>>
>> Which is why I am asking genuinely what do you think should be done
>> besides doing more code reviews? It does not seem to me that there is an
>> easy way to catch new stats being added with tools/scripts/whatever and
>> then determine what they are about, right?
> 
> I don't have a great way forward in mind, sadly. All I can think of is
> that we should try to create more well defined interfaces and steer
> away from free-form ones.

There is a lot of value in free-form too.

> 
> Example, here if the stats are vxlan decap/encap/error - we should
> expose that from the vxlan module. That way vxlan module defines one
> set of stats for everyone.
> 
> In general unless we attach stats to the object they relate to, we will
> end up building parallel structures for exposing statistics from the
> drivers. I posted a set once which was implementing hierarchical stats,
> but I've abandoned it for this reason.
> 
>>> Please focus on the stats this set adds, instead of fantasizing of what
>>> could be. These are absolutely not implementation specific!  
>>
>> Not sure if fantasizing is quite what I would use. I am just pointing
>> out that given the inability to standardize on statistics maybe we
>> should have namespaces and try our best to have everything fit into the
>> standard namespace along with a standard set of names, and push back
>> whenever we see vendor stats being added (or more pragmatically, ask
>> what they are). But maybe this very idea is moot.
> 
> IDK. I just don't feel like this is going to fly, see how many names
> people invented for the CRC error statistic in ethtool -S, even tho
> there is a standard stat for that! And users are actually parsing the
> output of ethtool -S to get CRC stats because (a) it became the go-to
> place for NIC stats and (b) some drivers forget to report in the
> standard place.
> 
> The cover letter says this set replaces the bad debugfs with a good,
> standard API. It may look good and standard for _vendors_ because they
> will know where to dump their counters, but it makes very little
> difference for _users_. If I have to parse names for every vendor I use,
> I can as well add a per-vendor debugfs path to my script.
> 
> The bar for implementation-specific driver stats has to be high.

My take away from this is you do not like the names - the strings side
of it.

Do you object to the netlink API? The netlink API via devlink?

'perf' has json files to describe and document counters
(tools/perf/pmu-events). Would something like that be acceptable as a
form of in-tree documentation of counters? (vs Documentation/networking
or URLs like
https://community.mellanox.com/s/article/understanding-mlx5-ethtool-counters)

> 
>>>>> If I have to download vendor documentation and tooling, or adapt my own
>>>>> scripts for every new vendor, I could have as well downloaded an SDK.    
>>>>
>>>> Are not you being a bit over dramatic here with your example?   
>>>
>>> I hope not. It's very hard/impossible today to run a fleet of Linux
>>> machines without resorting to vendor tooling.  
>>
>> Your argument was putting on the same level resorting to vendor tooling
>> to extract meaningful statistics/counters versus using a SDK to operate
>> the hardware (this is how I understood it), and I do not believe this is
>> fair.
> 
> Okay, fair. I just think that in datacenter deployments we are way
> closer to the SDK model than people may want to admit.
> 

I do not agree with that; the SDK model means you *must* use vendor code
to make something work. Your argument here is about labels for stats and
an understanding of their meaning.
