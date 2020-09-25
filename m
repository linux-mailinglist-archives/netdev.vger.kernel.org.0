Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79F4227951D
	for <lists+netdev@lfdr.de>; Sat, 26 Sep 2020 01:49:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729813AbgIYXtm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Sep 2020 19:49:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726037AbgIYXte (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Sep 2020 19:49:34 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39CDDC0613CE;
        Fri, 25 Sep 2020 16:49:34 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 2168213BA091A;
        Fri, 25 Sep 2020 16:32:46 -0700 (PDT)
Date:   Fri, 25 Sep 2020 16:49:32 -0700 (PDT)
Message-Id: <20200925.164932.397279241814019073.davem@davemloft.net>
To:     vee.khee.wong@intel.com
Cc:     peppe.cavallaro@st.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, kuba@kernel.org, mcoquelin.stm32@gmail.com,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        andriy.shevchenko@linux.intel.com, boon.leong.ong@intel.com,
        weifeng.voon@intel.com, sadhishkhanna.vijaya.balan@intel.com,
        chen.yong.seow@intel.com, mgross@linux.intel.com
Subject: Re: [PATCH net 1/1] net: stmmac: Fix clock handling on remove path
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200925095406.27834-1-vee.khee.wong@intel.com>
References: <20200925095406.27834-1-vee.khee.wong@intel.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Fri, 25 Sep 2020 16:32:46 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Wong Vee Khee <vee.khee.wong@intel.com>
Date: Fri, 25 Sep 2020 17:54:06 +0800

> While unloading the dwmac-intel driver, clk_disable_unprepare() is
> being called twice in stmmac_dvr_remove() and
> intel_eth_pci_remove(). This causes kernel panic on the second call.
> 
> Removing the second call of clk_disable_unprepare() in
> intel_eth_pci_remove().
> 
> Fixes: 09f012e64e4b ("stmmac: intel: Fix clock handling on error and remove paths")
> Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> Reviewed-by: Voon Weifeng <weifeng.voon@intel.com>
> Signed-off-by: Wong Vee Khee <vee.khee.wong@intel.com>

Applied, thanks.
