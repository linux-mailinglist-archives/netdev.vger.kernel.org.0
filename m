Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 017B461A84
	for <lists+netdev@lfdr.de>; Mon,  8 Jul 2019 08:03:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728375AbfGHGDV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jul 2019 02:03:21 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:38251 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727218AbfGHGDV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jul 2019 02:03:21 -0400
Received: by mail-wm1-f67.google.com with SMTP id s15so15015532wmj.3
        for <netdev@vger.kernel.org>; Sun, 07 Jul 2019 23:03:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=0k6bSvcU9O/QJnBhAJGLcZJTgSTBgLOXSurZ2xzE7js=;
        b=lQvTkTYEJ/sMp1IXbhfq2Y2RWZR0CsX3F1LBZlbkRQVDgnqew+qXd8euBmniOoV/DR
         SWO59l5RSsCl3DCNB/ndh8sgP5oGZ8pfSg+NMpOAUfXUMrRKii6F87pfpIGnzkSlDsC9
         wBGrRB7k0COlbRG+bb6YDIqc8WtA8rCXX0YPSZImQcpsqO0RO45MxbX9lumaTgpfiSvy
         us5vqPvunBFYxHHOZGmMwuN5oz+pGv7Q9+S0GYtSep4KAFfOMhJjBI6AngZ4ToWGRsuM
         kURaKNh5hcQiCwK8O1Xyx2l+g6uc1fSBNju5dktJiN/ZTL66q1s4OqLQrJ5Fh6YVS6Lz
         sShQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=0k6bSvcU9O/QJnBhAJGLcZJTgSTBgLOXSurZ2xzE7js=;
        b=RWupCiHG2T1dPiMqUGiUg5Y91GRLOfXWXEk4ZfYjD+l4htyOKSUUeBmQkf6xR6dZzu
         hhpwAzP3TEBDOE1yXaGJHLLN5uyUv5LsthNtWGC/ejN+G4oy/qLwmYuQtakm14Skp+Vt
         Yf2heUlzbeACC0gOncwWIhzYjyuY5+k7ascPubFDF8fbRbqV4pu/BB9xwL9Xb7Aukzw3
         vMFjs6GNLaYfifBRHBugMlVZ3h/3rKQUL/V2eWEHsbILzidNPPLG2kSsR7tddDdIhDb/
         G3+j4Cv5ay4h1jnS3jyYa5tzKyPEcw5KN8Ow0TrD6YkSUU+rFySMo+9eOxdLxcNGV2/L
         tpEw==
X-Gm-Message-State: APjAAAV2MrKF97RMHLycp2CqR4eN/yxA69Jtm70CYXWKVaVpdsNiKK1u
        sITMMelx1x4PwXwR2znL8QU=
X-Google-Smtp-Source: APXvYqxT/YZnTm8S2ODiZMLclzb9aoQVdq/YeOQ9ELHKMQJ40lSc8owtWZwUu8qm/ZT5sjRjo0X4Cw==
X-Received: by 2002:a1c:c545:: with SMTP id v66mr15267992wmf.51.1562565798588;
        Sun, 07 Jul 2019 23:03:18 -0700 (PDT)
Received: from ?IPv6:2003:ea:8bd6:c00:6cab:1c3d:9973:65c0? (p200300EA8BD60C006CAB1C3D997365C0.dip0.t-ipconnect.de. [2003:ea:8bd6:c00:6cab:1c3d:9973:65c0])
        by smtp.googlemail.com with ESMTPSA id u1sm14432661wml.14.2019.07.07.23.03.17
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 07 Jul 2019 23:03:17 -0700 (PDT)
Subject: Re: [PATCH] phy: added a PHY_BUSY state into phy_state_machine
To:     Florian Fainelli <f.fainelli@gmail.com>,
        "kwangdo.yi" <kwangdo.yi@gmail.com>, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>
References: <1562538732-20700-1-git-send-email-kwangdo.yi@gmail.com>
 <539888f4-e5be-7ad5-53ce-63dd182708b1@gmail.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <cd7591e7-4a4a-b5a6-21af-045acd89923d@gmail.com>
Date:   Mon, 8 Jul 2019 08:03:10 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <539888f4-e5be-7ad5-53ce-63dd182708b1@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 08.07.2019 05:07, Florian Fainelli wrote:
> +Andrew, Heiner (please CC PHY library maintainers).
> 
> On 7/7/2019 3:32 PM, kwangdo.yi wrote:
>> When mdio driver polling the phy state in the phy_state_machine,
>> sometimes it results in -ETIMEDOUT and link is down. But the phy
>> is still alive and just didn't meet the polling deadline. 
>> Closing the phy link in this case seems too radical. Failing to 
>> meet the deadline happens very rarely. When stress test runs for 
>> tens of hours with multiple target boards (Xilinx Zynq7000 with
>> marvell 88E1512 PHY, Xilinx custom emac IP), it happens. This 
>> patch gives another chance to the phy_state_machine when polling 
>> timeout happens. Only two consecutive failing the deadline is 
>> treated as the real phy halt and close the connection.
> 
In addition to what Florian said already there's at least one
issue apart from the quite hacky approach in general.

Let's say we are in interrupt mode and the timeout happens when
reading the PHY status after a link-down interrupt. When ignoring
the error we miss the transition and phylib will report a wrong
link status.

I also would prefer to first check for the root cause and try to
fix it, before adding hacks to upper layers for ignoring errors.

> How about simply increasing the MDIO polling timeout in the Xilinx EMAC
> driver instead? Or if the PHY is where the timeout needs to be
> increased, allow the PHY device drivers to advertise min/max timeouts
> such that the MDIO bus layer can use that information?
> 
>>
>>
>> Signed-off-by: kwangdo.yi <kwangdo.yi@gmail.com>
>> ---
>>  drivers/net/phy/phy.c | 6 ++++++
>>  include/linux/phy.h   | 1 +
>>  2 files changed, 7 insertions(+)
>>
>> diff --git a/drivers/net/phy/phy.c b/drivers/net/phy/phy.c
>> index e888542..9e8138b 100644
>> --- a/drivers/net/phy/phy.c
>> +++ b/drivers/net/phy/phy.c
>> @@ -919,7 +919,13 @@ void phy_state_machine(struct work_struct *work)
>>  		break;
>>  	case PHY_NOLINK:
>>  	case PHY_RUNNING:
>> +	case PHY_BUSY:
>>  		err = phy_check_link_status(phydev);
>> +		if (err == -ETIMEDOUT && old_state == PHY_RUNNING) {
>> +			phy->state = PHY_BUSY;
>> +			err = 0;
>> +
>> +		}
>>  		break;
>>  	case PHY_FORCING:
>>  		err = genphy_update_link(phydev);
>> diff --git a/include/linux/phy.h b/include/linux/phy.h
>> index 6424586..4a49401 100644
>> --- a/include/linux/phy.h
>> +++ b/include/linux/phy.h
>> @@ -313,6 +313,7 @@ enum phy_state {
>>  	PHY_RUNNING,
>>  	PHY_NOLINK,
>>  	PHY_FORCING,
>> +	PHY_BUSY,
>>  };
>>  
>>  /**
>>
> 

