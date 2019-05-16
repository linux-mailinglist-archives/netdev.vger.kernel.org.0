Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 53BA720768
	for <lists+netdev@lfdr.de>; Thu, 16 May 2019 14:58:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727322AbfEPM6C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 May 2019 08:58:02 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:37225 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726427AbfEPM6C (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 May 2019 08:58:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=k5pbD5kNkKeKh6Y1AUdtZmslH/u5KZj8aj+X+d85ieo=; b=U1FheUMGauXkx7nMMSlKuK/84q
        umMEwujxE49i2QKqUDrr+eLMIFUs7D+sbZsoYCjVrUUEN9K5gcrestTsoFr1cPYHmrSC0uNOei8w4
        coXtXIKLTcyUbvbaeMfnoPdhrxl0LLEJktF6PYx81dyWqMLhlOVWnOrAL2nYvBXTVjm0=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hRFxQ-00037Q-Ai; Thu, 16 May 2019 14:58:00 +0200
Date:   Thu, 16 May 2019 14:58:00 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Maxime Chevallier <maxime.chevallier@bootlin.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        netdev <netdev@vger.kernel.org>,
        "thomas.petazzoni@bootlin.com" <thomas.petazzoni@bootlin.com>,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: dsa: using multi-gbps speeds on CPU port
Message-ID: <20190516125800.GC14298@lunn.ch>
References: <20190515143936.524acd4e@bootlin.com>
 <20190515132701.GD23276@lunn.ch>
 <20190515160214.1aa5c7d9@bootlin.com>
 <35daa9e7-8b97-35dd-bc95-bab57ef401cd@gmail.com>
 <20190515161931.ul2fmkfxmyumfli5@shell.armlinux.org.uk>
 <CA+h21hp5aX00jtj5bSkig1jGY8JHAsKwGp+584jbOw3k82Z5KA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+h21hp5aX00jtj5bSkig1jGY8JHAsKwGp+584jbOw3k82Z5KA@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> My basic idea is to interface a Raspberry Pi-like board to a dumb
> "switch evaluation board" which has only the Ethernet ports and the
> SPI/whatever control interface exposed. The DSA CPU/master port combo
> in this case would go through a Cat5 cable, which is not going to pan
> out very well currently because both the RPi-side PHY and the switch
> board-side PHY need some massaging from their respective drivers. Both
> PHYs are C22.

Hi Vladimir

There are a number of boards like this, back to back PHYs. But they
all have the switch PHY strapped so they start on power on and
auto-negotiate. DSA then just works.

    Andrew
