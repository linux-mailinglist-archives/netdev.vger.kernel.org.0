Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55C6C424B29
	for <lists+netdev@lfdr.de>; Thu,  7 Oct 2021 02:33:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239861AbhJGAf3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Oct 2021 20:35:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:55584 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230435AbhJGAf0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 6 Oct 2021 20:35:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 823BF6101A;
        Thu,  7 Oct 2021 00:33:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633566814;
        bh=3okcXnxuE+BIfBFhHPL9nH1JgO502cHg6RX5wSZqz0w=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=KT/s7fKOw/53IUEt2hL1Vdmsl/j4O+98tcLHkBudkcniF/rQHQ4oxrLrx6O1R7tYp
         nGpE45zWJ02NGxPffiRoYwAHe8l2YLkrwzbY996ojb4SlfeHvQESQYlrSp+JekieB5
         XNcVGfn5RlWp+dcsQi5k52NV/PrkbSfSp63vG+SKWL621q43O4OW3p9N6DyYyLOJKW
         yFBpL35KsMLQNmn/uDX+C2PWICr+a/2pq04lqlG/A25bf/cZfWuLBLNuDjJk+DoDqQ
         ge9QsVT9v4WKPd7KbqHyCGuuKS8pPyMSYULQxG/o8LBqtp5RsvVwIe6OrLLg0huCP1
         QSluOf7t/07dg==
Date:   Wed, 6 Oct 2021 17:33:32 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     davem@davemloft.net, michael.riesch@wolfvision.net,
        peppe.cavallaro@st.com, alexandre.torgue@foss.st.com,
        joabreu@synopsys.com, mcoquelin.stm32@gmail.com,
        p.zabel@pengutronix.de, lgirdwood@gmail.com, broonie@kernel.org,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [BUG RESEND] net: stmmac: dwmac-rk: Ethernet broken on
 rockpro64 by commit 2d26f6e39afb ("net: stmmac: dwmac-rk: fix unbalanced
 pm_runtime_enable warnings")
Message-ID: <20211006173332.7dc69822@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <YV3Hk2R4uDKbTy43@monolith.localdoman>
References: <YV3Hk2R4uDKbTy43@monolith.localdoman>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 6 Oct 2021 16:58:11 +0100 Alexandru Elisei wrote:
> Resending this because my previous email client inserted HTML into the email,
> which was then rejected by the linux-kernel@vger.kernel.org spam filter.
> 
> After commit 2d26f6e39afb ("net: stmmac: dwmac-rk: fix unbalanced
> pm_runtime_enable warnings"), the network card on my rockpro64-v2 was left
> unable to get a DHCP lease from the network. The offending commit was found by
> bisecting the kernel; I tried reverting the commit from v5.15-rc4 and the
> network card started working as expected.

We have this queued up in netdev/net:

aec3f415f724 ("net: stmmac: dwmac-rk: Fix ethernet on rk3399 based devices")

It should hit stable soon.
