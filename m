Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7D634973C2
	for <lists+netdev@lfdr.de>; Sun, 23 Jan 2022 18:39:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239270AbiAWRjl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Jan 2022 12:39:41 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:49812 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232441AbiAWRjl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 23 Jan 2022 12:39:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=TpeFrxH14YUq45bMnvehHjYdMHvlZ8HQZ1rF7DFjtM0=; b=HDVD6mcewueDYju4m+947+6S7s
        9IC6udZX/q4dlqxA5MVOk5IIyklMKNYUmFg1lQBfVUvRszN8ZXEtKOEalV3lcp++dji2jb/is4Pd1
        vFfsc/c9sZWIiinIC+kpE2pHNjLq7oH5uaeLuuWVjXpKMprgCiGPHJ5ZB+O0JSe9XbU4=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nBgpq-002Oqt-BT; Sun, 23 Jan 2022 18:39:26 +0100
Date:   Sun, 23 Jan 2022 18:39:26 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jisheng Zhang <jszhang@kernel.org>
Cc:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: stmmac: don't stop RXC during LPI
Message-ID: <Ye2SznI2rNKAUDIq@lunn.ch>
References: <20220123141245.1060-1-jszhang@kernel.org>
 <Ye15va7tFWMgKPEE@lunn.ch>
 <Ye19bHxcQ5Plx0v9@xhacker>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Ye19bHxcQ5Plx0v9@xhacker>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> I think this is a common issue because the MAC needs phy's RXC for RX
> logic. But it's better to let other stmmac users verify. The issue
> can easily be reproduced on platforms with PHY_POLL external phy.

What is the relevance of PHY polling here? Are you saying if the PHY
is using interrupts you do not see this issue?

     Andrew
