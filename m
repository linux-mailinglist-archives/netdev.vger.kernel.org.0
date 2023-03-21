Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 85B0D6C2C23
	for <lists+netdev@lfdr.de>; Tue, 21 Mar 2023 09:19:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229754AbjCUITO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Mar 2023 04:19:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229640AbjCUITN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Mar 2023 04:19:13 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE9AD1E5DD;
        Tue, 21 Mar 2023 01:19:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8B3B9B80AAE;
        Tue, 21 Mar 2023 08:19:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8DA0C433D2;
        Tue, 21 Mar 2023 08:19:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679386749;
        bh=Ks5ViESurktGKgBd2uFB5R4vHEq34LZRHghYCYKAMSE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=po4Tb2EEoW2ifbcoLkCUcwd5AtZWf/qaa+6x3bbIYiiKJjXh5455CF05mKyYUERIJ
         8bWwH/P4XoIgm+cLobUUOkoKAi1iREKNfsozXcuVyXz9T2oy6va809LRdF4dqqJXak
         DlX0KMmMOvlUNLQr9xwUAaHnDsZ5NXuLhLC2Ivhrvwnlm4Vn4DzaBcYTi8ViB1QaGC
         XiljPqSl5CMfimJCNFqc6qBobdLyPEWbZP/LySJu3sRGPAOmzqCDQB9k9hWFQt3h+v
         NMRzd0QPwmihZd9JMelo3jPM1gg1ZynIzt2sT5BI4jDw4QxXY2kAyuo13OT0Kd399m
         6j0FOTougtPhA==
Date:   Tue, 21 Mar 2023 10:19:04 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Finn Thain <fthain@linux-m68k.org>
Cc:     Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Zhang Changzhong <zhangchangzhong@huawei.com>
Subject: Re: [PATCH v2 net] net/sonic: use dma_mapping_error() for error check
Message-ID: <20230321081904.GR36557@unreal>
References: <6645a4b5c1e364312103f48b7b36783b94e197a2.1679370343.git.fthain@linux-m68k.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6645a4b5c1e364312103f48b7b36783b94e197a2.1679370343.git.fthain@linux-m68k.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 21, 2023 at 02:45:43PM +1100, Finn Thain wrote:
> From: Zhang Changzhong <zhangchangzhong@huawei.com>
> 
> The DMA address returned by dma_map_single() should be checked with
> dma_mapping_error(). Fix it accordingly.
> 
> Fixes: efcce839360f ("[PATCH] macsonic/jazzsonic network drivers update")
> Signed-off-by: Zhang Changzhong <zhangchangzhong@huawei.com>
> Tested-by: Stan Johnson <userm57@yahoo.com>
> Signed-off-by: Finn Thain <fthain@linux-m68k.org>
> ---
> This was originally Zhang Changzhong's patch. I've just added the missing
> curly bracket which caused a build failure when the patch was first posted.
> ---
>  drivers/net/ethernet/natsemi/sonic.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 

Thanks,
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
