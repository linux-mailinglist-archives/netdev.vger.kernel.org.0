Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C84CF616272
	for <lists+netdev@lfdr.de>; Wed,  2 Nov 2022 13:10:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230019AbiKBMKU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Nov 2022 08:10:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229523AbiKBMKT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Nov 2022 08:10:19 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC75323146;
        Wed,  2 Nov 2022 05:10:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 60F56CE1F49;
        Wed,  2 Nov 2022 12:10:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 698C7C433B5;
        Wed,  2 Nov 2022 12:10:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667391015;
        bh=qDJ5/Ro/oYuwDa82PgD4He9ixe2S5LP8VN5XLIylMoc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=lcrpThxWccuW65vYOQvk5j+RctjUsl9KyjGWi/teScOw7yj+4jwEe+gHgLbqI7NuS
         /x1mwYTzc+g0OkibGgls1WkYW6Tdosa3QDYB/J+ULb47oqHlqBQ7SPpWm10WtnrqP1
         vWs0+zMQulH4Kt3AjjTfi+X+uqtO1Q5ix8TWLUZq1kHcgcg5jAcWdtmhmnOYPMyCvL
         QYkbdLebdGwwWRbjmwO7mSMGlX1hUbQ11D3pJc3q6qh0Y+H2KTdYihTvzH4s2WeHux
         sr1Ekzdvj5xTeBFOGc5gFBtkYBy+sVVznwkrA3d3avehROuuW1EX9pdTMMTbE0cXAv
         67UCchZnpojjA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 4F8D4C41620;
        Wed,  2 Nov 2022 12:10:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] veth: Avoid drop packets when xdp_redirect performs
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166739101532.14028.3067823596353159397.git-patchwork-notify@kernel.org>
Date:   Wed, 02 Nov 2022 12:10:15 +0000
References: <20221031061922.124992-1-hengqi@linux.alibaba.com>
In-Reply-To: <20221031061922.124992-1-hengqi@linux.alibaba.com>
To:     Heng Qi <hengqi@linux.alibaba.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, ast@kernel.org,
        daniel@iogearbox.net, hawk@kernel.org, john.fastabend@gmail.com,
        toke@redhat.com, xuanzhuo@linux.alibaba.com,
        henqqi@linux.alibaba.com
X-Spam-Status: No, score=-8.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Mon, 31 Oct 2022 14:19:22 +0800 you wrote:
> From: Heng Qi <henqqi@linux.alibaba.com>
> 
> In the current processing logic, when xdp_redirect occurs, it transmits
> the xdp frame based on napi.
> 
> If napi of the peer veth is not ready, the veth will drop the packets.
> This doesn't meet our expectations.
> 
> [...]

Here is the summary with links:
  - veth: Avoid drop packets when xdp_redirect performs
    https://git.kernel.org/netdev/net-next/c/2e0de6366ac1

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


