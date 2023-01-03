Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5F8C65BCFF
	for <lists+netdev@lfdr.de>; Tue,  3 Jan 2023 10:20:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237166AbjACJUX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Jan 2023 04:20:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237198AbjACJUU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Jan 2023 04:20:20 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D55CEE0AA;
        Tue,  3 Jan 2023 01:20:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E848F61194;
        Tue,  3 Jan 2023 09:20:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 4321BC433F1;
        Tue,  3 Jan 2023 09:20:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672737617;
        bh=SBX5BjaglMd9geNlMVmiFqVg49+qe0wrPdYdqPyyKec=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=lE0fHHXJORU9R54HRkjflM+XoRXSMyZ8ZNBWI2cA1rZ5P6MV/P5C+9EVuFKBHL4Zx
         t1bunovkV0znUgCkDddbNukBThr9HiS2Vs+V5azojF7el2xgNgjRfxbsDlkZRy3lkx
         WB4mrbiZCyFSsq5PI0YvAVYpCxMV/+SMvLSR9UEVrlLHfrRHYpbyK2LA1hlGnw2e83
         XLe6kTcEU17/SbkLxCodN+7HtmiI7jxWe5Qf6qBJiI4n+1N2DYyLY/H5D0TGcT67Va
         qUhN/HMAjjRICPHOETNbwohrOzDXcCzHaBOOMk55YtCSxObbeRtNJiEmSIvSqrLSOG
         o5JLi0c98szlQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 238D2E5724D;
        Tue,  3 Jan 2023 09:20:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v2] drivers/net/bonding/bond_3ad: return when there's no
 aggregator
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167273761714.18098.11508217081391735701.git-patchwork-notify@kernel.org>
Date:   Tue, 03 Jan 2023 09:20:17 +0000
References: <20230102095335.94249-1-d-tatianin@yandex-team.ru>
In-Reply-To: <20230102095335.94249-1-d-tatianin@yandex-team.ru>
To:     Daniil Tatianin <d-tatianin@yandex-team.ru>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        j.vosburgh@gmail.com, vfalico@gmail.com, andy@greyhouse.net,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
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
by David S. Miller <davem@davemloft.net>:

On Mon,  2 Jan 2023 12:53:35 +0300 you wrote:
> Otherwise we would dereference a NULL aggregator pointer when calling
> __set_agg_ports_ready on the line below.
> 
> Found by Linux Verification Center (linuxtesting.org) with the SVACE
> static analysis tool.
> 
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Signed-off-by: Daniil Tatianin <d-tatianin@yandex-team.ru>
> 
> [...]

Here is the summary with links:
  - [net,v2] drivers/net/bonding/bond_3ad: return when there's no aggregator
    https://git.kernel.org/netdev/net/c/9c807965483f

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


