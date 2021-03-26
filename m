Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 199DF349D92
	for <lists+netdev@lfdr.de>; Fri, 26 Mar 2021 01:21:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229919AbhCZAUh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 20:20:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:34608 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229622AbhCZAUI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Mar 2021 20:20:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 5E5F0619F3;
        Fri, 26 Mar 2021 00:20:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616718008;
        bh=6MAG7pNC47FMD7KpUYm4iyUttVEOej8BPuwc0o5OXdc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=uvUc+3wcHpRjgr+hH/rDSku5/ggqrZs4K+4qYfRhqkFfz4kvl1gDaH2gDu5T9ITxF
         bAwd+E3qObBWgQKOCNEwbntK4c92g6RgjdtgFc4wdt71oSysuZbHMaNh4sxld0cu9Y
         onj95YwQkMhw8PiZM03FhiR0VWgHZcsXWLfoAtlyno4UH/haDDG0pWFZzM0QUhXY1S
         m9rGfTwZMy4mSbCqTl8JRhArAVZP2bryHYDw2pkOCj+qAc3OvhjZVS4adjkl2A3cvg
         wJTg4wDeFmij4zGEa51xhGDsA6QeACsKHLW/gTWtLih8FYEGedUIa36wPpp6EyaUkD
         5NTJ3SEZMnDDw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 4D1F96008E;
        Fri, 26 Mar 2021 00:20:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf-next] libbpf: constify few bpf_program getters
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161671800831.29431.6318209091580946935.git-patchwork-notify@kernel.org>
Date:   Fri, 26 Mar 2021 00:20:08 +0000
References: <20210324172941.2609884-1-andrii@kernel.org>
In-Reply-To: <20210324172941.2609884-1-andrii@kernel.org>
To:     Andrii Nakryiko <andrii@kernel.org>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, ast@fb.com,
        daniel@iogearbox.net, kernel-team@fb.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to bpf/bpf-next.git (refs/heads/master):

On Wed, 24 Mar 2021 10:29:41 -0700 you wrote:
> bpf_program__get_type() and bpf_program__get_expected_attach_type() shouldn't
> modify given bpf_program, so mark input parameter as const struct bpf_program.
> This eliminates unnecessary compilation warnings or explicit casts in user
> programs.
> 
> Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
> 
> [...]

Here is the summary with links:
  - [bpf-next] libbpf: constify few bpf_program getters
    https://git.kernel.org/bpf/bpf-next/c/a46410d5e497

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


