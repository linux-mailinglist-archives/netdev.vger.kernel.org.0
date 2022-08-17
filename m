Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98EEC59676B
	for <lists+netdev@lfdr.de>; Wed, 17 Aug 2022 04:28:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237050AbiHQC2g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Aug 2022 22:28:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229453AbiHQC2e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Aug 2022 22:28:34 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2596A2BB13;
        Tue, 16 Aug 2022 19:28:31 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id e8-20020a17090a280800b001f2fef7886eso596709pjd.3;
        Tue, 16 Aug 2022 19:28:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=/88LFCybNpQT4FoBaHAzf79kXBntghACH0Sm9eDs1ug=;
        b=SQISoJpmrNlyVIQV4qSAQeJYpFi3VufCETLC2aEtJQ7ll7Audzo6RNVtBqjT1yxra4
         wW2P5j3v9WZS5I8flykM15x01276Oh0fvAWNG/zLaWgkEk7STKkf3e2hVsN0O12qJhZt
         cNxbIT+35UxEKuT4KBFKTZQZSDRle9ftym8Xdyv1a0vJ3e6gxa2242C5MBosKveJ3ZcL
         4bwceLM2VgGCv60Gfn8pGx9GQV4nJSoBIsWAkw7R+2+3lcR3gOnWZVS7JKympyO8UxHw
         82rOyGFIW1fNhV5zA72p52k6QEJN50CbZpHdbH//rjBpBFoV2RpYITduHMItcS1VFtqn
         uNqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=/88LFCybNpQT4FoBaHAzf79kXBntghACH0Sm9eDs1ug=;
        b=qO6fXgteLYkPpk3pRz7DpMcKXBs1VEh3GnqXEZnVWIElYcL87eveNi3eiXxNcYUVCa
         ltRV15L740vUc9biaRHxD50e86GQiGzemi4pcBdtpph6rJAU56pNLEYpaw14P4Ncmtgu
         vjaPAzhExVZG87NP50HklJYMkHpWmD2DSrd0VAppy4TLIBWiGVJRcTD13GARVSP3VAMQ
         Lcq5+P5zoW5lj7B3DFEnOPYR0fkf+rlm6H6KlHGDsRhZk0i7VHc0Ch20CCH8z5QFsRWi
         7m+9fY04I3YNlKlmWAnW5N6BMnavxPx2M9RCmAm58ssOZxXuC9yykGz5sprZSeVmo3pt
         eaGw==
X-Gm-Message-State: ACgBeo2u+bpnT5HHDO2yMGK7giNGxwH99i2s5GciFhJpr8gLM2C6wRFZ
        0OuBGQdhhJ8F5OV52N04pOii8l4QJFHZ3Q==
X-Google-Smtp-Source: AA6agR7lAjMOAYeqI28CLQ3hUbdkZbsUT9+81biUmjDnnYhy2UuUbj4kZEXGJvdv79d/5mCul5/hCA==
X-Received: by 2002:a17:902:ab13:b0:172:63bf:4e39 with SMTP id ik19-20020a170902ab1300b0017263bf4e39mr16505805plb.173.1660703310492;
        Tue, 16 Aug 2022 19:28:30 -0700 (PDT)
Received: from ?IPV6:2600:8802:b00:4a48:c1a6:4b60:fa53:d7ab? ([2600:8802:b00:4a48:c1a6:4b60:fa53:d7ab])
        by smtp.gmail.com with ESMTPSA id w4-20020a170902ca0400b001728ecd2277sm97770pld.113.2022.08.16.19.28.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 16 Aug 2022 19:28:29 -0700 (PDT)
Message-ID: <c1301f39-9202-5eee-a0f6-9c0b66f2dccf@gmail.com>
Date:   Tue, 16 Aug 2022 19:28:28 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.1.2
Subject: Re: [PATCH net] net: phy: Warn about incorrect mdio_bus_phy_resume()
 state
Content-Language: en-US
To:     Geert Uytterhoeven <geert@linux-m68k.org>
Cc:     Marek Szyprowski <m.szyprowski@samsung.com>,
        netdev <netdev@vger.kernel.org>,
        Steve Glendinning <steve.glendinning@shawell.net>,
        Doug Berger <opendmb@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        open list <linux-kernel@vger.kernel.org>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        Sergey Shtylyov <s.shtylyov@omp.ru>
References: <20220801233403.258871-1-f.fainelli@gmail.com>
 <CGME20220812111948eucas1p2bf97e7f4558eb024f419346367a87b45@eucas1p2.samsung.com>
 <27016cc0-f228-748b-ea03-800dda4e5f0c@samsung.com>
 <8c21e530-8e8f-ce2a-239e-9d3a354996cf@gmail.com>
 <CAMuHMdV8vsbFx+nikAwn1po1-PeZVhzotMaLLk+wXNquZceaRQ@mail.gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <CAMuHMdV8vsbFx+nikAwn1po1-PeZVhzotMaLLk+wXNquZceaRQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/16/2022 6:20 AM, Geert Uytterhoeven wrote:
> Hi Florian,
> 
> On Fri, Aug 12, 2022 at 6:39 PM Florian Fainelli <f.fainelli@gmail.com> wrote:
>> On 8/12/22 04:19, Marek Szyprowski wrote:
>>> On 02.08.2022 01:34, Florian Fainelli wrote:
>>>> Calling mdio_bus_phy_resume() with neither the PHY state machine set to
>>>> PHY_HALTED nor phydev->mac_managed_pm set to true is a good indication
>>>> that we can produce a race condition looking like this:
>>>>
>>>> CPU0                                         CPU1
>>>> bcmgenet_resume
>>>>     -> phy_resume
>>>>       -> phy_init_hw
>>>>     -> phy_start
>>>>       -> phy_resume
>>>>                                                    phy_start_aneg()
>>>> mdio_bus_phy_resume
>>>>     -> phy_resume
>>>>        -> phy_write(..., BMCR_RESET)
>>>>         -> usleep()                                  -> phy_read()
>>>>
>>>> with the phy_resume() function triggering a PHY behavior that might have
>>>> to be worked around with (see bf8bfc4336f7 ("net: phy: broadcom: Fix
>>>> brcm_fet_config_init()") for instance) that ultimately leads to an error
>>>> reading from the PHY.
>>>>
>>>> Fixes: fba863b81604 ("net: phy: make PHY PM ops a no-op if MAC driver manages PHY PM")
>>>> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
>>>
>>> This patch, as probably intended, triggers a warning during system
>>> suspend/resume cycle in the SMSC911x driver. I've observed it on ARM
>>> Juno R1 board on the kernel compiled from next-202208010:
>>>
>>>     ------------[ cut here ]------------
>>>     WARNING: CPU: 1 PID: 398 at drivers/net/phy/phy_device.c:323
>>> mdio_bus_phy_resume+0x34/0xc8
> 
> I am seeing the same on the ape6evm and kzm9g development
> boards with smsc911x Ethernet, and on various boards with Renesas
> Ethernet (sh_eth or ravb) if Wake-on-LAN is disabled.
> 
>> Yes this is catching an actual issue in the driver in that the PHY state
>> machine is still running while the system is trying to suspend. We could
>> go about fixing it in a different number of ways, though I believe this
>> one is probably correct enough to work and fix the warning:
> 
>> --- a/drivers/net/ethernet/smsc/smsc911x.c
>> +++ b/drivers/net/ethernet/smsc/smsc911x.c
>> @@ -1037,6 +1037,8 @@ static int smsc911x_mii_probe(struct net_device *dev)
>>                   return ret;
>>           }
>>
>> +       /* Indicate that the MAC is responsible for managing PHY PM */
>> +       phydev->mac_managed_pm = true;
>>           phy_attached_info(phydev);
>>
>>           phy_set_max_speed(phydev, SPEED_100);
>> @@ -2587,6 +2589,8 @@ static int smsc911x_suspend(struct device *dev)
>>           if (netif_running(ndev)) {
>>                   netif_stop_queue(ndev);
>>                   netif_device_detach(ndev);
>> +               if (!device_may_wakeup(dev))
>> +                       phy_suspend(dev->phydev);
>>           }
>>
>>           /* enable wake on LAN, energy detection and the external PME
>> @@ -2628,6 +2632,8 @@ static int smsc911x_resume(struct device *dev)
>>           if (netif_running(ndev)) {
>>                   netif_device_attach(ndev);
>>                   netif_start_queue(ndev);
>> +               if (!device_may_wakeup(dev))
>> +                       phy_resume(dev->phydev);
>>           }
>>
>>           return 0;
> 
> Thanks for your patch, but unfortunately this does not work on ape6evm
> and kzm9g, where the smsc911x device is connected to a power-managed
> bus.  It looks like the PHY registers are accessed while the device
> is already suspended, causing a crash during system suspend:

Does it work better if you replace phy_suspend() with phy_stop() and 
phy_resume() with phy_start()?
-- 
Florian
