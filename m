Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17A9426E5BE
	for <lists+netdev@lfdr.de>; Thu, 17 Sep 2020 21:56:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727738AbgIQOo5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Sep 2020 10:44:57 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:40762 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727678AbgIQOn0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 17 Sep 2020 10:43:26 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kIu8t-00F5IS-MX; Thu, 17 Sep 2020 15:40:07 +0200
Date:   Thu, 17 Sep 2020 15:40:07 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Willy Liu <willy.liu@realtek.com>
Cc:     hkallweit1@gmail.com, davem@davemloft.net, linux@armlinux.org.uk,
        kuba@kernel.org, ryankao@realtek.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: phy: realtek: Replace 2.5Gbps name from RTL8125 to
 RTL8226
Message-ID: <20200917134007.GN3526428@lunn.ch>
References: <1600306748-3176-1-git-send-email-willy.liu@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1600306748-3176-1-git-send-email-willy.liu@realtek.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 17, 2020 at 09:39:08AM +0800, Willy Liu wrote:
> According to PHY ID, 0x001cc800 should be named "RTL8226 2.5Gbps PHY"
> and 0x001cc840 should be named "RTL8226B_RTL8221B 2.5Gbps PHY".
> RTL8125 is not a single PHY solution, it integrates PHY/MAC/PCIE bus
> controller and embedded memory.
> 
> Signed-off-by: Willy Liu <willy.liu@realtek.com>

Hi Willy

Before submitting any more patches, please take a look at:

https://www.kernel.org/doc/html/latest/networking/netdev-FAQ.html

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
