Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C09759B387
	for <lists+netdev@lfdr.de>; Sun, 21 Aug 2022 13:42:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230186AbiHULmd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Aug 2022 07:42:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229800AbiHULmc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 21 Aug 2022 07:42:32 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52CE418362;
        Sun, 21 Aug 2022 04:42:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F2347B80A08;
        Sun, 21 Aug 2022 11:42:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF65DC433D6;
        Sun, 21 Aug 2022 11:42:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661082148;
        bh=/eHuW2753FzFdVi75ni68T/FATapwLcqXnK87QwVOEA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=jj5vTbCfbhjqhaOeFaToCi2qunD0yiik5khCHIeZ1R5/FtXs4kfFbjsvI312Bp7oI
         aMxvcXdobP6WA7F5RnhYXotPe7m5/3aze8Najtf+7LIrLMyCoMBqJ5/0Co5+olV/v2
         Dkdpeond/GyfKhBBiZU8o4VEzihpej5KWlrLFPQ1rVPnvJ0KaKfkbtVwvCsO16n0zD
         FZCExk4Q0BVcD3bIwezNXshn4OAwDUnqLADtUg7atgA9yCjVxvK9sCqW+TrfPubIhp
         fz4tbnwTAcFH2BWOGNAQisuHbm56aFO+6SHK5ZJQZQ2ReljvEYXx0pQHGB/GsYH768
         oh+XEVNW7+Stw==
Date:   Sun, 21 Aug 2022 14:42:24 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Jack Wang <jinpu.wang@ionos.com>
Cc:     linux-kernel@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org
Subject: Re: [PATCH v1 19/19] net/mlx4: Fix error check for dma_map_sg
Message-ID: <YwIaICkiKaoJfhvb@unreal>
References: <20220819060801.10443-1-jinpu.wang@ionos.com>
 <20220819060801.10443-20-jinpu.wang@ionos.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220819060801.10443-20-jinpu.wang@ionos.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 19, 2022 at 08:08:01AM +0200, Jack Wang wrote:
> dma_map_sg return 0 on error.
> 
> Cc: Tariq Toukan <tariqt@nvidia.com>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Eric Dumazet <edumazet@google.com>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Paolo Abeni <pabeni@redhat.com>
> Cc: netdev@vger.kernel.org
> Cc: linux-rdma@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> 
> Signed-off-by: Jack Wang <jinpu.wang@ionos.com>
> ---
>  drivers/net/ethernet/mellanox/mlx4/icm.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 

Thanks,
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
