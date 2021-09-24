Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 175F9416EF5
	for <lists+netdev@lfdr.de>; Fri, 24 Sep 2021 11:29:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245129AbhIXJbZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Sep 2021 05:31:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:43300 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244970AbhIXJbQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 Sep 2021 05:31:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3A51961039;
        Fri, 24 Sep 2021 09:29:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632475784;
        bh=2oeuxZrFJB0Hk8Nems2Au4UGPvKYbwE2jCoLgMnV170=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=dwg4PcKLO18rhE5rH3va7pTooZV7yJ1/yJq4hnzGROeGcBpJ4B+IrN9Pv31l+UKYX
         qvfp4YbbCZSWu+InhrhmUXxPOEi1amOuEeNG84phnjFD01oHAq1twZDFqB0sItrIIT
         K2i67BChS7gOPfTATaHeFkQ+sCVYyI5Crt7nVIB8=
Date:   Fri, 24 Sep 2021 11:29:41 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Macpaul Lin <macpaul.lin@mediatek.com>
Cc:     Petr Oros <poros@redhat.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Miles Chen <miles.chen@mediatek.com>,
        Bear Wang <bear.wang@mediatek.com>,
        Pablo Sun <pablo.sun@mediatek.com>,
        Fabien Parent <fparent@baylibre.com>,
        Macpaul Lin <macpaul@gmail.com>,
        linux-mediatek@lists.infradead.org
Subject: Re: backport commit ("e96bd2d3b1f8 phy: avoid unnecessary link-up
 delay in polling mode") to linux-5.4-stable
Message-ID: <YU2ahYG+mbriOevz@kroah.com>
References: <20210924091020.32695-1-macpaul.lin@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210924091020.32695-1-macpaul.lin@mediatek.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 24, 2021 at 05:10:20PM +0800, Macpaul Lin wrote:
> Hi reviewers,
> 
> I suggest to backport 
> commit "e96bd2d3b1f8 phy: avoid unnecessary link-up delay in polling mode"
> to linux-5.4 stable tree.
> 
> This patch reports a solution to an incorrect phy link detection issue.
> "With this solution we don't miss a link-down event in polling mode and
> link-up is faster."
> 
> commit: e96bd2d3b1f83170d1d5c1a99e439b39a22a5b58
> subject: phy: avoid unnecessary link-up delay in polling mode
> kernel version to apply to: Linux-5.4

Now queued up, thanks.

greg k-h
