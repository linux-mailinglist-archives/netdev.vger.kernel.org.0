Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1958C1F5C67
	for <lists+netdev@lfdr.de>; Wed, 10 Jun 2020 22:05:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730499AbgFJUFa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Jun 2020 16:05:30 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:33122 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727877AbgFJUF3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Jun 2020 16:05:29 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1jj6yU-0005Rc-Ay; Wed, 10 Jun 2020 22:05:26 +0200
Date:   Wed, 10 Jun 2020 22:05:26 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Michal Kubecek <mkubecek@suse.cz>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: ethtool 5.7: netlink ENOENT error when setting WOL
Message-ID: <20200610200526.GB19869@lunn.ch>
References: <77652728-722e-4d3b-6737-337bf4b391b7@gmail.com>
 <6359d5f8-50e4-a504-ba26-c3b6867f3deb@gmail.com>
 <20200610091328.evddgipbedykwaq6@lion.mk-sys.cz>
 <a433a0b0-bf5e-ad90-8373-4f88e2ef991d@gmail.com>
 <0353ce74-ffc6-4d40-bf0f-d2a7ad640b30@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0353ce74-ffc6-4d40-bf0f-d2a7ad640b30@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Not sure it makes sense to build ETHTOOL_NETLINK as a module, but at
> least ensuring that ETHTOOL_NETLINK is built into the kernel if PHYLIB=y
> or PHYLIB=m would make sense, or, better we find a way to decouple the
> two by using function pointers from the phy_driver directly that way
> there is no symbol dependency (but reference counting has to work).

Hi Florian

It is not so easy to make PHYLIB=m work. ethtool netlink needs to call
into the phylib core in order to trigger a cable test, not just PHY
drivers.

Ideas welcome.

      Andrew
