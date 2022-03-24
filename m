Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 670794E6178
	for <lists+netdev@lfdr.de>; Thu, 24 Mar 2022 11:06:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245479AbiCXKIC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Mar 2022 06:08:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349401AbiCXKH5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Mar 2022 06:07:57 -0400
Received: from lelv0142.ext.ti.com (lelv0142.ext.ti.com [198.47.23.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14F889F6D7;
        Thu, 24 Mar 2022 03:06:24 -0700 (PDT)
Received: from lelv0265.itg.ti.com ([10.180.67.224])
        by lelv0142.ext.ti.com (8.15.2/8.15.2) with ESMTP id 22OA68Lc102802;
        Thu, 24 Mar 2022 05:06:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1648116368;
        bh=XuSM+SWpQxW85C7aLKWpG8Av4KyR7imSTqKnTSbtJEA=;
        h=Date:Subject:To:CC:References:From:In-Reply-To;
        b=gKUBRbj8jYzcJDrf0q9Eo2WJTYr7WLGs4JLwD0SiUEnwk4XupZ7W/LdpSDsoQzYx8
         cJcvkBmo/PF7BvMwvOnK1nmA9Px5ZYhc+79LBq/sXxZ8CDItPNVx2vpJGgsYtmkMOM
         e+rAhK+HMIWSLk0c8Fvftu8pVfe9X/SPef+bqjVE=
Received: from DLEE108.ent.ti.com (dlee108.ent.ti.com [157.170.170.38])
        by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 22OA68kV024494
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 24 Mar 2022 05:06:08 -0500
Received: from DLEE113.ent.ti.com (157.170.170.24) by DLEE108.ent.ti.com
 (157.170.170.38) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2308.14; Thu, 24
 Mar 2022 05:06:07 -0500
Received: from lelv0327.itg.ti.com (10.180.67.183) by DLEE113.ent.ti.com
 (157.170.170.24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2308.14 via
 Frontend Transport; Thu, 24 Mar 2022 05:06:07 -0500
Received: from [10.250.232.209] (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id 22OA63jT075746;
        Thu, 24 Mar 2022 05:06:04 -0500
Message-ID: <846b6171-2acd-1e03-8cd8-827bf5437636@ti.com>
Date:   Thu, 24 Mar 2022 15:36:02 +0530
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
From:   Siddharth Vadapalli <s-vadapalli@ti.com>
In-Reply-To: <20220226072327.GA6830@localhost>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Raag,

On 26/02/22 12:53, Raag Jadav wrote:
> On Thu, Feb 24, 2022 at 10:48:57AM +0000, Russell King (Oracle) wrote:
>> Sorry for the late comment on this patch.
>>
>> On Sat, Feb 05, 2022 at 12:14:52PM +0530, Raag Jadav wrote:
>>> +static int vsc85xx_config_inband_aneg(struct phy_device *phydev, bool enabled)
>>> +{
>>> +	int rc;
>>> +	u16 reg_val = 0;
>>> +
>>> +	if (enabled)
>>> +		reg_val = MSCC_PHY_SERDES_ANEG;
>>> +
>>> +	mutex_lock(&phydev->lock);
>>> +
>>> +	rc = phy_modify_paged(phydev, MSCC_PHY_PAGE_EXTENDED_3,
>>> +			      MSCC_PHY_SERDES_PCS_CTRL, MSCC_PHY_SERDES_ANEG,
>>> +			      reg_val);
>>> +
>>> +	mutex_unlock(&phydev->lock);
>>
>> What is the reason for the locking here?
>>
>> phy_modify_paged() itself is safe due to the MDIO bus lock, so you
>> shouldn't need locking around it.
>>
> 
> True.
> 
> My initial thought was to have serialized access at PHY level,
> as we have multiple ports to work with.
> But I guess MDIO bus lock could do the job as well.
> 
> Will fix it in v2 if required.

Could you please let me know if you plan to post the v2 patch?

The autonegotiation feature is also required for VSC8514, and has to be invoked
in vsc8514_config_init(). Let me know if you need my help for this.

Regards,
Siddharth
