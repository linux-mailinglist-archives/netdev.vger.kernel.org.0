Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0AEB3422703
	for <lists+netdev@lfdr.de>; Tue,  5 Oct 2021 14:49:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234401AbhJEMu6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Oct 2021 08:50:58 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:49708 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232046AbhJEMuw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 Oct 2021 08:50:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=tqSNSLYNb3Te6dder1xIRr3pQgGJdKHt9Ww/f1QXaXQ=; b=QtYI9fv1rFEcQX+SVmBLn5Vokv
        n7+AROom0+beL3Pds/G5Qf7RKKGbF1kohj7l5xo/gQkrpQ5bII4GvC/WRKIqHoEhAZsyxU0zEmWbf
        pNfjK73NUQeH1wHjuLkmqgBcG5SaQZJi2ShTXTfW3quWSqb3dbHNEH2rxlqMGmBEPezs=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mXjsN-009gxk-6P; Tue, 05 Oct 2021 14:48:55 +0200
Date:   Tue, 5 Oct 2021 14:48:55 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Marcel Ziswiler <marcel@ziswiler.com>
Cc:     devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Frank Rowand <frowand.list@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: Re: [PATCH v1 1/4] dt-bindings: net: dsa: marvell: fix compatible in
 example
Message-ID: <YVxJt2ADMuVEwjnW@lunn.ch>
References: <20211005060334.203818-1-marcel@ziswiler.com>
 <20211005060334.203818-2-marcel@ziswiler.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211005060334.203818-2-marcel@ziswiler.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 05, 2021 at 08:03:31AM +0200, Marcel Ziswiler wrote:
> While the MV88E6390 switch chip exists, one is supposed to use a
> compatible of "marvell,mv88e6190" for it. Fix this in the given example.
> 
> Signed-off-by: Marcel Ziswiler <marcel@ziswiler.com>

Fixes: a3c53be55c95 ("net: dsa: mv88e6xxx: Support multiple MDIO busses")
Reviewed-by: Andrew Lunn <andrew@lunn.ch>

Hi Marcel

Since this is a fix, it should be sent separately, and for net, not
net-next.

Thanks

    Andrew
