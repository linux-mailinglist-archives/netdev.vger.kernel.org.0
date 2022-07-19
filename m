Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F51457916C
	for <lists+netdev@lfdr.de>; Tue, 19 Jul 2022 05:40:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234455AbiGSDk1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 23:40:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232912AbiGSDkS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 23:40:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D677F5F51
        for <netdev@vger.kernel.org>; Mon, 18 Jul 2022 20:40:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3EDE2614D4
        for <netdev@vger.kernel.org>; Tue, 19 Jul 2022 03:40:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8193AC341CB;
        Tue, 19 Jul 2022 03:40:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658202016;
        bh=+/9kI0Q5bp+LAV8s+rIg8XSwTB49g5vKNPcz+XyXoAk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=HSgUhZ1BRI5ygQCOmQzDLrq7uDvU9vri4OjJ5cAR5HZ4nCNlbTGfhO7A+gV8IKvMT
         P0vNrTAWKcsyGkN11A0ced1U6GlTHB4o3O/4GRn/LXafywB2+wsTD7a1Ulgpk5if2A
         OdjXFaWmSDRlGzmuwz8RHDjsnzoGqREQ5ev1NH2j/GvTu5OdYr/HJOX1MsgOh5mTcc
         F1p7HzDazk3Hr2QXwwNLsI2ZILne/B1+t+2lWM2UCxILYaEzCFY2pLAc2Fi8sr/tO6
         ddiOWhNTz/7mUd44YJ5zMC9WfRDtq29EnyhnUNlifrCNPwqEQscEUgPzSBov2uOor8
         40H5b+lKJE8aw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 6CBA1E451B0;
        Tue, 19 Jul 2022 03:40:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [patch net-next 0/9] devlink: prepare mlxsw and netdevsim for locked
 reload
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165820201644.29134.12601604897664566414.git-patchwork-notify@kernel.org>
Date:   Tue, 19 Jul 2022 03:40:16 +0000
References: <20220716110241.3390528-1-jiri@resnulli.us>
In-Reply-To: <20220716110241.3390528-1-jiri@resnulli.us>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com, mlxsw@nvidia.com,
        idosch@nvidia.com, saeedm@nvidia.com, moshe@nvidia.com,
        tariqt@nvidia.com
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Sat, 16 Jul 2022 13:02:32 +0200 you wrote:
> From: Jiri Pirko <jiri@nvidia.com>
> 
> This is preparation patchset to be able to eventually make a switch and
> make reload cmd to take devlink->lock as the other commands do.
> 
> This patchset is preparing 2 major users of devlink API - mlxsw and
> netdevsim. The sets of functions are similar, therefore taking care of
> both here.
> 
> [...]

Here is the summary with links:
  - [net-next,1/9] net: devlink: avoid false DEADLOCK warning reported by lockdep
    https://git.kernel.org/netdev/net-next/c/e26fde2f5bef
  - [net-next,2/9] net: devlink: add unlocked variants of devling_trap*() functions
    https://git.kernel.org/netdev/net-next/c/852e85a704c2
  - [net-next,3/9] net: devlink: add unlocked variants of devlink_resource*() functions
    https://git.kernel.org/netdev/net-next/c/c223d6a4bf6d
  - [net-next,4/9] net: devlink: add unlocked variants of devlink_sb*() functions
    https://git.kernel.org/netdev/net-next/c/755cfa69c4ec
  - [net-next,5/9] net: devlink: add unlocked variants of devlink_dpipe*() functions
    https://git.kernel.org/netdev/net-next/c/70a2ff89369d
  - [net-next,6/9] mlxsw: convert driver to use unlocked devlink API during init/fini
    https://git.kernel.org/netdev/net-next/c/72a4c8c94efa
  - [net-next,7/9] net: devlink: add unlocked variants of devlink_region_create/destroy() functions
    https://git.kernel.org/netdev/net-next/c/eb0e9fa2c635
  - [net-next,8/9] netdevsim: convert driver to use unlocked devlink API during init/fini
    https://git.kernel.org/netdev/net-next/c/012ec02ae441
  - [net-next,9/9] net: devlink: remove unused locked functions
    https://git.kernel.org/netdev/net-next/c/f655dacb59ac

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


