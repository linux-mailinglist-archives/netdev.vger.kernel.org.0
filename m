Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93E6A321DF4
	for <lists+netdev@lfdr.de>; Mon, 22 Feb 2021 18:21:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230218AbhBVRUs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Feb 2021 12:20:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:56908 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230017AbhBVRUr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Feb 2021 12:20:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 2B09464DE9;
        Mon, 22 Feb 2021 17:20:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614014407;
        bh=U/tYGCRQchrXDU5fvIsxpV66RzylpfJMvk2OJSrcUhQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=r2RWzn66fgmlA1i/f7B5ZEeyD+eylbdUvRj5xD4sSIFDXdovBNpb9T/QtJwN8NQM8
         +lRR39KaiLR+/f+fcfY2bBGzXwxFAgZ7VkzYHr3srNq528QGO4TnlRUaJ4SAjEKzvS
         v6bSHFnUZ1tZTjubXLq48mkqnRFflQFbIT025RPiaaCR3Ra5DYc3W72iRwVtQrpepY
         8NKVjvv/JWvy/M36nU71KU7etrLaJ86crjXv970SHQG+8F6ILyyqYWxFp9rVwlxrKa
         Bjd9NW+x7r7FemeKFSl7jksH0eTYqodUMuvP9Ucv/+7hxHWftP5UYbNS5n3YloU8Rt
         5fDqc2g4lglgw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 1F36A609D1;
        Mon, 22 Feb 2021 17:20:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [Patch bpf-next v2] bpf: clear percpu pointers in
 bpf_prog_clone_free()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161401440712.8774.15015105198478968097.git-patchwork-notify@kernel.org>
Date:   Mon, 22 Feb 2021 17:20:07 +0000
References: <20210218001647.71631-1-xiyou.wangcong@gmail.com>
In-Reply-To: <20210218001647.71631-1-xiyou.wangcong@gmail.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        cong.wang@bytedance.com, jiang.wang@bytedance.com, ast@kernel.org,
        daniel@iogearbox.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to bpf/bpf.git (refs/heads/master):

On Wed, 17 Feb 2021 16:16:47 -0800 you wrote:
> From: Cong Wang <cong.wang@bytedance.com>
> 
> Similar to bpf_prog_realloc(), bpf_prog_clone_create() also copies
> the percpu pointers, but the clone still shares them with the original
> prog, so we have to clear these two percpu pointers in
> bpf_prog_clone_free(). Otherwise we would get a double free:
> 
> [...]

Here is the summary with links:
  - [bpf-next,v2] bpf: clear percpu pointers in bpf_prog_clone_free()
    https://git.kernel.org/bpf/bpf/c/53f523f3052a

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


