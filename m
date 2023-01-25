Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 584C367AF1A
	for <lists+netdev@lfdr.de>; Wed, 25 Jan 2023 11:00:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235481AbjAYKAZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Jan 2023 05:00:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235137AbjAYKAW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Jan 2023 05:00:22 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B49235399E
        for <netdev@vger.kernel.org>; Wed, 25 Jan 2023 02:00:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 63BC2B81914
        for <netdev@vger.kernel.org>; Wed, 25 Jan 2023 10:00:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 036F1C433A7;
        Wed, 25 Jan 2023 10:00:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674640819;
        bh=m1yeVX44eEJEmyINMHo8+SgegJjtr8iPUIESwpcV8TY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=I1gh2obOOzdgxXVrLcigRKXGmbDV5MRI2Tkzix+PBv96hI6MPwx1Rh8cLuJr9gJ66
         t2+qOFbDo/cb0XW0c6EIzqAyTqfY2m0ETlqGar39xKGUa2oAyccRhX3myxBG0idLqn
         xZ4Gzm7HDxP5Twa+2WRaz7Rie74PTTS6xDds0xOBLCBL05S+bQwJ5yXDseiLSr6asl
         MbZKMpOkJXtJyxUp5PvLq4vBizMDRunetjvj6ohJ/KP2shFLYBhPVs1sS9gR5AbEQZ
         IPfnfjdVxd6sEflWWxZcOM/BxnLOkbIjwNfOV5samvSsv+OsPbMWbpWZ14XukErNRE
         S/xxR1rYGMhng==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id D4100F83ED2;
        Wed, 25 Jan 2023 10:00:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: ethtool: fix NULL pointer dereference in
 pause_prepare_data()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167464081886.8627.17099467315603370622.git-patchwork-notify@kernel.org>
Date:   Wed, 25 Jan 2023 10:00:18 +0000
References: <20230124111328.3630437-1-vladimir.oltean@nxp.com>
In-Reply-To: <20230124111328.3630437-1-vladimir.oltean@nxp.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, mkubecek@suse.cz
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

On Tue, 24 Jan 2023 13:13:28 +0200 you wrote:
> In the following call path:
> 
> ethnl_default_dumpit
> -> ethnl_default_dump_one
>    -> ctx->ops->prepare_data
>       -> pause_prepare_data
> 
> [...]

Here is the summary with links:
  - [net-next] net: ethtool: fix NULL pointer dereference in pause_prepare_data()
    https://git.kernel.org/netdev/net-next/c/f5be9caf7bf0

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


