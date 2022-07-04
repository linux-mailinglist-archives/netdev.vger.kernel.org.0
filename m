Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46122565113
	for <lists+netdev@lfdr.de>; Mon,  4 Jul 2022 11:40:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233867AbiGDJkY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Jul 2022 05:40:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233847AbiGDJkV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Jul 2022 05:40:21 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AED5E25E4;
        Mon,  4 Jul 2022 02:40:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 595C8B80E3F;
        Mon,  4 Jul 2022 09:40:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 07DF4C341CD;
        Mon,  4 Jul 2022 09:40:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656927615;
        bh=zftj9nKOAp79ayB0qyK8ahOTzbIYWv+GSDUKoSu/Ya0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=nK6yOvlZKhXdTgHmnayLtIfCEJlLlUwhjg21ghX3+Y8wqM8+saloSGHyJ/b87bIev
         28oVUXJLXtKVb31xn/AZbl/g1YlhNZhHFVcix2UBq63R5UnO3qNzO/wBFRO/BuAoyl
         L0x+0Fs5pc7mE7+lozSv6r9uy4s42X7bV2qSaZ2XFjFW5+4KlG27YdpylInL0ZSg4B
         3mPcDMGWlQFUSpz25AczsCkbJmbD4Kdsl1qHjYz+RwxR++kU3bzCZ1qG2ztFToB+nW
         h1espoX9DM2bAlf01AzmVRMLjJKgiRVcCEyGAdXJbRt9HGdfpPUoMLViKXNutyIPMG
         g3b0d4QEAcKiw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id DBB40E45BDE;
        Mon,  4 Jul 2022 09:40:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] selftest: net: bridge mdb add/del entry to port that
 is down
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165692761489.15750.11171118785999601605.git-patchwork-notify@kernel.org>
Date:   Mon, 04 Jul 2022 09:40:14 +0000
References: <20220701144350.2034989-1-casper.casan@gmail.com>
In-Reply-To: <20220701144350.2034989-1-casper.casan@gmail.com>
To:     Casper Andersson <casper.casan@gmail.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, shuah@kernel.org, netdev@vger.kernel.org,
        linux-kselftest@vger.kernel.org
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Fri,  1 Jul 2022 16:43:50 +0200 you wrote:
> Tests that permanent mdb entries can be added/deleted on ports with state down.
> 
> Signed-off-by: Casper Andersson <casper.casan@gmail.com>
> ---
> This feature was implemented recently and a selftest was suggested:
> https://lore.kernel.org/netdev/20220614063223.zvtrdrh7pbkv3b4v@wse-c0155/
> 
> [...]

Here is the summary with links:
  - [net-next] selftest: net: bridge mdb add/del entry to port that is down
    https://git.kernel.org/netdev/net-next/c/0d153dd208d4

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


