Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6AC826AE9A
	for <lists+netdev@lfdr.de>; Tue, 15 Sep 2020 22:20:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727974AbgIOUS5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Sep 2020 16:18:57 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:37042 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727916AbgIOUSm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 15 Sep 2020 16:18:42 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kIHOA-00Eobi-N0; Tue, 15 Sep 2020 22:17:18 +0200
Date:   Tue, 15 Sep 2020 22:17:18 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Dan Murphy <dmurphy@ti.com>
Cc:     davem@davemloft.net, f.fainelli@gmail.com, hkallweit1@gmail.com,
        mkubecek@suse.cz, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 2/3] net: dp83869: Add ability to advertise
 Fiber connection
Message-ID: <20200915201718.GD3526428@lunn.ch>
References: <20200915181708.25842-1-dmurphy@ti.com>
 <20200915181708.25842-3-dmurphy@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200915181708.25842-3-dmurphy@ti.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +		linkmode_set_bit(ETHTOOL_LINK_MODE_100baseFX_Full_BIT,
> +				 phydev->supported);
> +		linkmode_set_bit(ETHTOOL_LINK_MODE_100baseFX_Half_BIT,
> +				 phydev->supported);
> +
> +		/* Auto neg is not supported in 100base FX mode */

Hi Dan

If it does not support auto neg, how do you decide to do half duplex?
I don't see any code here which allows the user to configure it.

  Andrew
