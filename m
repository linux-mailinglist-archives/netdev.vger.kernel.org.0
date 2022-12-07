Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D831564598E
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 13:00:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230237AbiLGMAg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 07:00:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230215AbiLGMAT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 07:00:19 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FA356152;
        Wed,  7 Dec 2022 04:00:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B9E9E6151B;
        Wed,  7 Dec 2022 12:00:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id F0856C4314A;
        Wed,  7 Dec 2022 12:00:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670414417;
        bh=wTplOzez9AR5etPwMVDNyWyYGeCbRtsDqhvi5w63gpQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=uGcNkYLIjfbzXlC9L6HhoSvuI6PR2CZ9LDxT+jDw3ExIBCq8AdeYT9jWsYN37Clh/
         rZa+i01F367jnBcb9fSDzsevRy3/uvylL4EScmvHyzSp054ofuUMYvtsOVGEeK3S0W
         28Gg2rCSNM4/1c7WymtPE4V6Js0Mxk2GusUF1euFdMoesC2jDz1M6889Rievowvhd1
         fquoZjAA6tFzrNu+C9AKSLwqbwsWRCOeaEufclyxfZQemLcj5In0dcEfWX2Ap2XTsl
         rjnzD1p2ry6nOs70UCpA1gB67gPBxEaWvEqkN5rNmqT8MmSCJ9a7aE5pSegKI3yoht
         YtkdkhVBsj6yw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id CDBCAE49BBD;
        Wed,  7 Dec 2022 12:00:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net-next Patch v4 0/4] CN10KB MAC block support
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167041441683.7994.13511760581149404295.git-patchwork-notify@kernel.org>
Date:   Wed, 07 Dec 2022 12:00:16 +0000
References: <20221205070521.21860-1-hkelam@marvell.com>
In-Reply-To: <20221205070521.21860-1-hkelam@marvell.com>
To:     Hariprasad Kelam <hkelam@marvell.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kuba@kernel.org, davem@davemloft.net, pabeni@redhat.com,
        edumazet@google.com, sgoutham@marvell.com, lcherian@marvell.com,
        gakula@marvell.com, jerinj@marvell.com, sbhatta@marvell.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by Paolo Abeni <pabeni@redhat.com>:

On Mon, 5 Dec 2022 12:35:17 +0530 you wrote:
> OcteonTx2's next gen platform the CN10KB has RPM_USX MAC which has a
> different serdes when compared to RPM MAC. Though the underlying
> HW is different, the CSR interface has been designed largely inline
> with RPM MAC, with few exceptions though. So we are using the same
> CGX driver for RPM_USX MAC as well and will have a different set of APIs
> for RPM_USX where ever necessary.
> 
> [...]

Here is the summary with links:
  - [net-next,v4,1/4] octeontx2-af: Support variable number of lmacs
    https://git.kernel.org/netdev/net-next/c/f2e664ad503d
  - [net-next,v4,2/4] octeontx2-af: cn10kb: Add RPM_USX MAC support
    https://git.kernel.org/netdev/net-next/c/b9d0fedc6234
  - [net-next,v4,3/4] octeontx2-pf: ethtool: Implement get_fec_stats
    (no matching commit)
  - [net-next,v4,4/4] octeontx2-af: Add FEC stats for RPM/RPM_USX block
    https://git.kernel.org/netdev/net-next/c/84ad3642115d

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


