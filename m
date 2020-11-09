Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 533D82AC59E
	for <lists+netdev@lfdr.de>; Mon,  9 Nov 2020 20:57:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730863AbgKIT5P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Nov 2020 14:57:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:45930 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729499AbgKIT5P (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Nov 2020 14:57:15 -0500
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (c-67-180-217-166.hsd1.ca.comcast.net [67.180.217.166])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5E9E2206D8;
        Mon,  9 Nov 2020 19:57:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604951834;
        bh=hqgvKvqsLrWlJnRXYEC8bkCbRe/XLhQPjqC2IZq8Jh0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=WRjM9/gTqlHnSklr6hkuYho/PC3pcAdQIdHg0iehe5/SprIyh7ThQeDKTnjOnF5r0
         m3TXyp2ma4vLaERpehnDYDrLk8BfzZaFm1gl4632itLKU9i139xujTwKa0JY9QoZpR
         4YpW+v8NFSNV0iXiXPZKQsdYbw5Y7cs5K0UDa9EA=
Date:   Mon, 9 Nov 2020 11:57:13 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jisheng Zhang <Jisheng.Zhang@synaptics.com>
Cc:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] net: stmmac: platform: use optional clk/reset
 get APIs
Message-ID: <20201109115713.026aeb68@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20201109160855.24e911b6@xhacker.debian>
References: <20201109160855.24e911b6@xhacker.debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 9 Nov 2020 16:09:10 +0800 Jisheng Zhang wrote:
> @@ -596,14 +595,10 @@ stmmac_probe_config_dt(struct platform_device *pdev, const char **mac)
>  		dev_dbg(&pdev->dev, "PTP rate %d\n", plat->clk_ptp_rate);
>  	}
>  
> -	plat->stmmac_rst = devm_reset_control_get(&pdev->dev,
> -						  STMMAC_RESOURCE_NAME);
> +	plat->stmmac_rst = devm_reset_control_get_optional(&pdev->dev, STMMAC_RESOURCE_NAME);

This code was wrapped at 80 chars, please keep it wrapped.

