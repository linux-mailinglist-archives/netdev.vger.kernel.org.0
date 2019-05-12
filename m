Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9D61D1AA05
	for <lists+netdev@lfdr.de>; Sun, 12 May 2019 04:38:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726229AbfELCiF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 May 2019 22:38:05 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:32771 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726101AbfELCiE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 11 May 2019 22:38:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=IEholCRmvo79RozHFinaMDbZJFmhTsk8i5Tl1GopLHY=; b=BUeTJCJja2+VdXzxihw5yYDmlR
        O87b8QHz76NktMZWEWUI73EbLreFJkRKz48KtMutbBo01ESxyAqEdQgPGKlOOwAtD+4ehQprcYjwT
        clBedmLSzEp2mhTvaBy038MQEe3EAYhdtiYrK1eKJLfrBRSNvOdi6JmDYRl1DTycidhE=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hPeN8-0008Uc-Qb; Sun, 12 May 2019 04:37:54 +0200
Date:   Sun, 12 May 2019 04:37:54 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Peter Geis <pgwipeout@gmail.com>
Cc:     Serge Semin <fancer.lancer@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Serge Semin <Sergey.Semin@t-platforms.ru>,
        netdev@vger.kernel.org,
        "linux-rockchip@lists.infradead.org" 
        <linux-rockchip@lists.infradead.org>
Subject: Re: [Regression] "net: phy: realtek: Add rtl8211e rx/tx delays
 config" breaks rk3328-roc-cc networking
Message-ID: <20190512023754.GK4889@lunn.ch>
References: <066a0d38-2c64-7a1e-d176-04341f0cb6d7@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <066a0d38-2c64-7a1e-d176-04341f0cb6d7@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, May 11, 2019 at 07:17:08PM -0400, Peter Geis wrote:
> Good Evening,
> 
> Commit f81dadbcf7fd067baf184b63c179fc392bdb226e "net: phy: realtek: Add
> rtl8211e rx/tx delays config" breaks networking completely on the
> rk3328-roc-cc.
> Reverting the offending commit solves the problem.

Hi Peter

The fix should be in net, and will soon make its way upwards.

    Andrew
