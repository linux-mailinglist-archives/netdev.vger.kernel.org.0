Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67C606DBF69
	for <lists+netdev@lfdr.de>; Sun,  9 Apr 2023 12:11:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229527AbjDIKKY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Apr 2023 06:10:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbjDIKKX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Apr 2023 06:10:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44772421B
        for <netdev@vger.kernel.org>; Sun,  9 Apr 2023 03:10:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CD4F06023E
        for <netdev@vger.kernel.org>; Sun,  9 Apr 2023 10:10:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B44EC433EF;
        Sun,  9 Apr 2023 10:10:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681035021;
        bh=Uf+OysgD5k1aqYYWFOANYCfaCp7XVqAiasCHGU4uj8w=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=QIhJ205vVVzmZ9aDi7Gxq15nf8nAVEPFNEEf33K7A5PvnKLdPBUZVty3JQaX7eggq
         DodTh0nde1Y1EvNovHQhIAPCuKPcRdCXJos+EmW7Htqd30NRWYD/UybCF1kAcvm/xE
         4FQFuCxxNXbnmVwmcxSAjNjfEhvKl9OpDS41TikVKP5e69yBs1iXBiNxKBq4Rb3kJr
         BDdpxj5eXKnE0npje2pFmua0xYgJAAxBQZrERt4xJ5/yPZfUB+vC4k3CakWge/Ks1n
         mUXeKDeIaIIghiwzhlHwQay475OkODRAWPKM0W06xRiuZ532OmWkPpkc1x0n/n91MH
         KPgIE/9dDKl3w==
Date:   Sun, 9 Apr 2023 13:10:16 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Eli Cohen <elic@nvidia.com>, Eric Dumazet <edumazet@google.com>,
        Jacob Keller <jacob.e.keller@intel.com>,
        netdev@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Shay Drory <shayd@nvidia.com>
Subject: Re: [PATCH net-next] net/mlx5: Include proper PCI headers file to
 fix compilation error
Message-ID: <20230409101016.GI14869@unreal>
References: <33205aa15efbafa9330a00f2f6f8651add551f49.1681026343.git.leonro@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <33205aa15efbafa9330a00f2f6f8651add551f49.1681026343.git.leonro@nvidia.com>
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Apr 09, 2023 at 10:48:43AM +0300, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@nvidia.com>
> 
> Fix the following compilation error, which happens due to missing pci.h
> include.
> 
>  drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c:148:31: error: implicit declaration of function
> 'pci_msix_can_alloc_dyn' [-Werror=implicit-function-declaration]
> 
> Fixes: 3354822cde5a ("net/mlx5: Use dynamic msix vectors allocation")
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> ---
>  drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c | 1 +
>  1 file changed, 1 insertion(+)

Actually, this patch is not needed.
The fix is in PCI tree.
https://lore.kernel.org/all/310ecc4815dae4174031062f525245f0755c70e2.1680119924.git.reinette.chatre@intel.com/

Thanks
