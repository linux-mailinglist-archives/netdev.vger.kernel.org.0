Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B8BA27B800
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 01:21:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727231AbgI1XVt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Sep 2020 19:21:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:44790 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726369AbgI1XVt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 28 Sep 2020 19:21:49 -0400
Received: from lt-jalone-7480.mtl.com (c-24-6-56-119.hsd1.ca.comcast.net [24.6.56.119])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 513BE206C9;
        Mon, 28 Sep 2020 23:21:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601335308;
        bh=S2+UC+XrRqfCZ/+gR6ZQaUOaVF+k3xO1+tGlLGwIl9g=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=pUru917FzEYkB62HFZ1JWJcY/cDvNUBgzPb2Dr0F9/IdsypHsU8KTRdRoYIEE5VlL
         KuedFBKR1lNBPlIJkcLjuy2bdk4Nl+Njn2y/dATkcp48fXBayctqTC3QHwVvsmjTgW
         +/5ODrxN8245SLzWn2R8XggnDVhXlcN40Dz3LTuM=
Message-ID: <1017ab3724b83818c03dfa7661b3f31827a7f62f.camel@kernel.org>
Subject: Re: [PATCH net-next] net/mlx5e: Fix a use after free on error in
 mlx5_tc_ct_shared_counter_get()
From:   Saeed Mahameed <saeed@kernel.org>
To:     David Miller <davem@davemloft.net>, dan.carpenter@oracle.com
Cc:     leon@kernel.org, kuba@kernel.org, roid@mellanox.com,
        ozsh@mellanox.com, paulb@mellanox.com, elibr@mellanox.com,
        lariel@nvidia.com, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, kernel-janitors@vger.kernel.org
Date:   Mon, 28 Sep 2020 16:21:47 -0700
In-Reply-To: <20200928.122952.688062131867166420.davem@davemloft.net>
References: <20200928090556.GA377727@mwanda>
         <20200928.122952.688062131867166420.davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2020-09-28 at 12:29 -0700, David Miller wrote:
> From: Dan Carpenter <dan.carpenter@oracle.com>
> Date: Mon, 28 Sep 2020 12:05:56 +0300
> 
> > This code frees "shared_counter" and then dereferences on the next
> line
> > to get the error code.
> > 
> > Fixes: 1edae2335adf ("net/mlx5e: CT: Use the same counter for both
> directions")
> > Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> 
> Saeed, I assume you will pick this up.
> 
> Thank you.

Applied to net-next-mlx5.

Thanks

