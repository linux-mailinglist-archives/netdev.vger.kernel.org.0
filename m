Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 951904DA33D
	for <lists+netdev@lfdr.de>; Tue, 15 Mar 2022 20:24:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343584AbiCOTZ4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Mar 2022 15:25:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239180AbiCOTZz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Mar 2022 15:25:55 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99B356434
        for <netdev@vger.kernel.org>; Tue, 15 Mar 2022 12:24:42 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id pv16so4307107ejb.0
        for <netdev@vger.kernel.org>; Tue, 15 Mar 2022 12:24:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=q3025djmCwSjJau/+QJixAeZzb6I/lhr1deLG1MzwGQ=;
        b=igoJSbGsiBxHPeIFc0ca/0MOLdzUpuFu0SuPWu6gThv73/aPeTY+y9UM+cw60bdELR
         EEmdcWoClLN55nkPJLSbsmh0COR3+7TuojFCtW3ECxnHb5AHe/oyxxBThHaDlHQcgIjR
         e4JS6l3dU7GjbQuL3x7PyJKGUsNR9puH2UrEE1GJRFfrqQe0uJGdWzPFpyfLxGXlQwAr
         u50/mgRaqUkj01godEWTb1iMouGLkd4BKJRsN6cYlOc21yLvRIfGwsNtFosL7TaMQOQy
         G7FUzzhJHOhAvurb/lI0Ymhwzs8qz+l4/yhNkyV/HTsJVtigPOC5ZxWB6o7YIe8MguHd
         AydA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=q3025djmCwSjJau/+QJixAeZzb6I/lhr1deLG1MzwGQ=;
        b=5PhaPJIELY5J+gxbMjJdZnbKp0kjqU7TmUSC98zWByjnPJr2fcRLkzbhjdw6NKy7Oq
         kHpRyNSJFHVzkWqpz8gPnLaZtePbVhXREjwBQ2mFghxrrJrGCZbEswwnkhpAfpRGSR6B
         a456s/Ob7P4gr5NgGBMA/z/s6P8Qo22tjX7EiZraJj4eQqxyxFp0CTZbI2opvWQo4jDC
         +m8PEIQC1StCTmY+aRiVqgGIVTU05fJk8NLeDT8HikPveNe+ZtVZrbw2rnZgBb/mX7uf
         X8cSy/xhZCAL1Gb+vv8HCfEgla8QkEdsdbsICc/f02224d/Q8fg3CLe7CjdktbyUg3BR
         4lsA==
X-Gm-Message-State: AOAM530TyAZHTe63Nu4v3wajrXvx7Jrv3MrdwVrNj0406SCJstHokyh3
        hyXyRTahbpEqyW+CteUz5ihnqSTpSts=
X-Google-Smtp-Source: ABdhPJwIiyEOP76QSlgk19TD+G10UQq8KCi995M79Dpv5Po2sTQePwXfJJckZKowIeoWd98V11LcCw==
X-Received: by 2002:a17:907:168a:b0:6da:9167:47dc with SMTP id hc10-20020a170907168a00b006da916747dcmr23894614ejc.126.1647372280947;
        Tue, 15 Mar 2022 12:24:40 -0700 (PDT)
Received: from ?IPV6:2a01:c23:bdcc:f500:2cd7:7756:d344:20c? (dynamic-2a01-0c23-bdcc-f500-2cd7-7756-d344-020c.c23.pool.telefonica.de. [2a01:c23:bdcc:f500:2cd7:7756:d344:20c])
        by smtp.googlemail.com with ESMTPSA id r23-20020aa7da17000000b00415a1431488sm10048354eds.4.2022.03.15.12.24.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Mar 2022 12:24:40 -0700 (PDT)
Message-ID: <1198ce91-24ee-3d66-6045-9cf287f23459@gmail.com>
Date:   Tue, 15 Mar 2022 20:24:32 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: r8169: rtl8168ep_driver_stop disables the DASH port
Content-Language: en-US
To:     Yanko Kaneti <yaneti@declera.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Nicfae <Nicfae@realtek.com>,
        Kevin_cheng <kevin_cheng@realtek.com>
References: <d654c98b90d98db13b84752477fe2c63834bcf59.camel@declera.com>
 <42304a71ed72415c803ec22d3a750b33@realtek.com>
 <ed2850b12b304a7cb89972850e503026@realtek.com>
 <37bd0b005af4e10fd7e9ada2437775a4735d40a0.camel@declera.com>
 <79606fda-ad17-954b-a2f2-7f155f142264@gmail.com>
 <da6297799b82ffbac52a192019b8844c89bbf0b9.camel@declera.com>
 <2c638572a97d9f598135e9e1b3a56d3f9592b502.camel@declera.com>
 <5606063c65f9b67e036497c24fa8c527ebd24fae.camel@declera.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
In-Reply-To: <5606063c65f9b67e036497c24fa8c527ebd24fae.camel@declera.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 15.03.2022 15:19, Yanko Kaneti wrote:
> On Tue, 2022-03-15 at 12:25 +0200, Yanko Kaneti wrote:
>> On Tue, 2022-03-15 at 11:40 +0200, Yanko Kaneti wrote:
>>> On Mon, 2022-03-14 at 22:24 +0100, Heiner Kallweit wrote:
>>>> On 14.03.2022 15:05, Yanko Kaneti wrote:
>>>>> On Mon, 2022-03-14 at 01:00 +0000, Kevin_cheng wrote:
>>>>> Hello Kevin,
>>>>>
>>>>>> Thanks for your email. Linux DASH requires specific driver and client
>>>>>> tool. It depends on the manufacturer’s requirement. You need to
>>>>>> contact ASRock to make sure they support Linux DASH and have verified
>>>>>> it.
>>>>>
>>>>> Thanks for the answer but its not much help for me.
>>>>> I am not going to use a driver that's not in mainline.
>>>>>
>>>>> I wasn't really expecting full DASH support but that at least
>>>>> r8169/linux does not prevent the limied DASH web interface functionality
>>>>> from working.
>>>>>
>>>>> Currently this is not the case on this board with the current BIOS:
>>>>>  - Once the kernel is loaded the DASH web interface power management
>>>>> (reset, hard off) no longer works
>>>>>  - Normal shutdown or r8169 module unload actually disconnects the phy.
>>>>>  
>>>>> It would be nice if DASH basics worked without being broken/supported by
>>>>> the OS.
>>>>>
>>>>> Regards
>>>>> Yanko
>>>>>
>>>>>>
>>>>>> Best Regards
>>>>>> Kevin Cheng
>>>>>> Technical Support Dept.
>>>>>> Realtek Semiconductor Corp.
>>>>>>
>>>>>> -----Original Message-----
>>>>>> From: Yanko Kaneti <yaneti@declera.com> 
>>>>>> Sent: Friday, March 11, 2022 9:12 PM
>>>>>> To: Heiner Kallweit <hkallweit1@gmail.com>; nic_swsd
>>>>>> <nic_swsd@realtek.com>
>>>>>> Cc: netdev <netdev@vger.kernel.org>
>>>>>> Subject: r8169: rtl8168ep_driver_stop disables the DASH port
>>>>>>
>>>>>> Hello,
>>>>>>
>>>>>> Testing DASH on a ASRock A520M-HDVP/DASH, which has a RTL8111/8168 EP
>>>>>> chip. DASH is enabled and seems to work on BIOS/firmware level.
>>>>>>
>>>>>> It seems that r8169's cleanup/exit in rtl8168ep_driver_stop manages to
>>>>>> actually stop the LAN port, hence cutting the system remote
>>>>>> management.
>>>>>>
>>>>>> This is evident on plain shutdown or rmmod r8169.
>>>>>> If one does a hardware reset or echo "b" > /proc/sysrq-trigger  the
>>>>>> cleanup doesn't happen and the DASH firmware remains in working order
>>>>>> and the LAN port remains up.
>>>>>>
>>>>>> A520M-HDVP/DASH BIOS ver 1.70
>>>>>> Reatlek fw:
>>>>>>  Firmware Version:               3.0.0.20200423
>>>>>>  Version String:         20200428.1200000113
>>>>>>  
>>>>>> I have no idea if its possible or how to update the realtek firmware,
>>>>>> preferably from Linux.
>>>>>>
>>>>>> Various other DASH functionality seems to not work but basic working
>>>>>> power managements is really a deal breaker for the whole thing.
>>>>>>
>>>>>>
>>>>>> Regards
>>>>>> Yanko
>>>>>> ------Please consider the environment before printing this e-mail.
>>>>>
>>>>
>>>> Realtek doesn't provide any public datasheets, therefore it's hard to say
>>>> how DASH is handled in the chip.
>>>> However there are few places left where the PHY may be suspended w/o
>>>> checking for DASH. Can you try the following?
>>>>
>>>>
>>>> diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
>>>> index 67014eb76..95788ce7a 100644
>>>> --- a/drivers/net/ethernet/realtek/r8169_main.c
>>>> +++ b/drivers/net/ethernet/realtek/r8169_main.c
>>>> @@ -1397,8 +1397,13 @@ static void __rtl8169_set_wol(struct rtl8169_private *tp, u32 wolopts)
>>>>  	rtl_lock_config_regs(tp);
>>>>  
>>>>  	device_set_wakeup_enable(tp_to_dev(tp), wolopts);
>>>> -	rtl_set_d3_pll_down(tp, !wolopts);
>>>> -	tp->dev->wol_enabled = wolopts ? 1 : 0;
>>>> +	if (tp->dash_type == RTL_DASH_NONE) {
>>>> +		rtl_set_d3_pll_down(tp, !wolopts);
>>>> +		tp->dev->wol_enabled = wolopts ? 1 : 0;
>>>> +	} else {
>>>> +		/* keep PHY from suspending if DASH is enabled */
>>>> +		tp->dev->wol_enabled = 1;
>>>> +	}
>>>>  }
>>>>  
>>>>  static int rtl8169_set_wol(struct net_device *dev, struct ethtool_wolinfo *wol)
>>>> @@ -4672,7 +4677,7 @@ static void r8169_phylink_handler(struct net_device *ndev)
>>>>  	if (netif_carrier_ok(ndev)) {
>>>>  		rtl_link_chg_patch(tp);
>>>>  		pm_request_resume(&tp->pci_dev->dev);
>>>> -	} else {
>>>> +	} else if (tp->dash_type == RTL_DASH_NONE) {
>>>>  		pm_runtime_idle(&tp->pci_dev->dev);
>>>>  	}
>>>>  
>>>> @@ -4978,7 +4983,8 @@ static void rtl_shutdown(struct pci_dev *pdev)
>>>>  	/* Restore original MAC address */
>>>>  	rtl_rar_set(tp, tp->dev->perm_addr);
>>>>  
>>>> -	if (system_state == SYSTEM_POWER_OFF) {
>>>> +	if (system_state == SYSTEM_POWER_OFF &&
>>>> +	    tp->dash_type == RTL_DASH_NONE) {
>>>>  		if (tp->saved_wolopts)
>>>>  			rtl_wol_shutdown_quirk(tp);
>>>>  
>>>
>>> Thanks Heiner. 
>>> So I tried this over linus tip from today and unfortunately it doesn't
>>> help the shutdown or rmmod. 
>>> With the couple more additions below I can get it to stay up on rmmod  ,
>>> but still after that , shutdown still brings it down. Perhaps that
>>> leaves all to the BIOS/realtek firmware..
>>>
>>>
>>> diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
>>> index 19e2621e0645..d5d85a44be3e 100644
>>> --- a/drivers/net/ethernet/realtek/r8169_main.c
>>> +++ b/drivers/net/ethernet/realtek/r8169_main.c
>>> @@ -4675,7 +4680,8 @@ static void rtl8169_down(struct rtl8169_private *tp)
>>>         /* Clear all task flags */
>>>         bitmap_zero(tp->wk.flags, RTL_FLAG_MAX);
>>>  
>>> -       phy_stop(tp->phydev);
>>> +       if (tp->dash_type == RTL_DASH_NONE)
>>> +               phy_stop(tp->phydev);
>>>  
>>>         rtl8169_update_counters(tp);
>>>  
>>> @@ -4715,7 +4721,8 @@ static int rtl8169_close(struct net_device *dev)
>>>  
>>>         free_irq(tp->irq, tp);
>>>  
>>> -       phy_disconnect(tp->phydev);
>>> +       if (tp->dash_type == RTL_DASH_NONE)
>>> +               phy_disconnect(tp->phydev);
>>>  
>>>         dma_free_coherent(&pdev->dev, R8169_RX_RING_BYTES, tp->RxDescArray,
>>>                           tp->RxPhyAddr);
>>>
>>
>> Some additional data points:
>>
>> - with r8169 blacklisted the link survives shutdown
>>
>> - even with r8169 blacklisted the DASH web interface stops being able to
>> control power/off/reset
>>
>> - with rtl8168_driver_start/stop commented followed by rmmod r8169 and
>> link still up  it still goes down on shutdown
> 
> After some random poking I managed to keep the link up after shutdown. 
> All the previous bits plus this init tweak:
> 
> @@ -5409,7 +5417,8 @@ static int rtl_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
>         /* configure chip for default features */
>         rtl8169_set_features(dev, dev->features);
>  
> -       rtl_set_d3_pll_down(tp, true);
> +       if (tp->dash_type == RTL_DASH_NONE)
> +               rtl_set_d3_pll_down(tp, true);
>  
>         jumbo_max = rtl_jumbo_max(tp);
>         if (jumbo_max)
> 

Thanks for your efforts. We can not omit the phy_.. calls in the non-DASH case,
therefore could you please test the following (replacing the first attempt)?


diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 67014eb76..33f5c5698 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -1397,8 +1397,11 @@ static void __rtl8169_set_wol(struct rtl8169_private *tp, u32 wolopts)
 	rtl_lock_config_regs(tp);
 
 	device_set_wakeup_enable(tp_to_dev(tp), wolopts);
-	rtl_set_d3_pll_down(tp, !wolopts);
-	tp->dev->wol_enabled = wolopts ? 1 : 0;
+
+	if (tp->dash_type == RTL_DASH_NONE) {
+		rtl_set_d3_pll_down(tp, !wolopts);
+		tp->dev->wol_enabled = wolopts ? 1 : 0;
+	}
 }
 
 static int rtl8169_set_wol(struct net_device *dev, struct ethtool_wolinfo *wol)
@@ -4938,6 +4941,9 @@ static int rtl8169_runtime_idle(struct device *device)
 {
 	struct rtl8169_private *tp = dev_get_drvdata(device);
 
+	if (tp->dash_type != RTL_DASH_NONE)
+		return -EBUSY;
+
 	if (!netif_running(tp->dev) || !netif_carrier_ok(tp->dev))
 		pm_schedule_suspend(device, 10000);
 
@@ -4978,7 +4984,8 @@ static void rtl_shutdown(struct pci_dev *pdev)
 	/* Restore original MAC address */
 	rtl_rar_set(tp, tp->dev->perm_addr);
 
-	if (system_state == SYSTEM_POWER_OFF) {
+	if (system_state == SYSTEM_POWER_OFF &&
+	    tp->dash_type == RTL_DASH_NONE) {
 		if (tp->saved_wolopts)
 			rtl_wol_shutdown_quirk(tp);
 
@@ -5449,7 +5456,12 @@ static int rtl_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	/* configure chip for default features */
 	rtl8169_set_features(dev, dev->features);
 
-	rtl_set_d3_pll_down(tp, true);
+	if (tp->dash_type == RTL_DASH_NONE) {
+		rtl_set_d3_pll_down(tp, true);
+	} else {
+		rtl_set_d3_pll_down(tp, false);
+		dev->wol_enabled = 1;
+	}
 
 	jumbo_max = rtl_jumbo_max(tp);
 	if (jumbo_max)
-- 
2.35.1


