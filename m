Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A24E1B5DF8
	for <lists+netdev@lfdr.de>; Thu, 23 Apr 2020 16:37:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728297AbgDWOhY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Apr 2020 10:37:24 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:58630 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726363AbgDWOhY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 Apr 2020 10:37:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=3+fByAMXo9X0NbPvTaF3P44AieG5P/6XjT9WC6GWwOA=; b=WZQXdpe1xs5vNCcREe9Hlz/rQn
        KTy81E21moUdEgByQ0H3ujl4EFc7M0eQBwU910JMo1s0gi8i/7V1M6XAz+3e7u0mBIf9CAaBlJ6c/
        8vLooOTBmXCLmXSwQeEuKoF4864sdjREcpNl4OiVRnlEArF7+2bcmguE9RtOXT1r8BrE=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jRcyW-004OZN-Ci; Thu, 23 Apr 2020 16:37:12 +0200
Date:   Thu, 23 Apr 2020 16:37:12 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Colin King <colin.king@canonical.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Michael Walle <michael@walle.cc>,
        Guenter Roeck <linux@roeck-us.net>, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH][next] net: phy: bcm54140: fix less than zero comparison
 on an unsigned
Message-ID: <20200423143712.GA1020784@lunn.ch>
References: <20200423141016.19666-1-colin.king@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200423141016.19666-1-colin.king@canonical.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 23, 2020 at 03:10:16PM +0100, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> Currently the unsigned variable tmp is being checked for an negative
> error return from the call to bcm_phy_read_rdb and this can never
> be true since tmp is unsigned.  Fix this by making tmp a plain int.
> 
> Addresses-Coverity: ("Unsigned compared against 0")

I thought 0 was unsigned?

> Fixes: 4406d36dfdf1 ("net: phy: bcm54140: add hwmon support")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
