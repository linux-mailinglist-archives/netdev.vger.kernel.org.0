Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 375A16E748B
	for <lists+netdev@lfdr.de>; Wed, 19 Apr 2023 10:00:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231524AbjDSIAW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Apr 2023 04:00:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230377AbjDSIAV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Apr 2023 04:00:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DF1149D2
        for <netdev@vger.kernel.org>; Wed, 19 Apr 2023 01:00:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8836C63B98
        for <netdev@vger.kernel.org>; Wed, 19 Apr 2023 08:00:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id DD0A5C4339C;
        Wed, 19 Apr 2023 08:00:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681891218;
        bh=ZpZfEf1/dqMDb0m3a8QVQcUjFMZJDfL4L386bPmuXNg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=EP5HEjsxmaK209zqDY9y8Hg0FZXWkdlollMQWK+mFF558o+mjcMim6Cx7WJPTjcMC
         ghdfPVBxixhsSyco1BMFofEV96zx/PzN9UcbxJS3F4sQVRh16D+KmtluYa/OPrDOev
         DBzQOphbmgBCMYtsG6Oguz2K/rm/tTK/FsdcmMz99/2zX5GqL7OzW3KI53UH/StZ01
         TiWQWj73ao/wPOsuhcqB4YFZ2x88nEWQqP67UZCIIlat1aPxEpEizKS3XuwnODR6MO
         1+BEjnmkR+5FReVm9tyg676cgbofL5J1+kWORbo8Dnyw8dTP/rQbxfjARrja2phCeB
         o4/XbKEAV+FBw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id C17DEE330AB;
        Wed, 19 Apr 2023 08:00:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] bonding: Fix memory leak when changing bond type to
 Ethernet
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168189121878.23437.6270366874822293930.git-patchwork-notify@kernel.org>
Date:   Wed, 19 Apr 2023 08:00:18 +0000
References: <20230417061216.2398529-1-idosch@nvidia.com>
In-Reply-To: <20230417061216.2398529-1-idosch@nvidia.com>
To:     Ido Schimmel <idosch@nvidia.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com, j.vosburgh@gmail.com,
        andy@greyhouse.net, monis@Voltaire.COM, razor@blackwall.org,
        mirsad.todorovac@alu.unizg.hr
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

This patch was applied to netdev/net.git (main)
by David S. Miller <davem@davemloft.net>:

On Mon, 17 Apr 2023 09:12:16 +0300 you wrote:
> When a net device is put administratively up, its 'IFF_UP' flag is set
> (if not set already) and a 'NETDEV_UP' notification is emitted, which
> causes the 8021q driver to add VLAN ID 0 on the device. The reverse
> happens when a net device is put administratively down.
> 
> When changing the type of a bond to Ethernet, its 'IFF_UP' flag is
> incorrectly cleared, resulting in the kernel skipping the above process
> and VLAN ID 0 being leaked [1].
> 
> [...]

Here is the summary with links:
  - [net] bonding: Fix memory leak when changing bond type to Ethernet
    https://git.kernel.org/netdev/net/c/c484fcc058ba

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


