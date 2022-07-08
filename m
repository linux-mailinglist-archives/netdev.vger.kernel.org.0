Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 79E8756C501
	for <lists+netdev@lfdr.de>; Sat,  9 Jul 2022 02:29:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229750AbiGHXke (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jul 2022 19:40:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229739AbiGHXkb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jul 2022 19:40:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C16E7FE64;
        Fri,  8 Jul 2022 16:40:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A48E1622F7;
        Fri,  8 Jul 2022 23:40:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E37EFC341C7;
        Fri,  8 Jul 2022 23:40:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657323630;
        bh=7YzsMxnV1hFa5+QXhvXZ/gMiIlRckfliHklfMlnWyoU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=XtbZN95u7NSI4tlAzo2XedJBoOfMMyz9PX6pSZocbD+biyhea1y8DHOM4r4tZ7IGh
         u2RhZdOfU9CnTIPLth8jKcyIKLRAiywMHd1WL7eXd7HFtMQx2m3RRasDs45QT/1jou
         wKdM3m3sKnTPMkQ+5rrUsLMG6urb8jEdawxqbDHpZo+mIbukk8/eEQWl4bySXR6fKa
         MJU+9tI8Z04AMxr30a8p8Xst5wzl6CeoaOUL7ep5ATE8cYNl/q5donPJpdW0ehxxd4
         LKr6SufN6ct6kQm2W1m6E7xXbzJbqS6pdpmjVxRAyoi4xmE0gQEKedXHWALc7uFp3I
         e2PHlkROg9P6w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id C642DE45BDB;
        Fri,  8 Jul 2022 23:40:29 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: pull-request: bpf-next 2022-07-09
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165732362980.8115.16048830645094200005.git-patchwork-notify@kernel.org>
Date:   Fri, 08 Jul 2022 23:40:29 +0000
References: <20220708233145.32365-1-daniel@iogearbox.net>
In-Reply-To: <20220708233145.32365-1-daniel@iogearbox.net>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, ast@kernel.org, andrii@kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This pull request was applied to bpf/bpf.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Sat,  9 Jul 2022 01:31:45 +0200 you wrote:
> Hi David, hi Jakub, hi Paolo, hi Eric,
> 
> The following pull-request contains BPF updates for your *net-next* tree.
> 
> We've added 94 non-merge commits during the last 19 day(s) which contain
> a total of 125 files changed, 5141 insertions(+), 6701 deletions(-).
> 
> [...]

Here is the summary with links:
  - pull-request: bpf-next 2022-07-09
    https://git.kernel.org/bpf/bpf/c/7c895ef88403

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


