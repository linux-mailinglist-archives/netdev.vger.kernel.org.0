Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 38E1F14204
	for <lists+netdev@lfdr.de>; Sun,  5 May 2019 21:06:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727539AbfEETG5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 May 2019 15:06:57 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:55432 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726636AbfEETG4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 May 2019 15:06:56 -0400
Received: by mail-wm1-f66.google.com with SMTP id y2so12820378wmi.5
        for <netdev@vger.kernel.org>; Sun, 05 May 2019 12:06:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=JP1Kw0aqb3FXJv1c8G3OLINVl9kkNBHcMGH3wLlLefc=;
        b=fJhK83KOwE/2ShmwhRwNFbJRfq82yDC48hz6DsgVmpbdDo/OzuS2/6gjeMyo9Faivt
         rhvgXjr7dtuPcnfb3puGJoBHoA9DzcU5hWbr7FYiS6Ae/4q3gJ1/Dh/y8C0QFdTcvvTr
         6E71E8xZJprAgoPBKn2JN3PNee5GRFe8rzjRijMnblo3MDFq8SWa2ulD5y99XEqr78dq
         JNX95vsZAEQUibc7JN1Oqp1Iy75wNQIUv+l6RZwjZXx4QMWTkTjpSAuNFcj1kn12Ow8z
         IfEtVciUJ61P/CZHUYthHBbzE7pc47KeUGXfYhixFDFQ9AUwj1B5vwUE+65dkDFSGqco
         SaNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=JP1Kw0aqb3FXJv1c8G3OLINVl9kkNBHcMGH3wLlLefc=;
        b=iOP5adqMSAADsiON0yGitqoVlogKMXZElhmCE8bxWUi5AWDBGJu71sUvnf9EAFEd0O
         0l/skdNNFdS7VvvpcRSWo+ittIYGLcSI+bJVRooypia3QJcdTMvgjeF5LUmvNM83/s7H
         DEwBuo4E32u7MbfskUF+g/4UA9mOkFzcnIX00M2BXznFEqKUHNf6+aw4sSSNo/lW5sGZ
         FgYvzXToDHRTqJYp/BjXlcGAt7Wnp979jmO/2pp9Z8inNV+0ZepgbDE/0TLKdvu+RZJl
         es8wiNq6t4wyU74VMynDt6Suwd7whjXxWYOzaq+WwYm7axRQru07upABIOWavVrLlgzw
         Pv/g==
X-Gm-Message-State: APjAAAVxCSp1CUQCAsE37vKoXS7Qc9N55V31RcOiesSN6DYNdwPP9T0Z
        GXafD9D1C02T1AE5d8MNPzMS33YpT+E=
X-Google-Smtp-Source: APXvYqz5SEylIZJ82rtjFU5BFPhypfB8a8zO01FzfhV5IJjsRaKhg263U1hcrIXMa1qwyZMVNjn3gg==
X-Received: by 2002:a1c:f205:: with SMTP id s5mr13243718wmc.131.1557083214022;
        Sun, 05 May 2019 12:06:54 -0700 (PDT)
Received: from ?IPv6:2003:ea:8bd4:5700:d9a7:917c:8564:c504? (p200300EA8BD45700D9A7917C8564C504.dip0.t-ipconnect.de. [2003:ea:8bd4:5700:d9a7:917c:8564:c504])
        by smtp.googlemail.com with ESMTPSA id t81sm11932093wmb.47.2019.05.05.12.06.53
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 05 May 2019 12:06:53 -0700 (PDT)
Subject: Re: [PATCH net-next] net: phy: improve pause mode reporting in
 phy_print_status
To:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <1ea97344-6971-44dd-2191-9a8db0d2c10d@gmail.com>
 <65df73ce-9213-2b6a-6894-f68bf54a5f3d@gmail.com>
 <5cc8f009-c558-05ff-1739-4e4fd8c68bf2@gmail.com>
 <87b70c57-2d95-8e23-674d-71541122b1b4@gmail.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <1278310b-5457-e8eb-851e-1796d2616f8d@gmail.com>
Date:   Sun, 5 May 2019 21:06:47 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <87b70c57-2d95-8e23-674d-71541122b1b4@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 05.05.2019 20:46, Florian Fainelli wrote:
> 
> 
> On 5/5/2019 10:31 AM, Heiner Kallweit wrote:
>> On 05.05.2019 19:10, Florian Fainelli wrote:
>>>
>>>
>>> On 5/5/2019 10:03 AM, Heiner Kallweit wrote:
>>>> So far we report symmetric pause only, and we don't consider the local
>>>> pause capabilities. Let's properly consider local and remote
>>>> capabilities, and report also asymmetric pause.
>>>
>>> I would go one step further which is to print what is the link state of
>>> RX/TX pause, so something like:
>>>
>>> - local RX/TX pause advertisement
>>> - link partnr RX/TX pause advertisement
>>> - RX/TX being enabled for the link (auto-negotiated or manual)
>>>
>>> this sort of duplicates what ethtool offers already but arguably so does
>>> printing the link state so this would not be that big of a stretch.
>>>
>>> I would make the print be something like:
>>>
>>> Link is Up - 1Gb/Full - local pause: rx/tx, lpa pause: rx/tx, link
>>> pause: auto-negotiated
>>> Link is Up - 1Gb/Full - local pause: rx/tx, lpa pause: rx/tx, link
>>> pause: forced off
>>> Link is Up - 1Gb/Full - local pause: rx/tx, lpa pause: rx/tx, link
>>> pause: forced on
>>>
>> For speed and duplex we don't print the capabilities of both sides
>> but the negotiation result. Therefore I think it's more plausible
>> to do the same for pause.
> 
> Pause is different though, if the link speed does not match, there is no
> link, if the duplex do not match you may establish a link but there will
> be a duplex mismatch which will cause all sorts of issues. Pause is not
> an essential link parameter and is more of an optimization.
> 
Right, still I think this is too much and only partially relevant
information for the user. And if e.g. the remote side doesn't support
pause, then it's irrelevant what we support. I think the user is
(if at all) interested in the information which pause mode is effectively
used.

>> IMO the intention of phy_print_status() is to print what is
>> effectively used. If a user is interested in the detailed capabilities
>> of both sides he can use ethtool, as mentioned by you.
>>
>> In fixed mode we currently report pause "off" always.
>>
>> Maybe, before we go further, one question for my understanding:
>> If the link partner doesn't support pause, who tells the MAC how that
>> it must not send pause frames? Is the network driver supposed to
>> do this in the adjust_link callback?
> 
> If the link partner does not support pause, they are not advertised by
> the link partner and you can read that from the LPA and the resolution
> of the local pause and link partner pause settings should come back as
> "not possible" (there may be caveats with symmetric vs. asymmetric pause
> support).
> 
> PHYLINK is a good example of how pause should be reported towards the MAC.
> 
Thanks. So I think the usual MAC driver would have to check pause support
in the handler passed as argument to phy_connect_direct().

>>
>> In the Realtek network chip datasheet I found a vague comment that
>> the MAC checks the aneg result of the internal PHY to decide
>> whether send pause frames or not.
> 
> That would mean that the MAC behaves in a mode where it defaults to
> pause frame being auto-negotiated, which is something that some Ethernet
> MAC drivers default to as well. As long as you can disable pause when
> the user requests it, that should be fine.
> 
At least for the Realtek chips there is no documented way to disable pause.
If the remote side doesn't support pause, what happens if a pause frame is
sent? Is it just ignored or can we expect some sort of issue?

>>
>>>
>>> Thanks!
>>>
>>>>
>>>> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
>>>> ---
>>>>  drivers/net/phy/phy.c | 28 +++++++++++++++++++++++++++-
>>>>  1 file changed, 27 insertions(+), 1 deletion(-)
>>>>
>>>> diff --git a/drivers/net/phy/phy.c b/drivers/net/phy/phy.c
>>>> index 1a146c5c5..e88854292 100644
>>>> --- a/drivers/net/phy/phy.c
>>>> +++ b/drivers/net/phy/phy.c
>>>> @@ -60,6 +60,32 @@ static void phy_link_down(struct phy_device *phydev, bool do_carrier)
>>>>  	phy_led_trigger_change_speed(phydev);
>>>>  }
>>>>  
>>>> +static const char *phy_pause_str(struct phy_device *phydev)
>>>> +{
>>>> +	bool local_pause, local_asym_pause;
>>>> +
>>>> +	if (phydev->autoneg == AUTONEG_DISABLE)
>>>> +		goto no_pause;
>>>> +
>>>> +	local_pause = linkmode_test_bit(ETHTOOL_LINK_MODE_Pause_BIT,
>>>> +					phydev->advertising);
>>>> +	local_asym_pause = linkmode_test_bit(ETHTOOL_LINK_MODE_Asym_Pause_BIT,
>>>> +					     phydev->advertising);
>>>> +
>>>> +	if (local_pause && phydev->pause)
>>>> +		return "rx/tx";
>>>> +
>>>> +	if (local_asym_pause && phydev->asym_pause) {
>>>> +		if (local_pause)
>>>> +			return "rx";
>>>> +		if (phydev->pause)
>>>> +			return "tx";
>>>> +	}
>>>> +
>>>> +no_pause:
>>>> +	return "off";
>>>> +}
>>>> +
>>>>  /**
>>>>   * phy_print_status - Convenience function to print out the current phy status
>>>>   * @phydev: the phy_device struct
>>>> @@ -71,7 +97,7 @@ void phy_print_status(struct phy_device *phydev)
>>>>  			"Link is Up - %s/%s - flow control %s\n",
>>>>  			phy_speed_to_str(phydev->speed),
>>>>  			phy_duplex_to_str(phydev->duplex),
>>>> -			phydev->pause ? "rx/tx" : "off");
>>>> +			phy_pause_str(phydev));
>>>>  	} else	{
>>>>  		netdev_info(phydev->attached_dev, "Link is Down\n");
>>>>  	}
>>>>
>>>
>>
> 

