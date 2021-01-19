Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6B6A2FC2EB
	for <lists+netdev@lfdr.de>; Tue, 19 Jan 2021 23:03:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727117AbhASWCA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jan 2021 17:02:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:48222 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728980AbhASWAs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 Jan 2021 17:00:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 03224230FE;
        Tue, 19 Jan 2021 22:00:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611093608;
        bh=vwzqmV+/JrI+lZ0C0St5fU/gOE1dmzOlc9Y/V0+Q0Q8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=IYRPZ+riiTpisTvAuU5S0j2reSlPiRcmNWY/n8+7OuOzsa/Gzflc/UhydOkfTBv94
         QkXIoJ/J+9iGP/wG8aEfLuWiCP3Y43QP5ILs9/hN63iwecr6MxFoKh38qDs49pZq61
         mmtkVJCR/tXQe4cf6ub8VgP6rZ3K/LMiWV5j4lFGw+kGu04/pGc2HOFtuMWLgcFWjL
         xrfHI9njG5WR9rI9pNtYqiEqn1x8/1G+ztDUWgIna1W4FgSPm6s2qGowjivwXLcnDo
         gKB1SJAe5wg87r8YuKtCmpnIXEUk82V7k2XWhVVozOOn28uJLVBRlNOtCZC1aNVjiq
         9vI6GW/inYOtA==
Received: from pdx-korg-docbuild-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-1.ci.codeaurora.org (Postfix) with ESMTP id DC15A604FC;
        Tue, 19 Jan 2021 22:00:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf] xsk: Clear pool even for inactive queues
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161109360789.28449.15236558642649089733.git-patchwork-notify@kernel.org>
Date:   Tue, 19 Jan 2021 22:00:07 +0000
References: <20210118160333.333439-1-maximmi@mellanox.com>
In-Reply-To: <20210118160333.333439-1-maximmi@mellanox.com>
To:     Maxim Mikityanskiy <maximmi@mellanox.com>
Cc:     magnus.karlsson@intel.com, bjorn.topel@intel.com,
        jonathan.lemon@gmail.com, ast@kernel.org, daniel@iogearbox.net,
        davem@davemloft.net, kuba@kernel.org, hawk@kernel.org,
        john.fastabend@gmail.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to bpf/bpf.git (refs/heads/master):

On Mon, 18 Jan 2021 18:03:33 +0200 you wrote:
> The number of queues can change by other means, rather than ethtool. For
> example, attaching an mqprio qdisc with num_tc > 1 leads to creating
> multiple sets of TX queues, which may be then destroyed when mqprio is
> deleted. If an AF_XDP socket is created while mqprio is active,
> dev->_tx[queue_id].pool will be filled, but then real_num_tx_queues may
> decrease with deletion of mqprio, which will mean that the pool won't be
> NULLed, and a further increase of the number of TX queues may expose a
> dangling pointer.
> 
> [...]

Here is the summary with links:
  - [bpf] xsk: Clear pool even for inactive queues
    https://git.kernel.org/bpf/bpf/c/b425e24a934e

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


