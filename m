Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77DEC60C716
	for <lists+netdev@lfdr.de>; Tue, 25 Oct 2022 11:00:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231611AbiJYJAU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Oct 2022 05:00:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230090AbiJYJAT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Oct 2022 05:00:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1A454C2DE
        for <netdev@vger.kernel.org>; Tue, 25 Oct 2022 02:00:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7A6D261812
        for <netdev@vger.kernel.org>; Tue, 25 Oct 2022 09:00:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C6190C433D7;
        Tue, 25 Oct 2022 09:00:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666688417;
        bh=nEU0kmdCWy5OZVlwElDSKdLzd8/bzGc4gk6n+N3fTZo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=P52pX9ytS7sS/OlGxnPVoCYNwE4CnBYrfQsoDbPr5J+9wbQ0Xnq9MYjhmz7e4pOr2
         BsnIaCwGBv1EPkSnVvQzBEUk+ufrhQQTlOEf5rb8L/QZwRiL5/SqLAfENGcj6mYrX1
         wHb/KN4aV/cqJob0f0t6VwfFmIMJeeXPgyWExQSBEEeCnAio78Mma0woso+gu4ORgc
         2Wiuz16fyjqn7DlIf0i9GkfKKK8hkoRW2qEtbGEzA6p/LBMjtjmAvJ+LSU+ZyvNAgS
         KjjA6rexiUllv+MsoWAUXeVwL0rEMKAy0GK6z1yY0FSJP0QrGZyHaqRjlWi3Jce1K9
         2mjy8tAyzNmGw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 9A68FE451B2;
        Tue, 25 Oct 2022 09:00:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net-next PATCH v3 0/3] Extend action skbedit to RX queue mapping
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166668841762.31681.15742501889552591102.git-patchwork-notify@kernel.org>
Date:   Tue, 25 Oct 2022 09:00:17 +0000
References: <166633888716.52141.3425659377117969638.stgit@anambiarhost.jf.intel.com>
In-Reply-To: <166633888716.52141.3425659377117969638.stgit@anambiarhost.jf.intel.com>
To:     Amritha Nambiar <amritha.nambiar@intel.com>
Cc:     netdev@vger.kernel.org, kuba@kernel.org, alexander.duyck@gmail.com,
        jhs@mojatatu.com, jiri@resnulli.us, xiyou.wangcong@gmail.com,
        vinicius.gomes@intel.com, sridhar.samudrala@intel.com
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by Paolo Abeni <pabeni@redhat.com>:

On Fri, 21 Oct 2022 00:58:34 -0700 you wrote:
> Based on the discussion on
> https://lore.kernel.org/netdev/166260012413.81018.8010396115034847972.stgit@anambiarhost.jf.intel.com/ ,
> the following series extends skbedit tc action to RX queue mapping.
> Currently, skbedit action in tc allows overriding of transmit queue.
> Extending this ability of skedit action supports the selection of
> receive queue for incoming packets. On the receive side, this action
> is supported only in hardware, so the skip_sw flag is enforced.
> 
> [...]

Here is the summary with links:
  - [net-next,v3,1/3] act_skbedit: skbedit queue mapping for receive queue
    https://git.kernel.org/netdev/net-next/c/4a6a676f8c16
  - [net-next,v3,2/3] ice: Enable RX queue selection using skbedit action
    https://git.kernel.org/netdev/net-next/c/143b86f346c7
  - [net-next,v3,3/3] Documentation: networking: TC queue based filtering
    https://git.kernel.org/netdev/net-next/c/d5ae8ecf3832

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


