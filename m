Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4603C3BA280
	for <lists+netdev@lfdr.de>; Fri,  2 Jul 2021 17:06:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232058AbhGBPIw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Jul 2021 11:08:52 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:37628 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231791AbhGBPIw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 2 Jul 2021 11:08:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=vEFH4//fNmJ1dKiJR0SLis4t45bfQOPUbiQDB7XuDNA=; b=5nT8qjfrkE0IcxtelKNfFJfBZf
        6OFa1V+xg9+TiiXGmlDA0ryD9DxZfhWyNTvJ2Mm2CuiY0cxad3rCHR7insTZQjDKMFSBebwgkaIpu
        9gRhMJincKxaaa8BNxYV1F58ZkTUQu//gmc1wrDpSNyolk7fOIPafVp9iF1bvhYlW0Ec=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1lzKk7-00BviL-G6; Fri, 02 Jul 2021 17:06:11 +0200
Date:   Fri, 2 Jul 2021 17:06:11 +0200
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
Subject: Re: [PATCH net-next v2 2/6] net: dsa: qca: ar9331: make proper
 initial port defaults
Message-ID: <YN8rY5wDVv0tca85@lunn.ch>
References: <20210702101751.13168-1-o.rempel@pengutronix.de>
 <20210702101751.13168-3-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210702101751.13168-3-o.rempel@pengutronix.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 02, 2021 at 12:17:47PM +0200, Oleksij Rempel wrote:
> Make sure that all external port are actually isolated from each other,
> so no packets are leaked.
> 
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
