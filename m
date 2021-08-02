Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B76243DE038
	for <lists+netdev@lfdr.de>; Mon,  2 Aug 2021 21:42:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229571AbhHBTmy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Aug 2021 15:42:54 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:58106 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229612AbhHBTmw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Aug 2021 15:42:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=sN4KDunurye5XxF7bw52w4+xclrqcyu5uBX2K3T/OA8=; b=bSVVy75HefYpA4IPbSvM3f0eLy
        FlJjLd5xnThrTh0W47ogHQvp3bwvKtpLf6irtedtUuiHtTwWHg6Ek8NeC5rtNuXaUSJ4GjWZGtZlO
        FFUQVx6QezhCiLKQB1noWi7R0Mopr8Wr+K5D+vev63/p4IjiqaUmwsgOXtlIl2RzeDpg=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mAdpZ-00Frqe-CH; Mon, 02 Aug 2021 21:42:33 +0200
Date:   Mon, 2 Aug 2021 21:42:33 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mips@vger.kernel.org
Subject: Re: [PATCH net-next v3 2/6] net: dsa: qca: ar9331: make proper
 initial port defaults
Message-ID: <YQhKqale0gbw3DYY@lunn.ch>
References: <20210802131037.32326-1-o.rempel@pengutronix.de>
 <20210802131037.32326-3-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210802131037.32326-3-o.rempel@pengutronix.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 02, 2021 at 03:10:33PM +0200, Oleksij Rempel wrote:
> Make sure that all external port are actually isolated from each other,
> so no packets are leaked.
> 
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
