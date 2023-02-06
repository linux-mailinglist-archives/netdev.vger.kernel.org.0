Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A35A068B99B
	for <lists+netdev@lfdr.de>; Mon,  6 Feb 2023 11:13:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230199AbjBFKNJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Feb 2023 05:13:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230222AbjBFKNE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Feb 2023 05:13:04 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3539212AA
        for <netdev@vger.kernel.org>; Mon,  6 Feb 2023 02:12:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BBA3FB80E9A
        for <netdev@vger.kernel.org>; Mon,  6 Feb 2023 10:10:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 63445C433A7;
        Mon,  6 Feb 2023 10:10:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675678221;
        bh=ijH4tJjNbfaEQkRglSN2E4Yb6lxL6Ks2zlwbV+4B4+c=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=u7l4gL1q2M2Lrfsnx4PgjxDONrL6eUpHWozUNDRvxQ8jRYNDL0DwEvNSfQa90ECvd
         njgFhFEUj/AQ3rT9zBNNz+OIuip//DrdZPpzRz84rOS7UNeheJdE8OELaiascnGggg
         XFWn9OYy5GOnxz9hcYdDG6NNJGjmcInLwN1d5OblxPY6ulWQHzEazhmQdHaH9s7HF1
         uKCdQnva2auq/UD61Qt0nZewKafvgTT6sC8IDKdeblhYUZaY0deQTxH8Yp6DF90dUW
         1gjbiHgoQ2TWXfibjFoH59UoaD6kfmood7CsH0dyKyxsTqT95bx/o6iznKV1X2YLHc
         pPX2IygWU0NDg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 4543DE55EFD;
        Mon,  6 Feb 2023 10:10:21 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2] gve: Fix gve interrupt names
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167567822127.32454.1039056357318547988.git-patchwork-notify@kernel.org>
Date:   Mon, 06 Feb 2023 10:10:21 +0000
References: <20230203212045.1298677-1-pkaligineedi@google.com>
In-Reply-To: <20230203212045.1298677-1-pkaligineedi@google.com>
To:     Praveen Kaligineedi <pkaligineedi@google.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        jeroendb@google.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Fri,  3 Feb 2023 13:20:45 -0800 you wrote:
> IRQs are currently requested before the netdevice is registered
> and a proper name is assigned to the device. Changing interrupt
> name to avoid using the format string in the name.
> 
> Interrupt name before change: eth%d-ntfy-block.<blk_id>
> Interrupt name after change: gve-ntfy-blk<blk_id>@pci:<pci_name>
> 
> [...]

Here is the summary with links:
  - [net-next,v2] gve: Fix gve interrupt names
    https://git.kernel.org/netdev/net-next/c/843711459391

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


