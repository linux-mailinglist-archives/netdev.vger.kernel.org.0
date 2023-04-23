Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 368C66EC141
	for <lists+netdev@lfdr.de>; Sun, 23 Apr 2023 18:56:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230010AbjDWQ4X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Apr 2023 12:56:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229648AbjDWQ4W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Apr 2023 12:56:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F59DA9;
        Sun, 23 Apr 2023 09:56:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 29FA161B5A;
        Sun, 23 Apr 2023 16:56:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 084D9C433EF;
        Sun, 23 Apr 2023 16:56:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682268980;
        bh=tx4DNa3+BuRipHchT7RV96Wl55IEGW7IECRqIdmmQi4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=RnZl0NLU2mCHcsbnanZbmtVd+kJkGz0R6S6x3KXyuxEaig6VjdeWS3CpE/d0Li6d4
         gSMVqygc6Ce0WMgomy+WJE1b4+szgdnjEjakP5Y+smNRxpcqOzNEXT2euTclazm3ix
         N37Am9yVPMSjT8vuXxNWr0TWCpgivLpsmmO+XEdvkveTa+L8eTnuoXqeIu6ygnd5JB
         EL+lrsefNzEBlzxLH1a/AyZAeStFLPWYK+z9woZz+mq0W+gMCsbvT+/Uuucb2hJphK
         d4ri+GeNV/JskosEh3CR4Q1U48pzITuZuzGufFWl64yO3qDnu9El10AbHnC5P4lo9s
         CdG4VurjlXF7Q==
Date:   Sun, 23 Apr 2023 19:56:16 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Geetha sowjanya <gakula@marvell.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kuba@kernel.org, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com, richardcochran@gmail.com, sgoutham@marvell.com,
        sbhatta@marvell.com, hkelam@marvell.com
Subject: Re: [net PATCH 9/9] octeontx2-pf: mcs: Do not reset PN while
 updating secy
Message-ID: <20230423165616.GL4782@unreal>
References: <20230423095454.21049-1-gakula@marvell.com>
 <20230423095454.21049-10-gakula@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230423095454.21049-10-gakula@marvell.com>
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Apr 23, 2023 at 03:24:54PM +0530, Geetha sowjanya wrote:
> From: Subbaraya Sundeep <sbhatta@marvell.com>
> 
> After creating SecYs, SCs and SAs a SecY can be modified
> to change attributes like validation mode, protect frames
> mode etc. During this SecY update, packet number is reset to
> initial user given value by mistake. Hence do not reset
> PN when updating SecY parameters.
> 
> Fixes: c54ffc73601c ("octeontx2-pf: mcs: Introduce MACSEC hardware offloading")
> Signed-off-by: Subbaraya Sundeep <sbhatta@marvell.com>
> Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
> Signed-off-by: Geetha sowjanya <gakula@marvell.com>
> ---
>  .../ethernet/marvell/octeontx2/nic/cn10k_macsec.c | 15 ++++++++++-----
>  1 file changed, 10 insertions(+), 5 deletions(-)
> 

Thanks,
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
