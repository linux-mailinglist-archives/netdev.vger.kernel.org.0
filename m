Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 06BB3641421
	for <lists+netdev@lfdr.de>; Sat,  3 Dec 2022 05:40:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230332AbiLCEkX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Dec 2022 23:40:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229823AbiLCEkU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Dec 2022 23:40:20 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 070FC92A3B;
        Fri,  2 Dec 2022 20:40:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9679FB8229F;
        Sat,  3 Dec 2022 04:40:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 41CC8C433D7;
        Sat,  3 Dec 2022 04:40:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670042417;
        bh=IalLhNA0Wd6Cx26vlm+yVV8EFNCe5y1O6LGLKcDZ4+Y=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=tOkx/8fSvvUjwy+BdnzkJANge25ecbWY3JChHVDHIaS8M9yD6dcHJsUhob6VDRfBo
         7jiPQ5r6pU9YRykWXcgTPLlGZSX8UPOSdYAL38rYVTjkIAiFFFye+v3klkVzOa61C5
         GIRFMjgoa6nTIVv02o0VPrvwBUlzblBQnsGsNv9T9+ihOUs7i3debm+HGg+AnBW2R/
         GwwRJlo+ZDDtuzX2ZGVu/Ti4LAx3AI8MftgqJdgwUHCQX9JhPjmU1klAhfz8akfgXm
         jD7B9/ltm/45udPBDPScCRUBoEUs+9/vbF5UBAjcSk0NUZZZw2yXBhcqkGYxY78rmO
         GJX//9Kp+YliA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 1DCAAE29F3E;
        Sat,  3 Dec 2022 04:40:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: pull-request: bluetooth 2022-12-02
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167004241711.29921.3509378462888475002.git-patchwork-notify@kernel.org>
Date:   Sat, 03 Dec 2022 04:40:17 +0000
References: <20221202213726.2801581-1-luiz.dentz@gmail.com>
In-Reply-To: <20221202213726.2801581-1-luiz.dentz@gmail.com>
To:     Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Fri,  2 Dec 2022 13:37:26 -0800 you wrote:
> The following changes since commit e931a173a685fe213127ae5aa6b7f2196c1d875d:
> 
>   Merge branch 'vmxnet3-fixes' (2022-12-02 10:30:07 +0000)
> 
> are available in the Git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth.git tags/for-net-2022-12-02
> 
> [...]

Here is the summary with links:
  - pull-request: bluetooth 2022-12-02
    https://git.kernel.org/netdev/net/c/a789c70c1dfe

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


