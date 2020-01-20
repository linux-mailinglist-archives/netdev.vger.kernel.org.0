Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ECFD0142606
	for <lists+netdev@lfdr.de>; Mon, 20 Jan 2020 09:44:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727065AbgATIoe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jan 2020 03:44:34 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:54862 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726451AbgATIoe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jan 2020 03:44:34 -0500
Received: from localhost (82-95-191-104.ip.xs4all.nl [82.95.191.104])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 79133153CB398;
        Mon, 20 Jan 2020 00:44:31 -0800 (PST)
Date:   Mon, 20 Jan 2020 09:44:27 +0100 (CET)
Message-Id: <20200120.094427.1467601968385671074.davem@davemloft.net>
To:     zhengdejin5@gmail.com
Cc:     peppe.cavallaro@st.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, mcoquelin.stm32@gmail.com,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: stmmac: modified pcs mode support for RGMII
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200115155323.15543-1-zhengdejin5@gmail.com>
References: <20200115155323.15543-1-zhengdejin5@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 20 Jan 2020 00:44:33 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dejin Zheng <zhengdejin5@gmail.com>
Date: Wed, 15 Jan 2020 23:53:23 +0800

> snps databook noted that physical coding sublayer (PCS) interface
> that can be used when the MAC is configured for the TBI, RTBI, or
> SGMII PHY interface. we have RGMII and SGMII in a SoC and it also
> has the PCS block. it needs stmmac_init_phy and stmmac_mdio_register
> function for initializing phy when it used RGMII interface.
> 
> Signed-off-by: Dejin Zheng <zhengdejin5@gmail.com>

Applied to net-next, thank you.
