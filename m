Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 78C8658716C
	for <lists+netdev@lfdr.de>; Mon,  1 Aug 2022 21:30:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234145AbiHATaW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Aug 2022 15:30:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232136AbiHATaT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Aug 2022 15:30:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 856FD330;
        Mon,  1 Aug 2022 12:30:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9B653B81674;
        Mon,  1 Aug 2022 19:30:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 30731C433D6;
        Mon,  1 Aug 2022 19:30:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659382214;
        bh=ssT8OTv2i1c2xMK1/QiGETQ9VivKbrU9Iou5OuLvaLo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=BBXNniCMsZFHga5EOOfi6ZH804GxFPl6s5PrgfhZeVk8BKIXyrmQFWiylWLN2M1pS
         2cd9nPHsJ2wFvJK1mdHa6OIE3T0nYj6WT1hnj6WrK9l5w6xwyYVoYgwb2fLcw8u/9t
         4ij3XP6D9/xa4tHO+Kc3EXSAdk28vHaq1cRD8Ke86APpPkMdqI659aBL2CPq2c0QTf
         8+/cdihzpzjUV6YS6Zw2Wzi1YKrEZLS+mzVCwsUCoT3Zk9pIJFraPDPtzP65sZIcnz
         DFtXlxeXpQXBafZVbLTOf/s9fIxz/uTi+BoXUe2Iek0vXJeE/1uHfDY843GcAXG5E5
         WNTQOHHeOJouA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 124EDC43140;
        Mon,  1 Aug 2022 19:30:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] Documentation: devlink: add add devlink-selftests to
 the table of contents
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165938221407.30942.11853092153259357010.git-patchwork-notify@kernel.org>
Date:   Mon, 01 Aug 2022 19:30:14 +0000
References: <20220730022058.16813-1-bagasdotme@gmail.com>
In-Reply-To: <20220730022058.16813-1-bagasdotme@gmail.com>
To:     Bagas Sanjaya <bagasdotme@gmail.com>
Cc:     netdev@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, jiri@nvidia.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        vikas.gupta@broadcom.com, gospo@broadcom.com, lkp@intel.com
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Sat, 30 Jul 2022 09:20:57 +0700 you wrote:
> Commit 08f588fa301bef ("devlink: introduce framework for selftests") adds
> documentation for devlink selftests framework, but it is missing from
> table of contents.
> 
> Add it.
> 
> Link: https://lore.kernel.org/linux-doc/202207300406.CUBuyN5i-lkp@intel.com/
> Fixes: 08f588fa301bef ("devlink: introduce framework for selftests")
> Reported-by: kernel test robot <lkp@intel.com>
> Signed-off-by: Bagas Sanjaya <bagasdotme@gmail.com>
> 
> [...]

Here is the summary with links:
  - [net-next] Documentation: devlink: add add devlink-selftests to the table of contents
    https://git.kernel.org/netdev/net-next/c/4ff7c8fc81ce

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


