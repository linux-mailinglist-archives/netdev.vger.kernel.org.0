Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4474449E671
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 16:44:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243057AbiA0PoA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 10:44:00 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:58116 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234341AbiA0PoA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 Jan 2022 10:44:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=NRNfjci1BUqMB7hhJHAezNYkKercVodV9D1Lc98O3ZE=; b=yF5nFX+LAKzUnFrdwhYrQ29vb+
        LLgfv6kPaZAiKmc165TT20rHGLoi8fVqSLClhC6jJAK5KgqJLYPX6HgCgNjlIePdLjiuTokqh8KDW
        SDI/cgY78nVbw9WCgvblLjTvp/P5rZUqlIC/L0k81APy44gHNX/nFnxUmAEou686GbcU=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nD6wD-0030do-4Y; Thu, 27 Jan 2022 16:43:53 +0100
Date:   Thu, 27 Jan 2022 16:43:53 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Oliver Neukum <oneukum@suse.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next v1 1/1] usbnet: add devlink support
Message-ID: <YfK9uV0BviEiemDi@lunn.ch>
References: <20220127110742.922752-1-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220127110742.922752-1-o.rempel@pengutronix.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 27, 2022 at 12:07:42PM +0100, Oleksij Rempel wrote:
> The weakest link of usbnet devices is the USB cable. Currently there is
> no way to automatically detect cable related issues except of analyzing
> kernel log, which would differ depending on the USB host controller.
> 
> The Ethernet packet counter could potentially show evidence of some USB
> related issues, but can be Ethernet related problem as well.

I don't know the usbnet drivers very well. A quick look suggests they
don't support statistics via ethtool -S. So you could make use of that
to return statistics about USB error events.

However, GregKH point still stands, maybe such statistics should be
made for all USB devices, and be available in /sys/bus/usb/devices/*

     Andrew
