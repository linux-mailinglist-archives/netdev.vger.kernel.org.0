Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BACD01F8AB
	for <lists+netdev@lfdr.de>; Wed, 15 May 2019 18:30:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727059AbfEOQar (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 May 2019 12:30:47 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:36404 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726283AbfEOQaq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 May 2019 12:30:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=/jgEMIDy5Z7SXmgem/4x43oE0NiOTmkQaryEL2fpU6g=; b=LSfV+8kuk724zsZ7GaOEH0wQxN
        nM45NKzWj5vBTGbOlN7A81onmdgpFcubESpROzn+uU9Ht7TKd3EtEZeXpW7+JbyPI62W+ebFf14NM
        rrUhvBBTQP+7ZT96irl1DCKe3p0gBZ2VEeGmJdd8b+F+ldEfKiWJnOkf3DEwQwazb4IE=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hQwnh-0008VA-9Z; Wed, 15 May 2019 18:30:41 +0200
Date:   Wed, 15 May 2019 18:30:41 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Dinh Nguyen <dinguyen@kernel.org>, netdev@vger.kernel.org,
        davem@davemloft.net, joabreu@synopsys.com,
        Wei Liang Lim <wei.liang.lim@intel.com>
Subject: Re: [PATCH net-next] net: stmmac: socfpga: add RMII phy mode
Message-ID: <20190515163041.GB24455@lunn.ch>
References: <20190515144631.5490-1-dinguyen@kernel.org>
 <20190515152407.GA24455@lunn.ch>
 <cbe79f88-2f4c-a5bc-7dcd-e1dac253a787@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cbe79f88-2f4c-a5bc-7dcd-e1dac253a787@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 15, 2019 at 09:18:15AM -0700, Florian Fainelli wrote:
> On 5/15/19 8:24 AM, Andrew Lunn wrote:
> >> --- a/drivers/net/ethernet/stmicro/stmmac/dwmac-socfpga.c
> >> +++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-socfpga.c
> >> @@ -251,6 +251,9 @@ static int socfpga_dwmac_set_phy_mode(struct socfpga_dwmac *dwmac)
> >>  	case PHY_INTERFACE_MODE_SGMII:
> >>  		val = SYSMGR_EMACGRP_CTRL_PHYSEL_ENUM_GMII_MII;
> >>  		break;
> >> +	case PHY_INTERFACE_MODE_RMII:
> >> +		val = SYSMGR_EMACGRP_CTRL_PHYSEL_ENUM_RMII;
> >> +		break;
> > 
> > What about PHY_INTERFACE_MODE_RMII_ID, PHY_INTERFACE_MODE_RMII_RXID,
> > PHY_INTERFACE_MODE_RMII_TXID?
> 
> RMII is reduced MII not Reduced Gigabit MII (RGMII), which still
> operates at MII speed, therefore no concept of internal deal for RX/TX
> data lines, the change looks fine to me.

Upps, yes. Missed the missing G!

Sorry  for the noise.

       Andrew
