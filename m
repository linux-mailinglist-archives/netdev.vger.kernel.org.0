Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B21D1699291
	for <lists+netdev@lfdr.de>; Thu, 16 Feb 2023 12:00:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230049AbjBPLAV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Feb 2023 06:00:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229718AbjBPLAU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Feb 2023 06:00:20 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 930EE59EB
        for <netdev@vger.kernel.org>; Thu, 16 Feb 2023 03:00:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2D92861F47
        for <netdev@vger.kernel.org>; Thu, 16 Feb 2023 11:00:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 896A4C433EF;
        Thu, 16 Feb 2023 11:00:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676545218;
        bh=bApknXD5a/8N2n9A+m/muQvK1ykweq3vseOPrQarHiI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=UwYHYstMXOzYJbppll6AsS5StZfqzenNmFpZ2hKE9rAFmx/7LDcLxUit5OaKYPPo9
         iVsTVJwfkM6k3HxeSAt5WI/Svk7rVHVBLFNFSowIqNjWTPm9TLGQZMZKut4b6j5WrT
         +8XicshiXz/C6aT7OmCQxrDsgxVVndjJj19tk2lP4KkCIA2+nyatIGlRAJhqCuDyWL
         LTdogMEKlT/N7uLOFu1aQAZUv306A+SoTsfBcYpZFAYv8bmEyylp6JQ0TwCFTE7uQy
         rh/aut9J6l4U2VXPyjm4axw0auS/KsVI+5VoY3YxFh9zMIRdvGbBuFNA3m18JO2+lL
         vjMHocNDp4LNA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 6E035E21EC4;
        Thu, 16 Feb 2023 11:00:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] devlink: Fix netdev notifier chain corruption
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167654521844.29376.6928357027245745496.git-patchwork-notify@kernel.org>
Date:   Thu, 16 Feb 2023 11:00:18 +0000
References: <20230215073139.1360108-1-idosch@nvidia.com>
In-Reply-To: <20230215073139.1360108-1-idosch@nvidia.com>
To:     Ido Schimmel <idosch@nvidia.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com, jiri@nvidia.com,
        jacob.e.keller@intel.com, sfr@canb.auug.org.au, mlxsw@nvidia.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Paolo Abeni <pabeni@redhat.com>:

On Wed, 15 Feb 2023 09:31:39 +0200 you wrote:
> Cited commit changed devlink to register its netdev notifier block on
> the global netdev notifier chain instead of on the per network namespace
> one.
> 
> However, when changing the network namespace of the devlink instance,
> devlink still tries to unregister its notifier block from the chain of
> the old namespace and register it on the chain of the new namespace.
> This results in corruption of the notifier chains, as the same notifier
> block is registered on two different chains: The global one and the per
> network namespace one. In turn, this causes other problems such as the
> inability to dismantle namespaces due to netdev reference count issues.
> 
> [...]

Here is the summary with links:
  - [net] devlink: Fix netdev notifier chain corruption
    https://git.kernel.org/netdev/net/c/b20b8aec6ffc

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


