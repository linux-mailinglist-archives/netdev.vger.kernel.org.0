Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5585F3E0A8A
	for <lists+netdev@lfdr.de>; Thu,  5 Aug 2021 00:50:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234790AbhHDWuT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Aug 2021 18:50:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:34612 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229775AbhHDWuS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Aug 2021 18:50:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 767D661008;
        Wed,  4 Aug 2021 22:50:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628117405;
        bh=+cXz/rOvQSGw8tu/6sxQ4BKvpQtXXmU5qTfkfz7dRgQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=jDkGYmEjZlRgvZuQDCG/KUu5rN5iXERGT5vt0BzBW8G5BQklmDb2KaOC8zYAyl+W7
         N6XHoX+kzawuxum+kKivE3XGfyR+AxY5o3uUHeZ79qAQTzBCydyAVOp80mDhJnMq4h
         QvskNTDNTsaailWpZ4FqS5pc14TtZDM3j99W5BOMAF3IqNwbJFePWI9JBX4lsENqeD
         8MqzzYv7evr7zNw8NFSB4RU7Qn2JVYGV9l8flzjoOZ4Ej/jDkM7M/s9I17nK42tt8t
         ESF3RIJQWzNVYLDfBPiXiyFfxyLsGvfqn9UITLKWyyySNec7R9j1QlPmZqzE2GU1Ea
         vhVz7IQWQ1Nug==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 6832A609E2;
        Wed,  4 Aug 2021 22:50:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf-next] samples/bpf: xdp_redirect_cpu: Add mprog-disable to
 optstring.
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162811740542.13655.7097622991414354603.git-patchwork-notify@kernel.org>
Date:   Wed, 04 Aug 2021 22:50:05 +0000
References: <20210731005632.13228-1-matthew.cover@stackpath.com>
In-Reply-To: <20210731005632.13228-1-matthew.cover@stackpath.com>
To:     Matt Cover <werekraken@gmail.com>
Cc:     ast@kernel.org, daniel@iogearbox.net, davem@davemloft.net,
        jakub.kicinski@netronome.com, hawk@kernel.org,
        john.fastabend@gmail.com, andrii@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, kpsingh@kernel.org,
        lorenzo@kernel.org, matthew.cover@stackpath.com,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to bpf/bpf-next.git (refs/heads/master):

On Fri, 30 Jul 2021 17:56:32 -0700 you wrote:
> Commit ce4dade7f12a ("samples/bpf: xdp_redirect_cpu: Load a eBPF program
> on cpumap") added the following option, but missed adding it to optstring:
> - mprog-disable: disable loading XDP program on cpumap entries
> 
> Add the missing option character.
> 
> Fixes: ce4dade7f12a ("samples/bpf: xdp_redirect_cpu: Load a eBPF program on cpumap")
> Signed-off-by: Matthew Cover <matthew.cover@stackpath.com>
> 
> [...]

Here is the summary with links:
  - [bpf-next] samples/bpf: xdp_redirect_cpu: Add mprog-disable to optstring.
    https://git.kernel.org/bpf/bpf-next/c/34ad6d9d8c27

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


