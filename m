Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E74A598B30
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 20:31:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344658AbiHRSae (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 14:30:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345490AbiHRSaW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 14:30:22 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7B1FB69E7;
        Thu, 18 Aug 2022 11:30:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3307CB823D3;
        Thu, 18 Aug 2022 18:30:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D071DC43142;
        Thu, 18 Aug 2022 18:30:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660847417;
        bh=fI2E+NRcQT9l3R7bWq67w2FGYGk5sVJ4p2To2lJLGeM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=uqtmWAQMxfScqvC7zoHnyN7z8u59WAU3Tq6/ZSzrHFq00fViKOE/VIQEjoUlPNi/0
         rQjenHBu0QJAblR6CDrIgaBHCXmf8yfhJsU30nFkxQ3qakeBWNlaKU8wMLWezYny+6
         OSIfXnedeuy7DBe2KzChVquINzGBeLGIRwOJfBaXV2Cxu7pMR2VdTmDXOfFjwW4fKj
         Ip4axk3A0XD+0tJKycnbnAqDoxFMcnF3ilACXI1ohTe8/fJHwD7MRXyXKgbodECkbK
         zlQ1lGrCi7sEnUo3mh6vLFCBZdblZ+aK3o1byLwax74fIY+Z1+cCLHLIfkx/5o2lLE
         NEcaiU/wdAGlw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id AD99CE2A05A;
        Thu, 18 Aug 2022 18:30:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [Patch net v3 0/4] tcp: some bug fixes for tcp_read_skb()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166084741770.25395.13635272233936484735.git-patchwork-notify@kernel.org>
Date:   Thu, 18 Aug 2022 18:30:17 +0000
References: <20220817195445.151609-1-xiyou.wangcong@gmail.com>
In-Reply-To: <20220817195445.151609-1-xiyou.wangcong@gmail.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        cong.wang@bytedance.com
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

This series was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 17 Aug 2022 12:54:41 -0700 you wrote:
> From: Cong Wang <cong.wang@bytedance.com>
> 
> This patchset contains 3 bug fixes and 1 minor refactor patch for
> tcp_read_skb(). V1 only had the first patch, as Eric prefers to fix all
> of them together, I have to group them together. Please see each patch
> description for more details.
> 
> [...]

Here is the summary with links:
  - [net,v3,1/4] tcp: fix sock skb accounting in tcp_read_skb()
    https://git.kernel.org/netdev/net/c/e9c6e7976026
  - [net,v3,2/4] tcp: fix tcp_cleanup_rbuf() for tcp_read_skb()
    https://git.kernel.org/netdev/net/c/c457985aaa92
  - [net,v3,3/4] tcp: refactor tcp_read_skb() a bit
    https://git.kernel.org/netdev/net/c/a8688821f385
  - [net,v3,4/4] tcp: handle pure FIN case correctly
    https://git.kernel.org/netdev/net/c/2e23acd99efa

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


