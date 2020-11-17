Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 063C42B70CD
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 22:20:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726597AbgKQVUH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Nov 2020 16:20:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:52084 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725747AbgKQVUH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Nov 2020 16:20:07 -0500
Content-Type: text/plain; charset="utf-8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605648006;
        bh=vvL09pv+PUiatC6tOx3OTbDVczBs3wy7hASTiHNjRog=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ORN69zNJQEp34S/2K26auXAYHGry1w8ZitiSGVyS8jjWLgeNjg25UsX/g3CbSSv/O
         8lP01tJ1N2bahs11zjalxpK/wYaAeJr2FMUIR0Caz9OhYs++7tLt0H9udhcj5r62OC
         Vk06PTjZu/Tk8uh0YMwT20KrzLUNVt8HRG/PzjJs=
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf-next v3 0/5] xsk: i40e: Tx performance improvements
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <160564800642.24253.1580711036123652762.git-patchwork-notify@kernel.org>
Date:   Tue, 17 Nov 2020 21:20:06 +0000
References: <1605525167-14450-1-git-send-email-magnus.karlsson@gmail.com>
In-Reply-To: <1605525167-14450-1-git-send-email-magnus.karlsson@gmail.com>
To:     Magnus Karlsson <magnus.karlsson@gmail.com>
Cc:     magnus.karlsson@intel.com, bjorn.topel@intel.com, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        jonathan.lemon@gmail.com, kuba@kernel.org,
        john.fastabend@gmail.com, bpf@vger.kernel.org,
        jeffrey.t.kirsher@intel.com, anthony.l.nguyen@intel.com,
        maciej.fijalkowski@intel.com, maciejromanfijalkowski@gmail.com,
        intel-wired-lan@lists.osuosl.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to bpf/bpf-next.git (refs/heads/master):

On Mon, 16 Nov 2020 12:12:42 +0100 you wrote:
> This patch set improves the performance of mainly the Tx processing of
> AF_XDP sockets. Though, patch 3 also improves the Rx path. All in all,
> this patch set improves the throughput of the l2fwd xdpsock
> application by around 11%. If we just take a look at Tx processing part,
> it is improved by 35% to 40%.
> 
> Hopefully the new batched Tx interfaces should be of value to other
> drivers implementing AF_XDP zero-copy support. But patch #3 is generic
> and will improve performance of all drivers when using AF_XDP sockets
> (under the premises explained in that patch).
> 
> [...]

Here is the summary with links:
  - [bpf-next,v3,1/5] samples/bpf: increment Tx stats at sending
    https://git.kernel.org/bpf/bpf-next/c/90da4b3208d3
  - [bpf-next,v3,2/5] i40e: remove unnecessary sw_ring access from xsk Tx
    https://git.kernel.org/bpf/bpf-next/c/f320460b9489
  - [bpf-next,v3,3/5] xsk: introduce padding between more ring pointers
    https://git.kernel.org/bpf/bpf-next/c/b8c7aece29bc
  - [bpf-next,v3,4/5] xsk: introduce batched Tx descriptor interfaces
    https://git.kernel.org/bpf/bpf-next/c/9349eb3a9d2a
  - [bpf-next,v3,5/5] i40e: use batched xsk Tx interfaces to increase performance
    https://git.kernel.org/bpf/bpf-next/c/3106c580fb7c

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


