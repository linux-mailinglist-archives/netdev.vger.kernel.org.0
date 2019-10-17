Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EAF7CDB23A
	for <lists+netdev@lfdr.de>; Thu, 17 Oct 2019 18:22:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2440473AbfJQQWT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Oct 2019 12:22:19 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:50846 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391091AbfJQQWT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 17 Oct 2019 12:22:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=yYGDmTWdpok/xWnLGj7w6mA7xTyvaVCtiqcsC3AJCpQ=; b=2L+jAG8Ywqn73DSlznFpAet952
        vUroIflGLGIMEnu3QNwOuXpyLOY/ZGjiT7ph2pfGXhZQT98B8J/3fdzZvqx8YG07Q8c2jMQF1n8e9
        BoT+kzWK4wzK04r0iA8e+q2ZdrlJO8okRbkptmRX7YAZVwz+3MWII9AgeCnMJ20Ibd8w=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.92.2)
        (envelope-from <andrew@lunn.ch>)
        id 1iL8XW-0005Du-AQ; Thu, 17 Oct 2019 18:22:14 +0200
Date:   Thu, 17 Oct 2019 18:22:14 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Alexandre Belloni <alexandre.belloni@bootlin.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Vladimir Zapolskiy <vz@mleia.com>,
        Sylvain Lemieux <slemieux.tyco@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 2/2] net: lpc_eth: parse phy nodes from device tree
Message-ID: <20191017162214.GS17013@lunn.ch>
References: <20191017094757.26885-1-alexandre.belloni@bootlin.com>
 <20191017094757.26885-2-alexandre.belloni@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191017094757.26885-2-alexandre.belloni@bootlin.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 17, 2019 at 11:47:57AM +0200, Alexandre Belloni wrote:
> When connected to a micrel phy, phy_find_first doesn't work properly
> because the first phy found is on address 0, the broadcast address but, the
> first thing the phy driver is doing is disabling this broadcast address.
> The phy is then available only on address 1 but the mdio driver doesn't
> know about it.
> 
> Instead, register the mdio bus using of_mdiobus_register and try to find
> the phy description in device tree before falling back to phy_find_first.
> 
> This ultimately also allows to describe the interrupt the phy is connected
> to.
> 
> Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>

Hi Alexandre

It is normal to have a cover note for a patch series.

Otherwise:

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
