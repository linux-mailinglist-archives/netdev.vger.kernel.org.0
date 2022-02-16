Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 544BB4B8F14
	for <lists+netdev@lfdr.de>; Wed, 16 Feb 2022 18:22:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237075AbiBPRWn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Feb 2022 12:22:43 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:58498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234006AbiBPRWm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Feb 2022 12:22:42 -0500
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0EC3D0051
        for <netdev@vger.kernel.org>; Wed, 16 Feb 2022 09:22:29 -0800 (PST)
Received: by mail-pg1-x531.google.com with SMTP id 75so2723112pgb.4
        for <netdev@vger.kernel.org>; Wed, 16 Feb 2022 09:22:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=0cWOC9cd+Zv4q9jZVpbWuiP41aPu+CCLM4vJYQFKe4M=;
        b=hAbqXDHivGHIx5PN9edB5rBCXQSoeN2S/nHZcLqwTchKA36lVTWq2pOwBJHeemumEX
         0q5vhK/60SR68vKFR0MxDApyQgPAWGKi/PNJ/mW3gPFZ2P+2YxRM/FKyfR6wwyA7J9Xw
         UfBix+uCUwY2/U3qfhIg+b0aKl3xNo5mgFb/K20lvJS41cYAQ126lcRf0Yt7BFeWk775
         Vow0Fil8CMWO7MrbgzgvoTDQLmONg0xhTfEqk3KOc/eGr31leUVTZrgFZRgzfk2u2+KF
         OXgj8MwE/2ohLREIFPLpV2sZ9SdQ11yG7QLrTaRgM05rlMhwMGERM2hLt2WZboM1TnSi
         TiNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=0cWOC9cd+Zv4q9jZVpbWuiP41aPu+CCLM4vJYQFKe4M=;
        b=2zIIrrJQw/Uzb1fhs+DFTYsJwgBaU28Dp+v/e5KHlE4/FQWDVN6e8iuOpVCf9+0L3m
         aZEQe/oj/LDQVbBU4JqQAURvupB1Gh4fZOK4jNdF2xKO+6ZcOtjDynIrTxBGrRkrJLhh
         Pnl0dLcV5FWVHD5rjjfbwn2tc5XT8eWzCufou+M/2c8HcxQHKhk4lmrb91M00GNDz4Qk
         LDVIREj7TwAbUEVkwyi116maZfZczvDI3/opxdKLVkniMMVUdvYbxgoZ+RyKqfB0EBVW
         wOGXRtnzxjAd2rmeLCnccchTmVNXGWdaJ0GPxh+suoxH1eqhRAMOgYCSHUNOcOIqucW3
         t+Gg==
X-Gm-Message-State: AOAM5305jEwmkYK9oH0/Gl2Y7Dlvb2TauCvxWV6rPSLQj4sw6ydtHBGV
        z9EFg2OgyoXGTO7sma9F7Ae3ibOQOLw=
X-Google-Smtp-Source: ABdhPJyB4Q6/Ha46JTD48UFwHOCdSr0b1cb4vaE3jgfL8oC2hXLbhZqVwsrazplRTK6G8VUd7WL1xQ==
X-Received: by 2002:a05:6a00:124d:b0:4e1:30a5:29a9 with SMTP id u13-20020a056a00124d00b004e130a529a9mr4151906pfi.85.1645032148925;
        Wed, 16 Feb 2022 09:22:28 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id a15sm5628003pgd.11.2022.02.16.09.22.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 16 Feb 2022 09:22:28 -0800 (PST)
Subject: Re: DSA and Marvell Switch Drivers
To:     "Moltmann, Tobias" <Tobias.Moltmann@siemens.com>,
        Andrew Lunn <andrew@lunn.ch>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <PA4PR10MB46060AD14E4D15C2F50CA3AAE5359@PA4PR10MB4606.EURPRD10.PROD.OUTLOOK.COM>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <a8d12f90-4058-f567-f278-0521937700b1@gmail.com>
Date:   Wed, 16 Feb 2022 09:22:26 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <PA4PR10MB46060AD14E4D15C2F50CA3AAE5359@PA4PR10MB4606.EURPRD10.PROD.OUTLOOK.COM>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/16/22 12:55 AM, Moltmann, Tobias wrote:
> Hello,
> 
> I would first rewrite my questions and provide some information's and add some of Andrews answer to it as well.
> As I learned it would be helpful to address the "netdev list" to get (hopefully) even more help. 
> So please feel free to provide some feedback, thank you!
> 
> The issue we face comes along with an Kernel upgrade from 4.4.xxx to now 5.10.xx. It is all industrial-based hardware, so 
> no classical PC or something. On the hardware we have an x86 CPU, an IGB -> Marvell Switch (Marvell 88E6176) ->
> and two PHY's connected there.
> 
> Very roughly the way it worked/run with the 4.4 Kernel:
> 
> - mv88e6xxx_init() called - registered the driver
> - IGB driver loaded, started probing
> - within the probing we set up an MDIO bus (name: igb MDIO, id: 0000:01:00.0_mii)
> - the libphy does a first scan with no result due to some other missing stuff - at this point it is ok
> - also within the igb probing we set up an dsa_platform_data struct and run a platform_device_register()
> - this triggers the DSA driver
> - mv88e6352_probe() is called our Marvell switch is detected
> - a new DSA slave MDIO bus is been brought up automatically
> - mdiobus_scan() there register our two PHY devices 
> - everything is working :)
> 
> 
> Now in the 5.10 Kernel, as there are the rewritten DSA/Marvell drivers included, the upper "stuff" is not working anymore.
> So far so good... Due to the fact, that the DSA/Marvell drivers aren't platform driver anymore the trigger with the platform_device_register()
> has no effect any more. I suggest we need to end up in the new mv88e6xxx_probe() function in drivers/net/dsa/mv88e6xxx/chip.c.
> As there is all the probing, register of DSA stuff included. 
> I added some "printf" in the module init parts in the chip.c file as well as in the /net/dsa/dsa.c - and I do see them in the
> Kernel logfile after startup. Everything else I added as output, does not show up.
> 
> Andrew already pointed out, that you now have to set up (as example) the following:
> 
> static struct dsa_mv88e6xxx_pdata dsa_mv88e6xxx_pdata = {
>         .cd = {
>                 .port_names[0] = NULL,
>                 .port_names[1] = "cpu",
>                 .port_names[2] = "red",
>                 .port_names[3] = "blue",
>                 .port_names[4] = "green",
>                 .port_names[5] = NULL,
>                 .port_names[6] = NULL,
>                 .port_names[7] = NULL,
>                 .port_names[8] = "waic0",
>         },
>         .compatible = "marvell,mv88e6190",
>         .enabled_ports = BIT(1) | BIT(2) | BIT(3) | BIT(4) | BIT(8),
>         .eeprom_len = 65536,
> };
> 
> static const struct mdio_board_info bdinfo = {
>         .bus_id = "gpio-0",
>         .modalias = "mv88e6085",
>         .mdio_addr = 0,
>         .platform_data = &dsa_mv88e6xxx_pdata, };
> 
>         dsa_mv88e6xxx_pdata.netdev = dev_get_by_name(&init_net, "eth0");
>         if (!dsa_mv88e6xxx_pdata.netdev) {
>                 dev_err(dev, "Error finding Ethernet device\n");
>                 return -ENODEV;
>         }
> 
>         err = mdiobus_register_board_info(&bdinfo, 1);
>         if (err) {
>                 dev_err(dev, "Error setting up MDIO board info\n");
>                 goto out;
>         }
> 
> I did a bunch of tries with this information's, put in our .bus_id, changed the port_names accordingly, switched the board register up and down etc. 
> but it still does not succeed ☹ 
> As Andrew also mentioned there is no mainline example and I'm also a bit confused that I haven't found (might be limitated to my person)
> any example somewhere out there which will put some light in our darkness...
> 
> So I would appreciate any help from you guys.
> You can also contact me directly - feel free if you think it a more optimized way. 
> I'll share my solution/information's if it works someday ...

There is a working example of registering a dsa platform data based
switch under drivers/net/dsa/dsa_loop_bdinfo.c can you try to get
inspiration from that one and see where the registration fails?
-- 
Florian
