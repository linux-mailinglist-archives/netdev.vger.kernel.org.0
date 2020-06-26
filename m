Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 411B720BA29
	for <lists+netdev@lfdr.de>; Fri, 26 Jun 2020 22:21:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725834AbgFZUVE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jun 2020 16:21:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725780AbgFZUVE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jun 2020 16:21:04 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F235C03E979;
        Fri, 26 Jun 2020 13:21:04 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id ACEC9127320BC;
        Fri, 26 Jun 2020 13:21:02 -0700 (PDT)
Date:   Fri, 26 Jun 2020 13:21:01 -0700 (PDT)
Message-Id: <20200626.132101.413123758768311075.davem@davemloft.net>
To:     jbx6244@gmail.com
Cc:     peppe.cavallaro@st.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, kuba@kernel.org, mcoquelin.stm32@gmail.com,
        heiko@sntech.de, linux-rockchip@lists.infradead.org,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] net: stmmac: change Kconfig menu entry to
 STMMAC/DWMAC
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200626120527.10562-1-jbx6244@gmail.com>
References: <20200626120527.10562-1-jbx6244@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 26 Jun 2020 13:21:03 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Johan Jonker <jbx6244@gmail.com>
Date: Fri, 26 Jun 2020 14:05:26 +0200

> When a Rockchip user wants to enable support for
> the ethernet controller one has to search for
> something with STMicroelectronics.
> Change the Kconfig menu entry to STMMAC/DWMAC,
> so that it better reflects the options it enables.
> 
> Signed-off-by: Johan Jonker <jbx6244@gmail.com>

I'm not OK with this.  It's called internally stmmac
beause it's based upon an ST Microelectronics chipset.

This is what happens when we have several sub drivers
based upon a top-level common chipset "library".

The problem you have is that just knowing the driver
doesn't tell you the dependencies, but that's a larger
scope generic problem that needs a high level solution
rather then something we should be hacking around with
name adjustments here and there.
