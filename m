Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CFF622745C
	for <lists+netdev@lfdr.de>; Thu, 23 May 2019 04:29:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728761AbfEWC3M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 May 2019 22:29:12 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:35717 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728022AbfEWC3M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 May 2019 22:29:12 -0400
Received: by mail-pf1-f196.google.com with SMTP id d126so151022pfd.2
        for <netdev@vger.kernel.org>; Wed, 22 May 2019 19:29:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:openpgp:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Cly1plf9xhA+ZTMnASKax1m0Hs+ws3b5nd6+ZNFQ+2o=;
        b=diGa3O20WjrlWBODsD6y0uzmqawHfxr68TfzNMSMzZs2/7Iv7V0WuVloniEDyvDU2D
         M8Z/Peh5zVjaZ9rWC/okpAzQ53HMyfeAkWqzDga2Ibs4Shz+2mpRUXXuvL4v2MCpEogz
         MHnwQ38qBqpEp//JNUpZGNMO/Mw2BWt4ElAdpx8Dk5TEln6ltiUwPIMyNhGMLSpVVySz
         /P42q1QncbhlEvXNMkFWHGU8Vx3qpOccMczguWvMXYnZrcCplUcVzpkg+GPrd/6V5bHy
         PDpKOGlmf0u60EArOsO8jzrpRl4Rv2vIxjOB1XyuvKW+AFuvg+A3PhwXT5TGlNe9j5Ti
         uoww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Cly1plf9xhA+ZTMnASKax1m0Hs+ws3b5nd6+ZNFQ+2o=;
        b=Ql29ey1MwPjjcZqCEtX72IKLnpAAZH6Q72XcH/OAU6b/6IzgvHk/nfshOR8hlDceq/
         UdMqZUZs3uCSblnUP4nsnK1kGDJVWrnDmAtXOJFsPp48O0hMDFmUzQXi8QlUNsJ4DC7E
         0M6FXd0ndTRUG2JwM4rT6k7dr+BGewjIL1M0q/KNjGgtEaHTw4ajueTzCMgRZ7dPrqmh
         DKgdkbpyfKa0W3Ek7HUtADBPUwhKcmm0g6+jWNYFZnOw+BIbgAeYeoZct7EoSnE3a+i5
         LTMk0A6W2cX93YCG8gq2wCci87IfHlIavrt6vhvdccrWt9Bj/D144Ek42lyqMsAcLZ78
         ukkw==
X-Gm-Message-State: APjAAAXlEpy3x8TBERP9pl1vUfMFAw+rjynR1k27gloBTumZvZ/BXnNf
        5yK/AwJ/SWYNa9c8coodUftmAyJD
X-Google-Smtp-Source: APXvYqzqstrPiXS5BIiPqJA48ZYOz0t0qahs+p3pTgySlyhiCIfJWx8g1BVOuhE7JqeFUW3EbkvSuA==
X-Received: by 2002:a62:bd11:: with SMTP id a17mr16227298pff.126.1558578551236;
        Wed, 22 May 2019 19:29:11 -0700 (PDT)
Received: from [10.230.28.107] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id z125sm37750440pfb.75.2019.05.22.19.29.09
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 22 May 2019 19:29:10 -0700 (PDT)
Subject: Re: [RFC PATCH net-next 5/9] net: phylink: Add phylink_create_raw
From:   Florian Fainelli <f.fainelli@gmail.com>
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
Openpgp: preference=signencrypt
Message-ID: <0d29a5ee-8a68-d0be-c524-6e3ee1f46802@gmail.com>
Date:   Wed, 22 May 2019 19:29:07 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <c2712523-f1b9-47f8-672b-d35e62bf35ea@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/22/2019 7:25 PM, Florian Fainelli wrote:
> 
> 
> On 5/22/2019 6:20 PM, Ioana Ciornei wrote:
>> This adds a new entry point to PHYLINK that does not require a
>> net_device structure.
>>
>> The main intended use are DSA ports that do not have net devices
>> registered for them (mainly because doing so would be redundant - see
>> Documentation/networking/dsa/dsa.rst for details). So far DSA has been
>> using PHYLIB fixed PHYs for these ports, driven manually with genphy
>> instead of starting a full PHY state machine, but this does not scale
>> well when there are actual PHYs that need a driver on those ports, or
>> when a fixed-link is requested in DT that has a speed unsupported by the
>> fixed PHY C22 emulation (such as SGMII-2500).
>>
>> The proposed solution comes in the form of a notifier chain owned by the
>> PHYLINK instance, and the passing of phylink_notifier_info structures
>> back to the driver through a blocking notifier call.
>>
>> The event API exposed by the new notifier mechanism is a 1:1 mapping to
>> the existing PHYLINK mac_ops, plus the PHYLINK fixed-link callback.
>>
>> Both the standard phylink_create() function, as well as its raw variant,
>> call the same underlying function which initializes either the netdev
>> field or the notifier block of the PHYLINK instance.
>>
>> All PHYLINK driver callbacks have been extended to call the notifier
>> chain in case the instance is a raw one.
>>
>> Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
>> Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
>> ---
> 
> [snip]
> 
>> +	struct phylink_notifier_info info = {
>> +		.link_an_mode = pl->link_an_mode,
>> +		/* Discard const pointer */
>> +		.state = (struct phylink_link_state *)state,
>> +	};
>> +
>>  	netdev_dbg(pl->netdev,
>>  		   "%s: mode=%s/%s/%s/%s adv=%*pb pause=%02x link=%u an=%u\n",
>>  		   __func__, phylink_an_mode_str(pl->link_an_mode),
>> @@ -299,7 +317,12 @@ static void phylink_mac_config(struct phylink *pl,
>>  		   __ETHTOOL_LINK_MODE_MASK_NBITS, state->advertising,
>>  		   state->pause, state->link, state->an_enabled);
> 
> Don't you need to guard that netdev_dbg() with an if (pl->ops) to avoid
> de-referencing a NULL net_device?
> 
> Another possibility could be to change the signature of the
> phylink_mac_ops to take an opaque pointer and in the case where we
> called phylink_create() and passed down a net_device pointer, we somehow
> remember that for doing any operation that requires a net_device
> (printing, setting carrier). We lose strict typing in doing that, but
> we'd have fewer places to patch for a blocking notifier call.
> 

Or even make those functions part of phylink_mac_ops such that the
caller could pass an .carrier_ok callback which is netif_carrier_ok()
for a net_device, else it's NULL, same with printing functions if desired...
-- 
Florian
