Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5A7560C19B
	for <lists+netdev@lfdr.de>; Tue, 25 Oct 2022 04:20:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230286AbiJYCUV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Oct 2022 22:20:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230257AbiJYCUT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Oct 2022 22:20:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94FEC1C405
        for <netdev@vger.kernel.org>; Mon, 24 Oct 2022 19:20:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6C4D061704
        for <netdev@vger.kernel.org>; Tue, 25 Oct 2022 02:20:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C1FC0C433D7;
        Tue, 25 Oct 2022 02:20:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666664415;
        bh=cTEZ+LAIL6IoJkjJqC+/LId+8OvoxypYK7RmVSIJiLw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ei5F/+FgO+Lxs213zrjyTyGgQACd/paZOHzm1Cy18ULHN3S/vC0pQL4XdJBd+11YE
         ZveJqFmXTtzBcI5ELGjsX1yFCRjrGtox3ep1EqY319VOH506mUPvArdx3yRh15ch2O
         D9Te7jQRw/kYYkW2vMoszbJFw+T57JxdSjgLlB7U3BvbxvXxQgzyL01+Dwbn1oweJY
         x2YM8GMDjmdI2j5CV9w2J+WfjNn1pcQU1GoqeDw8XsmhXUwPzZx82wp30t3N/Up5FQ
         R62QyD30kdkVRKtwxng4I70HEkDrgUqk+p2E+lyGB6DBxXCbuVMX595+oDbQkHO/9a
         PRlitNTi05wLw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id A2F77C4166D;
        Tue, 25 Oct 2022 02:20:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] ethtool: eeprom: fix null-deref on genl_info in dump
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166666441566.15570.11093156073902761922.git-patchwork-notify@kernel.org>
Date:   Tue, 25 Oct 2022 02:20:15 +0000
References: <5575919a2efc74cd9ad64021880afc3805c54166.1666362167.git.lucien.xin@gmail.com>
In-Reply-To: <5575919a2efc74cd9ad64021880afc3805c54166.1666362167.git.lucien.xin@gmail.com>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        edumazet@google.com, pabeni@redhat.com, vladyslavt@nvidia.com
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Fri, 21 Oct 2022 10:22:47 -0400 you wrote:
> The similar fix as commit 46cdedf2a0fa ("ethtool: pse-pd: fix null-deref on
> genl_info in dump") is also needed for ethtool eeprom.
> 
> Fixes: c781ff12a2f3 ("ethtool: Allow network drivers to dump arbitrary EEPROM data")
> Signed-off-by: Xin Long <lucien.xin@gmail.com>
> ---
>  net/ethtool/eeprom.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Here is the summary with links:
  - [net] ethtool: eeprom: fix null-deref on genl_info in dump
    https://git.kernel.org/netdev/net/c/9d9effca9d7d

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


