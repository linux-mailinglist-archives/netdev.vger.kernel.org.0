Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7D5F7140028
	for <lists+netdev@lfdr.de>; Fri, 17 Jan 2020 00:48:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391976AbgAPXsP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 18:48:15 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:43316 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729858AbgAPXsO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jan 2020 18:48:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=rmXiI3vzC8bbhiQCSSQ77/Y3ycjkva4fep8g+DTRJh0=; b=OImhmIjv6TUI80mkEkVUTIAL8t
        MvsEOzKFFnLQaVyUmOGsRM47UflQ9ZVLyQfrym0k61eMsf3Coh8TjPmYTafrANTrI86v9wpa/TCN9
        1Hbvf0kQiHWxCFj5WtDbjAOSMrazOjJSRGdLNi+HSHV0JbGVVh2Oh+M8mQV3AUemPZSw=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1isErv-0001O9-9t; Fri, 17 Jan 2020 00:48:07 +0100
Date:   Fri, 17 Jan 2020 00:48:07 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev@vger.kernel.org, cphealy@gmail.com,
        rmk+kernel@armlinux.org.uk, Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next v3] net: phy: Maintain MDIO device and bus
 statistics
Message-ID: <20200116234807.GJ19046@lunn.ch>
References: <20200116044856.1819-1-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200116044856.1819-1-f.fainelli@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 15, 2020 at 08:48:50PM -0800, Florian Fainelli wrote:
> We maintain global statistics for an entire MDIO bus, as well as broken
> down, per MDIO bus address statistics. Given that it is possible for
> MDIO devices such as switches to access MDIO bus addresses for which
> there is not a mdio_device instance created (therefore not a a
> corresponding device directory in sysfs either), we also maintain
> per-address statistics under the statistics folder. The layout looks
> like this:
> 
> /sys/class/mdio_bus/../statistics/
> 	transfers
> 	errrors
> 	writes
> 	reads
> 	transfers_<addr>
> 	errors_<addr>
> 	writes_<addr>
> 	reads_<addr>
> 
> When a mdio_device instance is registered, a statistics/ folder is
> created with the tranfers, errors, writes and reads attributes which
> point to the appropriate MDIO bus statistics structure.
> 
> Statistics are 64-bit unsigned quantities and maintained through the
> u64_stats_sync.h helper functions.
> 
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>

Tested-by: Andrew Lunn <andrew@lunn.ch>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
