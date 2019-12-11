Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AD7DC11BEFE
	for <lists+netdev@lfdr.de>; Wed, 11 Dec 2019 22:20:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726613AbfLKVUl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Dec 2019 16:20:41 -0500
Received: from mail-wr1-f46.google.com ([209.85.221.46]:44550 "EHLO
        mail-wr1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726313AbfLKVUk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Dec 2019 16:20:40 -0500
Received: by mail-wr1-f46.google.com with SMTP id q10so208303wrm.11
        for <netdev@vger.kernel.org>; Wed, 11 Dec 2019 13:20:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=nJB4kfT4HKkA0ytRktRHAcE4WORz8Cv20hglwFKSUrs=;
        b=F3Y07zWDRqJzQCya7fky5X27JXk/n7noWtIQhanXEneD1dAHC03sCbDKXf6UQ7Nxcv
         PX18UhXOHzfts8y8cS3AgzEpVj7RWUwOr871ZffqQ/e2fvJ6Vrc0T4jIR5fafmGRsgK+
         1R8a3R2nW1KiYvLZ2PHZzvl07IjJUsLFh+kVnN6jhsoTBhkRLy3S2UU2Jdv1f9XXYx7J
         7PqFbPUAAdjkUx7OUZOc2GtyjBt2FBpG24IOz9nRZsS/W6P7v73/vKnoj0AErXiXyZRu
         wMHWsV0zh/goY+mKmPnGhBS0QZff0QQ9/dit8b0FiNZS92aJJhn+A3nqIj3TslKfgD78
         Q0zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=nJB4kfT4HKkA0ytRktRHAcE4WORz8Cv20hglwFKSUrs=;
        b=R+ITjnHVaVpquH0IFTsWE4mtQdq/XTDt6jPQxiaM6ZleTHSVz+tVAlm204lZudq9dc
         HsG6HxPsQ38sIHV2KpdbVu2iZ9rVvk7f7uyUQmdri8qTgbmZ9nv1c3ITrwFatVmr9ciF
         SHiM8Ituf7BtDDitxxpz6u24Nt60iff4C5pQGxoTOkPz5Ly0TFpwM91gqaYg5JkLjYQs
         d5nGYBA+BxU40oWNmz9KAu7gx6P55xLtdbB5J+MOX2889TXbc4Ael/HtL9rsHiE0tKNn
         UqOXMAO+x+tw7oRFvzyLrup8pkpooLaITLBEZ70jzmgGMRL3eD/mofduqE79n1MtEqmf
         Dqog==
X-Gm-Message-State: APjAAAWb/KehPeA392IyLL494VT1Vcjthcibjl235P0GwuUmPZ1ZQkTr
        gcEOq4NyRs6GamRwcs2BE9dbLY78
X-Google-Smtp-Source: APXvYqyUwxqx5FsSAGd5HXHi09yF41apC+9GzBBR6SZ1zUnKTmkZDdRgmdQ+LtpyWhWdvsFhvHmU/g==
X-Received: by 2002:a05:6000:160d:: with SMTP id u13mr2121886wrb.22.1576099238661;
        Wed, 11 Dec 2019 13:20:38 -0800 (PST)
Received: from ?IPv6:2003:ea:8f4a:6300:40b2:575f:21ab:316e? (p200300EA8F4A630040B2575F21AB316E.dip0.t-ipconnect.de. [2003:ea:8f4a:6300:40b2:575f:21ab:316e])
        by smtp.googlemail.com with ESMTPSA id 5sm3722734wrh.5.2019.12.11.13.20.37
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 11 Dec 2019 13:20:38 -0800 (PST)
Subject: Re: phylib's new dynamic feature detection seems too early
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev@vger.kernel.org
References: <20191210171536.GW25745@shell.armlinux.org.uk>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <e6e063bd-e6da-1b23-b012-e10f7415ab2b@gmail.com>
Date:   Wed, 11 Dec 2019 22:20:33 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
MIME-Version: 1.0
In-Reply-To: <20191210171536.GW25745@shell.armlinux.org.uk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10.12.2019 18:15, Russell King - ARM Linux admin wrote:
> Hi,
> 
> Back in dcdecdcfe1fc ("net: phy: switch drivers to use dynamic feature
> detection"), Heiner switched a bunch of PHYs over to using his
> wonderful new idea of reading the PHY capabilities from the registers.
> However, this is flawed.
> 
> The features are read from the PHY shortly after the PHY driver is
> bound to the device, while the PHY is in its default pin-strapped
> defined mode. PHYs such as the 88E1111 set their capabilities according
> to the pin-strapped host interface mode.
> 
> If the 88E1111 is pin-strapped for a 1000base-X host interface, then it
> indicates that it is not capable of 100M or 10M modes - which is
> entirely sensible.
> 
> However, the SFP support will switch the PHY into SGMII mode, where the
> PHY will support 100M and 10M modes. Indeed, reading the PHY registers
> using mii-diag after initialisation reports that the PHY supports these
> speeds.
> 
> This switch happens in the Marvell PHY driver when the config_init()
> method is called, via phy_init_hw() and phy_attach_direct() - which
> is where the MAC driver configures the PHY for its requested interface
> mode.
> 
> Therefore, the features dynamically read from the PHY are entirely
> meaningless, until the PHY interface mode has been properly set.
> 
> This means that SFP modules, such as Champion One 1000SFPT and a
> multitude of others which default to a 1000base-X interface end up
> only advertising 1000baseT despite being switched to SGMII mode and
> actually supporting 100M and 10M speeds - and that can't be changed
> via ethtool as the support mask doesn't allow the other speeds.
> 
> Thoughts how to get around this?
> 
Before reading PHY capabilities from the registers the capabilities
were completely static, I don't think this was better.
The capabilities read in phy_probe() are correct for the default
interface mode. And for all PHY drivers not implementing
config_init() we have to read the capabilities in phy_probe().

In case the capabilities can change in config_init() a first thought
would be to clear supported/advertised and re-read the capabilities
at the end of config_init().

Heiner
