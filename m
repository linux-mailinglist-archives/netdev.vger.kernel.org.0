Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4F1C34D961
	for <lists+netdev@lfdr.de>; Mon, 29 Mar 2021 23:01:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231340AbhC2VAi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Mar 2021 17:00:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:52736 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230381AbhC2VAJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Mar 2021 17:00:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 8EA5D619A0;
        Mon, 29 Mar 2021 21:00:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617051609;
        bh=yaSWQazrZiSwReDMeqdNMrlLNtC/prMzlW7hAAg4ZqM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=dcETECa/6abTTUkq+fSIrTM+6UTtM9hiYBMA026UHXdOgbXaK7Sq+KLmmUzIjEhy9
         gjEeX7OXeJUqBUfCbFRP2mSEU5MF2Gcbu4Lff1xz6DX9Ehmm321qFr81SfJQTn3H4r
         LjTqY93IzYciT/ERQAtbVUuw+E79t+HQrQmhkrOaEhTuzwDriNPQ3TGNYmt+CeFCcl
         kVCyUaZNtPl14LwHXuyXbfuoSGKWL6+JSAxGpRnqTuAryp6LEIzccoQihRO8TWkJ5E
         zd7nLZsiYR1kFDTb3qHaApQvo7wReAsvOl6rFlqVnmpnuafRO/UoaFqWfMML6WAar8
         YEy6DwHdk+XkA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 8A39560A48;
        Mon, 29 Mar 2021 21:00:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] Documentation: net: Document resilient next-hop
 groups
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161705160956.24062.16663173296559040830.git-patchwork-notify@kernel.org>
Date:   Mon, 29 Mar 2021 21:00:09 +0000
References: <1a164ec0cc63a0d9f5dd9a1df891b6302c8c2326.1617033033.git.petrm@nvidia.com>
In-Reply-To: <1a164ec0cc63a0d9f5dd9a1df891b6302c8c2326.1617033033.git.petrm@nvidia.com>
To:     Petr Machata <petrm@nvidia.com>
Cc:     netdev@vger.kernel.org, idosch@nvidia.com, dsahern@gmail.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Mon, 29 Mar 2021 17:57:31 +0200 you wrote:
> Add a document describing the principles behind resilient next-hop groups,
> and some notes about how to configure and offload them.
> 
> Suggested-by: David Ahern <dsahern@gmail.com>
> Signed-off-by: Petr Machata <petrm@nvidia.com>
> Reviewed-by: David Ahern <dsahern@gmail.com>
> 
> [...]

Here is the summary with links:
  - [net-next] Documentation: net: Document resilient next-hop groups
    https://git.kernel.org/netdev/net-next/c/87f2c6716f64

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


