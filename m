Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC71B38B81E
	for <lists+netdev@lfdr.de>; Thu, 20 May 2021 22:10:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237467AbhETULc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 May 2021 16:11:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:56008 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234089AbhETULc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 20 May 2021 16:11:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 6939D61355;
        Thu, 20 May 2021 20:10:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621541410;
        bh=VoFOOd9J5TqvywW8m8wTbjIHtqHY1KUY6r19bEBdDc4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=tsV4DAoG/I7i5Eig7MqCnK3iX3ynh67DUBomgnms20a+CM1VGIr5rf0L2ovNtstaL
         ALluUC2txKzfDx6d6+NMVF7WrfO0ASyNz71ah6RKTwNSD320P4qob/gbz9Cz62fdy5
         msjko3yJ5tLqDrZIe8HX2zJsJ3c3cUsodT/ChNx7FEP9rjTIi4zGDpmdK3NOUAIvqc
         A6IoRqk/jgSxzIQoKWId1MbRrVzEzPXeaE3YsSQhUYxbY2z7YOoLY+kwzR1eSl0JHC
         07n9i9MhVs2in5EKNXWxNTKzrzZNzN0IdWT1w0vU6XvTSKYaUv6+WV8xiStYRIUPb1
         yyCSAy3tEbAGg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 57A6160A53;
        Thu, 20 May 2021 20:10:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 0/1] mISDN: Remove obsolete PIPELINE_DEBUG debugging
 information
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162154141035.20508.606432183655543086.git-patchwork-notify@kernel.org>
Date:   Thu, 20 May 2021 20:10:10 +0000
References: <20210520021412.8100-1-thunder.leizhen@huawei.com>
In-Reply-To: <20210520021412.8100-1-thunder.leizhen@huawei.com>
To:     Zhen Lei <thunder.leizhen@huawei.com>
Cc:     isdn@linux-pingi.de, leon@kernel.org, netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Thu, 20 May 2021 10:14:10 +0800 you wrote:
> v1 --> v2:
> Remove all obsolete PIPELINE_DEBUG debugging information.
> 
> v1:
> Mark local variable 'incomplete' as __maybe_unused in dsp_pipeline_build()
> 
> 
> [...]

Here is the summary with links:
  - [1/1] mISDN: Remove obsolete PIPELINE_DEBUG debugging information
    https://git.kernel.org/netdev/net-next/c/2682ea324b00

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


