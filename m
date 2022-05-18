Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A8B852AF8A
	for <lists+netdev@lfdr.de>; Wed, 18 May 2022 03:00:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233089AbiERBAP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 May 2022 21:00:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232262AbiERBAO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 May 2022 21:00:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6B435401C;
        Tue, 17 May 2022 18:00:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 54D60615D1;
        Wed, 18 May 2022 01:00:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id AEC3AC34117;
        Wed, 18 May 2022 01:00:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652835612;
        bh=hRSWUQy2B7VTjDHpomlTwwG+3bjN81RQApR4V7eOuLc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=bhAvssdfzzxmHC69e8r1n8ZmS6JewH/6LGOWa0BL/9IPmuyMabUc/Lowsi46l1UhJ
         QWZxcJZEpXk8rw3uNi7XNdNMDRWp7rIvXMlMvqAGXJGS+lajsNf5eIFAxQtbBL+X0Z
         /N9gXE78FfhvSZ4O0Ia3BOZFoWckv3Cx49u4wpBmMYqu+gBxHLX2jW+qXDNiPPWdfW
         DJjaK8i62eeRRxmLm1tw8tkCSGQfJEPTOyf2cIWnbA8bRPkZ+TPfJdpMU9K8+WgniT
         mpKPfFCD7wF7jYz9NdzGt8Aw3gROsngrO7qfmjabNE6owmFlJS8LozONFYh0875dqq
         2JfzdVPw3EZ9g==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 93164F0389D;
        Wed, 18 May 2022 01:00:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v6 1/2] ptp: ptp_clockmatrix: Add PTP_CLK_REQ_EXTTS
 support
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165283561259.28988.13999615912204869168.git-patchwork-notify@kernel.org>
Date:   Wed, 18 May 2022 01:00:12 +0000
References: <1652712427-14703-1-git-send-email-min.li.xe@renesas.com>
In-Reply-To: <1652712427-14703-1-git-send-email-min.li.xe@renesas.com>
To:     Min Li <min.li.xe@renesas.com>
Cc:     richardcochran@gmail.com, lee.jones@linaro.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
by Jakub Kicinski <kuba@kernel.org>:

On Mon, 16 May 2022 10:47:06 -0400 you wrote:
> Use TOD_READ_SECONDARY for extts to keep TOD_READ_PRIMARY
> for gettime and settime exclusively. Before this change,
> TOD_READ_PRIMARY was used for both extts and gettime/settime,
> which would result in changing TOD read/write triggers between
> operations. Using TOD_READ_SECONDARY would make extts
> independent of gettime/settime operation
> 
> [...]

Here is the summary with links:
  - [net,v6,1/2] ptp: ptp_clockmatrix: Add PTP_CLK_REQ_EXTTS support
    https://git.kernel.org/netdev/net-next/c/bec67592521e
  - [net,v6,2/2] ptp: ptp_clockmatrix: return -EBUSY if phase pull-in is in progress
    https://git.kernel.org/netdev/net-next/c/7c7dcd66c5e0

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


