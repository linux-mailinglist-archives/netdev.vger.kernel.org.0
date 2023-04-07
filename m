Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB8536DA786
	for <lists+netdev@lfdr.de>; Fri,  7 Apr 2023 04:11:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240529AbjDGCLj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Apr 2023 22:11:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240482AbjDGCLU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Apr 2023 22:11:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD3C57EDC
        for <netdev@vger.kernel.org>; Thu,  6 Apr 2023 19:10:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 58853643AE
        for <netdev@vger.kernel.org>; Fri,  7 Apr 2023 02:10:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 9DC3DC433D2;
        Fri,  7 Apr 2023 02:10:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680833418;
        bh=b7KpgeV8wVCTL5YlTZT4/D+eMzHGTzoUzOpL19HtHbs=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=QkQHL3Vn474l0v90slqfBzfioSRoxQM15ROgcin2rg+AdZXA8v99Qy5BCt765WQpU
         K3hobS+Q4l5sSfzKpMVNIka8CRoQ6UPJHo8Dc/MWfntS++TzzdbPQM+nlLEccifKC9
         02JzzGfMuW+51V6ZOm93zIymc2stUCd9CsgMHzh16E4+yc1lXeuqCTKpWjAbM58b9q
         CBaJK/CUSHCvOwg7XWapQ8u7KMfG4mqYIE+G/4OLYe1yYZbkhn7d8cS1DqIjw92tbi
         mOo2kYPInHzr0lk6vovzLavkrB8GoO/KbDLYg0YfVxF9s4icCQ2l3frp27pNHA0w2L
         93ljlMd38RZSQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 7C471E4F154;
        Fri,  7 Apr 2023 02:10:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] selftests: forwarding: hw_stats_l3: Detect failure
 to install counters
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168083341850.14298.16040431856385703177.git-patchwork-notify@kernel.org>
Date:   Fri, 07 Apr 2023 02:10:18 +0000
References: <a86817961903cca5cb0aebf2b2a06294b8aa7dea.1680704172.git.petrm@nvidia.com>
In-Reply-To: <a86817961903cca5cb0aebf2b2a06294b8aa7dea.1680704172.git.petrm@nvidia.com>
To:     Petr Machata <petrm@nvidia.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org, shuah@kernel.org,
        danieller@nvidia.com, mlxsw@nvidia.com, liuhangbin@gmail.com
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 5 Apr 2023 16:25:12 +0200 you wrote:
> Running this test makes little sense if the enabled l3_stats are not
> actually reported as "used". This can signify a failure of a driver to
> install the necessary counters, or simply lack of support for enabling
> in-HW counters on a given netdevice. It is generally impossible to tell
> from the outside which it is. But more likely than not, if somebody is
> running this on veth pairs, they do not intend to actually test that a
> certain piece of HW can install in-HW counters for the veth. It is more
> likely they are e.g. running the test by mistake.
> 
> [...]

Here is the summary with links:
  - [net-next] selftests: forwarding: hw_stats_l3: Detect failure to install counters
    https://git.kernel.org/netdev/net-next/c/a9fda7a0b033

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


