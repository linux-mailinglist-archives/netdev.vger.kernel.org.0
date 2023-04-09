Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC0436DBF44
	for <lists+netdev@lfdr.de>; Sun,  9 Apr 2023 10:55:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229503AbjDIIzX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Apr 2023 04:55:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbjDIIzW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Apr 2023 04:55:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4BD146B4;
        Sun,  9 Apr 2023 01:55:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 70EAC6118C;
        Sun,  9 Apr 2023 08:55:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51EDEC433D2;
        Sun,  9 Apr 2023 08:55:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681030520;
        bh=lqqiLjfdID7NyrKwl8gxSvXGYqRVMurTrjdak7tHvak=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Z4cY0crpnqKkmW2SbJZhhN/vR2Pi9xctdkfISRhIRbBxJe1Xcp5XI9WmMAiQJ4s1T
         hD/nAkNIS6EGMcfwe+ZxAA96ci2EyqU6sGD+lq7AkG/UNThDFBTXGZIcJB3YIe4QDc
         RxgK25yfZK57AlxNGcMVcUrOAwKtBo0whBtURGUK4Yh6Kvnz3rujaZRfs/mVxCf9+5
         OaNGkS/lbW6pDTBSbrgzJcQbLpmayNfkU4hnbXduYHpDtB0UyQgDW6zmBcRiF5qauo
         cVC/+NijSjImyugthBBg5JmJEpUuag9uWnD7a9ztiuXVgQ6kP7kX0CBP9beAxkr+6N
         ica23rJPRO+vA==
Date:   Sun, 9 Apr 2023 11:55:16 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Niklas Schnelle <schnelle@linux.ibm.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Gerd Bayer <gbayer@linux.ibm.com>,
        Alexander Schmidt <alexs@linux.ibm.com>,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net/mlx5: stop waiting for PCI link if reset is required
Message-ID: <20230409085516.GD14869@unreal>
References: <20230403075657.168294-1-schnelle@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230403075657.168294-1-schnelle@linux.ibm.com>
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 03, 2023 at 09:56:56AM +0200, Niklas Schnelle wrote:
> after an error on the PCI link, the driver does not need to wait
> for the link to become functional again as a reset is required. Stop
> the wait loop in this case to accelerate the recovery flow.
> 
> Co-developed-by: Alexander Schmidt <alexs@linux.ibm.com>
> Signed-off-by: Alexander Schmidt <alexs@linux.ibm.com>
> Signed-off-by: Niklas Schnelle <schnelle@linux.ibm.com>
> ---
>  drivers/net/ethernet/mellanox/mlx5/core/health.c | 12 ++++++++++--
>  1 file changed, 10 insertions(+), 2 deletions(-)
> 

The subject line should include target for netdev patches: [PATCH net-next] ....

Thanks,
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
