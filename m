Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 963232FADAF
	for <lists+netdev@lfdr.de>; Tue, 19 Jan 2021 00:12:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390244AbhARXKu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jan 2021 18:10:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:44514 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732930AbhARXKs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 Jan 2021 18:10:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id E0DB222E03;
        Mon, 18 Jan 2021 23:10:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611011407;
        bh=CPvdEexz+aw0ObvjB0QJZEWdZ9rvW30T40PLralrCmA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=XIRAl8GBM06MS0p6pNZLzqRL6YK7ddUD/GS7qaqx3d/uNqnofeh+QEj2c8w4sAQvM
         4FcjB43K0gOaqnbDvHH8dWpAKooikflgc84cN0ta2JkspXZ8cWHDOhrY0fFYCCjtw+
         1l6ZI30mB6Qw96skxkEc8309bzM7W1LgIN9HDcD1V4Or5lbRUwdCDZgQpcp2s4JWNe
         b/NZ5peuVCLupL26hJv8XkjApcigyUhMYtesO9Fbh9PYFADiSGtq3vkEKkzmkYslLN
         VE/Ad7tJFvpLkMoC/yU7wpKxbohAqEmaNUElKRZF26e/r6a+QK0+SWtQnPbH5T3nhb
         ys7Ka+PYcpacw==
Received: from pdx-korg-docbuild-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-1.ci.codeaurora.org (Postfix) with ESMTP id D2B7D602DA;
        Mon, 18 Jan 2021 23:10:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH for bpf-next] docs: bpf: add minimal markup to address doc
 warning
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161101140785.10967.10936414258257855749.git-patchwork-notify@kernel.org>
Date:   Mon, 18 Jan 2021 23:10:07 +0000
References: <20210118080004.6367-1-lukas.bulwahn@gmail.com>
In-Reply-To: <20210118080004.6367-1-lukas.bulwahn@gmail.com>
To:     Lukas Bulwahn <lukas.bulwahn@gmail.com>
Cc:     jackmanb@google.com, ast@kernel.org, bpf@vger.kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, bjorn.topel@gmail.com,
        netdev@vger.kernel.org, mchehab+huawei@kernel.org,
        linux-doc@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to bpf/bpf-next.git (refs/heads/master):

On Mon, 18 Jan 2021 09:00:04 +0100 you wrote:
> Commit 91c960b00566 ("bpf: Rename BPF_XADD and prepare to encode other
> atomics in .imm") modified the BPF documentation, but missed some ReST
> markup.
> 
> Hence, make htmldocs warns on Documentation/networking/filter.rst:1053:
> 
>   WARNING: Inline emphasis start-string without end-string.
> 
> [...]

Here is the summary with links:
  - [for,bpf-next] docs: bpf: add minimal markup to address doc warning
    https://git.kernel.org/bpf/bpf-next/c/95204c9bfa48

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


