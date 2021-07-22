Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4323F3D1C89
	for <lists+netdev@lfdr.de>; Thu, 22 Jul 2021 05:52:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230390AbhGVDMQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Jul 2021 23:12:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229900AbhGVDMP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Jul 2021 23:12:15 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2234C061575;
        Wed, 21 Jul 2021 20:52:50 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id jx7-20020a17090b46c7b02901757deaf2c8so3681021pjb.0;
        Wed, 21 Jul 2021 20:52:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=MsrIEXBG2MXpg2Ixffs8oOP+CXS/zrxslRWb7KTsb1I=;
        b=u68b+fXkPvyfMOMMZ5ZPJBIzW6BCtJOOws+ctggEnJnUq6fvV9r27KiohANRGg22jQ
         aiJ+TNNKIj04lUWZQjYtpfGx4UwfyZ+e6Yrt+oNvnObnZFuqx3kIbFaRZa3RrGrXH7oy
         14Cru7B397kbglzS0rrdnndWzRzM38ZGCgYu9ZEkW7ABOwyL4+O/9eWwVqJUt+V5L627
         1x1hIclihym6ud9oCs8jQekXZNXh+Jwyv+StBOAxjMADis81pi+sAGHG7KsJDS/Vfzgt
         JeUUkPShGiED6Wa2sJYyzlkXRETobez6nhHRYSZ4zsNDfw/fby/uSYC6PLj/w2QUdSZi
         9uIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=MsrIEXBG2MXpg2Ixffs8oOP+CXS/zrxslRWb7KTsb1I=;
        b=CzNxUnExzID094MpGymXYKDTC/dZWfe5ZxmRwABPULpeOaRb8e08hexpA7wTbTyLyF
         fIif7/OzR9b2kxONJ9u7qhoVxHC54zPh/0RebBOYR1KvbfmnTbF4ncb4deifnHJixA7X
         WgH6uW/4i9cfSn7eoynDUFptnp5mroPmCI+tzHti3yLQBA4ooybvHnsPWtTwncIbsnHz
         31QZKX8IpvS7ayjPSfHcMKIMtC4JJDy/pfBsZA6NIvKGRLefC5OPbFgzmfc9QwbfaY3V
         NUaBpJkcCuwzkCWRYAgVWT9urar7yqNL8vUjvyDp7PMZp2fihhTKr5oLae/T/pYDUCBx
         TLkg==
X-Gm-Message-State: AOAM533VQldJMkNhwaMXQEDOicSbcaVNT6LwSVcl21G2A+4WpfStrSR3
        5+RaTQ8LBZVH3KK1iDkdqGnnL8DIa9U=
X-Google-Smtp-Source: ABdhPJwnSbg9tw7Op5Wd2FzeFqdoQPJshpinCJo+Gh0JaTNeg/HmUlg3t7y/u58TweDWh1dqBelVIQ==
X-Received: by 2002:a65:62da:: with SMTP id m26mr39062373pgv.370.1626925968746;
        Wed, 21 Jul 2021 20:52:48 -0700 (PDT)
Received: from [10.230.31.46] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id il2sm11232373pjb.29.2021.07.21.20.52.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 21 Jul 2021 20:52:48 -0700 (PDT)
Subject: Re: [PATCH net-next 5/5] igc: Export LEDs
To:     =?UTF-8?Q?Marek_Beh=c3=ban?= <kabel@kernel.org>,
        Andrew Lunn <andrew@lunn.ch>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Pavel Machek <pavel@ucw.cz>,
        Tony Nguyen <anthony.l.nguyen@intel.com>, davem@davemloft.net,
        kuba@kernel.org, Kurt Kanzenbach <kurt@linutronix.de>,
        netdev@vger.kernel.org, sasha.neftin@intel.com,
        vitaly.lifshits@intel.com, vinicius.gomes@intel.com,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Dvora Fuxbrumer <dvorax.fuxbrumer@linux.intel.com>,
        "linux-leds@vger.kernel.org" <linux-leds@vger.kernel.org>
References: <20210716212427.821834-1-anthony.l.nguyen@intel.com>
 <20210716212427.821834-6-anthony.l.nguyen@intel.com>
 <f705bcd6-c55c-0b07-612f-38348d85bbee@gmail.com> <YPTKB0HGEtsydf9/@lunn.ch>
 <88d23db8-d2d2-5816-6ba1-3bd80738c398@gmail.com> <YPbu8xOFDRZWMTBe@lunn.ch>
 <3b7ad100-643e-c173-0d43-52e65d41c8c3@gmail.com>
 <20210721204543.08e79fac@thinkpad> <YPh6b+dTZqQNX+Zk@lunn.ch>
 <20210721220716.539f780e@thinkpad>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <484e00c7-e76b-08a6-f247-b2f6e8302d9c@gmail.com>
Date:   Wed, 21 Jul 2021 20:52:37 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210721220716.539f780e@thinkpad>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/21/2021 1:07 PM, Marek Behún wrote:
> On Wed, 21 Jul 2021 21:50:07 +0200
> Andrew Lunn <andrew@lunn.ch> wrote:
> 
>>> Hi Heiner,
>>>
>>> in sysfs, all devices registered under LED class will have symlinks in
>>> /sys/class/leds. This is how device classes work in Linux.
>>>
>>> There is a standardized format for LED device names, please look at
>>> Documentation/leds/leds-class.rst.
>>>
>>> Basically the LED name is of the format
>>>    devicename:color:function
>>
>> The interesting part here is, what does devicename mean, in this
>> context?
>>
>> We cannot use the interface name, because it is not unique, and user
>> space can change it whenever it wants. So we probably need to build
>> something around the bus ID, e.g. pci_id. Which is not very friendly
>> :-(
> 
> Unfortunately there isn't consensus about what the devicename should
> mean. There are two "schools of thought":
> 
> 1. device name of the trigger source for the LED, i.e. if the LED
>     blinks on activity on mmc0, the devicename should be mmc0. We have
>     talked about this in the discussions about ethernet PHYs.
>     In the case of the igc driver if the LEDs are controlled by the MAC,
>     I guess some PCI identifier would be OK. Or maybe ethernet-mac
>     identifier, if we have something like that? (Since we can't use
>     interface names due to the possibility of renaming.)
> 
>     Pavel and I are supporters of this scheme.
> 
> 2. device name of the LED controller. For example LEDs controlled by
>     the maxim,max77650-led controller (leds-max77650.c) define device
>     name as "max77650"
> 
>     Jacek supports this scheme.
> 
> The complication is that both these schemes are used already in
> upstream kernel, and we have to maintain backwards compatibility of
> sysfs ABI, so we can't change that.
> 
> I have been thinking for some time that maybe we should poll Linux
> kernel developers about these two schemes, so that a consensus is
> reached. Afterwards we can deprecate the other scheme and add a Kconfig
> option (default n for backwards compatibility) to use the new scheme.
> 
> What do you think?

FWIW, dev_name() should be the "devicename" from what you described 
above. This is foundational property for all devices that Linux 
registers that is used for logging, name spacing within /sys/, uniqe, 
ABI stable, etc. Anything different would be virtually impossible to 
maintain and would lead to ABI breakage down the road, guaranteed.

Yes it can be long (especially with PCI devices), and unfriendly, but 
hey, udev to the rescue then, rename based on user preferences.
-- 
Florian
