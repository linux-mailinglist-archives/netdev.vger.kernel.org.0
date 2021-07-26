Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A5A73D5A5C
	for <lists+netdev@lfdr.de>; Mon, 26 Jul 2021 15:30:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233707AbhGZMuQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Jul 2021 08:50:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:57096 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233194AbhGZMuN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 26 Jul 2021 08:50:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A02376008E;
        Mon, 26 Jul 2021 13:30:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627306242;
        bh=FaL9vbBdE3V+biHAq9tmrKS0iFa4UFCe6BoDl6uMk60=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=J7qaBEvXhTSI7/DwGfZoarXHYcnw9BzFRju1/kEXS5csUhp01ARF7qCl2r4uY8v4c
         tl4pMfDX1kNSz60NhC91N3kHPBSwytSOQl8Yj8WjiPKd8UyGoF8jsm6sGguXeNsVKe
         bywPeQ7mHjtNj6yFLOf33yHo1oKuBzCP8qx+y+/PMna6MlmfKDDpH2m67yIpZLhqwc
         rzjgmjfBEDPK0nMpK0TsouL/HwhCGix2LnvdqUq8tUeMRr2X1e66B7E1knXN+d9KWA
         wzqiqlYcb6l3hssKKFnWCCqv/2IaVlCuAkgeRa/Azdf9iw8Ti+1+xMJOsYcI014UFE
         tWPXmF8W/bS5w==
Date:   Mon, 26 Jul 2021 16:30:39 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Shung-Hsi Yu <shung-hsi.yu@suse.com>
Cc:     Majd Dibbiny <majd@mellanox.com>,
        Maor Gottlieb <maorg@mellanox.com>,
        Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: BUG: double free of mlx5_cmd_work_ent during shutdown
Message-ID: <YP64/2PATVW4p0vP@unreal>
References: <YPkU4HZwKMf9kuBH@syu-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YPkU4HZwKMf9kuBH@syu-laptop>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 22, 2021 at 02:49:04PM +0800, Shung-Hsi Yu wrote:
> Hi,

Thanks a lot for your extensive analysis and report. We will continue
to work internally in order to find a proper solution to this problematic
flow.

Thanks
