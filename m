Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0B2748A75E
	for <lists+netdev@lfdr.de>; Tue, 11 Jan 2022 06:30:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344108AbiAKFaL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jan 2022 00:30:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232010AbiAKFaL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jan 2022 00:30:11 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0F12C06173F
        for <netdev@vger.kernel.org>; Mon, 10 Jan 2022 21:30:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 60E73614B5
        for <netdev@vger.kernel.org>; Tue, 11 Jan 2022 05:30:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C230EC36AEF;
        Tue, 11 Jan 2022 05:30:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641879009;
        bh=BmZtOVbA2uaLSANpCoNkx9CUuLJ3nsTUUMgkWXZeEoE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=IjndxM7v1Edj8SZupIXMCywdA3G771SCNUCSRzXN9LG7W4/0zvyPs5WNVANHd0CXi
         QumbEtapI6mVMYMRl7dU+7nnhEAsYdZV2LjXcZkldzuE7JD8jeznP/K/XO+jPUTi//
         WQIhVmopYPOttTUX812Dd0DVhhMuO99AH7oSoskpVXoo2rFsaEXXuZiHjCVZwLQUoq
         Ebnjz9PyIecBQqDI7wnDBPYyhYzlDsL6eTQC2bf3aVRMAiXsUUitjjw302Y1LTbL/6
         0CBVIGwIFCNFnvVvTm9tJ6sBKvJafGZ2riJ22WtqtxUeWi1511J9gWgeTsrLYmsywL
         XP5iqAvWWUruQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id AAA56F6078D;
        Tue, 11 Jan 2022 05:30:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] Revert "net: vertexcom: default to disabled on
 kbuild"
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164187900969.26519.3947390893531180994.git-patchwork-notify@kernel.org>
Date:   Tue, 11 Jan 2022 05:30:09 +0000
References: <20220110205246.66298-1-saeed@kernel.org>
In-Reply-To: <20220110205246.66298-1-saeed@kernel.org>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        saeedm@nvidia.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Mon, 10 Jan 2022 12:52:46 -0800 you wrote:
> From: Saeed Mahameed <saeedm@nvidia.com>
> 
> This reverts commit 6bf950a8ff72920340dfdec93c18bd3f5f35de6a.
> 
> To align with other vendors, NET_VENDOR configs are supposed to be ON by
> default, while their drivers should default to OFF.
> 
> [...]

Here is the summary with links:
  - [net-next] Revert "net: vertexcom: default to disabled on kbuild"
    https://git.kernel.org/netdev/net/c/7d6019b602de

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


