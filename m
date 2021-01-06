Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 933F52EC529
	for <lists+netdev@lfdr.de>; Wed,  6 Jan 2021 21:39:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726808AbhAFUiZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jan 2021 15:38:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727362AbhAFUiY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jan 2021 15:38:24 -0500
Received: from mail-lf1-x12d.google.com (mail-lf1-x12d.google.com [IPv6:2a00:1450:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 239E9C061575
        for <netdev@vger.kernel.org>; Wed,  6 Jan 2021 12:37:44 -0800 (PST)
Received: by mail-lf1-x12d.google.com with SMTP id o19so9629897lfo.1
        for <netdev@vger.kernel.org>; Wed, 06 Jan 2021 12:37:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Oo/UcMGQKopNOjNOeiN5/OelccMhyMI2pJTK/KByn5w=;
        b=IOuJU4mF1K72Idv/g3rQPmQoWS/75ScvXVEpbJCrjH7dFR87ucisv+FkayGyPvStgt
         vhGCCppSynkuV5Nh7zjlkipB0tzeGoDfxbL6RUSBJBNzH9CBJ5x+sDCKL2Wjmi6WNCch
         StsRaGnd/XWOLfMvffWQ1XebOiBTeVZyPkjOoofdcRNFojZ0eIHu+UbyFTy1Ngvc3XwA
         n7QcN1lUH/oDvD9nyzsCE/5n4QlGCzc49TfC3HS/om+vGgKjENiZ2oE5ChCJYMl33b02
         DfwvA9IoOLgC1u5AtCDhqAx+9yvXRvhWYWemtdB/AfoVQT1ZMl0oKzLzbmr1ppbAyA4A
         dxtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Oo/UcMGQKopNOjNOeiN5/OelccMhyMI2pJTK/KByn5w=;
        b=Zu89jjzQILKLgyAbsxaQac/X3G30dx+dI0EmogRyNhSBJEaq+z+xot/z9iEAIytOOG
         FTfuv+R/FBSnQQDpz5vLs9Y/Plf6Wdo9ZuIxxF7faSydEsnnBVemNCsT9uycdZGP+AF4
         8Hye9p9hUGBJjKBv3zTm3ttLmfAE12sE5upWB5cPBWO4QYe4kjvtbWWZwb9NlwSkKk8n
         cjQKBP5CcN8SKvykZ46d/S/0wCEDbfn2FuO5VIUcok5KztuPk3o28q1W1muc+rjPC9x9
         Z7Mtw0PIb8hwxXRPCqEQF9WS9Yhu4nNhmo4Dvshj5iMK0ibsGH9MN9GMJhedTy50gX/I
         xi1Q==
X-Gm-Message-State: AOAM5320gbcY0Qaxl+xA88O25h0B40oIZ43NwoRejfQ049wPCM32GO8A
        cIJYAbcUWc/vR0/gB0YEn94=
X-Google-Smtp-Source: ABdhPJwzdmQuGvtv48DGXNiln5j4mwlqbTaA7/AMQro2DkFH2N0x+CwwLdxi/JCx6Zt1vxhP4ESYPQ==
X-Received: by 2002:a2e:a402:: with SMTP id p2mr2632535ljn.270.1609965462629;
        Wed, 06 Jan 2021 12:37:42 -0800 (PST)
Received: from localhost.localdomain (ip-194-187-74-233.konfederacka.maverick.com.pl. [194.187.74.233])
        by smtp.googlemail.com with ESMTPSA id n15sm647382ljm.59.2021.01.06.12.37.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 Jan 2021 12:37:41 -0800 (PST)
Subject: Re: [PATCH net-next 2/2] net: broadcom: share header defining UniMAC
 registers
To:     Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Doug Berger <opendmb@gmail.com>, Ray Jui <ray.jui@broadcom.com>,
        Arun Parameswaran <arun.parameswaran@broadcom.com>,
        Murali Krishna Policharla <murali.policharla@broadcom.com>,
        Timur Tabi <timur@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        netdev@vger.kernel.org, bcm-kernel-feedback-list@broadcom.com,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>
References: <20210106073245.32597-1-zajec5@gmail.com>
 <20210106073245.32597-2-zajec5@gmail.com>
 <284cc000-edf1-e943-2531-8c23e9470de1@gmail.com>
From:   =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Message-ID: <ed92d6bd-0d07-afbb-6b53-23180a5abae9@gmail.com>
Date:   Wed, 6 Jan 2021 21:37:39 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <284cc000-edf1-e943-2531-8c23e9470de1@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 06.01.2021 20:26, Florian Fainelli wrote:
> On 1/5/21 11:32 PM, Rafał Miłecki wrote:
>> From: Rafał Miłecki <rafal@milecki.pl>
>>
>> UniMAC is integrated into multiple Broadcom's Ethernet controllers so
>> use a shared header file for it and avoid some code duplication.
>>
>> Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
>> ---
>>   MAINTAINERS                                   |  2 +
> 
> Don't you need to update the BGMAC section to also list unimac.h since
> it is a shared header now? This looks good to me, the conversion does
> produce the following warnings on x86-64 (and probably arm64, too):
> 
> drivers/net/ethernet/broadcom/bgmac.c: In function 'bgmac_set_rx_mode':
> drivers/net/ethernet/broadcom/bgmac.c:788:33: warning: conversion from
> 'long unsigned int' to 'u32' {aka 'unsigned int'} changes value from
> '18446744073709551599' to '4294967279' [-Woverflow]
>    788 |   bgmac_umac_cmd_maskset(bgmac, ~CMD_PROMISC, 0, true);
> drivers/net/ethernet/broadcom/bgmac.c: In function 'bgmac_mac_speed':
> drivers/net/ethernet/broadcom/bgmac.c:828:13: warning: conversion from
> 'long unsigned int' to 'u32' {aka 'unsigned int'} changes value from
> '18446744073709550579' to '4294966259' [-Woverflow]
>    828 |  u32 mask = ~(CMD_SPEED_MASK << CMD_SPEED_SHIFT | CMD_HD_EN);
>        |             ^
> drivers/net/ethernet/broadcom/bgmac.c: In function 'bgmac_chip_reset':
> drivers/net/ethernet/broadcom/bgmac.c:999:11: warning: conversion from
> 'long unsigned int' to 'u32' {aka 'unsigned int'} changes value from
> '18446744073197811804' to '3783227484' [-Woverflow]
>    999 |           ~(CMD_TX_EN |
>        |           ^~~~~~~~~~~~~
>   1000 |      CMD_RX_EN |
>        |      ~~~~~~~~~~~
>   1001 |      CMD_RX_PAUSE_IGNORE |
>        |      ~~~~~~~~~~~~~~~~~~~~~
>   1002 |      CMD_TX_ADDR_INS |
>        |      ~~~~~~~~~~~~~~~~~
>   1003 |      CMD_HD_EN |
>        |      ~~~~~~~~~~~
>   1004 |      CMD_LCL_LOOP_EN |
>        |      ~~~~~~~~~~~~~~~~~
>   1005 |      CMD_CNTL_FRM_EN |
>        |      ~~~~~~~~~~~~~~~~~
>   1006 |      CMD_RMT_LOOP_EN |
>        |      ~~~~~~~~~~~~~~~~~
>   1007 |      CMD_RX_ERR_DISC |
>        |      ~~~~~~~~~~~~~~~~~
>   1008 |      CMD_PRBL_EN |
>        |      ~~~~~~~~~~~~~
>   1009 |      CMD_TX_PAUSE_IGNORE |
>        |      ~~~~~~~~~~~~~~~~~~~~~
>   1010 |      CMD_PAD_EN |
>        |      ~~~~~~~~~~~~
>   1011 |      CMD_PAUSE_FWD),
>        |      ~~~~~~~~~~~~~~
> drivers/net/ethernet/broadcom/bgmac.c: In function 'bgmac_enable':
> drivers/net/ethernet/broadcom/bgmac.c:1057:32: warning: conversion from
> 'long unsigned int' to 'u32' {aka 'unsigned int'} changes value from
> '18446744073709551612' to '4294967292' [-Woverflow]
>   1057 |  bgmac_umac_cmd_maskset(bgmac, ~(CMD_TX_EN | CMD_RX_EN),
>        |                                ^~~~~~~~~~~~~~~~~~~~~~~~
> drivers/net/ethernet/broadcom/bgmac.c: In function 'bgmac_chip_init':
> drivers/net/ethernet/broadcom/bgmac.c:1108:32: warning: conversion from
> 'long unsigned int' to 'u32' {aka 'unsigned int'} changes value from
> '18446744073709551359' to '4294967039' [-Woverflow]
>   1108 |  bgmac_umac_cmd_maskset(bgmac, ~CMD_RX_PAUSE_IGNORE, 0, true);
> drivers/net/ethernet/broadcom/bgmac.c:1117:33: warning: conversion from
> 'long unsigned int' to 'u32' {aka 'unsigned int'} changes value from
> '18446744073709518847' to '4294934527' [-Woverflow]
>   1117 |   bgmac_umac_cmd_maskset(bgmac, ~CMD_LCL_LOOP_EN, 0, false);

I can reproduce that after switching from mips to arm64. Before this
change bgmac.h was not using BIT() macro. Now it does and that macro
forces UL (unsigned long).

Is there any cleaner solution than below one?


diff --git a/drivers/net/ethernet/broadcom/bgmac.c b/drivers/net/ethernet/broadcom/bgmac.c
index 075f6e146b29..1cb0ec3d9b3a 100644
--- a/drivers/net/ethernet/broadcom/bgmac.c
+++ b/drivers/net/ethernet/broadcom/bgmac.c
@@ -785,7 +785,7 @@ static void bgmac_set_rx_mode(struct net_device *net_dev)
  	if (net_dev->flags & IFF_PROMISC)
  		bgmac_umac_cmd_maskset(bgmac, ~0, CMD_PROMISC, true);
  	else
-		bgmac_umac_cmd_maskset(bgmac, ~CMD_PROMISC, 0, true);
+		bgmac_umac_cmd_maskset(bgmac, (u32)~CMD_PROMISC, 0, true);
  }

  #if 0 /* We don't use that regs yet */
@@ -825,7 +825,7 @@ static void bgmac_clear_mib(struct bgmac *bgmac)
  /* http://bcm-v4.sipsolutions.net/mac-gbit/gmac/gmac_speed */
  static void bgmac_mac_speed(struct bgmac *bgmac)
  {
-	u32 mask = ~(CMD_SPEED_MASK << CMD_SPEED_SHIFT | CMD_HD_EN);
+	u32 mask = (u32)~(CMD_SPEED_MASK << CMD_SPEED_SHIFT | CMD_HD_EN);
  	u32 set = 0;

  	switch (bgmac->mac_speed) {
@@ -996,7 +996,7 @@ static void bgmac_chip_reset(struct bgmac *bgmac)
  		cmdcfg_sr = CMD_SW_RESET_OLD;

  	bgmac_umac_cmd_maskset(bgmac,
-			       ~(CMD_TX_EN |
+			       (u32)~(CMD_TX_EN |
  				 CMD_RX_EN |
  				 CMD_RX_PAUSE_IGNORE |
  				 CMD_TX_ADDR_INS |
@@ -1054,7 +1054,7 @@ static void bgmac_enable(struct bgmac *bgmac)
  		cmdcfg_sr = CMD_SW_RESET_OLD;

  	cmdcfg = bgmac_umac_read(bgmac, UMAC_CMD);
-	bgmac_umac_cmd_maskset(bgmac, ~(CMD_TX_EN | CMD_RX_EN),
+	bgmac_umac_cmd_maskset(bgmac, (u32)~(CMD_TX_EN | CMD_RX_EN),
  			       cmdcfg_sr, true);
  	udelay(2);
  	cmdcfg |= CMD_TX_EN | CMD_RX_EN;
@@ -1105,7 +1105,7 @@ static void bgmac_chip_init(struct bgmac *bgmac)
  	bgmac_write(bgmac, BGMAC_INT_RECV_LAZY, 1 << BGMAC_IRL_FC_SHIFT);

  	/* Enable 802.3x tx flow control (honor received PAUSE frames) */
-	bgmac_umac_cmd_maskset(bgmac, ~CMD_RX_PAUSE_IGNORE, 0, true);
+	bgmac_umac_cmd_maskset(bgmac, (u32)~CMD_RX_PAUSE_IGNORE, 0, true);

  	bgmac_set_rx_mode(bgmac->net_dev);

@@ -1114,7 +1114,7 @@ static void bgmac_chip_init(struct bgmac *bgmac)
  	if (bgmac->loopback)
  		bgmac_umac_cmd_maskset(bgmac, ~0, CMD_LCL_LOOP_EN, false);
  	else
-		bgmac_umac_cmd_maskset(bgmac, ~CMD_LCL_LOOP_EN, 0, false);
+		bgmac_umac_cmd_maskset(bgmac, (u32)~CMD_LCL_LOOP_EN, 0, false);

  	bgmac_umac_write(bgmac, UMAC_MAX_FRAME_LEN, 32 + ETHER_MAX_LEN);



> I did verify that the md5sum of the objects does not change before and
> after changes (except bgmac.o, which is expected due to the warning
> above0, so that gives me good confidence that the changes are correct :)
> 
> Acked-by: Florian Fainelli <f.fainelli@gmail.com>

Thanks!
