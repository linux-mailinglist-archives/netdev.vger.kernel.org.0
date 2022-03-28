Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EFD1A4E8FD9
	for <lists+netdev@lfdr.de>; Mon, 28 Mar 2022 10:14:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239186AbiC1IQF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Mar 2022 04:16:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239182AbiC1IQE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Mar 2022 04:16:04 -0400
Received: from fllv0015.ext.ti.com (fllv0015.ext.ti.com [198.47.19.141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AF1412776;
        Mon, 28 Mar 2022 01:14:23 -0700 (PDT)
Received: from fllv0034.itg.ti.com ([10.64.40.246])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 22S8Dv3o014064;
        Mon, 28 Mar 2022 03:13:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1648455237;
        bh=emVq8fUjWce333B85VW9zsY10Mr1PEvsIJ2jYK1KaaQ=;
        h=Date:Subject:To:CC:References:From:In-Reply-To;
        b=SHrYdVNSZ0zUykJdOs5qHsLqJAeZenV8dc/Ow28XkeO/xM1+2VF3q+iOZ858xLk/O
         1G5onBYI4tu3ZyaNs80sTkvmuHr5TN23g+733CnKKDLdbqPhNqJOXfSvpeCUwkUR3z
         14l2RzMJael1WkhATupz+CI+2FJyTrSb4IxUPNkg=
Received: from DFLE103.ent.ti.com (dfle103.ent.ti.com [10.64.6.24])
        by fllv0034.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 22S8Dv3M106347
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 28 Mar 2022 03:13:57 -0500
Received: from DFLE101.ent.ti.com (10.64.6.22) by DFLE103.ent.ti.com
 (10.64.6.24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2308.14; Mon, 28
 Mar 2022 03:13:57 -0500
Received: from lelv0326.itg.ti.com (10.180.67.84) by DFLE101.ent.ti.com
 (10.64.6.22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2308.14 via
 Frontend Transport; Mon, 28 Mar 2022 03:13:57 -0500
Received: from [10.250.232.209] (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0326.itg.ti.com (8.15.2/8.15.2) with ESMTP id 22S8Dr0C018651;
        Mon, 28 Mar 2022 03:13:53 -0500
Message-ID: <300da7e6-a72f-e7a1-f430-e1e26752594f@ti.com>
Date:   Mon, 28 Mar 2022 13:43:51 +0530
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH] net: phy: mscc: enable MAC SerDes autonegotiation
Content-Language: en-US
To:     Raag Jadav <raagjadav@gmail.com>
CC:     "Russell King (Oracle)" <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Steen Hegelund <steen.hegelund@microchip.com>,
        Bjarni Jonasson <bjarni.jonasson@microchip.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <1644043492-31307-1-git-send-email-raagjadav@gmail.com>
 <YhdimdT1qLdGqPAW@shell.armlinux.org.uk> <20220226072327.GA6830@localhost>
 <846b6171-2acd-1e03-8cd8-827bf5437636@ti.com>
 <20220327083012.GA3254@localhost>
From:   Siddharth Vadapalli <s-vadapalli@ti.com>
In-Reply-To: <20220327083012.GA3254@localhost>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Raag,

On 27/03/22 14:00, Raag Jadav wrote:
> On Thu, Mar 24, 2022 at 03:36:02PM +0530, Siddharth Vadapalli wrote:
>> Hi Raag,
>>
>> On 26/02/22 12:53, Raag Jadav wrote:
>>> On Thu, Feb 24, 2022 at 10:48:57AM +0000, Russell King (Oracle) wrote:
>>>> Sorry for the late comment on this patch.
>>>>
>>>> On Sat, Feb 05, 2022 at 12:14:52PM +0530, Raag Jadav wrote:
>>>>> +static int vsc85xx_config_inband_aneg(struct phy_device *phydev, bool enabled)
>>>>> +{
>>>>> +	int rc;
>>>>> +	u16 reg_val = 0;
>>>>> +
>>>>> +	if (enabled)
>>>>> +		reg_val = MSCC_PHY_SERDES_ANEG;
>>>>> +
>>>>> +	mutex_lock(&phydev->lock);
>>>>> +
>>>>> +	rc = phy_modify_paged(phydev, MSCC_PHY_PAGE_EXTENDED_3,
>>>>> +			      MSCC_PHY_SERDES_PCS_CTRL, MSCC_PHY_SERDES_ANEG,
>>>>> +			      reg_val);
>>>>> +
>>>>> +	mutex_unlock(&phydev->lock);
>>>>
>>>> What is the reason for the locking here?
>>>>
>>>> phy_modify_paged() itself is safe due to the MDIO bus lock, so you
>>>> shouldn't need locking around it.
>>>>
>>>
>>> True.
>>>
>>> My initial thought was to have serialized access at PHY level,
>>> as we have multiple ports to work with.
>>> But I guess MDIO bus lock could do the job as well.
>>>
>>> Will fix it in v2 if required.
>>
>> Could you please let me know if you plan to post the v2 patch?
>>
>> The autonegotiation feature is also required for VSC8514, and has to be invoked
>> in vsc8514_config_init(). Let me know if you need my help for this.
>>
> 
> Maybe this is what you're looking for.
> https://www.spinics.net/lists/netdev/msg768517.html

Thank you for pointing me to the thread. I will follow up regarding the progress
of the autonegotiation feature on that thread.

Regards,
Siddharth
