Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B904D2D2E9F
	for <lists+netdev@lfdr.de>; Tue,  8 Dec 2020 16:51:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730020AbgLHPur (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Dec 2020 10:50:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:47168 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729587AbgLHPuq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 8 Dec 2020 10:50:46 -0500
Content-Type: text/plain; charset="utf-8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607442605;
        bh=zVgYIPzY0yswoQuz0fPF3OJWza4Epai6XbK6d8ox7MU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=pnw9KWRqB/2W3BmtprgApxMp25Hjca6fWuWjx5/6efPE/nYiG/mF5tSURtwR9KpEA
         pDHlEoSz2135f5KIAhA44eDA1bwFvi4sI7Qoo5gaGFwLjmKbIwwJGqB0Xik6o2Rq2A
         Bv0puKKSSHTLdTXZcQOTZE5ZP7osBzjCm0/RYxvMw5K/2y4jRY5FwqRyWZzZX73RjT
         zZXUsqtaxXho2AM47yKyJIblNjMgeq7Tbvb/xmNHdR1jr7gwaR0rV8nmr0xbf6QGRY
         /h42I5s854DuS6rkBfCMDjDI3CdHSr4u5K1sxfsTaOCDaAHP4blLKDuKiKnSGJNB98
         5ZEyTrBjb4jZQ==
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf] tools/bpftool: fix PID fetching with a lot of results
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <160744260580.27281.6558242327403068096.git-patchwork-notify@kernel.org>
Date:   Tue, 08 Dec 2020 15:50:05 +0000
References: <20201204232002.3589803-1-andrii@kernel.org>
In-Reply-To: <20201204232002.3589803-1-andrii@kernel.org>
To:     Andrii Nakryiko <andrii@kernel.org>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, ast@fb.com,
        daniel@iogearbox.net, kernel-team@fb.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to bpf/bpf.git (refs/heads/master):

On Fri, 4 Dec 2020 15:20:01 -0800 you wrote:
> In case of having so many PID results that they don't fit into a singe page
> (4096) bytes, bpftool will erroneously conclude that it got corrupted data due
> to 4096 not being a multiple of struct pid_iter_entry, so the last entry will
> be partially truncated. Fix this by sizing the buffer to fit exactly N entries
> with no truncation in the middle of record.
> 
> Fixes: d53dee3fe013 ("tools/bpftool: Show info for processes holding BPF map/prog/link/btf FDs")
> Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
> 
> [...]

Here is the summary with links:
  - [bpf] tools/bpftool: fix PID fetching with a lot of results
    https://git.kernel.org/bpf/bpf/c/932c60558109

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


