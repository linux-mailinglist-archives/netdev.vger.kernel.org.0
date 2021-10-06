Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8173C424AB7
	for <lists+netdev@lfdr.de>; Thu,  7 Oct 2021 01:51:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239863AbhJFXxl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Oct 2021 19:53:41 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:53174 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230513AbhJFXxk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 6 Oct 2021 19:53:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=p+EUkla6NLtHOgGQnxlHAUMhXKs0Gb4m5BVOENzPYM8=; b=ZyutL5ZSLYro1t0M2v5X6x9t84
        8EPQkpg74zOuFwlzROZkdNvsmpEgIIVJwVafkGjyUVgarPxhOVx2mIYJGGnsG8+Gj3rWe3vFAhG+6
        viA9Wyt6yUUUCntou5tQckp4LyMCRfEvBw9BQZPFLUzOWoHxyWvNGsm6Oo1Yb+3aCXLg=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mYGhI-009t75-UI; Thu, 07 Oct 2021 01:51:40 +0200
Date:   Thu, 7 Oct 2021 01:51:40 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Ansuel Smith <ansuelsmth@gmail.com>
Cc:     Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [net-next PATCH 04/13] drivers: net: phy: at803x: better
 describe debug regs
Message-ID: <YV42jMfuZo38MSxd@lunn.ch>
References: <20211006223603.18858-1-ansuelsmth@gmail.com>
 <20211006223603.18858-5-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211006223603.18858-5-ansuelsmth@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 07, 2021 at 12:35:54AM +0200, Ansuel Smith wrote:
> Give a name to known debug regs from Documentation instead of using
> unknown hex values.
> 
> Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
