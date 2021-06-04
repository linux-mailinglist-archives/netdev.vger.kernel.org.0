Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11C2C39C3DC
	for <lists+netdev@lfdr.de>; Sat,  5 Jun 2021 01:24:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231836AbhFDX0Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Jun 2021 19:26:16 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:46402 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229853AbhFDX0P (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Jun 2021 19:26:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=NVWQo2+M+77CNuw3/l4UoBJFVe3OkbHLNkyJJHkxNX8=; b=srvJezUPBYaD0bOIH22AyFCb0N
        77SxFSuBBqRTpO2nrLZSDKL4gsSiGT7wlflSvxqYhHAAF2UALN2AXjl2+9azPBVd3DiGbSDZfkln1
        HFd2PmsXL+92e1Tg77Gby0G5dXMbNJKAtk8SrVBO7WIOIF7CyWlr5YM5dS1o+qqHZqBU=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1lpJAu-007sMn-7I; Sat, 05 Jun 2021 01:24:24 +0200
Date:   Sat, 5 Jun 2021 01:24:24 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next v1 4/7] net: usb: asix: ax88772: add generic
 selftest support
Message-ID: <YLq2KOQBF+5fImPW@lunn.ch>
References: <20210604134244.2467-1-o.rempel@pengutronix.de>
 <20210604134244.2467-5-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210604134244.2467-5-o.rempel@pengutronix.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 04, 2021 at 03:42:41PM +0200, Oleksij Rempel wrote:
> With working phylib support we are able now to use generic selftests.
> 
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
