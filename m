Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A17EA609EC3
	for <lists+netdev@lfdr.de>; Mon, 24 Oct 2022 12:11:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231150AbiJXKLo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Oct 2022 06:11:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231163AbiJXKLY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Oct 2022 06:11:24 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9198736411
        for <netdev@vger.kernel.org>; Mon, 24 Oct 2022 03:11:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 42264B810AF
        for <netdev@vger.kernel.org>; Mon, 24 Oct 2022 10:10:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E8A31C433D7;
        Mon, 24 Oct 2022 10:10:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666606216;
        bh=Ypr0FjbcfHQDHI1QycfVWtYONHacPMWaLFEBHBQ3toU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=BBk8parfczskx0jazcPD1pqJbelwl+flNyW5HjG4ieTZUuncRo9GDffCYaIYqYu22
         XQUweocY1gRGpkvP0q+W0C1YkjI+HVHsfaPfiKSoWF3/kvEzcbegEFF9dnrzG8QJbb
         /IxtY7CgYC8EtE39BtuwUNVFy+YNtaEnKUWj0BYsd245TjgjVqJX6Qs+Jqeu86e6y9
         ic9PkazZmHEYRVqpqyi9cjbfjFrSKmReFOAWsTsD9K4EZMRftIfJPQ1BilXRsUSt3v
         u970aspxoxJIWaJio3A2G88sKe3z2kQ0hsWsGpsds1WBb81rmjuJCAMZHCj7AKqaWL
         QUA+TeyGZ7ByQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id CB45BE270DE;
        Mon, 24 Oct 2022 10:10:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/2] kcm: annotate data-races
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166660621582.6109.3511329675884298704.git-patchwork-notify@kernel.org>
Date:   Mon, 24 Oct 2022 10:10:15 +0000
References: <20221020224512.3211657-1-edumazet@google.com>
In-Reply-To: <20221020224512.3211657-1-edumazet@google.com>
To:     Eric Dumazet <edumazet@google.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, eric.dumazet@gmail.com
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Thu, 20 Oct 2022 22:45:10 +0000 you wrote:
> This series address two different syzbot reports for KCM.
> 
> Eric Dumazet (2):
>   kcm: annotate data-races around kcm->rx_psock
>   kcm: annotate data-races around kcm->rx_wait
> 
>  net/kcm/kcmsock.c | 23 +++++++++++++++--------
>  1 file changed, 15 insertions(+), 8 deletions(-)

Here is the summary with links:
  - [net,1/2] kcm: annotate data-races around kcm->rx_psock
    https://git.kernel.org/netdev/net/c/15e4dabda11b
  - [net,2/2] kcm: annotate data-races around kcm->rx_wait
    https://git.kernel.org/netdev/net/c/0c745b5141a4

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


