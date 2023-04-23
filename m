Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA05C6EBF94
	for <lists+netdev@lfdr.de>; Sun, 23 Apr 2023 14:50:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230219AbjDWMu0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Apr 2023 08:50:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230185AbjDWMuV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Apr 2023 08:50:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B14EA10EC;
        Sun, 23 Apr 2023 05:50:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3EF7560F12;
        Sun, 23 Apr 2023 12:50:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 9AAC5C433A1;
        Sun, 23 Apr 2023 12:50:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682254219;
        bh=QpV1kIThma30wk4nihLJg1ef6jHbubidHACUqkX3n1o=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Q077Xzq3rt/q/xNk6RvlrDXWf5q528PK/E4Dkkr12Ny89BspQfxNqpTm09JVQ+rgj
         olhMnMwHxU3p+QcqXnhni70tFJNdu4pXgWEbWHY8gc/X4Er7ljh06HPambZPG/G+ca
         UX6sy0dXX/xd4lxX75aM8ZO4+VFNMG58kd/oOiY1NF+8+cBmvzPllL2/0sm/HUyv63
         hKXAIbCkDMmqtFHPJhqvsTbDhTNE4h0hM/BPkgl+5SqCk7KLWm+UNX/ogVxFNmfvV7
         PFCw/Mv7FXvpUOcl0QO+SCf4ibDbQbZBIq/wpjQnO/EZMk8s3pt7bNTsHYaiCHDrxO
         dZYzj2UOD7rjA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 7D6FCE4F0DA;
        Sun, 23 Apr 2023 12:50:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] rxrpc: Replace fake flex-array with flexible-array
 member
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168225421951.16046.3046343203794923640.git-patchwork-notify@kernel.org>
Date:   Sun, 23 Apr 2023 12:50:19 +0000
References: <84871.1682082533@warthog.procyon.org.uk>
In-Reply-To: <84871.1682082533@warthog.procyon.org.uk>
To:     David Howells <dhowells@redhat.com>
Cc:     netdev@vger.kernel.org, gustavoars@kernel.org,
        simon.horman@corigine.com, keescook@chromium.org,
        jaltman@auristor.com, marc.dionne@auristor.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, linux-afs@lists.infradead.org,
        linux-hardening@vger.kernel.org, linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (main)
by David S. Miller <davem@davemloft.net>:

On Fri, 21 Apr 2023 14:08:53 +0100 you wrote:
> From: Gustavo A. R. Silva <gustavoars@kernel.org>
> 
> Zero-length arrays as fake flexible arrays are deprecated and we are
> moving towards adopting C99 flexible-array members instead.
> 
> Transform zero-length array into flexible-array member in struct
> rxrpc_ackpacket.
> 
> [...]

Here is the summary with links:
  - [net-next] rxrpc: Replace fake flex-array with flexible-array member
    https://git.kernel.org/netdev/net-next/c/788352191c85

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


