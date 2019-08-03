Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0332C80886
	for <lists+netdev@lfdr.de>; Sun,  4 Aug 2019 00:23:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729206AbfHCWW7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Aug 2019 18:22:59 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:58922 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729195AbfHCWW6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 3 Aug 2019 18:22:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=wXhy7Y9XBu632+EH0hMzaNos8wsO8EH/iThD5p4gReA=; b=rt3fI8LvIp209fSWlTo8mkurYe
        SUbtcbFZOrH8rYUu7Gj1NZdhWe5ANcKN8BLuZkyVv2qzxQN3IBZ3x5HK9e1wUXyCkQNYk+3/6qiRw
        Mg90VgE9qY+2gpyZ+2dWYzR4TWZgp5dBCHRaJljC2S1WgZcIAr13puJ1bF6AqfnlKfa4=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hu2QP-000806-1C; Sun, 04 Aug 2019 00:22:53 +0200
Date:   Sun, 4 Aug 2019 00:22:53 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Arnaud Patard <arnaud.patard@rtp-net.org>
Cc:     netdev@vger.kernel.org
Subject: Re: [patch 1/1] drivers/net/ethernet/marvell/mvmdio.c: Fix non OF
 case
Message-ID: <20190803222253.GA29685@lunn.ch>
References: <20190802083310.772136040@rtp-net.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190802083310.772136040@rtp-net.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 02, 2019 at 10:32:40AM +0200, Arnaud Patard wrote:
> Orion5.x systems are still using machine files and not device-tree.
> Commit 96cb4342382290c9 ("net: mvmdio: allow up to three clocks to be
> specified for orion-mdio") has replaced devm_clk_get() with of_clk_get(),
> leading to a oops at boot and not working network, as reported in 
> https://lists.debian.org/debian-arm/2019/07/msg00088.html and possibly in
> https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=908712.
> 
> Link: https://lists.debian.org/debian-arm/2019/07/msg00088.html
> Fixes: 96cb4342382290c9 ("net: mvmdio: allow up to three clocks to be specified for orion-mdio")
> Signed-off-by: Arnaud Patard <arnaud.patard@rtp-net.org>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
