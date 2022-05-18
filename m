Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0AC4652BBF8
	for <lists+netdev@lfdr.de>; Wed, 18 May 2022 16:16:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237588AbiERNK0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 May 2022 09:10:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237532AbiERNKR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 May 2022 09:10:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73CB117B87D
        for <netdev@vger.kernel.org>; Wed, 18 May 2022 06:10:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0F975B8202B
        for <netdev@vger.kernel.org>; Wed, 18 May 2022 13:10:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A821AC385A5;
        Wed, 18 May 2022 13:10:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652879412;
        bh=oxW5QNha+y4EXPqyf5yBoOzLQk5W+AFJVVHUiIaIdbw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=sOS0shxviQc9szub8gXBb0U/YIaPNju9DiQKrLGGesInHRoOFgtNQxsdwhoXnFI0O
         Q+7oqGdm5NGku4OeY0AdM8GHnTbu1HUO1ehAQD0xdkpU0Y0kkp72WxMUzLCycfXANo
         88uzl+2czVWYl5MXGA2M6s3lgSP7fyfKCJKOBOE3eEP+U/jjwZpCaeukKsSOh9NaU1
         AY+LLjBQZqGEra1e8OochKehTW2J0k7ccES4MKyMrTaN1xH/g8mDEshWuVyASOw0Hz
         KHdTxtI0QK7UauNWPapRUR5R3jnWiLzuao9LqtYU22URRzb0M4xEm7DJs8zlAQp8+f
         +NL/ov2i898Yg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 8E9F9F0383D;
        Wed, 18 May 2022 13:10:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 1/1] igb: skip phy status check where unavailable
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165287941258.26952.11617819989897167847.git-patchwork-notify@kernel.org>
Date:   Wed, 18 May 2022 13:10:12 +0000
References: <20220517180105.1758335-1-anthony.l.nguyen@intel.com>
In-Reply-To: <20220517180105.1758335-1-anthony.l.nguyen@intel.com>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, kevmitch@arista.com, netdev@vger.kernel.org,
        gurucharanx.g@intel.com
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
by David S. Miller <davem@davemloft.net>:

On Tue, 17 May 2022 11:01:05 -0700 you wrote:
> From: Kevin Mitchell <kevmitch@arista.com>
> 
> igb_read_phy_reg() will silently return, leaving phy_data untouched, if
> hw->ops.read_reg isn't set. Depending on the uninitialized value of
> phy_data, this led to the phy status check either succeeding immediately
> or looping continuously for 2 seconds before emitting a noisy err-level
> timeout. This message went out to the console even though there was no
> actual problem.
> 
> [...]

Here is the summary with links:
  - [net,1/1] igb: skip phy status check where unavailable
    https://git.kernel.org/netdev/net/c/942d2ad5d2e0

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


