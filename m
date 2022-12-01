Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 347DF63E9A0
	for <lists+netdev@lfdr.de>; Thu,  1 Dec 2022 07:10:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229782AbiLAGKX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Dec 2022 01:10:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229750AbiLAGKT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Dec 2022 01:10:19 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D10A1A85E5;
        Wed, 30 Nov 2022 22:10:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8B593B81E4F;
        Thu,  1 Dec 2022 06:10:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 3F619C43150;
        Thu,  1 Dec 2022 06:10:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669875016;
        bh=LkEKKmWZfIlro2/l2LEFbEZPNpPPWmZpOzAn20tg1Ho=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=oUdN8vhPCMP36rKWZRdoU13ULCk6gWTV6KYjOCyuXzM6KuFKkMEXa7EO20ktV4UQc
         3z2OQleCnHQkhOHvxiOuiiUt4xFMwhB3kLBJaTLxiQWl39wAS/DcDhcvbphYAdNY9F
         bZJeAEsDafeddYwgS06HC92FOeP0FV283H0qKRRsVCwTpJGuY7bAt1A5pWSxoe70Ut
         fzwcSx5VPbzlZlxPzKiYcy+FOE8oW76uByG2o6VGbGhhy1ZTeSb6uY18SQ6b2Rs9on
         HFzs4VA72+YqRsNr19A0f1pfgPhn2mLQmY1+gso1l7eRWyO04O+YE/gJfcOceIS8KX
         I4JJIGVY2HT1w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 2C64CE270C8;
        Thu,  1 Dec 2022 06:10:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 1/4] netfilter: nft_set_pipapo: Actually validate
 intervals in fields after the first one
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166987501617.18933.12218233052985060196.git-patchwork-notify@kernel.org>
Date:   Thu, 01 Dec 2022 06:10:16 +0000
References: <20221130121934.1125-2-pablo@netfilter.org>
In-Reply-To: <20221130121934.1125-2-pablo@netfilter.org>
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

This series was applied to netdev/net.git (master)
by Pablo Neira Ayuso <pablo@netfilter.org>:

On Wed, 30 Nov 2022 13:19:31 +0100 you wrote:
> From: Stefano Brivio <sbrivio@redhat.com>
> 
> Embarrassingly, nft_pipapo_insert() checked for interval validity in
> the first field only.
> 
> The start_p and end_p pointers were reset to key data from the first
> field at every iteration of the loop which was supposed to go over
> the set fields.
> 
> [...]

Here is the summary with links:
  - [net,1/4] netfilter: nft_set_pipapo: Actually validate intervals in fields after the first one
    https://git.kernel.org/netdev/net/c/97d4d394b587
  - [net,2/4] netfilter: flowtable_offload: fix using __this_cpu_add in preemptible
    https://git.kernel.org/netdev/net/c/a81047154e7c
  - [net,3/4] netfilter: conntrack: fix using __this_cpu_add in preemptible
    https://git.kernel.org/netdev/net/c/9464d0b68f11
  - [net,4/4] netfilter: ctnetlink: fix compilation warning after data race fixes in ct mark
    https://git.kernel.org/netdev/net/c/1feeae071507

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


