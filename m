Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 36D2D6322E9
	for <lists+netdev@lfdr.de>; Mon, 21 Nov 2022 14:00:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229743AbiKUNAU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 08:00:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229649AbiKUNAT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 08:00:19 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04F1929353;
        Mon, 21 Nov 2022 05:00:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 96BB7611BB;
        Mon, 21 Nov 2022 13:00:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id EE274C433B5;
        Mon, 21 Nov 2022 13:00:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669035618;
        bh=Rh8fLXV9RmZgpWECeQbCx2qZ1f1QlXUBtz1A5qovBsw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=MFPtKE/S9o3c37QIQDbnrOMRi6CHXGZpQLohhlI6jfBD//AMIGXHGKnQ+ec4jN5y5
         35MJB4FcoiAHOm3cL6Ea5nZ0yMGtvzDfVMcBx/ibSCPmOqMZUnBopKKQcbQe3M1Wav
         C00Jg4RBjs6k44DeSoyqLmWyRwRUS8WYbbRf46f4aWeBIjJ613d3lEJDago+6oa0jl
         jhFji/L1nmdoDvFnrwDk0fv6lp7jAV18N+MsXE+c5ELv20t7CqG9oTNvUH8PRv1ni/
         ao7hhZT0mO2NSub2NWCu+bZVNz27vxqgsWkYBZLF8brLXGTRUj2JQUcz+YcpOk5Ges
         O75rP2b1gs/cQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id DAB59E29F3E;
        Mon, 21 Nov 2022 13:00:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 net-next] net: ethernet: renesas: rswitch: Fix MAC address
 info
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166903561789.31413.8881724644010450361.git-patchwork-notify@kernel.org>
Date:   Mon, 21 Nov 2022 13:00:17 +0000
References: <20221118002724.996108-1-yoshihiro.shimoda.uh@renesas.com>
In-Reply-To: <20221118002724.996108-1-yoshihiro.shimoda.uh@renesas.com>
To:     Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, error27@gmail.com,
        geert+renesas@glider.be, saeed@kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Fri, 18 Nov 2022 09:27:24 +0900 you wrote:
> Smatch detected the following warning.
> 
>     drivers/net/ethernet/renesas/rswitch.c:1717 rswitch_init() warn:
>     '%pM' cannot be followed by 'n'
> 
> The 'n' should be '\n'.
> 
> [...]

Here is the summary with links:
  - [v2,net-next] net: ethernet: renesas: rswitch: Fix MAC address info
    https://git.kernel.org/netdev/net-next/c/1cb507263290

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


