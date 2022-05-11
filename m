Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B00D524044
	for <lists+netdev@lfdr.de>; Thu, 12 May 2022 00:30:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348760AbiEKWaW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 May 2022 18:30:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348751AbiEKWaR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 May 2022 18:30:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B33320CDAE
        for <netdev@vger.kernel.org>; Wed, 11 May 2022 15:30:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AB326B82641
        for <netdev@vger.kernel.org>; Wed, 11 May 2022 22:30:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 5DD6EC34116;
        Wed, 11 May 2022 22:30:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652308213;
        bh=l2vuG3/CDuDwGit+CM7BmZ1VfjxfaeA7tweJHxqX6GA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=dT5REhB2npkjB0oX3R5AUsXPwIzp3ngoLWDXl5zIac60cN19hn2KAXCHoBRVVY+pL
         98mCF7IvR87ulbBChWZvvqE1VkpuyK5zbMmns8Ze82PQW6tz2DWMYTl0DNQQdzF+sN
         lNbgvEKokU8xCoHOqV9TFh7OTgr+jPGoK7yZxWHEt+gmbvIFVZB1khVZrXt9QB05O3
         WiW5xYlbzd+p41SuI8AnU1vAl7Nm11k7X6ibf0wic25BzzD1u7d/e6UpNmpuC0QSFe
         eza4Rk7+vAR6fMKd0f/aAMhRCWaPMrTrvLYOyvqv0Hj/bVjDTGS6ae3rY6HErj7YAA
         Vad9Zc+CL0Axg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 43196F03933;
        Wed, 11 May 2022 22:30:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/3][pull request] 1GbE Intel Wired LAN Driver
 Updates 2022-05-10
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165230821327.9762.14528839058570975303.git-patchwork-notify@kernel.org>
Date:   Wed, 11 May 2022 22:30:13 +0000
References: <20220510210656.2168393-1-anthony.l.nguyen@intel.com>
In-Reply-To: <20220510210656.2168393-1-anthony.l.nguyen@intel.com>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, netdev@vger.kernel.org, sasha.neftin@intel.com
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

This series was applied to netdev/net-next.git (master)
by Tony Nguyen <anthony.l.nguyen@intel.com>:

On Tue, 10 May 2022 14:06:53 -0700 you wrote:
> This series contains updates to igc driver only.
> 
> Sasha cleans up the code by removing an unused function and removing an
> enum for PHY type as there is only one PHY. The return type for
> igc_check_downshift() is changed to void as it always returns success.
> 
> The following are changes since commit ecd17a87eb78b5bd5ca6d1aa20c39f2bc3591337:
>   x25: remove redundant pointer dev
> and are available in the git repository at:
>   git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue 1GbE
> 
> [...]

Here is the summary with links:
  - [net-next,1/3] igc: Remove igc_set_spd_dplx method
    https://git.kernel.org/netdev/net-next/c/d098538ed4e8
  - [net-next,2/3] igc: Remove unused phy_type enum
    https://git.kernel.org/netdev/net-next/c/7241069f7a07
  - [net-next,3/3] igc: Change type of the 'igc_check_downshift' method
    https://git.kernel.org/netdev/net-next/c/95073d08154a

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


