Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 577AF1EE287
	for <lists+netdev@lfdr.de>; Thu,  4 Jun 2020 12:34:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726207AbgFDKeU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Jun 2020 06:34:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:36528 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725601AbgFDKeU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 4 Jun 2020 06:34:20 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2436B206C3;
        Thu,  4 Jun 2020 10:34:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591266859;
        bh=rjZlYPQX8+7WuJlTYc7K8S4AaWWC63MoQ5lnQqgQ0Uc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ADsvpQbM0IbvLDKQtUXimWcx0vuht5cCwa9xpPJNU1y2muJb/f6lTtGmaAsSAipob
         EN0ojuuLT+Yb/x3ia9bPxxDQcp0/gcTvYT0rEfYikwQbVuD6OmVQPuxQHFWpEDH9dp
         1wiKkgOVjQ0VwG1YQzIYy7Xoh1drl3WsBJFQv1pw=
Date:   Thu, 4 Jun 2020 13:34:16 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Matthew Wilcox <willy@infradead.org>
Cc:     linux-rdma@vger.kernel.org, Paul Blakey <paulb@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        linux-netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH] net/mlx5: Improve tuple ID allocation
Message-ID: <20200604103416.GB8834@unreal>
References: <20200603152901.17985-1-willy@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200603152901.17985-1-willy@infradead.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 03, 2020 at 08:29:01AM -0700, Matthew Wilcox wrote:
> From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
>
> There's no need to use a temporary variable; the XArray is designed to
> write directly into the object being allocated.
>
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> ---
>  drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c | 8 +++-----
>  1 file changed, 3 insertions(+), 5 deletions(-)
t

Thanks,
Reviewed-by: Leon Romanovsky <leonro@mellanox.com>
