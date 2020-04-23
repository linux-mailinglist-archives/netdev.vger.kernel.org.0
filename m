Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0ED841B5153
	for <lists+netdev@lfdr.de>; Thu, 23 Apr 2020 02:35:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726358AbgDWAfg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Apr 2020 20:35:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:46020 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725846AbgDWAfe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 Apr 2020 20:35:34 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DF27F20776;
        Thu, 23 Apr 2020 00:35:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587602134;
        bh=n1nLJgUAM7cj+BKe5t12zohf1N73ArufiYr579rwHRA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=QDi/81/Vwb3ke/QCb8lJBvruy3zytUC3kwBsmm/z1TGyRPT+eoXnYm9nHUBU4zXfn
         L9UEiM6RbNNxR+G8zpj8qSuSWfWRKFVB2V3B3rtO+Xb+RSA0kpVYputfGkRu3XyNAB
         8F2CVafAMLmpH6Edbt0hbZJR5BARsNjKtINhKRN8=
Date:   Wed, 22 Apr 2020 17:35:32 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     <sameehj@amazon.com>
Cc:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        Arthur Kiyanovski <akiyano@amazon.com>, <dwmw@amazon.com>,
        <zorik@amazon.com>, <matua@amazon.com>, <saeedb@amazon.com>,
        <msw@amazon.com>, <aliguori@amazon.com>, <nafea@amazon.com>,
        <gtzalik@amazon.com>, <netanel@amazon.com>, <alisaidi@amazon.com>,
        <benh@amazon.com>, <ndagan@amazon.com>
Subject: Re: [PATCH V1 net-next 01/13] net: ena: fix error returning in
 ena_com_get_hash_function()
Message-ID: <20200422173532.702e7b23@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200422081628.8103-2-sameehj@amazon.com>
References: <20200422081628.8103-1-sameehj@amazon.com>
        <20200422081628.8103-2-sameehj@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 22 Apr 2020 08:16:16 +0000 sameehj@amazon.com wrote:
> From: Arthur Kiyanovski <akiyano@amazon.com>
> 
> In case the "func" parameter is NULL we now return "-EINVAL".
> This shouldn't happen in general, but when it does happen, this is the
> proper way to handle it.
> 
> We also check func for NULL in the beginning of the function, as there
> is no reason to do all the work and realize in the end of the function
> it was useless.
> 
> Fixes: 1738cd3ed342 ("net: ena: Add a driver for Amazon Elastic Network Adapters (ENA)")

Also, why the fixes tag? Is this a fix for a user-visible problem?

> Signed-off-by: Sameeh Jubran <sameehj@amazon.com>
> Signed-off-by: Arthur Kiyanovski <akiyano@amazon.com>
