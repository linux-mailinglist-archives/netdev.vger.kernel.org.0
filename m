Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB9BF6454D6
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 08:49:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229677AbiLGHtL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 02:49:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229475AbiLGHtJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 02:49:09 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 195902F392
        for <netdev@vger.kernel.org>; Tue,  6 Dec 2022 23:49:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C8D61B8013C
        for <netdev@vger.kernel.org>; Wed,  7 Dec 2022 07:49:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2361C433C1;
        Wed,  7 Dec 2022 07:49:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670399346;
        bh=bB6My/PRtokI7IVPufQQ2Xl/5LAQPJjFYUdcYuhJaA0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=sb+MrucsnffmrCIwayDRCJ4EMRBLh7Qwd6rPcLjbNJJn1T7EWonTgMgiTJM83Wyit
         haX6vw/EuWmbBb4RW63HKDCHRpKOQgQUM4ZsHZiSxwi4e7EDYLdOSaPIkIimWlm1P8
         ygS/CG7K5UMjMVdeMB1r3j1YpconHX64m8gftKMaGkgnzC/f2pD+vzvicx/BN1JEuA
         FNsnsWJo7lX21/8BTuW9FTMNltrSGEcNwPYy1OFSzy0dQ6R1PvQSOr7yi9aaA5lNnE
         sJkFH4cLmXLWQdnIaPHxSY0PzPKD7w8rgpVfI//wzgiE9Hu/NmmLLZLSTjDia3ki23
         UQjQqJOblz3fw==
Date:   Wed, 7 Dec 2022 09:49:01 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Eric Dumazet <edumazet@google.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Tariq Toukan <tariqt@nvidia.com>, Wei Wang <weiwan@google.com>,
        netdev@vger.kernel.org, eric.dumazet@gmail.com
Subject: Re: [PATCH net-next 0/3] mlx4: better BIG-TCP support
Message-ID: <Y5BFbc0hhLhTLILF@unreal>
References: <20221206055059.1877471-1-edumazet@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221206055059.1877471-1-edumazet@google.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 06, 2022 at 05:50:56AM +0000, Eric Dumazet wrote:
> mlx4 uses a bounce buffer in TX whenever the tx descriptors
> wrap around the right edge of the ring.
> 
> Size of this bounce buffer was hard coded and can be
> increased if/when needed.
> 
> Eric Dumazet (3):
>   net/mlx4: rename two constants
>   net/mlx4: MLX4_TX_BOUNCE_BUFFER_SIZE depends on MAX_SKB_FRAGS
>   net/mlx4: small optimization in mlx4_en_xmit()
> 
>  drivers/net/ethernet/mellanox/mlx4/en_tx.c   | 18 ++++++++++--------
>  drivers/net/ethernet/mellanox/mlx4/mlx4_en.h | 18 +++++++++++++-----
>  2 files changed, 23 insertions(+), 13 deletions(-)
> 

Thanks,
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
