Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E52050CB5E
	for <lists+netdev@lfdr.de>; Sat, 23 Apr 2022 16:41:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229767AbiDWOny (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Apr 2022 10:43:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229917AbiDWOnv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Apr 2022 10:43:51 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28E3783B08
        for <netdev@vger.kernel.org>; Sat, 23 Apr 2022 07:40:52 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id u7so1744495plg.13
        for <netdev@vger.kernel.org>; Sat, 23 Apr 2022 07:40:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=GgwnvTGaPEM6jRY2ls7CdT1RKG8XUeXZzkENfBMw0tg=;
        b=bVDysq1D20bi9AiCx+fPbKS7jXCkaa+vb/2Anp1imfRhrX68pNNvhkJPOpXYj0ckkl
         OrAM9/Ako1CUsEuHO1FQjnm6EFzmFG+9ejFW7+44uzZ8EW0XZaLlM/7Tml5XvYvHlTE/
         nb55Spp9nGYdW+Apq7H0imavCt9OGMxwAlXSKeTxA4qVdbhbEriGYuvMYY8dxtdRxEAI
         /8cfHDtJBkBQeBC3+JdBRgwEb7IKCXNJgUDLDs+h2MTmGyAS64egXUYoe9X7/PWvcTwV
         0GRluyth/pscSgxOWmvVdNGDe1x/cRF5mkLZWVPpiIh6mXZO/kAxV+/aXJNKOAqeK8hI
         hIKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=GgwnvTGaPEM6jRY2ls7CdT1RKG8XUeXZzkENfBMw0tg=;
        b=VHPt+eZoji6uzOGD4OzzD1p5HnAtysmqB1TPk2NC3jCrYy83sR1byN/3iotTS9vMig
         JD0IxvqPF85w3zthabogtCt+270RYUc4MY4fkAx8eRlB/OlCBED3feHEHOTticnbPXtn
         9VYaG//NBRA0c7/kSgTUpgieZq9KkbpsIhXoJxQSAEwNDOeftit9rddI+sH1KwVatpwY
         MyZ8fsYa+Xahh4x80w4CujbN/ItcGlsG0lgEhYqKHmr0OxjjlYFlBmiE2GZEBkyP7L7P
         Y0UhqxIrBMp5kQVGYas2512Vf5QI5/Z35kqrnbBe/xidT6RS5Y/DEZn46yqF72gxyFLc
         JKtw==
X-Gm-Message-State: AOAM533xWe1tjOcgo3kQFDpFQjR7Nf8jbC0NC8Zf5Vt53yC9XZxXMEm3
        bQdIivT6V8un3URA4/8URC4ib0ApJO4=
X-Google-Smtp-Source: ABdhPJyKOotQFgHQelj+9aszafYWM7kbwdex0H4Rg+GsAo6dna58du1lywIk+cmMEntQs1dVDREu7w==
X-Received: by 2002:a17:902:f70f:b0:153:ebfe:21b3 with SMTP id h15-20020a170902f70f00b00153ebfe21b3mr9469712plo.119.1650724851544;
        Sat, 23 Apr 2022 07:40:51 -0700 (PDT)
Received: from ?IPV6:2600:8802:b00:4a48:d148:def2:73f:7f8c? ([2600:8802:b00:4a48:d148:def2:73f:7f8c])
        by smtp.gmail.com with ESMTPSA id bc11-20020a656d8b000000b0039cc4dbb295sm4903080pgb.60.2022.04.23.07.40.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 23 Apr 2022 07:40:50 -0700 (PDT)
Message-ID: <01f35484-e8b6-d0bb-dba7-d1e0407c00ca@gmail.com>
Date:   Sat, 23 Apr 2022 07:40:49 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH net-next] 1588 support on bcm54210pe
Content-Language: en-US
To:     Richard Cochran <richardcochran@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>
Cc:     Lasse Johnsen <lasse@timebeat.app>, netdev@vger.kernel.org,
        Gordon Hollingworth <gordon@raspberrypi.com>,
        Ahmad Byagowi <clk@fb.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        bcm-kernel-feedback-list@broadcom.com,
        Florian Fainelli <f.fainelli@gmail.com>
References: <928593CA-9CE9-4A54-B84A-9973126E026D@timebeat.app>
 <YmBc2E2eCPHMA7lR@lunn.ch>
 <C6DCE6EC-926D-4EDF-AFE9-F949C0F55B7F@timebeat.app>
 <YmLC98NMfHUxwPF6@lunn.ch> <20220422194810.GA9325@hoboy.vegasvil.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220422194810.GA9325@hoboy.vegasvil.org>
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



On 4/22/2022 12:48 PM, Richard Cochran wrote:
> On Fri, Apr 22, 2022 at 05:00:07PM +0200, Andrew Lunn wrote:
> 
>>> I am confident that this code is relevant exclusively to the
>>> BCM54210PE.
> 
> Not true.
> 
>> It will not even work with the BCM54210, BCM54210S and
>>> BCM54210SE PHYs.
> 
> The registers you used are also present in the BCM541xx devices.
> Pretty sure your code would work on those devices (after adjusting
> register offsets).
> 
>> Florian can probably tell us more, but often hardware like this is
>> shared by multiple devices. If it is, you might want to use a more
>> generic prefix.
> 
> My understanding is that there are two implementions, gen1 and gen2.
> Your bcm542xx and the bcm541xx are both gen1, and both support inband
> Rx time stamping.

That is correct. Lasse for your future submission please address the 
following:

- conform to the usual patch submission style and break up your changes 
between bcmgenet.c (although I doubt you need to change it), broadcom.c 
and bcm-phy-lib.[ch]

- do not create a PHY device entry specifically for BCM54210PE, use the 
existing BCM54210 entry and add checks using the revision field of 
phydev->phy_id where necessary. There are already many entries in this 
driver, adding more does not help maintaining it. Also, I went through 
several months of work fixing bugs and adding decent power management 
features to this driver that all PHYs should leverage, adding a new 
entry means we need to verify whether all code paths are hit or not

- move generic code, such as all of the PTP code into bcm-phy-lib.[ch] 
where it can easily be re-used across multiple PHY device driver entries 
(54810, 54210 etc.)

Thanks!

> 
> Because the registers are all the same (just the offsets are
> different), I'd like to see a common module that can be used by all
> gen1 devices.  The module could be named bcm-ptp-gen1.c for example.

I would prefer that we just stick to adding that code to 
bcm-phy-lib.[ch] which all Broadcom PHY drivers can use and we can 
decide whether we want to add a Kconfig option specifically for PTP.

Cheers
-- 
Florian
