Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 43012688024
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 15:30:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232176AbjBBOaW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Feb 2023 09:30:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232098AbjBBOaW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Feb 2023 09:30:22 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF3A544B2
        for <netdev@vger.kernel.org>; Thu,  2 Feb 2023 06:30:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8DA62B82680
        for <netdev@vger.kernel.org>; Thu,  2 Feb 2023 14:30:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 31B73C4339C;
        Thu,  2 Feb 2023 14:30:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675348218;
        bh=bUP7CTRlA8JD+TzJMv4msB6hRjkuiXOjt1CBXqA3fl0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=h94HdDR4mtM+lDFDlBKVcBPrf3MDmSxs0jgQCBqULoW+otV4xKrKvFGMEq9Zz69cn
         4b7AmJkmmIBrSFCcXspNu4j1EQ8z8addcMSBzszrzVT/AeEj3aZWMn5PNKo1n2Nu/z
         xtyT8Q4Hf4Ryfaa3hBwrD253VknnI0rG5WeFzStLV6OCe1jW8jutG78rQ0yV2JzYIx
         voxNuTTKeKszol9auO2y36fpHFoQ3s0de40MmGrh3pNhEHX/0jLm2uNou3Wxz65Fwh
         hsWcG6ZybcLeDgGAOuDP9ceyUt8evPxmzZi8SRN4LdnNtYIiHbam23W51qC29dvuLw
         VoHKZU+Mzo1FA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 16667C0C40E;
        Thu,  2 Feb 2023 14:30:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2 0/2] amd-xgbe: add support for 2.5GbE and
 rx-adaptation
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167534821808.12052.909511830779066046.git-patchwork-notify@kernel.org>
Date:   Thu, 02 Feb 2023 14:30:18 +0000
References: <20230201054932.212700-1-Raju.Rangoju@amd.com>
In-Reply-To: <20230201054932.212700-1-Raju.Rangoju@amd.com>
To:     Raju Rangoju <Raju.Rangoju@amd.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        edumazet@google.com, pabeni@redhat.com, Shyam-sundar.S-k@amd.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by Paolo Abeni <pabeni@redhat.com>:

On Wed, 1 Feb 2023 11:19:30 +0530 you wrote:
> This patch series adds support for 2.GbE in 10GBaseT mode and
> rx-adaptation support for Yellow Carp devices.
> 
> 1) Support for 2.5GbE:
>    Add the necessary changes to the driver to fully recognize and enable
>    2.5GbE speed in 10GBaseT mode.
> 
> [...]

Here is the summary with links:
  - [net-next,v2,1/2] amd-xgbe: add 2.5GbE support to 10G BaseT mode
    https://git.kernel.org/netdev/net-next/c/3ee217c47b8b
  - [net-next,v2,2/2] amd-xgbe: add support for rx-adaptation
    https://git.kernel.org/netdev/net-next/c/4f3b20bfbb75

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


