Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15F181D2131
	for <lists+netdev@lfdr.de>; Wed, 13 May 2020 23:36:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729469AbgEMVgf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 May 2020 17:36:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729411AbgEMVgd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 May 2020 17:36:33 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AA02C061A0C;
        Wed, 13 May 2020 14:36:33 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id t11so328782pgg.2;
        Wed, 13 May 2020 14:36:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=VpoOJn6i4aDVNgvde4W3X1iXzGR+JdKQ0KKW5fvKRLM=;
        b=NbjpkCzzP0ogAOfWyMX34L9+J9RSyWacyH0Bru23JzuNUIbJNWckgPEZb8vjM2easr
         AyNN/1V4LJLm2rdw3Qdd4skiAG/dBF5dZaaG7c6W0zulNcnm5uRd4b+/aDc+hsaRPo6F
         c/nVTvuGyeq1IbtkDv10e17DA9sTnJKC3rv050qzxO7xvpH1XlIlsbMZ4PNPZHM0IryU
         NRuZDzcfsigT2VPoIis8KHg5Khi+woQN3fSqXwMUzEofEHiXW+QsKmvxq3UpDzWi0qwB
         zvH8fzAL4PB3KLh/UOAAksU268sXIEt3JlsiRDOft4kpJoE3C28Xr9fTT9hAW2cngA/n
         jpsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=VpoOJn6i4aDVNgvde4W3X1iXzGR+JdKQ0KKW5fvKRLM=;
        b=AH8R3NYOiXVf9KodpceSWMvYBhfgLWDxzvlmVjVZbWncORjRL0g+LQOZpAux/83ZNM
         B8mQBJKLglFE+Gcy8Bbd1MOPRSnR1iiM3JmalB5qamq3ieFM0snNryQW68d0BSD5RpvO
         iNsjMH7mkH3V6wMGesqNbe1EJnZgKlVA5FkperVY0jBI+TJHcNg2BZParSZLa1g6slbC
         jRKKGebQbdt3XDTIFuQ8SxX4qJ40V+RkfmtLHyqCHRj0Rtp8n0josxpvTv/lWX8YxXXF
         HrIW5AVHbXi/k98zIiMtwPWZV8Z6YYp7sMQ00KTKoPksPhz7Mrg/0deZ5N0rSQw+mbPE
         aFxA==
X-Gm-Message-State: AOAM532Ctk2RrJbpe8nwsfBQO2iSQ3pmkQBbixtiV+ByygRWAoX1jadd
        j1O2/u87YeQiXGurGyPf1K+WIoyj
X-Google-Smtp-Source: ABdhPJywhvQAU47EyT10Pm5UNvQu0HhjDddVgU8TUwiNxfEQ9l6J2cgIB01RpFPiWGUQ3gGmRdOKiA==
X-Received: by 2002:a63:c34a:: with SMTP id e10mr1231638pgd.132.1589405792528;
        Wed, 13 May 2020 14:36:32 -0700 (PDT)
Received: from [10.230.191.242] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 62sm420679pfu.181.2020.05.13.14.36.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 May 2020 14:36:32 -0700 (PDT)
Subject: Re: [PATCH net-next 3/4] net: ethernet: introduce phy_set_pause
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        bcm-kernel-feedback-list@broadcom.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1589243050-18217-1-git-send-email-opendmb@gmail.com>
 <1589243050-18217-4-git-send-email-opendmb@gmail.com>
 <20200513094239.GG1551@shell.armlinux.org.uk>
From:   Doug Berger <opendmb@gmail.com>
Message-ID: <7cd0e092-0896-4dc5-66a9-7213e92b3060@gmail.com>
Date:   Wed, 13 May 2020 14:39:21 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200513094239.GG1551@shell.armlinux.org.uk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/13/2020 2:42 AM, Russell King - ARM Linux admin wrote:
> On Mon, May 11, 2020 at 05:24:09PM -0700, Doug Berger wrote:
>> This commit introduces the phy_set_pause function to the phylib as
>> a helper to support the set_pauseparam ethtool method.
>>
>> It is hoped that the new behavior introduced by this function will
>> be widely embraced and the phy_set_sym_pause and phy_set_asym_pause
>> functions can be deprecated. Those functions are retained for all
>> existing users and for any desenting opinions on my interpretation
>> of the functionality.
>>
>> Signed-off-by: Doug Berger <opendmb@gmail.com>
>> ---
>>  drivers/net/phy/phy_device.c | 31 +++++++++++++++++++++++++++++++
>>  include/linux/phy.h          |  1 +
>>  2 files changed, 32 insertions(+)
>>
>> diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
>> index 48ab9efa0166..e6dafb3c3e5f 100644
>> --- a/drivers/net/phy/phy_device.c
>> +++ b/drivers/net/phy/phy_device.c
>> @@ -2614,6 +2614,37 @@ void phy_set_asym_pause(struct phy_device *phydev, bool rx, bool tx)
>>  EXPORT_SYMBOL(phy_set_asym_pause);
>>  
>>  /**
>> + * phy_set_pause - Configure Pause and Asym Pause with autoneg
>> + * @phydev: target phy_device struct
>> + * @rx: Receiver Pause is supported
>> + * @tx: Transmit Pause is supported
>> + * @autoneg: Auto neg should be used
>> + *
>> + * Description: Configure advertised Pause support depending on if
>> + * receiver pause and pause auto neg is supported. Generally called
>> + * from the set_pauseparam ethtool_ops.
>> + *
>> + * Note: Since pause is really a MAC level function it should be
>> + * notified via adjust_link to update its pause functions.
>> + */
>> +void phy_set_pause(struct phy_device *phydev, bool rx, bool tx, bool autoneg)
>> +{
>> +	linkmode_set_pause(phydev->advertising, tx, rx, autoneg);
>> +
>> +	/* Reset the state of an already running link to force a new
>> +	 * link up event when advertising doesn't change or when PHY
>> +	 * autoneg is disabled.
>> +	 */
>> +	mutex_lock(&phydev->lock);
>> +	if (phydev->state == PHY_RUNNING)
>> +		phydev->state = PHY_UP;
>> +	mutex_unlock(&phydev->lock);
> 
> I wonder about this - will drivers cope with having two link-up events
> via adjust_link without a corresponding link-down event?  What if they
> touch registers that are only supposed to be touched while the link is
> down?  Obviously, drivers have to opt-in to this interface, so it may
> be okay provided we don't get wholesale changes.
I too wonder about this. That's why I brought it up in the cover letter
to this set. I would prefer a cleaner service interface for this kind of
behavior for the reasons described in the cover letter, but thought this
might be acceptable.

>> +
>> +	phy_start_aneg(phydev);
> 
> Should we be making that conditional on something changing and autoneg
> being enabled, like phy_set_asym_pause() does?  There is no point
> interrupting an established link if the advertisement didn't change.
Again this is described in the cover letter but repeated here:
"The third introduces the phy_set_pause() function based on the existing
phy_set_asym_pause() implementation. One aberration here is the direct
manipulation of the phy state machine to allow a new link up event to
notify the MAC that the pause parameters may have changed. This is a
convenience to simplify the MAC driver by allowing one implementation
of the pause configuration logic to be located in its adjust_link
callback. Otherwise, the MAC driver would need to handle configuring
the pause parameters for an already active PHY link which would likely
require additional synchronization logic to protect the logic from
asynchronous changes in the PHY state.

The logic in phy_set_asym_pause() that looks for a change in
advertising is not particularly helpful here since now a change from
tx=1 rx=1 to tx=0 rx=1 no longer changes the advertising if autoneg is
enabled so phy_start_aneg() would not be called. I took the alternate
approach of unconditionally calling phy_start_aneg() since it
accommodates both manual and autoneg configured links. The "aberrant"
logic allows manually configured and autonegotiated links that don't
change their advertised parameters to receive an adjust_link call to
act on pause parameters that have no effect on the PHY layer.

It seemed excessive to bring the PHY down and back up when nogotiation
is not necessary, but that could be an alternative approach. I am
certainly open to any suggestions on how to improve that portion of
the code if it is controversial and a consensus can be reached."

>> +}
>> +EXPORT_SYMBOL(phy_set_pause);
>> +
>> +/**
>>   * phy_validate_pause - Test if the PHY/MAC support the pause configuration
>>   * @phydev: phy_device struct
>>   * @pp: requested pause configuration
>> diff --git a/include/linux/phy.h b/include/linux/phy.h
>> index 5d8ff5428010..71e484424e68 100644
>> --- a/include/linux/phy.h
>> +++ b/include/linux/phy.h
>> @@ -1403,6 +1403,7 @@ void phy_support_asym_pause(struct phy_device *phydev);
>>  void phy_set_sym_pause(struct phy_device *phydev, bool rx, bool tx,
>>  		       bool autoneg);
>>  void phy_set_asym_pause(struct phy_device *phydev, bool rx, bool tx);
>> +void phy_set_pause(struct phy_device *phydev, bool rx, bool tx, bool autoneg);
>>  bool phy_validate_pause(struct phy_device *phydev,
>>  			struct ethtool_pauseparam *pp);
>>  void phy_get_pause(struct phy_device *phydev, bool *tx_pause, bool *rx_pause);
>> -- 
>> 2.7.4
>>
>>
> 

