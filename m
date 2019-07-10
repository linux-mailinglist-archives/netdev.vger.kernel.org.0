Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8160A6446F
	for <lists+netdev@lfdr.de>; Wed, 10 Jul 2019 11:31:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727374AbfGJJbp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Jul 2019 05:31:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:34308 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727064AbfGJJbp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Jul 2019 05:31:45 -0400
Received: from localhost (unknown [37.142.3.125])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C01A020838;
        Wed, 10 Jul 2019 09:31:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562751104;
        bh=vy0Mr4Uol6rxl9Ul5HNef3JkghGVfMZzH2ZYvBEDPNM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=v3AUO4eYGlcdf0/mRSZxPbZ2Xs+pJEVLj+7ECL67ahfXbHScUC+ItJ93D0h1evUJv
         X4xwiL//KM6HoaGu1aq2/XwMq3fleodsYyTzpDjOQ25Ie/Vz+b4bt39sAJRumpGlLl
         PWR5BVOMD3BBROb3E3q6OTjafSO/4YRLR5rXa9ME=
Date:   Wed, 10 Jul 2019 12:31:39 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Nathan Chancellor <natechancellor@gmail.com>
Cc:     Saeed Mahameed <saeedm@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>,
        Boris Pismenny <borisp@mellanox.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
        clang-built-linux@googlegroups.com,
        Nick Desaulniers <ndesaulniers@google.com>
Subject: Re: [PATCH net-next v3] net/mlx5e: Convert single case statement
 switch statements into if statements
Message-ID: <20190710093139.GG7034@mtr-leonro.mtl.com>
References: <20190710044748.3924-1-natechancellor@gmail.com>
 <20190710060614.6155-1-natechancellor@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190710060614.6155-1-natechancellor@gmail.com>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 09, 2019 at 11:06:15PM -0700, Nathan Chancellor wrote:
> During the review of commit 1ff2f0fa450e ("net/mlx5e: Return in default
> case statement in tx_post_resync_params"), Leon and Nick pointed out
> that the switch statements can be converted to single if statements
> that return early so that the code is easier to follow.
>
> Suggested-by: Leon Romanovsky <leon@kernel.org>
> Suggested-by: Nick Desaulniers <ndesaulniers@google.com>
> Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
> ---

Thanks again,
Reviewed-by: Leon Romanovsky <leonro@mellanox.com>
