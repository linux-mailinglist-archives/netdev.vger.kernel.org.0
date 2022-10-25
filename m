Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF1FD60CA78
	for <lists+netdev@lfdr.de>; Tue, 25 Oct 2022 13:00:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231808AbiJYLAX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Oct 2022 07:00:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231649AbiJYLAV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Oct 2022 07:00:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7CFF2034D
        for <netdev@vger.kernel.org>; Tue, 25 Oct 2022 04:00:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 34CFF618D3
        for <netdev@vger.kernel.org>; Tue, 25 Oct 2022 11:00:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 91C72C43470;
        Tue, 25 Oct 2022 11:00:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666695616;
        bh=FA1VZQDtazyCxbkXstqAX/NSbbxs7NzuJb+fqDysfk0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=hmGDgn+UfhmT1tzoTzzQPX5H+4UrgoKjctsNqu+CRlIFGXZt3WUtdN+SPzRJf2CbP
         YzFbNwgZ7wfrLoSOU8hhGxIKY1ICJIMUS/HCmpjHLg4Q6uoi3e+/PdLn9/39pddNvU
         q+1swia4vQegpGC/VcBqyeT40UXwPYHISc+HO+hx3JGgMIkkQi042zYFfgqSp9UR5i
         4Eh5ITwqPlYJpuFJDi+S0rKXLM7CQ9m8CZflE1WmULWCg1QR3+w60Jl4oosNleHxH1
         g6dV5ael7FMTVc78OQ727MKSTo9FRASLh7AEQKesdGFEP8ZX/9r/pAk55TGnxlJA/x
         bAM+zpfmK2ZrA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 751FCE270DD;
        Tue, 25 Oct 2022 11:00:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/3] mptcp: Socket option updates
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166669561647.19870.18241415967281584728.git-patchwork-notify@kernel.org>
Date:   Tue, 25 Oct 2022 11:00:16 +0000
References: <20221022004505.160988-1-mathew.j.martineau@linux.intel.com>
In-Reply-To: <20221022004505.160988-1-mathew.j.martineau@linux.intel.com>
To:     Mat Martineau <mathew.j.martineau@linux.intel.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com,
        matthieu.baerts@tessares.net, mptcp@lists.linux.dev
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Fri, 21 Oct 2022 17:45:02 -0700 you wrote:
> Patches 1 and 3 refactor a recent socket option helper function for more
> generic use, and make use of it in a couple of places.
> 
> Patch 2 adds TCP_FASTOPEN_NO_COOKIE functionality to MPTCP sockets,
> similar to TCP_FASTOPEN_CONNECT support recently added in v6.1
> 
> 
> [...]

Here is the summary with links:
  - [net-next,1/3] mptcp: sockopt: make 'tcp_fastopen_connect' generic
    https://git.kernel.org/netdev/net-next/c/d3d429047cc6
  - [net-next,2/3] mptcp: add TCP_FASTOPEN_NO_COOKIE support
    https://git.kernel.org/netdev/net-next/c/e64d4deb4de0
  - [net-next,3/3] mptcp: sockopt: use new helper for TCP_DEFER_ACCEPT
    https://git.kernel.org/netdev/net-next/c/caea64675d8b

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


