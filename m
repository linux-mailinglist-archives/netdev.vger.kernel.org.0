Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1E374681A1
	for <lists+netdev@lfdr.de>; Sat,  4 Dec 2021 02:00:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383928AbhLDBDf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Dec 2021 20:03:35 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:35396 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344497AbhLDBDe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Dec 2021 20:03:34 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 29AC962D87
        for <netdev@vger.kernel.org>; Sat,  4 Dec 2021 01:00:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8455BC341C0;
        Sat,  4 Dec 2021 01:00:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638579609;
        bh=0k5lWC9al7vwaHQPBlrkD1L2QXFKTz5hoZQ/9gfsNwo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=CRzaHq+xZki3MZDcdyXtzuAViMFlAEWZ31oLTivbMPp9GEBfSUjj37bwqCx/da67e
         w8HEmnAlVN8SM295N+tZMMPUW4/mfKUUGb+WEy++uzGxrdeu0DCdCNLnFQiOzzQzbS
         SurCqM/UD9rLFdc0+cAQxU+Qr5NckFS0i9bDa6nTwUcI5FPfezDqAO+1HX5PVEoLce
         n7A84bDTTPZK71Qd5mAxRTLETJhKk2v9OjIM5BJfr5w9SbxKXOVRd7WbK4uFea7TVE
         kL02QBxF2G6z8UMvxN98E6KMlU6Bokwrvwpuqm1C3MKBHGVHvUv//7qwSjtKRhXz+0
         bZH8ZifxNT2XQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 5AFD960A90;
        Sat,  4 Dec 2021 01:00:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 net] qede: validate non LSO skb length
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163857960936.5665.16947442289939867589.git-patchwork-notify@kernel.org>
Date:   Sat, 04 Dec 2021 01:00:09 +0000
References: <20211203174413.13090-1-manishc@marvell.com>
In-Reply-To: <20211203174413.13090-1-manishc@marvell.com>
To:     Manish Chopra <manishc@marvell.com>
Cc:     kuba@kernel.org, netdev@vger.kernel.org, aelior@marvell.com,
        palok@marvell.com, pkushwaha@marvell.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Fri, 3 Dec 2021 09:44:13 -0800 you wrote:
> Although it is unlikely that stack could transmit a non LSO
> skb with length > MTU, however in some cases or environment such
> occurrences actually resulted into firmware asserts due to packet
> length being greater than the max supported by the device (~9700B).
> 
> This patch adds the safeguard for such odd cases to avoid firmware
> asserts.
> 
> [...]

Here is the summary with links:
  - [v2,net] qede: validate non LSO skb length
    https://git.kernel.org/netdev/net/c/8e227b198a55

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


