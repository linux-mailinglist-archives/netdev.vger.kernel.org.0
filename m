Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4078733169D
	for <lists+netdev@lfdr.de>; Mon,  8 Mar 2021 19:50:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230446AbhCHSu0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Mar 2021 13:50:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:58932 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230490AbhCHSuX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Mar 2021 13:50:23 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 9BA2265194;
        Mon,  8 Mar 2021 18:50:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615229422;
        bh=rssix3XvXO4um6kczgo793VcQ3UozKJZ4MpeHy6RRAI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=gg5CE6r51AqzRMjnTPPllENj6ehAe+zf6rh6V7o800VytPtQe3ec3hmG9ozxWBlY8
         fsIU5U4R5TMqEy5an44T7vi4DD/FKDPkROBpt3WCV5dv/jCWKYOZVXI4duZs/g6E52
         Otq3jX/T7/iHr4ChrP8ymNcmfgH6uonSx2w2JLJiEi83rrXRF+V053zhyI1FxHh4xP
         IYdaru3WmpVkUsSlgQN73UwkDJE2p+y7SvIloRfPd1n8aub+XT79T95wZjWiAm+lqD
         FJcFB/SqK18XlwsezpvhC3lRS0bw2RXlDzx5kEueQG5VUuh+kuNySa9qNqQwSrAneF
         k6eUzRLgRjksw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 9751660952;
        Mon,  8 Mar 2021 18:50:22 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf-next] libbpf: fix INSTALL flag order
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161522942261.22364.5755505303228120302.git-patchwork-notify@kernel.org>
Date:   Mon, 08 Mar 2021 18:50:22 +0000
References: <20210306014127.850411-1-andrii@kernel.org>
In-Reply-To: <20210306014127.850411-1-andrii@kernel.org>
To:     Andrii Nakryiko <andrii@kernel.org>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, ast@fb.com,
        daniel@iogearbox.net, kernel-team@fb.com, gvalkov@abv.bg
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to bpf/bpf.git (refs/heads/master):

On Fri, 5 Mar 2021 17:41:26 -0800 you wrote:
> It was reported ([0]) that having optional -m flag between source and
> destination arguments in install command breaks bpftools cross-build on MacOS.
> Move -m to the front to fix this issue.
> 
>   [0] https://github.com/openwrt/openwrt/pull/3959
> 
> Fixes: 7110d80d53f4 ("libbpf: Makefile set specified permission mode")
> Reported-by: Georgi Valkov <gvalkov@abv.bg>
> Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
> 
> [...]

Here is the summary with links:
  - [bpf-next] libbpf: fix INSTALL flag order
    https://git.kernel.org/bpf/bpf/c/e7fb6465d4c8

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


