Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AD9A1BEC88
	for <lists+netdev@lfdr.de>; Thu, 26 Sep 2019 09:28:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729208AbfIZH2x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Sep 2019 03:28:53 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:44798 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726521AbfIZH2x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Sep 2019 03:28:53 -0400
Received: from localhost (unknown [65.39.69.237])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 89207128F384F;
        Thu, 26 Sep 2019 00:28:50 -0700 (PDT)
Date:   Thu, 26 Sep 2019 09:28:49 +0200 (CEST)
Message-Id: <20190926.092849.214919483212512707.davem@davemloft.net>
To:     thierry.reding@gmail.com
Cc:     peppe.cavallaro@st.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, f.fainelli@gmail.com,
        jakub.kicinski@netronome.com, jonathanh@nvidia.com,
        bbiswas@nvidia.com, netdev@vger.kernel.org,
        linux-tegra@vger.kernel.org
Subject: Re: [PATCH net-next] net: stmmac: Fix page pool size
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190923095915.11588-1-thierry.reding@gmail.com>
References: <20190923095915.11588-1-thierry.reding@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 26 Sep 2019 00:28:52 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Thierry Reding <thierry.reding@gmail.com>
Date: Mon, 23 Sep 2019 11:59:15 +0200

> From: Thierry Reding <treding@nvidia.com>
> 
> The size of individual pages in the page pool in given by an order. The
> order is the binary logarithm of the number of pages that make up one of
> the pages in the pool. However, the driver currently passes the number
> of pages rather than the order, so it ends up wasting quite a bit of
> memory.
> 
> Fix this by taking the binary logarithm and passing that in the order
> field.
> 
> Fixes: 2af6106ae949 ("net: stmmac: Introducing support for Page Pool")
> Signed-off-by: Thierry Reding <treding@nvidia.com>

Not only should this have been marked v2, it should have targetted 'net'
instead of 'net-next'.

In any event, I've applied it, thanks.
