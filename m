Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA12C674B1D
	for <lists+netdev@lfdr.de>; Fri, 20 Jan 2023 05:44:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229648AbjATEof (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Jan 2023 23:44:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230344AbjATEoD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Jan 2023 23:44:03 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 905B4BFF7E
        for <netdev@vger.kernel.org>; Thu, 19 Jan 2023 20:39:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CA809B820E8
        for <netdev@vger.kernel.org>; Thu, 19 Jan 2023 05:10:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 77EE3C433D2;
        Thu, 19 Jan 2023 05:10:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674105017;
        bh=6hL4kBUaglkdvpIwTmMl3mA4fTWfrfaUHVAPWRfBsi0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=XIjSddnZtQA7hoQaCc9k7ar3JLcJQfxmgveoHFAPiNwYQMG4PmKUxhqA/OX2nDUDV
         2HwEhTtoDLryttrIZ/k70eALkFqBsUNixXIzZfmL2ghagdtbhwd/YggxTMUuJhfJXp
         9jEb9thTJWQ4gBYC6HyZ1Ve+aiMIoObVXF/GIK99bq1Qib6lf9joeyBd8NhAOkaMeq
         E8XZBj6E5uMcr0keIs/jOJLcVixAYJVkP5S0hH2GHmFPQKjfKUdQP3FqJqerdPvLUx
         6E2xx23xsv0EqDkZj64ar6ewWYMcnuWXFiHvF0SHlKczMJ6lDOwDoqUoO9kAhA6FSl
         dIck/azvpmzIg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 53D6AC5C7C4;
        Thu, 19 Jan 2023 05:10:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] MAINTAINERS: add networking entries for Willem
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167410501733.20849.17750108156001750585.git-patchwork-notify@kernel.org>
Date:   Thu, 19 Jan 2023 05:10:17 +0000
References: <20230117190141.60795-1-kuba@kernel.org>
In-Reply-To: <20230117190141.60795-1-kuba@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 17 Jan 2023 11:01:41 -0800 you wrote:
> We often have to ping Willem asking for reviews of patches
> because he doesn't get included in the CC list. Add MAINTAINERS
> entries for some of the areas he covers so that ./scripts/ will
> know to add him.
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> 
> [...]

Here is the summary with links:
  - [net] MAINTAINERS: add networking entries for Willem
    https://git.kernel.org/netdev/net/c/e0be11a833e8

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


