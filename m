Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF50E676317
	for <lists+netdev@lfdr.de>; Sat, 21 Jan 2023 03:30:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229645AbjAUCaT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Jan 2023 21:30:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229379AbjAUCaS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Jan 2023 21:30:18 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FA1959549;
        Fri, 20 Jan 2023 18:30:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 96AB262169;
        Sat, 21 Jan 2023 02:30:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id DBB40C4339B;
        Sat, 21 Jan 2023 02:30:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674268216;
        bh=baUSQQIhr3cO8U9cZGe0FbE8PLMx6yDnO2WLKToUXBc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=tws6a/AIPVYi8juMI1mhRkFagwRnhvkM+8OKLdXQ6UpOkhSH5OYmnSG/jC2oLR9tf
         V9mzYyhX8k0BJ3YT/Pc9mJtTLv0HtxZCCLJiEdp8n8lyl4i/rYRubuM5t9vHxexZRX
         qDXlVAuRkkzNIsqWNGlX992umZTARvC92rl3bFGe0SzWwmY4TDHdwmxn4OdoU5PYut
         5h/P6P0a8babAUGal3joOV9SihJ7AIV3+CMtojhaLU6bZSCpSlbuFs8MS8ZJk1NLw7
         +BIXUuO64Bw95iCywann/rI5XDy5Lgne/KTLDx63f9zBpCulyvOA0IyV3BH9lQqAjT
         5cIAuuiKNfGqg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id C2399C04E34;
        Sat, 21 Jan 2023 02:30:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v2] net: ethernet: renesas: rswitch: Fix ethernet-ports
 handling
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167426821679.2125.8741037695113963678.git-patchwork-notify@kernel.org>
Date:   Sat, 21 Jan 2023 02:30:16 +0000
References: <20230120001959.1059850-1-yoshihiro.shimoda.uh@renesas.com>
In-Reply-To: <20230120001959.1059850-1-yoshihiro.shimoda.uh@renesas.com>
To:     Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, jiri@nvidia.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Fri, 20 Jan 2023 09:19:59 +0900 you wrote:
> If one of ports in the ethernet-ports was disabled, this driver
> failed to probe all ports. So, fix it.
> 
> Fixes: 3590918b5d07 ("net: ethernet: renesas: Add support for "Ethernet Switch"")
> Signed-off-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
> Reviewed-by: Jiri Pirko <jiri@nvidia.com>
> 
> [...]

Here is the summary with links:
  - [net,v2] net: ethernet: renesas: rswitch: Fix ethernet-ports handling
    https://git.kernel.org/netdev/net/c/fd941bd64f07

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


