Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B8EC5A7668
	for <lists+netdev@lfdr.de>; Wed, 31 Aug 2022 08:15:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230103AbiHaGPY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Aug 2022 02:15:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230135AbiHaGPT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Aug 2022 02:15:19 -0400
Received: from mail-lj1-x229.google.com (mail-lj1-x229.google.com [IPv6:2a00:1450:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A03AA5FF6
        for <netdev@vger.kernel.org>; Tue, 30 Aug 2022 23:15:18 -0700 (PDT)
Received: by mail-lj1-x229.google.com with SMTP id k18so7151623lji.13
        for <netdev@vger.kernel.org>; Tue, 30 Aug 2022 23:15:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=uaBfumxJcJC33yAQtmwWr4FE5fX9GDm6ngQD1TC2G+A=;
        b=fc/pH/Tq5KQBGPIcl9pqy+SRwX3mcJy9pVT65297drMr4WTlyAp3Fm2tMm2Qtpel43
         xFUo5WSrmpSwhxsSfzTiawQXuF4XXJ+/wEstK2VX5sZ9tib834E9/X0ASXgHFY1e8CuH
         kPvkk61JPpoYEqNhcMkn//c8cxmo4gwr3wNzDMcorWPYG53IQ8FRswBWGIf+N/WYnvLR
         jhmIv2TZYCVQKY38G7V8gY/NC4avy/RAexbvlBT6VKV9Dv7WTnvOXelro1PZSSk+IRQ5
         hC8EatHDo5kC4fFLHkqdfYg34upCx7M+Kbqvqd9wLrAgvrYPzYQgpHnEyDlr3dnkzKhd
         6bsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=uaBfumxJcJC33yAQtmwWr4FE5fX9GDm6ngQD1TC2G+A=;
        b=LlTLC4WzFLZ7WcerunQVGoZKLE2Z0vzS3dYvtvk9NTjnCgxAz8/5cYQ5UzTZoOSyfe
         YXXekVEWkk6dZquiy4fwitOO5dl4bQb+g2dAIrzaFcZbdf6OEwhbkmkhFQF9FyH62VH0
         uyGfzACRUAE2rjqDuxU8mtkMFXa4NdefpbJZDkF4B+uBVKX9ZDbwrIXFQpTFoR0JuEYn
         y06tBoFWOsjggDnt4SSxEAd9AiSTDlrzFJYlTlxJEWngaAmroEqneqguyRXv5WMyEtqT
         4326uAxyEN6c8ZBbjuptq6YM+SBkPi49c4kMx6njpEqPUzEc+lCcNkops5KEZYS2KwKR
         QZGw==
X-Gm-Message-State: ACgBeo2mBF5OQTCMER5j0kxKvw7bHdjdKV56KINzH/LJDGJGwxd7adO7
        5z7mYHHlOk0Gj5DIstzdGjw=
X-Google-Smtp-Source: AA6agR5ek1hMl5ji/G7yBETaWxQyre3Jv3Pa45WYbBkKLV9dwQYKcEElzPorT1DWQF8TkT5KCENZVg==
X-Received: by 2002:a2e:a5c6:0:b0:25e:223f:a417 with SMTP id n6-20020a2ea5c6000000b0025e223fa417mr8756533ljp.236.1661926516698;
        Tue, 30 Aug 2022 23:15:16 -0700 (PDT)
Received: from [10.0.1.14] (h-98-128-229-160.NA.cust.bahnhof.se. [98.128.229.160])
        by smtp.gmail.com with ESMTPSA id n6-20020a05651203e600b00492aefd73a5sm429190lfq.132.2022.08.30.23.15.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 30 Aug 2022 23:15:16 -0700 (PDT)
Message-ID: <68d465fc-8316-ef3c-efc2-3b1fa38c0e4c@gmail.com>
Date:   Wed, 31 Aug 2022 08:15:15 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH net-next v2 2/3] dsa: mv88e6xxx: Add support for RMU in
 select switches
Content-Language: en-US
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
References: <20220826063816.948397-1-mattias.forsblad@gmail.com>
 <20220826063816.948397-3-mattias.forsblad@gmail.com>
 <20220830163515.3d2lzzc55vmko325@skbuf>
 <20220830164226.ohmn6bkwagz6n3pg@skbuf>
From:   Mattias Forsblad <mattias.forsblad@gmail.com>
In-Reply-To: <20220830164226.ohmn6bkwagz6n3pg@skbuf>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022-08-30 18:42, Vladimir Oltean wrote:
> On Tue, Aug 30, 2022 at 07:35:15PM +0300, Vladimir Oltean wrote:
>>> +void mv88e6xxx_rmu_master_change(struct dsa_switch *ds, const struct net_device *master,
>>> +				 bool operational)
>>> +{
>>> +	struct mv88e6xxx_chip *chip = ds->priv;
>>> +
>>> +	if (operational)
>>> +		chip->rmu.ops = &mv88e6xxx_bus_ops;
>>> +	else
>>> +		chip->rmu.ops = NULL;
>>> +}
>>
>> There is a subtle but very important point to be careful about here,
>> which is compatibility with multiple CPU ports. If there is a second DSA
>> master whose state flaps from up to down, this should not affect the
>> fact that you can still use RMU over the first DSA master. But in your
>> case it does, so this is a case of how not to write code that accounts
>> for that.
>>
>> In fact, given this fact, I think your function prototypes for
>> chip->info->ops->rmu_enable() are all wrong / not sufficiently
>> reflective of what the hardware can do. If the hardware has a bit mask
>> of ports on which RMU operations are possible, why hardcode using
>> dsa_switch_upstream_port() and not look at which DSA masters/CPU ports
>> are actually up? At least for the top-most switch. For downstream
>> switches we can use dsa_switch_upstream_port(), I guess (even that can
>> be refined, but I'm not aware of setups using multiple DSA links, where
>> each DSA link ultimately goes to a different upstream switch).
> 
> Hit "send" too soon. Wanted to give the extra hint that the "master"
> pointer is given to you here for a reason. You can look at struct
> dsa_port *cpu_dp = master->dsa_ptr, and figure out the index of the CPU
> port which can be used for RMU operations. I see that the macros are
> constructed in a very strange way:
> 

Ah, nice one. Thanks.

> #define MV88E6352_G1_CTL2_RMU_MODE_DISABLED	0x0000
> #define MV88E6352_G1_CTL2_RMU_MODE_PORT_4	0x1000
> #define MV88E6352_G1_CTL2_RMU_MODE_PORT_5	0x2000
> #define MV88E6352_G1_CTL2_RMU_MODE_PORT_6	0x3000
> 
> it's as if this is actually a bit mask of ports, and they all can be
> combined together. The bit in G1_CTL2 whose state we can flip can be
> made to depend on the number of the CPU port attached to the DSA master
> which changed state.

