Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BEDFC35D67D
	for <lists+netdev@lfdr.de>; Tue, 13 Apr 2021 06:38:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229695AbhDMEac (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Apr 2021 00:30:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:60308 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229882AbhDMEa2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 13 Apr 2021 00:30:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 5A82F613AB;
        Tue, 13 Apr 2021 04:30:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618288209;
        bh=/0ir3Fkbfp7lsymYhOzAfQexZTLRCwhmQw1Ofn5CGeA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=CEMnUWIORiE9xKtA8bSVZ3ax/NLGbYjb5H8FiFgNn5PiiRMGiJr1aIS2vVlvOG53R
         j/7chU7nBmcpZgU9n7Zi/sc9M95eSR5QoRySLBhn6xJJ4NjQhfdyUedXqMpvcqdKGM
         DjBPJ3FP1iRi2vGxLgUCKbdwFJQEhdy0LNRj/UPK6L/zrRn9pyk0nDfvxFZlhTUOls
         k0OzDo1TkYbHPToAODEE5Sr17ir2f8W5KepvebhzL0k6Un2rtsXjX/CSRPtEtfT4hl
         aHJn1MgtGwxytA17Fmu5PG9WE8g6gd6V9Hv9o2gOZijROKIXlJmjFe/CA7ty4ZGEFl
         aVcTQIWxqWdsg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 45B4260CCF;
        Tue, 13 Apr 2021 04:30:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf-next v2] libbpf: clarify flags in ringbuf helpers
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161828820927.6788.4472259651967052992.git-patchwork-notify@kernel.org>
Date:   Tue, 13 Apr 2021 04:30:09 +0000
References: <20210412192434.944343-1-pctammela@mojatatu.com>
In-Reply-To: <20210412192434.944343-1-pctammela@mojatatu.com>
To:     Pedro Tammela <pctammela@gmail.com>
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, joe@cilium.io,
        quentin@isovalent.com, netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org, pctammela@mojatatu.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to bpf/bpf-next.git (refs/heads/master):

On Mon, 12 Apr 2021 16:24:32 -0300 you wrote:
> In 'bpf_ringbuf_reserve()' we require the flag to '0' at the moment.
> 
> For 'bpf_ringbuf_{discard,submit,output}' a flag of '0' might send a
> notification to the process if needed.
> 
> Signed-off-by: Pedro Tammela <pctammela@mojatatu.com>
> 
> [...]

Here is the summary with links:
  - [bpf-next,v2] libbpf: clarify flags in ringbuf helpers
    https://git.kernel.org/bpf/bpf-next/c/5c507329000e

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


