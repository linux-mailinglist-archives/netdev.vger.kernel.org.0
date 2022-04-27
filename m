Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE2D351272C
	for <lists+netdev@lfdr.de>; Thu, 28 Apr 2022 01:05:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233888AbiD0XHt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Apr 2022 19:07:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240260AbiD0XHY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Apr 2022 19:07:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE89CA2046;
        Wed, 27 Apr 2022 16:01:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8C49761E9E;
        Wed, 27 Apr 2022 23:01:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id ABB6CC385A7;
        Wed, 27 Apr 2022 23:01:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651100506;
        bh=dIP20b4eWKPIBhB9e9BcqWnLqB/CfPkIKK7WqakBH88=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=PDUTMTsKEJst4u0WdjA5vNLMOuhTfRV+F7ivpIejvLT7vVnwLH18X/egS7DfuBisW
         yXu4Nm0F9NiuUFnhVVzSPptNLooy6/gUnOckRHnY0gOXNK9986tOt5+28RYRXeoc4Q
         ljOlb6RLv3bXxzOuXXs9BojYJ3B/3yxisnYsO8yIbtWkFeQ47HUjPwfE0sf8MVtwx1
         iDJKm1KJKgilFyQnG6ajfDDSTycQAQrH5sCOTeQRQ2lV1ntVYUBTqLZubl3q1sPSS2
         nfXj/5F/v0ce6fH3mh69AZUWS9cKYYf6YGZgS/8ScF1wTjP+HU+/monZ1pAVFhlS4t
         xnjr63P8pf0Zw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 90997E8DD85;
        Wed, 27 Apr 2022 23:01:46 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: pull-request: bpf-next 2022-04-27
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165110050658.2033.16722871450848438620.git-patchwork-notify@kernel.org>
Date:   Wed, 27 Apr 2022 23:01:46 +0000
References: <20220427224758.20976-1-daniel@iogearbox.net>
In-Reply-To: <20220427224758.20976-1-daniel@iogearbox.net>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, ast@kernel.org, andrii@kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This pull request was applied to bpf/bpf.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 28 Apr 2022 00:47:58 +0200 you wrote:
> Hi David, hi Jakub, hi Paolo, hi Eric,
> 
> The following pull-request contains BPF updates for your *net-next* tree.
> 
> We've added 85 non-merge commits during the last 18 day(s) which contain
> a total of 163 files changed, 4499 insertions(+), 1521 deletions(-).
> 
> [...]

Here is the summary with links:
  - pull-request: bpf-next 2022-04-27
    https://git.kernel.org/bpf/bpf/c/347cb5deae25

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


