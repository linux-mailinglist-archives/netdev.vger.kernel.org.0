Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A82927D84D
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 22:35:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728914AbgI2Ufb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 16:35:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726623AbgI2Ufb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Sep 2020 16:35:31 -0400
Received: from mail-ed1-x542.google.com (mail-ed1-x542.google.com [IPv6:2a00:1450:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C70F4C061755;
        Tue, 29 Sep 2020 13:35:30 -0700 (PDT)
Received: by mail-ed1-x542.google.com with SMTP id j2so7976572eds.9;
        Tue, 29 Sep 2020 13:35:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=dLqvcYnkR6wcaYc/X8Uf5hGPrUII3cq8cxEQidQqD2c=;
        b=nQuc8UorKij2dvFrl9eyV3LebN7SZEOyZX9RmLM4Sg96vJ0QjQldQB49d6KplDMfzC
         ia1SpooTuQfasK43Ci+0si4ixC6roU45fHyNQKWHzSKchWDKGngsswBNXTgx8ijduqIP
         2sC1oYVefUQJ2MT5ZP8DBpUhsZzkZxd1zjkXQNYjHrvMZkDopMXdg3SPhGyDp/QAZddv
         +zgeUnriKxtanauwActDD+pwi2XqtmH5vLIfePKaGVYgzTtcQDKc76u3zjZXpXBDNddF
         O18Ypl7Gwxmzd+owmEV5bjTbezGSq06uU4MtqvAdzM50B2THntPAdqqwz9Hb3cglszrL
         Q38g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=dLqvcYnkR6wcaYc/X8Uf5hGPrUII3cq8cxEQidQqD2c=;
        b=lqaf6SEzu5tFCDv/Z+bJjckPwjkyFXhEDGDr6sQ7jWdLSCHcamKZCXzQCQ2C5i1rGo
         La4mp/1Lo3bC9UCpManXFNSOFuTfORSojcGLUaBrFYtlh0bgtLQvL5bKIZ2W/bs/l6lr
         jzTMunhDdECvBo3e21WBOQLEtSpP22sOBAI4UTTvfXfPXp1n3jOhJzfwBu6XjvmpoMf/
         EkY2KPaGNS1s7IcxBVIu3wRYMBPHY1t0eZEr069VpUHGAAGSe84Dhqz/hhFQdultkTqx
         Yy2hGRF4DAyNMdclqXQM2fiKbUJXq8joIK0fxsiSZTLoJJZ/mvuq/Lgmsfs6hdLVXuOU
         Zcsg==
X-Gm-Message-State: AOAM531waEPVGOxtPGgMDaZnKthZhycJZDkh1AXDhJwHOfBr61m2+oHL
        StwFKa/KaNjiTuxwz8uadu4k2PSxgq4=
X-Google-Smtp-Source: ABdhPJzJIjR1r04ng+FsPwT6sfLOcc2WIfR9LvRTj5r027MZM2yaKPVM6oDmO9KOSCNAFSkGAIiTeQ==
X-Received: by 2002:aa7:c148:: with SMTP id r8mr5379164edp.210.1601411729127;
        Tue, 29 Sep 2020 13:35:29 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f00:6a00:f1df:74ef:35e5:214d? (p200300ea8f006a00f1df74ef35e5214d.dip0.t-ipconnect.de. [2003:ea:8f00:6a00:f1df:74ef:35e5:214d])
        by smtp.googlemail.com with ESMTPSA id n4sm5964096ejj.19.2020.09.29.13.35.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 29 Sep 2020 13:35:28 -0700 (PDT)
Subject: Re: RTL8402 stops working after hibernate/resume
To:     Hans de Goede <hdegoede@redhat.com>,
        Petr Tesarik <ptesarik@suse.cz>
Cc:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
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
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <5f2d3d48-9d1d-e9fe-49bc-d1feeb8a92eb@gmail.com>
Date:   Tue, 29 Sep 2020 22:35:23 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <217ae37d-f2b0-1805-5696-11644b058819@redhat.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 29.09.2020 22:08, Hans de Goede wrote:
> Hi,
> 
> On 9/29/20 9:07 PM, Petr Tesarik wrote:
>> Hi Heiner (and now also Hans)!
>>
>> @Hans: I'm adding you to this conversation, because you're the author
>> of commit b1e3454d39f99, which seems to break the r8169 driver on a
>> laptop of mine.
> 
> Erm, no, as you bi-sected yourself already commit 9f0b54cd167219
> ("r8169: move switching optional clock on/off to pll power functions")
> 
> Broke your laptop, commit b1e3454d39f99 ("clk: x86: add "ether_clk" alias
> for Bay Trail / Cherry Trail") is about 18 months older.
> 
>> On Fri, 25 Sep 2020 16:47:54 +0200
>> Heiner Kallweit <hkallweit1@gmail.com> wrote:
>>
>>> On 25.09.2020 14:56, Petr Tesarik wrote:
>>>> On Fri, 25 Sep 2020 11:52:41 +0200
>>>> Petr Tesarik <ptesarik@suse.cz> wrote:
>>>>   
>>>>> On Fri, 25 Sep 2020 11:44:09 +0200
>>>>> Heiner Kallweit <hkallweit1@gmail.com> wrote:
>>>>>  
>>>>>> On 25.09.2020 10:54, Petr Tesarik wrote:
>>>>> [...]
>>>>>>> Does it make sense to bisect the change that broke the driver for me, or should I rather dispose of this waste^Wlaptop in an environmentally friendly manner? I mean, would you eventually accept a workaround for a few machines with a broken BIOS?
>>>>>>>        
>>>>>> If the workaround is small and there's little chance to break other stuff: then usually yes.
>>>>>> If you can spend the effort to bisect the issue, this would be appreciated.
>>>>>
>>>>> OK, then I'm going to give it a try.
>>>>
>>>> Done. The system freezes when this commit is applied:
>>>>
>>>> commit 9f0b54cd167219266bd3864570ae8f4987b57520
>>>> Author: Heiner Kallweit <hkallweit1@gmail.com>
>>>> Date:   Wed Jun 17 22:55:40 2020 +0200
>>>>
>>>>      r8169: move switching optional clock on/off to pll power functions
>>>>    
>>> This sounds weird. On your system tp->clk should be NULL,
> 
> Heiner, why do you say that tp->clk should be NULL on Petr's
> system? Because it is an x86 based system?
> 
This was a misunderstanding on my side, I was under the assumption
that ether_clk applies to DT-configured systems only.

> Some X86 SoCs, specifically, the more tablet oriented Bay and Cherry
> Trail SoCs, which are much more ARM SoC like then other X86 SoCs do
> also use the clock framework and the SoC has a number of external clk
> pins which are typically used by audio codecs and by ethernet chips.
> 
>>> making
>>> clk_prepare_enable() et al no-ops. Please check whether tp->clk
>>> is NULL after the call to rtl_get_ether_clk().
>>
>> This might be part of the issue. On my system tp->clk is definitely not
>> NULL:
>>
>> crash> *rtl8169_private.clk 0xffff9277aca58940
>>    clk = 0xffff9277ac2c82a0
>>
>> crash> *clk 0xffff9277ac2c82a0
>> struct clk {
>>    core = 0xffff9277aef65d00,
>>    dev = 0xffff9277aed000b0,
>>    dev_id = 0xffff9277aec60c00 "0000:03:00.2",
>>    con_id = 0xffff9277ad04b080 "ether_clk",
>>    min_rate = 0,
>>    max_rate = 18446744073709551615,
>>    exclusive_count = 0,
>>    clks_node = {
>>      next = 0xffff9277ad2428d8,
>>      pprev = 0xffff9277aef65dc8
>>    }
>> }
>>
>> The dev_id corresponds to the Ethernet controller:
>>
>> 03:00.2 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL810xE PCI Express Fast Ethernet controller (rev 06)
>>
>> Looking at clk_find(), it matches this entry in clocks:
>>
>> struct clk_lookup {
>>    node = {
>>      next = 0xffffffffbc702f40,
>>      prev = 0xffff9277bf7190c0
>>    },
>>    dev_id = 0x0,
>>    con_id = 0xffff9277bf719524 "ether_clk",
>>    clk = 0x0,
>>    clk_hw = 0xffff9277ad2427f8
>> }
>>
>> That's because this kernel is built with CONFIG_PMC_ATOM=y, and looking
>> at the platform initialization code, the "ether_clk" alias is created
>> unconditionally. Hans already added.
> 
> Petr, unconditionally is not really correct here, just as claiming
> above that my commit broke things was not really correct either.
> 
> I guess this is mostly semantics, but I don't appreciate
> the accusatory tone here.
> 
> The code in question binds to a clk-pmc-atom platform_device which
> gets instantiated by drivers/platform/x86/pmc_atom.c. Which in turn
> binds to a PCI device which is only present on Bay Trail and Cherry
> Trail SoCs.
> 
> IOW the commit operates as advertised in its Subject:
> "clk: x86: add "ether_clk" alias for Bay Trail / Cherry Trail"
> 
> So with that all clarified lets try to see if we can figure out
> *why* this is actually happening.
> 
> Petr, can you describe your hardware in some more detail,
> in the bits quoted when you first Cc-ed me there is not that
> much detail. What is the vendor and model of your laptop?
> 
> Looking closer at commit 9f0b54cd167219
> ("r8169: move switching optional clock on/off to pll power functions")
> I notice that the functions which now enable/disable the clock:
> rtl_pll_power_up() and rtl_pll_power_down()
> 
> Only run when the interface is up during suspend/resume.
> Petr, I guess the laptop is not connected to ethernet when you
> hibernate it?
> 
> That means that on resume the clock will not be re-enabled.
> 
> This is a subtle but important change and I believe that
> this is what is breaking things. I guess that the PLL which
> rtl_pll_power_up() / rtl_pll_power_down() controls is only
> used for ethernet-timing.  But the external clock controlled
> through pt->clk is a replacement for using an external
> crystal with the r8169 chip. So with it disabled, the entire
> chip does not have a clock and is essentially dead.
> It can then e.g. not respond to any pci-e reads/writes done
> to it.
> 
> So I believe that the proper fix for this is to revert
> commit 9f0b54cd167219
> ("r8169: move switching optional clock on/off to pll power functions")
> 
> As that caused the whole chip's clock to be left off after
> a suspend/resume while the interface is down.
> 
> Also some remarks about this while I'm being a bit grumpy about
> all this anyways (sorry):
> 
> 1. 9f0b54cd167219 ("r8169: move switching optional clock on/off
> to pll power functions") commit's message does not seem to really
> explain why this change was made...
> 
> 2. If a git blame would have been done to find the commit adding
> the clk support: commit c2f6f3ee7f22 ("r8169: Get and enable optional ether_clk clock")
> then you could have known that the clk in question is an external
> clock for the entire chip, the commit message pretty clearly states
> this (although "the entire" part is implied only) :
> 
> "On some boards a platform clock is used as clock for the r8169 chip,
> this commit adds support for getting and enabling this clock (assuming
> it has an "ether_clk" alias set on it).
> 
Even if the missing clock would stop the network chip completely,
this shouldn't freeze the system as described by Petr.
In some old RTL8169S spec an external 25MHz clock is mentioned,
what matches the MII bus frequency. Therefore I'm not 100% convinced
that the clock is needed for basic chip operation, but due to
Realtek not releasing datasheets I can't verify this.

But yes, if reverting this change avoids the issue on Petr's system,
then we should do it. A simple mechanical revert wouldn't work because
source file structure has changed since then, so I'll prepare a patch
that effectively reverts the change.

> This is related to commit d31fd43c0f9a ("clk: x86: Do not gate clocks
> enabled by the firmware") which is a previous attempt to fix this for some
> x86 boards, but this causes all Cherry Trail SoC using boards to not reach
> there lowest power states when suspending.
> 
> This commit (together with an atom-pmc-clk driver commit adding the alias)
> fixes things properly by making the r8169 get the clock and enable it when
> it needs it."
> 
> Regards,
> 
> Hans
> 

Heiner
