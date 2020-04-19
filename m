Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BC691AFBA9
	for <lists+netdev@lfdr.de>; Sun, 19 Apr 2020 17:15:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726343AbgDSPPU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Apr 2020 11:15:20 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:48356 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725793AbgDSPPT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 19 Apr 2020 11:15:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=XVrE188aHRyG4rfR77ZMbP+LMlJ/d+camixd9PuWXjs=; b=5FcjKKuZ9E+5cmAaemeJbTd7eM
        JQTdowj4WWcTG0K+P6qBsIkEIIsO9Xy58dvgRrGAavQ31GcWtQ4au8oAKwPIwg/1vPZMIMw+Qa9vJ
        pWNOWcAgXhmluS0UlH92NbnCcb7vfUcWZ53Vobe1TRmv2oNuUpssvYlMhLKxmTnXovps=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jQBfA-003eL6-6J; Sun, 19 Apr 2020 17:15:16 +0200
Date:   Sun, 19 Apr 2020 17:15:16 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev@vger.kernel.org, Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next] net: phy: Propagate error from bus->reset
Message-ID: <20200419151516.GH836632@lunn.ch>
References: <20200419031713.24423-1-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200419031713.24423-1-f.fainelli@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Apr 18, 2020 at 08:17:13PM -0700, Florian Fainelli wrote:
> If a bus->reset() call for the mii_bus structure returns an error (e.g.:
> -EPROE_DEFER) we should propagate it accordingly.
> 
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
