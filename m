Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EF27F28B8D
	for <lists+netdev@lfdr.de>; Thu, 23 May 2019 22:32:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388085AbfEWUcN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 May 2019 16:32:13 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:37076 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387544AbfEWUcL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 May 2019 16:32:11 -0400
Received: by mail-wr1-f68.google.com with SMTP id e15so7682616wrs.4
        for <netdev@vger.kernel.org>; Thu, 23 May 2019 13:32:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=EF8YDTkYet94xXU+H81i1hIfZ9b+Pmstsq6xQ/yzSmk=;
        b=ojrnkmSZwCVGxyySLj9vfNtQJ4yH+BDq8e3UvGKkFchXb4Sae4jLAjSQOiep4fom30
         oU+/g7Vw7iw3v6DM2K0fO9b4w6Ph6A4NRqs15zy9kvQSlaJPN7jezCzTOx8esLolby7d
         UVLrRyHvlt8v+rvw5F3xQ0pdu9NwUns8spy7Lr4MeW4capdgzUzVCcHm0dDoTxiydEpK
         t2S32YKqjF9RW2RWPivhdstlRaKGbOCtl0IvXKRc1caHipWmM+dhVHwKN/7E7BcZW/Q5
         g+L0vzVXe6iJDlq4aC7O71CvCrWrLz3z9rd1QB9BILfEomj0IqMdjhBmd+9XGcnmyR0v
         0XPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=EF8YDTkYet94xXU+H81i1hIfZ9b+Pmstsq6xQ/yzSmk=;
        b=PC6Cwrp/8XbQQuC+3qySZ+bO4fxIFdATO36ttIiuMGfb/NCHpyBGGT0uBoppK6LVH1
         dq9ke+04jdVHfuTmhUgm+7d6529EDZXdREvRiOU1kTnDW6Ae9yjELGlOQDl31Jx+/jfX
         tmd6Xygd0gWZYdMHJbLVHsVjlI83KPhHJOuq7292SjmXWmSSzHdnnyVimu0dcSUGps4t
         egvN40nF3w6J8hLy8+qwG7z0Jt9T9kYwtWmKOrOqAIcfYlYwrWcRRsXv9X3MYGoziaim
         WDhWGOz57vILpLhhaelLJsdHS3MPS7mKL0H9hB/597zy+PlLquXg734m4ZPhakM9dPCm
         QvBQ==
X-Gm-Message-State: APjAAAWaI2UfpMrPBSx2++UZLrJKJ3KXB1ma9nLPj2/RZswANQwvRWv+
        qav+ENLRAV0tqG0w6PdHw3dSkERjIPw=
X-Google-Smtp-Source: APXvYqyZD+d9K2w4kyKNOBDOdYoVW8yh2yNPYr22TgBxPJQElgzPxNKjnQo0O/tWGkLFmQGlrmJS9w==
X-Received: by 2002:adf:dd0d:: with SMTP id a13mr682374wrm.153.1558643529265;
        Thu, 23 May 2019 13:32:09 -0700 (PDT)
Received: from [192.168.1.2] (5-12-225-227.residential.rdsnet.ro. [5.12.225.227])
        by smtp.gmail.com with ESMTPSA id s20sm627238wrg.8.2019.05.23.13.32.08
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 23 May 2019 13:32:08 -0700 (PDT)
Subject: Re: [RFC PATCH net-next 5/9] net: phylink: Add phylink_create_raw
To:     Florian Fainelli <f.fainelli@gmail.com>,
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
From:   Vladimir Oltean <olteanv@gmail.com>
Message-ID: <50aa7d8d-c03d-2209-93bf-f73784bf1970@gmail.com>
Date:   Thu, 23 May 2019 23:32:07 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <716d26d0-e997-177f-ca35-d39cbd1f67ce@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/23/19 5:32 PM, Florian Fainelli wrote:
> 
> On 5/23/2019 5:10 AM, Ioana Ciornei wrote:
>>
>>> Subject: Re: [RFC PATCH net-next 5/9] net: phylink: Add phylink_create_raw
>>>
>>>
>>>
>>> On 5/22/2019 7:25 PM, Florian Fainelli wrote:
>>>>
>>>>
>>>> On 5/22/2019 6:20 PM, Ioana Ciornei wrote:
>>>>> This adds a new entry point to PHYLINK that does not require a
>>>>> net_device structure.
>>>>>
>>>>> The main intended use are DSA ports that do not have net devices
>>>>> registered for them (mainly because doing so would be redundant - see
>>>>> Documentation/networking/dsa/dsa.rst for details). So far DSA has
>>>>> been using PHYLIB fixed PHYs for these ports, driven manually with
>>>>> genphy instead of starting a full PHY state machine, but this does
>>>>> not scale well when there are actual PHYs that need a driver on those
>>>>> ports, or when a fixed-link is requested in DT that has a speed
>>>>> unsupported by the fixed PHY C22 emulation (such as SGMII-2500).
>>>>>
>>>>> The proposed solution comes in the form of a notifier chain owned by
>>>>> the PHYLINK instance, and the passing of phylink_notifier_info
>>>>> structures back to the driver through a blocking notifier call.
>>>>>
>>>>> The event API exposed by the new notifier mechanism is a 1:1 mapping
>>>>> to the existing PHYLINK mac_ops, plus the PHYLINK fixed-link callback.
>>>>>
>>>>> Both the standard phylink_create() function, as well as its raw
>>>>> variant, call the same underlying function which initializes either
>>>>> the netdev field or the notifier block of the PHYLINK instance.
>>>>>
>>>>> All PHYLINK driver callbacks have been extended to call the notifier
>>>>> chain in case the instance is a raw one.
>>>>>
>>>>> Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
>>>>> Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
>>>>> ---
>>>>
>>>> [snip]
>>>>
>>>>> +	struct phylink_notifier_info info = {
>>>>> +		.link_an_mode = pl->link_an_mode,
>>>>> +		/* Discard const pointer */
>>>>> +		.state = (struct phylink_link_state *)state,
>>>>> +	};
>>>>> +
>>>>>   	netdev_dbg(pl->netdev,
>>>>>   		   "%s: mode=%s/%s/%s/%s adv=%*pb pause=%02x link=%u
>>> an=%u\n",
>>>>>   		   __func__, phylink_an_mode_str(pl->link_an_mode),
>>>>> @@ -299,7 +317,12 @@ static void phylink_mac_config(struct phylink *pl,
>>>>>   		   __ETHTOOL_LINK_MODE_MASK_NBITS, state->advertising,
>>>>>   		   state->pause, state->link, state->an_enabled);
>>>>
>>>> Don't you need to guard that netdev_dbg() with an if (pl->ops) to
>>>> avoid de-referencing a NULL net_device?
>>>>
>>
>>
>> The netdev_* print will not dereference a NULL net_device since it has explicit checks agains this.
>> Instead it will just print (net/core/dev.c, __netdev_printk):
>>
>> 	printk("%s(NULL net_device): %pV", level, vaf);
>>
>>
>>>> Another possibility could be to change the signature of the
>>>> phylink_mac_ops to take an opaque pointer and in the case where we
>>>> called phylink_create() and passed down a net_device pointer, we
>>>> somehow remember that for doing any operation that requires a
>>>> net_device (printing, setting carrier). We lose strict typing in doing
>>>> that, but we'd have fewer places to patch for a blocking notifier call.
>>>>
>>>
>>> Or even make those functions part of phylink_mac_ops such that the caller
>>> could pass an .carrier_ok callback which is netif_carrier_ok() for a net_device,
>>> else it's NULL, same with printing functions if desired...
>>> --
>>> Florian
>>
>>
>> Let me see if I understood this correctly. I presume that any API that we add should not break any current PHYLINK users.
>>
>> You suggest to change the prototype of the phylink_mac_ops from
>>
>> 	void (*validate)(struct net_device *ndev, unsigned long *supported,
>> 			 struct phylink_link_state *state);
>>
>> to something that takes a void pointer:
>>
>> 	void (*validate)(void *dev, unsigned long *supported,
>> 			 struct phylink_link_state *state);
> 
> That is what I am suggesting, but I am also suggesting passing all
> netdev specific calls that must be made as callbacks as well, so
> something like:
> 
> 	bool (*carrier_ok)(const void *dev)
> 	void (*carrier_set)(const void *dev, bool on)
> 	void (*print)(const void *dev, const char *fmt)
> 
> as new members of phylink_mac_ops.
> 
>>
>> This would imply that the any function in PHYLINK would have to somehow differentiate if the dev provided is indeed a net_device or another structure in order to make the decision if netif_carrier_off should be called or not (this is so we do not break any drivers using PHYLINK). I cannot see how this judgement can be made.
> 
> You don't have to make the judgement you can just do:
> 
> if (pl->ops->carrier_set)
> 	pl->ops->carrier_set(dev,
> 
> where dev was this opaque pointer passed to phylink_create() the first
> time it was created. Like I wrote, we lose strong typing doing that, but
> we don't have to update all code paths for if (pl->ops) else notifier.
> 

Hi Florian,

Have you thought this through?
What about the totally random stuff, such as this portion from 2/9:

> @@ -1187,8 +1190,10 @@ int phy_attach_direct(struct net_device *dev, struct phy_device *phydev,
>  	 * our own module->refcnt here, otherwise we would not be able to
>  	 * unload later on.
>  	 */
> +	if (dev)
> +		ndev_owner = dev->dev.parent->driver->owner;
>  	if (ndev_owner != bus->owner && !try_module_get(bus->owner)) {
> -		dev_err(&dev->dev, "failed to get the bus module\n");
> +		phydev_err(phydev, "failed to get the bus module\n");
>  		return -EIO;
>  	}

Which is in PHYLIB by the way.
Do you just add a pl->ops->owns_mdio_bus() callback? What if that code 
goes away in the future? Do you remove it? This is code that all users 
of phylink_create_raw will have to implement.

IMO the whole point is to change as little as possible from PHYLINK's 
surface, and nothing from PHYLIB's. What you're suggesting is to change 
everything, *including* phylib. And PHYLINK's print callback can't be 
used in PHYLIB unless struct phylink is made public.

And if you want to replace "struct net_device *ndev" with "const void 
*dev", how will you even assign the phydev->attached_dev->phydev 
backlink? Another callback?

As for carrier state - realistically I don't see how any raw PHYLINK 
user would implement it any other way except keep a variable for it. 
Hence just let PHYLINK do it once.

I fail to see how this is cleaner.

-Vladimir
