Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D86135373E
	for <lists+netdev@lfdr.de>; Sun,  4 Apr 2021 09:52:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229750AbhDDHwG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Apr 2021 03:52:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:48454 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229569AbhDDHwG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 4 Apr 2021 03:52:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 55E59610CE;
        Sun,  4 Apr 2021 07:52:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617522722;
        bh=LwKzGMQVsWclXDERrnRMti1IqSHukAWiOX6veN1SHjM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=J0ZId673MRRA1vWe3rBFcJHkZDpxZRX5vrVsK+wMJlNQZ5oy4oASk1r9hp6tGtFB4
         uh56wgOAnYPnzyNrEb4+6roWiJ0Zf8o50PZIs76ukzyEotS/Hge9RzPicpLKftrmFq
         Wy+84uSf5kX5JqZ5Eb5359Ozv3YNf+EfifUT0aFYg6Gh2nTnLfnDN7hZpbjHR8g8y7
         3yJmP4PkYGAKiIb5dtao9LACWrmXiMroe8aDWyHh2wm385OtxSmAiokfbCBoJRXqI2
         aeMcQ46ared8u4hs/doYp2HjUkvNLCVq8a9SI36sgc3x4WQywunkEpO9El+FNhUnkQ
         ojm2MZ227SkBQ==
Date:   Sun, 4 Apr 2021 10:51:57 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Doug Ledford <dledford@redhat.com>,
        Maor Gottlieb <maorg@nvidia.com>, linux-rdma@vger.kernel.org,
        netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>,
        Yishai Hadas <yishaih@mellanox.com>
Subject: Re: [PATCH rdma-next 6/7] RDMA/mlx5: Add support in MEMIC operations
Message-ID: <YGlwHUvYCer5DJ+c@unreal>
References: <20210318111548.674749-1-leon@kernel.org>
 <20210318111548.674749-7-leon@kernel.org>
 <20210401174704.GA1626672@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210401174704.GA1626672@nvidia.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 01, 2021 at 02:47:04PM -0300, Jason Gunthorpe wrote:
> On Thu, Mar 18, 2021 at 01:15:47PM +0200, Leon Romanovsky wrote:
> > From: Maor Gottlieb <maorg@nvidia.com>
> > 
> > MEMIC buffer, in addition to regular read and write operations, can
> > support atomic operations from the host.
> > 
> > Introduce and implement new UAPI to allocate address space for MEMIC
> > operations such as atomic. This includes:

<...>

> It looks mostly fine otherwise, the error flows are a bit hard to read
> though, when a new type is added this should also get re-organized so
> we don't do stuff like:
> 
> err_free:
> 	/* In MEMIC error flow, dm will be freed internally */
> 	if (type != MLX5_IB_UAPI_DM_TYPE_MEMIC)
> 		kfree(dm);

I actually liked it, because the "re-organized" code was harder to read
than this simple check. but ok, let's try again.

Thanks
