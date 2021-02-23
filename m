Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67BA6322A6D
	for <lists+netdev@lfdr.de>; Tue, 23 Feb 2021 13:24:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232527AbhBWMXS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Feb 2021 07:23:18 -0500
Received: from fllv0016.ext.ti.com ([198.47.19.142]:36002 "EHLO
        fllv0016.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232316AbhBWMXP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Feb 2021 07:23:15 -0500
Received: from lelv0266.itg.ti.com ([10.180.67.225])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id 11NCMKs4017792;
        Tue, 23 Feb 2021 06:22:20 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1614082940;
        bh=EhWZj3kxi2xbFc+sNH7zq/wCO8MCdICSnmIsalBeMas=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=KXTsdsCpdMNOqaK4YajpxkOrPNWFiKgjSmKhjk5oJvRxuZF3oolSD6rzzjltQjfZz
         6L+uAeF3bqB4u0EXwQRkjB645Q5ye+EsYEuJydSQ94BN33z8mm4T3USrPPHzLLqnFi
         6MA/g7o7fm/L83mlgwYJO9YYrNwib3nG+27ymyOw=
Received: from DLEE100.ent.ti.com (dlee100.ent.ti.com [157.170.170.30])
        by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 11NCMK50031926
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 23 Feb 2021 06:22:20 -0600
Received: from DLEE109.ent.ti.com (157.170.170.41) by DLEE100.ent.ti.com
 (157.170.170.30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Tue, 23
 Feb 2021 06:22:19 -0600
Received: from fllv0039.itg.ti.com (10.64.41.19) by DLEE109.ent.ti.com
 (157.170.170.41) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Tue, 23 Feb 2021 06:22:19 -0600
Received: from [10.250.232.74] (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0039.itg.ti.com (8.15.2/8.15.2) with ESMTP id 11NCMFBc073064;
        Tue, 23 Feb 2021 06:22:16 -0600
Subject: Re: [PATCH v15 2/4] phy: Add media type and speed serdes
 configuration interfaces
To:     Steen Hegelund <steen.hegelund@microchip.com>,
        Leon Romanovsky <leon@kernel.org>
CC:     Vinod Koul <vkoul@kernel.org>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Bjarni Jonasson <bjarni.jonasson@microchip.com>,
        Microchip UNG Driver List <UNGLinuxDriver@microchip.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Andrew Lunn <andrew@lunn.ch>
References: <20210218161451.3489955-1-steen.hegelund@microchip.com>
 <20210218161451.3489955-3-steen.hegelund@microchip.com>
 <YDH20a2hP+HtBqHz@unreal>
 <94dad8f439dd870b3488130e82f50e28b81fccf1.camel@microchip.com>
From:   Kishon Vijay Abraham I <kishon@ti.com>
Message-ID: <c1b78a32-de24-c036-5a7a-7ef297cc5e3a@ti.com>
Date:   Tue, 23 Feb 2021 17:52:14 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <94dad8f439dd870b3488130e82f50e28b81fccf1.camel@microchip.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Leon,

On 22/02/21 1:30 pm, Steen Hegelund wrote:
> Hi Leon,
> 
> On Sun, 2021-02-21 at 07:59 +0200, Leon Romanovsky wrote:
>> EXTERNAL EMAIL: Do not click links or open attachments unless you
>> know the content is safe
>>
>> On Thu, Feb 18, 2021 at 05:14:49PM +0100, Steen Hegelund wrote:
>>> Provide new phy configuration interfaces for media type and speed
>>> that
>>> allows e.g. PHYs used for ethernet to be configured with this
>>> information.
>>>
>>> Signed-off-by: Lars Povlsen <lars.povlsen@microchip.com>
>>> Signed-off-by: Steen Hegelund <steen.hegelund@microchip.com>
>>> Reviewed-by: Andrew Lunn <andrew@lunn.ch>
>>> Reviewed-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
>>> ---
>>>
> 
> ...
> 
>>>  int phy_validate(struct phy *phy, enum phy_mode mode, int submode,
>>>                union phy_configure_opts *opts);
>>> @@ -344,6 +356,20 @@ static inline int phy_set_mode_ext(struct phy
>>> *phy, enum phy_mode mode,
>>>  #define phy_set_mode(phy, mode) \
>>>       phy_set_mode_ext(phy, mode, 0)
>>>
>>> +static inline int phy_set_media(struct phy *phy, enum phy_media
>>> media)
>>> +{
>>> +     if (!phy)
>>> +             return 0;
>>
>> I'm curious, why do you check for the NULL in all newly introduced
>> functions?
>> How is it possible that calls to phy_*() supply NULL as the main
>> struct?
>>
>> Thanks
> 
> I do not know the history of that, but all the functions in the
> interface that takes a phy as input and returns a status follow that
> pattern.  Maybe Kishon and Vinod knows the origin?

It is to make handling optional PHYs simpler. See here for the origin :-)
http://lore.kernel.org/r/1391264157-2112-1-git-send-email-andrew@lunn.ch

Thanks
Kishon
> 
>>
>>> +     return -ENODEV;
>>> +}
>>> +
>>> +static inline int phy_set_speed(struct phy *phy, int speed)
>>> +{
>>> +     if (!phy)
>>> +             return 0;
>>> +     return -ENODEV;
>>> +}
>>> +
>>>  static inline enum phy_mode phy_get_mode(struct phy *phy)
>>>  {
>>>       return PHY_MODE_INVALID;
>>> --
>>> 2.30.0
>>>
> 
> Best Regards
> Steen
> 
