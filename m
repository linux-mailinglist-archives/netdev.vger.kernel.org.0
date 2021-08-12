Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E20F53EA0DE
	for <lists+netdev@lfdr.de>; Thu, 12 Aug 2021 10:45:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235349AbhHLIqH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Aug 2021 04:46:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:56380 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235291AbhHLIqE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 12 Aug 2021 04:46:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id C8CC661059;
        Thu, 12 Aug 2021 08:45:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628757939;
        bh=GLIgwLmyw53y4DO/eKRwJRHkKOweimPFRD61u6YtxRM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=fcSHAhiX+Bhe4StcQy0u3xQOo1UsypUrRD1s6XKlfphidJ5wC9BSo57w0enw3fFxx
         JyHtDpwsAqvDPztUkqVAwqX+Zfba+T50i93+7axEs5R8FebBNqLETFJfWgSOsqfUsL
         8xrN8O/2u1WZBrN1nLZMmXZTpxe0jX4xXyGEW+tTQu8GHsWLC/iVGHZ5XQvJicfsvW
         PTVE6MCcCLVUUjoL0OuiT4jEIeJz05e5nSWdwArng8Sg46O6wgWnjDsvgnAkadoLrh
         TCxHqwublcwIyvGsjdRCriqexetvwX/7q2AI2y3U09WGltcQhfGb2CMPqn3isvL808
         W53Olg7/i0S4Q==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id BC6E0608FA;
        Thu, 12 Aug 2021 08:45:39 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net] Revert "tipc: Return the correct errno code"
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162875793976.15157.7114935762780231482.git-patchwork-notify@kernel.org>
Date:   Thu, 12 Aug 2021 08:45:39 +0000
References: <20210811012209.4589-1-hoang.h.le@dektech.com.au>
In-Reply-To: <20210811012209.4589-1-hoang.h.le@dektech.com.au>
To:     Hoang Le <hoang.h.le@dektech.com.au>
Cc:     jmaloy@redhat.com, maloy@donjonn.com, ying.xue@windriver.com,
        kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        zhengyongjun3@huawei.com, tung.q.nguyen@dektech.com.au,
        tipc-discussion@lists.sourceforge.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Wed, 11 Aug 2021 08:22:09 +0700 you wrote:
> This reverts commit 0efea3c649f0 because of:
> - The returning -ENOBUF error is fine on socket buffer allocation.
> - There is side effect in the calling path
> tipc_node_xmit()->tipc_link_xmit() when checking error code returning.
> 
> Fixes: 0efea3c649f0 ("tipc: Return the correct errno code")
> Acked-by: Jon Maloy <jmaloy@redhat.com>
> Signed-off-by: Hoang Le <hoang.h.le@dektech.com.au>
> 
> [...]

Here is the summary with links:
  - [net] Revert "tipc: Return the correct errno code"
    https://git.kernel.org/netdev/net/c/86704993e6a5

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


