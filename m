Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD3D96084C7
	for <lists+netdev@lfdr.de>; Sat, 22 Oct 2022 07:50:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229535AbiJVFua (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Oct 2022 01:50:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229815AbiJVFu1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Oct 2022 01:50:27 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84643F01AB
        for <netdev@vger.kernel.org>; Fri, 21 Oct 2022 22:50:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 05C7EB82DEA
        for <netdev@vger.kernel.org>; Sat, 22 Oct 2022 05:50:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B761FC433D7;
        Sat, 22 Oct 2022 05:50:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666417818;
        bh=H85iMTshk6immY3T4CG5cb13/9z/WeJT6uPaH4Vtntc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ckxb91IysiNy4lNsGy+o9/4YL27NQHxJ3ihUirwdxSfLxurm4KVuBcAbQx3TRskIM
         1YoIXqbUpRluR7TkyD9mxy36vvF7ZzFDVx27hwCItn5Yv4koiopcXmfRAgSrgfhavj
         WViX9IIrcyVb1BuupsgP7JYc3hdIUMUVFlgJxDbRKifY1HnYQX/db8dCjUYb/KTjTZ
         t62jE6YbC3XqdLK9C63b0/2ndQgFkEopzuGQtaqGpPwSHo6q/DbgbpATyPH4B6J07Y
         jyZQAb2VhDT8eABbC6uioIE6IRSl1HbceD51ndvso6tTKIylsoSdb0PwyjrcjdBVrh
         XgKDH97Ky2ePg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 96CE3E270E2;
        Sat, 22 Oct 2022 05:50:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v3 net 0/5] amd-xgbe: Miscellaneous fixes
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166641781860.12745.2886726965081084372.git-patchwork-notify@kernel.org>
Date:   Sat, 22 Oct 2022 05:50:18 +0000
References: <20221020064215.2341278-1-Raju.Rangoju@amd.com>
In-Reply-To: <20221020064215.2341278-1-Raju.Rangoju@amd.com>
To:     Raju Rangoju <Raju.Rangoju@amd.com>
Cc:     thomas.lendacky@amd.com, Shyam-sundar.S-k@amd.com,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        Rajesh1.Kumar@amd.com
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 20 Oct 2022 12:12:10 +0530 you wrote:
> (1) Fix the rrc for Yellow carp devices. CDR workaround path
>     is disabled for YC devices, receiver reset cycle is not
>     needed in such cases.
> 
> (2) Add enumerations for mailbox command and sub-commands.
>     Instead of using hard-coded values, use enums.
> 
> [...]

Here is the summary with links:
  - [v3,net,1/5] amd-xgbe: Yellow carp devices do not need rrc
    https://git.kernel.org/netdev/net/c/f97fc7ef4146
  - [v3,net,2/5] amd-xgbe: use enums for mailbox cmd and sub_cmds
    https://git.kernel.org/netdev/net/c/1246d0862349
  - [v3,net,3/5] amd-xgbe: enable PLL_CTL for fixed PHY modes only
    https://git.kernel.org/netdev/net/c/fc75c032aee6
  - [v3,net,4/5] amd-xgbe: fix the SFP compliance codes check for DAC cables
    https://git.kernel.org/netdev/net/c/09c5f6bf11ac
  - [v3,net,5/5] amd-xgbe: add the bit rate quirk for Molex cables
    https://git.kernel.org/netdev/net/c/170a9e341a3b

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


