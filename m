Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 342D7C00E7
	for <lists+netdev@lfdr.de>; Fri, 27 Sep 2019 10:15:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726473AbfI0IPx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Sep 2019 04:15:53 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:57110 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726054AbfI0IPw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Sep 2019 04:15:52 -0400
Received: from localhost (unknown [65.39.69.237])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 4698914D0875D;
        Fri, 27 Sep 2019 01:15:50 -0700 (PDT)
Date:   Fri, 27 Sep 2019 10:15:48 +0200 (CEST)
Message-Id: <20190927.101548.1428184970448877652.davem@davemloft.net>
To:     dan.carpenter@oracle.com
Cc:     peppe.cavallaro@st.com, martin.blumenstingl@googlemail.com,
        alexandre.torgue@st.com, joabreu@synopsys.com,
        khilman@baylibre.com, mcoquelin.stm32@gmail.com,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH net] net: stmmac: dwmac-meson8b: Fix signedness bug in
 probe
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190925105822.GH3264@mwanda>
References: <20190925105822.GH3264@mwanda>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 27 Sep 2019 01:15:52 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>
Date: Wed, 25 Sep 2019 13:58:22 +0300

> The "dwmac->phy_mode" is an enum and in this context GCC treats it as
> an unsigned int so the error handling is never triggered.
> 
> Fixes: 566e82516253 ("net: stmmac: add a glue driver for the Amlogic Meson 8b / GXBB DWMAC")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Applied.
