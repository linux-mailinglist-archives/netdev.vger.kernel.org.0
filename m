Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 15C8952F6FF
	for <lists+netdev@lfdr.de>; Sat, 21 May 2022 02:50:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235271AbiEUAuP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 May 2022 20:50:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229555AbiEUAuP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 May 2022 20:50:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E662F195900;
        Fri, 20 May 2022 17:50:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2AFF961E9E;
        Sat, 21 May 2022 00:50:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 78E50C34116;
        Sat, 21 May 2022 00:50:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653094212;
        bh=lANK/dHuOGyuRpfooUZbseMGEzHwxd6HsBRfy0m+pu0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ulwAfyl2XyVAbw8VhY3/kznTaE6XXr94ZQS+7cePTB2ltWLrWRMRkvIA7UqUhl3Tw
         Gq2P2J//iiwHip2K9vm1DFbukX+G/c4+/O1yoyB6g/vAsgv6CpGehdsVGGzLrqtbQg
         PTB7dJ3eBoJFEJEdKsuXo85U9CHA26gxi/Cxbm6nEkxkFG8kpjNqbgcA1dGmwg/rnU
         0N3IrFdF/+hrj0TbkMipz41WNFyg3YWs9gubbZxF2ifEEJDz8eEzYZFd1SOA+Yt0c1
         2snYY2z2VopeH8GIaMMBDdqZgHSY1TsBEQdulHYyUcbws63Jiw0lfyTKL8Siq4ZQz+
         qnqdw9S47iP4w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 5B556F0393C;
        Sat, 21 May 2022 00:50:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH -next] stcp: Use memset_after() to zero sctp_stream_out_ext
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165309421237.963.17903650361322953279.git-patchwork-notify@kernel.org>
Date:   Sat, 21 May 2022 00:50:12 +0000
References: <20220519062932.249926-1-xiujianfeng@huawei.com>
In-Reply-To: <20220519062932.249926-1-xiujianfeng@huawei.com>
To:     Xiu Jianfeng <xiujianfeng@huawei.com>
Cc:     vyasevich@gmail.com, nhorman@tuxdriver.com,
        marcelo.leitner@gmail.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        linux-sctp@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 19 May 2022 14:29:32 +0800 you wrote:
> Use memset_after() helper to simplify the code, there is no functional
> change in this patch.
> 
> Signed-off-by: Xiu Jianfeng <xiujianfeng@huawei.com>
> ---
>  net/sctp/stream_sched.c | 9 +++------
>  1 file changed, 3 insertions(+), 6 deletions(-)

Here is the summary with links:
  - [-next] stcp: Use memset_after() to zero sctp_stream_out_ext
    https://git.kernel.org/netdev/net-next/c/29849a486a85

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


