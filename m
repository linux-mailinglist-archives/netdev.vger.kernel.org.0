Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D73CC2F0C8A
	for <lists+netdev@lfdr.de>; Mon, 11 Jan 2021 06:31:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727329AbhAKFbY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 00:31:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:60130 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726721AbhAKFbX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 11 Jan 2021 00:31:23 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5E200205CA;
        Mon, 11 Jan 2021 05:30:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610343043;
        bh=Id1285G737J0aoqxJGvM/ZIcD3X+Z6IwGoKmmJf8hiU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=FHxk1cJMhOftPT+9WAknjY0ya6u3uxOhe/rmd4D3f1enlZqlHuAW13kVaCKrCWKoD
         ZU6EkwLGRm2MXCNBLEi7zxRf6Nsw1KgO02jBD15DRuoBFn/gNMxINYLRdTOum8nsaD
         kVC2RynQ5phzpdufd/xLtfr7xNlPTV4VA9XWVZFBx/rBBBY5Pkc1EwES6ZJVsqYRmJ
         Lixsv/Kn7XlkIjoxKshGA3qt++ckT6tHhu7VlToPoK35pNBZEv9UdmhvL3rzBU9YSv
         EcC7ZyYIjXNozGBFvbKLNxea6u3/bzYxxJMvuTExeFax6OlfJ0zH5iwLmkN8VVQF7e
         fKH7zop8+gL4w==
Date:   Mon, 11 Jan 2021 07:30:38 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     David Ahern <dsahern@gmail.com>
Cc:     Patrisious Haddad <phaddad@nvidia.com>,
        Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        linux-netdev <netdev@vger.kernel.org>,
        RDMA mailing list <linux-rdma@vger.kernel.org>
Subject: Re: [PATCH iproute2-next v2] rdma: Add support for the netlink extack
Message-ID: <20210111053038.GJ31158@unreal>
References: <20210103061706.18313-1-leon@kernel.org>
 <f2ad7596-b976-aef7-56b7-edfba3a77ba0@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f2ad7596-b976-aef7-56b7-edfba3a77ba0@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jan 10, 2021 at 10:23:06AM -0700, David Ahern wrote:
> On 1/2/21 11:17 PM, Leon Romanovsky wrote:
> > From: Patrisious Haddad <phaddad@nvidia.com>
> >
> > Add support in rdma for extack errors to be received
> > in userspace when sent from kernel, so now netlink extack
> > error messages sent from kernel would be printed for the
> > user.
> >
> > Signed-off-by: Patrisious Haddad <phaddad@nvidia.com>
> > Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> > ---
> > David,
> >
> > Just as a note, rdmatool is heavily influenced by the devlink and
> > general code should probably be applicable for both tools. Most likely
> > that any core refactoring/fix in the devlink is needed for rdmatool too.
> >
>
> understood and it was not the best model to start with but here we are.
>
> Petr did a good job of refactoring when he added dcb, but rdma was
> slightly different so the refactoring did not update it.

I can work to reduce the gaps, just need to know them.

Thanks
