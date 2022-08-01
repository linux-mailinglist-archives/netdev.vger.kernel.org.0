Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26B72586849
	for <lists+netdev@lfdr.de>; Mon,  1 Aug 2022 13:40:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230433AbiHALkS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Aug 2022 07:40:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230428AbiHALkQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Aug 2022 07:40:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2153C1276B
        for <netdev@vger.kernel.org>; Mon,  1 Aug 2022 04:40:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B1D9B6123A
        for <netdev@vger.kernel.org>; Mon,  1 Aug 2022 11:40:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 09F44C433D7;
        Mon,  1 Aug 2022 11:40:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659354014;
        bh=7eajLU0+4ruWWnESz9sSCRw6F1t4V5hcgu9m1Dpyz64=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=qcKMFKXmAVbajYQhkWzHkyCl7C9uH9ieyjElw+py9XolX23SRaokZ0IfJW6HjOJdv
         hM/8G+6WiA4E9h9Chox54y0XZ1LECfBn1IqnCFjMTXOCgdtz84pDYV1f6v1UOdVRxW
         Zybjj6gI3rqlO7auDJMVU2SICpQoiJ57q47rV7CW+LW1MRincsIlj0cjLUnJuLux/A
         QuoVsQ56aThkc6rJw078Ii6ihREgV47RutAKNCWjWnwazodRrlCRXRtpvwlhYf3lcR
         RPpSshGDL41Jpq5kn7HmXgPxsYMVM0uaYzq6RD9s6DnbO0KuUfFX4EaSbckgZ5HRGK
         kM7GX7O6cmI+Q==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id E0648C43140;
        Mon,  1 Aug 2022 11:40:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [patch net-next 0/4] net: devlink: allow parallel commands on
 multiple devlinks
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165935401391.20802.2879221081624985623.git-patchwork-notify@kernel.org>
Date:   Mon, 01 Aug 2022 11:40:13 +0000
References: <20220729071038.983101-1-jiri@resnulli.us>
In-Reply-To: <20220729071038.983101-1-jiri@resnulli.us>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        idosch@nvidia.com, petrm@nvidia.com, pabeni@redhat.com,
        edumazet@google.com, mlxsw@nvidia.com, saeedm@nvidia.com,
        tariqt@nvidia.com, leon@kernel.org, moshe@nvidia.com
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Fri, 29 Jul 2022 09:10:34 +0200 you wrote:
> From: Jiri Pirko <jiri@nvidia.com>
> 
> Aim of this patchset is to remove devlink_mutex and eventually to enable
> parallel ops on devlink netlink interface.
> 
> Jiri Pirko (4):
>   net: devlink: introduce "unregistering" mark and use it during
>     devlinks iteration
>   net: devlink: convert reload command to take implicit devlink->lock
>   net: devlink: remove devlink_mutex
>   net: devlink: enable parallel ops on netlink interface
> 
> [...]

Here is the summary with links:
  - [net-next,1/4] net: devlink: introduce "unregistering" mark and use it during devlinks iteration
    https://git.kernel.org/netdev/net-next/c/c2368b19807a
  - [net-next,2/4] net: devlink: convert reload command to take implicit devlink->lock
    https://git.kernel.org/netdev/net-next/c/644a66c60f02
  - [net-next,3/4] net: devlink: remove devlink_mutex
    https://git.kernel.org/netdev/net-next/c/d3efc2a6a6d8
  - [net-next,4/4] net: devlink: enable parallel ops on netlink interface
    https://git.kernel.org/netdev/net-next/c/09b278462f16

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


