Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E0E0614179
	for <lists+netdev@lfdr.de>; Sun,  5 May 2019 19:32:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727960AbfEERcH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 May 2019 13:32:07 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:37332 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727232AbfEERcH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 May 2019 13:32:07 -0400
Received: by mail-wr1-f65.google.com with SMTP id a12so4150910wrn.4
        for <netdev@vger.kernel.org>; Sun, 05 May 2019 10:32:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=uG6wrlem7NeBhXDv8nSDjYpmYlfJN4B5RS9hu20hJoo=;
        b=sfM0kAoqiHF7JZeiuAntPtw6GsEymo/rG0+wiAbqI9k9F3T6fCjoGg71Ua+whkURBP
         JrwpgIAg0uCOcTKxu14fCZsndgAhmJr4+MbwdSFbkYJLI7PIS7W0OuHOW8vvJAhYvTwe
         CQ2h9+YjNyCo/UUdzscsvja3oOkJsBK6oXGeDDOTEKdiyQtbwd3blRmCciVtTadbQe3b
         fWFCe66TQNXcSrBWeZoXR4e1gIWElRsXUqfieUuZzBlKgRlS3rBNGeP6hhy1XbXfPULI
         5vDuYBinLsKX5jGCJmawjT3UMmefoVIioZZJ7ozVAULl8zo0F2v8WM/9xpUrfym47ZSB
         ySjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=uG6wrlem7NeBhXDv8nSDjYpmYlfJN4B5RS9hu20hJoo=;
        b=cOcyx+bNwImIPSp1/P8C67XX25Rta+mOtluaEIEAyrTSJRBYpSdNTCtGR6WpRD5jm6
         B7agh83VrbCTIEg8AZ05wabTAtP68HesOhPi5dO9LFdz/JsJ+XI8hvB9Zo+3mi4xgLXh
         DMXeVFL/2ZB4kFPdeLTe3T4M+vul5ucECuEb9chRxGKGIvdEf2zELpp8iZftKuPufFTE
         /MwVMk6b36JSvSnMkfwQzqjjbmIQGkCrOOOlCG46tzizpIphza4sVv3d+D6n1yYcVr+P
         CthlOx0UUIM3+NO3tTFLl6inCN3U1Vl/pOQrMF5CFS6qJqHTQdadYCsfHjgZhfQsepEz
         8wZQ==
X-Gm-Message-State: APjAAAXeO1M76nGvlihWczlBxAnTNZv33KqT5c8jb6zBCHcKZjiGloxO
        Vz2nOZfVUCr1JkEBymIdUKKoqOHSXHw=
X-Google-Smtp-Source: APXvYqyoyGGhG0nGCF0si7sIDDImcUBSu7x9ND/A3witAiEYQ8MJ5K56lJagL+UPjlYJ1Pq5JtsxMA==
X-Received: by 2002:adf:f402:: with SMTP id g2mr2465342wro.117.1557077525104;
        Sun, 05 May 2019 10:32:05 -0700 (PDT)
Received: from ?IPv6:2003:ea:8bd4:5700:d9a7:917c:8564:c504? (p200300EA8BD45700D9A7917C8564C504.dip0.t-ipconnect.de. [2003:ea:8bd4:5700:d9a7:917c:8564:c504])
        by smtp.googlemail.com with ESMTPSA id t81sm11439011wmb.47.2019.05.05.10.32.03
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 05 May 2019 10:32:04 -0700 (PDT)
Subject: Re: [PATCH net-next] net: phy: improve pause mode reporting in
 phy_print_status
To:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <1ea97344-6971-44dd-2191-9a8db0d2c10d@gmail.com>
 <65df73ce-9213-2b6a-6894-f68bf54a5f3d@gmail.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <5cc8f009-c558-05ff-1739-4e4fd8c68bf2@gmail.com>
Date:   Sun, 5 May 2019 19:31:59 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <65df73ce-9213-2b6a-6894-f68bf54a5f3d@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 05.05.2019 19:10, Florian Fainelli wrote:
> 
> 
> On 5/5/2019 10:03 AM, Heiner Kallweit wrote:
>> So far we report symmetric pause only, and we don't consider the local
>> pause capabilities. Let's properly consider local and remote
>> capabilities, and report also asymmetric pause.
> 
> I would go one step further which is to print what is the link state of
> RX/TX pause, so something like:
> 
> - local RX/TX pause advertisement
> - link partnr RX/TX pause advertisement
> - RX/TX being enabled for the link (auto-negotiated or manual)
> 
> this sort of duplicates what ethtool offers already but arguably so does
> printing the link state so this would not be that big of a stretch.
> 
> I would make the print be something like:
> 
> Link is Up - 1Gb/Full - local pause: rx/tx, lpa pause: rx/tx, link
> pause: auto-negotiated
> Link is Up - 1Gb/Full - local pause: rx/tx, lpa pause: rx/tx, link
> pause: forced off
> Link is Up - 1Gb/Full - local pause: rx/tx, lpa pause: rx/tx, link
> pause: forced on
> 
For speed and duplex we don't print the capabilities of both sides
but the negotiation result. Therefore I think it's more plausible
to do the same for pause.
IMO the intention of phy_print_status() is to print what is
effectively used. If a user is interested in the detailed capabilities
of both sides he can use ethtool, as mentioned by you.

In fixed mode we currently report pause "off" always.

Maybe, before we go further, one question for my understanding:
If the link partner doesn't support pause, who tells the MAC how that
it must not send pause frames? Is the network driver supposed to
do this in the adjust_link callback?

In the Realtek network chip datasheet I found a vague comment that
the MAC checks the aneg result of the internal PHY to decide
whether send pause frames or not.

> 
> Thanks!
> 
>>
>> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
>> ---
>>  drivers/net/phy/phy.c | 28 +++++++++++++++++++++++++++-
>>  1 file changed, 27 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/net/phy/phy.c b/drivers/net/phy/phy.c
>> index 1a146c5c5..e88854292 100644
>> --- a/drivers/net/phy/phy.c
>> +++ b/drivers/net/phy/phy.c
>> @@ -60,6 +60,32 @@ static void phy_link_down(struct phy_device *phydev, bool do_carrier)
>>  	phy_led_trigger_change_speed(phydev);
>>  }
>>  
>> +static const char *phy_pause_str(struct phy_device *phydev)
>> +{
>> +	bool local_pause, local_asym_pause;
>> +
>> +	if (phydev->autoneg == AUTONEG_DISABLE)
>> +		goto no_pause;
>> +
>> +	local_pause = linkmode_test_bit(ETHTOOL_LINK_MODE_Pause_BIT,
>> +					phydev->advertising);
>> +	local_asym_pause = linkmode_test_bit(ETHTOOL_LINK_MODE_Asym_Pause_BIT,
>> +					     phydev->advertising);
>> +
>> +	if (local_pause && phydev->pause)
>> +		return "rx/tx";
>> +
>> +	if (local_asym_pause && phydev->asym_pause) {
>> +		if (local_pause)
>> +			return "rx";
>> +		if (phydev->pause)
>> +			return "tx";
>> +	}
>> +
>> +no_pause:
>> +	return "off";
>> +}
>> +
>>  /**
>>   * phy_print_status - Convenience function to print out the current phy status
>>   * @phydev: the phy_device struct
>> @@ -71,7 +97,7 @@ void phy_print_status(struct phy_device *phydev)
>>  			"Link is Up - %s/%s - flow control %s\n",
>>  			phy_speed_to_str(phydev->speed),
>>  			phy_duplex_to_str(phydev->duplex),
>> -			phydev->pause ? "rx/tx" : "off");
>> +			phy_pause_str(phydev));
>>  	} else	{
>>  		netdev_info(phydev->attached_dev, "Link is Down\n");
>>  	}
>>
> 

