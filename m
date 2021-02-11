Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E6D53195A5
	for <lists+netdev@lfdr.de>; Thu, 11 Feb 2021 23:15:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229991AbhBKWOS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Feb 2021 17:14:18 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:52122 "EHLO
        mail.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229523AbhBKWOM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Feb 2021 17:14:12 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        by mail.monkeyblade.net (Postfix) with ESMTPSA id A218B4D2ADD0C;
        Thu, 11 Feb 2021 14:13:29 -0800 (PST)
Date:   Thu, 11 Feb 2021 14:13:07 -0800 (PST)
Message-Id: <20210211.141307.764092492929918552.davem@davemloft.net>
To:     nobuhiro1.iwamatsu@toshiba.co.jp
Cc:     kuba@kernel.org, robh+dt@kernel.org, peppe.cavallaro@st.com,
        alexandre.torgue@st.com, joabreu@synopsys.com,
        punit1.agrawal@toshiba.co.jp, yuji2.ishikawa@toshiba.co.jp,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] net: stmmac: Add Toshiba Visconti SoCs glue driver
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20210210162954.3955785-3-nobuhiro1.iwamatsu@toshiba.co.jp>
References: <20210210162954.3955785-1-nobuhiro1.iwamatsu@toshiba.co.jp>
        <20210210162954.3955785-3-nobuhiro1.iwamatsu@toshiba.co.jp>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.2 (mail.monkeyblade.net [0.0.0.0]); Thu, 11 Feb 2021 14:13:30 -0800 (PST)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
Date: Thu, 11 Feb 2021 01:29:52 +0900

> +static int visconti_eth_init_hw(struct platform_device *pdev, struct plat_stmmacenet_data *plat_dat)
> +{
> +	struct visconti_eth *dwmac;
> +	unsigned int reg_val, clk_sel_val;

Please use reverse christmas tree ordering for local variable declarations.

> +static int visconti_eth_clock_probe(struct platform_device *pdev,
> +				    struct plat_stmmacenet_data *plat_dat)
> +{
> +	int err;
> +	struct visconti_eth *dwmac;

Likewise.

> +static int visconti_eth_clock_remove(struct platform_device *pdev)
> +{
> +	struct net_device *ndev = platform_get_drvdata(pdev);
> +	struct stmmac_priv *priv = netdev_priv(ndev);
> +	struct visconti_eth *dwmac = get_stmmac_bsp_priv(&pdev->dev);
Likewise.

Thanks.
