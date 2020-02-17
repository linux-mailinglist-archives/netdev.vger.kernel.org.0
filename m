Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B2F2316094B
	for <lists+netdev@lfdr.de>; Mon, 17 Feb 2020 04:53:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726485AbgBQDxC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Feb 2020 22:53:02 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:48516 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726498AbgBQDxC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Feb 2020 22:53:02 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 4EC611582D81F;
        Sun, 16 Feb 2020 19:53:01 -0800 (PST)
Date:   Sun, 16 Feb 2020 19:53:00 -0800 (PST)
Message-Id: <20200216.195300.260413184133485319.davem@davemloft.net>
To:     ilias.apalodimas@linaro.org
Cc:     netdev@vger.kernel.org, jonathan.lemon@gmail.com,
        lorenzo@kernel.org, thomas.petazzoni@bootlin.com,
        jaswinder.singh@linaro.org, peppe.cavallaro@st.com,
        alexandre.torgue@st.com, joabreu@synopsys.com,
        mcoquelin.stm32@gmail.com, hawk@kernel.org, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, john.fastabend@gmail.com,
        linux-kernel@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, bpf@vger.kernel.org
Subject: Re: [PATCH net-next] net: page_pool: API cleanup and comments
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200216094056.8078-1-ilias.apalodimas@linaro.org>
References: <20200216094056.8078-1-ilias.apalodimas@linaro.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 16 Feb 2020 19:53:02 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ilias Apalodimas <ilias.apalodimas@linaro.org>
Date: Sun, 16 Feb 2020 11:40:55 +0200

> Functions starting with __ usually indicate those which are exported,
> but should not be called directly. Update some of those declared in the
> API and make it more readable.
> 
> page_pool_unmap_page() and page_pool_release_page() were doing
> exactly the same thing. Keep the page_pool_release_page() variant
> and export it in order to show up on perf logs.
> Finally rename __page_pool_put_page() to page_pool_put_page() since we
> can now directly call it from drivers and rename the existing
> page_pool_put_page() to page_pool_put_full_page() since they do the same
> thing but the latter is trying to sync the full DMA area.
> 
> Also update netsec, mvneta and stmmac drivers which use those functions.
> 
> Suggested-by: Jonathan Lemon <jonathan.lemon@gmail.com>
> Signed-off-by: Ilias Apalodimas <ilias.apalodimas@linaro.org>

Applied to net-next, thanks.
