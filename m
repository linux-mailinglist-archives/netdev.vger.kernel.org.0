Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9902E193481
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 00:21:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727498AbgCYXVz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Mar 2020 19:21:55 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:39361 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727389AbgCYXVz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Mar 2020 19:21:55 -0400
Received: by mail-wr1-f65.google.com with SMTP id p10so5647001wrt.6
        for <netdev@vger.kernel.org>; Wed, 25 Mar 2020 16:21:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=S+jH2eiKfN+WQNk03Ej74RnfmlcrpGydeOjmlJLZ8DM=;
        b=b9w77pgaHd+qI1CkEkrVeqV7tFN6QRoJYvx5H7gHC47OO9PpfVzdgoeh2h45X8iXV0
         iqKiJ1ZMKoPVVe9PsaNpAorTnhZCWq6M66t3hNdTDAvDseafmF0K4o5K5MyK6ux8Gew8
         V5CiMmxeW6fHu4Y01PMpgFgGldQW2IbhHHrYYdSKeVF+P3h8zHnI40Vk5oHuFDndXe6f
         HkNtldWrGT1orUH/gMP9LMo6AAWNInuDTmr6gSI1p7EE+XhCeUC98nCisiShncWUbOQu
         HaXZ7PdInmruUVZ4pNap1h0ZwAnTLiZjiDT+pNpNsXr++LDgnJpyWPRf8WcYWIEb06Ea
         dkww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=S+jH2eiKfN+WQNk03Ej74RnfmlcrpGydeOjmlJLZ8DM=;
        b=ulzkH26VQmO8S8bvAoW0LDL42hZE/gSa/Lap/PjDOpBLYdXLYQI9Jdg1xPkGDVJMxG
         aHC3tKgP+RBuNZEBAu4I1pdkTfEvVWUsXtwgDGYYut+KNL+MWpbz3y0cpLQGRwPpe4d3
         PLP6UGh1UISjUrB4Ps9fhrzBw72UaDWK4u8h5znWRKB7X/WNYwcp5WFqB7jFH1xV+ZdH
         8n5nWO1IK+gXw+1AnebrhYcqoabMSvVxHTdMbLheWNZtgRN0jsnioJWk/uw5rD8q/L7e
         4ZvLxhrXX4LgLWuXNtgOM83RH80WICJ8nmlM1TOj0eFUXtIcvA6d91bLvVxXu7AV9qdE
         rjXQ==
X-Gm-Message-State: ANhLgQ0VCALskH3CgHpp/3OoJvFgAfVxTz04wWk/ljz67RDVbl3kh3+G
        vyPB5MIP/BInZYVsNdSmajCGG8tY
X-Google-Smtp-Source: ADFU+vvvIdfl85H9o5pxsV4UyP6zuI4L87fL7zcVuTzmHoUxsfxoNNpzaltNJnD+kC49tmc96b0dmg==
X-Received: by 2002:adf:9cca:: with SMTP id h10mr5839310wre.167.1585178513123;
        Wed, 25 Mar 2020 16:21:53 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f29:6000:7875:5b5d:92c0:cb32? (p200300EA8F29600078755B5D92C0CB32.dip0.t-ipconnect.de. [2003:ea:8f29:6000:7875:5b5d:92c0:cb32])
        by smtp.googlemail.com with ESMTPSA id r3sm753703wrm.35.2020.03.25.16.21.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 25 Mar 2020 16:21:52 -0700 (PDT)
Subject: Re: [PATCH v2 net-next 02/10] net: phy: bcm7xx: Add jumbo frame
 configuration to PHY
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        murali.policharla@broadcom.com,
        Stephen Hemminger <stephen@networkplumber.org>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>,
        netdev <netdev@vger.kernel.org>
References: <20200325152209.3428-1-olteanv@gmail.com>
 <20200325152209.3428-3-olteanv@gmail.com>
 <ec070d0f-3712-8663-f39f-124b7f802450@gmail.com>
 <CA+h21hrJyxDX98dzY0TbySKqXvC1+jkNJb0z+17LPOSN8=WeqA@mail.gmail.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <36655415-551d-11e7-a834-10bb6f07b2d0@gmail.com>
Date:   Thu, 26 Mar 2020 00:21:45 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <CA+h21hrJyxDX98dzY0TbySKqXvC1+jkNJb0z+17LPOSN8=WeqA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 25.03.2020 23:45, Vladimir Oltean wrote:
> On Wed, 25 Mar 2020 at 17:44, Heiner Kallweit <hkallweit1@gmail.com> wrote:
>>
>> On 25.03.2020 16:22, Vladimir Oltean wrote:
>>> From: Murali Krishna Policharla <murali.policharla@broadcom.com>
>>>
>>> Add API to configure jumbo frame settings in PHY during initial PHY
>>> configuration.
>>>
>>> Signed-off-by: Murali Krishna Policharla <murali.policharla@broadcom.com>
>>> Reviewed-by: Scott Branden <scott.branden@broadcom.com>
>>> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
>>> ---
>>>  drivers/net/phy/bcm-phy-lib.c | 28 ++++++++++++++++++++++++++++
>>>  drivers/net/phy/bcm-phy-lib.h |  1 +
>>>  drivers/net/phy/bcm7xxx.c     |  4 ++++
>>>  include/linux/brcmphy.h       |  1 +
>>>  4 files changed, 34 insertions(+)
>>>
>>> diff --git a/drivers/net/phy/bcm-phy-lib.c b/drivers/net/phy/bcm-phy-lib.c
>>> index e0d3310957ff..a26c80e13b43 100644
>>> --- a/drivers/net/phy/bcm-phy-lib.c
>>> +++ b/drivers/net/phy/bcm-phy-lib.c
>>> @@ -423,6 +423,34 @@ int bcm_phy_28nm_a0b0_afe_config_init(struct phy_device *phydev)
>>>  }
>>>  EXPORT_SYMBOL_GPL(bcm_phy_28nm_a0b0_afe_config_init);
>>>
>>> +int bcm_phy_enable_jumbo(struct phy_device *phydev)
>>> +{
>>> +     int val = 0, ret = 0;
>>> +
>>> +     ret = phy_write(phydev, MII_BCM54XX_AUX_CTL,
>>> +                     MII_BCM54XX_AUXCTL_SHDWSEL_MISC);
>>> +     if (ret < 0)
>>> +             return ret;
>>> +
>>> +     val = phy_read(phydev, MII_BCM54XX_AUX_CTL);
>>> +
>>> +     /* Enable extended length packet reception */
>>> +     val |= MII_BCM54XX_AUXCTL_ACTL_EXT_PKT_LEN;
>>> +     ret = phy_write(phydev, MII_BCM54XX_AUX_CTL, val);
>>> +
>>
>> There are different helpers already in bcm-phy-lib,
>> e.g. bcm54xx_auxctl_read. Also bcm_phy_write_misc()
>> has has quite something in common with your new function.
>> It would be good if a helper could be used here.
>>
> 
> Thanks Heiner.
> I'm not quite sure the operation is performed correctly though? My
> books are telling me that the "Receive Extended Packet Length" field
> is accessible via the Auxiliary Control Register 0x18 when the shadow
> value is 000, not 111 as this patch is doing. At least for BCM54xxx in
> terms of which the macros are defined. Am I wrong?
> 

I didn't check the datasheet, so I can't really comment on whether the
patch does what it is supposed to do. My point was that the following
pattern occurs several times in the driver:
phy_write(phydev, MII_BCM54XX_AUX_CTL, VAL_1);
phy_modify(phydev, MII_BCM54XX_AUX_CTL, VAL_2, VAL_3)
(or phy_clear_bits/phy_set_bits instead of phy_modify)

Therefore a generic helper could make sense, or it could at least be
written as such a two-liner always.

>>> +     if (ret < 0)
>>> +             return ret;
>>> +
>>> +     val = phy_read(phydev, MII_BCM54XX_ECR);
>>> +
>>> +     /* Enable 10K byte packet length reception */
>>> +     val |= BIT(0);
>>> +     ret =  phy_write(phydev, MII_BCM54XX_ECR, val);
>>> +
>>
>> Why not use phy_set_bits() ?
>>
> 
> Well, the reason is that I didn't write the patch. I'll simplify it.
> 
>>> +     return ret;
>>> +}
>>> +EXPORT_SYMBOL_GPL(bcm_phy_enable_jumbo);
>>> +
>>>  MODULE_DESCRIPTION("Broadcom PHY Library");
>>>  MODULE_LICENSE("GPL v2");
>>>  MODULE_AUTHOR("Broadcom Corporation");
>>> diff --git a/drivers/net/phy/bcm-phy-lib.h b/drivers/net/phy/bcm-phy-lib.h
>>> index c86fb9d1240c..129df819be8c 100644
>>> --- a/drivers/net/phy/bcm-phy-lib.h
>>> +++ b/drivers/net/phy/bcm-phy-lib.h
>>> @@ -65,5 +65,6 @@ void bcm_phy_get_stats(struct phy_device *phydev, u64 *shadow,
>>>                      struct ethtool_stats *stats, u64 *data);
>>>  void bcm_phy_r_rc_cal_reset(struct phy_device *phydev);
>>>  int bcm_phy_28nm_a0b0_afe_config_init(struct phy_device *phydev);
>>> +int bcm_phy_enable_jumbo(struct phy_device *phydev);
>>>
>>>  #endif /* _LINUX_BCM_PHY_LIB_H */
>>> diff --git a/drivers/net/phy/bcm7xxx.c b/drivers/net/phy/bcm7xxx.c
>>> index af8eabe7a6d4..692048d86ab1 100644
>>> --- a/drivers/net/phy/bcm7xxx.c
>>> +++ b/drivers/net/phy/bcm7xxx.c
>>> @@ -178,6 +178,10 @@ static int bcm7xxx_28nm_config_init(struct phy_device *phydev)
>>>               break;
>>>       }
>>>
>>> +     if (ret)
>>> +             return ret;
>>> +
>>> +     ret =  bcm_phy_enable_jumbo(phydev);
>>>       if (ret)
>>>               return ret;
>>>
>>> diff --git a/include/linux/brcmphy.h b/include/linux/brcmphy.h
>>> index b475e7f20d28..19bd86019e93 100644
>>> --- a/include/linux/brcmphy.h
>>> +++ b/include/linux/brcmphy.h
>>> @@ -119,6 +119,7 @@
>>>  #define MII_BCM54XX_AUXCTL_SHDWSEL_AUXCTL    0x00
>>>  #define MII_BCM54XX_AUXCTL_ACTL_TX_6DB               0x0400
>>>  #define MII_BCM54XX_AUXCTL_ACTL_SMDSP_ENA    0x0800
>>> +#define MII_BCM54XX_AUXCTL_ACTL_EXT_PKT_LEN  0x4000
>>>
>>>  #define MII_BCM54XX_AUXCTL_SHDWSEL_MISC                      0x07
>>>  #define MII_BCM54XX_AUXCTL_SHDWSEL_MISC_WIRESPEED_EN 0x0010
>>>
>>
> 
> Regards,
> -Vladimir
> .
> 

