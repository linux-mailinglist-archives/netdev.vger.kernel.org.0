Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31C4C6E0E26
	for <lists+netdev@lfdr.de>; Thu, 13 Apr 2023 15:10:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230305AbjDMNKp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Apr 2023 09:10:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230298AbjDMNKm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Apr 2023 09:10:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35003A5D5;
        Thu, 13 Apr 2023 06:10:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 59D4963E35;
        Thu, 13 Apr 2023 13:10:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A7B8DC4339E;
        Thu, 13 Apr 2023 13:10:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681391418;
        bh=/6XN2JgxHvtFnTYlscTnTuxXq2yPgSJkGBYiF/uwa8w=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=au1SO+qgXmPPwPOAQBCDvlhX5M2njWmfVibs78hBBs4p9BZjZtloVlbterDrqU0LR
         Ak/xXzz3zC1jcd552kc6CClxVjL3Y8hUmJ0txMEqVoFZjswLZDq6LMmfBDI7dGuVgg
         KGerOXQSyecMa9Sy5dOffc6SH6ICag7bFW6zP4XZ7NSHdKMZTaMmFEqMQ6sxJogZz3
         0NSjYCGKKuQgQ6r/Sr6OhoFvDhq7tG94iHaKyLZ/mcu5rgUQwndMZXPQkEvJfacRuu
         o0ZLQbXn6AcuNvd4CdKYKAfDGhgzNvvqJrQqSNkxkH2ndJ4BB5KBbeH5AMMeG4vnnQ
         crEn3kog1ccAQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 8A23DE45090;
        Thu, 13 Apr 2023 13:10:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf-next v2] xsk: Elide base_addr comparison in
 xp_unaligned_validate_desc
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168139141856.617.2602212913039871764.git-patchwork-notify@kernel.org>
Date:   Thu, 13 Apr 2023 13:10:18 +0000
References: <20230411130025.19704-1-kal.conley@dectris.com>
In-Reply-To: <20230411130025.19704-1-kal.conley@dectris.com>
To:     Kal Cutter Conley <kal.conley@dectris.com>
Cc:     bjorn@kernel.org, magnus.karlsson@intel.com,
        maciej.fijalkowski@intel.com, jonathan.lemon@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, ast@kernel.org, daniel@iogearbox.net,
        hawk@kernel.org, john.fastabend@gmail.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to bpf/bpf-next.git (master)
by Daniel Borkmann <daniel@iogearbox.net>:

On Tue, 11 Apr 2023 15:00:25 +0200 you wrote:
> Remove redundant (base_addr >= pool->addrs_cnt) comparison from the
> conditional.
> 
> In particular, addr is computed as:
> 
>     addr = base_addr + offset
> 
> [...]

Here is the summary with links:
  - [bpf-next,v2] xsk: Elide base_addr comparison in xp_unaligned_validate_desc
    https://git.kernel.org/bpf/bpf-next/c/1ba83f505c53

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


