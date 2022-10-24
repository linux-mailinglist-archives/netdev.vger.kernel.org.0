Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A382960AA6F
	for <lists+netdev@lfdr.de>; Mon, 24 Oct 2022 15:35:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232550AbiJXNdU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Oct 2022 09:33:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232662AbiJXNbc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Oct 2022 09:31:32 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CEE5AE849;
        Mon, 24 Oct 2022 05:34:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 45C8CB815BA;
        Mon, 24 Oct 2022 12:10:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id DDD48C4347C;
        Mon, 24 Oct 2022 12:10:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666613416;
        bh=cdCHLXnVCJNJXY7t+Cvw1tsUArAl3Ic0KCr/SKSDfwk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=jsVVa0dX8N6oxjmD6Jcpp/n5z4LFqQrmxd9uwPon8CnHpqi9847Ce/R0gzj0GabVD
         XXXwcG0Iq0J/PM9llUOhhXTAslPDEAkYLml/750g6tCnOFZsOHuQr7e/r2AsiXSIvI
         iA768b020E6rLFZbLaT26MD07M6aHZSgz3+hvRBlM7LPy5oGBpnZY6ucbtQunZL6HS
         o+8n8EtRmsWYU5zH3RQobXm1xiZbZoVsM7YULXdgW4h0dXLUrDI+MgiC61TGOlJ8YO
         M/nCag5HnAnj99/Vjzjgpd1Lk5HMVub3Bu17a70BnNwbFQuRXo6T0Ri9SgbeRsd400
         1/CQSUKkt/PBg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id CBB25C4166D;
        Mon, 24 Oct 2022 12:10:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: fec: Add support for periodic output signal of
 PPS
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166661341683.16761.2803999202840620072.git-patchwork-notify@kernel.org>
Date:   Mon, 24 Oct 2022 12:10:16 +0000
References: <20221020043556.3859006-1-wei.fang@nxp.com>
In-Reply-To: <20221020043556.3859006-1-wei.fang@nxp.com>
To:     Wei Fang <wei.fang@nxp.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, frank.li@nxp.com,
        richardcochran@gmail.com
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Thu, 20 Oct 2022 12:35:56 +0800 you wrote:
> From: Wei Fang <wei.fang@nxp.com>
> 
> This patch adds the support for configuring periodic output
> signal of PPS. So the PPS can be output at a specified time
> and period.
> For developers or testers, they can use the command "echo
> <channel> <start.sec> <start.nsec> <period.sec> <period.
> nsec> > /sys/class/ptp/ptp0/period" to specify time and
> period to output PPS signal.
> Notice that, the channel can only be set to 0. In addtion,
> the start time must larger than the current PTP clock time.
> So users can use the command "phc_ctl /dev/ptp0 -- get" to
> get the current PTP clock time before.
> 
> [...]

Here is the summary with links:
  - [net-next] net: fec: Add support for periodic output signal of PPS
    https://git.kernel.org/netdev/net-next/c/350749b909bf

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


