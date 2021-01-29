Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3AA99308340
	for <lists+netdev@lfdr.de>; Fri, 29 Jan 2021 02:32:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231680AbhA2Bbm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jan 2021 20:31:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:47784 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231332AbhA2BbM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 Jan 2021 20:31:12 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 20E0760235;
        Fri, 29 Jan 2021 01:30:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611883811;
        bh=RoNpr+uuzeuPk/9ltrUInRqmGmuVHIcnj9VLYGruJg0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=QfJff2Lqle1TgJ0v6hQeuDbuVdM4sY2x1yDtuJilYyWLshAHjIZmL/xjgGwrWeBYH
         4c7z+fuF5+96Rv5VbR453YDSJ/T/1kBNNi/vCO5dnNXzzz2aoXg8QkxgnXxWC9lLHO
         q12gCtlT57ln0WkhXiJS2Pcn9H4KTB1pVqHvt2eQ0FSxWpwqiakdZxVWIi9njmsgYM
         yZJ5uiMfvfzCQZlT5AZHU1yG3TyEtKnkLCQm/lecwaeOPU3bG6bOb/Q8wHBVqPUczB
         cgyqahcmPO7wvje/XW2QhvpiPnB0EuDrQXEnYI2EvJqfa0Ixyv7SHdcuM3oO7DRvRZ
         6zfa6e+xOwL7w==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 08ABB65322;
        Fri, 29 Jan 2021 01:30:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf-next] bpf: simplify cases in bpf_base_func_proto
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161188381102.24962.16531213008210155721.git-patchwork-notify@kernel.org>
Date:   Fri, 29 Jan 2021 01:30:11 +0000
References: <20210127174615.3038-1-tklauser@distanz.ch>
In-Reply-To: <20210127174615.3038-1-tklauser@distanz.ch>
To:     Tobias Klauser <tklauser@distanz.ch>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, daniel@iogearbox.net,
        ast@kernel.org, andrii@kernel.org, john.fastabend@gmail.com,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        kpsingh@kernel.org, sdf@google.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to bpf/bpf-next.git (refs/heads/master):

On Wed, 27 Jan 2021 18:46:15 +0100 you wrote:
> !perfmon_capable() is checked before the last switch(func_id) in
> bpf_base_func_proto. Thus, the cases BPF_FUNC_trace_printk and
> BPF_FUNC_snprintf_btf can be moved to that last switch(func_id) to omit
> the inline !perfmon_capable() checks.
> 
> Signed-off-by: Tobias Klauser <tklauser@distanz.ch>
> 
> [...]

Here is the summary with links:
  - [bpf-next] bpf: simplify cases in bpf_base_func_proto
    https://git.kernel.org/bpf/bpf-next/c/61ca36c8c4eb

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


