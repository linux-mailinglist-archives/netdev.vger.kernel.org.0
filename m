Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D95944D611C
	for <lists+netdev@lfdr.de>; Fri, 11 Mar 2022 13:00:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348457AbiCKMBW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Mar 2022 07:01:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239962AbiCKMBV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Mar 2022 07:01:21 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E10031AA49B
        for <netdev@vger.kernel.org>; Fri, 11 Mar 2022 04:00:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 366F2CE26CB
        for <netdev@vger.kernel.org>; Fri, 11 Mar 2022 12:00:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 293C6C340EE;
        Fri, 11 Mar 2022 12:00:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647000013;
        bh=lVH2cu/7teMphcwg8e30Fpy7QjTzLSoUuiHKAndAITE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=bkr7B0LSacD049iIH0CaPOqjdWEHCpaEctQIrFTek4MgbtpAFSADab04UDlyxhRLa
         hNoezuxqniakEoas0ZPXRAyx1RGDIsJ/NhEr2mLgfosSZOVHMYkg0yQzGfgyGEg+6n
         jqzA7BBG5p2QBlRPcEyIamQj/7H7/RQvre60nTdq9oB/Qaomzz1DE4WP8m9a7AUHC2
         HmKqvjVk59XIpUoI0xzda1nhoETXKVFeOpWJ08a3fAcxBWYUzHXKYgH6Y1Xx47P8qx
         h5BrLSejFo/MuUUjSLiK+DrS+jKRHJ/rPePR0r84JgxA06BUq1rI4EsbaDtFPTo5P+
         Gy1slh+ehFENg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 01ECCE8DD5B;
        Fri, 11 Mar 2022 12:00:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2 00/10] ptp: ocp: support for new firmware
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164700001300.30031.1743387265026229019.git-patchwork-notify@kernel.org>
Date:   Fri, 11 Mar 2022 12:00:13 +0000
References: <20220310201912.933172-1-jonathan.lemon@gmail.com>
In-Reply-To: <20220310201912.933172-1-jonathan.lemon@gmail.com>
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

This series was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Thu, 10 Mar 2022 12:19:02 -0800 you wrote:
> This series contains support for new firmware features for
> the timecard.
> 
> v1 -> v2: roundup() is not 32-bit safe, use DIV_ROUND_UP_ULL
> 
> Jonathan Lemon (10):
>   ptp: ocp: Add support for selectable SMA directions.
>   ptp: ocp: Add ability to disable input selectors.
>   ptp: ocp: Rename output selector 'GNSS' to 'GNSS1'
>   ptp: ocp: Add GND and VCC output selectors
>   ptp: ocp: Add firmware capability bits for feature gating
>   ptp: ocp: Add signal generators and update sysfs nodes
>   ptp: ocp: Program the signal generators via PTP_CLK_REQ_PEROUT
>   ptp: ocp: Add 4 frequency counters
>   ptp: ocp: Add 2 more timestampers
>   docs: ABI: Document new timecard sysfs nodes.
> 
> [...]

Here is the summary with links:
  - [net-next,v2,01/10] ptp: ocp: Add support for selectable SMA directions.
    (no matching commit)
  - [net-next,v2,02/10] ptp: ocp: Add ability to disable input selectors.
    https://git.kernel.org/netdev/net-next/c/b2c4f0ac53f3
  - [net-next,v2,03/10] ptp: ocp: Rename output selector 'GNSS' to 'GNSS1'
    https://git.kernel.org/netdev/net-next/c/be69087ce675
  - [net-next,v2,04/10] ptp: ocp: Add GND and VCC output selectors
    https://git.kernel.org/netdev/net-next/c/cd09193ffbf8
  - [net-next,v2,05/10] ptp: ocp: Add firmware capability bits for feature gating
    https://git.kernel.org/netdev/net-next/c/c205d53c4923
  - [net-next,v2,06/10] ptp: ocp: Add signal generators and update sysfs nodes
    https://git.kernel.org/netdev/net-next/c/b325af3cfab9
  - [net-next,v2,07/10] ptp: ocp: Program the signal generators via PTP_CLK_REQ_PEROUT
    https://git.kernel.org/netdev/net-next/c/1aa66a3a135a
  - [net-next,v2,08/10] ptp: ocp: Add 4 frequency counters
    https://git.kernel.org/netdev/net-next/c/2407f5d62017
  - [net-next,v2,09/10] ptp: ocp: Add 2 more timestampers
    https://git.kernel.org/netdev/net-next/c/0fa3ff7eb02a
  - [net-next,v2,10/10] docs: ABI: Document new timecard sysfs nodes.
    https://git.kernel.org/netdev/net-next/c/ff1d56cb2653

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


