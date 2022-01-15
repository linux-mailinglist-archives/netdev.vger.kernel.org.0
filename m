Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F10148F42B
	for <lists+netdev@lfdr.de>; Sat, 15 Jan 2022 02:31:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232033AbiAOBaL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jan 2022 20:30:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229584AbiAOBaK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jan 2022 20:30:10 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 619C6C061574;
        Fri, 14 Jan 2022 17:30:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F11F5620D9;
        Sat, 15 Jan 2022 01:30:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 4C6D9C36AEA;
        Sat, 15 Jan 2022 01:30:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642210209;
        bh=jaeXbZMuIfqzwYIZi0iIZBP3+PIHLNTDh33oru99wiM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=V5D75XsazkAYpHFDzf5HTUvzndjUVuW3trJxE3XRPqlGlu5ETovGQSjchxTtgAe2q
         eMWVHGLENn/QHNHR0xUEqaf5cBv0AJi34lYScoCu9JKKMcV1gexobGgCV4YIdnlMJ1
         eFW0h2SPF2rz7C8BJ1wxcz7VyWpKg1e1fITor9TxWE8Mw0SnrHZ1tzbCO+uR9GwOnP
         2C/p1WJNT2O+YCLVvKf27YNvDwlIIpMhhfq4zW7AguS3OEWT5sa/2pSCJj6q9lP5O3
         fcmaaZlLSWkGE0GGYTEjj13zIiLfF8sgvC3IgTMD0vy51CaG8wuS/tU1vxXX05T2E+
         7rE7O1JZHwlRQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 3774FF6079B;
        Sat, 15 Jan 2022 01:30:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf-next] test: selftests: remove unused various in
 sockmap_verdict_prog.c
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164221020922.14883.7115689326424030782.git-patchwork-notify@kernel.org>
Date:   Sat, 15 Jan 2022 01:30:09 +0000
References: <20220113031658.633290-1-imagedong@tencent.com>
In-Reply-To: <20220113031658.633290-1-imagedong@tencent.com>
To:     Menglong Dong <menglong8.dong@gmail.com>
Cc:     shuah@kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        davemarchevsky@fb.com, linux-kselftest@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org, imagedong@tencent.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to bpf/bpf-next.git (master)
by Andrii Nakryiko <andrii@kernel.org>:

On Thu, 13 Jan 2022 11:16:58 +0800 you wrote:
> From: Menglong Dong <imagedong@tencent.com>
> 
> 'lport' and 'rport' in bpf_prog1() of sockmap_verdict_prog.c is not
> used, just remove them.
> 
> Signed-off-by: Menglong Dong <imagedong@tencent.com>
> 
> [...]

Here is the summary with links:
  - [bpf-next] test: selftests: remove unused various in sockmap_verdict_prog.c
    https://git.kernel.org/bpf/bpf-next/c/e80f2a0d1946

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


