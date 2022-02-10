Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C414C4B0246
	for <lists+netdev@lfdr.de>; Thu, 10 Feb 2022 02:30:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232589AbiBJBaL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 20:30:11 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:33276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232462AbiBJBaJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 20:30:09 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BE52FE8;
        Wed,  9 Feb 2022 17:30:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5DF42617F7;
        Thu, 10 Feb 2022 01:30:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B9F32C340F1;
        Thu, 10 Feb 2022 01:30:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644456609;
        bh=QCCqocOBA0QXANoR9Th7qCJXBmcweW8s/m7U1ai9C5E=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=fpB6X8Au1GTblA5imuus/BJFEuX9LTKozlgVvHcwfql2P0FgYwZZgSWigzkzUZkLj
         Vg86Mp8NvLWFpmr4aP21pLetK+F/IT8sH+oWmUtDU/ErjWc5EkxirpayoJo/vQpiAg
         akajpvR6h5ZUXZqCy+R0cAe5O6/eUekFoLSD1WAkL9UipJUnrHxqkgPpkg/6asOE1Z
         8Ey8SttVebfkfytu7QmKjhmRmDnzt2be5IOszye8UP5BDbqfa7zUCYrgmSKX2lVRcc
         WDK2tvpoQKl5bXBpLMsiGCJ7j9afCHYNx2Br2ASI4Fw3lcLgUhJL+oZ8ZHV5sh2u1t
         tQIJYMEh21s6A==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id A8FE3E6D447;
        Thu, 10 Feb 2022 01:30:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v8 net-next] net: drop_monitor: support drop reason
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164445660968.21209.6215816253255469230.git-patchwork-notify@kernel.org>
Date:   Thu, 10 Feb 2022 01:30:09 +0000
References: <20220209060838.55513-1-imagedong@tencent.com>
In-Reply-To: <20220209060838.55513-1-imagedong@tencent.com>
To:     Menglong Dong <menglong8.dong@gmail.com>
Cc:     idosch@idosch.org, nhorman@tuxdriver.com, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, rostedt@goodmis.org,
        dsahern@kernel.org, imagedong@tencent.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Wed,  9 Feb 2022 14:08:38 +0800 you wrote:
> From: Menglong Dong <imagedong@tencent.com>
> 
> In the commit c504e5c2f964 ("net: skb: introduce kfree_skb_reason()")
> drop reason is introduced to the tracepoint of kfree_skb. Therefore,
> drop_monitor is able to report the drop reason to users by netlink.
> 
> The drop reasons are reported as string to users, which is exactly
> the same as what we do when reporting it to ftrace.
> 
> [...]

Here is the summary with links:
  - [v8,net-next] net: drop_monitor: support drop reason
    https://git.kernel.org/netdev/net-next/c/5cad527d5ffa

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


