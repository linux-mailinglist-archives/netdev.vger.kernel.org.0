Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E383564E976
	for <lists+netdev@lfdr.de>; Fri, 16 Dec 2022 11:30:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229973AbiLPKaT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Dec 2022 05:30:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229932AbiLPKaS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Dec 2022 05:30:18 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA8FC33C19
        for <netdev@vger.kernel.org>; Fri, 16 Dec 2022 02:30:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5CDA462057
        for <netdev@vger.kernel.org>; Fri, 16 Dec 2022 10:30:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B5E0EC433D2;
        Fri, 16 Dec 2022 10:30:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671186616;
        bh=shtm4Nl55P1bHzY8HxDcP/QRRQWtmMKCMlYAOlLv0z8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=AwhYvpetHm3M+0QYNWQrbCqg+VdqaR6i2VRp0LVhorikLRsMuouE74u6WU/iwjWdS
         WyaaDK443K0oZMsQi9qTZ56lPtZXkDthgPZJKQyQIWSUpsJYHY/0FaJ7a8GDtOdpnY
         WsrfFGHY9LDqVT/KlfGzumED5PX3eyO4wVqyLFsAATo+riMCVp4BSigEAs7tH590Fa
         yzuKzSG4aCfAVzrIh1DZ1eXKDXVahH+krKTa0l/3hm8aTB0IRc++48z18gBLPVhzt7
         nND0vuZ1IJRkwhJwRK+LUv7NnUAuGlYUJ8m5q3NCL5w9WF9neGmPIg6Pyyai+WDIGZ
         TQldQrMHCt4MA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id A092EE4D00F;
        Fri, 16 Dec 2022 10:30:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/3] devlink: region snapshot locking fix and selftest
 adjustments
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167118661665.18535.1251213129465649322.git-patchwork-notify@kernel.org>
Date:   Fri, 16 Dec 2022 10:30:16 +0000
References: <20221215020102.1619685-1-kuba@kernel.org>
In-Reply-To: <20221215020102.1619685-1-kuba@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, jiri@resnulli.us, jacob.e.keller@intel.com
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
by David S. Miller <davem@davemloft.net>:

On Wed, 14 Dec 2022 18:00:59 -0800 you wrote:
> Minor fix for region snapshot locking and adjustments to selftests.
> 
> Jakub Kicinski (3):
>   devlink: hold region lock when flushing snapshots
>   selftests: devlink: fix the fd redirect in dummy_reporter_test
>   selftests: devlink: add a warning for interfaces coming up
> 
> [...]

Here is the summary with links:
  - [net,1/3] devlink: hold region lock when flushing snapshots
    https://git.kernel.org/netdev/net/c/b4cafb3d2c74
  - [net,2/3] selftests: devlink: fix the fd redirect in dummy_reporter_test
    https://git.kernel.org/netdev/net/c/2fc60e2ff972
  - [net,3/3] selftests: devlink: add a warning for interfaces coming up
    https://git.kernel.org/netdev/net/c/d1c4a3469e73

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


