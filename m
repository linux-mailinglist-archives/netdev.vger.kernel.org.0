Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 067081E18B1
	for <lists+netdev@lfdr.de>; Tue, 26 May 2020 03:13:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388387AbgEZBNU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 May 2020 21:13:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387888AbgEZBNT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 May 2020 21:13:19 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DAD7C061A0E
        for <netdev@vger.kernel.org>; Mon, 25 May 2020 18:13:19 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 8D51C127AA591;
        Mon, 25 May 2020 18:13:18 -0700 (PDT)
Date:   Mon, 25 May 2020 18:13:17 -0700 (PDT)
Message-Id: <20200525.181317.1216905484376882401.davem@davemloft.net>
To:     fugang.duan@nxp.com
Cc:     peppe.cavallaro@st.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, kuba@kernel.org, netdev@vger.kernel.org,
        mcoquelin.stm32@gmail.com, p.zabel@pengutronix.de,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH net 1/2] net: ethernet: dwmac: add Ethernet glue logic
 for NXP imx8 chip
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1590402554-13175-2-git-send-email-fugang.duan@nxp.com>
References: <1590402554-13175-1-git-send-email-fugang.duan@nxp.com>
        <1590402554-13175-2-git-send-email-fugang.duan@nxp.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 25 May 2020 18:13:18 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Fugang Duan <fugang.duan@nxp.com>
Date: Mon, 25 May 2020 18:29:13 +0800

> +static int imx_dwmac_init(struct platform_device *pdev, void *priv)
> +{
> +	struct imx_priv_data *dwmac = priv;
> +	struct plat_stmmacenet_data *plat_dat = dwmac->plat_dat;
> +	int ret;
> +

Please code these sequences as:

	struct plat_stmmacenet_data *plat_dat;
	struct imx_priv_data *dwmac = priv;
	int ret;

	plat_dat = dwmac->plat_dat;

In order to have reverse christmas three local variable ordering.

THank you.
