Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FB4445E8EA
	for <lists+netdev@lfdr.de>; Fri, 26 Nov 2021 08:58:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353168AbhKZIBt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Nov 2021 03:01:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243068AbhKZH7r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Nov 2021 02:59:47 -0500
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1D21C061746
        for <netdev@vger.kernel.org>; Thu, 25 Nov 2021 23:55:24 -0800 (PST)
Received: by mail-wm1-x329.google.com with SMTP id y196so7354624wmc.3
        for <netdev@vger.kernel.org>; Thu, 25 Nov 2021 23:55:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language
         :references:to:cc:from:in-reply-to:content-transfer-encoding;
        bh=7K++LkXsS6XgS3HT0eqv9aGIP5739ED6kh0pSpSWAKE=;
        b=cLsRPOZGNQmTLpFLGhcLM9wlVmW5s8UuYvlh3iG/F/UpLsrHa5vwpnt7BTap35zOTq
         UTfgyHFekh/71hmXPoo1uhTl9i6SqN1W7efdPSvw8xf1QoOUvh9H4Kqe3xczqs1l0weg
         8FFxyXbww6upmsN3Z9Xl13WB1hP49RexDxLlaw9IC/vLL3G52W+MGRXKPrmOD/TVtftL
         +TfZhEw8N8rqfBq0PhvnTAOHUOcZOpZMlDc519ZG7BNY2ocfWRVRMwY4INJJLsTUTSx1
         LutEQnvmpx6G0pO2PpwU9EuFWITm0A1cQauzE6bI406lV/mJYRavqiDz3SC4jgWUkPcX
         LuNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:references:to:cc:from:in-reply-to
         :content-transfer-encoding;
        bh=7K++LkXsS6XgS3HT0eqv9aGIP5739ED6kh0pSpSWAKE=;
        b=GbHsjexxWYvGnX/38aVX/+i4bJVz5wTd9CgYNXzfDAegsOH5bmjGscT9W/aqN7Nz4I
         MPlJiMBZfHp0/co6xt2mP8PYXmIrGkrVK73g1unK/W/BBdylmy5MSIqLmSUyDMpTPdQs
         VyFhQWsJqI9Gs0MCCnO5581doKzShKFCKVAiuUQjz8QNahzd0Hs+YaWXgUUy4MhfVByP
         bhHzhPbxzb+a26JA18NGa5MRlU8UnFw76z22u/u2YlQJWFsqY+AOPuxhBH2c7tZjB4Yd
         hcSxX1setQhJAxvvv0g7AFljytvyyZmeyOGWPYt7mnOY9CcXUfyqM/AtBHwirtnIJ4ar
         f+xw==
X-Gm-Message-State: AOAM533Ytm7vj0PnFH7h6AtBZUkkTFst8bU59vlD3Ta7uijhRUeu7K+x
        vuX986e6A6VZAergMfdzrXY=
X-Google-Smtp-Source: ABdhPJyNJmdQLM0lI8ozgQNbn+3u1XiUlyMuee6QQ0sQ8PqHB8iu5Bp84hTOP8n6LZZETJlGC1aRkQ==
X-Received: by 2002:a1c:8:: with SMTP id 8mr13659175wma.106.1637913323396;
        Thu, 25 Nov 2021 23:55:23 -0800 (PST)
Received: from ?IPV6:2003:ea:8f1a:f00:eda0:b7b0:4339:bfa2? (p200300ea8f1a0f00eda0b7b04339bfa2.dip0.t-ipconnect.de. [2003:ea:8f1a:f00:eda0:b7b0:4339:bfa2])
        by smtp.googlemail.com with ESMTPSA id x4sm9718614wmi.3.2021.11.25.23.55.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 25 Nov 2021 23:55:23 -0800 (PST)
Message-ID: <131f97e4-f11b-2280-beb5-55d8a0570d20@gmail.com>
Date:   Fri, 26 Nov 2021 08:55:17 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.2
Subject: Fwd: [Bug 215129] New: Linux kernel hangs during power down
Content-Language: en-US
References: <4a28ad86-1b1e-ab51-2351-efdd6caf8e1d@gmail.com>
To:     Vinicius Costa Gomes <vinicius.gomes@intel.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>
From:   Heiner Kallweit <hkallweit1@gmail.com>
In-Reply-To: <4a28ad86-1b1e-ab51-2351-efdd6caf8e1d@gmail.com>
X-Forwarded-Message-Id: <4a28ad86-1b1e-ab51-2351-efdd6caf8e1d@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

FYI

That's what Jakub was just referring to.

-------- Forwarded Message --------
Subject: Re: [Bug 215129] New: Linux kernel hangs during power down
Date: Thu, 25 Nov 2021 22:11:16 +0100
From: Heiner Kallweit <hkallweit1@gmail.com>
To: Jakub Kicinski <kuba@kernel.org>, Jesse Brandeburg <jesse.brandeburg@intel.com>, Tony Nguyen <anthony.l.nguyen@intel.com>, intel-wired-lan <intel-wired-lan@lists.osuosl.org>, Kalle Valo <kvalo@codeaurora.org>
CC: netdev@vger.kernel.org, ath10k@lists.infradead.org, Stephen Hemminger <stephen@networkplumber.org>

On 25.11.2021 08:32, Heiner Kallweit wrote:
> On 25.11.2021 01:46, Jakub Kicinski wrote:
>> Adding Kalle and Hainer.
>>
>> On Wed, 24 Nov 2021 14:45:05 -0800 Stephen Hemminger wrote:
>>> Begin forwarded message:
>>>
>>> Date: Wed, 24 Nov 2021 21:14:53 +0000
>>> From: bugzilla-daemon@bugzilla.kernel.org
>>> To: stephen@networkplumber.org
>>> Subject: [Bug 215129] New: Linux kernel hangs during power down
>>>
>>>
>>> https://bugzilla.kernel.org/show_bug.cgi?id=215129
>>>
>>>             Bug ID: 215129
>>>            Summary: Linux kernel hangs during power down
>>>            Product: Networking
>>>            Version: 2.5
>>>     Kernel Version: 5.15
>>>           Hardware: All
>>>                 OS: Linux
>>>               Tree: Mainline
>>>             Status: NEW
>>>           Severity: normal
>>>           Priority: P1
>>>          Component: Other
>>>           Assignee: stephen@networkplumber.org
>>>           Reporter: martin.stolpe@gmail.com
>>>         Regression: No
>>>
>>> Created attachment 299703
>>>   --> https://bugzilla.kernel.org/attachment.cgi?id=299703&action=edit    
>>> Kernel log after timeout occured
>>>
>>> On my system the kernel is waiting for a task during shutdown which doesn't
>>> complete.
>>>
>>> The commit which causes this behavior is:
>>> [f32a213765739f2a1db319346799f130a3d08820] ethtool: runtime-resume netdev
>>> parent before ethtool ioctl ops
>>>
>>> This bug causes also that the system gets unresponsive after starting Steam:
>>> https://steamcommunity.com/app/221410/discussions/2/3194736442566303600/
>>>
>>
> 
> I think the reference to ath10k_pci is misleading, Kalle isn't needed here.
> The actual issue is a RTNL deadlock in igb_resume(). See log snippet:
> 
> Nov 24 18:56:19 MartinsPc kernel:  igb_resume+0xff/0x1e0 [igb 21bf6a00cb1f20e9b0e8434f7f8748a0504e93f8]
> Nov 24 18:56:19 MartinsPc kernel:  pci_pm_runtime_resume+0xa7/0xd0
> Nov 24 18:56:19 MartinsPc kernel:  ? pci_pm_freeze_noirq+0x110/0x110
> Nov 24 18:56:19 MartinsPc kernel:  __rpm_callback+0x41/0x120
> Nov 24 18:56:19 MartinsPc kernel:  ? pci_pm_freeze_noirq+0x110/0x110
> Nov 24 18:56:19 MartinsPc kernel:  rpm_callback+0x35/0x70
> Nov 24 18:56:19 MartinsPc kernel:  rpm_resume+0x567/0x810
> Nov 24 18:56:19 MartinsPc kernel:  __pm_runtime_resume+0x4a/0x80
> Nov 24 18:56:19 MartinsPc kernel:  dev_ethtool+0xd4/0x2d80
> 
> We have at least two places in net core where runtime_resume() is called
> under RTNL. This conflicts with the current structure in few Intel drivers
> that have something like the following in their resume path.
> 
> 	rtnl_lock();
> 	if (!err && netif_running(netdev))
> 		err = __igb_open(netdev, true);
> 
> 	if (!err)
> 		netif_device_attach(netdev);
> 	rtnl_unlock();
> 
> Other drivers don't do this, so it's the question whether it's actually
> needed here to take RTNL. Some discussion was started [0], but it ended
> w/o tangible result and since then it has been surprisingly quiet.
> 
> [0] https://www.spinics.net/lists/netdev/msg736880.html
> 

I think the problem with runtime_resume() taking RTNL could also hit
the driver internally. See following call chain: If this would ever
be called when the device is runtime-suspended, then a similar
deadlock would occur.

__dev_open()    - called with RTNL held
  igb_open()
    __igb_open()   - arg resuming is false
      if (!resuming)
        pm_runtime_get_sync(&pdev->dev);
          igb_resume()
            rtnl_lock()
