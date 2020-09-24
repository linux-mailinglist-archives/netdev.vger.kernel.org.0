Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01DF8277978
	for <lists+netdev@lfdr.de>; Thu, 24 Sep 2020 21:37:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728808AbgIXThw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Sep 2020 15:37:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728783AbgIXThv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Sep 2020 15:37:51 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60E86C0613CE
        for <netdev@vger.kernel.org>; Thu, 24 Sep 2020 12:37:51 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id s12so463202wrw.11
        for <netdev@vger.kernel.org>; Thu, 24 Sep 2020 12:37:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=AOuRgxjssI/TMxZPeJ/92FAftXoL+BcLlQUJLC+bwV4=;
        b=a1BRP4q1rhyJA1LBJd/wwceO6ALSniTBabRQmEREYiVJlvCNPBY9xu5ZVQK8Fh0dKq
         idUosbdZhryOIwjrws3y7ogF8QB+crjFM3CFcvawoRP7m04AL/9klhY1diPZK3UZSXqE
         M23LbkUYsjZJeunHSOPklUPFiWG40yxUJdMqHNWaFFT5wE0+J9vBBPvOq+LaO6OUvnlc
         DmLrGW0NJi4C2ViK0xRgr4OAcek7VH2w7H5ZfqgQfRRDwjLvTP027MvC+hUlQPCO4mCz
         T6qpANrJI1r3zC/sFBBWZUAJBL9+Q/IIqIpBf0twbDKymo7X2UbInuA0746afQ+IhWZw
         MfaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=AOuRgxjssI/TMxZPeJ/92FAftXoL+BcLlQUJLC+bwV4=;
        b=gYGXyeJsm9peXuXymJB7NUL2MuREaMQ888SaxvImygSxpsi4S6DHV3Q19AK5QKfrnx
         b/Yb/fQ3mi5xchNKgSdBXCZViA78zCebX9OWiIshTc2ow1puk3+vi3/UYcTQ1SYTQTw5
         jcc008ClmBRpQXNaTaDhJUgXQVF8Xqswf8oiYzEcHAEPEahAkQcVpALbD9DQrEupqX2k
         cD2zvdWV9JBBGxgRXVGktMQHiRa2GazxlluokMs57wRY4xYt6tIvjZ1wnGF9AfnMOwFV
         4VhCDkQD//acsg21COAlvFcmaSBzeFj8fZiNYFHNhQbC1DA+PaTkJVI/onClVzc/7b+Y
         Zlzw==
X-Gm-Message-State: AOAM531miJYKkSNxm/ZM3uzLACiXenmbB8Ow3Q7FDgVKxDC5fT+b22Ll
        YrrmbBG7iRZXNfjU88gnDNPLO6vcw3g=
X-Google-Smtp-Source: ABdhPJxeZlzo7gsLcGBpo5z+rZQyCuTWh4vEyOb2fpbI44L6n5fd+e5MqaB2gGldRP+D6+mv+Z15Pw==
X-Received: by 2002:adf:ec82:: with SMTP id z2mr522084wrn.214.1600976269841;
        Thu, 24 Sep 2020 12:37:49 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f23:5700:218d:aa9:b244:cdab? (p200300ea8f235700218d0aa9b244cdab.dip0.t-ipconnect.de. [2003:ea:8f23:5700:218d:aa9:b244:cdab])
        by smtp.googlemail.com with ESMTPSA id t4sm197452wrr.26.2020.09.24.12.37.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 24 Sep 2020 12:37:49 -0700 (PDT)
Subject: Re: RTL8402 stops working after hibernate/resume
To:     Petr Tesarik <ptesarik@suse.cz>
Cc:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        netdev@vger.kernel.org
References: <20200715102820.7207f2f8@ezekiel.suse.cz>
 <d742082e-42a1-d904-8a8f-4583944e88e1@gmail.com>
 <20200716105835.32852035@ezekiel.suse.cz>
 <e1c7a37f-d8d0-a773-925c-987b92f12694@gmail.com>
 <20200903104122.1e90e03c@ezekiel.suse.cz>
 <7e6bbb75-d8db-280d-ac5b-86013af39071@gmail.com>
 <20200924211444.3ba3874b@ezekiel.suse.cz>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <4ed5d890-4211-3a4d-8c5d-d0bcb9b2c609@gmail.com>
Date:   Thu, 24 Sep 2020 21:37:42 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20200924211444.3ba3874b@ezekiel.suse.cz>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 24.09.2020 21:14, Petr Tesarik wrote:
> On Wed, 23 Sep 2020 11:57:41 +0200
> Heiner Kallweit <hkallweit1@gmail.com> wrote:
> 
>> On 03.09.2020 10:41, Petr Tesarik wrote:
>>> Hi Heiner,
>>>
>>> this issue was on the back-burner for some time, but I've got some
>>> interesting news now.
>>>
>>> On Sat, 18 Jul 2020 14:07:50 +0200
>>> Heiner Kallweit <hkallweit1@gmail.com> wrote:
>>>   
>>>> [...]
>>>> Maybe the following gives us an idea:
>>>> Please do "ethtool -d <if>" after boot and after resume from suspend,
>>>> and check for differences.  
>>>
>>> The register dump did not reveal anything of interest - the only
>>> differences were in the physical addresses after a device reopen.
>>>
>>> However, knowing that reloading the driver can fix the issue, I copied
>>> the initialization sequence from init_one() to rtl8169_resume() and
>>> gave it a try. That works!
>>>
>>> Then I started removing the initialization calls one by one. This
>>> exercise left me with a call to rtl_init_rxcfg(), which simply sets the
>>> RxConfig register. In other words, these is the difference between
>>> 5.8.4 and my working version:
>>>
>>> --- linux-orig/drivers/net/ethernet/realtek/r8169_main.c	2020-09-02 22:43:09.361951750 +0200
>>> +++ linux/drivers/net/ethernet/realtek/r8169_main.c	2020-09-03 10:36:23.915803703 +0200
>>> @@ -4925,6 +4925,9 @@
>>>  
>>>  	clk_prepare_enable(tp->clk);
>>>  
>>> +	if (tp->mac_version == RTL_GIGA_MAC_VER_37)
>>> +		RTL_W32(tp, RxConfig, RX128_INT_EN | RX_DMA_BURST);
>>> +
>>>  	if (netif_running(tp->dev))
>>>  		__rtl8169_resume(tp);
>>>  
>>> This is quite surprising, at least when the device is managed by
>>> NetworkManager, because then it is closed on wakeup, and the open
>>> method should call rtl_init_rxcfg() anyway. So, it might be a timing
>>> issue, or incorrect order of register writes.
>>>   
>> Thanks for the analysis. If you manually bring down and up the
>> interface, do you see the same issue?
> 
> I'm not quite sure what you mean, but if the interface is configured
> (and NetworkManager is stopped), I can do 'ip link set eth0 down' and
> then 'ip link set eth0 up', and the interface is fully functional.
> 
>> What is the value of RxConfig when entering the resume function?
> 
> I added a dev_info() to rtl8169_resume(). First with NetworkManager
> active (i.e. interface down on suspend):
> 
> [  525.956675] r8169 0000:03:00.2: RxConfig after resume: 0x0002400f
> 
> Then I re-tried with NetworkManager stopped (i.e. interface up on
> suspend). Same result:
> 
> [  785.413887] r8169 0000:03:00.2: RxConfig after resume: 0x0002400f
> 
Thanks for checking this. The value is not what I would have expected,
it may be a BIOS bug or HW issue with RTL8402. I'll slightly modify
your proposed patch and then let you re-test it.

> I hope that's what you were asking for...
> 
> Petr T
> 
Heiner
