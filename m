Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AC9963A14F
	for <lists+netdev@lfdr.de>; Sat,  8 Jun 2019 20:52:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727457AbfFHSwP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Jun 2019 14:52:15 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:38518 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727323AbfFHSwP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 8 Jun 2019 14:52:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=wwfe/kw/xcn42VGNSd2LBWdNKlPX9l/EJe3gYvcv8bg=; b=s4UPoIx+1aFTzpKIwYhntjtulA
        PkutqclWCX6+GlXC8Rdq83LR2drGBCL9ENeFzTl3nHvATof1ENwz0IoWhXYUhx/HWnF6BDPYh5lF4
        QfL9nkh7lxKmFaFLUfHKQMwKk0I7qoDanbnK2fvqHLLj747kNcM+cMo9rYyyWGD4B2gA=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hZgRp-00064p-6L; Sat, 08 Jun 2019 20:52:13 +0200
Date:   Sat, 8 Jun 2019 20:52:13 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     f.fainelli@gmail.com, vivien.didelot@gmail.com,
        davem@davemloft.net, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 2/2] net: dsa: sja1105: Add RGMII delay support
 for P/Q/R/S chips
Message-ID: <20190608185213.GB22700@lunn.ch>
References: <20190608161228.5730-1-olteanv@gmail.com>
 <20190608161228.5730-3-olteanv@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190608161228.5730-3-olteanv@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jun 08, 2019 at 07:12:28PM +0300, Vladimir Oltean wrote:
> As per the DT phy-mode specification, RGMII delays are applied by the
> MAC when there is no PHY present on the link.
> 
> Signed-off-by: Vladimir Oltean <olteanv@gmail.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
