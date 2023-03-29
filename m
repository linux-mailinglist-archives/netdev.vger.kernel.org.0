Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA52E6CD268
	for <lists+netdev@lfdr.de>; Wed, 29 Mar 2023 09:00:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229625AbjC2HAb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Mar 2023 03:00:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229508AbjC2HA3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Mar 2023 03:00:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E9BB213B;
        Wed, 29 Mar 2023 00:00:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3698F61ACE;
        Wed, 29 Mar 2023 07:00:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8D607C433A1;
        Wed, 29 Mar 2023 07:00:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680073226;
        bh=H/Y47s92B9hocY4pZywyRRULUhPmYkLXk/pOMTbcGik=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=LNO6qTXxgYYq2v6h+I9IteS+a2lJD7yPHmFA+S5XlLcIqXyz32YR4Ym7QlbaUQQt5
         wPkwLJBTtERb8t4RtxopKOOw5llJtpRY7CrtXysFxWeUJlWhJpxdMMcdPD9Uu6Hq8a
         FYZs++a9scKVGXmBqES+GlZHS1ZSHmfYgjVie06U6UCr6IZ8dNNURiT9EuP1pQvLex
         UHJ9WTEPAvWEGkUIcsxhYuWjLOukt5D+kz/54DDn6cQjtwrMt+nho8iIuFk/WoAx9f
         whv4+2n54eaOFak0sdv4Th5PaE2mhWoqyeaaCGMHiwAWP4Ssi1OomWrOayZW/4dWVP
         /VDFVLzQxB1mw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 6FDF0E50D76;
        Wed, 29 Mar 2023 07:00:26 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] testing/vsock: add vsock_perf to gitignore
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168007322645.11543.3621479638262616925.git-patchwork-notify@kernel.org>
Date:   Wed, 29 Mar 2023 07:00:26 +0000
References: <20230327-vsock-add-vsock-perf-to-ignore-v1-1-f28a84f3606b@bytedance.com>
In-Reply-To: <20230327-vsock-add-vsock-perf-to-ignore-v1-1-f28a84f3606b@bytedance.com>
To:     Bobby Eshleman <bobby.eshleman@bytedance.com>
Cc:     sgarzare@redhat.com, AVKrasnov@sberdevices.ru, pabeni@redhat.com,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Mon, 27 Mar 2023 22:16:06 +0000 you wrote:
> This adds the vsock_perf binary to the gitignore file.
> 
> Fixes: 8abbffd27ced ("test/vsock: vsock_perf utility")
> Signed-off-by: Bobby Eshleman <bobby.eshleman@bytedance.com>
> ---
>  tools/testing/vsock/.gitignore | 1 +
>  1 file changed, 1 insertion(+)
> 
> [...]

Here is the summary with links:
  - [net-next] testing/vsock: add vsock_perf to gitignore
    https://git.kernel.org/netdev/net-next/c/24265c2c91ad

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


