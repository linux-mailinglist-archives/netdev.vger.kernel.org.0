Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F33785867CD
	for <lists+netdev@lfdr.de>; Mon,  1 Aug 2022 12:50:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230341AbiHAKuS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Aug 2022 06:50:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230042AbiHAKuQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Aug 2022 06:50:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 472F0F68;
        Mon,  1 Aug 2022 03:50:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 05109B80FF1;
        Mon,  1 Aug 2022 10:50:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 90B34C433B5;
        Mon,  1 Aug 2022 10:50:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659351012;
        bh=AyuwO2/1dfwoNstGKU29Y1p6hs/jknSvMh/8nrrVsOA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=tK0zGZmbyB0iE27QZ6Op3Xvp0TZfDHAzYfOHg51x9Ty55mB2/QklLqp8Arn7SFQVx
         9K9wwSKjamGlseT8br2Xeyk7VP+qJ+PeaAfAsHgT0p0vzWfqw0VsUuK9SHLhio0XnY
         RjTOPThHVGRm5jiePCY5ux70VGoxgxPSdIW8k/EQjW8c6u8odtlQpwNVeYA0AWBrqC
         W+BrbrSLW/+orEwVgZ5Mo9lw1IV/GVDsx4q/xU4VuuTGNR3IL9EXm4d1giW1RszHDh
         vbuklrPnW6Ug0LCGIrKIDYX9whdX0SbrlN1Yre/LYf/+tLRvnlyeUQpHGAt8fmXu1B
         vmtGSlQX2SPhg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 71040C43140;
        Mon,  1 Aug 2022 10:50:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net/rds: Use PTR_ERR instead of IS_ERR for rdsdebug()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165935101245.27984.11610788210313298570.git-patchwork-notify@kernel.org>
Date:   Mon, 01 Aug 2022 10:50:12 +0000
References: <20220727150341.23746-1-liqiong@nfschina.com>
In-Reply-To: <20220727150341.23746-1-liqiong@nfschina.com>
To:     Li Qiong <liqiong@nfschina.com>
Cc:     santosh.shilimkar@oracle.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        rds-devel@oss.oracle.com, linux-kernel@vger.kernel.org,
        yuzhe@nfschina.com, renyu@nfschina.com, jiaming@nfschina.com
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Wed, 27 Jul 2022 23:03:41 +0800 you wrote:
> If 'local_odp_mr->r_trans_private' is a error code,
> it is better to print the error code than to print
> the value of IS_ERR().
> 
> Signed-off-by: Li Qiong <liqiong@nfschina.com>
> ---
>  net/rds/rdma.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Here is the summary with links:
  - net/rds: Use PTR_ERR instead of IS_ERR for rdsdebug()
    https://git.kernel.org/netdev/net/c/5121db6afb99

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


