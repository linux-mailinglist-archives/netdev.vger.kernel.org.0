Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DD7F218E31B
	for <lists+netdev@lfdr.de>; Sat, 21 Mar 2020 18:01:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727745AbgCURBt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Mar 2020 13:01:49 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:49196 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726961AbgCURBt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 21 Mar 2020 13:01:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=64MMgAHQznGOH5Y++tpY7qj4XY7szKSqHJzx+oRG19o=; b=mU8z4ONygm4uHja8MGibs0kmMy
        ab8CaKD15ORC78IpMmHD8j4Q54DWGEu0AxoXN29EBsKuWKhTcPeY5LYCXB6bW2YT0oD/BRfj0lPxv
        K6jVd8J/f30oB0uzadxo6hPtcdqEhtNAoj006Uq/fMUZjy6V4d1I+js6cN6eY5EhZXAs=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jFhVK-0006E1-AJ; Sat, 21 Mar 2020 18:01:46 +0100
Date:   Sat, 21 Mar 2020 18:01:46 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Antoine Tenart <antoine.tenart@bootlin.com>,
        "David S. Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH net-next 1/4] net: phy: mscc: rename enum
 rgmii_rx_clock_delay to rgmii_clock_delay
Message-ID: <20200321170146.GF22639@lunn.ch>
References: <20200319211649.10136-1-olteanv@gmail.com>
 <20200319211649.10136-2-olteanv@gmail.com>
 <20200320100925.GB16662@lunn.ch>
 <CA+h21hrvsfwspGE6z37p-fwso3oD0pXijh+fZZfEEUEv6bySHQ@mail.gmail.com>
 <158470229183.43774.8932556125293087780@kwain>
 <CA+h21ho4aqgCSjgPTJ10cVeUow_RAUTNd9NSrVPJJVEqjAws9g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+h21ho4aqgCSjgPTJ10cVeUow_RAUTNd9NSrVPJJVEqjAws9g@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> And to add to that: without documentation, I don't really know what
> I'm consolidating.

It looked like the defines for the delays could be shared. But if you
are not happy with this, lets leave it as is.

    Andrew
