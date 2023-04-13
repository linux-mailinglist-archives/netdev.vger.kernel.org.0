Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A37F6E0DE2
	for <lists+netdev@lfdr.de>; Thu, 13 Apr 2023 15:00:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230003AbjDMNAV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Apr 2023 09:00:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229708AbjDMNAU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Apr 2023 09:00:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8885E4C2D;
        Thu, 13 Apr 2023 06:00:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1C54B63E1E;
        Thu, 13 Apr 2023 13:00:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 6E7DFC4339B;
        Thu, 13 Apr 2023 13:00:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681390818;
        bh=zRXU0ckp3oOYqxg3ICueDA/QkpSJMCJXnQu1Pq2cq3k=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Y6XCgTW47AjXFnC2g+HY33qv4dsGkEZsXWJfPYI8SAqNYxR2/dUq1UND8c9vALZwo
         2Mo98suZ80eZJCUB0l/RwFEVuiuBvMUKUS12uaIZkzD4voo+taTchqA81wV7kbvtbe
         xzR0HvP9wmPZOGmeW3v0sgQmQWJrozBSPs0oVgpEYNRFCDoaQGr49NjlSv/9zvCB3Z
         aGJgP6oa/J4ydQ6OKrYvvA+8xzCwp2k6+mw0KZoSmr/rDYKMzlb3tBLw8h6nfPBSLE
         08wO7aDJa4eaCDYGjR5DF8vYtdqfDd5us+4ylRoDZ9XaJu+ZC6VKzd4WA+SMyT4PWX
         4LPNIa80W9k4g==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 52BA3E4508F;
        Thu, 13 Apr 2023 13:00:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf-next] xsk: Simplify xp_aligned_validate_desc
 implementation
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168139081832.26604.18081207026429797036.git-patchwork-notify@kernel.org>
Date:   Thu, 13 Apr 2023 13:00:18 +0000
References: <20230410121841.643254-1-kal.conley@dectris.com>
In-Reply-To: <20230410121841.643254-1-kal.conley@dectris.com>
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

On Mon, 10 Apr 2023 14:18:41 +0200 you wrote:
> Perform the chunk boundary check like the page boundary check in
> xp_desc_crosses_non_contig_pg(). This simplifies the implementation and
> reduces the number of branches.
> 
> Signed-off-by: Kal Conley <kal.conley@dectris.com>
> ---
>  net/xdp/xsk_queue.h | 12 ++++--------
>  1 file changed, 4 insertions(+), 8 deletions(-)

Here is the summary with links:
  - [bpf-next] xsk: Simplify xp_aligned_validate_desc implementation
    https://git.kernel.org/bpf/bpf-next/c/0c5f48599bed

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


