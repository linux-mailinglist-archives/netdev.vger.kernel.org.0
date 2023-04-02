Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 58C7D6D37F1
	for <lists+netdev@lfdr.de>; Sun,  2 Apr 2023 14:50:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230377AbjDBMuW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Apr 2023 08:50:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbjDBMuV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Apr 2023 08:50:21 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CD1C1C1DF;
        Sun,  2 Apr 2023 05:50:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E318FB80E79;
        Sun,  2 Apr 2023 12:50:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A1FA9C433A4;
        Sun,  2 Apr 2023 12:50:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680439817;
        bh=VWD8AhzQ5saiH3TAQeVQN3iTIBGgdcpAgBHSgDg8uE0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=P+uF+XHpFGEBoYo1nLM0vZVF8MWEmioSKbHBUukOeYoQSW1uejwXr8uT2r3XPZcKx
         Wg7L9nM92pRtIv+wXT2cD1pLPfS1hid0a6vxrCmWJYhfaTd7suOpdXP1kNX+k1Wwr8
         DTqhPWZDXzDJ6AN3c1mOz8XWwtkGsMEal8hbhZ3/kCZUv1VZpubh65oJWM98obzEQM
         7r9Ysl7G9s0GkdDdPzjW8FQRrNr9Wk8o2x3Ts7ptgL5GLjwRWu/YSpCFeM933GBayN
         9lSnT9U5/F9Fx27Imfi8lh6vt9ws0IDa1GY0rWhvuLYLnXRYHg0fS1OMUI/LX5htFS
         2K+0US0oNmZTQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 7CEB3C73FE2;
        Sun,  2 Apr 2023 12:50:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: alteon: remove unused len variable
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168043981750.15620.10299883476369868511.git-patchwork-notify@kernel.org>
Date:   Sun, 02 Apr 2023 12:50:17 +0000
References: <20230331205545.1863496-1-trix@redhat.com>
In-Reply-To: <20230331205545.1863496-1-trix@redhat.com>
To:     Tom Rix <trix@redhat.com>
Cc:     jes@trained-monkey.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, nathan@kernel.org,
        ndesaulniers@google.com, linux-acenic@sunsite.dk,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        llvm@lists.linux.dev
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
by David S. Miller <davem@davemloft.net>:

On Fri, 31 Mar 2023 16:55:45 -0400 you wrote:
> clang with W=1 reports
> drivers/net/ethernet/alteon/acenic.c:2438:10: error: variable
>   'len' set but not used [-Werror,-Wunused-but-set-variable]
>                 int i, len = 0;
>                        ^
> This variable is not used so remove it.
> 
> [...]

Here is the summary with links:
  - net: alteon: remove unused len variable
    https://git.kernel.org/netdev/net-next/c/51aaa68222d6

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


