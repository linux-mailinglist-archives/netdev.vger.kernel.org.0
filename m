Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EA329134DA7
	for <lists+netdev@lfdr.de>; Wed,  8 Jan 2020 21:32:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726931AbgAHUcO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jan 2020 15:32:14 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:47446 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725446AbgAHUcO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jan 2020 15:32:14 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 398D41584B098;
        Wed,  8 Jan 2020 12:32:13 -0800 (PST)
Date:   Wed, 08 Jan 2020 12:32:12 -0800 (PST)
Message-Id: <20200108.123212.1596766574776684630.davem@davemloft.net>
To:     wens@kernel.org
Cc:     peppe.cavallaro@st.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, mripard@kernel.org, wens@csie.org,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH netdev] net: stmmac: dwmac-sunxi: Allow all RGMII modes
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200106030922.19721-1-wens@kernel.org>
References: <20200106030922.19721-1-wens@kernel.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 08 Jan 2020 12:32:13 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Chen-Yu Tsai <wens@kernel.org>
Date: Mon,  6 Jan 2020 11:09:22 +0800

> From: Chen-Yu Tsai <wens@csie.org>
> 
> Allow all the RGMII modes to be used. This would allow us to represent
> the hardware better in the device tree with RGMII_ID where in most
> cases the PHY's internal delay for both RX and TX are used.
> 
> Fixes: af0bd4e9ba80 ("net: stmmac: sunxi platform extensions for GMAC in Allwinner A20 SoC's")
> Signed-off-by: Chen-Yu Tsai <wens@csie.org>

Applied and queued up for -stable.
