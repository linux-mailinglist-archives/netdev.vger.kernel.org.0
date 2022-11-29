Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D18463C106
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 14:30:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231463AbiK2NaU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Nov 2022 08:30:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232201AbiK2NaT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Nov 2022 08:30:19 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54AAB627FB
        for <netdev@vger.kernel.org>; Tue, 29 Nov 2022 05:30:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 01562B8162D
        for <netdev@vger.kernel.org>; Tue, 29 Nov 2022 13:30:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 82D9AC433D7;
        Tue, 29 Nov 2022 13:30:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669728615;
        bh=K2QSbHVGXAJpQYWuxePpV3g4KK0X7iPT4p349xhsLZQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=NXO8g1hIak7d91nXZGn+MuwwaQg3P7DilZbnagVCVOhipXnDIYKNJd56foAjXipQC
         2uELAPaGAgtnXxQ+NythNfGh7ZyKSg5tb8SZ8Bccl3pxZCd9Wew/4ZqYb533HLofAZ
         I2WAKSZpAoKkvqFlyYa68KwKsUEt5l/aD99o/qW/rQa6PZf5v5qH7l1RSAVRP5X6v+
         elSmVb1sKxVAISjwfRNFbVwqrd2bwautmDKoynGYfEtf2JymIcrFCS99KtuZ4Ayg5m
         vpnvVr/KsqRkvE+i2ZMVllypOqyQAdxTfiu+823aIVNxFaU/DHVnPt9yi2N8/8Wv8Q
         pl523KiaC+f+Q==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 6A2B0E21EF5;
        Tue, 29 Nov 2022 13:30:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [patch net-next] net: devlink: add WARN_ON_ONCE to check return value
 of unregister_netdevice_notifier_net() call
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166972861543.11345.4124043536487758491.git-patchwork-notify@kernel.org>
Date:   Tue, 29 Nov 2022 13:30:15 +0000
References: <20221125100255.1786741-1-jiri@resnulli.us>
In-Reply-To: <20221125100255.1786741-1-jiri@resnulli.us>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com, idosch@idosch.org
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
by Paolo Abeni <pabeni@redhat.com>:

On Fri, 25 Nov 2022 11:02:55 +0100 you wrote:
> From: Jiri Pirko <jiri@nvidia.com>
> 
> As the return value is not 0 only in case there is no such notifier
> block registered, add a WARN_ON_ONCE() to yell about it.
> 
> Suggested-by: Ido Schimmel <idosch@idosch.org>
> Signed-off-by: Jiri Pirko <jiri@nvidia.com>
> 
> [...]

Here is the summary with links:
  - [net-next] net: devlink: add WARN_ON_ONCE to check return value of unregister_netdevice_notifier_net() call
    https://git.kernel.org/netdev/net-next/c/7666dbec7268

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


