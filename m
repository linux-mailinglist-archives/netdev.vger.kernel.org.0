Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2102E5A0702
	for <lists+netdev@lfdr.de>; Thu, 25 Aug 2022 03:57:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235210AbiHYB52 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Aug 2022 21:57:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235390AbiHYB5I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Aug 2022 21:57:08 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 672599DF8D;
        Wed, 24 Aug 2022 18:51:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7C20EB826EB;
        Thu, 25 Aug 2022 01:50:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id F35F4C433D6;
        Thu, 25 Aug 2022 01:50:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661392214;
        bh=2OGaEduFCiPineSOVVLO6Gwm/s1lSRzTZxkHiQJryrE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Vwa2lyC7ArxTleJP30aahH6kOA9Yh7G7SIGYcY3YypAZBtVSjzJ7ZbYDEt4B2CWuK
         z+pG2boqvVKUTVgJHSjIAIvZNJB1Q97Iw8+GVetLA+8OZT/F0JzIR3HSwQCIRjMWQZ
         S47OIEqK0NUyxplRffs0R/ZooSVOLcn7WY5fv9DAbWT1KBEGgRctoACY8dmqYZH6zC
         TAEzqVmy015vOvEepMFRKazv7WQ8cne46u4sUgMTAD0voshK0u/R+pI+BUM6rPh0Se
         P0ykq1ZakPRf5CYiXTUw8qnK+sB3h2SsteJXZQc/lTpUkRDUuITwWuQA2htt9+FxpQ
         huJmk5L6XXJ6w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id D1685C0C3EC;
        Thu, 25 Aug 2022 01:50:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] MAINTAINERS: rectify file entry in BONDING DRIVER
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166139221385.11258.9501149170982049306.git-patchwork-notify@kernel.org>
Date:   Thu, 25 Aug 2022 01:50:13 +0000
References: <20220824072945.28606-1-lukas.bulwahn@gmail.com>
In-Reply-To: <20220824072945.28606-1-lukas.bulwahn@gmail.com>
To:     Lukas Bulwahn <lukas.bulwahn@gmail.com>
Cc:     jtoppins@redhat.com, jay.vosburgh@canonical.com,
        j.vosburgh@gmail.com, vfalico@gmail.com, andy@greyhouse.net,
        netdev@vger.kernel.org, kuba@kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
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

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 24 Aug 2022 09:29:45 +0200 you wrote:
> Commit c078290a2b76 ("selftests: include bonding tests into the kselftest
> infra") adds the bonding tests in the directory:
> 
>   tools/testing/selftests/drivers/net/bonding/
> 
> The file entry in MAINTAINERS for the BONDING DRIVER however refers to:
> 
> [...]

Here is the summary with links:
  - MAINTAINERS: rectify file entry in BONDING DRIVER
    https://git.kernel.org/netdev/net/c/b09da0126ce0

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


