Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 04C304F405A
	for <lists+netdev@lfdr.de>; Tue,  5 Apr 2022 23:16:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345523AbiDEUBN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Apr 2022 16:01:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1573263AbiDEShY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Apr 2022 14:37:24 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02EB7167E3
        for <netdev@vger.kernel.org>; Tue,  5 Apr 2022 11:35:25 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id m30so20702977wrb.1
        for <netdev@vger.kernel.org>; Tue, 05 Apr 2022 11:35:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=conchuod-ie.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=fMfK7hmCnbrxv84hU70wjXKP41CBHA8Tij4U12U5HGc=;
        b=6aTeEx0imUwl6lvQlIFGBzuBgW6bSzbe1GtQiiGT62QGUqRtuqc9wY7zWWfyxerxTW
         f6cy2XGL9VRfIzApuLSuYsp8COb64RmnLH5H7lhpXGwgn+V5XDAvaw0ZoAoihcj71ryt
         hFny7cIE3afYaj2eMsOV/20RpdSoaOBmiM1pNd6Uviqm5bySN04f4FnidN1lZ36K9uh+
         FkOf4FwBqvNgqvj2+NludQticqsIFlGdVY7/6llIsnJGuiv6eZr/p2fTnPTSolLqcjRz
         XVSr2dmzIrPhKzMnAfvDA7CWNZEWK5GHODlB4qc2QAvWrdNXjmNwfQLwN2NrrLRsoMkr
         C7eA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=fMfK7hmCnbrxv84hU70wjXKP41CBHA8Tij4U12U5HGc=;
        b=J9EuF3JE/x8NttVQ9KWEkAt6DNORpK222aNCJJW83HeP5ZbWzJRNn50ZMkSowyqKpf
         wywD+yNFU0/JGfvJeFcWRu6E7gyzd4MyCRkO/sKVty9HAFfygqBOHclMF5dMRjqM8VMu
         D+B7xNBxsI2D2SU278SsodrH5/iJh6bgEtrd7nXQGpjRZux6jHWJVW1J0EI+IGdVL3WJ
         EL1cULNq5E1Sp0ifOSNbwtH+8So4fmsYNVXqvU7/Pq+n0aHMw1byFBR8A9/8ed5Ad0Vi
         IFwqJwXks2olIx4qSg+khwBSUXxSMbHc+U9wAjNirTu/nITMjAnH7zGLtwi9O5FIi1j1
         htPQ==
X-Gm-Message-State: AOAM532/x9WxLOj66UCWQGS2y0Pl7nNrmtF3UBySYVlgfGVj5aRpa0Fg
        B0HowgNgEUkql4Lv8FtRZsGr6g==
X-Google-Smtp-Source: ABdhPJzYjwxU8FIT7JcOynGd8Y6dSpW4pLRiNTuRwI2G7mW+uofCg/127Pj59Imt33TasJ39dZfArA==
X-Received: by 2002:adf:ef8e:0:b0:206:1b61:7c20 with SMTP id d14-20020adfef8e000000b002061b617c20mr3595492wro.543.1649183723105;
        Tue, 05 Apr 2022 11:35:23 -0700 (PDT)
Received: from [192.168.2.116] ([51.37.209.28])
        by smtp.gmail.com with ESMTPSA id m3-20020a5d6243000000b001e33760776fsm12563088wrv.10.2022.04.05.11.35.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Apr 2022 11:35:22 -0700 (PDT)
Message-ID: <a0b05792-678f-2ecb-ac18-01a88fb0873b@conchuod.ie>
Date:   Tue, 5 Apr 2022 19:35:21 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: riscv defconfig CONFIG_PM/macb/generic PHY regression in
 v5.18-rc1
Content-Language: en-US
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Palmer Dabbelt <palmer@rivosinc.com>, linux@armlinux.org.uk,
        Conor.Dooley@microchip.com, apatel@ventanamicro.com,
        netdev@vger.kernel.org, Nicolas.Ferre@microchip.com,
        Claudiu.Beznea@microchip.com, hkallweit1@gmail.com,
        linux-riscv@lists.infradead.org
References: <mhng-524fe1b1-ca51-43a6-ac0f-7ea325da8b6a@palmer-ri-x1c9>
 <25acda81-4c5c-f8ba-0220-5ffe90bb197e@conchuod.ie> <YkyFOqAqA2IyTCOp@lunn.ch>
From:   Conor Dooley <mail@conchuod.ie>
In-Reply-To: <YkyFOqAqA2IyTCOp@lunn.ch>
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



On 05/04/2022 19:06, Andrew Lunn wrote:
>> I tried using the one for the VSC8662 (0007.0660) since that's whats on,
>> the board but that didn't help.
>> Without the revert:
>>
>> [    1.521768] macb 20112000.ethernet eth0: Cadence GEM rev 0x0107010c at
>> 0x20112000 irq 17 (00:04:a3:4d:4c:dc)
>> [    3.206274] macb 20112000.ethernet eth0: PHY
>> [20112000.ethernet-ffffffff:09] driver [Vitesse VSC8662] (irq=POLL)
>> [    3.216641] macb 20112000.ethernet eth0: configuring for phy/sgmii link
>> mode
>> (and then nothing)
>>
>> If I revert the CONFIG_PM addition:
>>
>> [    1.508882] macb 20112000.ethernet eth0: Cadence GEM rev 0x0107010c at
>> 0x20112000 irq 17 (00:04:a3:4d:4c:dc)
>> [    2.879617] macb 20112000.ethernet eth0: PHY
>> [20112000.ethernet-ffffffff:09] driver [Vitesse VSC8662] (irq=POLL)
>> [    2.890010] macb 20112000.ethernet eth0: configuring for phy/sgmii link
>> mode
>> [    6.981823] macb 20112000.ethernet eth0: Link is Up - 1Gbps/Full - flow
>> control off
>> [    6.989657] IPv6: ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
>>
>> I will try again tomorrow with "ethernet-phy-id0007.0771" to see if
>> anything changes, since that would use the Microsemi driver rather
>> than the Vitesse driver that VSC8662/0007.0660 uses.
> 
> The numbers here should be the same as what you find in registers 2
> and 3 of the PHY. They identify the manufacture, version and revision
> of the PHY. With a normal probe, these two registers are read, and the
> PHY driver found which says it supports the particular ID. The only
> time you need to actually list the IDs in DT is when you cannot find
> the PHY using the normal probe, generally because its regulator/reset
> is turned off, and only the PHY driver knows how to fix that.
> Chicken/Egg.
> 
> You don't have this issue, you always seem to be able to find the PHY,
> so you don't need these properties.

Good to know.

> Also, using the Microsemi driver for a Vitesse hardware is like using
> the intel i210 Ethernet driver for an amd xgbe Ethernet hardware....

Ehh, not sure that this is the best comparison. Microsemi bought Vitesse
in 2015, and the PHYs supported by the Microsemi driver are all VSC*
products. I was going to try it in the off chance that the reset was
handled differently, but point taken!

> 
>      Andrew
