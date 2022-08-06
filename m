Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 05C4058B359
	for <lists+netdev@lfdr.de>; Sat,  6 Aug 2022 04:10:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241626AbiHFCKQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Aug 2022 22:10:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241589AbiHFCKP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Aug 2022 22:10:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6C34111F
        for <netdev@vger.kernel.org>; Fri,  5 Aug 2022 19:10:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3DF5A615CC
        for <netdev@vger.kernel.org>; Sat,  6 Aug 2022 02:10:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 80D1EC43470;
        Sat,  6 Aug 2022 02:10:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659751813;
        bh=50f0Nxxe3AjQgiUpGiT2LjMfc7156SxTzOkGphbVcDk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=R70Ws4nRNKywstYHZigifKu9RpM2xRsUyRY41tTnQ7Hu48kJbwRjVXx9yy7EczB3h
         Ke8oCfA5MtGmhGEBhdEKYbr2R3l4EntwcQ6ocVodWAuPKfs+4FpM2YAwLQoX+JvUMH
         +Jd8Oo+hIS3LsfYe0bA3ldgrLWWFclhZdzogX6aamxcmqZ3wWMO0dOWAeWfeRMuS+I
         XktvACPlOozDM19xWHCmKEj3KX5jJgAV+dS+h6+n6r5P+9vruXxjU+eNSFdw45Jeas
         lZNLZd2UcFEe+g665q+S51Bd7wcj5gatEzb+jA08rTmVy8yauCgius1Hz33I55dhzx
         L6X691z6aB+FA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 6709BC43143;
        Sat,  6 Aug 2022 02:10:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] eth: fix the help in Wangxun's Kconfig
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165975181341.26957.8441008587032087995.git-patchwork-notify@kernel.org>
Date:   Sat, 06 Aug 2022 02:10:13 +0000
References: <20220804182641.1442000-1-kuba@kernel.org>
In-Reply-To: <20220804182641.1442000-1-kuba@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, ingo@hannover.ccc.de, jiawenwu@trustnetic.com
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

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Thu,  4 Aug 2022 11:26:41 -0700 you wrote:
> The text was copy&pasted from Intel, adjust it to say Wangxun.
> 
> Reported-by: Ingo Saitz <ingo@hannover.ccc.de>
> Fixes: 3ce7547e5b71 ("net: txgbe: Add build support for txgbe")
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
> CC: jiawenwu@trustnetic.com
> 
> [...]

Here is the summary with links:
  - [net] eth: fix the help in Wangxun's Kconfig
    https://git.kernel.org/netdev/net/c/049d5d9890e9

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


