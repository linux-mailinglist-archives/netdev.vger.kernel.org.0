Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 175571EEDF7
	for <lists+netdev@lfdr.de>; Fri,  5 Jun 2020 00:52:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727826AbgFDWwi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Jun 2020 18:52:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726446AbgFDWwi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Jun 2020 18:52:38 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AC33C08C5C0;
        Thu,  4 Jun 2020 15:52:38 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id CCED511F5F8D1;
        Thu,  4 Jun 2020 15:52:36 -0700 (PDT)
Date:   Thu, 04 Jun 2020 15:52:35 -0700 (PDT)
Message-Id: <20200604.155235.1008812507143457607.davem@davemloft.net>
To:     dan.carpenter@oracle.com
Cc:     peppe.cavallaro@st.com, fugang.duan@nxp.com,
        alexandre.torgue@st.com, joabreu@synopsys.com, kuba@kernel.org,
        mcoquelin.stm32@gmail.com, shawnguo@kernel.org,
        s.hauer@pengutronix.de, kernel@pengutronix.de, festevam@gmail.com,
        linux-imx@nxp.com, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH net-next] net: ethernet: dwmac: Fix an error code in
 imx_dwmac_probe()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200603175025.GA19353@mwanda>
References: <20200603175025.GA19353@mwanda>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 04 Jun 2020 15:52:37 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>
Date: Wed, 3 Jun 2020 20:50:25 +0300

> The code is return PTR_ERR(NULL) which is zero or success.  We should
> return -ENOMEM instead.
> 
> Fixes: 94abdad6974a5 ("net: ethernet: dwmac: add ethernet glue logic for NXP imx8 chip")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Applied.
