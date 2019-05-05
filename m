Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0F8B514150
	for <lists+netdev@lfdr.de>; Sun,  5 May 2019 19:10:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727539AbfEERKm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 May 2019 13:10:42 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:45183 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726905AbfEERKl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 May 2019 13:10:41 -0400
Received: by mail-pg1-f196.google.com with SMTP id i21so5230645pgi.12
        for <netdev@vger.kernel.org>; Sun, 05 May 2019 10:10:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:openpgp:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ztkJTcuTXQOCyi8mht8yVX2MhiBPwV8g7HjSpcnnDuw=;
        b=Di3lwhEl69DdmmlsrYFOFDZBd72ps16woxxfmHr+N2Lr8kW+FobWt51GnGkU2NwURe
         TpDQ45lReEczyHKVmek0SsqPhAFPvZ4gPJRApZ9M1wE/SbGFvFeyuvimetijGu/lcE7b
         O4ayjxDm5oWH5r+2tIWc9hUm17piCyiDgldlsJQs5Oqf4Wvjb5uxIy8G9/V/kJqWN1Sg
         jgmQDispU7uuRL3u2blg5BwNSO3MF82cyYp8vLUNcHl1N4AMv2xZF5gGIhm3itduJBpJ
         TaTBP02fkUywApQLjou0Q8LGKJTaWaGV4Frn/YkIMtvA9MXZ29jDaRHmjlIFSSfSFoPC
         0PKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ztkJTcuTXQOCyi8mht8yVX2MhiBPwV8g7HjSpcnnDuw=;
        b=ioZ/b5Ip4ogbR3qYBEZPMxkIknLd7+r1S1j2vwRGpW2h6Ad2MTSbsejTxk2iAZMZuz
         prcqvDg0NCTXMjozOFZNFJbiJ2A0CzB5clANiOLIZWDWQ9PSRb43RYlEc73FS5+BWA8k
         TGsZyMS9W3IQhPewgxaofRLud/gQWk4fDHsMWrW+uFg7VAvYNQOZ6hntATv8xxy6YMmz
         aSIZGJ/sKTobv0DMgu0MGvd1iWopTa9xgQwwBgwqI08tmBTLveDu26h/up8XO1qV1vdx
         dCfLWT9DBauQfoNW6JMuFwB/j35wa6Dz4mhQ0HoIim9HxVvlX5VzDQW2/cXSnMtAM1ey
         j3yw==
X-Gm-Message-State: APjAAAU4OcR3ihJJOr+IkcLZPRmTsHai7O9eMtdCMeXHAwE+a3CZvYbA
        13rBp0c6foLuwqMMQgYoGQ0QBozI
X-Google-Smtp-Source: APXvYqwGPsFumArBvoK2G6rUKBPTlEUlpp436M/lU4GmwCtSFzk4SB5RysFx55KTuWAuhgfHYDrRXg==
X-Received: by 2002:a63:f806:: with SMTP id n6mr1145570pgh.242.1557076240621;
        Sun, 05 May 2019 10:10:40 -0700 (PDT)
Received: from [192.168.1.3] (ip68-101-123-102.oc.oc.cox.net. [68.101.123.102])
        by smtp.gmail.com with ESMTPSA id y8sm11212106pgk.20.2019.05.05.10.10.39
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 05 May 2019 10:10:39 -0700 (PDT)
Subject: Re: [PATCH net-next] net: phy: improve pause mode reporting in
 phy_print_status
To:     Heiner Kallweit <hkallweit1@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <1ea97344-6971-44dd-2191-9a8db0d2c10d@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Openpgp: preference=signencrypt
Message-ID: <65df73ce-9213-2b6a-6894-f68bf54a5f3d@gmail.com>
Date:   Sun, 5 May 2019 10:10:37 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <1ea97344-6971-44dd-2191-9a8db0d2c10d@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/5/2019 10:03 AM, Heiner Kallweit wrote:
> So far we report symmetric pause only, and we don't consider the local
> pause capabilities. Let's properly consider local and remote
> capabilities, and report also asymmetric pause.

I would go one step further which is to print what is the link state of
RX/TX pause, so something like:

- local RX/TX pause advertisement
- link partnr RX/TX pause advertisement
- RX/TX being enabled for the link (auto-negotiated or manual)

this sort of duplicates what ethtool offers already but arguably so does
printing the link state so this would not be that big of a stretch.

I would make the print be something like:

Link is Up - 1Gb/Full - local pause: rx/tx, lpa pause: rx/tx, link
pause: auto-negotiated
Link is Up - 1Gb/Full - local pause: rx/tx, lpa pause: rx/tx, link
pause: forced off
Link is Up - 1Gb/Full - local pause: rx/tx, lpa pause: rx/tx, link
pause: forced on


Thanks!

> 
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
> ---
>  drivers/net/phy/phy.c | 28 +++++++++++++++++++++++++++-
>  1 file changed, 27 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/phy/phy.c b/drivers/net/phy/phy.c
> index 1a146c5c5..e88854292 100644
> --- a/drivers/net/phy/phy.c
> +++ b/drivers/net/phy/phy.c
> @@ -60,6 +60,32 @@ static void phy_link_down(struct phy_device *phydev, bool do_carrier)
>  	phy_led_trigger_change_speed(phydev);
>  }
>  
> +static const char *phy_pause_str(struct phy_device *phydev)
> +{
> +	bool local_pause, local_asym_pause;
> +
> +	if (phydev->autoneg == AUTONEG_DISABLE)
> +		goto no_pause;
> +
> +	local_pause = linkmode_test_bit(ETHTOOL_LINK_MODE_Pause_BIT,
> +					phydev->advertising);
> +	local_asym_pause = linkmode_test_bit(ETHTOOL_LINK_MODE_Asym_Pause_BIT,
> +					     phydev->advertising);
> +
> +	if (local_pause && phydev->pause)
> +		return "rx/tx";
> +
> +	if (local_asym_pause && phydev->asym_pause) {
> +		if (local_pause)
> +			return "rx";
> +		if (phydev->pause)
> +			return "tx";
> +	}
> +
> +no_pause:
> +	return "off";
> +}
> +
>  /**
>   * phy_print_status - Convenience function to print out the current phy status
>   * @phydev: the phy_device struct
> @@ -71,7 +97,7 @@ void phy_print_status(struct phy_device *phydev)
>  			"Link is Up - %s/%s - flow control %s\n",
>  			phy_speed_to_str(phydev->speed),
>  			phy_duplex_to_str(phydev->duplex),
> -			phydev->pause ? "rx/tx" : "off");
> +			phy_pause_str(phydev));
>  	} else	{
>  		netdev_info(phydev->attached_dev, "Link is Down\n");
>  	}
> 

-- 
Florian
