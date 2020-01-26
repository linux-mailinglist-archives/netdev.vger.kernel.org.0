Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 51C07149CE9
	for <lists+netdev@lfdr.de>; Sun, 26 Jan 2020 21:51:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727306AbgAZUvK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Jan 2020 15:51:10 -0500
Received: from mail-pg1-f195.google.com ([209.85.215.195]:38073 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726144AbgAZUvK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Jan 2020 15:51:10 -0500
Received: by mail-pg1-f195.google.com with SMTP id a33so4117859pgm.5
        for <netdev@vger.kernel.org>; Sun, 26 Jan 2020 12:51:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=rUw/EqpnMGXS7ks9XXUp/woOorHBS3ZbDbtLss8/gMU=;
        b=vne7v4ZKFHa1tBNfLlAHMqa64de9IV0lmrJUOpXunWXQfv5mmCadGuqOhfVr/USE3k
         fZws9bVoVUUeyETC1BryNzlOEpC9TL0+sDXlstYsH1hwnARFcNJnWYjx+2XlU4gx0/TY
         RhkOUsXxQrzVTLeHsOqnRxG/yLapQh6pHr0KSPwXVJWaGaEWPOl4oQU1r80lRIGW9pVf
         ichlacMxGYzTjRRoEJRp8ZBU9N0PU7/hKAvcShkZTLdotepYLI1+UHswT0hMXz+oEouB
         geLKhMgdJs1rmygEi02r1R3LrEK9+yzn3qxyQP/vWvLoVyALkI4sT2bJ7QoYSMiDaYqt
         BjOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=rUw/EqpnMGXS7ks9XXUp/woOorHBS3ZbDbtLss8/gMU=;
        b=Zob0Xdn+3O/h6NfIf9ic6trd8eEP3sOW5jMcbwGKkVYTqP+1obMFgFmoJGiqwxzoZ9
         OFZupb8Sr8acka+kXlv3nwfunKXxNEJWUARQgjtt22+FUQfkZlssXcwhrGnhihgxO1Oi
         vHqO4d9FDarAeJV2qUtV5yEJvELJu5kdyBh8AMAd6cGU4JaQ7olZBeFO+PpwkUy8acug
         dnkpI7x5a1esPRE0ZGV1PhON5TKUa0yTTTr6ltX6rlp4rGjgt8Pt5w0Rsy5tojfCP2kp
         3pr3cxxfuQE75bp/G7K+O8jUwnNW4oq2FnDTClaMeQSz8JM11GJC7oUAB8ZBFca9eC+A
         i9IQ==
X-Gm-Message-State: APjAAAWZtFN685ib209uqGQ3yXEOA4abBQJbtxhWTyCUYgx0r5DWBWx8
        Nl98QwZhjTRPbeXH/zYn315WQg==
X-Google-Smtp-Source: APXvYqycCLu07ZGvMXEA9kzZDZsTCycbKrXpO8bBxsZJlgc9FOG5ZS0NhsjlJODExjnsQ/3JhGQ81Q==
X-Received: by 2002:a63:63c3:: with SMTP id x186mr16011039pgb.294.1580071869725;
        Sun, 26 Jan 2020 12:51:09 -0800 (PST)
Received: from Shannons-MacBook-Pro.local (static-50-53-47-17.bvtn.or.frontiernet.net. [50.53.47.17])
        by smtp.gmail.com with ESMTPSA id l2sm13048140pjt.31.2020.01.26.12.51.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 26 Jan 2020 12:51:09 -0800 (PST)
Subject: Re: [PATCH net-next] net/core: Replace driver version to be kernel
 version
To:     Leon Romanovsky <leon@kernel.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Michal Kalderon <michal.kalderon@marvell.com>,
        linux-netdev <netdev@vger.kernel.org>,
        RDMA mailing list <linux-rdma@vger.kernel.org>
References: <20200123130541.30473-1-leon@kernel.org>
 <43d43a45-18db-f959-7275-63c9976fdf40@pensando.io>
 <20200126194110.GA3870@unreal>
From:   Shannon Nelson <snelson@pensando.io>
Message-ID: <67fa104b-8b0e-dd70-3cc3-04dd008639be@pensando.io>
Date:   Sun, 26 Jan 2020 12:52:05 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.3.1
MIME-Version: 1.0
In-Reply-To: <20200126194110.GA3870@unreal>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/26/20 11:41 AM, Leon Romanovsky wrote:
> On Sun, Jan 26, 2020 at 10:56:17AM -0800, Shannon Nelson wrote:
>> On 1/23/20 5:05 AM, Leon Romanovsky wrote:
>>> From: Leon Romanovsky<leonro@mellanox.com>
>>>
>>> In order to stop useless driver version bumps and unify output
>>> presented by ethtool -i, let's overwrite the version string.
>>>
>>> Before this change:
>>> [leonro@erver ~]$ ethtool -i eth0
>>> driver: virtio_net
>>> version: 1.0.0
>>> After this change:
>>> [leonro@server ~]$ ethtool -i eth0
>>> driver: virtio_net
>>> version: 5.5.0-rc6+
>>>
>>> Signed-off-by: Leon Romanovsky<leonro@mellanox.com>
>>> ---
>>> I wanted to change to VERMAGIC_STRING, but the output doesn't
>>> look pleasant to my taste and on my system is truncated to be
>>> "version: 5.5.0-rc6+ SMP mod_unload modve".
>>>
>>> After this patch, we can drop all those version assignments
>>> from the drivers.
>>>
>>> Inspired by nfp and hns code.
>>> ---
>>>    net/core/ethtool.c | 3 +++
>>>    1 file changed, 3 insertions(+)
>>>
>>> diff --git a/net/core/ethtool.c b/net/core/ethtool.c
>>> index cd9bc67381b2..3c6fb13a78bf 100644
>>> --- a/net/core/ethtool.c
>>> +++ b/net/core/ethtool.c
>>> @@ -17,6 +17,7 @@
>>>    #include <linux/phy.h>
>>>    #include <linux/bitops.h>
>>>    #include <linux/uaccess.h>
>>> +#include <linux/vermagic.h>
>>>    #include <linux/vmalloc.h>
>>>    #include <linux/sfp.h>
>>>    #include <linux/slab.h>
>>> @@ -776,6 +777,8 @@ static noinline_for_stack int ethtool_get_drvinfo(struct net_device *dev,
>>>    		return -EOPNOTSUPP;
>>>    	}
>>>
>>> +	strlcpy(info.version, UTS_RELEASE, sizeof(info.version));
>>> +
>>>    	/*
>>>    	 * this method of obtaining string set info is deprecated;
>>>    	 * Use ETHTOOL_GSSET_INFO instead.
>>> --
>>> 2.20.1
>>>
>> First of all, although I've seen some of the arguments about distros and
>> their backporting, I still believe that the driver version number is
>> useful.  In most cases it at least gets us in the ballpark of what
>> generation the driver happens to be and is still useful. I'd really prefer
>> that it is just left alone for the device manufactures and their support
>> folks to deal with.
>>
>> Fine, I'm sure I lose that argument since there's already been plenty of
>> discussion about it.
>>
>> Meanwhile, there is some non-zero number of support scripts and processes,
>> possibly internal testing chains, that use that driver/vendor specific
>> version information and will be broken by this change.  Small number?  Large
>> number?  I don't know, but we're breaking them.
>>
>> Sure, I probably easily lose that argument too, but it still should be
>> stated.
>>
>> This will end up affecting out-of-tree drivers as well, where it is useful
>> to know what the version number is, most especially since it is different
>> from what the kernel provided driver is.  How else are we to get this
>> information out to the user?  If this feature gets squashed, we'll end up
>> having to abuse some other mechanism so we can get the live information from
>> the driver, and probably each vendor will find a different way to sneak it
>> out, giving us more chaos than where we started.  At least the ethtool
>> version field is a known and consistent place for the version info.
>>
>> Of course, out-of-tree drivers are not first class citizens, so I probably
>> lose that argument as well.
>>
>> So if you are so all fired up about not allowing the drivers to report their
>> own version number, then why report anything at all? Maybe just report a
>> blank field.  As some have said, the uname info is already available else
>> where, why are we sticking it here?
>>
>> Personally, I think this is a rather arbitrary, heavy handed and unnecessary
>> slam on the drivers, and will make support more difficult in the long run.
> The thing is that leaving this field as empty, for sure will break all
> applications. I have a feeling that it can be close to 100% hit rate.
> So, kernel version was chosen as an option, because it is already
> successfully in use by at least two drivers (nfp and hns).

I'm glad that works for those drivers.

> Leaving to deal with driver version to vendors is not an option too,
> because they prove for more than once that they are not capable to
> define user visible interfaces. It comes due to their natural believe
> that their company is alone in the world and user visible interface
> should be suitable for them only.

So you want to remove the one reliable place to put some information we 
find useful, thus forcing us to come up with creative new places to put 
it?  Shall we remove the firmware version number as well when we start 
abusing it by adding driver version information?

There has been a lot of work over the years to try to corral and unify 
various bits of information so that everyone can access it the same way, 
and now you're trying to remove one of those methods. This will only 
force driver writers to get "creative" on how to get the info they need 
out to the user.

> It is already impossible for users to distinguish properly versions
> of different vendors, because they use arbitrary strings with some
> numbers.

Shall we also fix it so those pesky distros can't add their own 
arbitrary version numbers to the kernel?

Again, I think you are trying to remove a useful bit of information.  
Just because it isn't useful to you doesn't mean it is useless to others.

sln

