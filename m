Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9EB46B58C3
	for <lists+netdev@lfdr.de>; Sat, 11 Mar 2023 06:50:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229806AbjCKFu0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Mar 2023 00:50:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229455AbjCKFuY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Mar 2023 00:50:24 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68E81659F;
        Fri, 10 Mar 2023 21:50:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 07B256069B;
        Sat, 11 Mar 2023 05:50:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 61C29C4339B;
        Sat, 11 Mar 2023 05:50:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678513822;
        bh=cEvt3ZhBfrja5tN7aTxCXLI507lYMVASgUZ8mx8gUlM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=SiIlnjIfuj06Rcw+muX2omnqkRBCKEZLqqnTDiYE6Yswvkpaq6m2I7CsG8koyryUv
         8VwDQn8Afdp9DJHsQLSRGZhoEVsbaqJe8IJQzBdNPyClm3rOFhKAhHyOTgNym5mXX6
         LBqMqk0C6I+yjX3NKyBkXfvZe+KFWgnHxsB4P5CwsmFuqfdYF+5CRme7knIJpwzJqM
         oRPdnnlSdx6SyA90ror6gJryyOcj159W4COGEprYHYbh/3Gar1/ik/zVCpwDrFiefB
         l2uGP8kSlmC1kvzFqZXDuqf+m4QdSKp3MrCPs7l6wig3PD9yK+g8e3UID9NMc7hdG6
         q+UsurgBmCH0w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 48881E270C7;
        Sat, 11 Mar 2023 05:50:22 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 1/4] netfilter: nft_nat: correct length for loading
 protocol registers
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167851382229.22535.17013828340193833705.git-patchwork-notify@kernel.org>
Date:   Sat, 11 Mar 2023 05:50:22 +0000
References: <20230309174655.69816-2-pablo@netfilter.org>
In-Reply-To: <20230309174655.69816-2-pablo@netfilter.org>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (main)
by Pablo Neira Ayuso <pablo@netfilter.org>:

On Thu,  9 Mar 2023 18:46:52 +0100 you wrote:
> From: Jeremy Sowden <jeremy@azazel.net>
> 
> The values in the protocol registers are two bytes wide.  However, when
> parsing the register loads, the code currently uses the larger 16-byte
> size of a `union nf_inet_addr`.  Change it to use the (correct) size of
> a `union nf_conntrack_man_proto` instead.
> 
> [...]

Here is the summary with links:
  - [net,1/4] netfilter: nft_nat: correct length for loading protocol registers
    https://git.kernel.org/netdev/net/c/068d82e75d53
  - [net,2/4] netfilter: nft_masq: correct length for loading protocol registers
    https://git.kernel.org/netdev/net/c/ec2c5917eb85
  - [net,3/4] netfilter: nft_redir: correct length for loading protocol registers
    https://git.kernel.org/netdev/net/c/1f617b6b4c7a
  - [net,4/4] netfilter: nft_redir: correct value of inet type `.maxattrs`
    https://git.kernel.org/netdev/net/c/493924519b1f

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


