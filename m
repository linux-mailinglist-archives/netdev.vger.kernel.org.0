Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D63C1D218A
	for <lists+netdev@lfdr.de>; Wed, 13 May 2020 23:57:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730120AbgEMV5w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 May 2020 17:57:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729487AbgEMV5w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 May 2020 17:57:52 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 095EBC061A0C;
        Wed, 13 May 2020 14:57:52 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id w7so1295912wre.13;
        Wed, 13 May 2020 14:57:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=YOoUa0xAi/KzpbI4jik8wbTI9P2HHu1hymEJr5NBiDI=;
        b=kZup2xPqnPYYj0DMmM740Z74B7fF4Pf1Za+zzpgAweieCVuGcB5kXLEGHFDOmiN+TE
         zDlhzY9loA7sx1eq9lEKBva6cajes3Fo0LGr6liJE+FgTwWqoNbD6tooEoW6UnUcR7TC
         tBNSVRNVxU7sJl4TK3kXCzxVB2uH6i/AgUPxdSEEsugJ269DAxWqoTmv0EseupNam2Ge
         MsE8g3wD+qrwEa/ZP6hW8pk0dqfd+6+RX9dMnt3ISmHeyA3hwqGiwPIRVH1XtvfhPnJU
         jDkvqPMpHtxUQTdWZbKiLm/CoZotn6d+5sf4F9duWpsffw68GdI64lT2CFgsL2WEB/ZA
         7efQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=YOoUa0xAi/KzpbI4jik8wbTI9P2HHu1hymEJr5NBiDI=;
        b=fSX8qDZhvyvmmDGEH+ZG/9E/unXvhp91AfkFeUhDiKfqlyFKoYV3oaAjOQnhb9wNTh
         qYy0sYxYmnmlTm8P4Xmr+iAq/P1BkEC2g0QnQrBgaSB7UuXmML3mfxHu0Kv4+Mgr2koM
         WbnFMjFTSYtdf4Kja/vHP29S3/GVhawmaFhWrqV0zgSMvPVmJEkDivJDdVjt7/Z/RR3I
         icy/QdzvdiUUzYONvo6w7IlnyUZQnJDFZrjKXwf8p2gQH5cpQxO+WSvFnEs4FYYRPgml
         kLF1jNN3XpaDQJzFiKQWCflcrmp0piEBkQmz1t9Vj+KTfJdNEhTKVFC7jE22sTvEK1mY
         d67g==
X-Gm-Message-State: AOAM533/lkM6a0fPP9yvs83THJCV6IsKCyJeSBh33C0g1LMIiFTztHqU
        ryLYzMPE+6niEFLpwVg0OJlDsOUZ
X-Google-Smtp-Source: ABdhPJzmq8mG3pfPm8JG5Ssb32Qxn/CxK37tCMNpOXfIetBXnFWjfooqp+E41Vh0lE4z0sY6eGuT9g==
X-Received: by 2002:a5d:6705:: with SMTP id o5mr1632637wru.426.1589407070514;
        Wed, 13 May 2020 14:57:50 -0700 (PDT)
Received: from [10.230.191.242] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id c19sm1144370wrb.89.2020.05.13.14.57.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 May 2020 14:57:50 -0700 (PDT)
Subject: Re: [PATCH net-next 4/4] net: bcmgenet: add support for ethtool flow
 control
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        bcm-kernel-feedback-list@broadcom.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1589243050-18217-1-git-send-email-opendmb@gmail.com>
 <1589243050-18217-5-git-send-email-opendmb@gmail.com>
 <20200513095246.GH1551@shell.armlinux.org.uk>
From:   Doug Berger <opendmb@gmail.com>
Message-ID: <ce0c0cd6-3532-be90-1307-5ccd8e3b02a4@gmail.com>
Date:   Wed, 13 May 2020 15:00:37 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200513095246.GH1551@shell.armlinux.org.uk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/13/2020 2:52 AM, Russell King - ARM Linux admin wrote:
> On Mon, May 11, 2020 at 05:24:10PM -0700, Doug Berger wrote:
>> diff --git a/drivers/net/ethernet/broadcom/genet/bcmmii.c b/drivers/net/ethernet/broadcom/genet/bcmmii.c
>> index 511d553a4d11..788da1ecea0c 100644
>> --- a/drivers/net/ethernet/broadcom/genet/bcmmii.c
>> +++ b/drivers/net/ethernet/broadcom/genet/bcmmii.c
>> @@ -25,6 +25,21 @@
>>  
>>  #include "bcmgenet.h"
>>  
>> +static u32 _flow_control_autoneg(struct phy_device *phydev)
>> +{
>> +	bool tx_pause, rx_pause;
>> +	u32 cmd_bits = 0;
>> +
>> +	phy_get_pause(phydev, &tx_pause, &rx_pause);
>> +
>> +	if (!tx_pause)
>> +		cmd_bits |= CMD_TX_PAUSE_IGNORE;
>> +	if (!rx_pause)
>> +		cmd_bits |= CMD_RX_PAUSE_IGNORE;
>> +
>> +	return cmd_bits;
>> +}
>> +
>>  /* setup netdev link state when PHY link status change and
>>   * update UMAC and RGMII block when link up
>>   */
>> @@ -71,12 +86,20 @@ void bcmgenet_mii_setup(struct net_device *dev)
>>  		cmd_bits <<= CMD_SPEED_SHIFT;
>>  
>>  		/* duplex */
>> -		if (phydev->duplex != DUPLEX_FULL)
>> -			cmd_bits |= CMD_HD_EN;
>> -
>> -		/* pause capability */
>> -		if (!phydev->pause)
>> -			cmd_bits |= CMD_RX_PAUSE_IGNORE | CMD_TX_PAUSE_IGNORE;
>> +		if (phydev->duplex != DUPLEX_FULL) {
>> +			cmd_bits |= CMD_HD_EN |
>> +				CMD_RX_PAUSE_IGNORE | CMD_TX_PAUSE_IGNORE;
> 
> phy_get_pause() already takes account of whether the PHY is in half
> duplex mode.  So:
> 
> 		bool tx_pause, rx_pause;
> 
> 		if (phydev->autoneg && priv->autoneg_pause) {
> 			phy_get_pause(phydev, &tx_pause, &rx_pause);
> 		} else if (phydev->duplex == DUPLEX_FULL) {
> 			tx_pause = priv->tx_pause;
> 			rx_pause = priv->rx_pause;
> 		} else {
> 			tx_pause = false;
> 			rx_pause = false;
> 		}
> 
> 		if (!tx_pause)
> 			cmd_bits |= CMD_TX_PAUSE_IGNORE;
> 		if (!rx_pause)
> 			cmd_bits |= CMD_RX_PAUSE_IGNORE;
> 
> would be entirely sufficient here.
I need to check the duplex to configure the HD bit in the same register
with the pause controls so I am covering both with one compare.

This also includes a bug here that I mentioned in one of my responses to
the first patch of the set. The call to phy_get_pause() should only be
conditioned on phydev->autoneg_pause here.

The idea is that both directions of pause default to on, but if
autoneg_pause is on then phy_get_pause() has an opportunity to disable
any direction if the capability can't be negotiated for that direction.
Finally, the pause feature can be explicitly disabled by the tx_pause
and rx_pause parameters.
> I wonder whether your implementation (which mine follows) is really
> correct though.  Consider this:
> 
> # ethtool -A eth0 autoneg on tx on rx on
> # ethtool -s eth0 autoneg off speed 1000 duplex full
> 
> At this point, what do you expect the resulting pause state to be?  It
> may not be what you actually think it should be - it will be tx and rx
> pause enabled (it's easier to see why that happens with my rewritten
> version of your implementation, which is functionally identical.)
> 
> If we take the view that if link autoneg is disabled, and therefore the
> link partner's advertisement is zero, shouldn't it result in tx and rx
> pause being disabled?
So with the bug fixed as described above, after these commands
autoneg_pause would be on and autoneg would be off. The logic would call
phy_get_pause() which should return tx_pause = rx_pause = false turning
pause off in both directions.

