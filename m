Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7D66416083D
	for <lists+netdev@lfdr.de>; Mon, 17 Feb 2020 03:37:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726751AbgBQChc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Feb 2020 21:37:32 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:47850 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726656AbgBQChc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Feb 2020 21:37:32 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id A80BE15383A6E;
        Sun, 16 Feb 2020 18:37:31 -0800 (PST)
Date:   Sun, 16 Feb 2020 18:37:31 -0800 (PST)
Message-Id: <20200216.183731.2157450869886971370.davem@davemloft.net>
To:     jhubbard@nvidia.com
Cc:     akpm@linux-foundation.org, santosh.shilimkar@oracle.com,
        hans.westgaard.ry@oracle.com, leonro@mellanox.com, kuba@kernel.org,
        netdev@vger.kernel.org, rds-devel@oss.oracle.com,
        linux-rdma@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] net/rds: Track user mapped pages through special
 API
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200212030355.1600749-2-jhubbard@nvidia.com>
References: <20200212030355.1600749-1-jhubbard@nvidia.com>
        <20200212030355.1600749-2-jhubbard@nvidia.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 16 Feb 2020 18:37:32 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: John Hubbard <jhubbard@nvidia.com>
Date: Tue, 11 Feb 2020 19:03:55 -0800

> From: Leon Romanovsky <leonro@mellanox.com>
> 
> Convert net/rds to use the newly introduces pin_user_pages() API,
> which properly sets FOLL_PIN. Setting FOLL_PIN is now required for
> code that requires tracking of pinned pages.
> 
> Note that this effectively changes the code's behavior: it now
> ultimately calls set_page_dirty_lock(), instead of set_page_dirty().
> This is probably more accurate.
> 
> As Christoph Hellwig put it, "set_page_dirty() is only safe if we are
> dealing with a file backed page where we have reference on the inode it
> hangs off." [1]
> 
> [1] https://lore.kernel.org/r/20190723153640.GB720@lst.de
> 
> Cc: Hans Westgaard Ry <hans.westgaard.ry@oracle.com>
> Cc: Santosh Shilimkar <santosh.shilimkar@oracle.com>
> Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
> Signed-off-by: John Hubbard <jhubbard@nvidia.com>

Applied, thank you.
