Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B87F24152F7
	for <lists+netdev@lfdr.de>; Wed, 22 Sep 2021 23:40:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238181AbhIVVli (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Sep 2021 17:41:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:47848 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238014AbhIVVlh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 Sep 2021 17:41:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id C673E611C6;
        Wed, 22 Sep 2021 21:40:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632346806;
        bh=kKspU6df3JFZlrUoGZBO3dnhk7nV8hFXBEK+CihxI/0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=LCE4XjtYA/sYn9J6akNRl/fK+6PifpXKTX0TiAvNIVQnSF2cKKEUGgyKbL6ScDEBu
         1JweOXMssljPNMeOyRw78vOLeGZrK/OIsKtA2ZEPq1yCcEsqqDD8AoX0nXEDuCWN63
         d6DmFWOaQUuihInderH4/D2lSq7fc3Pvwnl7AWNtr6kS1NoWcSpLv/3O/2ekhgwWyW
         lYm4UsNux6v/tC4kCM+cgVhmmkXjCX3daUHMDqb+bljPiN6Juw6z8c6pBwggBZh2g9
         DzBoy5x+oJ4ituDZzpw4MdUzpAaXULy0IszxL22k+eHDmmwhZiLD52S5XHbvR36yt+
         TUZsCVccODeog==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id B857D60A6B;
        Wed, 22 Sep 2021 21:40:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf] bpf: exempt CAP_BPF from checks against bpf_jit_limit
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163234680674.13903.12726490005358522005.git-patchwork-notify@kernel.org>
Date:   Wed, 22 Sep 2021 21:40:06 +0000
References: <20210922111153.19843-1-lmb@cloudflare.com>
In-Reply-To: <20210922111153.19843-1-lmb@cloudflare.com>
To:     Lorenz Bauer <lmb@cloudflare.com>
Cc:     ast@kernel.org, daniel@iogearbox.net, kernel-team@cloudflare.com,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to bpf/bpf.git (refs/heads/master):

On Wed, 22 Sep 2021 12:11:52 +0100 you wrote:
> When introducing CAP_BPF, bpf_jit_charge_modmem was not changed to
> treat programs with CAP_BPF as privileged for the purpose of JIT
> memory allocation. This means that a program without CAP_BPF can
> block a program with CAP_BPF from loading a program.
> 
> Fix this by checking bpf_capable in bpf_jit_charge_modmem.
> 
> [...]

Here is the summary with links:
  - [bpf] bpf: exempt CAP_BPF from checks against bpf_jit_limit
    https://git.kernel.org/bpf/bpf/c/7c3a00911b3d

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


