Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C65569E896
	for <lists+netdev@lfdr.de>; Tue, 21 Feb 2023 20:54:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229663AbjBUTym (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Feb 2023 14:54:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229498AbjBUTyl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Feb 2023 14:54:41 -0500
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C2F0233CE;
        Tue, 21 Feb 2023 11:54:41 -0800 (PST)
Received: by mail-pl1-x631.google.com with SMTP id bh1so6299868plb.11;
        Tue, 21 Feb 2023 11:54:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=LZtNabuOvExClcgrEORVynQKjs6pL5On5aAsfoAimgY=;
        b=p90O1ZeAb1UYj8T/WpScu661Zg+VzE8FqonKvjoB2r25obADJcLUHO5p8ZLaTfvnRg
         3s9zt83iBNXvEXzLsgtPojneV6fMEZaaa6a8AP1ygVmnH/MrPyEcMXWyI954KMxvL/9w
         0+ouQEr34e52yAYRyTNA9RA1wYlhIGT7d0pdR0iBn/BXV1jrCqnjevMOgWdGcaH1RisF
         EOl0MBGlxCUSZml5Mh0lkTH1YRsL9aDojIRxTFMx1akxnXjU4XnKbi4IJcaPFfjjL+TO
         gF49O/KrTF3JmAuE75UAWbzyakqKCT5AN33i4mcCD5ppkjwUUNI6/J8GRUfgG7YhBEtC
         W1Bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=LZtNabuOvExClcgrEORVynQKjs6pL5On5aAsfoAimgY=;
        b=8RBcuOnEtBpT/oU9I+URBYzqTTK+zbSYxM7vlPtffCI7mS1re0YBHPCCV5IxcwLw9d
         7FJF4Dg+OyXHqb/P0JPsl9rQkUl248UzhWkmkJWfoq7UuAV28aeQ8rZxx0zEinhcG04V
         uwCBUJ2o4OYkOen16kzZXuk2y3XDRQFCb+03mZzBVHR6hsSRdGe1MvcY2LNR2Q9zEGMr
         WLu6hvh/syKlLpmqgIfwZWKYsYpv5qkWklLE5zTwLC5EPW9BA3KXlD4dwj8rgY3YNym0
         b/DHEVSCvnMkMWq2r8+H+/Py2l3Po2YucOVDOkJVXqajYXm+rgYSni828Vd2eetdxPFq
         Tt/g==
X-Gm-Message-State: AO0yUKUUIUZYz6x1l/1hBE2FK1RRUyG4GBJSi1k9qSxO54I8vl8j/wmW
        4gptITgNkjJ/U5dmVL6S5O4=
X-Google-Smtp-Source: AK7set+EE/QTqyCHYl/k12767u5WxM16+kd38JN563JeBglbAAGpuXwHqBzwmxyTPB30cyB9KQ5sQQ==
X-Received: by 2002:a05:6a20:3d0c:b0:c7:1bac:6ef9 with SMTP id y12-20020a056a203d0c00b000c71bac6ef9mr3901987pzi.46.1677009280586;
        Tue, 21 Feb 2023 11:54:40 -0800 (PST)
Received: from [10.69.33.24] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id k17-20020a170902761100b0019a8468cbedsm276464pll.226.2023.02.21.11.53.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Feb 2023 11:54:40 -0800 (PST)
Message-ID: <33198e39-8c86-85db-76c2-c5ce18dee290@gmail.com>
Date:   Tue, 21 Feb 2023 11:53:43 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.1.2
Subject: Re: BCM54220: After the BCM54220 closes the auto-negotiation, the
 configuration forces the 1000M network port to be linked down all the time.
Content-Language: en-US
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     "Wang, Xiaolei" <Xiaolei.Wang@windriver.com>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "bcm-kernel-feedback-list@broadcom.com" 
        <bcm-kernel-feedback-list@broadcom.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "richardcochran@gmail.com" <richardcochran@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <MW5PR11MB5764F9734ACFED2EF390DFF795A19@MW5PR11MB5764.namprd11.prod.outlook.com>
 <ae617cad-63dc-333f-c4c4-5266de88e4f8@gmail.com> <Y/UehVXRNHuRprAv@lunn.ch>
From:   Doug Berger <opendmb@gmail.com>
In-Reply-To: <Y/UehVXRNHuRprAv@lunn.ch>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/21/2023 11:41 AM, Andrew Lunn wrote:
> On Tue, Feb 21, 2023 at 10:44:44AM -0800, Doug Berger wrote:
>> On 2/17/2023 12:06 AM, Wang, Xiaolei wrote:
>>> hi
>>>
>>>       When I use the nxp-imx7 board, eth0 is connected to the PC, eth0 is turned off the auto-negotiation mode, and the configuration is forced to 10M, 100M, 1000M. When configured to force 1000M，
>>>       The link status of phy status reg(0x1) is always 0, and the chip of phy is BCM54220, but I did not find the relevant datasheet on BCM official website, does anyone have any suggestions or the datasheet of BCM54220?
>>>
>>> thanks
>>> xiaolei
>>>
>> It is my understanding that the 1000BASE-T PHY requires peers to take on
>> asymmetric roles and that establishment of these roles requires negotiation
>> which occurs during auto-negotiation. Some PHYs may allow manual programming
>> of these roles, but it is not standardized and tools like ethtool do not
>> support manual specification of such details.
> 
> Are you talking about ethtool -s [master-slave|preferred-master|preferred-slave|forced-master|forced-slave]
> 
I am, though I was not aware of their addition to ethtool and I avoided 
referencing them by name out of an overabundance of political 
correctness ;).

Thanks for bringing this to my attention.

> The broadcom PHYs call genphy_config_aneg() -> __genphy_config_aneg()
> -> genphy_setup_master_slave() which should configure this, even when
> auto-neg is off.
Yes, this sounds good. Perhaps Xiaolei is not setting these properly 
when forcing 1000.

> 
> 	 Andrew
Thanks again!
     Doug
