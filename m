Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 396831665D5
	for <lists+netdev@lfdr.de>; Thu, 20 Feb 2020 19:09:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728576AbgBTSJk convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 20 Feb 2020 13:09:40 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:56888 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727298AbgBTSJk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Feb 2020 13:09:40 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 4460815AC0C26;
        Thu, 20 Feb 2020 10:09:39 -0800 (PST)
Date:   Thu, 20 Feb 2020 10:09:38 -0800 (PST)
Message-Id: <20200220.100938.2134816727649118049.davem@davemloft.net>
To:     ilias.apalodimas@linaro.org
Cc:     netdev@vger.kernel.org, jonathan.lemon@gmail.com,
        lorenzo@kernel.org, toke@redhat.com, brouer@redhat.com,
        thomas.petazzoni@bootlin.com, jaswinder.singh@linaro.org,
        peppe.cavallaro@st.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, mcoquelin.stm32@gmail.com, hawk@kernel.org,
        kuba@kernel.org, ast@kernel.org, daniel@iogearbox.net,
        john.fastabend@gmail.com, linux-kernel@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, bpf@vger.kernel.org
Subject: Re: [PATCH net-next v5] net: page_pool: API cleanup and comments
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200220074155.765234-1-ilias.apalodimas@linaro.org>
References: <20200220074155.765234-1-ilias.apalodimas@linaro.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 20 Feb 2020 10:09:40 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ilias Apalodimas <ilias.apalodimas@linaro.org>
Date: Thu, 20 Feb 2020 09:41:55 +0200

> Functions starting with __ usually indicate those which are exported,
> but should not be called directly. Update some of those declared in the
> API and make it more readable.
> 
> page_pool_unmap_page() and page_pool_release_page() were doing
> exactly the same thing calling __page_pool_clean_page().  Let's
> rename __page_pool_clean_page() to page_pool_release_page() and
> export it in order to show up on perf logs and get rid of
> page_pool_unmap_page().
> 
> Finally rename __page_pool_put_page() to page_pool_put_page() since we
> can now directly call it from drivers and rename the existing
> page_pool_put_page() to page_pool_put_full_page() since they do the same
> thing but the latter is trying to sync the full DMA area.
> 
> This patch also updates netsec, mvneta and stmmac drivers which use
> those functions.
> 
> Suggested-by: Jonathan Lemon <jonathan.lemon@gmail.com>
> Acked-by: Toke Høiland-Jørgensen <toke@redhat.com>
> Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>
> Signed-off-by: Ilias Apalodimas <ilias.apalodimas@linaro.org>

Applied, thanks Ilias.
