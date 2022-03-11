Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8918F4D59B9
	for <lists+netdev@lfdr.de>; Fri, 11 Mar 2022 05:41:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236877AbiCKElQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Mar 2022 23:41:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233332AbiCKElP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Mar 2022 23:41:15 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3292FEBAFF
        for <netdev@vger.kernel.org>; Thu, 10 Mar 2022 20:40:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C3C7B619C5
        for <netdev@vger.kernel.org>; Fri, 11 Mar 2022 04:40:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 1F488C340F3;
        Fri, 11 Mar 2022 04:40:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646973611;
        bh=+k3iCe5w8O92UwGBp775mNvesb1Q0nh+bDKQz82l9dc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=a2SZ4Gc9TWbIgzFav6iYzLi9QDwPjpp8AhEVaA8gjxK9gGoDglUJNdLc3DW0NMOUZ
         guzVY9DRAmQXApjfqSuanu5clWyUfMjeyW8779Jv38zesKnkKDo+8FuR1hC8TTW/Nk
         JV3u2xXD7dkHzZ62fIWuKNzwrIbzOIN6um9CfYEryrwx9u1S8Z0t+RmMc32DFsj0rf
         kyU6BokZujkZOPBYmk3uQc2YNjj7HT7tSN9cf2VkH6m01uzfsa4RtU4LRVaRBrCNqr
         B4MAVlcnNQd41IOvUM7fN2JvX4UEDHc8BCJk9PFayMJYcnqd/fbCGBJJL6p/CwktcT
         krPtKy6/0zyHw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 05A68E8DD5B;
        Fri, 11 Mar 2022 04:40:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] ptp: ocp: add UPF_NO_THRE_TEST flag for serial ports
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164697361101.17229.12244359500567675468.git-patchwork-notify@kernel.org>
Date:   Fri, 11 Mar 2022 04:40:11 +0000
References: <20220309223427.34745-1-jonathan.lemon@gmail.com>
In-Reply-To: <20220309223427.34745-1-jonathan.lemon@gmail.com>
To:     Jonathan Lemon <jonathan.lemon@gmail.com>
Cc:     netdev@vger.kernel.org, kuba@kernel.org, davem@davemloft.net,
        richardcochran@gmail.com, kernel-team@fb.com
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Wed,  9 Mar 2022 14:34:27 -0800 you wrote:
> From: Jonathan Lemon <bsd@fb.com>
> 
> The serial port driver attempts to test for correct THRE behavior
> on startup.  However, it does this by disabling interrupts, and
> then intentionally trying to trigger an interrupt in order to see
> if the IIR bit is set in the UART.
> 
> [...]

Here is the summary with links:
  - [net-next] ptp: ocp: add UPF_NO_THRE_TEST flag for serial ports
    https://git.kernel.org/netdev/net-next/c/c17c4059df24

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


