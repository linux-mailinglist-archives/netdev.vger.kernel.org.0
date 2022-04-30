Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C6AC5159AC
	for <lists+netdev@lfdr.de>; Sat, 30 Apr 2022 03:51:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382052AbiD3Bxl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Apr 2022 21:53:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1382033AbiD3Bxf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Apr 2022 21:53:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 407AF6146
        for <netdev@vger.kernel.org>; Fri, 29 Apr 2022 18:50:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0795D624B1
        for <netdev@vger.kernel.org>; Sat, 30 Apr 2022 01:50:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 63897C385B7;
        Sat, 30 Apr 2022 01:50:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651283412;
        bh=tQ/5uGt4ue2+Mi/FyIPgN+CLvm66oH76nZ8ozX4/zGk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=KuCNVFtG0FN/FW14PX3Zmj38fMMUFrUPTZKfivywT7MF0DIaED2vSlmuMSR04Nqt9
         hgrh1WcNSMsg58BrINlXp/2s5ITe5s/7Vf2oamHdNzrwbGLWpe7/uW2PkB1k4HA1XP
         TTy2F9mruOXmhXgycssrGamWE1Ual8JvHry4GsYpsQyMM5QzdKqG24RbSYqi1y4Cg6
         Ma4WwswPxKYASabQbfhBV09L6UonUGg4QClV23fAMMGEL8yWc2irsfDxWd6bExhXim
         eemohnVVR4Hh2W3lupaCImbC5p9VrrJYYhQy0I/cIXugZl2LTItuG7bPrcK02Yl9Tm
         SbHMbedlEvBOg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 4EAFFF0383D;
        Sat, 30 Apr 2022 01:50:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 net-next] nfp: flower: utilize the tuple iifidx in
 offloading ct flows
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165128341231.13664.13201000304388121550.git-patchwork-notify@kernel.org>
Date:   Sat, 30 Apr 2022 01:50:12 +0000
References: <20220429075124.128589-1-simon.horman@corigine.com>
In-Reply-To: <20220429075124.128589-1-simon.horman@corigine.com>
To:     Simon Horman <simon.horman@corigine.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        oss-drivers@corigine.com
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Fri, 29 Apr 2022 09:51:24 +0200 you wrote:
> From: Yinjun Zhang <yinjun.zhang@corigine.com>
> 
> The device info from which conntrack originates is stored in metadata
> field of the ct flow to offload now, driver can utilize it to reduce
> the number of offloaded flows.
> 
> v2: Drop inline keyword from get_netdev_from_rule() signature.
>     The compiler can decide.
> 
> [...]

Here is the summary with links:
  - [v2,net-next] nfp: flower: utilize the tuple iifidx in offloading ct flows
    https://git.kernel.org/netdev/net-next/c/7195464cf8f2

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


