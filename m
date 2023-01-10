Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 16A91663DF6
	for <lists+netdev@lfdr.de>; Tue, 10 Jan 2023 11:21:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235805AbjAJKVi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Jan 2023 05:21:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237824AbjAJKVS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Jan 2023 05:21:18 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 347475471D;
        Tue, 10 Jan 2023 02:20:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CBF94B810F7;
        Tue, 10 Jan 2023 10:20:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 72C33C433F0;
        Tue, 10 Jan 2023 10:20:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673346015;
        bh=8Q2IH03BjuiDs9pds80DylLwFc7gx0X+ejED0jc9hp8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Dx9BXsF9ociaoCcs1TcG2QauXfBTzwJgHoXO7ytNW9Y4VeK6dozewFFQGXSCDgQgb
         iRPGu+k67WpCGJrYrOPWXwRIaqbNOFHE6MnB/G+3gUzPKnIcLb4HpEhG/sIKCiS7RX
         8dtCv+sWPqm5V7hnKRYhh6uW9KQu0r8YLKRbKBwBDzuuM3217OZ8Q2U/p/3xxyXPhQ
         38Eqs6gfDlRkNnWOQQfWinlfRwPoNlBrctg+tn7xkJnxLdRXNkac9O9EF0n+2v8YlX
         40GHrvAMSAG+7ewias/vT/pSMZnqgJxhpfWRPDLhkAou0Ox7ucSxeIaGJ74UQvbhYe
         ksdWxvVUKP8jw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 59F12E21EEA;
        Tue, 10 Jan 2023 10:20:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net PATCH] octeontx2-pf: Fix resource leakage in VF driver unbind
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167334601536.23804.3249818012090319433.git-patchwork-notify@kernel.org>
Date:   Tue, 10 Jan 2023 10:20:15 +0000
References: <20230109061325.21395-1-hkelam@marvell.com>
In-Reply-To: <20230109061325.21395-1-hkelam@marvell.com>
To:     Hariprasad Kelam <hkelam@marvell.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kuba@kernel.org, davem@davemloft.net, pabeni@redhat.com,
        edumazet@google.com, sgoutham@marvell.com, gakula@marvell.com,
        sbhatta@marvell.com
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
by Paolo Abeni <pabeni@redhat.com>:

On Mon, 9 Jan 2023 11:43:25 +0530 you wrote:
> resources allocated like mcam entries to support the Ntuple feature
> and hash tables for the tc feature are not getting freed in driver
> unbind. This patch fixes the issue.
> 
> Fixes: 2da489432747 ("octeontx2-pf: devlink params support to set mcam entry count")
> Signed-off-by: Hariprasad Kelam <hkelam@marvell.com>
> Signed-off-by: Sunil Kovvuri Goutham <sgoutham@marvell.com>
> 
> [...]

Here is the summary with links:
  - [net] octeontx2-pf: Fix resource leakage in VF driver unbind
    https://git.kernel.org/netdev/net/c/53da7aec3298

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


