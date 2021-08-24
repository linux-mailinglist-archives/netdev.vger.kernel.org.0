Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCB6A3F5540
	for <lists+netdev@lfdr.de>; Tue, 24 Aug 2021 03:02:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235262AbhHXBCt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Aug 2021 21:02:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:54958 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234205AbhHXBAs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 23 Aug 2021 21:00:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 9E65B61360;
        Tue, 24 Aug 2021 01:00:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629766805;
        bh=C4C9EC93l2NXJl2GeHU5g8pzFErFS251vY0sAquMUPU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=EqdU3TM+GEiKCU1OdFUshE9+iCSL6kQ/mp83hR9rCTQTN6dI0Z2eR0k6+ikF/6B0b
         c29/ccAiTwvI579NDmqBHu8wkmuBx6pSeG/Uz/MHLpO4muc7BOsz3Qvrsc41Bjtr+t
         O6/4xgrBPmRPe0TGb7I2FjFtkSr924H6jXrHE56mDwL0REtNRrPX50CwXWi9Vxl4OS
         b5DtgloMD9lpY8n9SB0fyDfTnwKYyb2cNGsCRKOoeZ7RopNmWE1T2RWb8iqx1EMfSs
         lYHYAojIrDWVxF4F2YVqI/kwscJa6Lyry7CENt9Ry93izVX9318FMZDTbhqE9Cj3Dx
         zwauLB7LSpkEg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 90E376098C;
        Tue, 24 Aug 2021 01:00:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf-next v2 0/1] Refactor cgroup_bpf internals to use more
 specific attach_type
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162976680558.16394.17738506707111563389.git-patchwork-notify@kernel.org>
Date:   Tue, 24 Aug 2021 01:00:05 +0000
References: <20210819092420.1984861-1-davemarchevsky@fb.com>
In-Reply-To: <20210819092420.1984861-1-davemarchevsky@fb.com>
To:     Dave Marchevsky <davemarchevsky@fb.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, john.fastabend@gmail.com,
        kpsingh@kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to bpf/bpf-next.git (refs/heads/master):

On Thu, 19 Aug 2021 02:24:19 -0700 you wrote:
> The cgroup_bpf struct has a few arrays (effective, progs, and flags) of
> size MAX_BPF_ATTACH_TYPE. These are meant to separate progs by their
> attach type, currently represented by the bpf_attach_type enum.
> 
> There are some bpf_attach_type values which are not valid attach types
> for cgroup bpf programs. Programs with these attach types will never be
> handled by cgroup_bpf_{attach,detach} and thus will never be held in
> cgroup_bpf structs. Even if such programs did make it into their
> reserved slot in those arrays, they would never be executed.
> 
> [...]

Here is the summary with links:
  - [bpf-next,v2,1/1] bpf: migrate cgroup_bpf to internal cgroup_bpf_attach_type enum
    https://git.kernel.org/bpf/bpf-next/c/4ed589a27893

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


