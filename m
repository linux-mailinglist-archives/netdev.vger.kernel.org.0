Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A580F37ED15
	for <lists+netdev@lfdr.de>; Thu, 13 May 2021 00:38:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1385169AbhELUHE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 May 2021 16:07:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:39656 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1379557AbhELTlS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 12 May 2021 15:41:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 2A13C613D3;
        Wed, 12 May 2021 19:40:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620848410;
        bh=6zdrliYBXaQM5QAFokXBWFsRWuwG8CZV+fjPTf/R4fQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=r9zrG3ef3E6IlSkIh5a3Cm2Vp/ThQ/A5oyvlMAnG5f0DCiwZMbgCHAHmdRiAdbUDn
         lsHtR028EhPaSbSOz+NTkGzS0wVYfN63hiykiNV3oc+B8B9fZwdcuedxWYjjnqDRp5
         vYHo9yus6LkI/BNCMw6lGe+5ACYz8HItl33VXKroDAjT5bR0OIb9ko71R+uLPI3h50
         EzMU5LjYM3lpNRSjKFfscAwuzdv/vuusgHk8jdWE4QDBFRgQpK3a9b+sRyEpB9j/e+
         3ehajnJDwFDSdkou40c8WBU9FYpT7jbBZlhpwrb0AaLHZCLgEmtUsNpOphFpu4Lt6d
         bav/la5OTpw/Q==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 19EFC609D2;
        Wed, 12 May 2021 19:40:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] samples, bpf: suppress compiler warning
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162084841010.1089.2404998969995736892.git-patchwork-notify@kernel.org>
Date:   Wed, 12 May 2021 19:40:10 +0000
References: <20210511140429.89426-1-liuhailongg6@163.com>
In-Reply-To: <20210511140429.89426-1-liuhailongg6@163.com>
To:     Hailong Liu <liuhailongg6@163.com>
Cc:     ast@kernel.org, yhs@fb.com, daniel@iogearbox.net,
        andrii@kernel.org, kafai@fb.com, songliubraving@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org, liu.hailong6@zte.com.cn
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to bpf/bpf-next.git (refs/heads/master):

On Tue, 11 May 2021 22:04:29 +0800 you wrote:
> From: Hailong Liu <liu.hailong6@zte.com.cn>
> 
> While cross compiling on ARM32 , the casting from pointer to __u64 will
> cause warnings:
> 
> samples/bpf/task_fd_query_user.c: In function 'main':
> samples/bpf/task_fd_query_user.c:399:23: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]
> 399 | uprobe_file_offset = (__u64)main - (__u64)&__executable_start;
> | ^
> samples/bpf/task_fd_query_user.c:399:37: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]
> 399 | uprobe_file_offset = (__u64)main - (__u64)&__executable_start;
> 
> [...]

Here is the summary with links:
  - samples, bpf: suppress compiler warning
    https://git.kernel.org/bpf/bpf-next/c/0303ce17347a

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


