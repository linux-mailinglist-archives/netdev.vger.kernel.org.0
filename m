Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9508769417C
	for <lists+netdev@lfdr.de>; Mon, 13 Feb 2023 10:40:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229532AbjBMJk5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Feb 2023 04:40:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230043AbjBMJkz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Feb 2023 04:40:55 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A1C51BD1
        for <netdev@vger.kernel.org>; Mon, 13 Feb 2023 01:40:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EF02760F4B
        for <netdev@vger.kernel.org>; Mon, 13 Feb 2023 09:40:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 54089C433A7;
        Mon, 13 Feb 2023 09:40:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676281218;
        bh=j2rLLofvr8+PX95S/XnBDrWjdOqF+z6m/IV9T+hioXA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=myh1SaSpxJpQbUY4Aop0x9rClXloZnA66XTODcRtXjMjxzyM4aBM54mzxPvUOgchl
         8lgvVOQ9eSCNb1aAuB7PQ0KmzaPpioEwsNz2aT4Z+vxkSarsoFhDbF/ofLVjFapIeX
         qSbrfJ2uE6lBrL1/j52HVSCpGIvxs2PIklZRawSImBcPaz0pjuT8QcZ5oKucZSyfqM
         TJ9HxRWAKK8mmUTQFt/BP+Wn2N38GuIAWXxzI0OyTgJgoVZ6iJ6+faOvM8HOl4gmrA
         Wkof1Kh25Pl7TfyqhDHWQ1v7Y+yipf66B1FcUtSq/uOj1E4kNsY9PPAiSK7WeUscJk
         I0fnp+gR8ltyA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 43C69E68D2E;
        Mon, 13 Feb 2023 09:40:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] devlink: stop using NL_SET_ERR_MSG_MOD
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167628121827.7814.8131243149924275816.git-patchwork-notify@kernel.org>
Date:   Mon, 13 Feb 2023 09:40:18 +0000
References: <20230209222045.3832693-1-jacob.e.keller@intel.com>
In-Reply-To: <20230209222045.3832693-1-jacob.e.keller@intel.com>
To:     Jacob Keller <jacob.e.keller@intel.com>
Cc:     netdev@vger.kernel.org, jiri@resnulli.us, kuba@kernel.org
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Thu,  9 Feb 2023 14:20:45 -0800 you wrote:
> NL_SET_ERR_MSG_MOD inserts the KBUILD_MODNAME and a ':' before the actual
> extended error message. The devlink feature hasn't been able to be compiled
> as a module since commit f4b6bcc7002f ("net: devlink: turn devlink into a
> built-in").
> 
> Stop using NL_SET_ERR_MSG_MOD, and just use the base NL_SET_ERR_MSG. This
> aligns the extended error messages better with the NL_SET_ERR_MSG_ATTR
> messages as well.
> 
> [...]

Here is the summary with links:
  - [net-next] devlink: stop using NL_SET_ERR_MSG_MOD
    https://git.kernel.org/netdev/net-next/c/6d86bb0a5cb8

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


