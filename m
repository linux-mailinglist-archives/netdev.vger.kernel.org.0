Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6415D27A8D1
	for <lists+netdev@lfdr.de>; Mon, 28 Sep 2020 09:38:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726636AbgI1Hil (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Sep 2020 03:38:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:50998 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726522AbgI1Hil (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 28 Sep 2020 03:38:41 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 644DA2080C;
        Mon, 28 Sep 2020 07:38:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601278721;
        bh=PiD3Zi2tMnTXFm/5mYePwExWd1LeAD2rg1tycJRJy8A=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=BLUuRRdYlgv1HjvaaH2htdGbx5Bkl60fVmhbTcrOX6sOLvndDvbm0fw3PgNwkferg
         UOOMGYW8rtPyBaffoLHpeMihopGuiddXCmJR7XjtGUHvl+sOMSiAHp9kl9SQoqOpgE
         eUUACCvUblza6iT3r1ScdZiQkJQGnPH3OI2Mx5+4=
Date:   Mon, 28 Sep 2020 10:38:36 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc:     Saeed Mahameed <saeedm@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Roi Dayan <roid@mellanox.com>, Vlad Buslov <vladbu@nvidia.com>,
        Ariel Levkovich <lariel@mellanox.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH][next] net/mlx5e: Fix potential null pointer dereference
Message-ID: <20200928073836.GA3094@unreal>
References: <20200925164913.GA18472@embeddedor>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200925164913.GA18472@embeddedor>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 25, 2020 at 11:49:13AM -0500, Gustavo A. R. Silva wrote:
> Calls to kzalloc() and kvzalloc() should be null-checked
> in order to avoid any potential failures. In this case,
> a potential null pointer dereference.
>
> Fix this by adding null checks for _parse_attr_ and _flow_
> right after allocation.
>
> Addresses-Coverity-ID: 1497154 ("Dereference before null check")
> Fixes: c620b772152b ("net/mlx5: Refactor tc flow attributes structure")
> Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
> ---
>  drivers/net/ethernet/mellanox/mlx5/core/en_tc.c | 10 ++++++----
>  1 file changed, 6 insertions(+), 4 deletions(-)
>

Thanks,
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
