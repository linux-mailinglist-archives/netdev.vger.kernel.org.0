Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4530A53F1F1
	for <lists+netdev@lfdr.de>; Tue,  7 Jun 2022 00:04:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235077AbiFFWEe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jun 2022 18:04:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234626AbiFFWEc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jun 2022 18:04:32 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D494A33F
        for <netdev@vger.kernel.org>; Mon,  6 Jun 2022 15:04:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7B9D8B81BD1
        for <netdev@vger.kernel.org>; Mon,  6 Jun 2022 22:04:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 46365C385A9;
        Mon,  6 Jun 2022 22:04:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654553069;
        bh=mw+3Q0f1er9MF+Ygf/MRasae5sa8OPIpBMZszXnx538=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=nS82JSQSUW+hkj72T/cvYi4N1XPYuC1LlGhpbHaxdvRKLxUCBHAxNb+W45QlpHIJr
         Y+ep4A/UL2XVUCWfx2PvxMZFbgETeh7RNNkDAYcmKgjRwPC1UxLndqyEV3ecqfvhCw
         iFyXxbmxqEw8FnIPCZFqfwFg0DGP0EKVr0sVqBRCNfzIOh1J6CHkYstK0yWJy9bJup
         OuEBhrCWzM9S/cai2RasxmVkIy4o0ZBtdCkvuTlw/sGy7+fQIy0YwZY2iqDaBTx5d6
         xHW72+wwgUxaIT8ropx5+1np8fGX3oBTgAbbEt2VLcXo7BOGp7rjQpE5wL50+C+1+H
         cj95BLppvkOgw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 2A52BE737EF;
        Mon,  6 Jun 2022 22:04:29 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/3] amt: fix several bugs in amt_rcv()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165455306916.27266.12709601246061615305.git-patchwork-notify@kernel.org>
Date:   Mon, 06 Jun 2022 22:04:29 +0000
References: <20220602140108.18329-1-ap420073@gmail.com>
In-Reply-To: <20220602140108.18329-1-ap420073@gmail.com>
To:     Taehee Yoo <ap420073@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, netdev@vger.kernel.org
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Thu,  2 Jun 2022 14:01:05 +0000 you wrote:
> This series fixes bugs in amt_rcv().
> 
> First patch fixes pskb_may_pull() issue.
> Some functions missed to call pskb_may_pull() and uses wrong
> parameter of pskb_may_pull().
> 
> Second patch fixes possible null-ptr-deref in amt_rcv().
> If there is no amt private data in sock, skb will be freed.
> And it increases stats.
> But in order to increase stats, amt private data is needed.
> So, uninitialised pointer will be used at that point.
> 
> [...]

Here is the summary with links:
  - [net,1/3] amt: fix wrong usage of pskb_may_pull()
    https://git.kernel.org/netdev/net/c/f55a07074fdd
  - [net,2/3] amt: fix possible null-ptr-deref in amt_rcv()
    https://git.kernel.org/netdev/net/c/d16207f92a4a
  - [net,3/3] amt: fix wrong type string definition
    https://git.kernel.org/netdev/net/c/d7970039d87c

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


