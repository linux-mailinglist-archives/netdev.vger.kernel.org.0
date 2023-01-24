Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9FA64679078
	for <lists+netdev@lfdr.de>; Tue, 24 Jan 2023 06:51:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233118AbjAXFvQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Jan 2023 00:51:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233215AbjAXFvD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Jan 2023 00:51:03 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71E183D095;
        Mon, 23 Jan 2023 21:50:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 66AE0B8107A;
        Tue, 24 Jan 2023 05:50:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 1851FC433A7;
        Tue, 24 Jan 2023 05:50:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674539418;
        bh=L3tClp4Xmu5drhgyybMibMgwXpNBhWAEX8ptL+HRKsE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=P3VxJHGwq3Cj7JtQy5MYT116qnZD1oK1M4jtPA5q+JCkSGOA8ZwIUPG9x6Svd1kjR
         rXYG36VLgoKNkZXeZPEd1MAv3rB7ywuRFi0ENyiVSQD+bPKzARnJoGReXNxayTBUjX
         23mFJmerAizOe5m8iNKG0TvpKj6OQVwH+tmB+dvHHx2OsZQ95pGTKEBUSZIPh2eJix
         3hSKh8LJbOUYiLMhBsL1bd7VvD83FKeBI7QNOgrykq7rwAzbUJV4f5algZldDwMIyE
         y7lI+y+TURzbXeLhWEw529E8D8ytZOxm6yJXZRrXLmaXU0yliwMb6DMOGCgvAeif4H
         fi57yuzzlUkmg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id E631EF83ECF;
        Tue, 24 Jan 2023 05:50:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net] net: ethernet: adi: adin1110: Fix multicast offloading
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167453941793.4419.14633545413644092385.git-patchwork-notify@kernel.org>
Date:   Tue, 24 Jan 2023 05:50:17 +0000
References: <20230120090846.18172-1-alexandru.tachici@analog.com>
In-Reply-To: <20230120090846.18172-1-alexandru.tachici@analog.com>
To:     Alexandru Tachici <alexandru.tachici@analog.com>
Cc:     linux-kernel@vger.kernel.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, yangyingliang@huawei.com
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

On Fri, 20 Jan 2023 11:08:46 +0200 you wrote:
> Driver marked broadcast/multicast frames as offloaded incorrectly.
> Mark them as offloaded only when HW offloading has been enabled.
> This should happen only for ADIN2111 when both ports are bridged
> by the software.
> 
> Fixes: bc93e19d088b ("net: ethernet: adi: Add ADIN1110 support")
> Signed-off-by: Alexandru Tachici <alexandru.tachici@analog.com>
> 
> [...]

Here is the summary with links:
  - [net] net: ethernet: adi: adin1110: Fix multicast offloading
    https://git.kernel.org/netdev/net/c/8a4f6d023221

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


