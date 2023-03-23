Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2DE9F6C5D89
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 04:51:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230385AbjCWDvN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Mar 2023 23:51:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230248AbjCWDue (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Mar 2023 23:50:34 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F33CB30296;
        Wed, 22 Mar 2023 20:50:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2125CB81EDE;
        Thu, 23 Mar 2023 03:50:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D4F15C4339C;
        Thu, 23 Mar 2023 03:50:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679543419;
        bh=rJHuAmc6zW3jrRyme6qDkmwRksSKBXtraiFpAQLkVcI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=YSbU/LTbRVMvxVPXzb9jIO3ZiJIT8a+cdYTH1XxeaMMALkYACmKq9VG97aoQtq7Gn
         0FtxfA9kEVuJ9YlTNvfaFNgmjsi4DSX74M13m4ZfLYAqJj7D/6nJK93+Hm1RBJp/5D
         Cjg8YkU6E2mAKsY41O9tr37+47JFsWLQWTcUYQhZ/2zXCG4kUtZOmEtBKaccnWGw6b
         kX4QjJxMdcAqsE5YZEJ3J9okbNttkNPQpx44E+rzEHU4CVIxTvk+49eFdjwoaLTRa4
         uFOGKPNLW5DQXlDtnInhoz/8Xs0OKBgmvR3cRgGqBsDOCoVNjFivYUhwqvyaEfsqFl
         wX8rOp8xWXJTA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id BE309E61B85;
        Thu, 23 Mar 2023 03:50:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] ethernet: remove superfluous clearing of phydev
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167954341977.25225.18115905637742763072.git-patchwork-notify@kernel.org>
Date:   Thu, 23 Mar 2023 03:50:19 +0000
References: <20230321131745.27688-1-wsa+renesas@sang-engineering.com>
In-Reply-To: <20230321131745.27688-1-wsa+renesas@sang-engineering.com>
To:     Wolfram Sang <wsa+renesas@sang-engineering.com>
Cc:     netdev@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, bryan.whitehead@microchip.com,
        UNGLinuxDriver@microchip.com, s.shtylyov@omp.ru,
        steve.glendinning@shawell.net, wellslutw@gmail.com,
        linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 21 Mar 2023 14:17:45 +0100 you wrote:
> phy_disconnect() calls phy_detach() which already clears 'phydev' if it
> is attached to a struct net_device.
> 
> Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
> ---
> 
> Tested with an Renesas APE6-EK (SMSC911x). Because this is more of a
> mechanical change, I opted to put all occurences into one patch. I can
> break out, of course, if this is preferred.
> 
> [...]

Here is the summary with links:
  - [net-next] ethernet: remove superfluous clearing of phydev
    https://git.kernel.org/netdev/net-next/c/22f5c234141d

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


