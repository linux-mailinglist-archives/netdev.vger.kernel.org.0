Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF7B337481F
	for <lists+netdev@lfdr.de>; Wed,  5 May 2021 20:40:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234909AbhEESlH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 May 2021 14:41:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:33366 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234140AbhEESlG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 5 May 2021 14:41:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 2F200613B3;
        Wed,  5 May 2021 18:40:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620240009;
        bh=BjYJCc7lzFekyNNJy8iOPGERwQdPkDMqpFTOpPDtrrE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=cXRyiqbXYpnDDCQcJrTtjw9LzDl7/MBfg3zr/I1mwXvll/N9XZDHGFtgukMOVABoe
         RZnAS2Njoz4MIveq4S+4jHAk+G8t2a2t24q4ObKZ+3xZYP4Qb4WrY/czOBTDcA34WR
         Rbac5aAFF/OYO2a9DcXRcWx/YcsHR4ygHlDwGBBfsVlAiuZceuHu8npR1QicgI1OZy
         wtX5FWSWulvyMwW7XvDG15IO9ag+ffqtH6ZX0c3RuixrgCEKoGw/OeEpPeLx9KF7DN
         ARE6ScJvGbBtX/7KXGYS7X353VtWmSuhWz3hTaJ8jnLJCVAAJLreV1OugrJahDC/dR
         wBKbqa2Dbg+xg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 1F333609E8;
        Wed,  5 May 2021 18:40:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] libbpf: Add NULL check to add_dummy_ksym_var
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162024000912.20107.7612377378659531833.git-patchwork-notify@kernel.org>
Date:   Wed, 05 May 2021 18:40:09 +0000
References: <20210504234910.976501-1-irogers@google.com>
In-Reply-To: <20210504234910.976501-1-irogers@google.com>
To:     Ian Rogers <irogers@google.com>
Cc:     ast@kernel.org, daniel@iogearbox.net, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        john.fastabend@gmail.com, kpsingh@chromium.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org, sdf@google.com, ppenkov@google.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to bpf/bpf.git (refs/heads/master):

On Tue,  4 May 2021 16:49:10 -0700 you wrote:
> Avoids a segv if btf isn't present. Seen on the call path
> __bpf_object__open calling bpf_object__collect_externs.
> 
> Fixes: 5bd022ec01f0 (libbpf: Support extern kernel function)
> Suggested-by: Stanislav Fomichev <sdf@google.com>
> Suggested-by: Petar Penkov <ppenkov@google.com>
> Signed-off-by: Ian Rogers <irogers@google.com>
> 
> [...]

Here is the summary with links:
  - libbpf: Add NULL check to add_dummy_ksym_var
    https://git.kernel.org/bpf/bpf/c/9683e5775c75

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


