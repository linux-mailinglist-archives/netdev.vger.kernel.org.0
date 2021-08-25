Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34E5A3F72D8
	for <lists+netdev@lfdr.de>; Wed, 25 Aug 2021 12:20:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239901AbhHYKV2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Aug 2021 06:21:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:36134 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238807AbhHYKUy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 25 Aug 2021 06:20:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 0515F61222;
        Wed, 25 Aug 2021 10:20:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629886809;
        bh=+yvj9WBCj5Yftb66ia8SReidOS9AML/FLWu14G/C9vg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=lIU1PaKx8hRdkd4Upg1egO2Yug78vMS8KThfDCG3QuyP0dr+zh1hIo8e6lQylcJ/9
         FWcfxLqxV7Gf9sCdcAkJ9QgkeXmfLfuvKsEjDmIIA91QNyGJ6cimly2jIwPpiFvwR1
         zVLo2UH8f/+aDpQkEOYPhkxawdYHKgNv49hsqyM6emOE9KlCOOa+vxHWcM5SFsGHxA
         vcSkt0A6Rclihye2a72XIA8QIjP/TL8tKhqbWIX0Y91anjOFLF7CcAqj/BjpxyC89X
         55FcZpWwsxpdYTvSui+rj3Jr0PBAmkOml9l9p1rw5sm2kV8WQM0c2Mdt+ywrQ2Xz+L
         HbXnZfpxv8v2A==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id ED26A60A14;
        Wed, 25 Aug 2021 10:20:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/7] mptcp: Optimize output options and add MP_FAIL
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162988680896.8958.11835123498453806538.git-patchwork-notify@kernel.org>
Date:   Wed, 25 Aug 2021 10:20:08 +0000
References: <20210824232619.136912-1-mathew.j.martineau@linux.intel.com>
In-Reply-To: <20210824232619.136912-1-mathew.j.martineau@linux.intel.com>
To:     Mat Martineau <mathew.j.martineau@linux.intel.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        matthieu.baerts@tessares.net, mptcp@lists.linux.dev,
        pabeni@redhat.com, geliangtang@xiaomi.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Tue, 24 Aug 2021 16:26:12 -0700 you wrote:
> This patch set contains two groups of changes that we've been testing in
> the MPTCP tree.
> 
> 
> The first optimizes the code path and data structure for populating
> MPTCP option headers when transmitting.
> 
> [...]

Here is the summary with links:
  - [net-next,1/7] mptcp: optimize out option generation
    https://git.kernel.org/netdev/net-next/c/1bff1e43a30e
  - [net-next,2/7] mptcp: shrink mptcp_out_options struct
    https://git.kernel.org/netdev/net-next/c/d7b269083786
  - [net-next,3/7] mptcp: MP_FAIL suboption sending
    https://git.kernel.org/netdev/net-next/c/c25aeb4e0953
  - [net-next,4/7] mptcp: MP_FAIL suboption receiving
    https://git.kernel.org/netdev/net-next/c/5580d41b758a
  - [net-next,5/7] mptcp: send out MP_FAIL when data checksum fails
    https://git.kernel.org/netdev/net-next/c/478d770008b0
  - [net-next,6/7] mptcp: add the mibs for MP_FAIL
    https://git.kernel.org/netdev/net-next/c/eb7f33654dc1
  - [net-next,7/7] selftests: mptcp: add MP_FAIL mibs check
    https://git.kernel.org/netdev/net-next/c/6bb3ab4913e9

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


