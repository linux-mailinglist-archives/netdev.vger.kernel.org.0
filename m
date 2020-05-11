Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3C111CDA77
	for <lists+netdev@lfdr.de>; Mon, 11 May 2020 14:50:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727792AbgEKMu2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 May 2020 08:50:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726934AbgEKMu2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 May 2020 08:50:28 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FB01C061A0C
        for <netdev@vger.kernel.org>; Mon, 11 May 2020 05:50:28 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id j5so10816853wrq.2
        for <netdev@vger.kernel.org>; Mon, 11 May 2020 05:50:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=7bkkiFTxdZm0ufAKtT0Rv71LTDcG2tlQdV4w5dBRlnc=;
        b=VdTj9t3shF/XOlIHi8hFV2LIDGfLpBakSs9SqaLBSF4ztIuW8VVocuSqzcWGn4zhOr
         MU0ysBD1cynPoWl/cKE6/Rxrr4V/JpZCQR8Pj4NhcSscvwdMdwZW85OkxftvzVme74MW
         BDyJD4ejZ5XBbrc/rNkaRbnVQGghbAzr0jrjI/MD7E37h6LbW3CD44QsBOJBwjsagPhj
         F2/1dmQ5kljpyj1gkNNlLnqT0j9Xs+RVolRMY/aN3RmnppzVvjxTYW2GoeRNz3DBcQEA
         ccS0rgqlO8uJbLnkpH4c0rDbPxQD72FgM3lvjkcL1siLnSEx1DQOShM+6p+uqPdWPC3V
         1b+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=7bkkiFTxdZm0ufAKtT0Rv71LTDcG2tlQdV4w5dBRlnc=;
        b=hi/xpue0qEoOFc/YL1TmtIsayDOvl9hCmG/WqqcvxgkXmZHaashsZ5zF2LLg4i5Gv3
         MxgOa0tSi2K8FmBVfuTBX0tovdBRJ9sEFNHSnVDLw2gttSvQfL9UCr/DCM26DBiABFcc
         +rx7f+87bHnHylynC9IH+ryAqzn7HAA4OczuISyo6poOV3Jd1fayZaxYe+o10l3QiJZL
         r+9ZvYdunQMh0Ic+zxnQnKV/Oxu+sGY74dV1fNFgmbguj4tfgLWR/q9BwyacFvEB5lFL
         iYa0cgwXTIQOVdIVgHsaaH+E05clHO43JMrAXJZ4mGty9DbUOWn1ok1ElaGOUB8wF/Lv
         RIwA==
X-Gm-Message-State: AGi0PuYdYFUsMjWbtTAT/YhhtYKb+NZSQ9Z6WWwqQs17dzQbrElIJDoV
        uypkUETMTBthwWaGy9OROPKYxxrZ
X-Google-Smtp-Source: APiQypJ97l2lxgYirdh4Bgi0Xa8gw98b2ERlhmP5C1myc+y3Dra/Eyaw7jIsh3QwtuqOUIQwAatmLQ==
X-Received: by 2002:a5d:4b45:: with SMTP id w5mr19698132wrs.358.1589201426500;
        Mon, 11 May 2020 05:50:26 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f28:5200:c84b:195f:9500:f238? (p200300EA8F285200C84B195F9500F238.dip0.t-ipconnect.de. [2003:ea:8f28:5200:c84b:195f:9500:f238])
        by smtp.googlemail.com with ESMTPSA id s11sm17356407wrp.79.2020.05.11.05.50.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 May 2020 05:50:25 -0700 (PDT)
Subject: Re: [PATCH net-next 1/2] net: phy: check for aneg disabled and half
 duplex in phy_ethtool_set_eee
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <8e7df680-e3c2-24ae-81d3-e24776583966@gmail.com>
 <0c8429c2-7498-efe8-c223-da3d17b1e8e6@gmail.com>
 <20200510140521.GM1551@shell.armlinux.org.uk>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <01a6a1b2-39cc-531a-18be-44a59a5e7441@gmail.com>
Date:   Mon, 11 May 2020 14:50:23 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200510140521.GM1551@shell.armlinux.org.uk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10.05.2020 16:05, Russell King - ARM Linux admin wrote:
> On Sun, May 10, 2020 at 10:11:33AM +0200, Heiner Kallweit wrote:
>> EEE requires aneg and full duplex, therefore return EPROTONOSUPPORT
>> if aneg is disabled or aneg resulted in a half duplex mode.
> 
> I think this is completely wrong.  This is the ethtool configuration
> interface for EEE that you're making fail.
> 
You mentioned in a parallel response that you are aware of at least
userspace tool / use case that would be broken by this change.
Can you please point me to this tool / use case?

> Why should you not be able to configure EEE parameters if the link
> happens to negotiated a half-duplex?  Why should you not be able to
> adjust the EEE advertisment via ethtool if the link has negotiated
> half-duplex?
> 
> Why should any of this configuration depend on the current state?
> 
If EEE settings change, then phy_ethtool_set_eee() eventually
calls genphy_restart_aneg() which sets bits BMCR_ANENABLE in the
chip. Means if we enter the function with phydev->autoneg being
cleared, then we'll end up with an inconsistent state
(phydev->autoneg not reflecting chip aneg setting).
As alternative to throwing an error we could skip triggering an
aneg, what would you prefer?

> Why should we force people to negotiate a FD link before they can
> then configure EEE, and then have to perform a renegotiation?
> 
If being in a HD mode and setting EEE returns with a success return
code, then users may expect EEE to be active (what it is not).

> Sorry, but to me this patch seems to be a completely wrong approach,
> and I really don't get what problem it is trying to fix.
> 
>>
>> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
>> ---
>>  drivers/net/phy/phy.c | 3 +++
>>  1 file changed, 3 insertions(+)
>>
>> diff --git a/drivers/net/phy/phy.c b/drivers/net/phy/phy.c
>> index 8c22d02b4..891bb6929 100644
>> --- a/drivers/net/phy/phy.c
>> +++ b/drivers/net/phy/phy.c
>> @@ -1110,6 +1110,9 @@ int phy_ethtool_set_eee(struct phy_device *phydev, struct ethtool_eee *data)
>>  	if (!phydev->drv)
>>  		return -EIO;
>>  
>> +	if (phydev->autoneg == AUTONEG_DISABLE || phydev->duplex == DUPLEX_HALF)
>> +		return -EPROTONOSUPPORT;
>> +
>>  	/* Get Supported EEE */
>>  	cap = phy_read_mmd(phydev, MDIO_MMD_PCS, MDIO_PCS_EEE_ABLE);
>>  	if (cap < 0)
>> -- 
>> 2.26.2
>>
>>
>>
> 

