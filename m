Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 305911AA8F4
	for <lists+netdev@lfdr.de>; Wed, 15 Apr 2020 15:47:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2636214AbgDONpW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Apr 2020 09:45:22 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:39628 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2636203AbgDONpT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Apr 2020 09:45:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=mFdulGoyzXjkcnbudHCs8v43UlFuR/6b6qFTHBhgztQ=; b=aT9ZDP6NUhJkvzVM5Rv4I0IaCH
        2xBYHrQu7THMIFbFvSLSgbwRerLp0iMoF10yXHaGU8vYiNICcFX86T7lihyx6Ez+By+pVnGnvofi9
        0KKSBL3xm4o2mzc4RJ83veghAOHV7plgcKDdCy5GdpK/S0YpoDNJmAidq6nW5MLEEGAo=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jOiLn-002t3u-FB; Wed, 15 Apr 2020 15:45:11 +0200
Date:   Wed, 15 Apr 2020 15:45:11 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Michal Kubecek <mkubecek@suse.cz>,
        David Jander <david@protonic.nl>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Russell King <linux@armlinux.org.uk>, mkl@pengutronix.de
Subject: Re: [PATCH v1] ethtool: provide UAPI for PHY master/slave
 configuration.
Message-ID: <20200415134511.GB657811@lunn.ch>
References: <20200415121209.12197-1-o.rempel@pengutronix.de>
 <20200415131104.GA657811@lunn.ch>
 <20200415133728.urvsdolwhaa4eknm@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200415133728.urvsdolwhaa4eknm@pengutronix.de>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> In the IEEE 802.3 it is described as:
> ---------------------------------------------------------------------------
> Port type: Bit 9.10 is to be used to indicate the preference to operate
> as MASTER (multiport device) or as SLAVE (single-port device) if the
> MASTER-SLAVE Manual Configuration Enable bit, 9.12, is not set.  Usage
> of this bit is described in 40.5.2.
> 1 = Multiport device
> 0 = single-port device

I really should go read the standard, but...

> ---------------------------------------------------------------------------
> 
> Setting PORT_MODE_MASTER/PORT_MODE_SLAVE will increase the chance to get
> MASTER or SLAVE mode, but not force it.
> 
> If we will follow strictly to the IEEE 802.3 spec, it should be named:
> 
> #define PORT_MODE_UNKNOWN	0x00
> /* this two options will not force some specific mode, only influence
>  * the chance to get it */
> #define PORT_TYPE_MULTI_PORT	0x01
> #define PORT_TYPE_SINGLE_PORT	0x02
> /* this two options will force master or slave mode */
> #define PORT_MODE_MASTER	0x03
> #define PORT_MODE_SLAVE		0x04

I prefer having FORCE in the name.

But let me read the standard and get up to speed.

    Andrew
