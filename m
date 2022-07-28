Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C45675837BA
	for <lists+netdev@lfdr.de>; Thu, 28 Jul 2022 05:50:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234419AbiG1DuX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jul 2022 23:50:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233710AbiG1DuR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jul 2022 23:50:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABECC5F7C
        for <netdev@vger.kernel.org>; Wed, 27 Jul 2022 20:50:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5EF19B82322
        for <netdev@vger.kernel.org>; Thu, 28 Jul 2022 03:50:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 0457FC43142;
        Thu, 28 Jul 2022 03:50:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658980214;
        bh=fkErlQLa14CI4mX7a7Arsxf9NAEAlyikFocou9fuFgo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=jQjonutswB+29eyrqrksstAi8LAhk0lSipGcF2DWR9BmC6H9BfQzWwp+gq5JIJKqq
         WkxzDHP6wUvTM4X5CMJeUqevfUHgg5cQT+uRdNf/x9lCh5EaOxchIWirOE6O53WKRn
         pIrpg/GUWfV9edvHfv61HbbB4ywOr8Hg9hC1fqOnec1ujMODjiCpyB0gRY8goJZYze
         vx2mT4/7UqUzhhclDBaI+5rxfaM+Bb+PvLFCwSv/2AhUCPIBgXEuFH2UvfvYb8hJc/
         QbDtIdUJomOoNmUoj4YwYZ9nABOkUkxss9/qDahwYz8eCsscdK3Q8hMcj0Sh1Bm7vU
         w4E100ytjZKcA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id E568CC43142;
        Thu, 28 Jul 2022 03:50:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [patch net-next] net: devlink: remove redundant net_eq() check from
 sb_pool_get_dumpit()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165898021393.7628.2899392174792763993.git-patchwork-notify@kernel.org>
Date:   Thu, 28 Jul 2022 03:50:13 +0000
References: <20220727055912.568391-1-jiri@resnulli.us>
In-Reply-To: <20220727055912.568391-1-jiri@resnulli.us>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 27 Jul 2022 07:59:12 +0200 you wrote:
> From: Jiri Pirko <jiri@nvidia.com>
> 
> The net_eq() check is already performed inside
> devlinks_xa_for_each_registered_get() helper, so remove the redundant
> appearance.
> 
> Signed-off-by: Jiri Pirko <jiri@nvidia.com>
> 
> [...]

Here is the summary with links:
  - [net-next] net: devlink: remove redundant net_eq() check from sb_pool_get_dumpit()
    https://git.kernel.org/netdev/net-next/c/2bb88b2c4f73

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


