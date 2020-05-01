Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E5971C0CF8
	for <lists+netdev@lfdr.de>; Fri,  1 May 2020 06:00:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727793AbgEAEAj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 May 2020 00:00:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725791AbgEAEAi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 May 2020 00:00:38 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0E79C035494
        for <netdev@vger.kernel.org>; Thu, 30 Apr 2020 21:00:38 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 09781127806CC;
        Thu, 30 Apr 2020 21:00:38 -0700 (PDT)
Date:   Thu, 30 Apr 2020 21:00:37 -0700 (PDT)
Message-Id: <20200430.210037.2294375960459896634.davem@davemloft.net>
To:     andriy.shevchenko@linux.intel.com
Cc:     peppe.cavallaro@st.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, linux-stm32@st-md-mailman.stormreply.com,
        netdev@vger.kernel.org, weifeng.voon@intel.com,
        boon.leong.ong@intel.com
Subject: Re: [PATCH v1] stmmac: intel: Fix kernel crash due to wrong error
 path
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200429150932.17927-1-andriy.shevchenko@linux.intel.com>
References: <20200429150932.17927-1-andriy.shevchenko@linux.intel.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 30 Apr 2020 21:00:38 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Date: Wed, 29 Apr 2020 18:09:32 +0300

> Unfortunately sometimes ->probe() may fail. The commit b9663b7ca6ff
> ("net: stmmac: Enable SERDES power up/down sequence")
> messed up with error handling and thus:
> 
> [   12.811311] ------------[ cut here ]------------
> [   12.811993] kernel BUG at net/core/dev.c:9937!
> 
> Fix this by properly crafted error path.
> 
> Fixes: b9663b7ca6ff ("net: stmmac: Enable SERDES power up/down sequence")
> Cc: Voon Weifeng <weifeng.voon@intel.com>
> Cc: Ong Boon Leong <boon.leong.ong@intel.com>
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

Applied.
