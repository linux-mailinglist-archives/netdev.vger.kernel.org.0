Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 832073AF5DE
	for <lists+netdev@lfdr.de>; Mon, 21 Jun 2021 21:10:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231432AbhFUTMW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Jun 2021 15:12:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:48270 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229940AbhFUTMS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 21 Jun 2021 15:12:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id D604661289;
        Mon, 21 Jun 2021 19:10:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624302603;
        bh=6dKSJ7GqGI+2JetkoATGlsMml88nEt1kRXZ9sGNzA7E=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=YQMkh+mFLX+SbPGUh26M4oNnt8a/83ABHiXN9QeO/p6/MhkRkcNG81J1MTxIbj8e1
         ViH2aOr2ug4NkChflR5U7wCl+6kZkrmKiNCsxe9rQyJohpeqEc8IZKtMllme54pFi9
         eCc+pwsZIJITCp0KOXEysA0sJS689Ez1/KO5rFRnUzyU4HvS7ZaCnDK9qEFB9jAQTj
         j/eng5oryn92F1Ttv64HReVZHfYMQaIv0nRc+/msBaA//Xala/r/cz2rU35zwaaub5
         Ei78gmimIwjBmbg2flZzlFUEulwPB6BwnJ0nxeDudhe9O4rO0zv/MOC/DGxafdOlYg
         bSQO8q4CVs++A==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id CA0DE609AC;
        Mon, 21 Jun 2021 19:10:03 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net/netif_receive_skb_core: Use migrate_disable()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162430260382.905.10508036837319379798.git-patchwork-notify@kernel.org>
Date:   Mon, 21 Jun 2021 19:10:03 +0000
References: <20210617073817.vioupupx2gohyrxr@linutronix.de>
In-Reply-To: <20210617073817.vioupupx2gohyrxr@linutronix.de>
To:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, davem@davemloft.net,
        kuba@kernel.org, ast@kernel.org, daniel@iogearbox.net,
        hawk@kernel.org, john.fastabend@gmail.com, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        kpsingh@kernel.org, tglx@linutronix.de, rostedt@goodmis.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Thu, 17 Jun 2021 09:38:17 +0200 you wrote:
> The preempt disable around do_xdp_generic() has been introduced in
> commit
>    bbbe211c295ff ("net: rcu lock and preempt disable missing around generic xdp")
> 
> For BPF it is enough to use migrate_disable() and the code was updated
> as it can be seen in commit
>    3c58482a382ba ("bpf: Provide bpf_prog_run_pin_on_cpu() helper")
> 
> [...]

Here is the summary with links:
  - [net-next] net/netif_receive_skb_core: Use migrate_disable()
    https://git.kernel.org/netdev/net/c/2b4cd14fd995

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


