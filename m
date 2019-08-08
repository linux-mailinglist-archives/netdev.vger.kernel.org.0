Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B461686B21
	for <lists+netdev@lfdr.de>; Thu,  8 Aug 2019 22:09:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404429AbfHHUJo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Aug 2019 16:09:44 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:38591 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390202AbfHHUJn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Aug 2019 16:09:43 -0400
Received: by mail-wr1-f67.google.com with SMTP id g17so96113329wrr.5
        for <netdev@vger.kernel.org>; Thu, 08 Aug 2019 13:09:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=oqYRrl6Ut7S/G9zf4nlo8NNnUNIkKmLCGjEcEWmW9lI=;
        b=V43WtbDe+YhWmjc71z8TyBNg5SZhZquUKgYG9IlbEujIL6O+dv7WwWz8hKyR0WXDre
         eg6dPq1SWZV+r5HB+FLec5Rck2x9gi6Z/ZggSexfSzW0liUlzp9Mba3J9jaPYmcH1h+r
         atVekPZiltLI1J+4hoZb8WpbiT2rn9x0+k5weBklbzGi/D+1BpfXDhYEObu1tX74taVj
         AkpXOV+mothVXvtHi8nquFVHkyCG1g+KKMSk1hVSwcS8mUp9IwRqy4dFXS17cYY764o3
         9SftifEhOpPaTsYRPmuAsPInAQ62ro7dwXu63CaPXBjyxQ0LTsJjnFeWlIFrpC2HtzSE
         MZlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=oqYRrl6Ut7S/G9zf4nlo8NNnUNIkKmLCGjEcEWmW9lI=;
        b=ghSRgREcKiyeLfMrVKHBBjbx/hAfpZvVXxhtj3hVSTGJIr6A6EDcpTQaXDduIYdbQk
         RT2VpRxmRliAZrrDm++IxbcYtz4+ysXHriXqHS/wZtALnGlqHBv6JbdXoZ1CqQjz92t7
         z+TD2CjYLJCGKRh/9tBaRmqkstjKgz5Dl+hYZJ5j9/wy5sYuFp6WpdCgr2QVBJkO8IWU
         owPsDvmE9XZGWDERx3WzBBc/v8ZUf9qlgKJY8WpLhPwCvgr9R7HtbamxJlGXVRYFgUPs
         uuKQbWZGteZTLxk/bjcuJXD38U9ceKDYuz0btfyPQC2sa21lBf+VYwsPN/8qA+YoYcu6
         DUDg==
X-Gm-Message-State: APjAAAX0xV1ind4fGqt3XPgRMoHno2dUx5waExVKrg9qHJfmNIyxsmDC
        lcauGFtiSEgvHded8csKP3FsatZT
X-Google-Smtp-Source: APXvYqzveHqjJmVGluIYCeGgWRFywFzzIK9VxmMTuZ0ZO012/svHHjh/6EXysqRa7o9UWjt1Z2E3MA==
X-Received: by 2002:adf:f641:: with SMTP id x1mr16599850wrp.179.1565294981495;
        Thu, 08 Aug 2019 13:09:41 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f2f:3200:ec8a:8637:bf5f:7faf? (p200300EA8F2F3200EC8A8637BF5F7FAF.dip0.t-ipconnect.de. [2003:ea:8f2f:3200:ec8a:8637:bf5f:7faf])
        by smtp.googlemail.com with ESMTPSA id a84sm5008940wmf.29.2019.08.08.13.09.40
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 08 Aug 2019 13:09:41 -0700 (PDT)
Subject: Re: [PATCH net-next 1/3] net: phy: prepare phylib to deal with PHY's
 extending Clause 22
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <ddbf28b9-f32e-7399-10a6-27b79ca0aaf9@gmail.com>
 <214bedc0-4ae0-b15f-e03c-173f17527417@gmail.com>
 <20190808193243.GK27917@lunn.ch>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <1615562b-b91f-0e0e-fb2d-622b7ca134ba@gmail.com>
Date:   Thu, 8 Aug 2019 22:09:36 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190808193243.GK27917@lunn.ch>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 08.08.2019 21:32, Andrew Lunn wrote:
> On Thu, Aug 08, 2019 at 09:03:42PM +0200, Heiner Kallweit wrote:
>> The integrated PHY in 2.5Gbps chip RTL8125 is the first (known to me)
>> PHY that uses standard Clause 22 for all modes up to 1Gbps and adds
>> 2.5Gbps control using vendor-specific registers. To use phylib for
>> the standard part little extensions are needed:
>> - Move most of genphy_config_aneg to a new function
>>   __genphy_config_aneg that takes a parameter whether restarting
>>   auto-negotiation is needed (depending on whether content of
>>   vendor-specific advertisement register changed).
>> - Don't clear phydev->lp_advertising in genphy_read_status so that
>>   we can set non-C22 mode flags before.
>>
>> Basically both changes mimic the behavior of the equivalent Clause 45
>> functions.
>>
>> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
>> ---
>>  drivers/net/phy/phy_device.c | 35 +++++++++++++++--------------------
>>  include/linux/phy.h          |  8 +++++++-
>>  2 files changed, 22 insertions(+), 21 deletions(-)
>>
>> diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
>> index 7ddd91df9..bd7e7db8c 100644
>> --- a/drivers/net/phy/phy_device.c
>> +++ b/drivers/net/phy/phy_device.c
>> @@ -1571,11 +1571,9 @@ static int genphy_config_advert(struct phy_device *phydev)
>>  	/* Only allow advertising what this PHY supports */
>>  	linkmode_and(phydev->advertising, phydev->advertising,
>>  		     phydev->supported);
>> -	if (!ethtool_convert_link_mode_to_legacy_u32(&advertise,
>> -						     phydev->advertising))
>> -		phydev_warn(phydev, "PHY advertising (%*pb) more modes than genphy supports, some modes not advertised.\n",
>> -			    __ETHTOOL_LINK_MODE_MASK_NBITS,
>> -			    phydev->advertising);
>> +
>> +	ethtool_convert_link_mode_to_legacy_u32(&advertise,
>> +						phydev->advertising);
> 
> Hi Heiner
> 
> linkmode_adv_to_mii_adv_t() would remove the need to use
> ethtool_convert_link_mode_to_legacy_u32(), and this warning would also
> go away. 
> 
Thanks for the hint! I'll check and submit a v2.

>    Andrew
> 
Heiner

