Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E985D2779F6
	for <lists+netdev@lfdr.de>; Thu, 24 Sep 2020 22:12:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726185AbgIXUMe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Sep 2020 16:12:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725208AbgIXUMd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Sep 2020 16:12:33 -0400
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80FA9C0613CE
        for <netdev@vger.kernel.org>; Thu, 24 Sep 2020 13:12:33 -0700 (PDT)
Received: by mail-ej1-x641.google.com with SMTP id gx22so530951ejb.5
        for <netdev@vger.kernel.org>; Thu, 24 Sep 2020 13:12:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=qhrA+da5XYB4J1xUmP5mP0DDfDH6xLZkG83CjthZrPo=;
        b=EnRmlu2AA6nEJvPXBKke6rpLiHb+p+E5DQ36k4pNXWq2W/Aze8sE/NhuFtooiXouCO
         yx0fqAHqs1txGt6TUVngRfBJCvnN+nyNEnY0nhcHvK3naob91qxK4Ct6lE6QrlWYQlLa
         jlz7d6h8EqGlZrQhOfakyH5HTK7wKVXiGQvPklPEMydo9vXv0B0/P4wNoDyhWhguOfZJ
         ey817F3n9ylA3AV5dA1qBMmA328PwsoCmdbUHIvbWqp92npfii279Ru8GAXmEBgGUfAK
         96rwYcgboIIaXl8STxwyLcYCNcSVSxLtzM1l/RGphWdr17bxdPsXdHwEJNmXCTz1Q7RH
         iHRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=qhrA+da5XYB4J1xUmP5mP0DDfDH6xLZkG83CjthZrPo=;
        b=BmOB62ZUNTU+xJP7DNMGQeneARee5YZonoodiXvb1z+983MspageCPeOsZ9aKyuzZP
         1IZsKWpGQAC6/S/z33kfIvkcVgpDlnyIUeHWrxdbSFP/Le8t1PoWz/QHWslDs6qP5JLH
         WVkLkCRAeDrcOmQ9Mg0fjLEkCe0FvZ4dVpfUrsjXKJ4i6iRlyts7BaucjFSZxZmVSuR3
         ZXyJe/umw1NtKeHta0TzmJa3XQwA0SIxsil1ZTI5UuR36GIUhQrxr5eic7SQ3jBJqeha
         ja++i5a0L25lRNWV/bOpBEEan7NjputfappfpJvW5R+zSDMy0Csj1398VIISoDdr7iMY
         HnXw==
X-Gm-Message-State: AOAM533l79aUH6kcOSIa8jXpJfox0thp2Wf0JFq2ccrvLPQ4oF/gsCUL
        TgCkAipNMTNb/UrnaO86jvg3suPwcj8=
X-Google-Smtp-Source: ABdhPJxRDnuc57HNnWId7AYTOOHN2zwG6hbkjFPypzcVtlY6O2BvdmyuGhfBlq2pcSaAV24LdOlrZg==
X-Received: by 2002:a17:906:b04a:: with SMTP id bj10mr321136ejb.303.1600978351820;
        Thu, 24 Sep 2020 13:12:31 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f23:5700:218d:aa9:b244:cdab? (p200300ea8f235700218d0aa9b244cdab.dip0.t-ipconnect.de. [2003:ea:8f23:5700:218d:aa9:b244:cdab])
        by smtp.googlemail.com with ESMTPSA id b20sm331559ejv.9.2020.09.24.13.12.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 24 Sep 2020 13:12:31 -0700 (PDT)
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
Message-ID: <a10f658b-7fdf-2789-070a-83ad5549191a@gmail.com>
Date:   Thu, 24 Sep 2020 22:12:24 +0200
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
> I hope that's what you were asking for...
> 
> Petr T
> 

rtl8169_resume() has been changed in 5.9, therefore the patch doesn't
apply cleanly on older kernel versions. Can you test the following
on a 5.9-rc version or linux-next?

Thanks, Heiner


diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 9e4e6a883..4fb49fd0d 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -4837,6 +4837,10 @@ static int rtl8169_resume(struct device *device)
 
 	rtl_rar_set(tp, tp->dev->dev_addr);
 
+	/* Reportedly at least Asus X453MA corrupts packets otherwise */
+	if (tp->mac_version == RTL_GIGA_MAC_VER_37)
+		rtl_init_rxcfg(tp);
+
 	if (tp->TxDescArray)
 		rtl8169_up(tp);
 
-- 
2.28.0
















