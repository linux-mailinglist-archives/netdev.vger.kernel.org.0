Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 230B4150037
	for <lists+netdev@lfdr.de>; Mon,  3 Feb 2020 02:15:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726992AbgBCBPg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Feb 2020 20:15:36 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:33528 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726393AbgBCBPf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 2 Feb 2020 20:15:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=QBerq6LG2NxoRvig2/n4YtezyITokM6G5WarxJLcToo=; b=g+sbcjWpxpOoc58zXEAZTICQDj
        fVOR1AHGwlsAwfWY5b9dA2pTEg8e+DuMqoqhz+OLgJ6J6KW/2Ei+aFjZVrIkaukBSevdcr3OvsRRy
        iJohWO/tmUU+r2t1OafUWlpgJ9UC6h7GbtVhFbEsvd61uM/nhY+FYZBp1+iMHqOuiUHU=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1iyQKm-0007vg-Fx; Mon, 03 Feb 2020 02:15:28 +0100
Date:   Mon, 3 Feb 2020 02:15:28 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jeremy Linton <jeremy.linton@arm.com>
Cc:     netdev@vger.kernel.org, opendmb@gmail.com, f.fainelli@gmail.com,
        davem@davemloft.net, bcm-kernel-feedback-list@broadcom.com,
        linux-kernel@vger.kernel.org, wahrenst@gmx.net,
        hkallweit1@gmail.com
Subject: Re: [PATCH 3/6] net: bcmgenet: enable automatic phy discovery
Message-ID: <20200203011528.GA30319@lunn.ch>
References: <20200201074625.8698-1-jeremy.linton@arm.com>
 <20200201074625.8698-4-jeremy.linton@arm.com>
 <20200201152518.GI9639@lunn.ch>
 <ad9bc142-c0a8-74af-09c6-7150ff4b854a@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ad9bc142-c0a8-74af-09c6-7150ff4b854a@arm.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> I though I should clarify the direct question here about ACPI. ACPI does
> have the ability to do what you describe, but it a more rigorous way. If you
> look at the ACPI GenericSerialBus abstraction you will see how ACPI would
> likely handle this situation. I've been considering making a similar comment
> in that large fwnode patch set posted the other day.

I know ~0 about ACPI. But it does not seem unreasonable to describe an
MDIO bus in the same way as an i2c bus, or an spi bus. Each can have
devices on it, at specific addresses. Each needs common properties
like interrupts, and each needs bus specific properties like SPI
polarity. And you need pointers to these devices, so that other
subsystems can use them.

So maybe the correct way to describe this is to use ACPI
GenericSerialBus?

What the kernel community really seems to miss is a "Rob Herring" for
ACPI.

     Andrew
