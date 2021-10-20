Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08F9B434C45
	for <lists+netdev@lfdr.de>; Wed, 20 Oct 2021 15:40:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230178AbhJTNmW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Oct 2021 09:42:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:45492 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229639AbhJTNmV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 Oct 2021 09:42:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 2AC476128E;
        Wed, 20 Oct 2021 13:40:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634737207;
        bh=psDnb6swTAQZFyrUSsOqz3Z1+AjypfuNwCTPBV4oj8E=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Yga/wxKmbf7ckrRuWKlnm7QYPCxQEbZ3STj0+uGaaOssVUfdWsnkcYs0YRjc7AL//
         5JCFRCrQ7qPvKBLL4HTQBVtBw0D/t01/xy7O6o7B+3jfO7+trpElLZVS3t+HloZETN
         aV+TujZqCoQUsk+tYK0tA4EHGk4vrfRY/9kSXYtmcMf7nSGUk2nO9b28LwgKdNJ6dV
         1ZmFE7yLYYQIG3Jwd7xSqHo/peJCirLKZ1m7JElDZxOY6oUpUR6U7u97v4LQPntbk8
         7t1aTPafs8xv+N3GSx9IM65ga335tmlIknVsy/YSmveS1Q6cbK31m2kJRDU0bgmHRi
         EFnng1yb2lWug==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 1E55C609D1;
        Wed, 20 Oct 2021 13:40:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net-core: use netdev_* calls for kernel messages
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163473720711.8032.2122892195290628048.git-patchwork-notify@kernel.org>
Date:   Wed, 20 Oct 2021 13:40:07 +0000
References: <20211019164228.338538-1-jesse.brandeburg@intel.com>
In-Reply-To: <20211019164228.338538-1-jesse.brandeburg@intel.com>
To:     Jesse Brandeburg <jesse.brandeburg@intel.com>
Cc:     netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Tue, 19 Oct 2021 09:42:28 -0700 you wrote:
> While loading a driver and changing the number of queues, I noticed this
> message in the kernel log:
> 
> "[253489.070080] Number of in use tx queues changed invalidating tc
> mappings. Priority traffic classification disabled!"
> 
> But I had no idea what interface was being talked about because this
> message used pr_warn().
> 
> [...]

Here is the summary with links:
  - [net-next] net-core: use netdev_* calls for kernel messages
    https://git.kernel.org/netdev/net-next/c/5b92be649605

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


