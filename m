Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3D291141EFD
	for <lists+netdev@lfdr.de>; Sun, 19 Jan 2020 17:14:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727465AbgASQMr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Jan 2020 11:12:47 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:45848 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726778AbgASQMr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 19 Jan 2020 11:12:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=TpONs6HmP9hLhUMO7GsCvgxo1opeMZR5lpvUYD5DktM=; b=y8Kuxlb2BxATtgKn87RSipy1fG
        LOJFVC4cpw6uJkIOb2V5rmK6nUan/WVbDXGj6b6//uij6jSYdClmIHEjC4CF2T7MxEpnFooKPkIaX
        niQPPO+tAoeA73Akz9Nbj/HaSfmmdyk940+6wYgUKUoCo9Xw+pJFxIvYLCrOs0ttpzhI=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1itDBo-0004eM-B2; Sun, 19 Jan 2020 17:12:40 +0100
Date:   Sun, 19 Jan 2020 17:12:40 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        David Miller <davem@davemloft.net>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next 0/2] net: phy: add generic ndo_do_ioctl handler
 phy_do_ioctl
Message-ID: <20200119161240.GA17720@lunn.ch>
References: <520c07a1-dd26-1414-0a2f-7f0d491589d1@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <520c07a1-dd26-1414-0a2f-7f0d491589d1@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jan 19, 2020 at 02:31:06PM +0100, Heiner Kallweit wrote:
> A number of network drivers has the same glue code to use phy_mii_ioctl
> as ndo_do_ioctl handler. So let's add such a generic ndo_do_ioctl
> handler to phylib. As first user convert r8169.

Hi Heiner

Looks sensible. 

Two questions:

Did you look at how many drivers don't make the running check? I know
there are some MAC drivers which allow PHY ioctls when the interface
is down.  So maybe we want to put _running_ into this helper name, and
add anther helper which does not check for running?

Do you plan to convert any more MAC drivers?

   Andrew
