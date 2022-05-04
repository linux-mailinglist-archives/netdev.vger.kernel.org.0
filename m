Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F8BA51ABD7
	for <lists+netdev@lfdr.de>; Wed,  4 May 2022 19:53:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346575AbiEDRzx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 May 2022 13:55:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376625AbiEDRyy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 May 2022 13:54:54 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAFA35469F
        for <netdev@vger.kernel.org>; Wed,  4 May 2022 10:13:13 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id iq10so1819698pjb.0
        for <netdev@vger.kernel.org>; Wed, 04 May 2022 10:13:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=drqouNJ/3SzQU/uqYSQouGROjrZtgtnjed9pQY68xb0=;
        b=J0X2gJQc8MTLS5nyhE7Lpplq18NvDXFqs3L6HlBClPIahnBOr+aqgYG32VkNmQHUoT
         CF8ZPAHJDB4hLZrF00Y978AMew9ZenMc8yAW2CM4kqT07SjJ87j6Os593u07FuCTyPG5
         /Bq5uljGC94hAiEknv3hChfQLeaOQ10VVhVIkkZcU9v3RGtEdWbdvneekplTbWsMMkXI
         hPZM71jNDP+iTfzJCM3LnrAYauSw171zaN0BD8DF4+YxNjwqB0FGEJI9GaERX5GP+MWy
         Z7NjdgcSXrhAKz2qg70vFpdiJ9h8IXep5UOfr5uAfRLfkqeyCH/ljdXrzdnSyLsS8mWO
         VajQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=drqouNJ/3SzQU/uqYSQouGROjrZtgtnjed9pQY68xb0=;
        b=uBBrJexvFqPpDmz9bVP++KpB8VtjZLOdM1xiUVip+r287jhzlXODjCBjT1uKxV/P5p
         B8ql5RuYgHYdBKZCXsKHjS9pPKd4Y3g2Q3vckgqN0LBSa0Gxke+7w1v3ccQ2tv3GDJ+5
         h0XN5HlITrPiMeD3IQkjVs/mz07eG74R/4XppOXQ64dee1Zkjixg4QSNVHYmmAM5Fn2E
         eXa2Mj7zmqt9DoPE64E5StFqvXfRb5Fd99m6irSdaOWJ3OKiXaMAzNmweVuF25Iykp8h
         pLv0aDC9VXqFWe5ODBgxXDGJUTWbIfYX0m90tlUYl2Vh74LMngxkZwNwdi1z7Tghbt92
         qOzg==
X-Gm-Message-State: AOAM532/em4SxNPaNtr3gXL5FRmzKMgHaJJrCWG101cwd+joxpU+4fci
        bFj9LyYFqBG+xTYXfdUH1QU=
X-Google-Smtp-Source: ABdhPJxV4/onpJj+jRkj7f4kcK3XISTItJ8D/DcbXiWOncWyzPfLyx5gTOLi/E4d/ahNSf+CJwfE7w==
X-Received: by 2002:a17:902:9a0a:b0:158:a22a:5448 with SMTP id v10-20020a1709029a0a00b00158a22a5448mr23012430plp.20.1651684393153;
        Wed, 04 May 2022 10:13:13 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id c3-20020a17090a558300b001d5f22845bdsm4288533pji.1.2022.05.04.10.13.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 May 2022 10:13:12 -0700 (PDT)
Message-ID: <3d6aa110-8172-378c-c89e-7601111c8730@gmail.com>
Date:   Wed, 4 May 2022 10:13:11 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: imx6sx: Regression on FEC with KSZ8061
Content-Language: en-US
To:     Fabio Estevam <festevam@gmail.com>, Andrew Lunn <andrew@lunn.ch>
Cc:     Russell King - ARM Linux <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        netdev <netdev@vger.kernel.org>,
        NXP Linux Team <linux-imx@nxp.com>
References: <CAOMZO5BwYSgMZYHJcxV9bLcSQ2jjdFL47qr8o8FUj75z8SdhrQ@mail.gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <CAOMZO5BwYSgMZYHJcxV9bLcSQ2jjdFL47qr8o8FUj75z8SdhrQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/4/22 03:24, Fabio Estevam wrote:
> Hi,
> 
> On an imx6sx-based board, the Ethernet is functional on 5.10.
> 
> The board has a KSZ8061 Ethernet PHY.
> 
> After moving to kernel 5.15 or 5.17, the Ethernet is no longer functional:

This should help because kszphy_resume() calls kzsphy_config_reset() 
which sort of assumes that we have allocated a kszphy_priv structure 
from a probe function. Whenever we do not use the standard 
suspend/resume function, we need to make sure that we do have a .probe 
callback essentially.

diff --git a/drivers/net/phy/micrel.c b/drivers/net/phy/micrel.c
index 685a0ab5453c..1601b86415c5 100644
--- a/drivers/net/phy/micrel.c
+++ b/drivers/net/phy/micrel.c
@@ -3018,6 +3018,7 @@ static struct phy_driver ksphy_driver[] = {
         .name           = "Micrel KSZ8061",
         .phy_id_mask    = MICREL_PHY_ID_MASK,
         /* PHY_BASIC_FEATURES */
+       .probe          = kszphy_probe,
         .config_init    = ksz8061_config_init,
         .config_intr    = kszphy_config_intr,
         .handle_interrupt = kszphy_handle_interrupt,


> 
> # udhcpc -i eth0
> udhcpc: started, v1.35.0
> 8<--- cut here ---
> Unable to handle kernel NULL pointer dereference at virtual address 00000008
> pgd = f73cef4e
> [00000008] *pgd=00000000
> Internal error: Oops: 5 [#1] SMP ARM
> Modules linked in:
> CPU: 0 PID: 196 Comm: ifconfig Not tainted 5.15.37-dirty #94
> Hardware name: Freescale i.MX6 SoloX (Device Tree)
> PC is at kszphy_config_reset+0x10/0x114
> LR is at kszphy_resume+0x24/0x64
> pc : [<c08ed06c>]    lr : [<c08eddc8>]    psr: 60000013
> sp : c241dc30  ip : 00000000  fp : 00000000
> r10: c2728000  r9 : c2134320  r8 : 00000007
> r7 : 00000000  r6 : 00000000  r5 : c263c800  r4 : c263c800
> r3 : 00000000  r2 : 00000000  r1 : 00000000  r0 : c263c800
> Flags: nZCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment none
> Control: 10c5387d  Table: 82a4c04a  DAC: 00000051
> Register r0 information: slab kmalloc-2k start c263c800 pointer offset
> 0 size 2048
> Register r1 information: NULL pointer
> Register r2 information: NULL pointer
> Register r3 information: NULL pointer
> Register r4 information: slab kmalloc-2k start c263c800 pointer offset
> 0 size 2048
> Register r5 information: slab kmalloc-2k start c263c800 pointer offset
> 0 size 2048
> Register r6 information: NULL pointer
> Register r7 information: NULL pointer
> Register r8 information: non-paged memory
> Register r9 information: slab kmalloc-4k start c2134000 pointer offset
> 800 size 4096
> Register r10 information: slab kmalloc-4k start c2728000 pointer
> offset 0 size 4096
> Register r11 information: NULL pointer
> Register r12 information: NULL pointer
> Process ifconfig (pid: 196, stack limit = 0x4d59d998)
> Stack: (0xc241dc30 to 0xc241e000)
> dc20:                                     00000000 c263c800 c263c800 c263c800
> dc40: c263c800 c2134000 00000000 c08eddc8 c08edda4 c263c800 c2134000 c08e7008
> dc60: c263c800 c263ccb0 c2134000 c08e7080 c263c800 00000000 c2134000 c08e78a8
> dc80: c263c800 c2134000 c08faafc c08faafc 00000003 c2720818 c2134784 c08e7be4
> dca0: c263c800 c2134000 00000000 c08eed74 c2134000 c2720000 f0b73fe0 00000200
> dcc0: 00000003 c08f5688 00000007 c060b5d4 c241c000 c2736e00 c16097c8 c018ff64
> dce0: c2357cb0 00000000 c0800064 60000013 c2736e00 00000001 00000001 c1609388
> dd00: c0800064 c2357cb0 ef7f0e3c c07fb604 00000200 00000003 c2357cb0 ef7f0e3c
> dd20: c07fb604 c0ea9480 c241dd3c c060b5d4 c263c800 c07ffbd0 00001000 c2357cb0
> dd40: 00000000 c1609388 c2134000 c2720000 f0b73fe0 c1609388 c2134000 c2720000
> dd60: f0b73fe0 c08f830c fffffff1 00000001 c241dda4 c2134000 00000000 c0fc7d78
> dd80: c2134024 00001002 00000000 c26c6c00 c17f5811 c0b69110 00000001 c0b693f8
> dda0: ffffe000 c2134000 00000000 c1609388 00000000 c2134000 00000001 00001043
> ddc0: 00000000 c0b694dc 00000000 c241de60 00000000 c0e9cc84 00000000 c1609388
> dde0: c2134000 c241de60 00000000 00001002 00008914 c0b69560 00000000 c241de60
> de00: c26c6c0c 00000000 00008914 c0c28e18 00000000 c0e9cc84 00000000 c2134000
> de20: ffffe000 00001043 00007f00 fffffffd b6f5717c c1609388 00000020 00008914
> de40: bed76c90 bed76c90 bed76c90 c23b9500 00000003 c48ea400 00000000 c0c2b490
> de60: 30687465 00000000 00000000 00000000 00001043 00007f00 fffffffd b6f5717c
> de80: 00000000 00008913 c1e75880 00000000 00000001 bed76c90 c241dee4 00000051
> dea0: c23b9500 bed76c90 00000020 00000000 00000000 c1609388 00008913 00008914
> dec0: c48ea380 bed76c90 bed76c90 c0b397b4 c241dedf c16e0dd4 c02f6ec8 01000113
> dee0: 00000001 30687465 00000000 00000000 00000000 00001002 00007f00 fffffffd
> df00: b6f5717c c1609388 00000000 00008914 c0100080 c23b9500 bed76c90 c02e81e8
> df20: c27d4840 c241dfb0 00000017 005b403e c27d4840 c241dfb0 00000017 005b403e
> df40: c27d4840 c0ea9f4c 00000000 c02f6ed4 00000000 00000000 c02f6e24 00000100
> df60: c1028600 00000017 c160fa88 c0ea9d88 c241dfb0 005b403e 00000003 c1609388
> df80: c01001dc 005a6daa bed76c90 00008914 00000036 c01002a4 c241c000 00000036
> dfa0: 00000000 c0100080 005a6daa bed76c90 00000003 00008914 bed76c90 00000000
> dfc0: 005a6daa bed76c90 00008914 00000036 bed76e48 00000003 005c6a04 00000000
> dfe0: 005c6a34 bed76c08 004fdc64 b6ef1cfc 60000010 00000003 00000000 00000000
> [<c08ed06c>] (kszphy_config_reset) from [<c08eddc8>] (kszphy_resume+0x24/0x64)
> [<c08eddc8>] (kszphy_resume) from [<c08e7008>] (__phy_resume+0x38/0x90)
> [<c08e7008>] (__phy_resume) from [<c08e7080>] (phy_resume+0x20/0x34)
> [<c08e7080>] (phy_resume) from [<c08e78a8>] (phy_attach_direct+0x16c/0x2dc)
> [<c08e78a8>] (phy_attach_direct) from [<c08e7be4>]
> (phy_connect_direct+0x1c/0x58)
> [<c08e7be4>] (phy_connect_direct) from [<c08eed74>] (of_phy_connect+0x48/0x70)
> [<c08eed74>] (of_phy_connect) from [<c08f5688>] (fec_enet_mii_probe+0x3c/0x1bc)
> [<c08f5688>] (fec_enet_mii_probe) from [<c08f830c>] (fec_enet_open+0x280/0x36c)
> [<c08f830c>] (fec_enet_open) from [<c0b69110>] (__dev_open+0xf4/0x178)
> [<c0b69110>] (__dev_open) from [<c0b694dc>] (__dev_change_flags+0x164/0x1d4)
> [<c0b694dc>] (__dev_change_flags) from [<c0b69560>] (dev_change_flags+0x14/0x44)
> [<c0b69560>] (dev_change_flags) from [<c0c28e18>] (devinet_ioctl+0x6c4/0x870)
> [<c0c28e18>] (devinet_ioctl) from [<c0c2b490>] (inet_ioctl+0x1c4/0x2c0)
> [<c0c2b490>] (inet_ioctl) from [<c0b397b4>] (sock_ioctl+0x468/0x50c)
> [<c0b397b4>] (sock_ioctl) from [<c02e81e8>] (sys_ioctl+0xfc/0xebc)
> [<c02e81e8>] (sys_ioctl) from [<c0100080>] (ret_fast_syscall+0x0/0x1c)
> Exception stack(0xc241dfa8 to 0xc241dff0)
> dfa0:                   005a6daa bed76c90 00000003 00008914 bed76c90 00000000
> dfc0: 005a6daa bed76c90 00008914 00000036 bed76e48 00000003 005c6a04 00000000
> dfe0: 005c6a34 bed76c08 004fdc64 b6ef1cfc
> Code: e92d40f0 e1a04000 e5906448 e24dd00c (e5d63008)
> ---[ end trace 6d08cdbf6720c281 ]---
> Segmentation fault
> 
> I haven't started debugging this issue but just wanted to report it in
> case someone has any ideas first.
> 
> Thanks,
> 
> Fabio Estevam


-- 
Florian
