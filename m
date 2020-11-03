Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFA1C2A4D31
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 18:38:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728819AbgKCRiW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 12:38:22 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:33114 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727857AbgKCRiW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Nov 2020 12:38:22 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1ka0G9-0054Fm-Bj; Tue, 03 Nov 2020 18:38:17 +0100
Date:   Tue, 3 Nov 2020 18:38:17 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Dan Murphy <dmurphy@ti.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net,
        f.fainelli@gmail.com, hkallweit1@gmail.com, robh@kernel.org,
        devicetree@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v3 4/4] net: phy: dp83td510: Add support for the
 DP83TD510 Ethernet PHY
Message-ID: <20201103173817.GP1042051@lunn.ch>
References: <20201030172950.12767-1-dmurphy@ti.com>
 <20201030172950.12767-5-dmurphy@ti.com>
 <20201030160330.622c55a7@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <5b32a56b-f054-5790-c5cf-bf1e86403bad@ti.com>
 <20201103172153.GO1042051@lunn.ch>
 <d51ef446-1528-5d3f-8548-831598a005a7@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d51ef446-1528-5d3f-8548-831598a005a7@ti.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > > > drivers/net/phy/dp83td510.c:70:11: warning: symbol 'dp83td510_feature_array' was not declared. Should it be static?
> > > I did not see this warning. Did you use W=1?
> > I _think_ that one is W=1. All the PHY drivers are W=1 clean, and i
> > want to keep it that way. And i hope to make it the default in a lot
> > of the network code soon.
> OK I built with the W=1 before submission I did not see this but I will try
> some other things.

Then it might be sparse. Try C=1.

     Andrew
