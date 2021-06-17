Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 464D73AB200
	for <lists+netdev@lfdr.de>; Thu, 17 Jun 2021 13:10:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232375AbhFQLML (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Jun 2021 07:12:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:52716 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229901AbhFQLMK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 17 Jun 2021 07:12:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 1935C61369;
        Thu, 17 Jun 2021 11:10:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623928203;
        bh=gQvg9Q1AM9aT0v+HsBwsJ17VmOZXq4MeM7IYi1cTqxo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=OH1LVyDZefgQzGSCRgALmaf0L4zt2RdAFOpbxJWBjQS1nfHLaI+fFl2N/bAb1MRlC
         iFrtu3W27lkTUVm7+dELc9jOiqW4QlKiK/ff/X0bXiVOTKGJhA7TVFwEkGFONOsxTI
         5oOLMjhmCqdVIHDCnt/h3lc/GAOuu3UFdWzMr4qAIRRsFc1iZTKQRjaMo2cBUg/+9C
         ihXa5LZq8wawT3r9URo35itZ0L/sbKIT2eK/pSQ0FwagTAU2+dJCnj+ASN8CHcbJ7C
         LG1lsNg3bhnkZwhCospblmj09/0OZVWlb/rlE63jDFeJYyO3Nklu7a4d/LKoU+e2gN
         VRH1KJ4GQQ/iQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 0766C609EA;
        Thu, 17 Jun 2021 11:10:03 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf-next] selftests/bpf: fix selftests build with old
 system-wide headers
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162392820302.26848.12293984613133603033.git-patchwork-notify@kernel.org>
Date:   Thu, 17 Jun 2021 11:10:03 +0000
References: <20210617041446.425283-1-andrii@kernel.org>
In-Reply-To: <20210617041446.425283-1-andrii@kernel.org>
To:     Andrii Nakryiko <andrii@kernel.org>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, ast@fb.com,
        daniel@iogearbox.net, kernel-team@fb.com, kuniyu@amazon.co.jp
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to bpf/bpf-next.git (refs/heads/master):

On Wed, 16 Jun 2021 21:14:46 -0700 you wrote:
> migrate_reuseport.c selftest relies on having TCP_FASTOPEN_CONNECT defined in
> system-wide netinet/tcp.h. Selftests can use up-to-date uapi/linux/tcp.h, but
> that one doesn't have SOL_TCP. So instead of switching everything to uapi
> header, add #define for TCP_FASTOPEN_CONNECT to fix the build.
> 
> Cc: Kuniyuki Iwashima <kuniyu@amazon.co.jp>
> Fixes: c9d0bdef89a6 ("bpf: Test BPF_SK_REUSEPORT_SELECT_OR_MIGRATE.")
> Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
> 
> [...]

Here is the summary with links:
  - [bpf-next] selftests/bpf: fix selftests build with old system-wide headers
    https://git.kernel.org/bpf/bpf-next/c/f20792d425d2

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


