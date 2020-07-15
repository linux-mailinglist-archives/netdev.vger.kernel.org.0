Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F1702214B3
	for <lists+netdev@lfdr.de>; Wed, 15 Jul 2020 20:51:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726491AbgGOSvG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jul 2020 14:51:06 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:37398 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726086AbgGOSvG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Jul 2020 14:51:06 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1jvmUf-005HWy-Dr; Wed, 15 Jul 2020 20:51:01 +0200
Date:   Wed, 15 Jul 2020 20:51:01 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Helmut Grohne <helmut.grohne@intenta.de>
Cc:     David Miller <davem@davemloft.net>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "woojung.huh@microchip.com" <woojung.huh@microchip.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>
Subject: Re: [PATCH] net: phy: phy_remove_link_mode should not advertise new
 modes
Message-ID: <20200715185101.GB1256692@lunn.ch>
References: <20200714082540.GA31028@laureti-dev>
 <20200714.140710.213288407914809619.davem@davemloft.net>
 <20200715070345.GA3452@laureti-dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200715070345.GA3452@laureti-dev>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> It also is not true that the current code ensures your assertion.
> Specifically, phy_advertise_supported copies the pause bits from the old
> advertised to the new one regardless of whether they're set in
> supported.

This is an oddity of Pause. The PHY should not sets Pause in
supported, because the PHY is not the device which implements
Pause. The MAC needs to indicate to PHYLIB it implements Pause, and
then the PHY will advertise Pause.

I will address the other points in a separate email.

  Andrew
