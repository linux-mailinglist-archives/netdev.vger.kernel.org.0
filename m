Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43F7D3ACE32
	for <lists+netdev@lfdr.de>; Fri, 18 Jun 2021 17:00:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234823AbhFRPCO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Jun 2021 11:02:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:48654 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234780AbhFRPCN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 18 Jun 2021 11:02:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 6DAF461260;
        Fri, 18 Jun 2021 15:00:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624028404;
        bh=9jZ2mXvTw/RWuE316jNx14yMB+zLHBQuldybPoxUN64=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ElnNkh4Wwc/IOhU9hGwm7cAmpFvMkgS4oOVm4KZQIzGoBhF18LfozsiQpFpR8z1tQ
         +lvyuyfQ0G2eKT7IBKoOKefyBW1hn+fq+D8amLts5IAerceO0l1+4Ird32LnkrkcP7
         LnmmcePmsyGxmaxA5K83jL7UQCY7Exny4RaygUXLlR9Gwp2F/4QfDDHMme/EL+hKi3
         qf82QKqQscaxovtIg8tvMcN1woS90hGJtpd6gscRwaq9vm75tDkeJNwGxOVqYVBS6X
         zeOLhgcudBsPMAyGBC6Oh9disFJPlPnLogPlrYgM9+31dcX12KFRye/qrqMgO3oJrQ
         QKjFWRjbLjXNQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 64A63608B8;
        Fri, 18 Jun 2021 15:00:04 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf] xsk: fix missing validation for skb and unaligned mode
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162402840440.8973.13278193576359189223.git-patchwork-notify@kernel.org>
Date:   Fri, 18 Jun 2021 15:00:04 +0000
References: <20210617092255.3487-1-magnus.karlsson@gmail.com>
In-Reply-To: <20210617092255.3487-1-magnus.karlsson@gmail.com>
To:     Magnus Karlsson <magnus.karlsson@gmail.com>
Cc:     magnus.karlsson@intel.com, bjorn@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        maciej.fijalkowski@intel.com, jonathan.lemon@gmail.com,
        bpf@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to bpf/bpf.git (refs/heads/master):

On Thu, 17 Jun 2021 11:22:55 +0200 you wrote:
> From: Magnus Karlsson <magnus.karlsson@intel.com>
> 
> Fix a missing validation of a Tx descriptor when executing in skb mode
> and the umem is in unaligned mode. A descriptor could point to a
> buffer straddling the end of the umem, thus effectively tricking the
> kernel to read outside the allowed umem region. This could lead to a
> kernel crash if that part of memory is not mapped.
> 
> [...]

Here is the summary with links:
  - [bpf] xsk: fix missing validation for skb and unaligned mode
    https://git.kernel.org/bpf/bpf/c/2f99619820c2

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


