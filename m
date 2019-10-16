Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E0A9BD903A
	for <lists+netdev@lfdr.de>; Wed, 16 Oct 2019 13:59:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388046AbfJPL7e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Oct 2019 07:59:34 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:48142 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387930AbfJPL7e (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 16 Oct 2019 07:59:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=ZSzUaD/kQ4pwZMoB4pabopFlBdiauaJ0IWNrFeuxbyY=; b=ryTD8MLdgRy1HJCbl/0jy8wpz/
        o2VE+PMO+IJW6Z+YW8AdzqS8uckvCRWJ/PCqdC8aBUVLZAzy1N6moyeBtjRbCYeNVZu85gk1OUTjX
        IzezMY60VwA90bArmnU2TRGH9GNIQrtGIZFI+9N0dLkZwl5AOldJE5WtS5r4d++WpdOo=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.92.2)
        (envelope-from <andrew@lunn.ch>)
        id 1iKhxi-0007Bh-T2; Wed, 16 Oct 2019 13:59:30 +0200
Date:   Wed, 16 Oct 2019 13:59:30 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Marek Vasut <marex@denx.de>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        George McCollister <george.mccollister@gmail.com>,
        Tristram Ha <Tristram.Ha@microchip.com>,
        Woojung Huh <woojung.huh@microchip.com>
Subject: Re: [PATCH V2 1/2] net: dsa: microchip: Do not reinit mutexes on
 KSZ87xx
Message-ID: <20191016115930.GB4780@lunn.ch>
References: <20191013193238.1638-1-marex@denx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191013193238.1638-1-marex@denx.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Oct 13, 2019 at 09:32:37PM +0200, Marek Vasut wrote:
> The KSZ87xx driver calls mutex_init() on mutexes already inited in
> ksz_common.c ksz_switch_register(). Do not do it twice, drop the
> reinitialization.
> 
> Signed-off-by: Marek Vasut <marex@denx.de>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
