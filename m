Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 730323BA8FD
	for <lists+netdev@lfdr.de>; Sat,  3 Jul 2021 16:33:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229987AbhGCOga (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Jul 2021 10:36:30 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:38768 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229671AbhGCOg3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 3 Jul 2021 10:36:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=bxpmHvEbw/VezIzfHWv/vzLPGzxuLIn6bZO/3A3ERaw=; b=1RSddJ6EHD8GFGpKnfSEtWWYKb
        mtE5c2rf+BusLTr58CLxPQNtguOqyUV+DlZKqhVJhvcB5JQ1RNkl0NqaIKMLZnuX6K3MGliy/Z/s0
        M6UwVoTvBBrL/e03lRyR2OyJLkJt8Jb7TrPfjtTwKy0CaxgkrEWeNH/WpcZ8hfGiKon4=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1lzgiD-00C2IF-Tf; Sat, 03 Jul 2021 16:33:41 +0200
Date:   Sat, 3 Jul 2021 16:33:41 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     '@lunn.ch, Florian Fainelli <f.fainelli@gmail.com>,
        linux-mips@vger.kernel.org, netdev@vger.kernel.org,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Jakub Kicinski <kuba@kernel.org>,
        Vladimir Oltean <olteanv@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v2 3/6] net: dsa: qca: ar9331: add forwarding
 database support'
Message-ID: <YOB1RRx0L01zJ+/v@lunn.ch>
References: <20210702101751.13168-1-o.rempel@pengutronix.de>
 <20210702101751.13168-4-o.rempel@pengutronix.de>
 <YN8tWtqfRRO7kAlb@lunn.ch>
 <20210703085644.dg5faj74ijg7orw6@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210703085644.dg5faj74ijg7orw6@pengutronix.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Thank you!
> Can I have your Reviewed-by with this changes?

net-next is not accepting any patches at the moment. So repost when it
re-opens and i will add the reviewed-by.

	 Andrew
