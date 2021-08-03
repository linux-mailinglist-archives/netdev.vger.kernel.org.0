Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 426C83DF6EA
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 23:32:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232530AbhHCVcl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 17:32:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232478AbhHCVck (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Aug 2021 17:32:40 -0400
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF243C061757;
        Tue,  3 Aug 2021 14:32:27 -0700 (PDT)
Received: by mail-wm1-x32f.google.com with SMTP id i10-20020a05600c354ab029025a0f317abfso2611379wmq.3;
        Tue, 03 Aug 2021 14:32:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Cp/Mg8kbczj/nva5wsI/8lR2Wb55mtDxzql35OSy1zs=;
        b=tLNW2vOw3q+NbTSiKdqyiPn8XOOfWXupWlz23KwUU1Jh/W08Pk/dPnDQdlPzUQYG3j
         MHd7L7FLF4alPADlE/pDey41PJQFTSX/C1YshSdxUyzywqqPX9adxSKWtbSOlIk16amP
         iuyNdt4FmQA1AiwgpkazbtvNQkY4OC7ypU5xiUmqEXZPYA25cv4l23bBYkOfYfN9Qb+N
         4qF38F5SWJNRF28uCecDWZNqCfAViXhNWLUlGlRDpniyMQu/B/zHE41psstUgyAl7Bwv
         URpHibNE7cElMayj3pI5oOfjRcL2TvNXOs9yUxMoqAzv8bCLY0eqjsGZOdDMVRPlkx4D
         cl2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Cp/Mg8kbczj/nva5wsI/8lR2Wb55mtDxzql35OSy1zs=;
        b=bgNPNcI38bJEZeY0MNUsvv2qhv0qLEhsMHLn99pwJlj/tpIFW7AgwnWGw0hZf2ijFy
         YLggsQ/FHFLDnPo6Esolmj6+fcBm7uebFkxcFXvQSVuSq48sjVgSAbv90J+qFBhq/4LV
         3cN+U92NRlBwch1Idfm+yZbQhGeywVUi3J/qQCaY/+JsDignc0+/iZhVnQtb2YY0gtHS
         E7XTC3mOBTWp0HogTa4wis5BWZkw7HB7a7J7HWlNWQd9RfCp1da2EuL2eOCFAHsqgb6N
         PKz91QuQDBGszM1w0OM7hFBHxt+7pYI4dsiV3/WnZJKgS9up90f0RtdJDAcbQJBprOt3
         Rspw==
X-Gm-Message-State: AOAM530Iy/KyDQPzvW5M6FyQw+Jh7Js292bCcQBhLZPyQ9ZuQj+Un08Y
        a4W8l6Fg1NSDneX7s4ixPVr90/MhI8+9iA==
X-Google-Smtp-Source: ABdhPJyv7wCUh3C57TObq74JSIm5t48705qxWbLm9f7roatfLFb13+BeOhzeafzsjZN5CMwLeyidtA==
X-Received: by 2002:a05:600c:4657:: with SMTP id n23mr24012034wmo.46.1628026346228;
        Tue, 03 Aug 2021 14:32:26 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f10:c200:1168:dd9:b693:a674? (p200300ea8f10c20011680dd9b693a674.dip0.t-ipconnect.de. [2003:ea:8f10:c200:1168:dd9:b693:a674])
        by smtp.googlemail.com with ESMTPSA id g11sm102434wrd.97.2021.08.03.14.32.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Aug 2021 14:32:25 -0700 (PDT)
To:     Grygorii Strashko <grygorii.strashko@ti.com>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>
References: <106547ef-7a61-2064-33f5-3cc8d12adb34@gmail.com>
 <cb44d295-5267-48a7-b7c7-e4bf5b884e7a@gmail.com>
 <b4744988-4463-6463-243a-354cd87c4ced@ti.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH net-next 1/4] ethtool: runtime-resume netdev parent before
 ethtool ioctl ops
Message-ID: <75bdf142-f5f4-9a98-bf85-ac2cbbf1179b@gmail.com>
Date:   Tue, 3 Aug 2021 23:32:18 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <b4744988-4463-6463-243a-354cd87c4ced@ti.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 03.08.2021 22:41, Grygorii Strashko wrote:
> 
> 
> On 01/08/2021 13:36, Heiner Kallweit wrote:
>> If a network device is runtime-suspended then:
>> - network device may be flagged as detached and all ethtool ops (even if not
>>    accessing the device) will fail because netif_device_present() returns
>>    false
>> - ethtool ops may fail because device is not accessible (e.g. because being
>>    in D3 in case of a PCI device)
>>
>> It may not be desirable that userspace can't use even simple ethtool ops
>> that not access the device if interface or link is down. To be more friendly
>> to userspace let's ensure that device is runtime-resumed when executing the
>> respective ethtool op in kernel.
>>
>> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
>> ---
>>   net/ethtool/ioctl.c | 18 +++++++++++++++---
>>   1 file changed, 15 insertions(+), 3 deletions(-)
>>
>> diff --git a/net/ethtool/ioctl.c b/net/ethtool/ioctl.c
>> index baa5d1004..b7ff9abe7 100644
>> --- a/net/ethtool/ioctl.c
>> +++ b/net/ethtool/ioctl.c
>> @@ -23,6 +23,7 @@
>>   #include <linux/rtnetlink.h>
>>   #include <linux/sched/signal.h>
>>   #include <linux/net.h>
>> +#include <linux/pm_runtime.h>
>>   #include <net/devlink.h>
>>   #include <net/xdp_sock_drv.h>
>>   #include <net/flow_offload.h>
>> @@ -2589,7 +2590,7 @@ int dev_ethtool(struct net *net, struct ifreq *ifr)
>>       int rc;
>>       netdev_features_t old_features;
>>   -    if (!dev || !netif_device_present(dev))
>> +    if (!dev)
>>           return -ENODEV;
>>         if (copy_from_user(&ethcmd, useraddr, sizeof(ethcmd)))
>> @@ -2645,10 +2646,18 @@ int dev_ethtool(struct net *net, struct ifreq *ifr)
>>               return -EPERM;
>>       }
>>   +    if (dev->dev.parent)
>> +        pm_runtime_get_sync(dev->dev.parent);
> 
> the PM Runtime should allow to wake up parent when child is resumed if everything is configured properly.
> 
Not sure if there's any case yet where the netdev-embedded device is power-managed.
Typically only the parent (e.g. a PCI device) is.

> rpm_resume()
> ...
>     if (!parent && dev->parent) {
>  --> here
> 
Currently we don't get that far because we will bail out here already:

else if (dev->power.disable_depth > 0)
		retval = -EACCES;

If netdev-embedded device isn't power-managed then disable_depth is 1.

> So, hence PM runtime calls are moved to from drivers to net_core wouldn't be more correct approach to
> enable PM runtime for netdev->dev and lets PM runtime do the job?
> 
Where would netdev->dev be runtime-resumed so that netif_device_present() passes?
Wouldn't we then need RPM ops for the parent (e.g. PCI) and for netdev->dev?
E.g. the parent runtime-resume can be triggered by a PCI PME, then it would
have to resume netdev->dev.

> But, to be honest, I'm not sure adding PM runtime manipulation to the net core is a good idea -

The TI CPSW driver runtime-resumes the device in begin ethtool op and suspends
it in complete. This pattern is used in more than one driver and may be worth
being moved to the core.

> at minimum it might be tricky and required very careful approach (especially in err path).
> For example, even in this patch you do not check return value of pm_runtime_get_sync() and in
> commit bd869245a3dc ("net: core: try to runtime-resume detached device in __dev_open") also actualy.

The pm_runtime_get_sync() calls are attempts here. We don't want to bail out if a device
doesn't support RPM. I agree that checking the return code could make sense, but then we would
have to be careful which error codes we consider as failed.

> 
> 
> The TI CPSW driver may also be placed in non reachable state when netdev is closed (and even lose context),
> but we do not use netif_device_detach() (so netdev is accessible through netdev_ops/ethtool_ops),
> but instead wake up device by runtime PM for allowed operations or just save requested configuration which
> is applied at netdev->open() time then.
> I feel that using netif_device_detach() in PM runtime sounds like a too heavy approach ;)
> 
That's not a rare pattern when suspending or runtime-suspending to prevent different types
of access to a not accessible device. But yes, it's relatively big hammer ..

> huh, see it's merged already, so...
> 
>> +
>> +    if (!netif_device_present(dev)) {
>> +        rc = -ENODEV;
>> +        goto out;
>> +    }
>> +
>>       if (dev->ethtool_ops->begin) {
>>           rc = dev->ethtool_ops->begin(dev);
>> -        if (rc  < 0)
>> -            return rc;
>> +        if (rc < 0)
>> +            goto out;
>>       }
>>       old_features = dev->features;
>>   @@ -2867,6 +2876,9 @@ int dev_ethtool(struct net *net, struct ifreq *ifr)
>>         if (old_features != dev->features)
>>           netdev_features_change(dev);
>> +out:
>> +    if (dev->dev.parent)
>> +        pm_runtime_put(dev->dev.parent);
>>         return rc;
>>   }
>>
> 

