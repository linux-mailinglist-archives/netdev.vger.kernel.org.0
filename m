Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECDDD1AD175
	for <lists+netdev@lfdr.de>; Thu, 16 Apr 2020 22:49:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727864AbgDPUs5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Apr 2020 16:48:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725894AbgDPUs4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Apr 2020 16:48:56 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9802AC061A0C;
        Thu, 16 Apr 2020 13:48:56 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 627C412757E6A;
        Thu, 16 Apr 2020 13:48:55 -0700 (PDT)
Date:   Thu, 16 Apr 2020 13:48:54 -0700 (PDT)
Message-Id: <20200416.134854.89754180705215688.davem@davemloft.net>
To:     f.fainelli@gmail.com
Cc:     netdev@vger.kernel.org, olteanv@gmail.com, peppe.cavallaro@st.com,
        alexandre.torgue@st.com, joabreu@synopsys.com, mripard@kernel.org,
        wens@csie.org, mcoquelin.stm32@gmail.com,
        linux-arm-kernel@lists.infradead.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] net: stmmac: dwmac-sunxi: Provide TX and RX fifo
 sizes
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200414223952.5886-1-f.fainelli@gmail.com>
References: <20200414223952.5886-1-f.fainelli@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 16 Apr 2020 13:48:56 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Fainelli <f.fainelli@gmail.com>
Date: Tue, 14 Apr 2020 15:39:52 -0700

> After commit bfcb813203e619a8960a819bf533ad2a108d8105 ("net: dsa:
> configure the MTU for switch ports") my Lamobo R1 platform which uses
> an allwinner,sun7i-a20-gmac compatible Ethernet MAC started to fail
> by rejecting a MTU of 1536. The reason for that is that the DMA
> capabilities are not readable on this version of the IP, and there
> is also no 'tx-fifo-depth' property being provided in Device Tree. The
> property is documented as optional, and is not provided.
> 
> Chen-Yu indicated that the FIFO sizes are 4KB for TX and 16KB for RX, so
> provide these values through platform data as an immediate fix until
> various Device Tree sources get updated accordingly.
> 
> Fixes: eaf4fac47807 ("net: stmmac: Do not accept invalid MTU values")
> Suggested-by: Chen-Yu Tsai <wens@csie.org>
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>

Applied and queued up for -stable, thanks.
