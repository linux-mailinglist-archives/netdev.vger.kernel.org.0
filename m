Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3310B4266BD
	for <lists+netdev@lfdr.de>; Fri,  8 Oct 2021 11:26:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238232AbhJHJ2C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Oct 2021 05:28:02 -0400
Received: from foss.arm.com ([217.140.110.172]:37534 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229710AbhJHJ17 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 Oct 2021 05:27:59 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B9DB0D6E;
        Fri,  8 Oct 2021 02:26:04 -0700 (PDT)
Received: from monolith.localdoman (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id CEA153F70D;
        Fri,  8 Oct 2021 02:26:01 -0700 (PDT)
Date:   Fri, 8 Oct 2021 10:27:41 +0100
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     Punit Agrawal <punitagrawal@gmail.com>
Cc:     davem@davemloft.net, michael.riesch@wolfvision.net,
        peppe.cavallaro@st.com, alexandre.torgue@foss.st.com,
        joabreu@synopsys.com, kuba@kernel.org, mcoquelin.stm32@gmail.com,
        p.zabel@pengutronix.de, lgirdwood@gmail.com,
        Mark Brown <broonie@kernel.org>, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        arm-mail-list <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [BUG] Ethernet broken on rockpro64 by commit 2d26f6e39afb ("net:
 stmmac: dwmac-rk: fix unbalanced pm_runtime_enable warnings")
Message-ID: <YWAO/gibeTDelPVq@monolith.localdoman>
References: <8e33c244-b786-18e8-79bc-407e27e4756b@arm.com>
 <87zgrk19yb.fsf@stealth>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87zgrk19yb.fsf@stealth>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Punit,

On Fri, Oct 08, 2021 at 12:17:48PM +0900, Punit Agrawal wrote:
> Alexandru Elisei <alexandru.elisei@arm.com> writes:
> 
> > (Sorry I'm sending this to the wrong person, this is what I got
> > scripts/get_maintainer.pl for the file touched by the commit)
> >
> > After commit 2d26f6e39afb ("net: stmmac: dwmac-rk: fix unbalanced
> > pm_runtime_enable warnings"), the network card on my rockpro64-v2 was left unable
> > to get a DHCP lease from the network. The offending commit was found by bisecting
> > the kernel; I tried reverting the commit from current master (commit 0513e464f900
> > ("Merge tag 'perf-tools-fixes-for-v5.15-2021-09-27' of
> > git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux")) and the network card
> > was working as expected.
> >
> > It goes without saying that I can help with testing the fix and
> > further diagnosing.
> 
> A fix was recently merged for this (see aec3f415f724 ("net: stmmac:
> dwmac-rk: Fix ethernet on rk3399 based devices") and should show up in
> the next rc. Please shout out if that doesn't fix the broken ethernet
> for you.

I can confirm that it's now working, many thanks.

Alex

> 
> Thanks,
> Punit
> 
