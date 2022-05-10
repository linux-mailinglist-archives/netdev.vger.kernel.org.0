Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 203755226C3
	for <lists+netdev@lfdr.de>; Wed, 11 May 2022 00:20:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235348AbiEJWUQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 May 2022 18:20:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232977AbiEJWUO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 May 2022 18:20:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47EAF286FF0
        for <netdev@vger.kernel.org>; Tue, 10 May 2022 15:20:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CF37A61803
        for <netdev@vger.kernel.org>; Tue, 10 May 2022 22:20:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 2C1DFC385CF;
        Tue, 10 May 2022 22:20:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652221212;
        bh=dbBNGNNBmpgIfzxuq/w1P7pqAjwwFYCSfUkB83hHgqE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=sprYl7N5NmyuYsDtyhwcq+6XZA2Qqm9eIteGPKnO0zlZsNEXxxBhKLwXMirMus7Wk
         FkUy13yFuHvKWOT5sTMWLYx1/d5BGbsBfD3QeMx9ScVKKKV7U8YKZf06aT9aqWHxTT
         MmY9pJl2Rbf41VU/Wr4tuaRvcwdFp8Us3cfVRs9QBzvcuUQ5AZ2jKpAH5DT9oqZsTh
         jVGq5MnbS0KwgShI626L7ZbMl6yxc3DtGB83hGMTQUFfdMWzt4726tIwtZTpPIr9py
         A60R6cBaCK14/RWl84L6ELhPuJNtKcRXPRPZfwuWCRL93LWYRCWrtVMY4VQj6l/cmC
         /UYGprabA9qXg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 08FBBF03932;
        Tue, 10 May 2022 22:20:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] nfp: flower: fix 'variable 'flow6' set but not used'
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165222121203.4698.8319947844766085293.git-patchwork-notify@kernel.org>
Date:   Tue, 10 May 2022 22:20:12 +0000
References: <20220510074845.41457-1-simon.horman@corigine.com>
In-Reply-To: <20220510074845.41457-1-simon.horman@corigine.com>
To:     Simon Horman <simon.horman@corigine.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        oss-drivers@corigine.com, louis.peens@corigine.com, lkp@intel.com
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Tue, 10 May 2022 09:48:45 +0200 you wrote:
> From: Louis Peens <louis.peens@corigine.com>
> 
> Kernel test robot reported an issue after a recent patch about an
> unused variable when CONFIG_IPV6 is disabled. Move the variable
> declaration to be inside the #ifdef, and do a bit more cleanup. There
> is no need to use a temporary ipv6 bool value, it is just checked once,
> remove the extra variable and just do the check directly.
> 
> [...]

Here is the summary with links:
  - [net-next] nfp: flower: fix 'variable 'flow6' set but not used'
    https://git.kernel.org/netdev/net-next/c/61004d1d4bad

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


