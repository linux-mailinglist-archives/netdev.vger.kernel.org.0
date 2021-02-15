Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76DCB31B875
	for <lists+netdev@lfdr.de>; Mon, 15 Feb 2021 12:57:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230119AbhBOL4U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Feb 2021 06:56:20 -0500
Received: from fllv0015.ext.ti.com ([198.47.19.141]:46482 "EHLO
        fllv0015.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229895AbhBOL4S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Feb 2021 06:56:18 -0500
Received: from fllv0034.itg.ti.com ([10.64.40.246])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 11FBtEdk051330;
        Mon, 15 Feb 2021 05:55:14 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1613390114;
        bh=evOhiN5iqq5MDuW2y+VKX24pQNbwurTcJH8VQqHMCFg=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=CA5JrEwLGZFhs9rtWBnDJp0k4yJ8iD259/1g8qfTwH5yDJaMQot9jlkqlhsSmXGZF
         gOjMX6sc1bUaRZTMUaDwPHQyPN3dwXIbuRZqPwm72HGFPQ+XbQWG5xhmWb9gFAmh3E
         BaZvNJVKl4ks+tdnfGL7TgCAz60nEJRiFvK9Vtq0=
Received: from DLEE109.ent.ti.com (dlee109.ent.ti.com [157.170.170.41])
        by fllv0034.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 11FBtEvf013131
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 15 Feb 2021 05:55:14 -0600
Received: from DLEE105.ent.ti.com (157.170.170.35) by DLEE109.ent.ti.com
 (157.170.170.41) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Mon, 15
 Feb 2021 05:55:14 -0600
Received: from lelv0326.itg.ti.com (10.180.67.84) by DLEE105.ent.ti.com
 (157.170.170.35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Mon, 15 Feb 2021 05:55:14 -0600
Received: from [10.250.234.133] (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0326.itg.ti.com (8.15.2/8.15.2) with ESMTP id 11FBtAS4077334;
        Mon, 15 Feb 2021 05:55:11 -0600
Subject: Re: [PATCH v14 2/4] phy: Add media type and speed serdes
 configuration interfaces
To:     Steen Hegelund <steen.hegelund@microchip.com>,
        Vinod Koul <vkoul@kernel.org>
CC:     Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Bjarni Jonasson <bjarni.jonasson@microchip.com>,
        Microchip UNG Driver List <UNGLinuxDriver@microchip.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Andrew Lunn <andrew@lunn.ch>
References: <20210210085255.2006824-1-steen.hegelund@microchip.com>
 <20210210085255.2006824-3-steen.hegelund@microchip.com>
 <04d91f6b-775a-8389-b813-31f7b4a778cb@ti.com>
 <ffa00a2bf83ffa21ffdc61b380ab800c31f8cf28.camel@microchip.com>
From:   Kishon Vijay Abraham I <kishon@ti.com>
Message-ID: <704b850f-9345-2e36-e84b-b332fed22270@ti.com>
Date:   Mon, 15 Feb 2021 17:25:10 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <ffa00a2bf83ffa21ffdc61b380ab800c31f8cf28.camel@microchip.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Steen,

On 12/02/21 6:35 pm, Steen Hegelund wrote:
> Hi Kishon,
> 
> On Fri, 2021-02-12 at 17:02 +0530, Kishon Vijay Abraham I wrote:
>> EXTERNAL EMAIL: Do not click links or open attachments unless you
>> know the content is safe
>>
>> Hi Steen,
>>
>> On 10/02/21 2:22 pm, Steen Hegelund wrote:
>>> Provide new phy configuration interfaces for media type and speed
>>> that
>>> allows allows e.g. PHYs used for ethernet to be configured with
>>> this
>>> information.
>>>
>>> Signed-off-by: Lars Povlsen <lars.povlsen@microchip.com>
>>> Signed-off-by: Steen Hegelund <steen.hegelund@microchip.com>
>>> Reviewed-by: Andrew Lunn <andrew@lunn.ch>
>>> Reviewed-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
>>> ---
>>>  drivers/phy/phy-core.c  | 30 ++++++++++++++++++++++++++++++
>>>  include/linux/phy/phy.h | 26 ++++++++++++++++++++++++++
>>>  2 files changed, 56 insertions(+)
>>>
>>> diff --git a/drivers/phy/phy-core.c b/drivers/phy/phy-core.c
>>> index 71cb10826326..ccb575b13777 100644
>>> --- a/drivers/phy/phy-core.c
>>> +++ b/drivers/phy/phy-core.c
>>> @@ -373,6 +373,36 @@ int phy_set_mode_ext(struct phy *phy, enum
>>> phy_mode mode, int submode)
>>>  }
>>>  EXPORT_SYMBOL_GPL(phy_set_mode_ext);
>>>
>>> +int phy_set_media(struct phy *phy, enum phy_media media)
>>> +{
>>> +     int ret;
>>> +
>>> +     if (!phy || !phy->ops->set_media)
>>> +             return 0;
>>> +
>>> +     mutex_lock(&phy->mutex);
>>> +     ret = phy->ops->set_media(phy, media);
>>> +     mutex_unlock(&phy->mutex);
>>> +
>>> +     return ret;
>>> +}
>>> +EXPORT_SYMBOL_GPL(phy_set_media);
>>> +
>>> +int phy_set_speed(struct phy *phy, int speed)
>>> +{
>>> +     int ret;
>>> +
>>> +     if (!phy || !phy->ops->set_speed)
>>> +             return 0;
>>> +
>>> +     mutex_lock(&phy->mutex);
>>> +     ret = phy->ops->set_speed(phy, speed);
>>> +     mutex_unlock(&phy->mutex);
>>> +
>>> +     return ret;
>>> +}
>>> +EXPORT_SYMBOL_GPL(phy_set_speed);
>>
>> Can't speed derived from mode? Do we need a separate set_speed
>> function?
>>
>> Thanks
>> Kishon
> 
> Yes the client will need to be able to choose the speed as needed: 
> e.g. lower than the serdes mode supports, in case the the media or the
> other end is not capable of running that speed.  
> 
> An example is a 10G and 25G serdes connected via DAC and as there is no
> inband autoneg, the 25G client would have to manually select 10G speed
> to communicate with its partner.

Okay. Is it going to be some sort of manual negotiation where the
Ethernet controller invokes set_speed with different speeds? Or the
Ethernet controller will get the speed using some out of band mechanism
and invokes set_speed once with the actual speed?

Thanks
Kishon
> 
>>
>>> +
>>>  int phy_reset(struct phy *phy)
>>>  {
>>>       int ret;
>>> diff --git a/include/linux/phy/phy.h b/include/linux/phy/phy.h
>>> index e435bdb0bab3..e4fd69a1faa7 100644
>>> --- a/include/linux/phy/phy.h
>>> +++ b/include/linux/phy/phy.h
>>> @@ -44,6 +44,12 @@ enum phy_mode {
>>>       PHY_MODE_DP
>>>  };
>>>
>>> +enum phy_media {
>>> +     PHY_MEDIA_DEFAULT,
>>> +     PHY_MEDIA_SR,
>>> +     PHY_MEDIA_DAC,
>>> +};
>>> +
>>>  /**
>>>   * union phy_configure_opts - Opaque generic phy configuration
>>>   *
>>> @@ -64,6 +70,8 @@ union phy_configure_opts {
>>>   * @power_on: powering on the phy
>>>   * @power_off: powering off the phy
>>>   * @set_mode: set the mode of the phy
>>> + * @set_media: set the media type of the phy (optional)
>>> + * @set_speed: set the speed of the phy (optional)
>>>   * @reset: resetting the phy
>>>   * @calibrate: calibrate the phy
>>>   * @release: ops to be performed while the consumer relinquishes
>>> the PHY
>>> @@ -75,6 +83,8 @@ struct phy_ops {
>>>       int     (*power_on)(struct phy *phy);
>>>       int     (*power_off)(struct phy *phy);
>>>       int     (*set_mode)(struct phy *phy, enum phy_mode mode, int
>>> submode);
>>> +     int     (*set_media)(struct phy *phy, enum phy_media media);
>>> +     int     (*set_speed)(struct phy *phy, int speed);
>>>
>>>       /**
>>>        * @configure:
>>> @@ -215,6 +225,8 @@ int phy_power_off(struct phy *phy);
>>>  int phy_set_mode_ext(struct phy *phy, enum phy_mode mode, int
>>> submode);
>>>  #define phy_set_mode(phy, mode) \
>>>       phy_set_mode_ext(phy, mode, 0)
>>> +int phy_set_media(struct phy *phy, enum phy_media media);
>>> +int phy_set_speed(struct phy *phy, int speed);
>>>  int phy_configure(struct phy *phy, union phy_configure_opts
>>> *opts);
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
>>> +     return -ENOSYS;
>>> +}
>>> +
>>> +static inline int phy_set_speed(struct phy *phy, int speed)
>>> +{
>>> +     if (!phy)
>>> +             return 0;
>>> +     return -ENOSYS;
>>> +}
>>> +
>>>  static inline enum phy_mode phy_get_mode(struct phy *phy)
>>>  {
>>>       return PHY_MODE_INVALID;
>>>
> 
> 
> Thanks for your comments.
> 
> 
