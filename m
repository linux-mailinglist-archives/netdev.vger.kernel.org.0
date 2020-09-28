Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D423A27A8DB
	for <lists+netdev@lfdr.de>; Mon, 28 Sep 2020 09:40:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726666AbgI1Hjy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Sep 2020 03:39:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:51284 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726522AbgI1Hjy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 28 Sep 2020 03:39:54 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5D42D2080C;
        Mon, 28 Sep 2020 07:39:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601278794;
        bh=2gF0rkIswQL84sn3ipotr7KpzJrI256WEpunS2H4mic=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=MyAkeC3jSWRH/4WSUMu+DMWfnaDyP7HFYp7F1Z0rexLSTb5xfdWPRNW+FOkfrHxYw
         FTrLSdUG0iEEnJiSutw7R7YIF4ljiZ5sAi8PomFzi9IrhOkAxQ0sOObJZ8FHSgyuub
         IzhyGEQYOZzet2R0q3o+Cz8ky8gsf7J7+ErzuP34=
Date:   Mon, 28 Sep 2020 10:39:50 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Alex Dewar <alex.dewar90@gmail.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] net/mlx5e: Clean up error handling in
 mlx5e_alloc_flow()
Message-ID: <20200928073950.GB3094@unreal>
References: <20200927113254.362480-1-alex.dewar90@gmail.com>
 <20200927113254.362480-2-alex.dewar90@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200927113254.362480-2-alex.dewar90@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Sep 27, 2020 at 12:32:52PM +0100, Alex Dewar wrote:
> The variable flow is used after being allocated but before being
> null-checked, which will cause a null pointer dereference if the
> allocation failed. Fix this and tidy up the error-checking logic in this
> function.
>
> Addresses-Coverity: CID 1497154: Null pointer dereferences (REVERSE_INULL)
> Signed-off-by: Alex Dewar <alex.dewar90@gmail.com>
> ---
>  .../net/ethernet/mellanox/mlx5/core/en_tc.c   | 20 ++++++++++---------
>  1 file changed, 11 insertions(+), 9 deletions(-)
>

Thanks, but Gustavo already sent a fix.
https://lore.kernel.org/lkml/20200925164913.GA18472@embeddedor
