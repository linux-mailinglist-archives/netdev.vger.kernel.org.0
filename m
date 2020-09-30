Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96E0327F302
	for <lists+netdev@lfdr.de>; Wed, 30 Sep 2020 22:11:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728031AbgI3ULM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Sep 2020 16:11:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725355AbgI3ULM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Sep 2020 16:11:12 -0400
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BC1BC061755
        for <netdev@vger.kernel.org>; Wed, 30 Sep 2020 13:11:11 -0700 (PDT)
Received: by mail-ej1-x642.google.com with SMTP id qp15so3760891ejb.3
        for <netdev@vger.kernel.org>; Wed, 30 Sep 2020 13:11:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=8H7K4d8p2+OQGBFgvRXwol6gpw/pB3hlATDuq4c4vnc=;
        b=VPjgtuYJhli8MjJAiiOkUn7VAFWVudHH8/u1x0w5C/bjdNFDen0zGdm7ZA8F+a91Wq
         MmcMJfjBzL8OfFf2txgRG46zlDCWeJrMhLQY/ksegdyIBGoBtc4M1atRn1V+oMSucMuS
         VM6zW9WwovzeJXErvUxcS0jhPVkkhspETIGQD1/A13mC/607EPWHqBdcg/FQ65bhlBc5
         SvVMhOneZqvN+pvrZ5MHPRp+bRXDhEpNK96/9NQg3ttaovtynNsPUTaLfgRkRsA2wUox
         NrtGli+9Iu8RFizIdDd8bfbX8exc/iwc5L6TOD2/Cs7Kfaa2ZZzXcPnvZYSn7cv3aN9S
         xQzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=8H7K4d8p2+OQGBFgvRXwol6gpw/pB3hlATDuq4c4vnc=;
        b=Lpmug4c5PF0MpASVq2nsHOKJAFupTFeXrhgD92fxuywsk05YYjmFEvzn85adUGNpXe
         b3ZH+WkPP37oQ9crojT3InOfyHi6tjcv5wHMHNVcfRe8vyuRlzUdWfjAST5xqiYl/oEH
         LDJsPnK1SFg5CmZY3jQYz2NQjb5mWC8uOngXbgBDjQM/TXiIVvdKyGeSY6wOkqfEeNIX
         d61TxFr7q7h+p9WZ8LXEWnhivGbK/hXOkCUOLkT6nQl931xi5aLMq98fpa5s7iWDK5mk
         bnjjFJmfWYRKJ6E3CfxKKu4gy/z95fjUdLhztNipgURJI0oiYJDncmOs3wPAK18Z8xL9
         bW3A==
X-Gm-Message-State: AOAM530TfJBd3/ItH1He0URFG0rwmF1k39u8TuI/9CHEmPgpdFH//yiE
        6aQB9/R4DKulquZHT5uPVc95HPy7JF8=
X-Google-Smtp-Source: ABdhPJyU5LPS0PrSBE57hJu67Llk3iJxfHYYUGaQKe4WwCniQFqFQwAIXBZCKBmIiMpSJnd0dzI6+A==
X-Received: by 2002:a17:906:71c9:: with SMTP id i9mr4542955ejk.250.1601496669423;
        Wed, 30 Sep 2020 13:11:09 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f00:6a00:814c:b08d:e987:8b78? (p200300ea8f006a00814cb08de9878b78.dip0.t-ipconnect.de. [2003:ea:8f00:6a00:814c:b08d:e987:8b78])
        by smtp.googlemail.com with ESMTPSA id nm7sm2346071ejb.70.2020.09.30.13.11.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Sep 2020 13:11:08 -0700 (PDT)
Subject: Re: RTL8402 stops working after hibernate/resume
To:     Petr Tesarik <ptesarik@suse.cz>
Cc:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        netdev@vger.kernel.org
References: <20200715102820.7207f2f8@ezekiel.suse.cz>
 <20200716105835.32852035@ezekiel.suse.cz>
 <e1c7a37f-d8d0-a773-925c-987b92f12694@gmail.com>
 <20200903104122.1e90e03c@ezekiel.suse.cz>
 <7e6bbb75-d8db-280d-ac5b-86013af39071@gmail.com>
 <20200924211444.3ba3874b@ezekiel.suse.cz>
 <a10f658b-7fdf-2789-070a-83ad5549191a@gmail.com>
 <20200925093037.0fac65b7@ezekiel.suse.cz>
 <20200925105455.50d4d1cc@ezekiel.suse.cz>
 <aa997635-a5b5-75e3-8a30-a77acb2adf35@gmail.com>
 <20200925115241.3709caf6@ezekiel.suse.cz>
 <20200925145608.66a89e73@ezekiel.suse.cz>
 <30969885-9611-06d8-d50a-577897fcab29@gmail.com>
 <20200929210737.7f4a6da7@ezekiel.suse.cz>
 <217ae37d-f2b0-1805-5696-11644b058819@redhat.com>
 <5f2d3d48-9d1d-e9fe-49bc-d1feeb8a92eb@gmail.com>
 <1c2d888a-5702-cca9-195c-23c3d0d936b9@redhat.com>
 <8a82a023-e361-79db-7127-769e4f6e0d1b@gmail.com>
 <20200930184124.68a86b1d@ezekiel.suse.cz>
 <20200930193231.205ee7bd@ezekiel.suse.cz>
 <20200930200027.3b512633@ezekiel.suse.cz>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <2e91f3b7-b675-e117-2200-e97b089e9996@gmail.com>
Date:   Wed, 30 Sep 2020 22:11:02 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20200930200027.3b512633@ezekiel.suse.cz>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 30.09.2020 20:00, Petr Tesarik wrote:
> Hi Heiner again,
> 
> On Wed, 30 Sep 2020 19:32:59 +0200
> Petr Tesarik <ptesarik@suse.cz> wrote:
> 
>> Hi Heiner,
>>
>> On Wed, 30 Sep 2020 18:41:24 +0200
>> Petr Tesarik <ptesarik@suse.cz> wrote:
>>
>>> HI Heiner,
>>>
>>> On Wed, 30 Sep 2020 17:47:15 +0200
>>> Heiner Kallweit <hkallweit1@gmail.com> wrote:
>>> [...]  
>>>> Petr,
>>>> in the following I send two patches. First one is supposed to fix the freeze.
>>>> It also fixes another issue that existed before my ether_clk change:
>>>> ether_clk was disabled on suspend even if WoL is enabled. And the network
>>>> chip most likely needs the clock to check for WoL packets.    
>>>
>>> Should I also check whether WoL works? Plus, it would be probably good
>>> if I could check whether it indeed didn't work before the change. ;-)
>>>   
>>>> Please let me know whether it fixes the freeze, then I'll add your
>>>>   Tested-by.    
>>>
>>> Will do.  
>>
>> Here are the results:
>>
>> - WoL does not work without your patch; this was tested with 5.8.4,
>>   because master freezes hard on load.
>>
>> - I got a kernel crash when I woke up the laptop through keyboard; I am
>>   not sure if it is related, although I could spend some time looking
>>   at the resulting crash dump if you think it's worth the time.
>>

This may be caused by the following code in the resume path in 5.8.
The chip is accessed before the clock gets enabled.

rtl_rar_set(tp, tp->dev->dev_addr);
clk_prepare_enable(tp->clk);


>> - After applying your first patch on top of v5.9-rc6, the driver can be
>>   loaded, but stops working properly on suspend/resume.
>>
>> - WoL still does not work, but I'm no longer getting a kernel crash at
>>   least. ;-)
>>
>> Tested-by: Petr Tesarik <ptesarik@suse.com>
>>
>>>> Second patch is a re-send of the one I sent before, it should fix
>>>> the rx issues after resume from suspend for you.    
>>>
>>> All right, going to rebuild the kernel and see how it goes.  
>>
>> This second patch does not fix suspend/resume for me, unfortunately. The
>> receive is still erratic, but the behaviour is now different: some
>> packets are truncated, other packets are delayed by approx. 1024 ms.
>> Yes, 1024 may ring a bell, but I've no idea which.
> 
> I'm sorry, I added some debugging message, and as I was wondering why
> the resume path is not run, I found out I was not properly reloading the
> modified module. So, after fixing my build, your patch also fixes the
> Rx queue on resume! Both with and without NetworkManager.
> 
> So, you can also add to the second patch:
> 
> Tested-by: Petr Tesarik <ptesarik@suse.com>
> 
Thanks a lot for all your efforts!

> WoL still does not work on my laptop, but this might be an unrelated
> issue, and I can even imagine the BIOS is buggy in this regard.
> 
A simple further check you could do:
After sending the WoL packet (that doesn't wake the system) you wake
the system by e.g. a keystroke. Then check in /proc/interrupts for
a PCIe PME interrupt. If there's a PME interrupt, then the network
chip successfully detected the WoL packet, and it seems we have to
blame the BIOS.

> Petr T
> 
>> HTH,
>> Petr T
>>
>>> Stay tuned,
>>> Petr T
>>>
>>>   
>>>> diff --git a/drivers/net/ethernet/realtek/r8169_main.c
>>>>   b/drivers/net/ethernet/realtek/r8169_main.c index
>>>>   6c7c004c2..72351c5b0 100644 ---
>>>>   a/drivers/net/ethernet/realtek/r8169_main.c +++
>>>>   b/drivers/net/ethernet/realtek/r8169_main.c @@ -2236,14 +2236,10
>>>>   @@ static void rtl_pll_power_down(struct rtl8169_private *tp)
>>>>   default: break;
>>>>  	}
>>>> -
>>>> -	clk_disable_unprepare(tp->clk);
>>>>  }
>>>>  
>>>>  static void rtl_pll_power_up(struct rtl8169_private *tp)
>>>>  {
>>>> -	clk_prepare_enable(tp->clk);
>>>> -
>>>>  	switch (tp->mac_version) {
>>>>  	case RTL_GIGA_MAC_VER_25 ... RTL_GIGA_MAC_VER_33:
>>>>  	case RTL_GIGA_MAC_VER_37:
>>>> @@ -4820,29 +4816,39 @@ static void rtl8169_net_suspend(struct
>>>>   rtl8169_private *tp) 
>>>>  #ifdef CONFIG_PM
>>>>  
>>>> +static int rtl8169_net_resume(struct rtl8169_private *tp)
>>>> +{
>>>> +	rtl_rar_set(tp, tp->dev->dev_addr);
>>>> +
>>>> +	if (tp->TxDescArray)
>>>> +		rtl8169_up(tp);
>>>> +
>>>> +	netif_device_attach(tp->dev);
>>>> +
>>>> +	return 0;
>>>> +}
>>>> +
>>>>  static int __maybe_unused rtl8169_suspend(struct device *device)
>>>>  {
>>>>  	struct rtl8169_private *tp = dev_get_drvdata(device);
>>>>  
>>>>  	rtnl_lock();
>>>>  	rtl8169_net_suspend(tp);
>>>> +	if (!device_may_wakeup(tp_to_dev(tp)))
>>>> +		clk_disable_unprepare(tp->clk);
>>>>  	rtnl_unlock();
>>>>  
>>>>  	return 0;
>>>>  }
>>>>  
>>>> -static int rtl8169_resume(struct device *device)
>>>> +static int __maybe_unused rtl8169_resume(struct device *device)
>>>>  {
>>>>  	struct rtl8169_private *tp = dev_get_drvdata(device);
>>>>  
>>>> -	rtl_rar_set(tp, tp->dev->dev_addr);
>>>> -
>>>> -	if (tp->TxDescArray)
>>>> -		rtl8169_up(tp);
>>>> +	if (!device_may_wakeup(tp_to_dev(tp)))
>>>> +		clk_prepare_enable(tp->clk);
>>>>  
>>>> -	netif_device_attach(tp->dev);
>>>> -
>>>> -	return 0;
>>>> +	return rtl8169_net_resume(tp);
>>>>  }
>>>>  
>>>>  static int rtl8169_runtime_suspend(struct device *device)
>>>> @@ -4868,7 +4874,7 @@ static int rtl8169_runtime_resume(struct
>>>>   device *device) 
>>>>  	__rtl8169_set_wol(tp, tp->saved_wolopts);
>>>>  
>>>> -	return rtl8169_resume(device);
>>>> +	return rtl8169_net_resume(tp);
>>>>  }
>>>>  
>>>>  static int rtl8169_runtime_idle(struct device *device)    
>>>   
>>
> 
Heiner
