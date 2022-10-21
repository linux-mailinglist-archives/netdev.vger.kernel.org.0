Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2723606F38
	for <lists+netdev@lfdr.de>; Fri, 21 Oct 2022 07:11:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229983AbiJUFLM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Oct 2022 01:11:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229909AbiJUFKh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Oct 2022 01:10:37 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E564DBBCD;
        Thu, 20 Oct 2022 22:10:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D751AB82AD4;
        Fri, 21 Oct 2022 05:10:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8CEC8C433C1;
        Fri, 21 Oct 2022 05:10:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666329020;
        bh=uiS8E7UZqqx9dw/HCUIiU9iQ8Po61sH0v6P41uEyu1M=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=hgy+5XSWy435v2fDfR9qVLsF55x04HqwFshY9/BHVM/YjoKois8BLUfckBRFJC3xG
         mHC0u560hsl37pJpPPFxZRF3aS1psw+iVyyIzsNhZw7XVS7MFHri4Wwy5PRZVNKXiz
         U68DKoDj4Wvkak4zvg7caGDC/tyc2s6Hl6MowlWlN2ZL7HUSmv4obSZQEMcJYX6I/d
         hoE4/wnOvVWjW+8aozsSD8N5wJKeDWYL0lsftv0PzeGyZDGV6nluOdyJHohzZUiWwb
         XsAai3rnDzjnYGqdaqrqknalewwywORa4aYh77dRLfKQ/Q6b6vjy3DvUQnzrlbGMVj
         hdHooe3DST+1Q==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 71345E270E0;
        Fri, 21 Oct 2022 05:10:20 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/2] selftests: net: Fix problems in some drivers/net
 tests
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166632902045.25874.5012108937559240231.git-patchwork-notify@kernel.org>
Date:   Fri, 21 Oct 2022 05:10:20 +0000
References: <20221019091042.783786-1-bpoirier@nvidia.com>
In-Reply-To: <20221019091042.783786-1-bpoirier@nvidia.com>
To:     Benjamin Poirier <bpoirier@nvidia.com>
Cc:     netdev@vger.kernel.org, j.vosburgh@gmail.com, vfalico@gmail.com,
        andy@greyhouse.net, shuah@kernel.org, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com, olteanv@gmail.com,
        jiri@resnulli.us, davem@davemloft.net,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
        jtoppins@redhat.com, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 19 Oct 2022 18:10:40 +0900 you wrote:
> From: Benjamin Poirier <benjamin.poirier@gmail.com>
> 
> Fix two problems mostly introduced in commit bbb774d921e2 ("net: Add tests
> for bonding and team address list management").
> 
> Benjamin Poirier (2):
>   selftests: net: Fix cross-tree inclusion of scripts
>   selftests: net: Fix netdev name mismatch in cleanup
> 
> [...]

Here is the summary with links:
  - [net,1/2] selftests: net: Fix cross-tree inclusion of scripts
    https://git.kernel.org/netdev/net/c/ae108c48b5d2
  - [net,2/2] selftests: net: Fix netdev name mismatch in cleanup
    https://git.kernel.org/netdev/net/c/b2c0921b926c

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


