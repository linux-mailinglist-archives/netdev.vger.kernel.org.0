Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CDE2C178362
	for <lists+netdev@lfdr.de>; Tue,  3 Mar 2020 20:50:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731144AbgCCTus (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Mar 2020 14:50:48 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:54696 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727604AbgCCTus (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Mar 2020 14:50:48 -0500
Received: by mail-wm1-f65.google.com with SMTP id i9so3269384wml.4;
        Tue, 03 Mar 2020 11:50:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=72jp2PM3m/3yJ85MPU4yuZlrGXIka+61ev8w/EuCbz4=;
        b=crkesGEa5q/XDyLLUcvTkBPaoEV8sMnESatCqzGV9Ml+1KzVgpEZmAyJLa4/l2M9Nw
         f4MkoDqQWnBZvOPhZK0pTAq6lPs86ip441NTvksJNf0OptjP5PHCnXIxALbUMfEQXB16
         ZibWOcPOp3XMx+ZmZaFKjxvNm/UV6Q8SN8vvJ1kFqsvDDGGuUHkRAzvXbpwcwiOCILTD
         5obTbidY/FA5VmwuZInXI0J/R64Wi6qI6yL7clRVLOoP5KvNBL3st8B5x3t8Cz4Ob2Px
         s9Kb2Ty5LhTodyO9yruFS8PAvCI42eSx7eKsPFE37YwnK3pmKAhBsUEPMt6uWJ2WxFuN
         L24g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=72jp2PM3m/3yJ85MPU4yuZlrGXIka+61ev8w/EuCbz4=;
        b=nksXnZrgojc3VtNwK4v5ikMc5nlWvLReF5r+EPWzrfo3QXKol8qN4ZWoivN5sIKdBy
         J3oGbZvxUYZKDhqP+7pJ+46h0MjlYn2aGiUfv5/bW1a+5A5Cx/YPR0fX50KSAqkNed7C
         KQAzUxOn4z8WvVyHDy+X7Z//Cfwq71Js4TK51DUVkCJwekl8G1RDTIQiP8bw1J5zZGTZ
         4r9TlWUwiLGmwhx+ifKMAqjGr9iXrkAVfmdSBIXD+BjHk09HUELJGjAvuz1otIHeKdkY
         uzgucqZJ/xgJ0VFsc8Pl63VMZpf48/0oszruljigzEsN2Xq69BYyOSQmieIXYg5fqqsZ
         hy+g==
X-Gm-Message-State: ANhLgQ0s5Hy8CqCQYorbspv19x5IaD/XqqOfboCAdPCHq2nipaJ+EVCG
        DtAWOiXqc5enJON7F/8PhckdJzhh
X-Google-Smtp-Source: ADFU+vtEi0RhPp2pH2g5fG3PiaqyTgYcv2kILZjhuoeZch9vDVmW/l++2KADioUHjetKQSlUrxltwA==
X-Received: by 2002:a7b:c5da:: with SMTP id n26mr167838wmk.138.1583265046465;
        Tue, 03 Mar 2020 11:50:46 -0800 (PST)
Received: from ?IPv6:2003:ea:8f29:6000:f8e3:535f:f59f:a97f? (p200300EA8F296000F8E3535FF59FA97F.dip0.t-ipconnect.de. [2003:ea:8f29:6000:f8e3:535f:f59f:a97f])
        by smtp.googlemail.com with ESMTPSA id w16sm1187802wrp.8.2020.03.03.11.50.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Mar 2020 11:50:45 -0800 (PST)
Subject: Re: [PATCH v1] net: phy: tja11xx: add TJA1102 support
To:     Marc Kleine-Budde <mkl@pengutronix.de>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>
Cc:     Marek Vasut <marex@denx.de>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        David Jander <david@protonic.nl>,
        "David S. Miller" <davem@davemloft.net>
References: <20200303073715.32301-1-o.rempel@pengutronix.de>
 <eada8b95-bbfe-5dba-7e39-6202e67c26f0@gmail.com>
 <35d02d3d-0fd8-1fce-1f60-90a4a1377c78@pengutronix.de>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <9dae8f4a-43b0-e379-9b14-5a2a21640044@gmail.com>
Date:   Tue, 3 Mar 2020 20:50:40 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <35d02d3d-0fd8-1fce-1f60-90a4a1377c78@pengutronix.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 03.03.2020 09:56, Marc Kleine-Budde wrote:
> On 3/3/20 9:46 AM, Heiner Kallweit wrote:
>> On 03.03.2020 08:37, Oleksij Rempel wrote:
>>> TJA1102 is an dual T1 PHY chip. Both PHYs are separately addressable.
>>> PHY 0 can be identified by PHY ID. PHY 1 has no PHY ID and can be
>>> configured in device tree by setting compatible =
>>> "ethernet-phy-id0180.dc81".
>     ^^^^^^^^^^^^^^^^^^^^^^^^
> 
>> I'm not sure I understand what you're doing here. The two ports of the chip
>> are separate PHY's on individual MDIO bus addresses?
> 
> Yes, Port 0 and Port 1 have seperate MFIO bus addresses, but only Port 0
> has a proper phy_id (== PHY_ID_TJA1102), while Port 1 just has 0.
> 
> Currently we register Port 1 via the device tree compatible
> "ethernet-phy-id0180.dc81".
> 
Thanks for the explanation. Missed that part, then reading the PHY ID
of the chip is skipped. For checking whether we are port 0 or 1 it wouldn't
even be needed to read both PHY ID registers.
One drawback of the solution might be that it works on DT-configured
systems only (not sure how relevant this is). A little bit more detailed
comment may be helpful, to avoid misunderstandings like mine.

>> Reading the PHY ID registers here seems to repeat what phylib did already
>> to populate phydev->phy_id. If port 1 has PHD ID 0 then the driver wouldn't
>> bind and tja11xx_probe() would never be called (see phy_bus_match)
> 
> But we "force" it via the DT compatible. Another option would be to make
> up a phyid for Port 1 and hope that it doesn't collide with a real phy
> id in other or upcoming chips. But that sounds not like a clean solution
> either.
> 
> Marc
> 
Heiner
