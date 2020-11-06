Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5F002A8E12
	for <lists+netdev@lfdr.de>; Fri,  6 Nov 2020 05:10:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726121AbgKFEKF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Nov 2020 23:10:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:36258 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725815AbgKFEKF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Nov 2020 23:10:05 -0500
Content-Type: text/plain; charset="utf-8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604635804;
        bh=2N15nhrJ/px2Es33oiwIARAAWGYkcSpYH9XUfOxdI6w=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=qFiT71mZZC1Hf8qQfG3dNfsPhzej3VABGAA/vknRqID+13WKqXrjT0qhTThzdsfH6
         mebsR8H8TIQfLHdcBUlLzUhK4OWnmXHK79amycx11V3y0d8bt/ldma0DrNGbvXEXjz
         QrZwDA4phGtZygygPT9hTkE1zWs3E9F60zmr5s4k=
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf v4] bpf: zero-fill re-used per-cpu map element
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <160463580428.4516.12981335406471843015.git-patchwork-notify@kernel.org>
Date:   Fri, 06 Nov 2020 04:10:04 +0000
References: <20201104112332.15191-1-david.verbeiren@tessares.net>
In-Reply-To: <20201104112332.15191-1-david.verbeiren@tessares.net>
To:     David Verbeiren <david.verbeiren@tessares.net>
Cc:     bpf@vger.kernel.org, andrii@kernel.org, netdev@vger.kernel.org,
        matthieu.baerts@tessares.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to bpf/bpf.git (refs/heads/master):

On Wed,  4 Nov 2020 12:23:32 +0100 you wrote:
> Zero-fill element values for all other cpus than current, just as
> when not using prealloc. This is the only way the bpf program can
> ensure known initial values for all cpus ('onallcpus' cannot be
> set when coming from the bpf program).
> 
> The scenario is: bpf program inserts some elements in a per-cpu
> map, then deletes some (or userspace does). When later adding
> new elements using bpf_map_update_elem(), the bpf program can
> only set the value of the new elements for the current cpu.
> When prealloc is enabled, previously deleted elements are re-used.
> Without the fix, values for other cpus remain whatever they were
> when the re-used entry was previously freed.
> 
> [...]

Here is the summary with links:
  - [bpf,v4] bpf: zero-fill re-used per-cpu map element
    https://git.kernel.org/bpf/bpf/c/d3bec0138bfb

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


