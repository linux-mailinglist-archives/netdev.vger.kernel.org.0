Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F51C256327
	for <lists+netdev@lfdr.de>; Sat, 29 Aug 2020 00:29:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726838AbgH1W2w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Aug 2020 18:28:52 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:59130 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726524AbgH1W2v (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 28 Aug 2020 18:28:51 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kBmrW-00CLCh-J4; Sat, 29 Aug 2020 00:28:46 +0200
Date:   Sat, 29 Aug 2020 00:28:46 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Adam =?utf-8?Q?Rudzi=C5=84ski?= <adam.rudzinski@arf.net.pl>
Cc:     robh+dt@kernel.org, frowand.list@gmail.com, f.fainelli@gmail.com,
        netdev <netdev@vger.kernel.org>
Subject: Re: drivers/of/of_mdio.c needs a small modification
Message-ID: <20200828222846.GA2403519@lunn.ch>
References: <c8b74845-b9e1-6d85-3947-56333b73d756@arf.net.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c8b74845-b9e1-6d85-3947-56333b73d756@arf.net.pl>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Adam

> If kernel has to bring up two Ethernet interfaces, the processor has two
> peripherals with functionality of MACs (in i.MX6ULL these are Fast Ethernet
> Controllers, FECs), but uses a shared MDIO bus, then the kernel first probes
> one MAC, enables clock for its PHY, probes MDIO bus tryng to discover _all_
> PHYs, and then probes the second MAC, and enables clock for its PHY. The
> result is that the second PHY is still inactive during PHY discovery. Thus,
> one Ethernet interface is not functional.

What clock are you talking about? Do you have the FEC feeding a 50MHz
clock to the PHY? Each FEC providing its own clock to its own PHY? And
are you saying a PHY without its reference clock does not respond to
MDIO reads and hence the second PHY does not probe because it has no
reference clock?

	  Andrew
