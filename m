Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 023801DF2B7
	for <lists+netdev@lfdr.de>; Sat, 23 May 2020 01:07:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731282AbgEVXH0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 May 2020 19:07:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731175AbgEVXHY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 May 2020 19:07:24 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2C08C061A0E;
        Fri, 22 May 2020 16:07:24 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 60DFF1274E076;
        Fri, 22 May 2020 16:07:24 -0700 (PDT)
Date:   Fri, 22 May 2020 16:07:23 -0700 (PDT)
Message-Id: <20200522.160723.1511383489001652430.davem@davemloft.net>
To:     noodles@earth.li
Cc:     peppe.cavallaro@st.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        adron@yapic.net, marcel@ziswiler.com
Subject: Re: [PATCH] net: ethernet: stmmac: Enable interface clocks on
 probe for IPQ806x
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200521114934.GY311@earth.li>
References: <20200521114934.GY311@earth.li>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 22 May 2020 16:07:24 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jonathan McDowell <noodles@earth.li>
Date: Thu, 21 May 2020 12:49:34 +0100

> The ipq806x_gmac_probe() function enables the PTP clock but not the
> appropriate interface clocks. This means that if the bootloader hasn't
> done so attempting to bring up the interface will fail with an error
> like:
> 
> [   59.028131] ipq806x-gmac-dwmac 37600000.ethernet: Failed to reset the dma
> [   59.028196] ipq806x-gmac-dwmac 37600000.ethernet eth1: stmmac_hw_setup: DMA engine initialization failed
> [   59.034056] ipq806x-gmac-dwmac 37600000.ethernet eth1: stmmac_open: Hw setup failed
> 
> This patch, a slightly cleaned up version of one posted by Sergey
> Sergeev in:
> 
> https://forum.openwrt.org/t/support-for-mikrotik-rb3011uias-rm/4064/257
> 
> correctly enables the clock; we have already configured the source just
> before this.
> 
> Tested on a MikroTik RB3011.
> 
> Signed-off-by: Jonathan McDowell <noodles@earth.li>

Applied, thanks.
