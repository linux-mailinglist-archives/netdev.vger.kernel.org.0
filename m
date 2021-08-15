Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1EA3C3EC7EA
	for <lists+netdev@lfdr.de>; Sun, 15 Aug 2021 09:20:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236104AbhHOHUg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Aug 2021 03:20:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:39586 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235569AbhHOHUf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 15 Aug 2021 03:20:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id A576060F46;
        Sun, 15 Aug 2021 07:20:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629012005;
        bh=px4gJ7CL9y75VBJLQBcicntlIWhiF9ODmHFBMOrrW3s=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=VdkCiD8IvQkMMGSHncBG0omzpt+8XBb7/oOz1aKreqrNluKq6EN0sxlcLjI7S07EQ
         lEUeeCNMf/y0vMbhfvQAAKQ4EjJKMeFKhf9YI7I7WE/eWFRYxtchxEjWZmfC//z3p6
         RAwNUmqVtgKfDBE5vAO1nzefS5TaTkkELUSyQDWmMKQAo5ovCfJfT0G5YD/ks3WVL9
         O/5Hewc5GW/mC8znU/cc2a6c6QkzZktiX1FCbQh+DmgNGmG8U4UgjB/0WaFbbGZCNA
         a68GIv1ndCNIH8Z2xMYJ0UWi/QoxvsbQUj0oiNQ680hpO9FWYI9FnzXpcpc3xJLfq4
         ahSYfkNfWnZtA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 98A7D60A69;
        Sun, 15 Aug 2021 07:20:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] samples: bpf: offwaketime: define MAX_ENTRIES instead of a
 magic number
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162901200562.26534.13140686068070887107.git-patchwork-notify@kernel.org>
Date:   Sun, 15 Aug 2021 07:20:05 +0000
References: <20210815065013.15411-1-falakreyaz@gmail.com>
In-Reply-To: <20210815065013.15411-1-falakreyaz@gmail.com>
To:     Muhammad Falak R Wani <falakreyaz@gmail.com>
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to bpf/bpf-next.git (refs/heads/master):

On Sun, 15 Aug 2021 12:20:13 +0530 you wrote:
> Define MAX_ENTRIES instead of using 10000 as a magic number in various
> places.
> 
> Signed-off-by: Muhammad Falak R Wani <falakreyaz@gmail.com>
> ---
>  samples/bpf/offwaketime_kern.c | 9 +++++----
>  1 file changed, 5 insertions(+), 4 deletions(-)

Here is the summary with links:
  - samples: bpf: offwaketime: define MAX_ENTRIES instead of a magic number
    https://git.kernel.org/bpf/bpf-next/c/d1bf7c4d5dea

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


