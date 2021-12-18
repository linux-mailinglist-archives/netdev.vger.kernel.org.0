Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55EB9479BC8
	for <lists+netdev@lfdr.de>; Sat, 18 Dec 2021 17:53:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233620AbhLRQxD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Dec 2021 11:53:03 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:33488 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229552AbhLRQxC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 18 Dec 2021 11:53:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=MDwtg2LbDvKrineMm3PC1bHfpDSu9KouOSoRduAGoUY=; b=VHUiMLQfdaXshddWKnjF7utPbA
        1h1BVA7n3b4zYqfA8GlvuwLGbyraXl5Qf1hi6OmVTPCqmNOA/DPL8smsSAvqkHV5zO314k9uotEpf
        sH0iy3wbEKcbqccSY3I/xkXbGNGthS83CqXHoAc8eJoTi7euPZICOgmDC6YmdD6a9aao=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mycx5-00Gukz-1H; Sat, 18 Dec 2021 17:52:55 +0100
Date:   Sat, 18 Dec 2021 17:52:55 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Yevhen Orlov <yevhen.orlov@plvision.eu>
Cc:     netdev@vger.kernel.org,
        Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>,
        Taras Chornyi <taras.chornyi@plvision.eu>,
        Mickey Rachamim <mickeyr@marvell.com>,
        Serhiy Pshyk <serhiy.pshyk@plvision.eu>,
        Taras Chornyi <tchornyi@marvell.com>,
        Oleksandr Mazur <oleksandr.mazur@plvision.eu>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 0/6] prestera: add basic router driver support
Message-ID: <Yb4R55w1mq+NXOwO@lunn.ch>
References: <20211217195440.29838-1-yevhen.orlov@plvision.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211217195440.29838-1-yevhen.orlov@plvision.eu>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 17, 2021 at 09:54:32PM +0200, Yevhen Orlov wrote:
> Add initial router support for Marvell Prestera driver.
> Subscribe on inetaddr notifications. TRAP packets, that has to be routed
> (if packet has router's destination MAC address).

I must be missing something here. Why do you need to tell it the IP
address in order to perform software routing? All the switch needs to
know is the MAC address. Any packets for that MAC address should be
trapped to the host. The host can then decide what to do with it,
router, bridge, or consume it itself.

> Add features:
>  - Support ip address adding on port.
>    e.g.: "ip address add PORT 1.1.1.1/24"

This should just work already. If it does not, you have something
wrong in your current support.

	Andrew
