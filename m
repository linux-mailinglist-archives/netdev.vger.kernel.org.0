Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D3F2E141F5
	for <lists+netdev@lfdr.de>; Sun,  5 May 2019 20:46:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727472AbfEESqk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 May 2019 14:46:40 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:35153 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727232AbfEESqk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 May 2019 14:46:40 -0400
Received: by mail-pl1-f196.google.com with SMTP id w24so5218368plp.2
        for <netdev@vger.kernel.org>; Sun, 05 May 2019 11:46:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:openpgp:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=9GV9zzfJCSjvz/YdnGapoY5GfecRdVdZnSEeufqb5ss=;
        b=EIkmzvS+tI+G8Gvub2ThtmwNaZ2w3cRvobqFtI+QQAlgR53JRyiSUqMrTrgKJsq86T
         dFdUaltJidljp2HIEDp+VZokk1/oN83CI4zpriXZaXQCOFCJIE4Edm73xWYNNPknG9+q
         dllOiZJCyzULSkRCjFKQGehOKk1F2wlJnTvPUDSK8LN+IUXRCP9mWSGjRcvameWD5f1O
         hdKlX4d5aZ6AaDybWRucR7h5ezCBjscqqi1n/qZl0bqCM1S/dYk/NjBq9F09kfXuX8Go
         wRd6cExHkb/kV1vPh0F7cF0xnGrGOc2L8CX1ieVT2nfF6E2VJwRH4WEGkp82ZXHSeyv+
         nhfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=9GV9zzfJCSjvz/YdnGapoY5GfecRdVdZnSEeufqb5ss=;
        b=ZUNIAku81vvgj8LGISDYvHrx/lGOU57Nix4bxLPRFCg+ZiozKJEw3icT2LR9WFKAiv
         n2cM1Rk100ayC8RPLCC4Dnchp8HpTVwXoMm7JQwhRwvydrTGyRL576b+5gUWfN/QgNNf
         WVf7BtFRVqrIZhGkcpuRYFmRTihx0Jw54xCDkDedl7uvTXnvjqRXQSVqAknRZEO4NEgf
         uuHtE5wf7IzzdwZQgKQMv1yRw5ZVKirbUU86l1oaNHsiBrmz8I0ARxOFQsBTBWC8ZIch
         8PQTED4t82ClprlFbTuGtzvysAaXL5/CXOf6BDnBGzp79XRwNIauwJawZhC0m331O9yA
         Ayhw==
X-Gm-Message-State: APjAAAU+6VSl3e2p0FTV0giw/hCFpcTanR+Jak3gRntBDA1QYnlzUUkl
        /ZntBMkB/Ij0Un39SxSrjnxET+9x
X-Google-Smtp-Source: APXvYqx66AP2Ajtu1JBdxT+SFoFr/SYwzcIdjLFbnguU+fHS8/Zh2sUrmOqWEbRx7ALzUwWwnd6WFw==
X-Received: by 2002:a17:902:8f88:: with SMTP id z8mr26046937plo.54.1557081999039;
        Sun, 05 May 2019 11:46:39 -0700 (PDT)
Received: from [10.230.28.107] ([192.19.223.250])
        by smtp.gmail.com with ESMTPSA id s19sm9832033pgj.62.2019.05.05.11.46.35
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 05 May 2019 11:46:37 -0700 (PDT)
Subject: Re: [PATCH net-next] net: phy: improve pause mode reporting in
 phy_print_status
To:     Heiner Kallweit <hkallweit1@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <1ea97344-6971-44dd-2191-9a8db0d2c10d@gmail.com>
 <65df73ce-9213-2b6a-6894-f68bf54a5f3d@gmail.com>
 <5cc8f009-c558-05ff-1739-4e4fd8c68bf2@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Openpgp: preference=signencrypt
Message-ID: <87b70c57-2d95-8e23-674d-71541122b1b4@gmail.com>
Date:   Sun, 5 May 2019 11:46:32 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <5cc8f009-c558-05ff-1739-4e4fd8c68bf2@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/5/2019 10:31 AM, Heiner Kallweit wrote:
> On 05.05.2019 19:10, Florian Fainelli wrote:
>>
>>
>> On 5/5/2019 10:03 AM, Heiner Kallweit wrote:
>>> So far we report symmetric pause only, and we don't consider the local
>>> pause capabilities. Let's properly consider local and remote
>>> capabilities, and report also asymmetric pause.
>>
>> I would go one step further which is to print what is the link state of
>> RX/TX pause, so something like:
>>
>> - local RX/TX pause advertisement
>> - link partnr RX/TX pause advertisement
>> - RX/TX being enabled for the link (auto-negotiated or manual)
>>
>> this sort of duplicates what ethtool offers already but arguably so does
>> printing the link state so this would not be that big of a stretch.
>>
>> I would make the print be something like:
>>
>> Link is Up - 1Gb/Full - local pause: rx/tx, lpa pause: rx/tx, link
>> pause: auto-negotiated
>> Link is Up - 1Gb/Full - local pause: rx/tx, lpa pause: rx/tx, link
>> pause: forced off
>> Link is Up - 1Gb/Full - local pause: rx/tx, lpa pause: rx/tx, link
>> pause: forced on
>>
> For speed and duplex we don't print the capabilities of both sides
> but the negotiation result. Therefore I think it's more plausible
> to do the same for pause.

Pause is different though, if the link speed does not match, there is no
link, if the duplex do not match you may establish a link but there will
be a duplex mismatch which will cause all sorts of issues. Pause is not
an essential link parameter and is more of an optimization.

> IMO the intention of phy_print_status() is to print what is
> effectively used. If a user is interested in the detailed capabilities
> of both sides he can use ethtool, as mentioned by you.
> 
> In fixed mode we currently report pause "off" always.
> 
> Maybe, before we go further, one question for my understanding:
> If the link partner doesn't support pause, who tells the MAC how that
> it must not send pause frames? Is the network driver supposed to
> do this in the adjust_link callback?

If the link partner does not support pause, they are not advertised by
the link partner and you can read that from the LPA and the resolution
of the local pause and link partner pause settings should come back as
"not possible" (there may be caveats with symmetric vs. asymmetric pause
support).

PHYLINK is a good example of how pause should be reported towards the MAC.

> 
> In the Realtek network chip datasheet I found a vague comment that
> the MAC checks the aneg result of the internal PHY to decide
> whether send pause frames or not.

That would mean that the MAC behaves in a mode where it defaults to
pause frame being auto-negotiated, which is something that some Ethernet
MAC drivers default to as well. As long as you can disable pause when
the user requests it, that should be fine.

> 
>>
>> Thanks!
>>
>>>
>>> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
>>> ---
>>>  drivers/net/phy/phy.c | 28 +++++++++++++++++++++++++++-
>>>  1 file changed, 27 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/drivers/net/phy/phy.c b/drivers/net/phy/phy.c
>>> index 1a146c5c5..e88854292 100644
>>> --- a/drivers/net/phy/phy.c
>>> +++ b/drivers/net/phy/phy.c
>>> @@ -60,6 +60,32 @@ static void phy_link_down(struct phy_device *phydev, bool do_carrier)
>>>  	phy_led_trigger_change_speed(phydev);
>>>  }
>>>  
>>> +static const char *phy_pause_str(struct phy_device *phydev)
>>> +{
>>> +	bool local_pause, local_asym_pause;
>>> +
>>> +	if (phydev->autoneg == AUTONEG_DISABLE)
>>> +		goto no_pause;
>>> +
>>> +	local_pause = linkmode_test_bit(ETHTOOL_LINK_MODE_Pause_BIT,
>>> +					phydev->advertising);
>>> +	local_asym_pause = linkmode_test_bit(ETHTOOL_LINK_MODE_Asym_Pause_BIT,
>>> +					     phydev->advertising);
>>> +
>>> +	if (local_pause && phydev->pause)
>>> +		return "rx/tx";
>>> +
>>> +	if (local_asym_pause && phydev->asym_pause) {
>>> +		if (local_pause)
>>> +			return "rx";
>>> +		if (phydev->pause)
>>> +			return "tx";
>>> +	}
>>> +
>>> +no_pause:
>>> +	return "off";
>>> +}
>>> +
>>>  /**
>>>   * phy_print_status - Convenience function to print out the current phy status
>>>   * @phydev: the phy_device struct
>>> @@ -71,7 +97,7 @@ void phy_print_status(struct phy_device *phydev)
>>>  			"Link is Up - %s/%s - flow control %s\n",
>>>  			phy_speed_to_str(phydev->speed),
>>>  			phy_duplex_to_str(phydev->duplex),
>>> -			phydev->pause ? "rx/tx" : "off");
>>> +			phy_pause_str(phydev));
>>>  	} else	{
>>>  		netdev_info(phydev->attached_dev, "Link is Down\n");
>>>  	}
>>>
>>
> 

-- 
Florian
