Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ABECE512547
	for <lists+netdev@lfdr.de>; Thu, 28 Apr 2022 00:30:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234882AbiD0Wda (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Apr 2022 18:33:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232747AbiD0Wd2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Apr 2022 18:33:28 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB6D2101DC;
        Wed, 27 Apr 2022 15:30:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7F953B82AE0;
        Wed, 27 Apr 2022 22:30:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 32310C385AA;
        Wed, 27 Apr 2022 22:30:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651098612;
        bh=a+/A487atuJroB62YJy7WMPkgH5dBHBcNzHKH/ugl6s=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=e4CxEDTlcXkvivKWM+FmSCfB7DFPcINcyhCr1j9xbhTPZTmQyabu40EYCSuY0Lh6R
         KEgXNWp6MctPdAvgf0/vIinhr84hpmMmqhkt0BUxD57Euhut2mXGLpbNyd4AMDIkYo
         3WyJIqG17s40O7BjKhup8PI3eRd/O1R+aLTF+G0A21/4s1Umw4obuvve+lWy68LQvx
         IvIbAFfLIr6RKd9U7cXHppr+gT5T4FPRDyisBsCEm5amXuIyMGx4gqgDg/0ytHouk/
         d12d1M5BXeB+BrQFpOdYQFV2VBVuNLtP4/dJAwX3KCrKJY8JUAx9KNTKcDigpintSm
         rEq0F2pgXObPA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 1C4ACE8DD67;
        Wed, 27 Apr 2022 22:30:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: pull-request: bpf 2022-04-27
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165109861211.18051.15876839276700811787.git-patchwork-notify@kernel.org>
Date:   Wed, 27 Apr 2022 22:30:12 +0000
References: <20220427212748.9576-1-daniel@iogearbox.net>
In-Reply-To: <20220427212748.9576-1-daniel@iogearbox.net>
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

This pull request was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 27 Apr 2022 23:27:48 +0200 you wrote:
> Hi David, hi Jakub, hi Paolo, hi Eric,
> 
> The following pull-request contains BPF updates for your *net* tree.
> 
> We've added 5 non-merge commits during the last 20 day(s) which contain
> a total of 6 files changed, 34 insertions(+), 12 deletions(-).
> 
> [...]

Here is the summary with links:
  - pull-request: bpf 2022-04-27
    https://git.kernel.org/netdev/net/c/347cb5deae25

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


