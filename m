Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BCC5229957
	for <lists+netdev@lfdr.de>; Wed, 22 Jul 2020 15:43:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732483AbgGVNm0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jul 2020 09:42:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732476AbgGVNmZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jul 2020 09:42:25 -0400
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59176C0619DC
        for <netdev@vger.kernel.org>; Wed, 22 Jul 2020 06:42:25 -0700 (PDT)
Received: by mail-ej1-x642.google.com with SMTP id y10so2271362eje.1
        for <netdev@vger.kernel.org>; Wed, 22 Jul 2020 06:42:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=jXgAXCEDsC829k4D1lyuLHiL7I7MYIotT8rbhGrW/y8=;
        b=r1zGw3up7cFv29+4fN6pS4b5pju96gwkBmEBnNQoS7mTYtdRJzgh9015DDakLR+yCi
         Tuf6u61Vaedrqed/JPLJWrUD8kJvAFqlTmHqEQEPQr5Z1Ub/dDSGQhxLckydrYEkCrC9
         bn4TeSTarNDpK8bS259UXPXXbNsdEeL9fckDcsUDFwCaK4zoA3P7XV/tYFYW7IcRzYfE
         rFAfddhdHMFDt7tAXM6pXANjlgI82AcWrWbwKYcX1og3gfJmSTllRTgzvdWgvQevZ+IM
         LZZE0K8TuwMN4dr5QcTp2KG+kKTsyQ5766mO3Wjrvg7A9gsRTZzRq6nmj0Oe3QzXIlvM
         5EMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=jXgAXCEDsC829k4D1lyuLHiL7I7MYIotT8rbhGrW/y8=;
        b=UA7jr/6mXcIyZlgdtaFQpE23+qPVL2ZN08r1INpEs3CWa6BN8sP89gnbiKoe2iy8bi
         wC35o2Hvj9xvQdxgXe9ursVUJJTC/2q3JCVDJVhy2TLfMEgk/5x1uS528lMGTWIO6HQk
         Pp46+NgRBa3ehg5hRXtCrox9gXztroKnaOMkZptBYO1tccvKBxmRZGLgR2wHd3Szb8bB
         KNGGqkQ4gzvYs+ZEcEww3zNmVJ9HtQCOWeGPKxBuwpPfzT0r6PMgEWXNdQnSP8jMq/CL
         x9Vmu+rj+bsQxIqUf0/134/dEVhqR/djCL4NF6NPL3UB6QugGwBpgEGnnR78vunaawEx
         /e8A==
X-Gm-Message-State: AOAM5314pHmiZ99RxGr9C4JSwafq6rEdhj7v6CM6eLiS+OohqoI6+1ez
        eXaNI7IaRmD617SIchiNeDU=
X-Google-Smtp-Source: ABdhPJzJc00TJhf+Asb1Caf8dcf9T4WhzKQofIHB2mYL5MpJXZYScG0lmqNieKTBxbdc8EDtUGS2vw==
X-Received: by 2002:a17:906:f2c4:: with SMTP id gz4mr29811947ejb.484.1595425343760;
        Wed, 22 Jul 2020 06:42:23 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f23:5700:ac7e:458:8900:888c? (p200300ea8f235700ac7e04588900888c.dip0.t-ipconnect.de. [2003:ea:8f23:5700:ac7e:458:8900:888c])
        by smtp.googlemail.com with ESMTPSA id w20sm19369334eds.21.2020.07.22.06.42.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Jul 2020 06:42:23 -0700 (PDT)
Subject: Re: fec: micrel: Ethernet PHY type ID auto-detection issue
To:     Bruno Thomsen <bth@kamstrup.com>, Andrew Lunn <andrew@lunn.ch>,
        Fabio Estevam <festevam@gmail.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        Lars Alex Pedersen <laa@kamstrup.com>,
        "bruno.thomsen@gmail.com" <bruno.thomsen@gmail.com>
References: <CAH+2xPCzrBgngz5cY9DDDjnFUBNa=NSH3VMchFcnoVbjSm3rEw@mail.gmail.com>
 <CAOMZO5DtYDomD8FDCZDwYCSr2AwNT81Ay4==aDxXyBxtyvPiJA@mail.gmail.com>
 <20200717163441.GA1339445@lunn.ch>
 <AM0PR04MB697747DD5CFED332E6729122DC780@AM0PR04MB6977.eurprd04.prod.outlook.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <b8f2dbe4-1c30-b969-6a8c-79f808bc3e12@gmail.com>
Date:   Wed, 22 Jul 2020 15:42:17 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <AM0PR04MB697747DD5CFED332E6729122DC780@AM0PR04MB6977.eurprd04.prod.outlook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 22.07.2020 12:59, Bruno Thomsen wrote:
> Hi Andrew, 
> 
>>>> I have been having issues with Ethernet PHY type ID
>>>> auto-detection when changing from the deprecated fec
>>>> phy-reset-{gpios,duration,post-delay} properties to the
>>>> modern mdio reset-{assert-us,deassert-us,gpios}
>>>> properties in the device tree.
>>
>>>> Kernel error messages (modem mdio reset):
>>>> mdio_bus 30be0000.ethernet-1: MDIO device at address 1 is missing.
>>>> fec 30be0000.ethernet eth0: Unable to connect to phy
>>
>> It sounds like the PHY is not responding during scanning of the bus.
> 
> Yes, that is correct.
> 
>> If the ID is mostly 0xff there is no device there.
>>
>> So check the initial reset state of the PHY, and when is it taken out
>> of reset, and is the delay long enough for it to get itself together
>> and start answering requests.
> 
> When capturing traces with a logic analyzer, I do the following:
> - break the target in the bootloader
> - start trigger on reset or mdio signal (had to use mdio as reset wasn't used)
> - boot linux
> 
> I monitor 4 signals: MDIO, MDC, 3V3, reset.
> 
> The new mdio code path does not reset the PHY before reading
> of PHY type ID and for some reason this result in no responce,
> e.g. high (0xFFFF) and missing MDIO turnaround.
> 
> MDC is 2.5MHz, and I can decode the 2 read requests with a logic
> analyzer:
> 
> START C22
> OPCODE [Read]
> PHY Address ['1' (0x01)]
> Register Address ['2' (0x02)]
> !Turnaround
> Data ['65535' (0xFFFF)]
> 
> START C22
> OPCODE [Read]
> PHY Address ['1' (0x01)]
> Register Address ['3' (0x03)]
> !Turnaround
> Data ['65535' (0xFFFF)]
> 
> When using the deprecated fec phy reset code path, the PHY
> chip is reset just before reading of register 0x02 and 0x03.
> In this case the PHY respond correct with 0x0022 and 0x1561.
> 
> When looking at the mdio code I don't understand how the
> reset code should even work in the first place.
> 
>> static int mdio_probe(struct device *dev)
>> {
>> 	struct mdio_device *mdiodev = to_mdio_device(dev);
>> 	struct device_driver *drv = mdiodev->dev.driver;
>> 	struct mdio_driver *mdiodrv = to_mdio_driver(drv);
>> 	int err = 0;
>>
>> 	if (mdiodrv->probe) {
>> 		/* Deassert the reset signal */
>> 		mdio_device_reset(mdiodev, 0);
> 
> This assumes that the reset signal is asserted already.
> Not my case and it seems very flaky.
> 
> Deprecated fec code assert reset signal before reset assert delay,
> following deassert reset and deassert delay.
> https://elixir.bootlin.com/linux/latest/source/drivers/net/ethernet/freescale/fec_main.c#L3373
> 
>>
>> 		err = mdiodrv->probe(mdiodev);
>> 		if (err) {
>> 			/* Assert the reset signal */
>> 			mdio_device_reset(mdiodev, 1);
> 
> Reset signal is asserted in error path but there are no
> retry on probe.
> 
> 
>> void mdio_device_reset(struct mdio_device *mdiodev, int value)
>> {
>> 	unsigned int d;
>>
>> 	......
>>
>> 	d = value ? mdiodev->reset_assert_delay : mdiodev->reset_deassert_delay;
>> 	if (d)
>> 		usleep_range(d, d + max_t(unsigned int, d / 10, 100));
> 
> This is not the recommended way of sleeping if d > 20ms.
> 
Meanwhile there's a helper fsleep() that considers the thresholds for calling
udelay/usleep_range/msleep.

> https://www.kernel.org/doc/Documentation/timers/timers-howto.txt
> 
> The deprecated fec code handles this correctly.
> https://elixir.bootlin.com/linux/latest/source/drivers/net/ethernet/freescale/fec_main.c#L3381
> 
> if (d)
> 	if (d > 20000)
> 		msleep(d / 1000);
> 	else
> 		usleep_range(d, d + max_t(unsigned int, d / 10, 100));
> 
> 
> Micrel recommended reset circuit has a deassert tau of 100ms, e.g. 10k * 10uF.
> So to be sure the signal is deasserted 5 * tau or more, and this brings the value
> up in the 500-1000ms range depending on component tolerances and design
> margin.
> 
> See figure 22 in pdf for reset circuit.
> http://ww1.microchip.com/downloads/en/devicedoc/ksz8081mnx-rnb.pdf
> 
> So my current conclusion is that using generic mdio phy handling does
> not work with Micrel PHYs unless 3 issues has been resolved.
> - Reset PHY before auto type detection.
> - Add initial assert reset signal + delay when resetting phy.
> - Handle >20ms reset delays.
> 
> /Bruno
> 
> ----
> When using the 5.8.0-rc6 kernel (dirty due to device tree changes),
> I sometimes hit this kernel issue (never seen it with 5.7.8 or earlier),
> but don't think it's related:
> 
> kernel: =============================================================================
> kernel: BUG task_struct(119:NetworkManager-dispatcher.service) (Not tainted): Poison overwritten
> kernel: -----------------------------------------------------------------------------
> kernel: Disabling lock debugging due to kernel taint
> kernel: INFO: 0xe05e9b3f-0x9b36c418 @offset=30464. First byte 0xff instead of 0x6b
> kernel: INFO: Slab 0xaa165da6 objects=18 used=0 fp=0x37e5d9c3 flags=0x10200
> kernel: INFO: Object 0xf19b9dd9 @offset=29440 fp=0x00000000
> kernel: Redzone cb135af3: bb bb bb bb bb bb bb bb bb bb bb bb bb bb bb bb  ................
> kernel: Redzone a0061a8a: bb bb bb bb bb bb bb bb bb bb bb bb bb bb bb bb  ................
> kernel: Redzone f2917653: bb bb bb bb bb bb bb bb bb bb bb bb bb bb bb bb  ................
> kernel: Redzone aeb00bb5: bb bb bb bb bb bb bb bb bb bb bb bb bb bb bb bb  ................
> kernel: Object f19b9dd9: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
> kernel: Object cadb3eab: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
> kernel: Object a51c2cd1: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
> kernel: Object 6b25d1e5: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
> kernel: Object 1e35e7e8: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
> kernel: Object aea2a999: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
> kernel: Object e160fc75: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
> kernel: Object c1c29834: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
> kernel: Object 17ff6205: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
> kernel: Object a6781094: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
> kernel: Object ce2fd05e: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
> kernel: Object 7daa8dfb: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
> kernel: Object 4c0e09e9: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
> kernel: Object b23b73b7: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
> kernel: Object 698ecfeb: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
> kernel: Object c0437471: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
> kernel: Object a9236eff: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
> kernel: Object 4a6eac62: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
> kernel: Object 7fda2c51: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
> kernel: Object 8f143bf4: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
> kernel: Object aaa2bfdd: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
> kernel: Object 22d54b92: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
> kernel: Object 8fcef107: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
> kernel: Object d2a1c8a9: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
> kernel: Object b25c8021: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
> kernel: Object 1bed0f85: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
> kernel: Object a6c9ddc2: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
> kernel: Object 306f6960: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
> kernel: Object 478e89fc: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
> kernel: Object 90f8a983: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
> kernel: Object 0d8a4733: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
> kernel: Object 254b16da: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
> kernel: Object 409e6dac: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
> kernel: Object d043695a: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
> kernel: Object abee8a24: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
> kernel: Object 18715fa9: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
> kernel: Object fb3630b3: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
> kernel: Object 3aaedaf7: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
> kernel: Object 32565782: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
> kernel: Object 26869f35: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
> kernel: Object 789a34f9: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
> kernel: Object 8865b386: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
> kernel: Object a0d7868e: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
> kernel: Object 9cd04fce: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
> kernel: Object 4214b445: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
> kernel: Object 9d69b597: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
> kernel: Object 845ea8c4: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
> kernel: Object 2c937a0b: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
> kernel: Object eb5293e8: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
> kernel: Object dab824c2: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
> kernel: Object bfa6c2fa: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
> kernel: Object a2c4a8be: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
> kernel: Object 5e1f207c: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
> kernel: Object a974428f: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
> kernel: Object 91af2a44: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
> kernel: Object 6f71ee6f: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
> kernel: Object d4abc42d: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
> kernel: Object 3737f8db: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
> kernel: Object 65bd39e9: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
> kernel: Object cd12758c: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
> kernel: Object 212096ca: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
> kernel: Object 8462745b: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
> kernel: Object a430d1b2: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
> kernel: Object 7a0d1289: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
> kernel: Object e05e9b3f: ff 4d ff ff ff ff ff ff 10 e7 c6 77 3e 38 08 00  .M.........w>8..
> kernel: Object 8c5945af: 45 00 00 48 42 05 00 00 80 11 75 5c ac 14 15 1c  E..HB.....u\....
> kernel: Object de1b76ee: ac 14 15 ff e1 15 e1 15 00 34 8a 61 53 70 6f 74  .........4.aSpot
> kernel: Object a54d91d1: 55 64 70 30 94 e4 06 54 2b ed 49 66 00 01 00 04  Udp0...T+.If....
> kernel: Object 08ebc3be: 48 95 c2 03 94 eb 5d 89 b7 b5 0c 41 d7 12 76 ea  H.....]....A..v.
> kernel: Object ff29f54f: b1 7e 4d ed bb 74 cc c7 62 3d 2f 10 bb 74 cc c7  .~M..t..b=/..t..
> kernel: Object 9678dfaa: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
> kernel: Object 426da6d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
> kernel: Object 7fab2713: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
> kernel: Object 60862a98: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
> kernel: Object 0810ad40: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
> kernel: Object 1f0aa745: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
> kernel: Object 19944bf2: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
> kernel: Object 4ce341aa: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
> kernel: Object 9607ec6d: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
> kernel: Object a5915de7: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
> kernel: Object d686baa6: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
> kernel: Object 1df19b0d: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
> kernel: Object 0bbe9a96: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
> kernel: Object 6f1e7700: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
> kernel: Object 824ce600: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
> kernel: Object 790d4580: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
> kernel: Object f8a184dd: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
> kernel: Object f65d9e18: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
> kernel: Object b52e601b: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
> kernel: Object 82bf9d2e: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
> kernel: Object bf8060fe: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
> kernel: Object e90100be: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
> kernel: Object ea74812b: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
> kernel: Object e6403677: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
> kernel: Object faf222d4: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
> kernel: Object dca677d2: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
> kernel: Object 1c2391f0: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
> kernel: Object fb8b9c6d: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
> kernel: Object 967ee7ed: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
> kernel: Object f597fef4: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b a5  kkkkkkkkkkkkkkk.
> kernel: Redzone 13b0f2f9: bb bb bb bb                                      ....
> kernel: Padding 372127fe: 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a  ZZZZZZZZZZZZZZZZ
> kernel: Padding 6d5fbace: 5a 5a 5a 5a 5a 5a 5a 5a                          ZZZZZZZZ
> kernel: CPU: 0 PID: 127 Comm: kworker/0:3 Tainted: G    B             5.8.0-rc6-00008-g87d248347e60-dirty #1
> kernel: Hardware name: Freescale i.MX7 Dual (Device Tree)
> kernel: Workqueue: memcg_kmem_cache kmemcg_workfn
> kernel: [<8010ed20>] (unwind_backtrace) from [<8010b734>] (show_stack+0x10/0x14)
> kernel: [<8010b734>] (show_stack) from [<8047caf4>] (dump_stack+0x8c/0xa0)
> kernel: [<8047caf4>] (dump_stack) from [<8027351c>] (check_bytes_and_report+0xcc/0xe8)
> kernel: [<8027351c>] (check_bytes_and_report) from [<80274e0c>] (check_object+0x248/0x2ac)
> kernel: [<80274e0c>] (check_object) from [<80274edc>] (__free_slab+0x6c/0x2bc)
> kernel: [<80274edc>] (__free_slab) from [<80279a1c>] (__kmem_cache_shrink+0x1f4/0x248)
> kernel: [<80279a1c>] (__kmem_cache_shrink) from [<80279a7c>] (__kmemcg_cache_deactivate_after_rcu+0xc/0x4c)
> kernel: [<80279a7c>] (__kmemcg_cache_deactivate_after_rcu) from [<80249bb8>] (kmemcg_cache_deactivate_after_rcu+0xc/0x1c)
> kernel: [<80249bb8>] (kmemcg_cache_deactivate_after_rcu) from [<80249b98>] (kmemcg_workfn+0x24/0x38)
> kernel: [<80249b98>] (kmemcg_workfn) from [<80140000>] (process_one_work+0x19c/0x3e4)
> kernel: [<80140000>] (process_one_work) from [<8014028c>] (worker_thread+0x44/0x4dc)
> kernel: [<8014028c>] (worker_thread) from [<80146a2c>] (kthread+0x144/0x180)
> kernel: [<80146a2c>] (kthread) from [<80100148>] (ret_from_fork+0x14/0x2c)
> kernel: Exception stack(0xbb1d5fb0 to 0xbb1d5ff8)
> kernel: 5fa0:                                     00000000 00000000 00000000 00000000
> kernel: 5fc0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
> kernel: 5fe0: 00000000 00000000 00000000 00000000 00000013 00000000
> kernel: FIX task_struct(119:NetworkManager-dispatcher.service): Restoring 0xe05e9b3f-0x9b36c418=0x6b
> 

