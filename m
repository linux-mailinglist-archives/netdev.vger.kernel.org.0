Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE4F11AF79A
	for <lists+netdev@lfdr.de>; Sun, 19 Apr 2020 08:45:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725959AbgDSGpB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Apr 2020 02:45:01 -0400
Received: from guitar.tcltek.co.il ([192.115.133.116]:51491 "EHLO
        mx.tkos.co.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725446AbgDSGpB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 19 Apr 2020 02:45:01 -0400
Received: from tarshish (unknown [10.0.8.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx.tkos.co.il (Postfix) with ESMTPS id 0FE9C44046D;
        Sun, 19 Apr 2020 09:44:52 +0300 (IDT)
References: <18fe946c32093f50462e026090a9e32eb568c8c5.1587103852.git.baruch@tkos.co.il> <20200417154836.GB785713@lunn.ch>
User-agent: mu4e 1.2.0; emacs 26.1
From:   Baruch Siach <baruch@tkos.co.il>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH] net: phy: marvell10g: hwmon support for 2110
In-reply-to: <20200417154836.GB785713@lunn.ch>
Date:   Sun, 19 Apr 2020 09:44:45 +0300
Message-ID: <87blnoc6ua.fsf@tarshish>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,

On Fri, Apr 17 2020, Andrew Lunn wrote:
> On Fri, Apr 17, 2020 at 09:10:52AM +0300, Baruch Siach wrote:
>> Read the temperature sensor register from the correct location for the
>> 88E2110 PHY. There is no enable/disable bit, so leave
>> mv3310_hwmon_config() for 88X3310 only.
>
> Nice. Thanks for doing this.
>
>> @@ -191,7 +201,8 @@ static int mv3310_hwmon_probe(struct phy_device *phydev)
>>  	struct mv3310_priv *priv = dev_get_drvdata(&phydev->mdio.dev);
>>  	int i, j, ret;
>>  
>> -	if (phydev->drv->phy_id != MARVELL_PHY_ID_88X3310)
>> +	if (phydev->drv->phy_id != MARVELL_PHY_ID_88X3310 &&
>> +			phydev->drv->phy_id != MARVELL_PHY_ID_88E2110)
>>  		return 0;
>
> The indentation looks wrong here?

Indeed. Should I respin?

baruch

-- 
     http://baruch.siach.name/blog/                  ~. .~   Tk Open Systems
=}------------------------------------------------ooO--U--Ooo------------{=
   - baruch@tkos.co.il - tel: +972.52.368.4656, http://www.tkos.co.il -
