Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 919662F24F9
	for <lists+netdev@lfdr.de>; Tue, 12 Jan 2021 02:18:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405436AbhALAZd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 19:25:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:35256 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404158AbhAKXks (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 11 Jan 2021 18:40:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 9295622D08;
        Mon, 11 Jan 2021 23:40:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610408407;
        bh=GFVP0k0ArDEvlkJs6qoE68ZCxNtb7562UuE688TukKM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=nlotPYFPNyggtuCXMQav969vw7yPNUtnMuSMf6crGs7p9nw3v9HQgQ7Oyg3x5aYvC
         qBlVLIeF6qaV4Q79zsGoldb+ANyY7yv6HsYKyY0gUqJpLpOuv0I6JChbGKhdog11J0
         yXmpW52FGrf2EElA8LzFNMsxSnA9vCNAnmWUvyIvW9BPnEd7mQ8QBYhcRjnuxMyMs/
         2EGySfKjtLdMjBrfSm2FZVp1qDoj6wugbWqr46XgXH2KxMO5uVQr0mBZUUEQ0+IwGw
         0KpPbZUyHkbEsxXhDeem1lpUGLef/H1iG4Hj6sS6LrRDe7Y7tqNl6n8uBiBKUHF24t
         lt7zh7Z1ldU3g==
Received: from pdx-korg-docbuild-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-1.ci.codeaurora.org (Postfix) with ESMTP id 88C726025A;
        Mon, 11 Jan 2021 23:40:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] bpf: Prevent double bpf_prog_put call from
 bpf_tracing_prog_attach
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161040840755.14828.14759584484794908128.git-patchwork-notify@kernel.org>
Date:   Mon, 11 Jan 2021 23:40:07 +0000
References: <20210111191650.1241578-1-jolsa@kernel.org>
In-Reply-To: <20210111191650.1241578-1-jolsa@kernel.org>
To:     Jiri Olsa <jolsa@kernel.org>
Cc:     ast@kernel.org, daniel@iogearbox.net, andriin@fb.com,
        netdev@vger.kernel.org, bpf@vger.kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, john.fastabend@gmail.com,
        kpsingh@chromium.org, toke@redhat.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to bpf/bpf.git (refs/heads/master):

On Mon, 11 Jan 2021 20:16:50 +0100 you wrote:
> The bpf_tracing_prog_attach error path calls bpf_prog_put
> on prog, which causes refcount underflow when it's called
> from link_create function.
> 
>   link_create
>     prog = bpf_prog_get              <-- get
>     ...
>     tracing_bpf_link_attach(prog..
>       bpf_tracing_prog_attach(prog..
>         out_put_prog:
>           bpf_prog_put(prog);        <-- put
> 
> [...]

Here is the summary with links:
  - bpf: Prevent double bpf_prog_put call from bpf_tracing_prog_attach
    https://git.kernel.org/bpf/bpf/c/5541075a348b

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


