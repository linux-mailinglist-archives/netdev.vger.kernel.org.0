Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 00A3DC0107
	for <lists+netdev@lfdr.de>; Fri, 27 Sep 2019 10:22:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726785AbfI0IWL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Sep 2019 04:22:11 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:57204 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726136AbfI0IWK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Sep 2019 04:22:10 -0400
Received: from localhost (unknown [65.39.69.237])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 8244314DEA15A;
        Fri, 27 Sep 2019 01:22:08 -0700 (PDT)
Date:   Fri, 27 Sep 2019 10:22:06 +0200 (CEST)
Message-Id: <20190927.102206.1720435175604577653.davem@davemloft.net>
To:     dan.carpenter@oracle.com
Cc:     peppe.cavallaro@st.com, mathieu@codeaurora.org,
        alexandre.torgue@st.com, joabreu@synopsys.com,
        mcoquelin.stm32@gmail.com, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH net] net: ethernet: stmmac: Fix signedness bug in
 ipq806x_gmac_of_parse()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190925110554.GQ3264@mwanda>
References: <20190925110554.GQ3264@mwanda>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 27 Sep 2019 01:22:10 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>
Date: Wed, 25 Sep 2019 14:05:54 +0300

> The "gmac->phy_mode" variable is an enum and in this context GCC will
> treat it as an unsigned int so the error handling will never be
> triggered.
> 
> Fixes: b1c17215d718 ("stmmac: add ipq806x glue layer")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Applied.
