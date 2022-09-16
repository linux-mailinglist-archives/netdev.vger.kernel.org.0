Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A4D935BA96C
	for <lists+netdev@lfdr.de>; Fri, 16 Sep 2022 11:31:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230157AbiIPJaW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Sep 2022 05:30:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229768AbiIPJaT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Sep 2022 05:30:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 849EF2FFEC;
        Fri, 16 Sep 2022 02:30:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 42D25B82498;
        Fri, 16 Sep 2022 09:30:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id F0306C433D7;
        Fri, 16 Sep 2022 09:30:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663320616;
        bh=8URMKA0WFeAHhN4JW3gUlE5t8ISa0B70lbytY1nLHGw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=oui20Cq1+G6Gp/E/kV9VtNsR8odonv6do2fJ8AxfHHGtPVVnNztnE0obfMCFPDDne
         8K4sEO5GZ08aQaItqx4CDCJsD2hHNME+LBXOpZlpwd3Oll5jEghWeqhuVNuGf6BYcv
         s/U0Z7UnkTVCmAD5BG//B4nf6eWFVp3KXv9K5D++/Lnn0w0vHm/6GW5cj9N7F+45/y
         LDFpsMy1TZVjT1dYxVSIXm7P43ByggIUnAwXNWADIoGnXCXAi7JkygMlxooU6YZ7C+
         G23SsDOvNcNer7fCCuYbvzB1mLOa7EvDndw9TdggEZvIpok1l2ygQ0GuoaHzSx9HS+
         MhUzlXHpZGt5A==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id D1C49C59A58;
        Fri, 16 Sep 2022 09:30:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] vsock/vmci: fix repeated words in comments
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166332061585.20358.18279693577661649289.git-patchwork-notify@kernel.org>
Date:   Fri, 16 Sep 2022 09:30:15 +0000
References: <20220907040131.52975-1-yuanjilin@cdjrlc.com>
In-Reply-To: <20220907040131.52975-1-yuanjilin@cdjrlc.com>
To:     Jilin Yuan <yuanjilin@cdjrlc.com>
Cc:     sgarzare@redhat.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Wed,  7 Sep 2022 12:01:31 +0800 you wrote:
> Delete the redundant word 'that'.
> 
> Signed-off-by: Jilin Yuan <yuanjilin@cdjrlc.com>
> ---
>  net/vmw_vsock/vmci_transport.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Here is the summary with links:
  - vsock/vmci: fix repeated words in comments
    https://git.kernel.org/netdev/net-next/c/454e7b138436

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


