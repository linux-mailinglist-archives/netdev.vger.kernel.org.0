Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1814F24A4C8
	for <lists+netdev@lfdr.de>; Wed, 19 Aug 2020 19:20:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726689AbgHSRUT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Aug 2020 13:20:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725939AbgHSRUN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Aug 2020 13:20:13 -0400
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8264C061757
        for <netdev@vger.kernel.org>; Wed, 19 Aug 2020 10:20:12 -0700 (PDT)
Received: by mail-io1-xd43.google.com with SMTP id s1so12402560iot.10
        for <netdev@vger.kernel.org>; Wed, 19 Aug 2020 10:20:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=r0OUgYk4OvhINZfzJUNYWhWu5nUOxcsrZYjJQjHFQS8=;
        b=W/lslB15BWhJlTcEbXP9Mlj5xvtoNrIAAlw+6ztqe8TsFtmulZBlEuYJRhZTe4epEv
         o04cG0uj0PS7W7OiRgCqlr/TaC14SNk06jNc+gdpa4m1z2/dSILKOLJz9/NvYcIxFngV
         1/tsVfOiGa+feZ081WcoqbAmRWPkpPCBPZXDZBjRMblmTEyUAKa7XeJLiF4tgi1crd/X
         WroZtePULXMG44bmne7fqnpN4YpR7U4ibAOgQD5RKug9O5WptBsounKDNqY8j1QuPt9M
         yhXNzbAnVv8TAG57H1Fmhb1gBNq45Ukblffh91+8H1JkPjk9Rykf4EdGhnRc5vY19i4m
         pacA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=r0OUgYk4OvhINZfzJUNYWhWu5nUOxcsrZYjJQjHFQS8=;
        b=hpjDyUswk5FXkspEIVHO0wzk1aA0LqMyfAutMcpNDabtcPzm4rLaDWcbOe33FCOXpY
         DggbhW6SrIZv8hE8bitQEGnVvXXNQ1X7nKr408/ekliTUEGBOpHKh/y7Y4wX1p7k555+
         adsqrOaqEkHcJrDFeIjmr7qWYml5656h78rVmDuhKYpuSUPm096MF8IBuZfY712J+Xh1
         Hpa6wK3DdBYbmWCiXuQluWJlf0Eef50obp9PqqsG9qolXuxiyMoNpiVR3q4ZDfs88eeN
         uJ3lJ/cFXu6ijWvf9PtaFNRB4fnZ5sWk+kU56DX09fKTEYo7ggn7MN/+SAQwm6dDNqML
         Uw+g==
X-Gm-Message-State: AOAM533pAymd1USbG6tAij0rqPi7ipvOftFz9tJgOFiho/4A4bINi6Zj
        Q+JYbQaV/wXTuzbN1GM3EF7Aq52iIEY=
X-Google-Smtp-Source: ABdhPJwVGAYuoLSyXkNMx6cDh34RzKVQR7MknOPlSMVpmTdvYEGgiypAubnIIohULuZnXwbywkdYFQ==
X-Received: by 2002:a05:6602:2dc9:: with SMTP id l9mr21478929iow.154.1597857612005;
        Wed, 19 Aug 2020 10:20:12 -0700 (PDT)
Received: from [10.67.50.75] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id r3sm14166411iov.22.2020.08.19.10.20.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 19 Aug 2020 10:20:11 -0700 (PDT)
Subject: Re: [RFC PATCH net-next 0/6] devlink: Add device metric support
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     David Ahern <dsahern@gmail.com>, Ido Schimmel <idosch@idosch.org>,
        netdev@vger.kernel.org, davem@davemloft.net, jiri@nvidia.com,
        amcohen@nvidia.com, danieller@nvidia.com, mlxsw@nvidia.com,
        roopa@nvidia.com, andrew@lunn.ch, vivien.didelot@gmail.com,
        tariqt@nvidia.com, ayal@nvidia.com, mkubecek@suse.cz,
        Ido Schimmel <idosch@nvidia.com>
References: <20200817125059.193242-1-idosch@idosch.org>
 <20200818172419.5b86801b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <58a0356d-3e15-f805-ae52-dc44f265661d@gmail.com>
 <20200818203501.5c51e61a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <55e40430-a52f-f77b-0d1e-ef79386a0a53@gmail.com>
 <20200819091843.33ddd113@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Autocrypt: addr=f.fainelli@gmail.com; prefer-encrypt=mutual; keydata=
 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
 G10n8gCguORqNGMsVRxrlLs7/himep7MrCc=
Message-ID: <e4fd9b1c-5f7c-d560-9da0-362ddf93165c@gmail.com>
Date:   Wed, 19 Aug 2020 10:20:08 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200819091843.33ddd113@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/19/20 9:18 AM, Jakub Kicinski wrote:
> On Tue, 18 Aug 2020 21:30:16 -0700 Florian Fainelli wrote:
>>>>> I spend way too much time patrolling ethtool -S outputs already.  
>>>>
>>>> But that's the nature of detailed stats which are often essential to
>>>> ensuring the system is operating as expected or debugging some problem.
>>>> Commonality is certainly desired in names when relevant to be able to
>>>> build tooling around the stats.  
>>>
>>> There are stats which are clearly detailed and device specific,
>>> but what ends up happening is that people expose very much not
>>> implementation specific stats through the free form interfaces,
>>> because it's the easiest.
>>>
>>> And users are left picking up the pieces, having to ask vendors what
>>> each stat means, and trying to create abstractions in their user space
>>> glue.  
>>
>> Should we require vendors to either provide a Documentation/ entry for 
>> each statistics they have (and be guaranteed that it will be outdated 
>> unless someone notices), or would you rather have the statistics 
>> description be part of the devlink interface itself? Should we define 
>> namespaces such that standard metrics should be under the standard 
>> namespace and the vendor standard is the wild west?
> 
> I'm trying to find a solution which will not require a policeman to
> constantly monitor the compliance. Please see my effort to ensure
> drivers document and use the same ethtool -S stats in the TLS offload
> implementations. I've been trying to improve this situation for a long
> time, and it's getting old.

Which is why I am asking genuinely what do you think should be done
besides doing more code reviews? It does not seem to me that there is an
easy way to catch new stats being added with tools/scripts/whatever and
then determine what they are about, right?

> 
> Please focus on the stats this set adds, instead of fantasizing of what
> could be. These are absolutely not implementation specific!

Not sure if fantasizing is quite what I would use. I am just pointing
out that given the inability to standardize on statistics maybe we
should have namespaces and try our best to have everything fit into the
standard namespace along with a standard set of names, and push back
whenever we see vendor stats being added (or more pragmatically, ask
what they are). But maybe this very idea is moot.

> 
>>> If I have to download vendor documentation and tooling, or adapt my own
>>> scripts for every new vendor, I could have as well downloaded an SDK.  
>>
>> Are not you being a bit over dramatic here with your example? 
> 
> I hope not. It's very hard/impossible today to run a fleet of Linux
> machines without resorting to vendor tooling.

Your argument was putting on the same level resorting to vendor tooling
to extract meaningful statistics/counters versus using a SDK to operate
the hardware (this is how I understood it), and I do not believe this is
fair.

> 
>> At least  you can run the same command to obtain the stats regardless
>> of the driver and vendor, so from that perspective Linux continues to
>> be the abstraction and that is not broken.
> 
> Format of the data is no abstraction.
> 
-- 
Florian
