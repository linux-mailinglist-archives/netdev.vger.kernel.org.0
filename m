Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF4BC6F2EC2
	for <lists+netdev@lfdr.de>; Mon,  1 May 2023 08:40:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232159AbjEAGkZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 May 2023 02:40:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229785AbjEAGkX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 May 2023 02:40:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4242218D
        for <netdev@vger.kernel.org>; Sun, 30 Apr 2023 23:40:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8B50161AC6
        for <netdev@vger.kernel.org>; Mon,  1 May 2023 06:40:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id DC008C4339C;
        Mon,  1 May 2023 06:40:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682923220;
        bh=uMg/JgurLjXcMkhZbbLe39LjFvRfz3bFd9J5+FJ0sts=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=LY3iAQ0vq92nk6EfdEf/duUY3WgifV+jhXy+V4USPwY0TzZHAFx5cfYXRFO7GLPOD
         yONGJgn3UWuKDG9+dhJABsWrl4yRVL4xeArdSR2ybqE3wfjJslZI9pV4kxZYuEfk1W
         du9PGYr441mghPZY+7NiDD9ZHOj68UoVJhGCoG1Tv/HgGrZVmwWHIKDxKVtLJLSOsb
         PVcGZiO2hmsYsabzw3frVEhdDkCvOdoDlr/comayhwybLOU0oknysKi8ygV+GynUze
         +XOwVH0G11EEZ4LAL7KXjh/cqsKGy721FE2P2ZHD3m65qf4Wq15sAjmY4Al6Grx9HP
         c07MNtQovYKuA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id B77D6E270D2;
        Mon,  1 May 2023 06:40:20 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] sfc: Fix module EEPROM reporting for QSFP modules
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168292322074.19130.16103072216460264336.git-patchwork-notify@kernel.org>
Date:   Mon, 01 May 2023 06:40:20 +0000
References: <168268161289.12077.6557674540677231817.stgit@xcbamoreton41x.xlnx.xilinx.com>
In-Reply-To: <168268161289.12077.6557674540677231817.stgit@xcbamoreton41x.xlnx.xilinx.com>
To:     Andy Moreton <andy.moreton@amd.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, ecree.xilinx@gmail.com,
        habetsm.xilinx@gmail.com
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (main)
by David S. Miller <davem@davemloft.net>:

On Fri, 28 Apr 2023 12:33:33 +0100 you wrote:
> The sfc driver does not report QSFP module EEPROM contents correctly
> as only the first page is fetched from hardware.
> 
> Commit 0e1a2a3e6e7d ("ethtool: Add SFF-8436 and SFF-8636 max EEPROM
> length definitions") added ETH_MODULE_SFF_8436_MAX_LEN for the overall
> size of the EEPROM info, so use that to report the full EEPROM contents.
> 
> [...]

Here is the summary with links:
  - [net] sfc: Fix module EEPROM reporting for QSFP modules
    https://git.kernel.org/netdev/net/c/281900a923d4

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


