Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D7E552BC28
	for <lists+netdev@lfdr.de>; Wed, 18 May 2022 16:16:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237513AbiERNKQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 May 2022 09:10:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237463AbiERNKP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 May 2022 09:10:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F73617B879
        for <netdev@vger.kernel.org>; Wed, 18 May 2022 06:10:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F279361799
        for <netdev@vger.kernel.org>; Wed, 18 May 2022 13:10:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 5CB06C3411C;
        Wed, 18 May 2022 13:10:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652879413;
        bh=zmbOADcVZYUjFXoeYDVd+/sv5q5xYH3oTXNNYYZY4dU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=b1CLKcJpgrwtvcpaBtnUXSA1K4o9HSUluif/qd38VppKg8F1hIEqaAA9V5VrEuERT
         MJFKuueQzVbOyKT0zS2/jmUfJ3vIHlYIOdWMUC47tWOPSp9tLPlH4Cs/jOLi/BnmnC
         G5gkCyuAK9udc4aVWQLeLzuNOHU3fsvDcMCUS8gocIrQgrcOeCiuXdyuBYQnJS3JLG
         /UJIhyQQUWnwmkmozdZLDMncwzd1u9tNUJV2OtPYnNFy3rZC1mA+v2H5/9VF+tBAJl
         crCHwTVz/35H6bJC1JVuJsX/julCT7zl7TVWalCpU3d+PqnniLTogGUPhZX293QA7v
         sZz3LAIoc+42Q==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 4C958F0392C;
        Wed, 18 May 2022 13:10:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] selftests: netdevsim: Increase sleep time in
 hw_stats_l3.sh test
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165287941331.26952.14298357574723384568.git-patchwork-notify@kernel.org>
Date:   Wed, 18 May 2022 13:10:13 +0000
References: <20220518072726.741777-1-danieller@nvidia.com>
In-Reply-To: <20220518072726.741777-1-danieller@nvidia.com>
To:     Danielle Ratson <danieller@nvidia.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, shuah@kernel.org,
        petrm@nvidia.com, pabeni@redhat.com, mlxsw@nvidia.com
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Wed, 18 May 2022 10:27:26 +0300 you wrote:
> hw_stats_l3.sh test is failing often for l3 stats shows less than 20
> packets after 2 seconds sleep.
> 
> This is happening since there is a race between the 2 seconds sleep and
> the netdevsim actually delivering the packets.
> 
> Increase the sleep time so the packets will be delivered successfully on
> time.
> 
> [...]

Here is the summary with links:
  - [net-next] selftests: netdevsim: Increase sleep time in hw_stats_l3.sh test
    https://git.kernel.org/netdev/net-next/c/7ba106fcd4b4

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


