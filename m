Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D29F35674A3
	for <lists+netdev@lfdr.de>; Tue,  5 Jul 2022 18:42:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232198AbiGEQml (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jul 2022 12:42:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230013AbiGEQmk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jul 2022 12:42:40 -0400
Received: from mail-qt1-x834.google.com (mail-qt1-x834.google.com [IPv6:2607:f8b0:4864:20::834])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC0381CB3F
        for <netdev@vger.kernel.org>; Tue,  5 Jul 2022 09:42:38 -0700 (PDT)
Received: by mail-qt1-x834.google.com with SMTP id g14so14491684qto.9
        for <netdev@vger.kernel.org>; Tue, 05 Jul 2022 09:42:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=ryaTddm669SarBrctjnz45QTCtMCexG5wh9ypciJa10=;
        b=b8qj/GPYdLjVw3kewE0tTJvw/jKDZlHJbzsgY6Y0tmhBFTOrDiWVI28G8bX74s3FWq
         FzBfK3djRymyz3U+Q9sRyAN/fXqSXXnd1Sxg+JSTMc9NGm1tpy+hl2biPaZvQZfLGlU0
         5/4LRE5iJO2vsRD7I+G/8IS67jBLGlPtkxRbelsYcp0k37Y20RcRYkCKAxjbaNYWmB8b
         ZEfsIeG96abZJixV9q/cpiNRWWU3DCG69tEgsG1pdmS7Pu/feSXBHR7xK/uojQnDX+Sy
         DzMN5L0q00ZUlEN/60wlG7ptL3EP6JyohHiov3bzJy/0JDExJS33EMgUJtU0y2dhz8DP
         q30A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=ryaTddm669SarBrctjnz45QTCtMCexG5wh9ypciJa10=;
        b=EAjY3pI3NQ9qL3kyo0N3l06uygcXJQi9xGHFghPMbR9jDOUyTB4A4DK4lcwonRLGxM
         pmVzW7fNRBiUkedzwrF/euzdwrLUEpiNfF2EP9oYdUWsMUCq6T3uyYWp6eBP6g4lulMD
         B85xuEMPT4xuVdBLnWb3w8wmpo11idHgOdSvw0SRbZYOiEjSjiN7hpZR2iSeU9R0IMvs
         Wr8DfZF+2YA0UgfsoA3p/sd+R3Sbn+LxXzRd9cpu9pFUbim93LzZsNBpzVQRPuKn8MFZ
         w9F2q4Mc68K5qSFTuDXCqunta/Wd9gmnbe+JANZvOM48Wir2ccJSnS0Nt5jdzGJO7brh
         Kqtw==
X-Gm-Message-State: AJIora/SrURdEdKZQI2kIlDTz04SdC3pUHgI1j4Q4/rBZRCyqRqhMZ3J
        lfzZ7icaZYPxEGW7NCTVFSA=
X-Google-Smtp-Source: AGRyM1tIltMvT9oViWGHBLRHaRgJ9xXRfqV/Uru0GK2vt4xSGd18dPDxKadozcdmxjQVn+2qLvUSAA==
X-Received: by 2002:a05:6214:21c9:b0:472:f782:4c2b with SMTP id d9-20020a05621421c900b00472f7824c2bmr9097264qvh.12.1657039357817;
        Tue, 05 Jul 2022 09:42:37 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id ci27-20020a05622a261b00b00316dc1ffbb9sm15695510qtb.32.2022.07.05.09.42.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Jul 2022 09:42:37 -0700 (PDT)
Message-ID: <7fe6b661-06b9-96dd-e064-1db23a9eaae7@gmail.com>
Date:   Tue, 5 Jul 2022 09:42:33 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH RFC net-next v2 0/5] net: dsa: always use phylink
Content-Language: en-US
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Alexandre Belloni <alexandre.belloni@bootlin.com>,
        =?UTF-8?Q?Alvin_=c5=a0ipraga?= <alsi@bang-olufsen.dk>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        DENG Qingfang <dqfext@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        George McCollister <george.mccollister@gmail.com>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Jakub Kicinski <kuba@kernel.org>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        Matthias Brugger <matthias.bgg@gmail.com>,
        netdev@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        Sean Wang <sean.wang@mediatek.com>,
        UNGLinuxDriver@microchip.com,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Woojung Huh <woojung.huh@microchip.com>
References: <YsQIjC7UpcGWJovx@shell.armlinux.org.uk>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <YsQIjC7UpcGWJovx@shell.armlinux.org.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
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

On 7/5/22 02:46, Russell King (Oracle) wrote:
> A new revision of the series which incorporates changes that Marek
> suggested. Specifically, the changes are:
> 
> 1. Patch 2 - use the phylink_get_caps method in mv88e6xxx to get the
>     default interface rather than re-using port_max_speed_mode()
> 
> 2. Patch 4 - if no default interface is provided, use the supported
>     interface mask to search for the first interface that gives the
>     fastest speed.
> 
> 3. Patch 5 - now also removes the port_max_speed_mode() method

This was tested with bcm_sf2.c and b53_srab.b and did not cause 
regressions, however we do have a 'fixed-link' property for the CPU port 
(always have had one), so there was no regression expected.

See answers to your RFC v1 below.

> 
>   drivers/net/dsa/b53/b53_common.c       |   3 +-
>   drivers/net/dsa/bcm_sf2.c              |   3 +-
>   drivers/net/dsa/hirschmann/hellcreek.c |   3 +-
>   drivers/net/dsa/lantiq_gswip.c         |   6 +-
>   drivers/net/dsa/microchip/ksz_common.c |   3 +-
>   drivers/net/dsa/mt7530.c               |   3 +-
>   drivers/net/dsa/mv88e6xxx/chip.c       | 136 +++++++++++++++---------------
>   drivers/net/dsa/mv88e6xxx/chip.h       |   6 +-
>   drivers/net/dsa/mv88e6xxx/port.c       |  32 -------
>   drivers/net/dsa/mv88e6xxx/port.h       |   5 --
>   drivers/net/dsa/ocelot/felix.c         |   3 +-
>   drivers/net/dsa/qca/ar9331.c           |   3 +-
>   drivers/net/dsa/qca8k.c                |   3 +-
>   drivers/net/dsa/realtek/rtl8365mb.c    |   3 +-
>   drivers/net/dsa/sja1105/sja1105_main.c |   3 +-
>   drivers/net/dsa/xrs700x/xrs700x.c      |   3 +-
>   drivers/net/phy/phylink.c              | 150 ++++++++++++++++++++++++++++++---
>   include/linux/phylink.h                |   5 ++
>   include/net/dsa.h                      |   3 +-
>   net/dsa/port.c                         |  47 +++++++----
>   20 files changed, 270 insertions(+), 153 deletions(-)
> 
> On Wed, Jun 29, 2022 at 01:49:57PM +0100, Russell King (Oracle) wrote:
>> Mostly the same as the previous RFC, except:
>>
>> 1) incldues the phylink_validate_mask_caps() function
>> 2) has Marek's idea of searching the supported_interfaces bitmap for the
>>     fastest interface we can use
>> 3) includes a final patch to add a print which will be useful to hear
>>     from people testing it.
>>
>> Some of the questions from the original RFC remain though, so I've
>> included that text below. I'm guessing as they remain unanswered that
>> no one has any opinions on them?
>>
>>   drivers/net/dsa/b53/b53_common.c       |   3 +-
>>   drivers/net/dsa/bcm_sf2.c              |   3 +-
>>   drivers/net/dsa/hirschmann/hellcreek.c |   3 +-
>>   drivers/net/dsa/lantiq_gswip.c         |   6 +-
>>   drivers/net/dsa/microchip/ksz_common.c |   3 +-
>>   drivers/net/dsa/mt7530.c               |   3 +-
>>   drivers/net/dsa/mv88e6xxx/chip.c       |  53 ++++--------
>>   drivers/net/dsa/ocelot/felix.c         |   3 +-
>>   drivers/net/dsa/qca/ar9331.c           |   3 +-
>>   drivers/net/dsa/qca8k.c                |   3 +-
>>   drivers/net/dsa/realtek/rtl8365mb.c    |   3 +-
>>   drivers/net/dsa/sja1105/sja1105_main.c |   3 +-
>>   drivers/net/dsa/xrs700x/xrs700x.c      |   3 +-
>>   drivers/net/phy/phylink.c              | 148 ++++++++++++++++++++++++++++++---
>>   include/linux/phylink.h                |   5 ++
>>   include/net/dsa.h                      |   3 +-
>>   net/dsa/port.c                         |  47 +++++++----
>>   17 files changed, 215 insertions(+), 80 deletions(-)
>>
>> On Fri, Jun 24, 2022 at 12:41:26PM +0100, Russell King (Oracle) wrote:
>>> Hi,
>>>
>>> Currently, the core DSA code conditionally uses phylink for CPU and DSA
>>> ports depending on whether the firmware specifies a fixed-link or a PHY.
>>> If either of these are specified, then phylink is used for these ports,
>>> otherwise phylink is not, and we rely on the DSA drivers to "do the
>>> right thing". However, this detail is not mentioned in the DT binding,
>>> but Andrew has said that this behaviour has always something that DSA
>>> wants.
>>>
>>> mv88e6xxx has had support for this for a long time with its "SPEED_MAX"
>>> thing, which I recently reworked to make use of the mac_capabilities in
>>> preparation to solving this more fully.
>>>
>>> This series is an experiment to solve this properly, and it does this
>>> in two steps.
>>>
>>> The first step consists of the first two patches. Phylink needs to
>>> know the PHY interface mode that is being used so it can (a) pass the
>>> right mode into the MAC/PCS etc and (b) know the properties of the
>>> link and therefore which speeds can be supported across it.
>>>
>>> In order to achieve this, the DSA phylink_get_caps() method has an
>>> extra argument added to it so that DSA drivers can report the
>>> interface mode that they will be using for this port back to the core
>>> DSA code, thereby allowing phylink to be initialised with the correct
>>> interface mode.
>>>
>>> Note that this can only be used for CPU and DSA ports as "user" ports
>>> need a different behaviour - they rely on getting the interface mode
>>> from phylib, which will only happen if phylink is initialised with
>>> PHY_INTERFACE_MODE_NA. Unfortunately, changing this behaviour is likely
>>> to cause widespread regressions.
>>>
>>> Obvious questions:
>>> 1. Should phylink_get_caps() be augmented in this way, or should it be
>>>     a separate method?
>>>
>>> 2. DSA has traditionally used "interface mode for the maximum supported
>>>     speed on this port" where the interface mode is programmable (via
>>>     its internal port_max_speed_mode() method) but this is only present
>>>     for a few of the sub-drivers. Is reporting the current interface
>>>     mode correct where this method is not implemented?
>>>
>>> The second step is to introduce a function that allows phylink to be
>>> reconfigured after creation time to operate at max-speed fixed-link
>>> mode for the PHY interface mode, also using the MAC capabilities to
>>> determine the speed and duplex mode we should be using.
>>>
>>> Obvious questions:
>>> 1. Should we be allowing half-duplex for this?

Except for testing, not sure I do see a point as it should not be a 
configuration being used at all?

>>> 2. If we do allow half-duplex, should we prefer fastest speed over
>>>     duplex setting, or should we prefer fastest full-duplex speed
>>>     over any half-duplex?

I would opt for fastest speed over duplex setting.

>>> 3. How do we sanely switch DSA from its current behaviour to always
>>>     using phylink for these ports without breakage - this is the
>>>     difficult one, because it's not obvious which drivers have been
>>>     coded to either work around this quirk of the DSA implementation.
>>>     For example, if we start forcing the link down before calling
>>>     dsa_port_phylink_create(), and we then fail to set max-fixed-link,
>>>     then the CPU/DSA port is going to fail, and we're going to have
>>>     lots of regressions.

Good question, we already have a legacy_pre_march2020 behavior for a 
piece of infrastructure code that is not so old, I doubt that we would 
want to add more of that type of quirk.
-- 
Florian
