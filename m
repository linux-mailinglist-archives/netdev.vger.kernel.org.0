Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C4654F3E20
	for <lists+netdev@lfdr.de>; Tue,  5 Apr 2022 22:41:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344934AbiDEUBG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Apr 2022 16:01:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1457942AbiDERAw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Apr 2022 13:00:52 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D30851FA4F
        for <netdev@vger.kernel.org>; Tue,  5 Apr 2022 09:58:52 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id q19so13353956wrc.6
        for <netdev@vger.kernel.org>; Tue, 05 Apr 2022 09:58:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=conchuod-ie.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=8aHjdrzxvuuwSECjwvJEnyfmwIs0wnZS2SDA3RmFL94=;
        b=72YUET14s8SEElAjSW0t3i7Yg1P7m27US94euc+B33qxKztjfcGXWvx5NmgLNsPFPt
         NUtwyeaPm0bEEKvJfJJ3dXbf8AwIYARvwG++ClpEOZ2H4hdjKtMD4NuuQ2h5jsJjUrGN
         VpJrvhQOF8FP9ygCyEBB9ZE856r3d6Nat+AmmD0WS8tvqUAnFRfNq8laLiCRToRcbQsY
         tD9CyQ1lmY4Z0vyt8FGthgoX3rhMa/nzzmjplRK0zP23F9UmfcRidP9oKmHsER2Pwr6V
         BgtsZUo6I2/RV02DWXU6bnUqtu62K/wn829LFg5RVq6dFNAeoc/LfhIJoowRY2cPev6p
         J/Lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=8aHjdrzxvuuwSECjwvJEnyfmwIs0wnZS2SDA3RmFL94=;
        b=u9O6Hm3+O80fcq5MA+JZMPSUbvMH5LQ8WW+gKxplcrx9OvuiSnkWInIcHeF6YxGOhb
         kzDTiBB+uWIq/ZK9u+M8HUpt2aVEJvtIJ4wjsz4RlkSi3AwlI6DoMFX7HueBcvWXLs3q
         Okdt0f6ERiBQBb/vtX7Z4Rg1SEa0pQVz2lsALrEEOcID7QX/DDi4IdjFNrQA7ZpDifIJ
         jEbpyRwOu7a+tqG+YDdRp/9kW5UKwrirD4x8ezpIy+A28Ay/d0N86/yfKWHn8pQbWkPg
         H5NIO0FuIXDF5T5fKwfetDmDiHVCjYIvl+BfwyXszU4DuSf5nPzowrWtr6ZkSr5ODun7
         tNJQ==
X-Gm-Message-State: AOAM533UyIc/iZdTo3p5/830JmV6u+pIhLS0aamdKeXiUtgnqPnbNwAF
        1VsY/yQk0z9DdXFphl4pV6t/Qg==
X-Google-Smtp-Source: ABdhPJzjFdsPWmaS5MX3p/c9EvEWmyhF7l9YbAzv9tGV0wm6kHYJ1M5CL8YrSb98zEk1M6MVwxm2IQ==
X-Received: by 2002:a5d:6505:0:b0:205:9a98:e184 with SMTP id x5-20020a5d6505000000b002059a98e184mr3238708wru.317.1649177931194;
        Tue, 05 Apr 2022 09:58:51 -0700 (PDT)
Received: from [192.168.2.116] ([51.37.209.28])
        by smtp.gmail.com with ESMTPSA id s1-20020adfb781000000b002060d4a8bd9sm7578666wre.17.2022.04.05.09.58.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Apr 2022 09:58:50 -0700 (PDT)
Message-ID: <0415ff44-34fd-2f00-833d-fbcea3a967cb@conchuod.ie>
Date:   Tue, 5 Apr 2022 17:58:50 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: riscv defconfig CONFIG_PM/macb/generic PHY regression in
 v5.18-rc1
Content-Language: en-US
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>,
        Conor.Dooley@microchip.com
Cc:     palmer@rivosinc.com, apatel@ventanamicro.com,
        netdev@vger.kernel.org, Nicolas.Ferre@microchip.com,
        Claudiu.Beznea@microchip.com, andrew@lunn.ch, hkallweit1@gmail.com,
        linux-riscv@lists.infradead.org
References: <9f4b057d-1985-5fd3-65c0-f944161c7792@microchip.com>
 <Ykxl4m1uPPDktZnD@shell.armlinux.org.uk>
From:   Conor Dooley <mail@conchuod.ie>
In-Reply-To: <Ykxl4m1uPPDktZnD@shell.armlinux.org.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 05/04/2022 16:53, Russell King (Oracle) wrote:
> On Tue, Apr 05, 2022 at 01:05:12PM +0000, Conor.Dooley@microchip.com wrote:
>> Hey,
>> I seem to have come across a regression in the default riscv defconfig
>> between riscv-for-linus-5.18-mw0 (bbde015227e8) & v5.18-rc1, exposed by
>> c5179ef1ca0c ("RISC-V: Enable RISC-V SBI CPU Idle driver for QEMU virt
>> machine") which causes the ethernet phy to not come up on my Icicle kit:
>> [ 3.179864] macb 20112000.ethernet eth0: validation of sgmii with support 0000000,00000000,00006280 and advertisement 0000000,00000000,00004280 failed: -EINVAL
>> [ 3.194490] macb 20112000.ethernet eth0: Could not attach PHY (-22)
> 
> I don't think that would be related to the idle driver. This looks like
> the PHY hasn't filled in the supported mask at probe time - do you have
> the driver for the PHY built-in or the PHY driver module loaded?

Hey Russel,
The idle stuff enabled CONFIG_PM=y though in the default riscv
defconfig, so it is not confined to just QEMU.

I am not sure what the symbol for the generic phy & I am not at work
to properly check, so I hope this is the relevant part of the config:

CONFIG_PHYLINK=y
CONFIG_PHYLIB=y
CONFIG_SWPHY=y
CONFIG_FIXED_PHY=y

If it isn't, you should be able to generate the config I used to cause
the error with:
make ARCH=RISCV defconfig

If you look at my response to Andrew [1] you'll see that my problems
are not isolated to just the Generic PHY driver as a builtin Vitesse
driver has issues too (although validation appears to have passed).

Thanks,
Conor.

[1] 
https://lore.kernel.org/linux-riscv/60fd1eb7-a2ce-9084-c567-721e975e7e86@microchip.com/
