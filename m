Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 382BD6E4102
	for <lists+netdev@lfdr.de>; Mon, 17 Apr 2023 09:31:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231187AbjDQHbM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Apr 2023 03:31:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230414AbjDQHal (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Apr 2023 03:30:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 247B04EC5;
        Mon, 17 Apr 2023 00:30:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3210B61F37;
        Mon, 17 Apr 2023 07:30:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 935A9C4339B;
        Mon, 17 Apr 2023 07:30:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681716619;
        bh=ShXWrwQLsNavGYFQUw+rc/KtkIMVipV2AEZjvAYBBeE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=pnTaRxduJxjnJpvr6qDZo1wjjP4r731k4pPJrhBQHcb5Gcs0l7V6jjY4Gci+2luGC
         /+ysx5rjFZS3ie1TlvP4JUZbB9l2eSXldVyomahgS9ltUH74SEkbTRIznLlWtdJJt8
         esY5vQ/9P88zEbnvF8qmRyjxThxxStYe4fJOQMPvzGn+X67tFxM2EERT4cEt/VqmOw
         F8L4UzMdBZKr01yUy3f5N3SCCuum7pUvxUI7Mpu4keJqXIxu1RDuH0SqHfEBtWIaOb
         mQpLwF6ubggrTJoW/IVo85YIjE5wc1rBu2IgUdnWqLu1bykLsKeLk8ew78StHW1UXk
         thqMZhTLI1K0w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 7F1AFE3309D;
        Mon, 17 Apr 2023 07:30:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/2] sctp: add some missing peer_capables in sctp
 info dump
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168171661951.7386.5828887285252600503.git-patchwork-notify@kernel.org>
Date:   Mon, 17 Apr 2023 07:30:19 +0000
References: <cover.1681507192.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1681507192.git.lucien.xin@gmail.com>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     netdev@vger.kernel.org, linux-sctp@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org, edumazet@google.com,
        pabeni@redhat.com, marcelo.leitner@gmail.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (main)
by David S. Miller <davem@davemloft.net>:

On Fri, 14 Apr 2023 17:21:14 -0400 you wrote:
> The 1st patch removes the unused and obsolete hostname_address from
> sctp_association peer and also the bit from sctp_info peer_capables,
> and then reuses its bit for reconf_capable and use the higher
> available bit for intl_capable in the 2nd patch.
> 
> Xin Long (2):
>   sctp: delete the obsolete code for the host name address param
>   sctp: add intl_capable and reconf_capable in ss peer_capable
> 
> [...]

Here is the summary with links:
  - [net-next,1/2] sctp: delete the obsolete code for the host name address param
    https://git.kernel.org/netdev/net-next/c/bd4b28189469
  - [net-next,2/2] sctp: add intl_capable and reconf_capable in ss peer_capable
    https://git.kernel.org/netdev/net-next/c/ab4f1e28c941

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


