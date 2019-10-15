Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6ED2ED8066
	for <lists+netdev@lfdr.de>; Tue, 15 Oct 2019 21:38:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731958AbfJOTie (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Oct 2019 15:38:34 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:39709 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727856AbfJOTid (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Oct 2019 15:38:33 -0400
Received: by mail-wm1-f67.google.com with SMTP id v17so281778wml.4
        for <netdev@vger.kernel.org>; Tue, 15 Oct 2019 12:38:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=E3B63BPD8WhwxK8F76UGDMYTwfefF6997Iwnobico4A=;
        b=Xllzek0xvgC6jyu0c/eT0B5b5aeiV60nBgSZGPvRxpjAoFKIPpaVMpzpzUkMuwHAmw
         /9XxR1AfJJy7ypuSC5x5YBD6yucZzrC8bTLEmJ9zZLxf67zI/wsARAkzC87m7QXamiyL
         5CmBD6IAoEJIka4UWE8kxjnrDCTvNBq6pOXElaCBtaO4tHLrQxlGrU6uyxb7ggFHBT/R
         o/bIdwVJEl9koupbRlYlRttmxeAdLwHs2HQ//RWJ2KkqdlqeYa0rQV3OyCt01UjXQmPg
         oP+C8ofnMK5bSOykDzNEyUPCRinX/wFGvxYvNNuS/kwkzJZagqQbXmtJwjw9zoUb81+x
         1OyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=E3B63BPD8WhwxK8F76UGDMYTwfefF6997Iwnobico4A=;
        b=pVQjRalAQMexMCr3Gw4vGtVndZv+JOg21/d8IWknbAlEw1asskKeJ20cJi9uc/A8J2
         tKLHbbwR0JcuJrkrQ33PAPUfK05HsP4U8kTlFXu7rwr3PtYy/iju7/1kshSkXnPS4txK
         WjDRBSsoQa0hh+jpUcIhDKjCtsVWSE0FNaVyx86pfLrwNOBWdWvQu774FfveJWkUDwIO
         IXOgOAn/WTg1dTCLIMXhXvE3NopDUXuUijjFJLeD0G/BPrH63fz26BWWxHA7LdjYwqHn
         efU8BUK3gDgifK/77rCG5DyH/z06gJycip6v6uRBZI+PktVtJmNEOJeyAEKsMbyacNom
         TLIA==
X-Gm-Message-State: APjAAAW3EwxLyfEWNT8kpRYzYVRQJmdWI3Ynp/LLF45LZCcop+iPlH2i
        CJpz8PmJJWX3K+KeuuT7xeublJRX
X-Google-Smtp-Source: APXvYqweDgbFaIKgQlfsCgzo3guTMj64bM+rRO3BOaL1eG4Xww1rEpLEQ4okEl1oQARRe7th47z9jA==
X-Received: by 2002:a1c:f305:: with SMTP id q5mr137336wmq.137.1571168311140;
        Tue, 15 Oct 2019 12:38:31 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f26:6400:44d1:b396:5862:c59e? (p200300EA8F26640044D1B3965862C59E.dip0.t-ipconnect.de. [2003:ea:8f26:6400:44d1:b396:5862:c59e])
        by smtp.googlemail.com with ESMTPSA id h125sm335917wmf.31.2019.10.15.12.38.29
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 15 Oct 2019 12:38:30 -0700 (PDT)
Subject: Re: lan78xx and phy_state_machine
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Woojung Huh <woojung.huh@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>
Cc:     Stefan Wahren <wahrenst@gmx.net>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Daniel Wagner <dwagner@suse.de>,
        bcm-kernel-feedback-list@broadcom.com,
        linux-rpi-kernel@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, netdev@vger.kernel.org
References: <20191014140604.iddhmg5ckqhzlbkw@beryllium.lan>
 <20191014163004.GP25745@shell.armlinux.org.uk>
 <20191014192529.z7c5x6hzixxeplvw@beryllium.lan>
 <25cfc92d-f72b-d195-71b1-f5f238c7988d@gmx.net>
 <b9afd836-613a-dc63-f77b-f9a77d33acc4@gmail.com>
 <20191014221211.GR25745@shell.armlinux.org.uk>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <524267e6-df8e-d884-aeef-1ed8700e4e58@gmail.com>
Date:   Tue, 15 Oct 2019 21:38:22 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191014221211.GR25745@shell.armlinux.org.uk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 15.10.2019 00:12, Russell King - ARM Linux admin wrote:
> On Mon, Oct 14, 2019 at 10:20:15PM +0200, Heiner Kallweit wrote:
>> On 14.10.2019 21:51, Stefan Wahren wrote:
>>> [add more recipients]
>>>
>>> Am 14.10.19 um 21:25 schrieb Daniel Wagner:
>>>> Moving the phy_prepare_link() up in phy_connect_direct() ensures that
>>>> phydev->adjust_link is set when the phy_check_link_status() is called.
>>>>
>>>> diff --git a/drivers/net/phy/phy_device.c
>>>> b/drivers/net/phy/phy_device.c index 9d2bbb13293e..2a61812bcb0d 100644
>>>> --- a/drivers/net/phy/phy_device.c +++ b/drivers/net/phy/phy_device.c
>>>> @@ -951,11 +951,12 @@ int phy_connect_direct(struct net_device *dev,
>>>> struct phy_device *phydev, if (!dev) return -EINVAL;
>>>>
>>>> +       phy_prepare_link(phydev, handler);
>>>> +
>>>>         rc = phy_attach_direct(dev, phydev, phydev->dev_flags, interface);
>>>>         if (rc)
>>
>> If phy_attach_direct() fails we may have to reset phydev->adjust_link to NULL,
>> as we do in phy_disconnect(). Apart from that change looks good to me.
> 
> Sorry, but it doesn't look good to me.
> 
> I think there's a deeper question here - why is the phy state machine
> trying to call the link change function during attach?
After your comment I had a closer look at the lm78xx driver and few things
look suspicious:

- lan78xx_phy_init() (incl. the call to phy_connect_direct()) is called
  after register_netdev(). This may cause races.

- The following is wrong, irq = 0 doesn't mean polling.
  PHY_POLL is defined as -1. Also in case of irq = 0 phy_interrupt_is_valid()
  returns true.

	/* if phyirq is not set, use polling mode in phylib */
	if (dev->domain_data.phyirq > 0)
		phydev->irq = dev->domain_data.phyirq;
	else
		phydev->irq = 0;

- Manually calling genphy_config_aneg() in lan78xx_phy_init() isn't
  needed, however this should not cause our problem.

Bugs in the network driver would also explain why the issue doesn't occur
on other systems. Once we know more about the actual root cause
maybe phylib can be extended to detect that situation and warn.

> At this point, the PHY hasn't been "started" so it shouldn't be
> doing that.
> 
> Note the documentation, specifically phy.rst's "Keeping Close Tabs on
> the PAL" section.  Drivers are at liberty to use phy_prepare_link()
> _after_ phy_attach(), which means there is a window for
> phydev->adjust_link to be NULL.  It should _not_ be called at this
> point.
> 

