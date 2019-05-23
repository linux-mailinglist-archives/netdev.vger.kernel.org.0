Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AE81028C54
	for <lists+netdev@lfdr.de>; Thu, 23 May 2019 23:30:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387709AbfEWVaq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 May 2019 17:30:46 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:36331 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729797AbfEWVaq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 May 2019 17:30:46 -0400
Received: by mail-wm1-f68.google.com with SMTP id j187so7178923wmj.1
        for <netdev@vger.kernel.org>; Thu, 23 May 2019 14:30:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:openpgp:autocrypt:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=zI4T1oZ90AYUgWcTTwrlMBRuC2ZoFzjnpz7QKDxrDjs=;
        b=KUGGvimaK5WNFv6cb/HxGljsNf9kbjPozaroxsD2KBx8ZlnYb+7wATL2dBjrfDme3h
         3IEYs3abRbnCK3lbuGZHd7NZM01tYy3bRB8Z7lFnVpOJbN4Pp/jKn6qLZ7qMF34tT8D0
         6jI+28UJn7FHyg4/SzmAPsHMmdwIpywFuo9vU/uChRdXltSxvuTrsW+ONJ35EUQSPdyv
         82Fi4sZ0gveR5BqTZvs87m7YgNM00h1sqWQjTfFqRh/4mUsgKElUx6jHZ4VnGOvqJPul
         yHYHuVuXQNdHKClEi6QIHE3B9mLEVAkkVe+1TNFFIA3fpTB9dY4vPDwO0L0WbzM/RgRX
         Khsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=zI4T1oZ90AYUgWcTTwrlMBRuC2ZoFzjnpz7QKDxrDjs=;
        b=rBQnlQcSW8ByJgV9tSA+fB7R6mm0LtNSS57ba+8RctjF2V5/1Cfy9RvmlCQZ9iw17v
         T8o3splW3n03K/pRSg3Wmf2gb0APFVCVYQmJte7YyCP8JrS/zxKl3PRpaMna+RuuzRZG
         7myHBhN4MAoIo/ffiMq+stejltlxV2P++zbFtczfVGM2N2cUVa981j1NNkM4XqvXNL0+
         et6Rg67gTLm6PhNWkQ3a841NLXzwJtxjBigmeU/vnqD8wpe70HQ+JR6nkEk4cFWNq5kJ
         JWhVaachBwoH+jOBhdkDyZNcr9rTgWtusjQy42D/CLqyvraPAcaVAya38xZVMF9fYvFv
         yugA==
X-Gm-Message-State: APjAAAXWDom3Retx3Lkzs2k17rrW0gSS0io1o5kLQbW5vBKhZsclQBG4
        DmS4DCj8HAQS6EDUAp8KpBA=
X-Google-Smtp-Source: APXvYqzoc4uVri9Th3kM2Eu6SHxRcDOX00Uep93siMP2FzvApGiWyI2+5WJPgvKfmn+z3E8Tg2eFAw==
X-Received: by 2002:a1c:cf4c:: with SMTP id f73mr12665236wmg.118.1558647042162;
        Thu, 23 May 2019 14:30:42 -0700 (PDT)
Received: from [10.67.49.213] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id m10sm492634wmf.40.2019.05.23.14.30.39
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 23 May 2019 14:30:41 -0700 (PDT)
Subject: Re: [RFC PATCH net-next 5/9] net: phylink: Add phylink_create_raw
To:     Vladimir Oltean <olteanv@gmail.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "maxime.chevallier@bootlin.com" <maxime.chevallier@bootlin.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>
References: <20190523011958.14944-1-ioana.ciornei@nxp.com>
 <20190523011958.14944-6-ioana.ciornei@nxp.com>
 <c2712523-f1b9-47f8-672b-d35e62bf35ea@gmail.com>
 <0d29a5ee-8a68-d0be-c524-6e3ee1f46802@gmail.com>
 <VI1PR0402MB28006FF30E571E71F1AA1278E0010@VI1PR0402MB2800.eurprd04.prod.outlook.com>
 <716d26d0-e997-177f-ca35-d39cbd1f67ce@gmail.com>
 <50aa7d8d-c03d-2209-93bf-f73784bf1970@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Openpgp: preference=signencrypt
Autocrypt: addr=f.fainelli@gmail.com; prefer-encrypt=mutual; keydata=
 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
 M5kY0ACeNhCZJvZ5g4C2Lc9fcTHu8jxmEkI=
Message-ID: <0cca4621-13da-3fa2-cdd9-6a969162c49b@gmail.com>
Date:   Thu, 23 May 2019 14:30:30 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <50aa7d8d-c03d-2209-93bf-f73784bf1970@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/23/19 1:32 PM, Vladimir Oltean wrote:
> On 5/23/19 5:32 PM, Florian Fainelli wrote:
>>
>> On 5/23/2019 5:10 AM, Ioana Ciornei wrote:
>>>
>>>> Subject: Re: [RFC PATCH net-next 5/9] net: phylink: Add
>>>> phylink_create_raw
>>>>
>>>>
>>>>
>>>> On 5/22/2019 7:25 PM, Florian Fainelli wrote:
>>>>>
>>>>>
>>>>> On 5/22/2019 6:20 PM, Ioana Ciornei wrote:
>>>>>> This adds a new entry point to PHYLINK that does not require a
>>>>>> net_device structure.
>>>>>>
>>>>>> The main intended use are DSA ports that do not have net devices
>>>>>> registered for them (mainly because doing so would be redundant - see
>>>>>> Documentation/networking/dsa/dsa.rst for details). So far DSA has
>>>>>> been using PHYLIB fixed PHYs for these ports, driven manually with
>>>>>> genphy instead of starting a full PHY state machine, but this does
>>>>>> not scale well when there are actual PHYs that need a driver on those
>>>>>> ports, or when a fixed-link is requested in DT that has a speed
>>>>>> unsupported by the fixed PHY C22 emulation (such as SGMII-2500).
>>>>>>
>>>>>> The proposed solution comes in the form of a notifier chain owned by
>>>>>> the PHYLINK instance, and the passing of phylink_notifier_info
>>>>>> structures back to the driver through a blocking notifier call.
>>>>>>
>>>>>> The event API exposed by the new notifier mechanism is a 1:1 mapping
>>>>>> to the existing PHYLINK mac_ops, plus the PHYLINK fixed-link
>>>>>> callback.
>>>>>>
>>>>>> Both the standard phylink_create() function, as well as its raw
>>>>>> variant, call the same underlying function which initializes either
>>>>>> the netdev field or the notifier block of the PHYLINK instance.
>>>>>>
>>>>>> All PHYLINK driver callbacks have been extended to call the notifier
>>>>>> chain in case the instance is a raw one.
>>>>>>
>>>>>> Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
>>>>>> Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
>>>>>> ---
>>>>>
>>>>> [snip]
>>>>>
>>>>>> +    struct phylink_notifier_info info = {
>>>>>> +        .link_an_mode = pl->link_an_mode,
>>>>>> +        /* Discard const pointer */
>>>>>> +        .state = (struct phylink_link_state *)state,
>>>>>> +    };
>>>>>> +
>>>>>>       netdev_dbg(pl->netdev,
>>>>>>              "%s: mode=%s/%s/%s/%s adv=%*pb pause=%02x link=%u
>>>> an=%u\n",
>>>>>>              __func__, phylink_an_mode_str(pl->link_an_mode),
>>>>>> @@ -299,7 +317,12 @@ static void phylink_mac_config(struct phylink
>>>>>> *pl,
>>>>>>              __ETHTOOL_LINK_MODE_MASK_NBITS, state->advertising,
>>>>>>              state->pause, state->link, state->an_enabled);
>>>>>
>>>>> Don't you need to guard that netdev_dbg() with an if (pl->ops) to
>>>>> avoid de-referencing a NULL net_device?
>>>>>
>>>
>>>
>>> The netdev_* print will not dereference a NULL net_device since it
>>> has explicit checks agains this.
>>> Instead it will just print (net/core/dev.c, __netdev_printk):
>>>
>>>     printk("%s(NULL net_device): %pV", level, vaf);
>>>
>>>
>>>>> Another possibility could be to change the signature of the
>>>>> phylink_mac_ops to take an opaque pointer and in the case where we
>>>>> called phylink_create() and passed down a net_device pointer, we
>>>>> somehow remember that for doing any operation that requires a
>>>>> net_device (printing, setting carrier). We lose strict typing in doing
>>>>> that, but we'd have fewer places to patch for a blocking notifier
>>>>> call.
>>>>>
>>>>
>>>> Or even make those functions part of phylink_mac_ops such that the
>>>> caller
>>>> could pass an .carrier_ok callback which is netif_carrier_ok() for a
>>>> net_device,
>>>> else it's NULL, same with printing functions if desired...
>>>> -- 
>>>> Florian
>>>
>>>
>>> Let me see if I understood this correctly. I presume that any API
>>> that we add should not break any current PHYLINK users.
>>>
>>> You suggest to change the prototype of the phylink_mac_ops from
>>>
>>>     void (*validate)(struct net_device *ndev, unsigned long *supported,
>>>              struct phylink_link_state *state);
>>>
>>> to something that takes a void pointer:
>>>
>>>     void (*validate)(void *dev, unsigned long *supported,
>>>              struct phylink_link_state *state);
>>
>> That is what I am suggesting, but I am also suggesting passing all
>> netdev specific calls that must be made as callbacks as well, so
>> something like:
>>
>>     bool (*carrier_ok)(const void *dev)
>>     void (*carrier_set)(const void *dev, bool on)
>>     void (*print)(const void *dev, const char *fmt)
>>
>> as new members of phylink_mac_ops.
>>
>>>
>>> This would imply that the any function in PHYLINK would have to
>>> somehow differentiate if the dev provided is indeed a net_device or
>>> another structure in order to make the decision if netif_carrier_off
>>> should be called or not (this is so we do not break any drivers using
>>> PHYLINK). I cannot see how this judgement can be made.
>>
>> You don't have to make the judgement you can just do:
>>
>> if (pl->ops->carrier_set)
>>     pl->ops->carrier_set(dev,
>>
>> where dev was this opaque pointer passed to phylink_create() the first
>> time it was created. Like I wrote, we lose strong typing doing that, but
>> we don't have to update all code paths for if (pl->ops) else notifier.
>>
> 
> Hi Florian,
> 
> Have you thought this through?

Not to the point of seeing the problems you are highlighting.

> What about the totally random stuff, such as this portion from 2/9:
> 
>> @@ -1187,8 +1190,10 @@ int phy_attach_direct(struct net_device *dev,
>> struct phy_device *phydev,
>>       * our own module->refcnt here, otherwise we would not be able to
>>       * unload later on.
>>       */
>> +    if (dev)
>> +        ndev_owner = dev->dev.parent->driver->owner;
>>      if (ndev_owner != bus->owner && !try_module_get(bus->owner)) {
>> -        dev_err(&dev->dev, "failed to get the bus module\n");
>> +        phydev_err(phydev, "failed to get the bus module\n");
>>          return -EIO;
>>      }
> 
> Which is in PHYLIB by the way.
> Do you just add a pl->ops->owns_mdio_bus() callback? What if that code
> goes away in the future? Do you remove it? This is code that all users
> of phylink_create_raw will have to implement.
> 
> IMO the whole point is to change as little as possible from PHYLINK's
> surface, and nothing from PHYLIB's. What you're suggesting is to change
> everything, *including* phylib. And PHYLINK's print callback can't be
> used in PHYLIB unless struct phylink is made public.
> 
> And if you want to replace "struct net_device *ndev" with "const void
> *dev", how will you even assign the phydev->attached_dev->phydev
> backlink? Another callback?
> 
> As for carrier state - realistically I don't see how any raw PHYLINK
> user would implement it any other way except keep a variable for it.
> Hence just let PHYLINK do it once.
> 
> I fail to see how this is cleaner.
Fine, it's not.
-- 
Florian
