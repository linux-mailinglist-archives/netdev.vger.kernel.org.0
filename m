Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A772F27FB9
	for <lists+netdev@lfdr.de>; Thu, 23 May 2019 16:32:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730757AbfEWOch (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 May 2019 10:32:37 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:41473 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730708AbfEWOcg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 May 2019 10:32:36 -0400
Received: by mail-pg1-f193.google.com with SMTP id z3so3236872pgp.8
        for <netdev@vger.kernel.org>; Thu, 23 May 2019 07:32:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:openpgp:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=SqjZD0D4Gu8eJn3pNHblzABsIlVBZYvWwzUma4OPsDM=;
        b=aK56as8XG7eU6dvBLc7HDGlrMyJq49KLsFflllotM5ooB7u3YImXFzYBh7rhMNRYDG
         5kY1CJzBN7SlR6oAy3QxIl1cXY7PwXL8OMYcyBGNrFGoR19hCDDlhETlMEJsLL9B/iM6
         PjQA/tUdWjPi5KhJEav953p5a1osdAJ5qgEITAWNZ51S+HsHZmBiw6gu1rOk1/2kzhp3
         4IJr1UQeFNYamLKidPBJsHneY+vhqI2mggyUrg1JLLD4fdeSXx4ow9AuQKFuGKPjqdoF
         SYq3WtNoBoqqX9aoXi0GZE4Dv4EctNUufrPw2YjkTGMKt1dWDeSG8GGrtTSvhI4nbSQb
         dJNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=SqjZD0D4Gu8eJn3pNHblzABsIlVBZYvWwzUma4OPsDM=;
        b=P1hkcYR0Z3xnaq5VPQx4bZYZAVZTL1OdiTGLBqj1NebsmfeRgjLdjZXdT3KT/wmnOP
         zce05VqU/1IaD7BwjWWshdLULyq5r4NnKqJG311IKComzfyo4YF3maXPiTE10R7F8bA4
         bCv368Nf9X/pLfve5WgTjkmnWvwO/cpDzD8QNqCOVvsQUSX1nz1zs6eCm76wp/BcqaTz
         mxLU8OCoQhABa1+/cuZCkqutKHXkRGC+cCj02n5OUVAXU+9Y8aR63OgWZBxH+noY1zCI
         Rl7sAMz9QqCT7W2jANHD4N3EbsH9gNqvA9/9SaWQs2XbSCcueZ8MSSJN8TkJrztnKrLL
         HuJg==
X-Gm-Message-State: APjAAAUB3JZB+z4/f8b8HERWKTPknJxOdwLxip7s6Wd3+LSBvk9tfqEB
        8MTqzQzUBcihfbMQzz0B/ck=
X-Google-Smtp-Source: APXvYqwmD8f9YHb9Xqf62HVnzD74J1u49ObIXBYb8Ox2vOCZeiIAzWs99IYLEno1zbM3nFtp6Yr9gw==
X-Received: by 2002:a62:ab10:: with SMTP id p16mr72239738pff.222.1558621955785;
        Thu, 23 May 2019 07:32:35 -0700 (PDT)
Received: from [10.230.1.150] ([192.19.228.250])
        by smtp.gmail.com with ESMTPSA id ds14sm674848pjb.32.2019.05.23.07.32.34
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 23 May 2019 07:32:34 -0700 (PDT)
Subject: Re: [RFC PATCH net-next 5/9] net: phylink: Add phylink_create_raw
To:     Ioana Ciornei <ioana.ciornei@nxp.com>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "maxime.chevallier@bootlin.com" <maxime.chevallier@bootlin.com>,
        "olteanv@gmail.com" <olteanv@gmail.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>
References: <20190523011958.14944-1-ioana.ciornei@nxp.com>
 <20190523011958.14944-6-ioana.ciornei@nxp.com>
 <c2712523-f1b9-47f8-672b-d35e62bf35ea@gmail.com>
 <0d29a5ee-8a68-d0be-c524-6e3ee1f46802@gmail.com>
 <VI1PR0402MB28006FF30E571E71F1AA1278E0010@VI1PR0402MB2800.eurprd04.prod.outlook.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Openpgp: preference=signencrypt
Message-ID: <716d26d0-e997-177f-ca35-d39cbd1f67ce@gmail.com>
Date:   Thu, 23 May 2019 07:32:32 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <VI1PR0402MB28006FF30E571E71F1AA1278E0010@VI1PR0402MB2800.eurprd04.prod.outlook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/23/2019 5:10 AM, Ioana Ciornei wrote:
> 
>> Subject: Re: [RFC PATCH net-next 5/9] net: phylink: Add phylink_create_raw
>>
>>
>>
>> On 5/22/2019 7:25 PM, Florian Fainelli wrote:
>>>
>>>
>>> On 5/22/2019 6:20 PM, Ioana Ciornei wrote:
>>>> This adds a new entry point to PHYLINK that does not require a
>>>> net_device structure.
>>>>
>>>> The main intended use are DSA ports that do not have net devices
>>>> registered for them (mainly because doing so would be redundant - see
>>>> Documentation/networking/dsa/dsa.rst for details). So far DSA has
>>>> been using PHYLIB fixed PHYs for these ports, driven manually with
>>>> genphy instead of starting a full PHY state machine, but this does
>>>> not scale well when there are actual PHYs that need a driver on those
>>>> ports, or when a fixed-link is requested in DT that has a speed
>>>> unsupported by the fixed PHY C22 emulation (such as SGMII-2500).
>>>>
>>>> The proposed solution comes in the form of a notifier chain owned by
>>>> the PHYLINK instance, and the passing of phylink_notifier_info
>>>> structures back to the driver through a blocking notifier call.
>>>>
>>>> The event API exposed by the new notifier mechanism is a 1:1 mapping
>>>> to the existing PHYLINK mac_ops, plus the PHYLINK fixed-link callback.
>>>>
>>>> Both the standard phylink_create() function, as well as its raw
>>>> variant, call the same underlying function which initializes either
>>>> the netdev field or the notifier block of the PHYLINK instance.
>>>>
>>>> All PHYLINK driver callbacks have been extended to call the notifier
>>>> chain in case the instance is a raw one.
>>>>
>>>> Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
>>>> Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
>>>> ---
>>>
>>> [snip]
>>>
>>>> +	struct phylink_notifier_info info = {
>>>> +		.link_an_mode = pl->link_an_mode,
>>>> +		/* Discard const pointer */
>>>> +		.state = (struct phylink_link_state *)state,
>>>> +	};
>>>> +
>>>>  	netdev_dbg(pl->netdev,
>>>>  		   "%s: mode=%s/%s/%s/%s adv=%*pb pause=%02x link=%u
>> an=%u\n",
>>>>  		   __func__, phylink_an_mode_str(pl->link_an_mode),
>>>> @@ -299,7 +317,12 @@ static void phylink_mac_config(struct phylink *pl,
>>>>  		   __ETHTOOL_LINK_MODE_MASK_NBITS, state->advertising,
>>>>  		   state->pause, state->link, state->an_enabled);
>>>
>>> Don't you need to guard that netdev_dbg() with an if (pl->ops) to
>>> avoid de-referencing a NULL net_device?
>>>
> 
> 
> The netdev_* print will not dereference a NULL net_device since it has explicit checks agains this.
> Instead it will just print (net/core/dev.c, __netdev_printk):
> 
> 	printk("%s(NULL net_device): %pV", level, vaf);
> 
> 
>>> Another possibility could be to change the signature of the
>>> phylink_mac_ops to take an opaque pointer and in the case where we
>>> called phylink_create() and passed down a net_device pointer, we
>>> somehow remember that for doing any operation that requires a
>>> net_device (printing, setting carrier). We lose strict typing in doing
>>> that, but we'd have fewer places to patch for a blocking notifier call.
>>>
>>
>> Or even make those functions part of phylink_mac_ops such that the caller
>> could pass an .carrier_ok callback which is netif_carrier_ok() for a net_device,
>> else it's NULL, same with printing functions if desired...
>> --
>> Florian
> 
> 
> Let me see if I understood this correctly. I presume that any API that we add should not break any current PHYLINK users.
> 
> You suggest to change the prototype of the phylink_mac_ops from
> 
> 	void (*validate)(struct net_device *ndev, unsigned long *supported,
> 			 struct phylink_link_state *state);
> 
> to something that takes a void pointer:
> 
> 	void (*validate)(void *dev, unsigned long *supported,
> 			 struct phylink_link_state *state);

That is what I am suggesting, but I am also suggesting passing all
netdev specific calls that must be made as callbacks as well, so
something like:

	bool (*carrier_ok)(const void *dev)
	void (*carrier_set)(const void *dev, bool on)
	void (*print)(const void *dev, const char *fmt)

as new members of phylink_mac_ops.

> 
> This would imply that the any function in PHYLINK would have to somehow differentiate if the dev provided is indeed a net_device or another structure in order to make the decision if netif_carrier_off should be called or not (this is so we do not break any drivers using PHYLINK). I cannot see how this judgement can be made.

You don't have to make the judgement you can just do:

if (pl->ops->carrier_set)
	pl->ops->carrier_set(dev,

where dev was this opaque pointer passed to phylink_create() the first
time it was created. Like I wrote, we lose strong typing doing that, but
we don't have to update all code paths for if (pl->ops) else notifier.
-- 
Florian
