Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1725425013
	for <lists+netdev@lfdr.de>; Thu,  7 Oct 2021 11:28:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240674AbhJGJas (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Oct 2021 05:30:48 -0400
Received: from foss.arm.com ([217.140.110.172]:40238 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232704AbhJGJar (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 Oct 2021 05:30:47 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8DCBB1FB;
        Thu,  7 Oct 2021 02:28:53 -0700 (PDT)
Received: from monolith.localdoman (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 2B77F3F766;
        Thu,  7 Oct 2021 02:28:51 -0700 (PDT)
Date:   Thu, 7 Oct 2021 10:30:25 +0100
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     Jakub Kicinski <kuba@kernel.org>, broonie@kernel.org
Cc:     davem@davemloft.net, michael.riesch@wolfvision.net,
        peppe.cavallaro@st.com, alexandre.torgue@foss.st.com,
        joabreu@synopsys.com, mcoquelin.stm32@gmail.com,
        p.zabel@pengutronix.de, lgirdwood@gmail.com,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [BUG RESEND] net: stmmac: dwmac-rk: Ethernet broken on rockpro64
 by commit 2d26f6e39afb ("net: stmmac: dwmac-rk: fix unbalanced
 pm_runtime_enable warnings")
Message-ID: <YV6+G0glwnwf+N8G@monolith.localdoman>
References: <YV3Hk2R4uDKbTy43@monolith.localdoman>
 <20211006173332.7dc69822@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211006173332.7dc69822@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 06, 2021 at 05:33:32PM -0700, Jakub Kicinski wrote:
> On Wed, 6 Oct 2021 16:58:11 +0100 Alexandru Elisei wrote:
> > Resending this because my previous email client inserted HTML into the email,
> > which was then rejected by the linux-kernel@vger.kernel.org spam filter.
> > 
> > After commit 2d26f6e39afb ("net: stmmac: dwmac-rk: fix unbalanced
> > pm_runtime_enable warnings"), the network card on my rockpro64-v2 was left
> > unable to get a DHCP lease from the network. The offending commit was found by
> > bisecting the kernel; I tried reverting the commit from v5.15-rc4 and the
> > network card started working as expected.
> 
> We have this queued up in netdev/net:
> 
> aec3f415f724 ("net: stmmac: dwmac-rk: Fix ethernet on rk3399 based devices")
> 
> It should hit stable soon.

Hi Mark, Jakub,

Thank you both for your replies, will keep an eye out for when that patch hits
mainline.

Thanks,
Alex
