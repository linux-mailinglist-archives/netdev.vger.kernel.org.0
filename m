Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B35CE57FD25
	for <lists+netdev@lfdr.de>; Mon, 25 Jul 2022 12:10:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234679AbiGYKK2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jul 2022 06:10:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234620AbiGYKKP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jul 2022 06:10:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 011CE55B3;
        Mon, 25 Jul 2022 03:10:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7DBDC612DA;
        Mon, 25 Jul 2022 10:10:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 9CFBCC341CD;
        Mon, 25 Jul 2022 10:10:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658743813;
        bh=DTPr9cWKosO+jDms+REqzOYmNiyA0+dxrNo8vK/sdnM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=pXbgWhikoqxSnFS2OY9ElmGjADEPWJgmjcs/LnnbN7J/0O9d5ioJLlQcofkcmHB+e
         X5k0GF2x4SZUZufmHA27v7zNXaI44uH7zkLye4NphOEcOPOocUWAe5uRqDdTi/uh45
         UFFtqwgJ9Lfycr9MQaykUCeKyNgHPdrsDcsLGldHQmV9ify3yhbr18UCSbu3tfHf3D
         AjvbmtyMLyQrSGIfHlSg3QrD6rCA1WYIedBcNcUAXi6VIEEisFb8B5mxxAP8yQ6772
         ITbbOop95X8FuHYD0k/O1Z6Ys5yR8mPwSzExp3yUFtj+4JM5jHoRQktmPCdn7AqOQ5
         6kVJJ0G9iQcBw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 835C7E450B8;
        Mon, 25 Jul 2022 10:10:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: ipa: Fix typo 'the the' in comment
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165874381353.12821.5896325794806077969.git-patchwork-notify@kernel.org>
Date:   Mon, 25 Jul 2022 10:10:13 +0000
References: <20220722082227.74274-1-slark_xiao@163.com>
In-Reply-To: <20220722082227.74274-1-slark_xiao@163.com>
To:     Slark Xiao <slark_xiao@163.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, elder@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
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

On Fri, 22 Jul 2022 16:22:27 +0800 you wrote:
> Replace 'the the' with 'the' in the comment.
> 
> Signed-off-by: Slark Xiao <slark_xiao@163.com>
> ---
>  drivers/net/ipa/ipa_qmi_msg.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Here is the summary with links:
  - net: ipa: Fix typo 'the the' in comment
    https://git.kernel.org/netdev/net/c/2540d3c99926

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


