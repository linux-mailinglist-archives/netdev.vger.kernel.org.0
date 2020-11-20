Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5344E2BAC51
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 16:00:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727974AbgKTPAG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 10:00:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:45320 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727801AbgKTPAF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Nov 2020 10:00:05 -0500
Content-Type: text/plain; charset="utf-8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605884405;
        bh=BYiLKOVqkNAYoJTZqSUDLeWZewVr01bS2rylzop/SuM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=xQ0KBj1Kf+h81KTB7asTInYDP6htasrK0iUApPcOKhrODsiUn1QOxYUV1QpgoBd1D
         NKsYxHtsBbkh6eI7dC9J94U22GXW5NvLVKCjNQquH4yqRVpvDGFc7A7e4zTlMlzys7
         mqzwucccjrvwfmjdearkUFtlieDte/THJJxmRWi4=
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf] xsk: fix umem cleanup bug at socket destruct
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <160588440537.22328.3077027679091299701.git-patchwork-notify@kernel.org>
Date:   Fri, 20 Nov 2020 15:00:05 +0000
References: <1605873219-21629-1-git-send-email-magnus.karlsson@gmail.com>
In-Reply-To: <1605873219-21629-1-git-send-email-magnus.karlsson@gmail.com>
To:     Magnus Karlsson <magnus.karlsson@gmail.com>
Cc:     magnus.karlsson@intel.com, bjorn.topel@intel.com, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        jonathan.lemon@gmail.com, alardam@gmail.com, bpf@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to bpf/bpf.git (refs/heads/master):

On Fri, 20 Nov 2020 12:53:39 +0100 you wrote:
> From: Magnus Karlsson <magnus.karlsson@intel.com>
> 
> Fix a bug that is triggered when a partially setup socket is
> destroyed. For a fully setup socket, a socket that has been bound to a
> device, the cleanup of the umem is performed at the end of the buffer
> pool's cleanup work queue item. This has to be performed in a work
> queue, and not in RCU cleanup, as it is doing a vunmap that cannot
> execute in interrupt context. However, when a socket has only been
> partially set up so that a umem has been created but the buffer pool
> has not, the code erroneously directly calls the umem cleanup function
> instead of using a work queue, and this leads to a BUG_ON() in
> vunmap().
> 
> [...]

Here is the summary with links:
  - [bpf] xsk: fix umem cleanup bug at socket destruct
    https://git.kernel.org/bpf/bpf/c/537cf4e3cc2f

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


