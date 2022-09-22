Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C70175E6716
	for <lists+netdev@lfdr.de>; Thu, 22 Sep 2022 17:29:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232066AbiIVP3n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Sep 2022 11:29:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231578AbiIVP3m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Sep 2022 11:29:42 -0400
Received: from mail-qk1-x72d.google.com (mail-qk1-x72d.google.com [IPv6:2607:f8b0:4864:20::72d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55E6411819;
        Thu, 22 Sep 2022 08:29:38 -0700 (PDT)
Received: by mail-qk1-x72d.google.com with SMTP id g2so6427821qkk.1;
        Thu, 22 Sep 2022 08:29:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=HDugsKcFWwgDvORvlxlMOplZ/DsK34J0Lz1oHMLFJTw=;
        b=U8BZE1FwFlLg5Ql/wZikZ17sTNcRSJtyBZi4wvNg9xttGHjgJpex5cdXpRDZSyY0HH
         fD9eRl7CzLMUpaxU+4irSO1cHi99zXyp2l1AlR+1JC9fZMyJ8/lnoFD0Am7uFHjHhiLz
         TOvTXphrF6JsB4dAzUpv95L+8XmvRFm6eRi89mNE0IY5CuhPZu22VhTLDpQJFyAQAK1M
         IO4BZ6yYAi1KeAz9g3127gCLp0CQ8Ayw5MwiOTroJB7XeZ60VZvxBCzQnz6kfg9LgQd1
         RskZTSKL70ig2UkrgQXtPguTJscj7WRd9lDwiH1EEF4GhqqfSQdCQ8WQyUvDNRt0yOFr
         aGOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=HDugsKcFWwgDvORvlxlMOplZ/DsK34J0Lz1oHMLFJTw=;
        b=7D6yRLlgnJeBvol66/MuomicFZPA83As2RJHTzHgtjJImELzOT72eB/pE3NFYwlkDF
         Nvg/uKRs/zNlgHfYXGIOtXdL9UD60r2ScRyj9LVAIR+0WX8+6phaa7KfpVHrb1Y+aswD
         evbddJsSJyErxI0TAfWKZL3DcfNS4QOSvBiZMajeHIBqu4Pgj8DGKgEDwkOev1fevQtH
         /JaqGRhBp+S/4/gTbCPh4QjCpPNhMQ/6/WNGMovQq1JRskdbQUuEbUI5F8DM22xAf7RB
         eN6gJDAOZ/KU4x8jintH7rvg8YIV4nIGJilrUXo70CISn5DI7FWjh2cDi0P8cOUmbv0t
         EiSQ==
X-Gm-Message-State: ACrzQf3Am0FR8dafCsZH41W/QcodfYZ9JnaHx5De5RvQU7gx6kE37aHi
        tuaYv37opaE2Mm0w/8ZMrVIpZwW5zOk=
X-Google-Smtp-Source: AMsMyM6yjDnD0YQ1SqiZJ2eTbV87bhryvtmL/+AGMSEAkcUzteBpsl+ZZpryGz6HhdoLk/TXy5almw==
X-Received: by 2002:a05:620a:4052:b0:6ce:d5bc:a905 with SMTP id i18-20020a05620a405200b006ced5bca905mr2577971qko.629.1663860577054;
        Thu, 22 Sep 2022 08:29:37 -0700 (PDT)
Received: from [192.168.1.102] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id i12-20020a05620a404c00b006b8d1914504sm4851652qko.22.2022.09.22.08.29.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 22 Sep 2022 08:29:36 -0700 (PDT)
Message-ID: <26ef199c-cf45-57b5-70cc-9ee42879d96e@gmail.com>
Date:   Thu, 22 Sep 2022 08:29:34 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.0
Subject: Re: [PATCH net] net: phy: Warn about incorrect mdio_bus_phy_resume()
 state
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, opendmb@gmail.com,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        open list <linux-kernel@vger.kernel.org>
References: <20220801233403.258871-1-f.fainelli@gmail.com>
 <20220922053113.250dc095@kernel.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220922053113.250dc095@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/22/2022 5:31 AM, Jakub Kicinski wrote:
> On Mon,  1 Aug 2022 16:34:03 -0700 Florian Fainelli wrote:
>> Calling mdio_bus_phy_resume() with neither the PHY state machine set to
>> PHY_HALTED nor phydev->mac_managed_pm set to true is a good indication
>> that we can produce a race condition looking like this:
>>
>> CPU0						CPU1
>> bcmgenet_resume
>>   -> phy_resume
>>     -> phy_init_hw
>>   -> phy_start
>>     -> phy_resume
>>                                                  phy_start_aneg()
>> mdio_bus_phy_resume
>>   -> phy_resume
>>      -> phy_write(..., BMCR_RESET)
>>       -> usleep()                                  -> phy_read()
>>
>> with the phy_resume() function triggering a PHY behavior that might have
>> to be worked around with (see bf8bfc4336f7 ("net: phy: broadcom: Fix
>> brcm_fet_config_init()") for instance) that ultimately leads to an error
>> reading from the PHY.
> 
> Hi Florian! There were some follow ups on this one, were all the known
> reports covered at this point or there are still platforms to tweak?

This is the only active thread that I am aware of, and Lukas and I are 
in agreement as to what to do next:

https://lore.kernel.org/all/20220918191333.GA2107@wunner.de/

expect him to submit a follow on the warning condition to deal with the 
smsc95xx USB driver.

Thanks!
-- 
Florian
