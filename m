Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7DF731420A
	for <lists+netdev@lfdr.de>; Mon,  8 Feb 2021 22:40:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236876AbhBHVkO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 16:40:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:38422 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235601AbhBHVjw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Feb 2021 16:39:52 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 26F6D64E66;
        Mon,  8 Feb 2021 21:39:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612820351;
        bh=kKuMatlQNGlmus2I34gvECJW3QJnWHJqD7BxIGex7q0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=QuLW/F2XcAMP9e9LyMtRt6zcmT6oC2kfi8+Bws+s4fM2fknkm36RpzemL6lPgpe9M
         vEC4o3Q+EveR1BnkrWrd9pNKhft3llF6FNQN5lqd+4YjtalitBwSsFkEF+p59B5oFq
         jCAwQzz6aVtjxZypAsKoA0V6YX/+hAkX/0CIjBe8EaZZ9bHoYrl6Xr+kAfW4yJe7OE
         X1OBiAsU3UiiEgHOpabLRAp33yEPjIuBA2Bxi8B8wkVQtWIA6Vn6dwL7HKO6t3eeQc
         A6qd6c2L0Q8693tpTLSwM1PIRSE32nAuBWAY93gZeZwBn07RX1eLvzDKsKF+mrrSyx
         jqrGIoRwsfwzQ==
Date:   Mon, 8 Feb 2021 13:39:09 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Kevin Hao <haokexin@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Sunil Goutham <sgoutham@marvell.com>,
        Geetha sowjanya <gakula@marvell.com>,
        Subbaraya Sundeep <sbhatta@marvell.com>,
        hariprasad <hkelam@marvell.com>, netdev@vger.kernel.org,
        Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCH net-next] net: octeontx2: Fix the confusion in buffer
 alloc failure path
Message-ID: <20210208133909.74fe5ab5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210208014545.6945-1-haokexin@gmail.com>
References: <20210208014545.6945-1-haokexin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon,  8 Feb 2021 09:45:45 +0800 Kevin Hao wrote:
> @@ -1214,7 +1214,7 @@ int otx2_sq_aura_pool_init(struct otx2_nic *pfvf)
>  	struct otx2_snd_queue *sq;
>  	struct otx2_pool *pool;
>  	int err, ptr;
> -	s64 bufptr;
> +	dma_addr_t bufptr;

nit: please keep the variable declaration lines sorted longest to
     shortest.
