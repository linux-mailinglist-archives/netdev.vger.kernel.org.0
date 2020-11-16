Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3F8F2B53D3
	for <lists+netdev@lfdr.de>; Mon, 16 Nov 2020 22:30:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727571AbgKPVaF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 16:30:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:58074 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726035AbgKPVaF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Nov 2020 16:30:05 -0500
Content-Type: text/plain; charset="utf-8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605562204;
        bh=6joeIg2HubViP6CfKongiOuTb+0tYkeSRJnbkQNoBec=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=tc7I6VEODM4Cg5wIpvcmJSvxOKsBvN6+xrTunqE/eDnx9EVNji7WI8mk1KDX3R7ob
         RzLE6mVvieeIxBaLFiKYVNkXkvq2QdfQXH6jmYVvF8zjNBqFOvw4tR1PEXGfqrlHnT
         egGyDwJHiv7Wag2pTTnSYyaGuM+pm5swWDO2JTMQ=
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf] selftests/bpf: fix error return code in
 run_getsockopt_test()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <160556220472.15895.17339273833239307884.git-patchwork-notify@kernel.org>
Date:   Mon, 16 Nov 2020 21:30:04 +0000
References: <20201116101633.64627-1-wanghai38@huawei.com>
In-Reply-To: <20201116101633.64627-1-wanghai38@huawei.com>
To:     Wang Hai <wanghai38@huawei.com>
Cc:     shuah@kernel.org, ast@kernel.org, daniel@iogearbox.net,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com, andrii@kernel.org,
        john.fastabend@gmail.com, kpsingh@chromium.org, sdf@google.com,
        linux-kselftest@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to bpf/bpf.git (refs/heads/master):

On Mon, 16 Nov 2020 18:16:33 +0800 you wrote:
> Fix to return a negative error code from the error handling
> case instead of 0, as done elsewhere in this function.
> 
> Fixes: 65b4414a05eb ("selftests/bpf: add sockopt test that exercises BPF_F_ALLOW_MULTI")
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Wang Hai <wanghai38@huawei.com>
> 
> [...]

Here is the summary with links:
  - [bpf] selftests/bpf: fix error return code in run_getsockopt_test()
    https://git.kernel.org/bpf/bpf/c/2acc3c1bc8e9

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


