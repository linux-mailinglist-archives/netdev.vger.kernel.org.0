Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 842B217D2CE
	for <lists+netdev@lfdr.de>; Sun,  8 Mar 2020 10:17:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726260AbgCHJRF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Mar 2020 05:17:05 -0400
Received: from relay5-d.mail.gandi.net ([217.70.183.197]:48155 "EHLO
        relay5-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725854AbgCHJRF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 Mar 2020 05:17:05 -0400
X-Originating-IP: 37.167.192.10
Received: from localhost (unknown [37.167.192.10])
        (Authenticated sender: repk@triplefau.lt)
        by relay5-d.mail.gandi.net (Postfix) with ESMTPSA id E877F1C0004;
        Sun,  8 Mar 2020 09:16:50 +0000 (UTC)
Date:   Sun, 8 Mar 2020 10:25:36 +0100
From:   Remi Pommarel <repk@triplefau.lt>
To:     Jose Abreu <Jose.Abreu@synopsys.com>
Cc:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        "David S. Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-amlogic@lists.infradead.org" 
        <linux-amlogic@lists.infradead.org>
Subject: Re: [PATCH] net: stmmac: dwmac1000: Disable ACS if enhanced descs
 are not used
Message-ID: <20200308092536.GQ2248@voidbox>
References: <20200306193036.18414-1-repk@triplefau.lt>
 <BYAPR12MB326999F850BD9BDD037D87CAD3E00@BYAPR12MB3269.namprd12.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BYAPR12MB326999F850BD9BDD037D87CAD3E00@BYAPR12MB3269.namprd12.prod.outlook.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Mar 07, 2020 at 05:34:28PM +0000, Jose Abreu wrote:
> From: Remi Pommarel <repk@triplefau.lt>
> Date: Mar/06/2020, 19:30:36 (UTC+00:00)
> 
> >  	void __iomem *ioaddr = hw->pcsr;
> > +	struct stmmac_priv *priv = netdev_priv(dev);
> >  	u32 value = readl(ioaddr + GMAC_CONTROL);
> >  	int mtu = dev->mtu;
> 
> Please use reverse Christmas tree order and also provide a Fixes tag.

Done in v2.

Thanks,
-- 
Remi
