Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D2E32164E53
	for <lists+netdev@lfdr.de>; Wed, 19 Feb 2020 20:03:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726680AbgBSTDu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Feb 2020 14:03:50 -0500
Received: from fllv0015.ext.ti.com ([198.47.19.141]:60288 "EHLO
        fllv0015.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726643AbgBSTDu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Feb 2020 14:03:50 -0500
Received: from lelv0265.itg.ti.com ([10.180.67.224])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 01JJ3fWj081890;
        Wed, 19 Feb 2020 13:03:41 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1582139021;
        bh=PdP8o3LePLb06Tf/GSMcpBK5khtA63IgL9abPaFPLnE=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=nnU0eJ7yBDLsLSx5IRHXyo0FGmb2NnTyOaruSSIERsrn6odGaDwEDyagmA9FHRKN9
         gbrZ/f0OThJ0qPx7YoBdHpg+Aqfu+gW0e99IGShwVv3nDwcVRgIMOSnJcYbw39sL4L
         AJBlJlm8SmBeSH7p3oTFxB2Hw0VidfQPd5Xl3J6I=
Received: from DFLE114.ent.ti.com (dfle114.ent.ti.com [10.64.6.35])
        by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 01JJ3fh7127964
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 19 Feb 2020 13:03:41 -0600
Received: from DFLE104.ent.ti.com (10.64.6.25) by DFLE114.ent.ti.com
 (10.64.6.35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3; Wed, 19
 Feb 2020 13:03:41 -0600
Received: from lelv0327.itg.ti.com (10.180.67.183) by DFLE104.ent.ti.com
 (10.64.6.25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3 via
 Frontend Transport; Wed, 19 Feb 2020 13:03:41 -0600
Received: from [10.250.65.13] (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id 01JJ3eYB115217;
        Wed, 19 Feb 2020 13:03:40 -0600
Subject: Re: [PATCH net-master] net: phy: dp83848: Add the TI TLK05/06 PHY ID
To:     Andrew Lunn <andrew@lunn.ch>
CC:     <f.fainelli@gmail.com>, <hkallweit1@gmail.com>,
        <linux@armlinux.org.uk>, <davem@davemloft.net>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <afd@ti.com>
References: <20200219181613.5898-1-dmurphy@ti.com>
 <20200219184847.GD3281@lunn.ch>
From:   Dan Murphy <dmurphy@ti.com>
Message-ID: <81b0e285-8a2a-2370-ecf5-2540bc30f1ed@ti.com>
Date:   Wed, 19 Feb 2020 12:58:36 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200219184847.GD3281@lunn.ch>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrew(s)

On 2/19/20 12:48 PM, Andrew Lunn wrote:
> On Wed, Feb 19, 2020 at 12:16:13PM -0600, Dan Murphy wrote:
>> Add the TLK05/06 PHY ID to the DP83848 driver.  The TI website indicates
>> that the DP83822 device is a drop in replacement for the TLK05 device
>> but the TLK device does not have WoL support.  The TLK device is
>> register compatible to the DP83848 and the DP83848 does not support WoL
>> either.  So this PHY can be associated with the DP83848 driver.
>>
>> The initial TLKx PHY ID in the driver is a legacy ID and the public data
>> sheet indicates a new PHY ID.  So not to break any kernels out there
>> both IDs will continue to be supported in this driver.
>>
>> Signed-off-by: Dan Murphy <dmurphy@ti.com>
>> ---
>>   drivers/net/phy/dp83848.c | 4 ++++
>>   1 file changed, 4 insertions(+)
>>
>> diff --git a/drivers/net/phy/dp83848.c b/drivers/net/phy/dp83848.c
>> index 54c7c1b44e4d..66907cfa816a 100644
>> --- a/drivers/net/phy/dp83848.c
>> +++ b/drivers/net/phy/dp83848.c
>> @@ -12,6 +12,7 @@
>>   #define TI_DP83620_PHY_ID		0x20005ce0
>>   #define NS_DP83848C_PHY_ID		0x20005c90
>>   #define TLK10X_PHY_ID			0x2000a210
>> +#define TLK105_06_PHY_ID		0x2000a211
>>   
>>   /* Registers */
>>   #define DP83848_MICR			0x11 /* MII Interrupt Control Register */
>> @@ -85,6 +86,7 @@ static struct mdio_device_id __maybe_unused dp83848_tbl[] = {
>>   	{ NS_DP83848C_PHY_ID, 0xfffffff0 },
>>   	{ TI_DP83620_PHY_ID, 0xfffffff0 },
>>   	{ TLK10X_PHY_ID, 0xfffffff0 },
>> +	{ TLK105_06_PHY_ID, 0xfffffff0 },
>>   	{ }
>>   };
>>   MODULE_DEVICE_TABLE(mdio, dp83848_tbl);
>> @@ -115,6 +117,8 @@ static struct phy_driver dp83848_driver[] = {
>>   			   dp83848_config_init),
>>   	DP83848_PHY_DRIVER(TLK10X_PHY_ID, "TI TLK10X 10/100 Mbps PHY",
>>   			   NULL),
>> +	DP83848_PHY_DRIVER(TLK105_06_PHY_ID, "TI TLK105/06 10/100 Mbps PHY",
>> +			   NULL),
> I'm pretty sure Andrew's comment is correct. Due to the mask, the
> TLK10X_PHY_ID entry will hit.
Yes Andrew D is correct.
> What you can do is change the order and the mask. Put TLK105_06_PHY_ID
> before TLK10X_PHY_ID and have an exact match, no mask.

I don't think we need a patch then for this ID.

As Andrew D pointed out it will match the current ID since the lower 
nibble of the ID is masked off.

Dan
>
>         Andrew
