Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AADD4663E31
	for <lists+netdev@lfdr.de>; Tue, 10 Jan 2023 11:29:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229912AbjAJK3N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Jan 2023 05:29:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229718AbjAJK3L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Jan 2023 05:29:11 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98A3A1A38A;
        Tue, 10 Jan 2023 02:29:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 36018615B0;
        Tue, 10 Jan 2023 10:29:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C952DC433D2;
        Tue, 10 Jan 2023 10:29:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673346549;
        bh=z+0BWX2kSw+tuaITOB1eHSwdHQC4uPPD5XkVxlkUGcE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Xvnd7/kMMmFAF/mj2qfSx6VD9KB+Yhlg3k64CZMR2hYqDu1UH1Nb4ANRqWMH5812d
         mNSu1Mc79/TZBTntC8/ZO7CFph59XtJGwnRwpo9dczyXDjamwUJ0yrXKNY965aMJ9n
         kNa0ans+gcBA8rUEnP+TnrRcTuC1Rf+H8jsNMLgWmim/dU7Lm98eyVy+UHR5n+geNS
         Ek1DDcmlXBnO0qiO6Z9YgY++obdAE9pi5pjuUdXV4P0dlaWaf5yJPCTVGELkGrMR+x
         biVCqzZmH8P5VeodR51KY0W1fcPtco5A3gmmQ2VM9NcCHmUG6J8sFYF+29eGEjuA8T
         ziM38v7FPU/rA==
Date:   Tue, 10 Jan 2023 12:29:04 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     pabeni@redhat.com
Cc:     Hariprasad Kelam <hkelam@marvell.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kuba@kernel.org, davem@davemloft.net,
        pabeni@redhat.com, edumazet@google.com, sgoutham@marvell.com,
        gakula@marvell.com, sbhatta@marvell.com
Subject: Re: [net PATCH] octeontx2-pf: Fix resource leakage in VF driver
 unbind
Message-ID: <Y7098K4iMjPyAWww@unreal>
References: <20230109061325.21395-1-hkelam@marvell.com>
 <167334601536.23804.3249818012090319433.git-patchwork-notify@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <167334601536.23804.3249818012090319433.git-patchwork-notify@kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 10, 2023 at 10:20:15AM +0000, patchwork-bot+netdevbpf@kernel.org wrote:
> Hello:
> 
> This patch was applied to netdev/net.git (master)
> by Paolo Abeni <pabeni@redhat.com>:
> 
> On Mon, 9 Jan 2023 11:43:25 +0530 you wrote:
> > resources allocated like mcam entries to support the Ntuple feature
> > and hash tables for the tc feature are not getting freed in driver
> > unbind. This patch fixes the issue.
> > 
> > Fixes: 2da489432747 ("octeontx2-pf: devlink params support to set mcam entry count")
> > Signed-off-by: Hariprasad Kelam <hkelam@marvell.com>
> > Signed-off-by: Sunil Kovvuri Goutham <sgoutham@marvell.com>
> > 
> > [...]
> 
> Here is the summary with links:
>   - [net] octeontx2-pf: Fix resource leakage in VF driver unbind
>     https://git.kernel.org/netdev/net/c/53da7aec3298

Paolo,

I don't think that this patch should be applied.

It looks like wrong Fixes to me and I don't see clearly how structures
were allocated on VF which were cleared in this patch.

Thanks

> 
> You are awesome, thank you!
> -- 
> Deet-doot-dot, I am a bot.
> https://korg.docs.kernel.org/patchwork/pwbot.html
> 
> 
