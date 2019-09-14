Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F0641B2C5B
	for <lists+netdev@lfdr.de>; Sat, 14 Sep 2019 19:15:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726044AbfINRPb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Sep 2019 13:15:31 -0400
Received: from mail-oi1-f195.google.com ([209.85.167.195]:35608 "EHLO
        mail-oi1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725943AbfINRPa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Sep 2019 13:15:30 -0400
Received: by mail-oi1-f195.google.com with SMTP id a127so5202484oii.2
        for <netdev@vger.kernel.org>; Sat, 14 Sep 2019 10:15:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:openpgp:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=5UNbCndePIZD8ZoWB3nEA7+zm0nXMMwRBxOrzJA6QeU=;
        b=ShP42CrT6+pap9H6PVUOnsjt8P8SxVWbLvNw9zHAe7dFtut3LI+xS6tx43JhWjLj4J
         MpXZbt8k2B1hi6Y9npGc88HarQSZdTxWqBJE1ytZ/PBDz3SP5/RkgZB6rUE+VWbH/knG
         QKhLWWunYVfer521M54j8cun/SivSqFWufOdFYQbiTf6xFvz+Xo8VcuRq7GUupobTA7y
         cGebZHTWyD9WxOA0Kw+69r4r4ZpDgcJuVbRfP8bB0FXZinPcAnRTqPkwC3K+2+TgjK75
         xq+y88j3MPyZRPEIKob5NkAtUyldqNhlq9wLqyRklDgesBcwefuV+A5KDyVYQfWPaew/
         ZgzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=5UNbCndePIZD8ZoWB3nEA7+zm0nXMMwRBxOrzJA6QeU=;
        b=HBuNioIPUcC9SwVgqaxETHubrdh2ftLWv6+C5ALnY20vmFAMz6QzbugzWMb9RByTm5
         5VnBxKs3lXYaOrNq5HSuANdwwCYbCc2vr8/Q58rfYC3Xkl05deD+HktnLI8aMhG5bHOK
         dlYPKI2TEChvJC3Yh0K23mgUBmfaj1u+Dm8diqUFgS7A1/crYNSKnyAh0ft4olfYVuj0
         yp0J8WqcSZnBoV3rt0v8t4hI6XMC+ZStCT7UwrFQMbVeIoQfUMcgHxCwkoBD393OHhfG
         RvvfDxh/ifxZIM6t429gOodpjsc1LWrbfsU5S1fz8rrIcLv2HHfigNPJ9+V3lL5/ShvH
         9KBw==
X-Gm-Message-State: APjAAAWZSjmpImRrbOHW9CW+pG7C7O9NBOikizg/QrbftAau1BVP8vDb
        z/dApamLzck/UWN1wcrpOag=
X-Google-Smtp-Source: APXvYqz2E+K46l5Jt6SZDwPPUyqrY628Jb4f48Y7ZB9fxnFuToUZ+Vf94acs9HnvOZfcUaY+ry3vFg==
X-Received: by 2002:a54:4703:: with SMTP id k3mr7655022oik.143.1568481329574;
        Sat, 14 Sep 2019 10:15:29 -0700 (PDT)
Received: from [192.168.1.3] (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id b5sm2171854oia.20.2019.09.14.10.15.28
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 14 Sep 2019 10:15:28 -0700 (PDT)
Subject: Re: SFP support with RGMII MAC via RGMII to SERDES/SGMII PHY?
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     George McCollister <george.mccollister@gmail.com>,
        netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>
References: <CAFSKS=NmM9bPb0R_zoFN+9AuG=x6DUffTNXpLSNRAHuZz4ki-g@mail.gmail.com>
 <6cd331e5-4e50-d061-439a-f97417645497@gmail.com>
 <20190914084856.GD13294@shell.armlinux.org.uk>
From:   Florian Fainelli <f.fainelli@gmail.com>
Openpgp: preference=signencrypt
Message-ID: <84d75b1c-8489-4242-fe6d-e7d3b389f1a2@gmail.com>
Date:   Sat, 14 Sep 2019 10:15:26 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20190914084856.GD13294@shell.armlinux.org.uk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/14/2019 1:48 AM, Russell King - ARM Linux admin wrote:
> On Fri, Sep 13, 2019 at 08:31:18PM -0700, Florian Fainelli wrote:
>> +Russell, Andrew, Heiner,
>>
>> On 9/13/2019 9:44 AM, George McCollister wrote:
>>> Every example of phylink SFP support I've seen is using an Ethernet
>>> MAC with native SGMII.
>>> Can phylink facilitate support of Fiber and Copper SFP modules
>>> connected to an RGMII MAC if all of the following are true?
>>
>> I don't think that use case has been presented before, but phylink
>> sounds like the tool that should help solve it. From your description
>> below, it sounds like all the pieces are there to support it. Is the
>> Ethernet MAC driver upstream?
> 
> It has been presented, and it's something I've been trying to support
> for the last couple of years - in fact, I have patches in my tree that
> support a very similar scenario on the Macchiatobin with the 88x3310
> PHYs.
> 
>>> 1) The MAC is connected via RGMII to a transceiver/PHY (such as
>>> Marvell 88E1512) which then connects to the SFP via SERDER/SGMII. If
>>> you want to see a block diagram it's the first one here:
>>> https://www.marvell.com/transceivers/assets/Alaska_88E1512-001_product_brief.pdf
> 
> As mentioned above, this is no different from the Macchiatobin,
> where we have:
> 
>                   .-------- RJ45
> MAC ---- 88x3310 PHY
>                   `-------- SFP+
> 
> except instead of the MAC to PHY link being 10GBASE-R, it's RGMII,
> and the PHY to SFP+ link is 10GBASE-R instead of 1000BASE-X.
> 
> Note that you're abusing the term "SGMII".  SGMII is a Cisco
> modification of the IEEE 802.3 1000BASE-X protocol.  Fiber SFPs
> exclusively use 1000BASE-X protocol.  However, some copper SFPs
> (with a RJ45) do use SGMII.
> 
>>> 2) The 1G Ethernet driver has been converted to use phylink.
> 
> This is not necessary for this scenario.  The PHY driver needs to
> be updated to know about SFP though.
> 
> See:
> 
> http://git.armlinux.org.uk/cgit/linux-arm.git/commit/?h=phy&id=ece56785ee0e9df40dc823fdc39ee74b4a7cd1c4

Regarding that patch, the SFP attach/detach callbacks do not seem very
specific to the PHY driver, only the sfp_insert callback which needs to
check the interface selected by the SFP.

Do you think it would make sense to move some of that logic into the
core PHY library and only have PHY drivers can be used to connect a SFP
cage specify a "sfp_select_interface" callback that is responsible for
rejecting the mode the SFP has been configured in, if unsupported?
Likewise for parsing the "sfp" property, if we parse that property in
the core and do not have a sfp_select_interface callback defined, then
it is not going to work.

So far we know that both marvel10g.c and marvell.c, two drivers that
would already justify factoring things in the core, I recall some people
using Broadcom PHYs having the same use cases, so 3 possible drivers
needing that functionality.

> 
> as an example of the 88x3310 supporting a SFP+ cage.  This patch is
> also necessary:
> 
> http://git.armlinux.org.uk/cgit/linux-arm.git/commit/?h=phy&id=ef2d699397ca28c7f89e01cc9e5037989096a990
> 
> and if anything is going to stand in the way of progress on this, it
> is likely to be that patch.  I'll be attempting to post these after
> the next merge window (i.o.w. probably posting them in three weeks
> time.)


-- 
Florian
