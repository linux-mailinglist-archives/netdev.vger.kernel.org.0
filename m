Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C04EF4F4355
	for <lists+netdev@lfdr.de>; Tue,  5 Apr 2022 23:58:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1385079AbiDEUFP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Apr 2022 16:05:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1572953AbiDERZv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Apr 2022 13:25:51 -0400
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB0D516593
        for <netdev@vger.kernel.org>; Tue,  5 Apr 2022 10:23:52 -0700 (PDT)
Received: by mail-wm1-x335.google.com with SMTP id m67-20020a1ca346000000b0038e6a1b218aso66420wme.2
        for <netdev@vger.kernel.org>; Tue, 05 Apr 2022 10:23:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=conchuod-ie.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=khw56BcVfUfsYn9wIG9PZAUGugIcHpBdbCz+0QyhwfY=;
        b=SPQ4pnAB0M9i7EFSJbLACLDrZy5/KtFV0EoGdqKSiqKwZWlKRm1Bqc0d1MsDqDSkmK
         uOs7Ti3L9bUEHEUKNIzWShnr5jaFcDW1zyDR73cyK9FEHHDsmxAohvfIA0scW96G80w7
         63utohEYTSrU9ZrkkVs8yCRWJiOf3ACjZz6GKw3DJZIku7EeG2ROSX+lBfL674jZ36vQ
         +gr2aUYiPsp8pNOdRcV8+FBC299GuhOAtAc9wux+X9diHfsMhFwLgWuQQHQp+h9mrod1
         VjgVGtMbCdY1mCLOtLhm47YuCzNVhgO4FuTvjHpkboACH5f15c3iHPwK9s/02D0/e4LD
         BhkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=khw56BcVfUfsYn9wIG9PZAUGugIcHpBdbCz+0QyhwfY=;
        b=Pn15Rqo4jNjNwxxb1o/2Jh0K3D0yvp2Ipsd3q9Qw+VQOT2CKaafM4cm1FKFplPgH6Q
         DngIpccGZ0CjFZ2uuLZl7BSlyQiR7ahME7ecU8f9ytDYcM+/EKCfKMF/GPY8inLCH3Y2
         tL7oFyxql2fWLMfVa3pInc1kPR2FvEZaiqkLxmXdO2/HOL/CQquuAyiEJz31tBjmtaYT
         ixLgXNSNh/u5HYJ93i7zBpyzEybdzR1tUjKPwaDdLxq4ot/C73Wd1lPbr6jysLALAEEM
         6mQC7//Yb3MoiNmDtJiQ7QNM1M/YccRfvGzgVTIZF7/s9wwWhxdYV+o0fDXglyiRw03G
         OKRQ==
X-Gm-Message-State: AOAM532gYgUEdd7k326pahvSar3+cLz+5ShY/G+sBfySHnRgyF3XVTht
        9VUeo0khT7SrV/UreQFEiVSt4Q==
X-Google-Smtp-Source: ABdhPJyrY01oduAm4v4Hx0vaQGsRms0tKfOeXo366Rj2gd70qEB7nUGBCKvgXzpWamV2lA/U/1wh5Q==
X-Received: by 2002:a05:600c:4e11:b0:38c:bd19:e72c with SMTP id b17-20020a05600c4e1100b0038cbd19e72cmr4068671wmq.174.1649179431399;
        Tue, 05 Apr 2022 10:23:51 -0700 (PDT)
Received: from [192.168.2.116] ([51.37.209.28])
        by smtp.gmail.com with ESMTPSA id i1-20020a05600c400100b0038cf3371208sm2710883wmm.22.2022.04.05.10.23.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Apr 2022 10:23:50 -0700 (PDT)
Message-ID: <25acda81-4c5c-f8ba-0220-5ffe90bb197e@conchuod.ie>
Date:   Tue, 5 Apr 2022 18:23:49 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: riscv defconfig CONFIG_PM/macb/generic PHY regression in
 v5.18-rc1
Content-Language: en-US
To:     Palmer Dabbelt <palmer@rivosinc.com>, linux@armlinux.org.uk
Cc:     Conor.Dooley@microchip.com, apatel@ventanamicro.com,
        netdev@vger.kernel.org, Nicolas.Ferre@microchip.com,
        Claudiu.Beznea@microchip.com, andrew@lunn.ch, hkallweit1@gmail.com,
        linux-riscv@lists.infradead.org
References: <mhng-524fe1b1-ca51-43a6-ac0f-7ea325da8b6a@palmer-ri-x1c9>
From:   Conor Dooley <mail@conchuod.ie>
In-Reply-To: <mhng-524fe1b1-ca51-43a6-ac0f-7ea325da8b6a@palmer-ri-x1c9>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 05/04/2022 17:56, Palmer Dabbelt wrote:
> On Tue, 05 Apr 2022 08:53:06 PDT (-0700), linux@armlinux.org.uk wrote:
>> On Tue, Apr 05, 2022 at 01:05:12PM +0000, Conor.Dooley@microchip.com 
>> wrote:
>>> Hey,
>>> I seem to have come across a regression in the default riscv defconfig
>>> between riscv-for-linus-5.18-mw0 (bbde015227e8) & v5.18-rc1, exposed by
>>> c5179ef1ca0c ("RISC-V: Enable RISC-V SBI CPU Idle driver for QEMU virt
>>> machine") which causes the ethernet phy to not come up on my Icicle kit:
>>> [ 3.179864] macb 20112000.ethernet eth0: validation of sgmii with 
>>> support 0000000,00000000,00006280 and advertisement 
>>> 0000000,00000000,00004280 failed: -EINVAL
>>> [ 3.194490] macb 20112000.ethernet eth0: Could not attach PHY (-22)
>>
>> I don't think that would be related to the idle driver. This looks like
>> the PHY hasn't filled in the supported mask at probe time - do you have
>> the driver for the PHY built-in or the PHY driver module loaded?
> 
> IIRC we had a bunch of issues with the PHY on the HiFive Unleashed, 
> there was a quirky reset sequence that it wouldn't even probe correctly 
> without.  We have a
>     &eth0 {
>             status = "okay";
>             phy-mode = "gmii";
>             phy-handle = <&phy0>;
>             phy0: ethernet-phy@0 {
>                     compatible = "ethernet-phy-id0007.0771";
>                     reg = <0>;
>             };
>     };
> 
> in the Unleashed DT, but I can't find anything similar in the Icicle DT
> 
>     &mac1 {
>             status = "okay";
>             phy-mode = "sgmii";
>             phy-handle = <&phy1>;
>             phy1: ethernet-phy@9 {
>                     reg = <9>;
>                     ti,fifo-depth = <0x1>;
>             };
>             phy0: ethernet-phy@8 {
>                     reg = <8>;
>                     ti,fifo-depth = <0x1>;
>             };
>     };
> 
> I seem to remember picking that specific phy because it was similar to 
> the one that was POR for the Icicle at the time we decided, maybe you 
> have a similar phy with a similar quirk and need a similar workaround?

I tried using the one for the VSC8662 (0007.0660) since that's whats on,
the board but that didn't help.
Without the revert:

[    1.521768] macb 20112000.ethernet eth0: Cadence GEM rev 0x0107010c 
at 0x20112000 irq 17 (00:04:a3:4d:4c:dc)
[    3.206274] macb 20112000.ethernet eth0: PHY 
[20112000.ethernet-ffffffff:09] driver [Vitesse VSC8662] (irq=POLL)
[    3.216641] macb 20112000.ethernet eth0: configuring for phy/sgmii 
link mode
(and then nothing)

If I revert the CONFIG_PM addition:

[    1.508882] macb 20112000.ethernet eth0: Cadence GEM rev 0x0107010c 
at 0x20112000 irq 17 (00:04:a3:4d:4c:dc)
[    2.879617] macb 20112000.ethernet eth0: PHY 
[20112000.ethernet-ffffffff:09] driver [Vitesse VSC8662] (irq=POLL)
[    2.890010] macb 20112000.ethernet eth0: configuring for phy/sgmii 
link mode
[    6.981823] macb 20112000.ethernet eth0: Link is Up - 1Gbps/Full - 
flow control off
[    6.989657] IPv6: ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready

I will try again tomorrow with "ethernet-phy-id0007.0771" to see if
anything changes, since that would use the Microsemi driver rather
than the Vitesse driver that VSC8662/0007.0660 uses.

Thanks,
Conor.

