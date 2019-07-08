Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DC72D626FF
	for <lists+netdev@lfdr.de>; Mon,  8 Jul 2019 19:24:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733010AbfGHRYl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jul 2019 13:24:41 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:60964 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728744AbfGHRYl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Jul 2019 13:24:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=PXPrALiVedXxsDHKDjsbXRcTsWug8OY8up8Jb6866Uk=; b=NiOMtHaZHVsf47YAEaQbppY+GA
        BT53wsKj0Qhom0TkaQwtvTvp75RfnNaPLnqOtPTX/sY4QszOEmk9heXd5SA/WWN8ucpn1iSjso7vP
        Hkx+B6PJBlXbqhruUs+uO/3Tp2x0PtyYrm590Dupd8bPH6vureAZM8G+WpqDYq+6tnnI=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hkXNU-0003fv-6p; Mon, 08 Jul 2019 19:24:36 +0200
Date:   Mon, 8 Jul 2019 19:24:36 +0200
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
Subject: Re: [PATCH v2 net-next] net: stmmac: enable clause 45 mdio support
Message-ID: <20190708172436.GF9027@lunn.ch>
References: <1562348007-12263-1-git-send-email-weifeng.voon@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1562348007-12263-1-git-send-email-weifeng.voon@intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jul 06, 2019 at 01:33:27AM +0800, Voon Weifeng wrote:
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
> Signed-off-by: Voon Weifeng <weifeng.voon@intel.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
