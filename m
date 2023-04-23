Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44E306EC125
	for <lists+netdev@lfdr.de>; Sun, 23 Apr 2023 18:48:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229606AbjDWQr4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Apr 2023 12:47:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229478AbjDWQrz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Apr 2023 12:47:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32A8710E2;
        Sun, 23 Apr 2023 09:47:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C57F860F2A;
        Sun, 23 Apr 2023 16:47:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D8D9C433EF;
        Sun, 23 Apr 2023 16:47:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682268474;
        bh=0Gy0sKprsct9PeNbkShfwsKvr55d3L+yZ6gXbSWx++0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Xo/hlvuOPJOLWu4oaSUbvhWBWTTP+U1iXUlL5ddiw4aWDwNuqXybnEeonK912tjxv
         lMuwaCrkxzG6YoSd6u4NBkMbd82KFseQHkC2xlvUznz6joVvJXvU+gk1zgYhH8Ydyf
         mfa2PMS3rkdWmvB6SLNonsQxHbEwxpWz4DrFQ99KbMYY9IJ294Do+WrQtzp4AQupnS
         HSEVvK+QtuJ6sW4khvZC/De65IYzVcFzkDytRK25ABofhY5iuJXegfFdpGCIroC38N
         /6KGgWYYXoyj2zsesClo/et7lQunlq5pDgNFuw8pAkbwXSAukyVVWbnNmYawCmAvAn
         qS59Z1uvUvnKQ==
Date:   Sun, 23 Apr 2023 19:47:49 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Geetha sowjanya <gakula@marvell.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kuba@kernel.org, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com, richardcochran@gmail.com, sgoutham@marvell.com,
        sbhatta@marvell.com, hkelam@marvell.com
Subject: Re: [net PATCH 2/9] octeontx2-af: mcs: Write TCAM_DATA and TCAM_MASK
 registers at once
Message-ID: <20230423164749.GD4782@unreal>
References: <20230423095454.21049-1-gakula@marvell.com>
 <20230423095454.21049-3-gakula@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230423095454.21049-3-gakula@marvell.com>
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Apr 23, 2023 at 03:24:47PM +0530, Geetha sowjanya wrote:
> From: Subbaraya Sundeep <sbhatta@marvell.com>
> 
> As per hardware errata on CN10KB, all the four TCAM_DATA
> and TCAM_MASK registers has to be written at once otherwise
> write to individual registers will fail. Hence write to all
> TCAM_DATA registers and then to all TCAM_MASK registers.
> 
> Fixes: cfc14181d497 ("octeontx2-af: cn10k: mcs: Manage the MCS block hardware resources")
> Signed-off-by: Subbaraya Sundeep <sbhatta@marvell.com>
> Signed-off-by: Sunil Kovvuri Goutham <sgoutham@marvell.com>
> Signed-off-by: Geetha sowjanya <gakula@marvell.com>
> ---
>  drivers/net/ethernet/marvell/octeontx2/af/mcs.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 

Thanks,
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
