Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 027B02D4E80
	for <lists+netdev@lfdr.de>; Thu, 10 Dec 2020 00:07:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388390AbgLIXGo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Dec 2020 18:06:44 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:47416 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727599AbgLIXGo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Dec 2020 18:06:44 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kn8X1-00B8GX-SS; Thu, 10 Dec 2020 00:05:59 +0100
Date:   Thu, 10 Dec 2020 00:05:59 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Ivan Mikhaylov <i.mikhaylov@yadro.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] Add LED mode behavior/select properties and handle
Message-ID: <20201209230559.GE2649111@lunn.ch>
References: <20201209140501.17415-1-i.mikhaylov@yadro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201209140501.17415-1-i.mikhaylov@yadro.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 09, 2020 at 05:04:59PM +0300, Ivan Mikhaylov wrote:
> In KSZ9131 PHY it is possible to control LEDs blink behavior via
> LED mode behavior and select registers. Add DTS properties plus handles
> of them inside micrel PHY driver.
> 
> I've some concerns about passing raw register values into LED mode
> select and behavior.

There was been some work done allowing PHY LEDs to be controlled just
like other LEDs in Linux. That is how this should be done. Please go
look back in the netdev and LED mailing list archives, and join that
work.

     Andrew
