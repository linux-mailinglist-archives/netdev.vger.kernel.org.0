Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5B524274F0
	for <lists+netdev@lfdr.de>; Thu, 23 May 2019 06:08:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725848AbfEWEIv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 May 2019 00:08:51 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:37902 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725786AbfEWEIv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 May 2019 00:08:51 -0400
Received: by mail-wm1-f65.google.com with SMTP id t5so4233843wmh.3;
        Wed, 22 May 2019 21:08:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=/LhxOT+3mKOp8646fhyFd7RQKcrwy2o1g/++7VEPXKE=;
        b=CE1qn8SRdHON7QPLKdG5+1RWXAiSr9wqRIbZ1INqj7qD4bhX7+eB3oMQPMhbfC2UMf
         ACSczZ4AlW7JVW90IF971RTgWMGh0LU7VxzYqb3K8zz2ixGpep0P3sdWaMTjofryAEff
         GS6Y6CFo4xnFARu1+Kz1tv6T2rRgFKj96WMbZGlffYmKI8mOyh/IhzZbabHQLMvVqwze
         BDLvu4lRQnRcqOZHUd/C1PXEDDrCcQerwHhkRwhDgdRB7HzQAHi4P92K3bTN1w+tP/Hp
         +7/tix7UArGW2eoDRc11idcf1QtwA3Dz6VGWbF+R++vMswxqVTinD3KAk/o1bDXfzMbm
         q9uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=/LhxOT+3mKOp8646fhyFd7RQKcrwy2o1g/++7VEPXKE=;
        b=Sn6oI4c+UjcVCr/T77A0EoSsqPM5F6nK+nR6TqlzBqJb3UIYpXszc7bX6CHZU7+iJy
         u1JYW9Y3pL+5uEsIjSHOjlhbcfQ+2egqdboX/2O8CZGaKrwlPVfsPjEWjLipp+8KF3xV
         b+3dYFjIepc1u/8KsGsdg2IjrVXNfnxgYpSsn3o383OqTP3Izf1Pby87C5BKULBXc/4Y
         cnyNxyIB39Fq15zIwTX5QDcij3XZgSqZ9P3I0xevhXV+aOSR3BS/icEI409JXaR3xRU9
         0519C8Sa+QV9eqQzoeeB6lWQ2Vfnvg5fQT9YqsZ5vPVoRmzvX2H4hDHywPoku+v96dC/
         2n4g==
X-Gm-Message-State: APjAAAVuOThKkZ6FA1nBXE3CBAUSKRpuagQjxckZIieZHIZaojq0TLYG
        GnOkw9DuENGifJNzoTiYJ5B8wxq/
X-Google-Smtp-Source: APXvYqzWaIe7PQakTCW3+fi9El0aDhj4hoknFNBnZkDaPkn73UP52tqIRMVI/Ba0VNKZ1d7l/QwKaQ==
X-Received: by 2002:a7b:c7d6:: with SMTP id z22mr9494486wmk.54.1558584528762;
        Wed, 22 May 2019 21:08:48 -0700 (PDT)
Received: from ?IPv6:2003:ea:8bd4:5700:58fa:1813:196c:76bb? (p200300EA8BD4570058FA1813196C76BB.dip0.t-ipconnect.de. [2003:ea:8bd4:5700:58fa:1813:196c:76bb])
        by smtp.googlemail.com with ESMTPSA id 19sm4874003wmi.10.2019.05.22.21.08.47
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 22 May 2019 21:08:48 -0700 (PDT)
Subject: Re: [PATCH net-next 2/2] net: phy: aquantia: add USXGMII support
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Madalin-cristian Bucur <madalin.bucur@nxp.com>,
        Shawn Guo <shawnguo@kernel.org>, Li Yang <leoyang.li@nxp.com>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
References: <110a1e45-56a7-a646-7b63-f39fe3083c28@gmail.com>
 <2c68bdb1-9b53-ce0b-74d3-c7ea2d9e7ac0@gmail.com>
 <20190522205851.GA15257@lunn.ch>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <8e34e321-fe1d-0dea-0d85-246876c43e14@gmail.com>
Date:   Thu, 23 May 2019 06:08:42 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190522205851.GA15257@lunn.ch>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 22.05.2019 22:58, Andrew Lunn wrote:
> On Wed, May 22, 2019 at 09:58:32PM +0200, Heiner Kallweit wrote:
>> So far we didn't support mode USXGMII, and in order to not break the
>> two Freescale boards mode XGMII was accepted for the AQR107 family
>> even though it doesn't support XGMII. Add USXGMII support to the
>> Aquantia PHY driver and change the phy connection type for the two
>> boards.
>>
>> As an additional note: Even though the handle is named aqr106
>> there seem to be LS1046A boards with an AQR107.
>>
>> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
>> ---
>>  arch/arm64/boot/dts/freescale/fsl-ls1043a-rdb.dts | 2 +-
>>  arch/arm64/boot/dts/freescale/fsl-ls1046a-rdb.dts | 2 +-
>>  drivers/net/phy/aquantia_main.c                   | 6 +++++-
>>  3 files changed, 7 insertions(+), 3 deletions(-)
>>
>> diff --git a/arch/arm64/boot/dts/freescale/fsl-ls1043a-rdb.dts b/arch/arm64/boot/dts/freescale/fsl-ls1043a-rdb.dts
>> index 4223a2352..c2ce1a611 100644
>> --- a/arch/arm64/boot/dts/freescale/fsl-ls1043a-rdb.dts
>> +++ b/arch/arm64/boot/dts/freescale/fsl-ls1043a-rdb.dts
>> @@ -139,7 +139,7 @@
>>  
>>  	ethernet@f0000 { /* 10GEC1 */
>>  		phy-handle = <&aqr105_phy>;
>> -		phy-connection-type = "xgmii";
>> +		phy-connection-type = "usxgmii";
>>  	};
>>  
>>  	mdio@fc000 {
>> diff --git a/arch/arm64/boot/dts/freescale/fsl-ls1046a-rdb.dts b/arch/arm64/boot/dts/freescale/fsl-ls1046a-rdb.dts
>> index 6a6514d0e..f927a8a25 100644
>> --- a/arch/arm64/boot/dts/freescale/fsl-ls1046a-rdb.dts
>> +++ b/arch/arm64/boot/dts/freescale/fsl-ls1046a-rdb.dts
>> @@ -147,7 +147,7 @@
>>  
>>  	ethernet@f0000 { /* 10GEC1 */
>>  		phy-handle = <&aqr106_phy>;
>> -		phy-connection-type = "xgmii";
>> +		phy-connection-type = "usxgmii";
>>  	};
>>  
>>  	ethernet@f2000 { /* 10GEC2 */
>> diff --git a/drivers/net/phy/aquantia_main.c b/drivers/net/phy/aquantia_main.c
>> index 0fedd28fd..3f24c42a8 100644
>> @@ -487,7 +491,7 @@ static int aqr107_config_init(struct phy_device *phydev)
>>  	/* Check that the PHY interface type is compatible */
>>  	if (phydev->interface != PHY_INTERFACE_MODE_SGMII &&
>>  	    phydev->interface != PHY_INTERFACE_MODE_2500BASEX &&
>> -	    phydev->interface != PHY_INTERFACE_MODE_XGMII &&
>> +	    phydev->interface != PHY_INTERFACE_MODE_USXGMII &&
>>  	    phydev->interface != PHY_INTERFACE_MODE_10GKR)
>>  		return -ENODEV;
> 
> Hi Heiner
> 
> Just to reiterate Florian's point. We need to be careful with device
> tree blobs. We should try not to break them, at least not for a few
> cycles.
> 
> I would much prefer to see a
> 
> WARN_ON(phydev->interface == PHY_INTERFACE_MODE_XGMII,
>         "Your devicetree is out of date, please update it");
> 
> and accept XGMII for this cycle. These are development boards, so in
> theory users are developers, so should know how to update the DT.
> 
I see your point. Then I'll just change phylib and will let the NXP
guys change the board DTS.

>     Andrew
> 
Heiner
