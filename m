Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 10DF630E33
	for <lists+netdev@lfdr.de>; Fri, 31 May 2019 14:40:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726798AbfEaMju (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 08:39:50 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:44508 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726330AbfEaMju (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 31 May 2019 08:39:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=5a+ks8KczJ0w7srPtbo3j+uOInJQKmeeWwa3BYlP8Jg=; b=TbBDViJDIRbtCWzVHNraiHVgjf
        yGz0LWrnDnKOoAZQoxaLhRrCNtBbxPsdo+Ly0gx3C9++zOvUDKGgvMBcaT3w1dLecVeSasVtopBNq
        wNCiN3lpRCofM/8oixLT0vbAWD3uthn5sC9wo8U8p8HAKOGqu6LKjukVxyxWzAtdTulQ=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hWgov-0005S6-FV; Fri, 31 May 2019 14:39:41 +0200
Date:   Fri, 31 May 2019 14:39:41 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Voon Weifeng <weifeng.voon@intel.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jose Abreu <joabreu@synopsys.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        biao huang <biao.huang@mediatek.com>,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        Kweh Hock Leong <hock.leong.kweh@intel.com>
Subject: Re: [PATCH net-next v5 1/5] net: stmmac: enable clause 45 mdio
 support
Message-ID: <20190531123941.GD18608@lunn.ch>
References: <1559332694-6354-1-git-send-email-weifeng.voon@intel.com>
 <1559332694-6354-2-git-send-email-weifeng.voon@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1559332694-6354-2-git-send-email-weifeng.voon@intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jun 01, 2019 at 03:58:10AM +0800, Voon Weifeng wrote:
> From: Kweh Hock Leong <hock.leong.kweh@intel.com>
> 
> DWMAC4 is capable to support clause 45 mdio communication.
> This patch enable the feature on stmmac_mdio_write() and
> stmmac_mdio_read() by following phy_write_mmd() and
> phy_read_mmd() mdiobus read write implementation format.
> 
> Reviewed-by: Li, Yifan <yifan2.li@intel.com>
> Signed-off-by: Kweh Hock Leong <hock.leong.kweh@intel.com>
> Signed-off-by: Ong Boon Leong <boon.leong.ong@intel.com>
> Signed-off-by: Weifeng Voon <weifeng.voon@intel.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
