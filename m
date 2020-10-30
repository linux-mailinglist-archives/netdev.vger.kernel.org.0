Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4AA2F2A109D
	for <lists+netdev@lfdr.de>; Fri, 30 Oct 2020 22:56:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725845AbgJ3V4m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Oct 2020 17:56:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725797AbgJ3V4m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Oct 2020 17:56:42 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CC0CC0613CF;
        Fri, 30 Oct 2020 14:56:42 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id a9so7966325wrg.12;
        Fri, 30 Oct 2020 14:56:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=rvYh2GsGtQkLHNcSt74kHKL87bb/roryEb9Ia7149a0=;
        b=iC4NCb/+3X1MSJO+9wZtxZ6xR+2sUxdVlNSNxJX66XWY1C9H5caTW5vtOZA8sweVZB
         QZTJEVi9agWb3lX3O9+Fr/NEaUjLNXGVpr7y0DPZUPnzjvRiDs5D61vF6Q8dFn+ZG4Xs
         qAhNOPUA25cOiyFffcEGJXRH2kesH/ATxRGmEkvrmNS/YiaihV0CJL2yt7PgrN05DU6C
         81TrxDrPMeKG3vCTc3quYfeoM7RmKTffn5qN4/FRffexQcr4Kzm1Jxwna6sMyyAo1+3s
         fBffhj3N+l7BjRTPO9x/uNHDhcYclRGxKQLWjyhR1iR+OZs2lxtODBSc8pQyYJmMKSQd
         9+HA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=rvYh2GsGtQkLHNcSt74kHKL87bb/roryEb9Ia7149a0=;
        b=nUrSgM4SxsPOI+QK+eunyK7qRongqSGuE0jUl6so7ygq9rktlUckv1fWT+l1TJj3Le
         HHOiRGePhPE5i8GLa6+uRiFyXxY4+Eflg2FMuFPZmLqX4o+ggeUXWJgSyOxn+4v4ClEY
         OH155x6i2adkzL6veocVfuxKHfc8yV3a8Y3UBboEzSXCErUaV7/yZFjaSfadR4qefQ8r
         M9xBpwd4hzOmG9GnNl7RSaLyWm5GXGY/QxE0FhTSpCs7k4sLYN74iMk/f6h4Q0X+bkI+
         DYHeSE+sW/wNaOH3oe4CssChya9ZkjJ1VpbDy+ZPlLipCoIgG/JbWwUm71o7dYuppwtn
         Ozyw==
X-Gm-Message-State: AOAM530FQds+yeY40cp0jNlshGYUG4Ooj8C8JYFJjcJo5vbAio0I1ebu
        6PLBedB/0y4Gn5v6sFCyJic=
X-Google-Smtp-Source: ABdhPJzhROzZMdKsGhyAv0tMZdH7LplEHC6tgIzAqE6yygWcdFc2j5bS8VTsTWcghxPrZPVwFwp/QA==
X-Received: by 2002:adf:bc13:: with SMTP id s19mr5836034wrg.338.1604094998379;
        Fri, 30 Oct 2020 14:56:38 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f23:2800:9d19:4c77:c465:2524? (p200300ea8f2328009d194c77c4652524.dip0.t-ipconnect.de. [2003:ea:8f23:2800:9d19:4c77:c465:2524])
        by smtp.googlemail.com with ESMTPSA id g186sm14241177wma.1.2020.10.30.14.56.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 30 Oct 2020 14:56:37 -0700 (PDT)
Subject: Re: [PATCH net-next 00/19] net: phy: add support for shared
 interrupts (part 1)
To:     Ioana Ciornei <ciorneiioana@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Russell King <linux@armlinux.org.uk>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Ioana Ciornei <ioana.ciornei@nxp.com>,
        Alexandru Ardelean <alexandru.ardelean@analog.com>,
        Andre Edich <andre.edich@microchip.com>,
        Antoine Tenart <atenart@kernel.org>,
        Baruch Siach <baruch@tkos.co.il>,
        Christophe Leroy <christophe.leroy@c-s.fr>,
        Dan Murphy <dmurphy@ti.com>,
        Divya Koppera <Divya.Koppera@microchip.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Jerome Brunet <jbrunet@baylibre.com>,
        Kavya Sree Kotagiri <kavyasree.kotagiri@microchip.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Marco Felsch <m.felsch@pengutronix.de>,
        Marek Vasut <marex@denx.de>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Mathias Kresin <dev@kresin.me>,
        Maxim Kochetkov <fido_max@inbox.ru>,
        Michael Walle <michael@walle.cc>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Nisar Sayed <Nisar.Sayed@microchip.com>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Philippe Schenker <philippe.schenker@toradex.com>,
        Willy Liu <willy.liu@realtek.com>,
        Yuiko Oshino <yuiko.oshino@microchip.com>
References: <20201029100741.462818-1-ciorneiioana@gmail.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <43d672ae-c089-6621-5ab3-3a0f0303e51a@gmail.com>
Date:   Fri, 30 Oct 2020 22:56:24 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20201029100741.462818-1-ciorneiioana@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 29.10.2020 11:07, Ioana Ciornei wrote:
> From: Ioana Ciornei <ioana.ciornei@nxp.com>
> 
> This patch set aims to actually add support for shared interrupts in
> phylib and not only for multi-PHY devices. While we are at it,
> streamline the interrupt handling in phylib.
> 
> For a bit of context, at the moment, there are multiple phy_driver ops
> that deal with this subject:
> 
> - .config_intr() - Enable/disable the interrupt line.
> 
> - .ack_interrupt() - Should quiesce any interrupts that may have been
>   fired.  It's also used by phylib in conjunction with .config_intr() to
>   clear any pending interrupts after the line was disabled, and before
>   it is going to be enabled.
> 
> - .did_interrupt() - Intended for multi-PHY devices with a shared IRQ
>   line and used by phylib to discern which PHY from the package was the
>   one that actually fired the interrupt.
> 
> - .handle_interrupt() - Completely overrides the default interrupt
>   handling logic from phylib. The PHY driver is responsible for checking
>   if any interrupt was fired by the respective PHY and choose
>   accordingly if it's the one that should trigger the link state machine.
> 
>>From my point of view, the interrupt handling in phylib has become
> somewhat confusing with all these callbacks that actually read the same
> PHY register - the interrupt status.  A more streamlined approach would
> be to just move the responsibility to write an interrupt handler to the
> driver (as any other device driver does) and make .handle_interrupt()
> the only way to deal with interrupts.
> 
> Another advantage with this approach would be that phylib would gain
> support for shared IRQs between different PHY (not just multi-PHY
> devices), something which at the moment would require extending every
> PHY driver anyway in order to implement their .did_interrupt() callback
> and duplicate the same logic as in .ack_interrupt(). The disadvantage
> of making .did_interrupt() mandatory would be that we are slightly
> changing the semantics of the phylib API and that would increase
> confusion instead of reducing it.
> 
> What I am proposing is the following:
> 
> - As a first step, make the .ack_interrupt() callback optional so that
>   we do not break any PHY driver amid the transition.
> 
> - Every PHY driver gains a .handle_interrupt() implementation that, for
>   the most part, would look like below:
> 
> 	irq_status = phy_read(phydev, INTR_STATUS);
> 	if (irq_status < 0) {
> 		phy_error(phydev);
> 		return IRQ_NONE;
> 	}
> 
> 	if (irq_status == 0)
> 		return IRQ_NONE;
> 
> 	phy_trigger_machine(phydev);
> 
> 	return IRQ_HANDLED;
> 
> - Remove each PHY driver's implementation of the .ack_interrupt() by
>   actually taking care of quiescing any pending interrupts before
>   enabling/after disabling the interrupt line.
> 
> - Finally, after all drivers have been ported, remove the
>   .ack_interrupt() and .did_interrupt() callbacks from phy_driver.
> 

Looks good to me. The current interrupt support in phylib basically
just covers the link change interrupt and we need more flexibility.

And even in the current limited use case we face smaller issues.
One reason is that INTR_STATUS typically is self-clearing on read.
phylib has to deal with the case that did_interrupt may or may not
have read INTR_STATUS already.

I'd just like to avoid the term "shared interrupt", because it has
a well-defined meaning. Our major concern isn't shared interrupts
but support for multiple interrupt sources (in addition to
link change) in a PHY.

WRT implementing a shutdown hook another use case was mentioned
recently: https://lkml.org/lkml/2020/9/30/451
But that's not really relevant here and just fyi.


> This patch set is part 1 and it addresses the changes needed in phylib
> and 7 PHY drivers. The rest can be found on my Github branch here:
> https://github.com/IoanaCiornei/linux/commits/phylib-shared-irq
> 
> I do not have access to most of these PHY's, therefore I Cc-ed the
> latest contributors to the individual PHY drivers in order to have
> access, hopefully, to more regression testing.
> 
> Ioana Ciornei (19):
>   net: phy: export phy_error and phy_trigger_machine
>   net: phy: add a shutdown procedure
>   net: phy: make .ack_interrupt() optional
>   net: phy: at803x: implement generic .handle_interrupt() callback
>   net: phy: at803x: remove the use of .ack_interrupt()
>   net: phy: mscc: use phy_trigger_machine() to notify link change
>   net: phy: mscc: implement generic .handle_interrupt() callback
>   net: phy: mscc: remove the use of .ack_interrupt()
>   net: phy: aquantia: implement generic .handle_interrupt() callback
>   net: phy: aquantia: remove the use of .ack_interrupt()
>   net: phy: broadcom: implement generic .handle_interrupt() callback
>   net: phy: broadcom: remove use of ack_interrupt()
>   net: phy: cicada: implement the generic .handle_interrupt() callback
>   net: phy: cicada: remove the use of .ack_interrupt()
>   net: phy: davicom: implement generic .handle_interrupt() calback
>   net: phy: davicom: remove the use of .ack_interrupt()
>   net: phy: add genphy_handle_interrupt_no_ack()
>   net: phy: realtek: implement generic .handle_interrupt() callback
>   net: phy: realtek: remove the use of .ack_interrupt()
> 
>  drivers/net/phy/aquantia_main.c  |  57 ++++++++++----
>  drivers/net/phy/at803x.c         |  42 ++++++++--
>  drivers/net/phy/bcm-cygnus.c     |   2 +-
>  drivers/net/phy/bcm-phy-lib.c    |  37 ++++++++-
>  drivers/net/phy/bcm-phy-lib.h    |   1 +
>  drivers/net/phy/bcm54140.c       |  39 +++++++---
>  drivers/net/phy/bcm63xx.c        |  20 +++--
>  drivers/net/phy/bcm87xx.c        |  50 ++++++------
>  drivers/net/phy/broadcom.c       |  70 ++++++++++++-----
>  drivers/net/phy/cicada.c         |  35 ++++++++-
>  drivers/net/phy/davicom.c        |  59 ++++++++++----
>  drivers/net/phy/mscc/mscc_main.c |  70 +++++++++--------
>  drivers/net/phy/phy.c            |   6 +-
>  drivers/net/phy/phy_device.c     |  23 +++++-
>  drivers/net/phy/realtek.c        | 128 +++++++++++++++++++++++++++----
>  include/linux/phy.h              |   3 +
>  16 files changed, 484 insertions(+), 158 deletions(-)
> 
> Cc: Alexandru Ardelean <alexandru.ardelean@analog.com>
> Cc: Andre Edich <andre.edich@microchip.com>
> Cc: Antoine Tenart <atenart@kernel.org>
> Cc: Baruch Siach <baruch@tkos.co.il>
> Cc: Christophe Leroy <christophe.leroy@c-s.fr>
> Cc: Dan Murphy <dmurphy@ti.com>
> Cc: Divya Koppera <Divya.Koppera@microchip.com>
> Cc: Florian Fainelli <f.fainelli@gmail.com>
> Cc: Hauke Mehrtens <hauke@hauke-m.de>
> Cc: Heiner Kallweit <hkallweit1@gmail.com>
> Cc: Jerome Brunet <jbrunet@baylibre.com>
> Cc: Kavya Sree Kotagiri <kavyasree.kotagiri@microchip.com>
> Cc: Linus Walleij <linus.walleij@linaro.org>
> Cc: Marco Felsch <m.felsch@pengutronix.de>
> Cc: Marek Vasut <marex@denx.de>
> Cc: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
> Cc: Mathias Kresin <dev@kresin.me>
> Cc: Maxim Kochetkov <fido_max@inbox.ru>
> Cc: Michael Walle <michael@walle.cc>
> Cc: Neil Armstrong <narmstrong@baylibre.com>
> Cc: Nisar Sayed <Nisar.Sayed@microchip.com>
> Cc: Oleksij Rempel <o.rempel@pengutronix.de>
> Cc: Philippe Schenker <philippe.schenker@toradex.com>
> Cc: Willy Liu <willy.liu@realtek.com>
> Cc: Yuiko Oshino <yuiko.oshino@microchip.com>
> 

