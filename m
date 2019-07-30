Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 90CAD7A945
	for <lists+netdev@lfdr.de>; Tue, 30 Jul 2019 15:17:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730639AbfG3NRd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jul 2019 09:17:33 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:47598 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729351AbfG3NRd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Jul 2019 09:17:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=f6K5S1qRFYNJHT7vCxBKxMwimioP8M0YvDEtZLFUidM=; b=ulkwRLMN0NSamHlRyeWM0BYiYk
        roPACqXghaUfOj2riCufKHlIAWV8SXjAvG2ABaETa3G9y/D+3cp4gTfesQR8+EJujK80syg8YbMXm
        pIbyFAm7KCDI44IKy14Lo7QKc9BsbINHl7YZh7LH+W8RGticPo8skwayxUAleVLyz2ko=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hsS0F-0007XB-M0; Tue, 30 Jul 2019 15:17:19 +0200
Date:   Tue, 30 Jul 2019 15:17:19 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Tao Ren <taoren@fb.com>, Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Arun Parameswaran <arun.parameswaran@broadcom.com>,
        Justin Chen <justinpopo6@gmail.com>,
        netdev <netdev@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Andrew Jeffery <andrew@aj.id.au>,
        "openbmc@lists.ozlabs.org" <openbmc@lists.ozlabs.org>
Subject: Re: [PATCH net-next 2/2] net: phy: broadcom: add 1000Base-X support
 for BCM54616S
Message-ID: <20190730131719.GA28552@lunn.ch>
References: <20190730002549.86824-1-taoren@fb.com>
 <CA+h21hq1+E6-ScFx425hXwTPTZHTVZbBuAm7RROFZTBOFvD8vQ@mail.gmail.com>
 <3987251b-9679-dfbe-6e15-f991c2893bac@fb.com>
 <CA+h21ho1KOGS3WsNBHzfHkpSyE4k5HTE1tV9wUtnkZhjUZGeUw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+h21ho1KOGS3WsNBHzfHkpSyE4k5HTE1tV9wUtnkZhjUZGeUw@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Again, I don't think Linux has generic support for overwriting (or
> even describing) the operating mode of a PHY, although maybe that's a
> direction we would want to push the discussion towards. RGMII to
> copper, RGMII to fiber, SGMII to copper, copper to fiber (media
> converter), even RGMII to SGMII (RTL8211FS supports this) - lots of
> modes, and this is only for gigabit PHYs...

This is something Russell King has PHYLINK patches for, which have not
yet been merged. There are some boards which use a PHY as a media
converter, placed between the MAC and an SFP.

	   Andrew
