Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3340127F004
	for <lists+netdev@lfdr.de>; Wed, 30 Sep 2020 19:14:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725860AbgI3ROH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Sep 2020 13:14:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726540AbgI3ROE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Sep 2020 13:14:04 -0400
Received: from mail-ed1-x544.google.com (mail-ed1-x544.google.com [IPv6:2a00:1450:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CE73C061755;
        Wed, 30 Sep 2020 10:14:03 -0700 (PDT)
Received: by mail-ed1-x544.google.com with SMTP id e22so2692336edq.6;
        Wed, 30 Sep 2020 10:14:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=i1Wd1rGkTi8WNkdHeRxdT8867EVMbKTK7DcL1MD+9UU=;
        b=rovyLqos4TbZMUCQWr1LdCQsQ32rea9+fzaMQi0jAT6yfVwm0rbf43UZrt5HwGW6Mo
         mDzcS6rIh1FOo7OdqP2k3nq/QFCVjszTjwgK/K1uCjZ1X/ysrRt42gXKJyDqF0Wb3uh0
         8vU8FGGDANqUU6PTfZGniIRfi0Jxiy4Og6vqbT0/nywnG1meWeWV+BoR71Fb0iX15pRr
         ms08eLZIdlC/w5Ava952Mbb/oiqmG4s7S45WYZGklvrD6+RkVsg1cn99cG6K/eI5Pzl4
         84b0MwjFJEXAHmh41qoVQxf7unngKijI/cjpJ+1jeui+/pys6byqW4OgUBA48g11Uddj
         7rZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=i1Wd1rGkTi8WNkdHeRxdT8867EVMbKTK7DcL1MD+9UU=;
        b=HrxM9ELF6EvhNoBeSimKOrRj4NGNRniUnl9tHkr3HyA3ktHl8hTXhWGjwa/b+qnqlq
         NtPwwQopX+VlHbUAhX/XOzMBI4SqVbDYmVOl5+aVGmiPsLf1rLVKFoGCewsg/jrfQzPp
         nN8k+d7uZCliQriLulySzia/KaLOzydXHaLLa8quQG4ERKL9LPKiEOfSd3EFRj+WMZiP
         nrVEYBrMQUaMHm0jRwhc5X4aNiRFDFNtqKs0ZEB30Y57UzlZY6A5zpqn3prjqeZwlzox
         FA/o/hdKkZXirtiZb3z6IrATY0pdsyVnsWsr85XVHvds+NChXnQ456C16IQiBeu6QNrR
         73AA==
X-Gm-Message-State: AOAM530RwRYW1VOFQ1PIUZ2lPdFg+CwjIQj13uY3C6k/7EqPhzAgNxsm
        Z4v+4F+vvV+c2YXWG52kjFHQ6yAQ2fE=
X-Google-Smtp-Source: ABdhPJweDBlEg9LUx9JVG7sDdcQAsMDr1NoaiHyrHa/Z+w6ClIzEl0FMo0buCQVF7I6cSXgtxeCY3g==
X-Received: by 2002:a50:ed8d:: with SMTP id h13mr3753405edr.50.1601486041937;
        Wed, 30 Sep 2020 10:14:01 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f00:6a00:814c:b08d:e987:8b78? (p200300ea8f006a00814cb08de9878b78.dip0.t-ipconnect.de. [2003:ea:8f00:6a00:814c:b08d:e987:8b78])
        by smtp.googlemail.com with ESMTPSA id j5sm2058402ejt.52.2020.09.30.10.14.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Sep 2020 10:14:01 -0700 (PDT)
Subject: Re: RTL8402 stops working after hibernate/resume
To:     Petr Tesarik <ptesarik@suse.cz>
Cc:     Hans de Goede <hdegoede@redhat.com>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>,
        netdev@vger.kernel.org, linux-clk@vger.kernel.org
References: <20200715102820.7207f2f8@ezekiel.suse.cz>
 <d742082e-42a1-d904-8a8f-4583944e88e1@gmail.com>
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
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <8efecdb4-b991-7496-05f4-b8e953461f8c@gmail.com>
Date:   Wed, 30 Sep 2020 19:13:57 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20200930184124.68a86b1d@ezekiel.suse.cz>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 30.09.2020 18:41, Petr Tesarik wrote:
> HI Heiner,
> 
> On Wed, 30 Sep 2020 17:47:15 +0200
> Heiner Kallweit <hkallweit1@gmail.com> wrote:
> 
>> On 30.09.2020 11:04, Hans de Goede wrote:
>>> Hi,
>>>
>>> On 9/29/20 10:35 PM, Heiner Kallweit wrote:  
>>>> On 29.09.2020 22:08, Hans de Goede wrote:  
>>>
>>> <snip>
>>>   
>>>>> Also some remarks about this while I'm being a bit grumpy about
>>>>> all this anyways (sorry):
>>>>>
>>>>> 1. 9f0b54cd167219 ("r8169: move switching optional clock on/off
>>>>> to pll power functions") commit's message does not seem to really
>>>>> explain why this change was made...
>>>>>
>>>>> 2. If a git blame would have been done to find the commit adding
>>>>> the clk support: commit c2f6f3ee7f22 ("r8169: Get and enable optional ether_clk clock")
>>>>> then you could have known that the clk in question is an external
>>>>> clock for the entire chip, the commit message pretty clearly states
>>>>> this (although "the entire" part is implied only) :
>>>>>
>>>>> "On some boards a platform clock is used as clock for the r8169 chip,
>>>>> this commit adds support for getting and enabling this clock (assuming
>>>>> it has an "ether_clk" alias set on it).
>>>>>  
>>>> Even if the missing clock would stop the network chip completely,
>>>> this shouldn't freeze the system as described by Petr.
>>>> In some old RTL8169S spec an external 25MHz clock is mentioned,
>>>> what matches the MII bus frequency. Therefore I'm not 100% convinced
>>>> that the clock is needed for basic chip operation, but due to
>>>> Realtek not releasing datasheets I can't verify this.  
>>>
>>> Well if that 25 MHz is the only clock the chip has, then it basically
>>> has to be on all the time since all clocked digital ASICs cannot work
>>> without a clock.  Now pci-e is a packet-switched point-to-point bus,
>>> so the ethernet chip not working should not freeze the entire system,
>>> but I'm not really surprised that even though it should not do that,
>>> that it still does.
>>>   
>>>> But yes, if reverting this change avoids the issue on Petr's system,
>>>> then we should do it. A simple mechanical revert wouldn't work because
>>>> source file structure has changed since then, so I'll prepare a patch
>>>> that effectively reverts the change.  
>>>
>>> Great, thank you.
>>>
>>> Regards,
>>>
>>> Hans
>>>   
>>
>> Petr,
>> in the following I send two patches. First one is supposed to fix the freeze.
>> It also fixes another issue that existed before my ether_clk change:
>> ether_clk was disabled on suspend even if WoL is enabled. And the network
>> chip most likely needs the clock to check for WoL packets.
> 
> Should I also check whether WoL works? Plus, it would be probably good
> if I could check whether it indeed didn't work before the change. ;-)
> 
This would be perfect and much appreciated!


>> Please let me know whether it fixes the freeze, then I'll add your Tested-by.
> 
> Will do.
> 
>> Second patch is a re-send of the one I sent before, it should fix
>> the rx issues after resume from suspend for you.
> 
> All right, going to rebuild the kernel and see how it goes.
> 
> Stay tuned,
> Petr T
> 
> 
>> diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
>> index 6c7c004c2..72351c5b0 100644
>> --- a/drivers/net/ethernet/realtek/r8169_main.c
>> +++ b/drivers/net/ethernet/realtek/r8169_main.c
>> @@ -2236,14 +2236,10 @@ static void rtl_pll_power_down(struct rtl8169_private *tp)
>>  	default:
>>  		break;
>>  	}
>> -
>> -	clk_disable_unprepare(tp->clk);
>>  }
>>  
>>  static void rtl_pll_power_up(struct rtl8169_private *tp)
>>  {
>> -	clk_prepare_enable(tp->clk);
>> -
>>  	switch (tp->mac_version) {
>>  	case RTL_GIGA_MAC_VER_25 ... RTL_GIGA_MAC_VER_33:
>>  	case RTL_GIGA_MAC_VER_37:
>> @@ -4820,29 +4816,39 @@ static void rtl8169_net_suspend(struct rtl8169_private *tp)
>>  
>>  #ifdef CONFIG_PM
>>  
>> +static int rtl8169_net_resume(struct rtl8169_private *tp)
>> +{
>> +	rtl_rar_set(tp, tp->dev->dev_addr);
>> +
>> +	if (tp->TxDescArray)
>> +		rtl8169_up(tp);
>> +
>> +	netif_device_attach(tp->dev);
>> +
>> +	return 0;
>> +}
>> +
>>  static int __maybe_unused rtl8169_suspend(struct device *device)
>>  {
>>  	struct rtl8169_private *tp = dev_get_drvdata(device);
>>  
>>  	rtnl_lock();
>>  	rtl8169_net_suspend(tp);
>> +	if (!device_may_wakeup(tp_to_dev(tp)))
>> +		clk_disable_unprepare(tp->clk);
>>  	rtnl_unlock();
>>  
>>  	return 0;
>>  }
>>  
>> -static int rtl8169_resume(struct device *device)
>> +static int __maybe_unused rtl8169_resume(struct device *device)
>>  {
>>  	struct rtl8169_private *tp = dev_get_drvdata(device);
>>  
>> -	rtl_rar_set(tp, tp->dev->dev_addr);
>> -
>> -	if (tp->TxDescArray)
>> -		rtl8169_up(tp);
>> +	if (!device_may_wakeup(tp_to_dev(tp)))
>> +		clk_prepare_enable(tp->clk);
>>  
>> -	netif_device_attach(tp->dev);
>> -
>> -	return 0;
>> +	return rtl8169_net_resume(tp);
>>  }
>>  
>>  static int rtl8169_runtime_suspend(struct device *device)
>> @@ -4868,7 +4874,7 @@ static int rtl8169_runtime_resume(struct device *device)
>>  
>>  	__rtl8169_set_wol(tp, tp->saved_wolopts);
>>  
>> -	return rtl8169_resume(device);
>> +	return rtl8169_net_resume(tp);
>>  }
>>  
>>  static int rtl8169_runtime_idle(struct device *device)
> 

