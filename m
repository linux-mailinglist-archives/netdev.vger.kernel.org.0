Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F01C1F0A41
	for <lists+netdev@lfdr.de>; Sun,  7 Jun 2020 08:36:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726346AbgFGGgk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Jun 2020 02:36:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:53212 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726192AbgFGGgj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 7 Jun 2020 02:36:39 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C1DD6206D5;
        Sun,  7 Jun 2020 06:36:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591511799;
        bh=CQtxtcDJBMRX+osmArf8Mom4xa/l6e4FZSbPN3AB5Go=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=lRtQHxFBGzAI/gLGcUpeN7+AwzFbWuWVFRAISBh2Lk/1TLaVB2MXJhdyTn1ZCLAKl
         fnFAiJryk+F3iYGUROtZx5sQOfiT8lLshLkD2aPfcyyibNTV3TvrdIeNp3H19ieiHF
         Lv8+jQkIHvf8gpxdAanhegAtGZBdQgPwcBRDu/MU=
Date:   Sun, 7 Jun 2020 09:36:35 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Hu Haowen <xianfengting221@163.com>
Cc:     saeedm@mellanox.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net/mlx5: Add a missing macro undefinition
Message-ID: <20200607063635.GD164174@unreal>
References: <20200607051241.5375-1-xianfengting221@163.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200607051241.5375-1-xianfengting221@163.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jun 07, 2020 at 01:12:40PM +0800, Hu Haowen wrote:
> The macro ODP_CAP_SET_MAX is only used in function handle_hca_cap_odp()
> in file main.c, so it should be undefined when there are no more uses
> of it.
>
> Signed-off-by: Hu Haowen <xianfengting221@163.com>
> ---
>  drivers/net/ethernet/mellanox/mlx5/core/main.c | 2 ++
>  1 file changed, 2 insertions(+)

"should be undefined" is s little bit over statement, but overall
the patch is good.

Fixes: fca22e7e595f ("net/mlx5: ODP support for XRC transport is not enabled by default in FW")

Thanks,
Reviewed-by: Leon Romanovsky <leonro@mellanox.com>
