Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 73B71FF0DA
	for <lists+netdev@lfdr.de>; Sat, 16 Nov 2019 17:08:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731804AbfKPQIG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Nov 2019 11:08:06 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:42936 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730470AbfKPQIF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 16 Nov 2019 11:08:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=Qbe4TXEBkrfgX6IC8m6/gGbSVCgk/+e6wzluswb5du8=; b=otd9vrV4NWE/LOBN3DYjrhwJQs
        RfqUdrIpFJHCGIDm1lTDYbbmM3igUoYRgAuRE63iSiBCeFUxfiteaxr+egYYcQIDnAUW32xccyxhT
        5ccBlA89nXTlLf+fsG1LoPu+/jNz3gpzba1u2/iXMQFnxCdGxxqC5HDu3oy0eo1/yLts=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.92.2)
        (envelope-from <andrew@lunn.ch>)
        id 1iW0cD-0005rk-9F; Sat, 16 Nov 2019 17:08:01 +0100
Date:   Sat, 16 Nov 2019 17:08:01 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Russell King <rmk+kernel@armlinux.org.uk>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH] net: phylink: update to use phy_support_asym_pause()
Message-ID: <20191116160801.GC5653@lunn.ch>
References: <E1iVhqj-0007eY-8u@rmk-PC.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1iVhqj-0007eY-8u@rmk-PC.armlinux.org.uk>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 15, 2019 at 08:05:45PM +0000, Russell King wrote:
> Use phy_support_asym_pause() rather than open-coding it.
> 
> Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew

