Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F0F235D20F
	for <lists+netdev@lfdr.de>; Mon, 12 Apr 2021 22:32:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343496AbhDLUaa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Apr 2021 16:30:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:48572 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239925AbhDLUa2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Apr 2021 16:30:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 644376128E;
        Mon, 12 Apr 2021 20:30:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618259410;
        bh=mWzm90WdsQZqhr25leANZXcrRy7fOSIdZLvo5nI04Ik=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=AZviaHeKo5a0PeQTkP9o8U5T0DaLtUqqfqfyQmv8i06g//6LSxnTKGgtimCxfUEBJ
         58O81VqsqNG5m/cGVO/JmKczPLDQ1yGGmSNFT76nbGmpFFeHhr7lo3if76o1p9haAP
         w72myQC5+dTdOwgqkuT6sXMJWX46xGr/l7SIoI8gLmuF6N59SCY3Ntx706ELdOVMZJ
         AE3XkLqPRcW/43sMa6MEOOrjP5lgM+GNCRFhjsu8dxVNyIC5V9EHvW0u3fhChUYSed
         Yn4FcUQa4bTywaOZAB4fW2QeUBRg8mI0PtYU5YxUqHXDiuw82ArnFptoJ95XIFR93v
         k8eRh5E9/+3sw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 58A1760CCF;
        Mon, 12 Apr 2021 20:30:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/2] Ensuring net sysctl isolation
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161825941035.5277.6853296655425077124.git-patchwork-notify@kernel.org>
Date:   Mon, 12 Apr 2021 20:30:10 +0000
References: <20210412042453.32168-1-Jonathon.Reinhart@gmail.com>
In-Reply-To: <20210412042453.32168-1-Jonathon.Reinhart@gmail.com>
To:     Jonathon Reinhart <jonathon.reinhart@gmail.com>
Cc:     netdev@vger.kernel.org, Jonathon.Reinhart@gmail.com, fw@strlen.de,
        pablo@netfilter.org, davem@davemloft.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Mon, 12 Apr 2021 00:24:51 -0400 you wrote:
> This patchset is the result of an audit of /proc/sys/net to prove that
> it is safe to be mouted read-write in a container when a net namespace
> is in use. See [1].
> 
> The first commit adds code to detect sysctls which are not netns-safe,
> and can "leak" changes to other net namespaces.
> 
> [...]

Here is the summary with links:
  - [net-next,1/2] net: Ensure net namespace isolation of sysctls
    https://git.kernel.org/netdev/net-next/c/31c4d2f160eb
  - [net-next,2/2] netfilter: conntrack: Make global sysctls readonly in non-init netns
    https://git.kernel.org/netdev/net-next/c/2671fa4dc010

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


