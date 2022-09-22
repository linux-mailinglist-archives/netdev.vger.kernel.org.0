Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D9025E65FD
	for <lists+netdev@lfdr.de>; Thu, 22 Sep 2022 16:41:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232022AbiIVOlT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Sep 2022 10:41:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232024AbiIVOk4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Sep 2022 10:40:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DD3D6AEB9
        for <netdev@vger.kernel.org>; Thu, 22 Sep 2022 07:40:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0D69560F79
        for <netdev@vger.kernel.org>; Thu, 22 Sep 2022 14:40:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 6CC27C433D6;
        Thu, 22 Sep 2022 14:40:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663857614;
        bh=51KKU+RHcB2FCBgoSOxG+GVzuuJW2iXMAkz5w8/NeQY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=WvuOb620Rvw5ggopUBwDxcxp40EXjfBHwCchfVeYknpU3eGzKzivCwjZpaVj8vq4O
         eWYuE2MWr0cINE0jaE822fgGt7yqfZQ8SF124Qkt+v8RIm2VajNsgfUdUnFTRtB9nn
         cBzvuPq6SyUWzpoR+vkhml/vfeoOT2f8HtDkrplwUW+uhp3Gb6K2Wjnyl5d44Emn6U
         iSyCK9duV99qQTBKiupVTYUnMklhQMoa97crLTOkLQowkiooKU6K40gt04+BLlSuHQ
         7pR40l6HFaeaIx1j/xZizJTldIPjNyNj7IjzZaEGOhDuKcX+4N12fstBZGEM5fv/NQ
         p6iej7IjrB9kg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 4ED78E21ED1;
        Thu, 22 Sep 2022 14:40:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] bnxt: prevent skb UAF after handing over to PTP worker
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166385761431.22604.16014801539211187116.git-patchwork-notify@kernel.org>
Date:   Thu, 22 Sep 2022 14:40:14 +0000
References: <20220921201005.335390-1-kuba@kernel.org>
In-Reply-To: <20220921201005.335390-1-kuba@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, michael.chan@broadcom.com,
        pavan.chebbi@broadcom.com, edwin.peer@broadcom.com,
        andrew.gospodarek@broadcom.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 21 Sep 2022 13:10:05 -0700 you wrote:
> When reading the timestamp is required bnxt_tx_int() hands
> over the ownership of the completed skb to the PTP worker.
> The skb should not be used afterwards, as the worker may
> run before the rest of our code and free the skb, leading
> to a use-after-free.
> 
> Since dev_kfree_skb_any() accepts NULL make the loss of
> ownership more obvious and set skb to NULL.
> 
> [...]

Here is the summary with links:
  - [net] bnxt: prevent skb UAF after handing over to PTP worker
    https://git.kernel.org/netdev/net/c/c31f26c8f69f

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


