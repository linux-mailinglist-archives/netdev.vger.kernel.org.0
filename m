Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9010E134DA9
	for <lists+netdev@lfdr.de>; Wed,  8 Jan 2020 21:32:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727095AbgAHUcV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jan 2020 15:32:21 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:47470 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725446AbgAHUcV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jan 2020 15:32:21 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 423C11584B099;
        Wed,  8 Jan 2020 12:32:20 -0800 (PST)
Date:   Wed, 08 Jan 2020 12:32:19 -0800 (PST)
Message-Id: <20200108.123219.479736868120316034.davem@davemloft.net>
To:     wens@kernel.org
Cc:     peppe.cavallaro@st.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, mripard@kernel.org, wens@csie.org,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH netdev] net: stmmac: dwmac-sun8i: Allow all RGMII modes
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200106030945.19774-1-wens@kernel.org>
References: <20200106030945.19774-1-wens@kernel.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 08 Jan 2020 12:32:20 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Chen-Yu Tsai <wens@kernel.org>
Date: Mon,  6 Jan 2020 11:09:45 +0800

> From: Chen-Yu Tsai <wens@csie.org>
> 
> Allow all the RGMII modes to be used. This would allow us to represent
> the hardware better in the device tree with RGMII_ID where in most
> cases the PHY's internal delay for both RX and TX are used.
> 
> Fixes: 9f93ac8d4085 ("net-next: stmmac: Add dwmac-sun8i")
> Signed-off-by: Chen-Yu Tsai <wens@csie.org>

Applied and queued up for -stable.
