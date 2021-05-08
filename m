Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DEBE377363
	for <lists+netdev@lfdr.de>; Sat,  8 May 2021 19:32:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229617AbhEHRc5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 May 2021 13:32:57 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:59432 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229544AbhEHRcz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 8 May 2021 13:32:55 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1lfQnt-003Hqc-08; Sat, 08 May 2021 19:31:49 +0200
Date:   Sat, 8 May 2021 19:31:48 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Ansuel Smith <ansuelsmth@gmail.com>
Cc:     Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Vladimir Oltean <olteanv@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH net-next v3 19/20] net: dsa: qca8k: pass
 switch_revision info to phy dev_flags
Message-ID: <YJbLBBikxgqkd7JA@lunn.ch>
References: <20210504222915.17206-1-ansuelsmth@gmail.com>
 <20210504222915.17206-19-ansuelsmth@gmail.com>
 <20210506112458.yhgbpifebusc2eal@skbuf>
 <YJXMit3YfBXKM98j@Ansuel-xps.localdomain>
 <20210507233353.GE1336@shell.armlinux.org.uk>
 <YJXSbGzL040gnugV@Ansuel-xps.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YJXSbGzL040gnugV@Ansuel-xps.localdomain>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> The problem here was find a way to pass data from the dsa driver to the
> phy driver. In this specific case the phy driver is an internal phy
> present in the switch so it won't appear on anything else.

For internal PHYs, you are safe. But please keep in mind any RGMII
ports which the switch might have. Somebody could attach an external
PHY on such a port. So you should not return any flags for such ports.

    Andrew
