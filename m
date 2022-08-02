Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD622587603
	for <lists+netdev@lfdr.de>; Tue,  2 Aug 2022 05:40:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233354AbiHBDkW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Aug 2022 23:40:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231432AbiHBDkR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Aug 2022 23:40:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D1B6FCC;
        Mon,  1 Aug 2022 20:40:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E1C79611F3;
        Tue,  2 Aug 2022 03:40:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 36BD0C433C1;
        Tue,  2 Aug 2022 03:40:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659411613;
        bh=47AWwpQrYgMysc/F+zD8FV2o2P/4ceENn5IpcjMKU6o=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=JQ9quIW3M1UUdOhOf9WoS3uydqnBd7O11VJupGuJAsZQaRnhISFqYEHRmvONmXjIv
         o9Oma719321+Ff2yRerFSOtIs6QF1pG7Idqap8F8WOQe4uYfbC5DxJ8wpa06DyvpM5
         y0hBkASTQ+9GTi/904bEUpKOltsW0E4RT4+V+VntkZw/22vjEqDNuRu+5J3u16A0d3
         pQ2qJ8qWvUYMFE2D/uFuCS4sXnnNT3Gj8iCr7ov8pQNx2FDU/bFPD8r6lhBK5HCdVc
         WtkGaYHVHHk9/G5l56Qf84AOIxytS+kTFgB9uy4ukXPs1fL/MVGn15di/nn+mN9Hbd
         ljRfMaKsuuZng==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 1A904C43142;
        Tue,  2 Aug 2022 03:40:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH -next] net: marvell: prestera: remove reduntant code
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165941161310.6622.708712515490521378.git-patchwork-notify@kernel.org>
Date:   Tue, 02 Aug 2022 03:40:13 +0000
References: <20220801040731.34741-1-mailmesebin00@gmail.com>
In-Reply-To: <20220801040731.34741-1-mailmesebin00@gmail.com>
To:     Sebin Sebastian <mailmesebin00@gmail.com>
Cc:     tchornyi@marvell.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Mon,  1 Aug 2022 09:37:31 +0530 you wrote:
> Fixes the coverity warning 'EVALUATION_ORDER' violation. port is written
> twice with the same value.
> 
> Fixes: Coverity CID 1519056 (Incorrect expression)
> Signed-off-by: Sebin Sebastian <mailmesebin00@gmail.com>
> ---
>  drivers/net/ethernet/marvell/prestera/prestera_main.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Here is the summary with links:
  - [-next] net: marvell: prestera: remove reduntant code
    https://git.kernel.org/netdev/net-next/c/969e26c63d30

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


