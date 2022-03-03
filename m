Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D1CA4CC05C
	for <lists+netdev@lfdr.de>; Thu,  3 Mar 2022 15:50:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234140AbiCCOvG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Mar 2022 09:51:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233979AbiCCOvD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Mar 2022 09:51:03 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75BF918F233
        for <netdev@vger.kernel.org>; Thu,  3 Mar 2022 06:50:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E7ADDB825FF
        for <netdev@vger.kernel.org>; Thu,  3 Mar 2022 14:50:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8F758C340E9;
        Thu,  3 Mar 2022 14:50:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646319014;
        bh=Ymn0W+zXRSwfAEN17SZfoz2GdEljSKb8SkMo+P5MFrQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=JynwVsVbFy2jZwKcN7Mtons6ugY4k+AzQSOI4EIRdUUmrjOApEX5P2pnt5v2Go1L9
         3A5Z7GWtHJqv53uSJSB1tE621ahcWQE47/AlQRNKwtr05IgEufIvwFad3RmYo8Jnq3
         nk8rLA0eeXiRMEuZu1tgpmzLYR0Bl7gohnva3NCVmkBIZRXItgkqFDS4kOjBRQcReV
         7tZH0kxjZZdDpr/uICqbjBKuOnIsonGShYSXJEJ+9z/Iw1ixccFpJWF7DRLbd5LByA
         FW94eYkkqM+KdFux6gAwclI6pcMP99HiindNYgnZE3i9PgBh0zM4erDXis6aOYj/V+
         stjW7Eh+ZrHAA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 72233E5D087;
        Thu,  3 Mar 2022 14:50:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/5] ptp: ocp: TOD and monitoring updates
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164631901446.29171.13402566863234410160.git-patchwork-notify@kernel.org>
Date:   Thu, 03 Mar 2022 14:50:14 +0000
References: <20220302213459.6565-1-jonathan.lemon@gmail.com>
In-Reply-To: <20220302213459.6565-1-jonathan.lemon@gmail.com>
To:     Jonathan Lemon <jonathan.lemon@gmail.com>
Cc:     netdev@vger.kernel.org, richardcochran@gmail.com,
        davem@davemloft.net, kuba@kernel.org, kernel-team@fb.com
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
by David S. Miller <davem@davemloft.net>:

On Wed,  2 Mar 2022 13:34:54 -0800 you wrote:
> Add a series of patches for monitoring the status of the
> driver and adjusting TOD handling, especially around leap seconds.
> 
> Add documentation for the new sysfs nodes.
> 
> Jonathan Lemon (1):
>   docs: ABI: Document new timecard sysfs nodes.
> 
> [...]

Here is the summary with links:
  - [net-next,1/5] ptp: ocp: add TOD debug information
    https://git.kernel.org/netdev/net-next/c/9f492c4cb235
  - [net-next,2/5] ptp: ocp: Expose clock status drift and offset
    https://git.kernel.org/netdev/net-next/c/2f23f486cf62
  - [net-next,3/5] ptp: ocp: add tod_correction attribute
    https://git.kernel.org/netdev/net-next/c/44a412d13b31
  - [net-next,4/5] ptp: ocp: adjust utc_tai_offset to TOD info
    https://git.kernel.org/netdev/net-next/c/e68462a0d99d
  - [net-next,5/5] docs: ABI: Document new timecard sysfs nodes.
    https://git.kernel.org/netdev/net-next/c/4db073174f95

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


