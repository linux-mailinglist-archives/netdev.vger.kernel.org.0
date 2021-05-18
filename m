Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A20DC38811A
	for <lists+netdev@lfdr.de>; Tue, 18 May 2021 22:10:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236195AbhERULh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 May 2021 16:11:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:51624 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241268AbhERUL2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 18 May 2021 16:11:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id CF9AD6109F;
        Tue, 18 May 2021 20:10:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621368609;
        bh=SZ36Hy5Te3jHVc3bI2ZVgpRQzoaeNP06VB5M2NJjUpw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=SYApub6wIa9BpfUJ0jvQBainFRbnqqW7TbkXfxjWg8x8ZnnkGyNw+9ROz8KcZI0x8
         OYAc05Ovtev50CNiddhsGwxo4TsfQpGJiUDaZClGTuZYyAsX4cg4gi5LP6pvEQkreW
         YmTT5fuvD4/+PcAGeYk2i7hLO8WBi+WvvuwKZeU9NE+3T83UV0PVa6Dm8vc4KbqXTD
         ugEFFk6S86ohq5tIdIyZLg1zQMC00dj7JoBfJw4R68XJGtByuNUm8S+9r2JYlINBTW
         jVYmHm83ofJT4ByCfC3kWzQtMDsSpddt+gBBIE8Pz9Qf/i1doI6xYSyiMzemi3X4uZ
         pX904/qE3Cxfg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id C278660A4F;
        Tue, 18 May 2021 20:10:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf-next v3] bpf: check for BPF_F_ADJ_ROOM_FIXED_GSO when
 bpf_skb_change_proto
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162136860979.28642.16769179799041516109.git-patchwork-notify@kernel.org>
Date:   Tue, 18 May 2021 20:10:09 +0000
References: <1620804453-57566-1-git-send-email-dseok.yi@samsung.com>
In-Reply-To: <1620804453-57566-1-git-send-email-dseok.yi@samsung.com>
To:     Dongseok Yi <dseok.yi@samsung.com>
Cc:     willemdebruijn.kernel@gmail.com, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, john.fastabend@gmail.com,
        kpsingh@kernel.org, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to bpf/bpf-next.git (refs/heads/master):

On Wed, 12 May 2021 16:27:33 +0900 you wrote:
> In the forwarding path GRO -> BPF 6 to 4 -> GSO for TCP traffic, the
> coalesced packet payload can be > MSS, but < MSS + 20.
> bpf_skb_proto_6_to_4 will upgrade the MSS and it can be > the payload
> length. After then tcp_gso_segment checks for the payload length if it
> is <= MSS. The condition is causing the packet to be dropped.
> 
> tcp_gso_segment():
>         [...]
>         mss = skb_shinfo(skb)->gso_size;
>         if (unlikely(skb->len <= mss))
>                 goto out;
>         [...]
> 
> [...]

Here is the summary with links:
  - [bpf-next,v3] bpf: check for BPF_F_ADJ_ROOM_FIXED_GSO when bpf_skb_change_proto
    https://git.kernel.org/bpf/bpf-next/c/fa7b83bf3b15

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


