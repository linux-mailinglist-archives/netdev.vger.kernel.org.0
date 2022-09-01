Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B7C7B5A8B76
	for <lists+netdev@lfdr.de>; Thu,  1 Sep 2022 04:30:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232881AbiIACa1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Aug 2022 22:30:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232882AbiIACaV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Aug 2022 22:30:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F01D40E2E
        for <netdev@vger.kernel.org>; Wed, 31 Aug 2022 19:30:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DA17161DBD
        for <netdev@vger.kernel.org>; Thu,  1 Sep 2022 02:30:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 33B57C433D7;
        Thu,  1 Sep 2022 02:30:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661999415;
        bh=0FtPRRCR+hwPpfevd8Nh6lf1okppwuwDZEbnpsKadQQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=LDb9FPonAKQdNfukekEy5Iaw8Km7fuxXDBF2tUIynFq31TpwrRcLyOV1qp0bUpbuK
         Wh3IcpajjBDAt0ye0eqpXygMdIJJ8ibw2nAX6W2bj2cOJXp1rZJQWEbLpZd+CCJt8U
         WHlpIP41Sw1enVK4/gyvTDQf9j7b/BXmTHoTKevdaWo8ZpkhVt1ZW7v+RtVvoHVq/8
         2ziVlrD1qXgTUXbie8AqqGjYx5QbEqeH1+Qqldnm8vLnxXYbSSJoMNndusxxiaBcRp
         1BU9jZOoTJREgip7qY0jgs81hmePgHZ+yb/Q0QjL9l8j0fDpRKsxfDAQc5xnCttU5I
         xOHB9QFUs0vLA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 0CDE6E924D6;
        Thu,  1 Sep 2022 02:30:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: axienet: Switch to 64-bit RX/TX statistics
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166199941504.15840.7860646767848460996.git-patchwork-notify@kernel.org>
Date:   Thu, 01 Sep 2022 02:30:15 +0000
References: <20220829233901.3429419-1-robert.hancock@calian.com>
In-Reply-To: <20220829233901.3429419-1-robert.hancock@calian.com>
To:     Robert Hancock <robert.hancock@calian.com>
Cc:     radhey.shyam.pandey@xilinx.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        michal.simek@xilinx.com, linux@armlinux.org.uk,
        netdev@vger.kernel.org
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

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Mon, 29 Aug 2022 17:39:01 -0600 you wrote:
> The RX and TX byte/packet statistics in this driver could be overflowed
> relatively quickly on a 32-bit platform. Switch these stats to use the
> u64_stats infrastructure to avoid this.
> 
> Signed-off-by: Robert Hancock <robert.hancock@calian.com>
> ---
>  drivers/net/ethernet/xilinx/xilinx_axienet.h  | 12 ++++++
>  .../net/ethernet/xilinx/xilinx_axienet_main.c | 37 +++++++++++++++++--
>  2 files changed, 45 insertions(+), 4 deletions(-)

Here is the summary with links:
  - [net-next] net: axienet: Switch to 64-bit RX/TX statistics
    https://git.kernel.org/netdev/net-next/c/cb45a8bf4693

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


