Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F1B4058B351
	for <lists+netdev@lfdr.de>; Sat,  6 Aug 2022 04:02:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241607AbiHFCA1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Aug 2022 22:00:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241351AbiHFCAW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Aug 2022 22:00:22 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCC652630
        for <netdev@vger.kernel.org>; Fri,  5 Aug 2022 19:00:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6CBFEB82AFF
        for <netdev@vger.kernel.org>; Sat,  6 Aug 2022 02:00:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D4143C433D7;
        Sat,  6 Aug 2022 02:00:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659751215;
        bh=a0nJN1Z2LY4MqrpGMMJcmR3w668oAGjpCxZli7nDf4M=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=D+m0zsxZMzvzi7J6lCDzfwaY9YAeg8A3mWipIYJKsgEhDjKJUciu2ONsJQHM6QeVT
         y4qfLgUq6H5Snj4mO44gOA4pmswWjiFxrichFDbacazhhWCdHp7HX/dCQUFXfRCFJt
         ZoWhzhrVaJmMkR9j4MsM9Hc9bYL8RcN6UHjJPqTyJu39p7aV4q1HPnwOJvyvqHcPrx
         MWJUeYhn02JonjxlpiqI+5LEkdju8wuKU4mLf0Rn80HqVJh7hAOFDLXL7BYiJYA33Q
         QYviGbYErbqmC3xyIpcNC2uWW2JxzzwnyIuDKaEq6IVnN9wTAv6UuzoN0aNOGo8goT
         rL06rUVL+SS/A==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id BA1B5C43144;
        Sat,  6 Aug 2022 02:00:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net v4 PATCH 0/4] Octeontx2 AF driver fixes for NPC
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165975121575.22545.100113476247529567.git-patchwork-notify@kernel.org>
Date:   Sat, 06 Aug 2022 02:00:15 +0000
References: <1659513255-28667-1-git-send-email-sbhatta@marvell.com>
In-Reply-To: <1659513255-28667-1-git-send-email-sbhatta@marvell.com>
To:     Subbaraya Sundeep <sbhatta@marvell.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, netdev@vger.kernel.org, sgoutham@marvell.com
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

This series was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 3 Aug 2022 13:24:11 +0530 you wrote:
> This patchset includes AF driver fixes wrt packet parser NPC.
> Following are the changes:
> 
> Patch 1: The parser nibble configuration must be same for
> TX and RX interfaces and if not fix up is applied. This fixup was
> applied only for default profile currently and it has been fixed
> to apply for all profiles.
> Patch 2: Firmware image may not be present all times in the kernel image
> and default profile is used mostly hence suppress the warning.
> Patch 3: This patch fixes a corner case where NIXLF is detached but
> without freeing its mcam entries which results in resource leak.
> Patch 4: SMAC is overlapped with DMAC mistakenly while installing
> rules based on SMAC. This patch fixes that.
> 
> [...]

Here is the summary with links:
  - [net,v4,1/4] octeontx2-af: Apply tx nibble fixup always
    https://git.kernel.org/netdev/net/c/dd1d1a8a6b29
  - [net,v4,2/4] octeontx2-af: suppress external profile loading warning
    https://git.kernel.org/netdev/net/c/cf2437626502
  - [net,v4,3/4] octeontx2-af: Fix mcam entry resource leak
    https://git.kernel.org/netdev/net/c/3f8fe40ab773
  - [net,v4,4/4] octeontx2-af: Fix key checking for source mac
    https://git.kernel.org/netdev/net/c/c3c290276927

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


