Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 074C72A0A78
	for <lists+netdev@lfdr.de>; Fri, 30 Oct 2020 16:55:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727004AbgJ3PzD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Oct 2020 11:55:03 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:54876 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725844AbgJ3PzC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 30 Oct 2020 11:55:02 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kYWjv-004NPc-Jc; Fri, 30 Oct 2020 16:54:55 +0100
Date:   Fri, 30 Oct 2020 16:54:55 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Willy Liu <willy.liu@realtek.com>
Cc:     hkallweit1@gmail.com, linux@armlinux.org.uk, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, ryankao@realtek.com
Subject: Re: [PATCH net-next] net: phy: realtek: Add support for RTL8221B-CG
 series
Message-ID: <20201030155455.GA1042051@lunn.ch>
References: <1604037380-16735-1-git-send-email-willy.liu@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1604037380-16735-1-git-send-email-willy.liu@realtek.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 30, 2020 at 01:56:20PM +0800, Willy Liu wrote:
> Realtek single-port 2.5Gbps Ethernet PHYs are list as below:
> RTL8226-CG: the 1st generation 2.5Gbps single port PHY
> RTL8226B-CG/RTL8221B-CG: the 2nd generation 2.5Gbps single port PHY
> RTL8221B-VB-CG: the 3rd generation 2.5Gbps single port PHY
> RTL8221B-VM-CG: the 2.5Gbps single port PHY with MACsec feature
> 
> This patch adds the minimal drivers to manage these transceivers.
> 
> Signed-off-by: Willy Liu <willy.liu@realtek.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
