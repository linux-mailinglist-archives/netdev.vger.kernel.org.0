Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E36F7623810
	for <lists+netdev@lfdr.de>; Thu, 10 Nov 2022 01:20:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232137AbiKJAUT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Nov 2022 19:20:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231769AbiKJAUS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Nov 2022 19:20:18 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4047120BB
        for <netdev@vger.kernel.org>; Wed,  9 Nov 2022 16:20:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7220161D2B
        for <netdev@vger.kernel.org>; Thu, 10 Nov 2022 00:20:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A1478C433D7;
        Thu, 10 Nov 2022 00:20:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668039616;
        bh=uMs0FuIBk3bq8n/QIYe7lUVRZn8a/xWyIogJu1eXOxQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=gyisy0hDQkfKK6R99YLN2C3d1sgq/iu4dtdT0Fle4SeaEVeqqGygezX3gtyOfW1dp
         0gBQ9/Z5qL4EE8+SbZScPijZR6y88njNEh5sMd4FDDXAzPXpLKiW0aNN8zqF33arFM
         KVLvbYAugcTb+AKMQMk+bF7XcGed4xMcA4zPA9PRmKXxngqcX9+9WJLhj5t+/nCONZ
         iB7csHCHsg6yc0ioj3jMksee0C0KdBmURmaOH+wH1CXqz57aOYOF6atXPaXapOdgkb
         +hKnDWHJqlAVoSBgNhvuoKxrHvN5K9J9iX4loRT3aN/XALjnqx05X6LQri42nYgTA4
         Uk2t6Hd1agy4g==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 6E5F9C395F6;
        Thu, 10 Nov 2022 00:20:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [patch net-next v2 0/3] net: devlink: move netdev notifier block to
 dest namespace during reload
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166803961644.29271.8640118495260499830.git-patchwork-notify@kernel.org>
Date:   Thu, 10 Nov 2022 00:20:16 +0000
References: <20221108132208.938676-1-jiri@resnulli.us>
In-Reply-To: <20221108132208.938676-1-jiri@resnulli.us>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com, idosch@idosch.org,
        bigeasy@linutronix.de, imagedong@tencent.com, kuniyu@amazon.com,
        petrm@nvidia.com
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
by Jakub Kicinski <kuba@kernel.org>:

On Tue,  8 Nov 2022 14:22:05 +0100 you wrote:
> From: Jiri Pirko <jiri@nvidia.com>
> 
> Patch #1 is just a dependency of patch #2, which is the actual fix.
> Patch #3 adds a small check that would uncover the original bug
> instantly.
> 
> Jiri Pirko (3):
>   net: introduce a helper to move notifier block to different namespace
>   net: devlink: move netdev notifier block to dest namespace during
>     reload
>   net: devlink: add WARN_ON to check return value of
>     unregister_netdevice_notifier_net() call
> 
> [...]

Here is the summary with links:
  - [net-next,v2,1/3] net: introduce a helper to move notifier block to different namespace
    https://git.kernel.org/netdev/net-next/c/3e52fba03a20
  - [net-next,v2,2/3] net: devlink: move netdev notifier block to dest namespace during reload
    https://git.kernel.org/netdev/net-next/c/15feb56e30ef
  - [net-next,v2,3/3] net: devlink: add WARN_ON to check return value of unregister_netdevice_notifier_net() call
    (no matching commit)

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


