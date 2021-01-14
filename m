Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29A522F592C
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 04:32:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727221AbhANDUt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jan 2021 22:20:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:54752 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725875AbhANDUs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 13 Jan 2021 22:20:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 5F14B2368A;
        Thu, 14 Jan 2021 03:20:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610594408;
        bh=DsKff8k2U019nOkgpQIvVwjMpwDccNMnKcyt3nLKKH4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=BAq1PLoImqKJ+pYkWrgnI04JmWOER6IbgrED3ajsXhnZ7C5yZc5yLhb3mPLdUXgfu
         Ey81HLUXZvRtyZNOVdakRcAaKR3T3G+PJQadqMQYRi4DCDQHtiTfJpelaPh7ulDDO1
         BRJgtwwelE2JRbXkYdlMPETFAvDQ+1fKOz9c0O9JjU6sjg2fTvB9Ol5dzK62ec+jjA
         +uD7vNNwu+eldDnKxe0caHjcgdI7zqoeOUnXvCKGKU+RgbNKjnetRP61iILwLhasvq
         4Cp3VDpAiCcrRSunkWGbXrGYLK41UaEZLvuF/xEzQnNE/EzpluOHRDh/EYVQXU/Kql
         UGCf9i6MIHdVw==
Received: from pdx-korg-docbuild-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-1.ci.codeaurora.org (Postfix) with ESMTP id 4E6F060105;
        Thu, 14 Jan 2021 03:20:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 1/2] bpf,
 libbpf: Avoid unused function warning on bpf_tail_call_static
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161059440831.32332.1122850052450236500.git-patchwork-notify@kernel.org>
Date:   Thu, 14 Jan 2021 03:20:08 +0000
References: <20210113223609.3358812-1-irogers@google.com>
In-Reply-To: <20210113223609.3358812-1-irogers@google.com>
To:     Ian Rogers <irogers@google.com>
Cc:     ast@kernel.org, daniel@iogearbox.net, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        john.fastabend@gmail.com, kpsingh@chromium.org,
        quentin@isovalent.com, jean-philippe@linaro.org,
        tklauser@distanz.ch, iii@linux.ibm.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to bpf/bpf-next.git (refs/heads/master):

On Wed, 13 Jan 2021 14:36:08 -0800 you wrote:
> Add inline to __always_inline making it match the linux/compiler.h.
> Adding this avoids an unused function warning on bpf_tail_call_static
> when compining with -Wall.
> 
> Signed-off-by: Ian Rogers <irogers@google.com>
> ---
>  tools/lib/bpf/bpf_helpers.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Here is the summary with links:
  - [1/2] bpf, libbpf: Avoid unused function warning on bpf_tail_call_static
    https://git.kernel.org/bpf/bpf-next/c/ce5a518e9de5
  - [2/2] tools/bpftool: Add -Wall when building BPF programs
    https://git.kernel.org/bpf/bpf-next/c/bade5c554f1a

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


