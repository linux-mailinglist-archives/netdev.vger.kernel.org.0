Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E7664F4257
	for <lists+netdev@lfdr.de>; Tue,  5 Apr 2022 23:43:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357854AbiDEUD7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Apr 2022 16:03:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1457657AbiDEQ1B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Apr 2022 12:27:01 -0400
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83F2389CCB
        for <netdev@vger.kernel.org>; Tue,  5 Apr 2022 09:25:02 -0700 (PDT)
Received: by mail-wm1-x32e.google.com with SMTP id l62-20020a1c2541000000b0038e4570af2fso2002562wml.5
        for <netdev@vger.kernel.org>; Tue, 05 Apr 2022 09:25:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=conchuod-ie.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=ybM1oCgaQ6WD2vVarbV8uyDpv+y4wNMKY2GnbiDx1ys=;
        b=iUzJ18LSJr94o1SYCzAKEY/3mvZG9wDX3oYuKooiNWzh7cwaEYK5WhNkRy4JQmy+/j
         e5SmAe22772WpKlSJ4JGRexJgxyYmcoQr3YlJuZzHt197iE2fstRtltwN28TLuGNTCi0
         asSSxjT07yk1Lj9FKXCb9jAPZS5kd1nEYEz5IlegDMEU4W2JphwvHUGdvo0JLsWEHHMv
         s7GQwkpq74OmCLEHthsDyjUuvM0Zfd5VJa5lvLCOHuQ3d09DLHx1yLvYiFF9hEC5oTfr
         fFQ7lslM0DOse7WLRS4/PW3BpxEsBYEAcP2C1xXFz08b2m1fb7z6hA25qM3Xw3PQwpw5
         2nww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=ybM1oCgaQ6WD2vVarbV8uyDpv+y4wNMKY2GnbiDx1ys=;
        b=j78owWi2Fa60M9YqlAsKLV4yvKbOrGu07/A7MOZjEcMvsgnlnv0nrk+Qy8IBQHfPKB
         1WOtFucWxlPWnbm/Iq1cvXOOl0NE8ssC1n2SRCel73ympufgUPTVP/dwMjnw989Jnxra
         SmttUr1i4hStPdAtFguYwKtzqgCVIdURSD+8+cVUdmhOUTxRK0XhbUpvrwKtATHWidB5
         C//59+zoiG4mSVCqPpFABgQslLS14+WRMhzvjDBbVosUSgSIuB9HM703hXTtYxqpf0fT
         TlxBnY6/cHI+iR8PKmyd6RxFbBS+fHgR/GRq2fXebbXDOJ/wxipnSOVOjinj/3hjj4qM
         IdgA==
X-Gm-Message-State: AOAM532YQeyErMrAWmxbMuwUqlM7fiPObK9a4jMOoIVQ8A+L8JOVSs6x
        Z6u+/+6IpEg3vbjOjYdWF9FOFQ==
X-Google-Smtp-Source: ABdhPJx2ILdCbJslprkvQZegnhsn312OtIarZbS5ZGmQlPb0fPsLfa0HO8G5JR0Jb61WhaLBmXPiog==
X-Received: by 2002:a05:600c:4611:b0:389:9f47:30cd with SMTP id m17-20020a05600c461100b003899f4730cdmr3606782wmo.185.1649175901021;
        Tue, 05 Apr 2022 09:25:01 -0700 (PDT)
Received: from [192.168.2.116] ([51.37.209.28])
        by smtp.gmail.com with ESMTPSA id c7-20020a5d4f07000000b00203db8f13c6sm12672854wru.75.2022.04.05.09.24.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Apr 2022 09:25:00 -0700 (PDT)
Message-ID: <e445af29-4354-69c3-fa9a-c5b99d90a9a5@conchuod.ie>
Date:   Tue, 5 Apr 2022 17:25:00 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: riscv defconfig CONFIG_PM/macb/generic PHY regression in
 v5.18-rc1
Content-Language: en-US
To:     Andrew Lunn <andrew@lunn.ch>, Conor.Dooley@microchip.com
Cc:     palmer@rivosinc.com, apatel@ventanamicro.com,
        netdev@vger.kernel.org, Nicolas.Ferre@microchip.com,
        Claudiu.Beznea@microchip.com, linux@armlinux.org.uk,
        hkallweit1@gmail.com, linux-riscv@lists.infradead.org
References: <9f4b057d-1985-5fd3-65c0-f944161c7792@microchip.com>
 <YkxaiEbHwduhS2+p@lunn.ch>
From:   Conor Dooley <mail@conchuod.ie>
In-Reply-To: <YkxaiEbHwduhS2+p@lunn.ch>
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

On 05/04/2022 16:04, Andrew Lunn wrote:
>> [ 2.818894] macb 20112000.ethernet eth0: PHY [20112000.ethernet-ffffffff:09] driver [Generic PHY] (irq=POLL)
>> [ 2.828915] macb 20112000.ethernet eth0: configuring for phy/sgmii link mode
>> [11.045411] macb 20112000.ethernet eth0: Link is Up - 1Gbps/Full - flow control off
>> [11.053247] IPv6: ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
> 
> You have a multi-part link. You need that the PHY reports the line
> side is up. Put some printk in genphy_update_link() and look at
> phydev->link. You also need that the SGMII link between the PHY and
> the SoC is up. That is a bit harder to see, but try adding #define
> DEBUG at the top of phylink.c and phy.c so you get additional debug
> prints for the state machines.

Sure, will give it a go tomorrow.

> 
>         Andrew
> 
> _______________________________________________
> linux-riscv mailing list
> linux-riscv@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-riscv
