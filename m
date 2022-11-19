Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5497B630B8F
	for <lists+netdev@lfdr.de>; Sat, 19 Nov 2022 04:53:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232999AbiKSDx4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Nov 2022 22:53:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233499AbiKSDxU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Nov 2022 22:53:20 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2B3BC284F
        for <netdev@vger.kernel.org>; Fri, 18 Nov 2022 19:50:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CFEA96281D
        for <netdev@vger.kernel.org>; Sat, 19 Nov 2022 03:50:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 2F0FEC433C1;
        Sat, 19 Nov 2022 03:50:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668829818;
        bh=FF1yYs+fwyhpZ3s1iodKKbZfXgXwDfbDHOanhjnzeyY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=XzwHGQxAW7AxgJm7nyHLwEKIs38twOK5FbwivQyCDV9vsd2uvgVLRz8U4+tWw+/z/
         IxIFFfc0qJIILZ4QC+UYZScWdcv5IEpEIA19QgQM4nCtVyojzXRByG119GfaI1kE2K
         Uusfs5TqQqSo+JycUg00uXpfaZw7KJKnld8elvU2oP0Z943ecXMt4ZC+wU7rC2OAMf
         5H5mz+8We+2AuVeTfpC1PSjhMERZolCOlqTBa2qhfR8zWU/CBl8AgBrYhwGr/2kMed
         ef4YYAK5AeM27qoRZwtQR5rf2WDGjHTl0119wZZIyOnsSjfIHgDHE+Ks1Qn0gjyNVl
         p1Ukahh45OvWA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 14994E270F6;
        Sat, 19 Nov 2022 03:50:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/2] nfp: fixes for v6.1
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166882981807.27279.2575656239751297628.git-patchwork-notify@kernel.org>
Date:   Sat, 19 Nov 2022 03:50:18 +0000
References: <20221117153744.688595-1-simon.horman@corigine.com>
In-Reply-To: <20221117153744.688595-1-simon.horman@corigine.com>
To:     Simon Horman <simon.horman@corigine.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, oss-drivers@corigine.com
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
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 17 Nov 2022 16:37:42 +0100 you wrote:
> Hi,
> 
> this short series addresses two bugs in the NFP driver.
> 
> PATCH 1/2: Ensure that information displayed by "devlink port show"
>            reflects the number of lanes available to be split.
> 
> [...]

Here is the summary with links:
  - [net,1/2] nfp: fill splittable of devlink_port_attrs correctly
    https://git.kernel.org/netdev/net/c/4abd9600b9d1
  - [net,2/2] nfp: add port from netdev validation for EEPROM access
    https://git.kernel.org/netdev/net/c/0873016d46f6

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


