Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B569B59F917
	for <lists+netdev@lfdr.de>; Wed, 24 Aug 2022 14:10:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237257AbiHXMKc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Aug 2022 08:10:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237192AbiHXMKX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Aug 2022 08:10:23 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C82C3E779
        for <netdev@vger.kernel.org>; Wed, 24 Aug 2022 05:10:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 647D3B823FA
        for <netdev@vger.kernel.org>; Wed, 24 Aug 2022 12:10:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 27F9FC43141;
        Wed, 24 Aug 2022 12:10:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661343017;
        bh=UHaXAnrqTfqTtBcb3Ra0CMQdPFcTyuqJTdo9EbO4uXQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=vHLqIeZhBnBZ5cOAG4E8nfH8ZVsEDXZIWAcECoonLut6glQD4fABQnTxZVDK4Akjc
         led/QKnZ62PmWBoUC66RqhfBr3ltYN7/f590Mw1ST0fWvrbJf2vvCyRaPXb/H8aCbo
         nCp57J+z+2Pq+lOim7ZSZO2aWJlCY2a4kZvvQCLn9nu9Cl2fPOYq7bHxXSjdeFZaco
         Issl9W2LE6SFCmgM0GuQwGf2ckdYc5bvIZ77zv1lH/qi/IfNGOZMTCvjt26mVKaeUn
         MYO/Ozr4ayFWH/vrJeEYjjiJIcYZ/otVrI4ev8fKD4CSf+I4MiO/HkizKDwr/4RJ62
         fjMTVhFeAudTg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 11ECDC04E59;
        Wed, 24 Aug 2022 12:10:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] tcp: annotate data-race around
 tcp_md5sig_pool_populated
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166134301706.8334.6382184669199306096.git-patchwork-notify@kernel.org>
Date:   Wed, 24 Aug 2022 12:10:17 +0000
References: <20220822211528.915954-1-edumazet@google.com>
In-Reply-To: <20220822211528.915954-1-edumazet@google.com>
To:     Eric Dumazet <edumazet@google.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, eric.dumazet@gmail.com,
        abhishek.shah@columbia.edu
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

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Mon, 22 Aug 2022 21:15:28 +0000 you wrote:
> tcp_md5sig_pool_populated can be read while another thread
> changes its value.
> 
> The race has no consequence because allocations
> are protected with tcp_md5sig_mutex.
> 
> This patch adds READ_ONCE() and WRITE_ONCE() to document
> the race and silence KCSAN.
> 
> [...]

Here is the summary with links:
  - [net-next] tcp: annotate data-race around tcp_md5sig_pool_populated
    https://git.kernel.org/netdev/net-next/c/aacd467c0a57

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


