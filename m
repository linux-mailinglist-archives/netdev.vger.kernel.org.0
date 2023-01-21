Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 85F1767633C
	for <lists+netdev@lfdr.de>; Sat, 21 Jan 2023 04:00:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229720AbjAUDA1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Jan 2023 22:00:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229604AbjAUDAZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Jan 2023 22:00:25 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7F7785365;
        Fri, 20 Jan 2023 19:00:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 38F27B82B8B;
        Sat, 21 Jan 2023 03:00:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id DADF7C433EF;
        Sat, 21 Jan 2023 03:00:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674270018;
        bh=5/isiG1F6F2yJtSuQyZgo2mQgMcrRVRqoNoSGSyeAQU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=WAJwksRRq4L8aC4DWMJF3EC+nlAgYltXlS0Oim6CeMfCb/1MI+Xs5VuicLBAU7G0z
         Rh9LRfFvnRa29EjpNB4Ow/NGybWRpX/9Ovh2T5PgPMwldTrEIfNPZTyMwlCuV9ZrEP
         eA3d3gKZiuEyamcX+o1DogO+OTyMLbZ5b/ri3Er04layFOY0dlis7fPjl41Z06EFKb
         ddD64s/LoXhcgz2hMcjWM02fSEhV3LY2isQ9Sj7FMmV9P/s7Qypkuyw5pz6PJBYVMp
         ytlHF7Baz3afr+8hpfo2tlOxW5yfPpyBmoI523ssA8h37H3Suuc+lCeRDTTjKQG2TX
         bAv1SG2hEh4GQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id C27BFC395DC;
        Sat, 21 Jan 2023 03:00:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2] ptp_qoriq: fix latency in ptp_qoriq_adjtime() operation
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167427001879.13800.13324318173973424453.git-patchwork-notify@kernel.org>
Date:   Sat, 21 Jan 2023 03:00:18 +0000
References: <20230119204034.7969-1-nikhil.gupta@nxp.com>
In-Reply-To: <20230119204034.7969-1-nikhil.gupta@nxp.com>
To:     Nikhil Gupta <nikhil.gupta@nxp.com>
Cc:     linux-arm-kernel@lists.infradead.org, yangbo.lu@nxp.com,
        vladimir.oltean@nxp.com, richardcochran@gmail.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        vakul.garg@nxp.com, rajan.gupta@nxp.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Fri, 20 Jan 2023 02:10:34 +0530 you wrote:
> From: Nikhil Gupta <nikhil.gupta@nxp.com>
> 
> 1588 driver loses about 1us in adjtime operation at PTP slave
> This is because adjtime operation uses a slow non-atomic tmr_cnt_read()
> followed by tmr_cnt_write() operation.
> 
> In the above sequence, since the timer counter operation keeps
> incrementing, it leads to latency. The tmr_offset register
> (which is added to TMR_CNT_H/L register giving the current time)
> must be programmed with the delta nanoseconds.
> 
> [...]

Here is the summary with links:
  - [v2] ptp_qoriq: fix latency in ptp_qoriq_adjtime() operation
    https://git.kernel.org/netdev/net-next/c/24a7fffb2533

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


