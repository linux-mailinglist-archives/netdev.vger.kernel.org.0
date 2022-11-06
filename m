Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E55E61E549
	for <lists+netdev@lfdr.de>; Sun,  6 Nov 2022 19:22:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230029AbiKFSWn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Nov 2022 13:22:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229902AbiKFSWl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Nov 2022 13:22:41 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C70553B6;
        Sun,  6 Nov 2022 10:22:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 36411B80C91;
        Sun,  6 Nov 2022 18:22:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55948C433C1;
        Sun,  6 Nov 2022 18:22:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667758957;
        bh=0tDI6th3dfAe0TFQ/Ebo3ulSXvor7G9Blnf+NMeJAHM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=JA/7m8JxtHvp1hnTOmDYdkpYtKJwGtT5a9Lq/hpMIkW+QpY5mI/u08v61A0PI53Jf
         j4eKpbOX5e0ojb6I66ldojuhPhIEBGlgWAkg0mmgyCBZepCuEv+7wE+sNhNDERMy2h
         qn07Cvju6ibCkib2VcxLTy816WCoN3JQInR0wYWqX5z8Ljq6Ant+ug/tZ2gxtP4xbm
         e5kx0AI4lubizbuQKKDucYS/EmGV0zxf8dI3yLDAWNxECtbjk++ZhUyq4z2CyniFpb
         lzbRgyEXh9/AHzJccTlksO+eT9+xE+CFK0dWI/Q56+XlcDdYpdJ/kuskmPKAeDmd+n
         y29MV9UY85a3Q==
Date:   Sun, 6 Nov 2022 20:22:33 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Anisse Astier <anisse@astier.eu>
Cc:     netdev@vger.kernel.org, Anisse Astier <an.astier@criteo.com>,
        Erwan Velu <e.velu@criteo.com>,
        Maor Gottlieb <maorg@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-rdma@vger.kernel.org
Subject: Re: [PATCH] net/mlx5e: remove unused list in arfs
Message-ID: <Y2f7aaFtzokrhyhX@unreal>
References: <20221031165604.1771965-1-anisse@astier.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221031165604.1771965-1-anisse@astier.eu>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 31, 2022 at 05:56:04PM +0100, Anisse Astier wrote:
> This is never used, and probably something that was intended to be used
> before per-protocol hash tables were chosen instead.
> 
> Signed-off-by: Anisse Astier <anisse@astier.eu>
> ---
>  drivers/net/ethernet/mellanox/mlx5/core/en_arfs.c | 2 --
>  1 file changed, 2 deletions(-)
> 

The patch subject should be "[PATCH net-next] ..."

Thanks,
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
