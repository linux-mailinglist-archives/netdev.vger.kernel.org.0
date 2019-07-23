Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 42C1171989
	for <lists+netdev@lfdr.de>; Tue, 23 Jul 2019 15:40:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390355AbfGWNkq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jul 2019 09:40:46 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:59312 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390251AbfGWNkq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Jul 2019 09:40:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=WT3oDovkoe1bfd1iWcc8ualJNMhBVWi0I2gGsRsRw5Y=; b=roktKFKgOalv46lwcSCeBJOVe0
        7nL/GlBlNk6uA5Nnp85pRtUg1HozlzNczDECrhxg+a+zgapXw3U6EbzY7ieDqCs2PMXLShiJ1AdDy
        eBT9rWtMjv/5dSy5jZuRTbWxYTYc+B/LiOqVe6tmw7azDaN6OsK8hN6G42AXRxNZZzbQ=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hpv1x-0001ER-T9; Tue, 23 Jul 2019 15:40:37 +0200
Date:   Tue, 23 Jul 2019 15:40:37 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Rasmus Villemoes <rasmus.villemoes@prevas.dk>
Cc:     Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Rasmus Villemoes <Rasmus.Villemoes@prevas.se>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next] net: dsa: mv88e6xxx: avoid some redundant vtu
 load/purge operations
Message-ID: <20190723134037.GA2381@lunn.ch>
References: <20190722233713.31396-1-rasmus.villemoes@prevas.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190722233713.31396-1-rasmus.villemoes@prevas.dk>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 22, 2019 at 11:37:26PM +0000, Rasmus Villemoes wrote:
> We have an ERPS (Ethernet Ring Protection Switching) setup involving
> mv88e6250 switches which we're in the process of switching to a BSP
> based on the mainline driver. Breaking any link in the ring works as
> expected, with the ring reconfiguring itself quickly and traffic
> continuing with almost no noticable drops. However, when plugging back
> the cable, we see 5+ second stalls.

Hi Rasmus

I would prefer Vivien reviews this patch. But he is away at the
moment. Are you O.K. to wait a few days?

	Andrew
