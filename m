Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8AF5B10A073
	for <lists+netdev@lfdr.de>; Tue, 26 Nov 2019 15:37:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727827AbfKZOhX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Nov 2019 09:37:23 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:56642 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726101AbfKZOhX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 Nov 2019 09:37:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=oKkdwn0/YwK2hGC0uEm2QqP4fqSSsp4M7q3bSY4IohY=; b=baXi3B1tEmHUqbmdc44YZwyxBS
        96d8goz5ZmE4om9rTbjDA67dmR7wColKCZ2ivfq82HsmkxBctOTtwu025ubJrK147ZAPvhQ3Rr8we
        GCwerM3cYuo6a/R4lp8USxevFKF52PfWoKNkPsc9oDHbdLPhMpyO6kciCdrhJvJImJe4=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.92.2)
        (envelope-from <andrew@lunn.ch>)
        id 1iZbxt-0003XR-57; Tue, 26 Nov 2019 15:37:17 +0100
Date:   Tue, 26 Nov 2019 15:37:17 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Milind Parab <mparab@cadence.com>
Cc:     antoine.tenart@bootlin.com, nicolas.ferre@microchip.com,
        davem@davemloft.net, netdev@vger.kernel.org, f.fainelli@gmail.com,
        hkallweit1@gmail.com, linux-kernel@vger.kernel.org,
        dkangude@cadence.com, pthombar@cadence.com
Subject: Re: [PATCH 2/3] net: macb: add support for C45 MDIO read/write
Message-ID: <20191126143717.GP6602@lunn.ch>
References: <1574759354-102696-1-git-send-email-mparab@cadence.com>
 <1574759389-103118-1-git-send-email-mparab@cadence.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1574759389-103118-1-git-send-email-mparab@cadence.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 26, 2019 at 09:09:49AM +0000, Milind Parab wrote:
> This patch modify MDIO read/write functions to support
> communication with C45 PHY.

I think i've asked this before, at least once, but you have not added
it to the commit messages. Do all generations of the macb support C45?


FYI: Net next is closed at the moment, so your patches will be
rejected. Please post again when it re-opens.

	  Andrew
