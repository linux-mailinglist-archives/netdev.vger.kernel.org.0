Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4FF4574208
	for <lists+netdev@lfdr.de>; Thu, 14 Jul 2022 05:50:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232216AbiGNDuR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jul 2022 23:50:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229473AbiGNDuQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jul 2022 23:50:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 982D62655F
        for <netdev@vger.kernel.org>; Wed, 13 Jul 2022 20:50:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 238EA61E51
        for <netdev@vger.kernel.org>; Thu, 14 Jul 2022 03:50:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 66E41C3411C;
        Thu, 14 Jul 2022 03:50:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657770614;
        bh=Vv+RG997YxJbzouzg3So9ANf2gMgXEwOmxyYGCcyeOo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=PQTBbh5h4DnqBOuNYJ+8Nq1SWYO5BnZrmbtPl6pOiGKQd0UkoT9KIgpqyHT+17y73
         ZSh9TbkzYIoUBSuGom+3GwgzHuNqUU/9+/9+9uUStPYiUKalef7TGdtTeZEUhFRIk2
         W7dvrLJwFDPvmdeuzAydfu8rBC+ojZqIkJp+qgzzRkXhWRITCwx4vidFwq5bdR2hDY
         fI2VSFoVSkMGb/kygY2IlTan36Z2RH46+ij9wJ9KHB458u81QTneb3M7kIMWkJEH/Q
         nq9kwEPYnX4G9r1oX5QNcAszBxI9eke953IvaW3v49QBzarz2EsJ64TZR0HMfKozeA
         mnI3urm8jfrbg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 3B36DE45225;
        Thu, 14 Jul 2022 03:50:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/2][pull request] Intel Wired LAN Driver Updates
 2022-07-12
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165777061423.21676.16412315341068770256.git-patchwork-notify@kernel.org>
Date:   Thu, 14 Jul 2022 03:50:14 +0000
References: <20220712164829.7275-1-anthony.l.nguyen@intel.com>
In-Reply-To: <20220712164829.7275-1-anthony.l.nguyen@intel.com>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, netdev@vger.kernel.org
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (master)
by Tony Nguyen <anthony.l.nguyen@intel.com>:

On Tue, 12 Jul 2022 09:48:27 -0700 you wrote:
> This series contains updates to ice driver only.
> 
> Paul fixes detection of E822 devices for firmware update and changes NVM
> read for snapshot creation to be done in chunks as some systems cannot
> read the entire NVM in the allotted time.
> 
> The following are changes since commit f946964a9f79f8dcb5a6329265281eebfc23aee5:
>   net: marvell: prestera: fix missed deinit sequence
> and are available in the git repository at:
>   git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/net-queue 100GbE
> 
> [...]

Here is the summary with links:
  - [net,1/2] ice: handle E822 generic device ID in PLDM header
    https://git.kernel.org/netdev/net/c/f52d166819a4
  - [net,2/2] ice: change devlink code to read NVM in blocks
    https://git.kernel.org/netdev/net/c/7b6f9462a323

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


