Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE1F74351F7
	for <lists+netdev@lfdr.de>; Wed, 20 Oct 2021 19:50:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230391AbhJTRwW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Oct 2021 13:52:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:56686 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229941AbhJTRwW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 Oct 2021 13:52:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 8A4B9611C7;
        Wed, 20 Oct 2021 17:50:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634752207;
        bh=2Dzzo6jTqKBd7t+CAO2c1sp4Zw4SZDoIQxwCiTE9Y5k=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=of4UImj3Oz9AZZ66Gm4PEvOxokqNUX1zcK5lEasmoSyg6hpt8CFvogS9YRNh/yCj8
         KoBus6sIejY7HaJz9ZtL4hPBiO0VJE+sxmgBM4k/KJOMIM2nOLhYrz7m+qINsmjM+8
         REABHxYt/bWlUJYbIjnmAysilAdfg3+c9Bhm2lQTNa/zlHY6C1O/WyRhxV92sF7KuO
         goNuvbX+DJHAzQ4XC6JJPemQO+Nqubj9kbyorkQfXuxclKjsyS1X34rCBgdwYICR0e
         kgQXZ011gj7MDy+7aa0ab7X9THv6yPkEpDY5WwQhEoSSTr4A6hRpelfoVB1A3PZ9Zk
         EK+MAV6LEAyjQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 7DD6B609E7;
        Wed, 20 Oct 2021 17:50:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH selftests/bpf] selftests/bpf: remove duplicate include in
 cgroup_helpers.c.
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163475220751.2338.1905298841088957803.git-patchwork-notify@kernel.org>
Date:   Wed, 20 Oct 2021 17:50:07 +0000
References: <20211019014549.970830-1-ran.jianping@zte.com.cn>
In-Reply-To: <20211019014549.970830-1-ran.jianping@zte.com.cn>
To:     Ran Jianping <cgel.zte@gmail.com>
Cc:     shuah@kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        linux-kselftest@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        ran.jianping@zte.com.cn, zealci@zte.com.cn
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to bpf/bpf-next.git (master)
by Andrii Nakryiko <andrii@kernel.org>:

On Tue, 19 Oct 2021 01:45:49 +0000 you wrote:
> From: Ran Jianping <ran.jianping@zte.com.cn>
> 
> unistd.h included in '/tools/testing/selftests/bpf/cgroup_helpers.c'
>  is duplicated.It is also included on the 14 line.
> 
> Reported-by: Zeal Robot <zealci@zte.com.cn>
> Signed-off-by: Ran Jianping <ran.jianping@zte.com.cn>
> 
> [...]

Here is the summary with links:
  - [selftests/bpf] selftests/bpf: remove duplicate include in cgroup_helpers.c.
    https://git.kernel.org/bpf/bpf-next/c/b8f49dce799f

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


