Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E8E694F43D8
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 00:09:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346028AbiDEUB2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Apr 2022 16:01:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1457901AbiDEQ6O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Apr 2022 12:58:14 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DD362613B
        for <netdev@vger.kernel.org>; Tue,  5 Apr 2022 09:56:15 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id ku13-20020a17090b218d00b001ca8fcd3adeso3161865pjb.2
        for <netdev@vger.kernel.org>; Tue, 05 Apr 2022 09:56:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20210112.gappssmtp.com; s=20210112;
        h=date:subject:in-reply-to:cc:from:to:message-id:mime-version
         :content-transfer-encoding;
        bh=pD9fPwmVTM/jGE8ljozcqxyf1v/JIowTzA8YgXdXgLo=;
        b=6Yhc3GQ5D13EfpCiyxWdY9ATp+e66X5WPXMk58IseiYggOh8EF4zh770E/Bk7DRo51
         p4h4+pm4+wXMgBLs7qhYW6r1vVN2Wm7Iva6ruTUNUbuSqXPQ14wKHV8caf3YtyNS2Lzu
         Kveambm80gsiXG3DrJFesbT6dQs5tecj4kseuZoRyGhEDF0QpghcROkKwiOozw0IonrY
         cFQp7Fy2dYV4yttfGd+tA5dCEWgo4daS5HamfxZ1aTcDAeoqoOlCSQkeSBOmIT+3oI3o
         n27q25I2PMjmmtWPK+zyETaS0EMrgPC0vQ+07cBMFsDLQXUr/NREnSNOapE4gsNk4ftz
         tSMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:subject:in-reply-to:cc:from:to:message-id
         :mime-version:content-transfer-encoding;
        bh=pD9fPwmVTM/jGE8ljozcqxyf1v/JIowTzA8YgXdXgLo=;
        b=umpYtpC65wvGLKCIjyT+EE1gqvBgQBBg9W+JyEDaoqimTyZ/4ZadgS1f8JqpU7WZ97
         E9DaaHoctttnbu8EfFcfCei/i+c+YHrckvn1RGDLG7/mlLJY0Pr+3OSawWBeqFSMZhph
         cHbYABL4pP6IdRzyCta346Quxvk9OX96OyrsdORBNmL5f8kC08ILHqJmY106vWx+F/Tk
         sk4eGha4IHGy9q9w+nCfRdkvdBtmglD9jFvb/RYOaFcU1dOeYbSHhyyt9Lsl3WDlTe7k
         chaS0uPSf8/scJGK+q76qVWEneUsBMOE7mgg3YCQY2NmwGXzdDj0sCC3OlnGsXhpwc6t
         YNNA==
X-Gm-Message-State: AOAM530CEwT+6NGEBqMYPlFOI+0tp68vsB+CSn4LLnWECEtQAJG3At2I
        ijhurixY+yoFgg6N2nwrQESzSQ==
X-Google-Smtp-Source: ABdhPJxURqOrvjUNTuGDdXp9QzgwB0B9A/Tn2x7b4aAfTIkHHSa8BmZtjlyBr0mLrouMcWOZ+7cwhQ==
X-Received: by 2002:a17:90a:7841:b0:1c7:e8ad:ea25 with SMTP id y1-20020a17090a784100b001c7e8adea25mr5206129pjl.25.1649177774636;
        Tue, 05 Apr 2022 09:56:14 -0700 (PDT)
Received: from localhost ([12.3.194.138])
        by smtp.gmail.com with ESMTPSA id p18-20020a17090ad31200b001cab747e864sm2785950pju.43.2022.04.05.09.56.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Apr 2022 09:56:13 -0700 (PDT)
Date:   Tue, 05 Apr 2022 09:56:13 -0700 (PDT)
X-Google-Original-Date: Tue, 05 Apr 2022 09:56:11 PDT (-0700)
Subject:     Re: riscv defconfig CONFIG_PM/macb/generic PHY regression in v5.18-rc1
In-Reply-To: <Ykxl4m1uPPDktZnD@shell.armlinux.org.uk>
CC:     Conor.Dooley@microchip.com, apatel@ventanamicro.com,
        netdev@vger.kernel.org, Nicolas.Ferre@microchip.com,
        Claudiu.Beznea@microchip.com, andrew@lunn.ch, hkallweit1@gmail.com,
        linux-riscv@lists.infradead.org
From:   Palmer Dabbelt <palmer@rivosinc.com>
To:     linux@armlinux.org.uk
Message-ID: <mhng-524fe1b1-ca51-43a6-ac0f-7ea325da8b6a@palmer-ri-x1c9>
Mime-Version: 1.0 (MHng)
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 05 Apr 2022 08:53:06 PDT (-0700), linux@armlinux.org.uk wrote:
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

IIRC we had a bunch of issues with the PHY on the HiFive Unleashed, 
there was a quirky reset sequence that it wouldn't even probe 
correctly without.  We have a 

    &eth0 {
            status = "okay";
            phy-mode = "gmii";
            phy-handle = <&phy0>;
            phy0: ethernet-phy@0 {
                    compatible = "ethernet-phy-id0007.0771";
                    reg = <0>;
            };
    };

in the Unleashed DT, but I can't find anything similar in the Icicle DT

    &mac1 {
            status = "okay";
            phy-mode = "sgmii";
            phy-handle = <&phy1>;
            phy1: ethernet-phy@9 {
                    reg = <9>;
                    ti,fifo-depth = <0x1>;
            };
            phy0: ethernet-phy@8 {
                    reg = <8>;
                    ti,fifo-depth = <0x1>;
            };
    };

I seem to remember picking that specific phy because it was similar to 
the one that was POR for the Icicle at the time we decided, maybe you 
have a similar phy with a similar quirk and need a similar workaround?
