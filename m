Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F261A474514
	for <lists+netdev@lfdr.de>; Tue, 14 Dec 2021 15:30:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232685AbhLNOaN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Dec 2021 09:30:13 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:45858 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234103AbhLNOaL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Dec 2021 09:30:11 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A3704B819E5;
        Tue, 14 Dec 2021 14:30:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 53ACEC34606;
        Tue, 14 Dec 2021 14:30:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639492209;
        bh=z3nAwornvisSfWmUSClWg6808IQkc5+O34bqOR2l6RU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=huJam9qkpsbovmNVu6Gc9hPtLUC9U4Ti0Jg9OtnVAlzWfrFzNnJPbtYTd+xAV0bq0
         ABu4kiMJfBRoHfrIysd5W1NxznU6QH9hlMcdgerqk7jA0Qm+t6R7TiH2Lzq/F4DQaU
         Y1i4XA/GjUsS0HtxNLWCeTKPxRU/5T3sLy9Pw/oqyLfrWUxwcUsflzBgj8lB/ykoOd
         BoxACvmYEPCmCdUeigDvSzKL2WQ2gxXcRnblCbTeSKgAdkuPbLr//OCVcGjVmkD7B0
         vSHAF1u3/NZi0AJt+5hUIKJlg9xHpcWeIKFB3ripDh8DjR7uQtW4GwpLLtlR2WJ4lT
         RQ5ukLYt37LqA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 3B9C660A4F;
        Tue, 14 Dec 2021 14:30:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf] xsk: do not sleep in poll() when need_wakeup set
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163949220923.29681.938478415723074268.git-patchwork-notify@kernel.org>
Date:   Tue, 14 Dec 2021 14:30:09 +0000
References: <20211214102607.7677-1-magnus.karlsson@gmail.com>
In-Reply-To: <20211214102607.7677-1-magnus.karlsson@gmail.com>
To:     Magnus Karlsson <magnus.karlsson@gmail.com>
Cc:     magnus.karlsson@intel.com, bjorn@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        maciej.fijalkowski@intel.com, jonathan.lemon@gmail.com,
        bpf@vger.kernel.org, keith.wiles@intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to bpf/bpf.git (master)
by Daniel Borkmann <daniel@iogearbox.net>:

On Tue, 14 Dec 2021 11:26:07 +0100 you wrote:
> From: Magnus Karlsson <magnus.karlsson@intel.com>
> 
> Do not sleep in poll() when the need_wakeup flag is set. When this
> flag is set, the application needs to explicitly wake up the driver
> with a syscall (poll, recvmsg, sendmsg, etc.) to guarantee that Rx
> and/or Tx processing will be processed promptly. But the current code
> in poll(), sleeps first then wakes up the driver. This means that no
> driver processing will occur (baring any interrupts) until the timeout
> has expired.
> 
> [...]

Here is the summary with links:
  - [bpf] xsk: do not sleep in poll() when need_wakeup set
    https://git.kernel.org/bpf/bpf/c/bd0687c18e63

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


