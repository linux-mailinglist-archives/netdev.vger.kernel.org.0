Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EB3A71B1A5
	for <lists+netdev@lfdr.de>; Mon, 13 May 2019 10:00:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726909AbfEMIAP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 May 2019 04:00:15 -0400
Received: from smtp-out.xnet.cz ([178.217.244.18]:37057 "EHLO smtp-out.xnet.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725928AbfEMIAP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 May 2019 04:00:15 -0400
Received: from meh.true.cz (meh.true.cz [108.61.167.218])
        (Authenticated sender: petr@true.cz)
        by smtp-out.xnet.cz (Postfix) with ESMTPSA id 8DAE13248;
        Mon, 13 May 2019 10:00:12 +0200 (CEST)
Received: from localhost (meh.true.cz [local])
        by meh.true.cz (OpenSMTPD) with ESMTPA id 2f7fdfb8;
        Mon, 13 May 2019 10:00:10 +0200 (CEST)
Date:   Mon, 13 May 2019 10:00:10 +0200
From:   Petr =?utf-8?Q?=C5=A0tetiar?= <ynezz@true.cz>
To:     Andy Duan <fugang.duan@nxp.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "john@phrozen.org" <john@phrozen.org>,
        "bgolaszewski@baylibre.com" <bgolaszewski@baylibre.com>,
        Maxime Ripard <maxime.ripard@bootlin.com>
Subject: Re: [EXT] Re: [PATCH net 2/3] of_net: add property
 "nvmem-mac-address" for of_get_mac_addr()
Message-ID: <20190513080010.GV81826@meh.true.cz>
Reply-To: Petr =?utf-8?Q?=C5=A0tetiar?= <ynezz@true.cz>
References: <1557476567-17397-1-git-send-email-fugang.duan@nxp.com>
 <1557476567-17397-3-git-send-email-fugang.duan@nxp.com>
 <20190510181758.GF11588@lunn.ch>
 <VI1PR0402MB3600DCD22084A6A0D5190859FF0F0@VI1PR0402MB3600.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <VI1PR0402MB3600DCD22084A6A0D5190859FF0F0@VI1PR0402MB3600.eurprd04.prod.outlook.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andy Duan <fugang.duan@nxp.com> [2019-05-13 03:31:59]:

> From: Andrew Lunn <andrew@lunn.ch> Sent: Saturday, May 11, 2019 2:18 AM
> > On Fri, May 10, 2019 at 08:24:03AM +0000, Andy Duan wrote:
> > > If MAC address read from nvmem cell and it is valid mac address,
> > > .of_get_mac_addr_nvmem() add new property "nvmem-mac-address" in
> > > ethernet node. Once user call .of_get_mac_address() to get MAC address
> > > again, it can read valid MAC address from device tree in directly.
> > 
> > I suspect putting the MAC address into OF will go away in a follow up patch. It
> > is a bad idea.
> > 
> >        Andrew
> 
> I don't know the history why does of_get_mac_addr_nvmem() add the new property
> "nvmem-mac-address" into OF. But if it already did that, so the patch add the property
> check in . of_get_mac_address() to avoid multiple read nvmem cells in driver.

it was removed[1] already, more details[2].

1. https://git.kernel.org/pub/scm/linux/kernel/git/davem/net.git/commit/?id=265749861a2483263e6cd4c5e305640e4651c110
2. https://patchwork.ozlabs.org/patch/1092248/#2167609

-- ynnezz
