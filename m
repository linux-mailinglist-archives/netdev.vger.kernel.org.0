Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F28C04CACBE
	for <lists+netdev@lfdr.de>; Wed,  2 Mar 2022 19:00:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244338AbiCBSA5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Mar 2022 13:00:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244302AbiCBSA4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Mar 2022 13:00:56 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36712CA719
        for <netdev@vger.kernel.org>; Wed,  2 Mar 2022 10:00:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id ECFABB82161
        for <netdev@vger.kernel.org>; Wed,  2 Mar 2022 18:00:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 919CFC340EF;
        Wed,  2 Mar 2022 18:00:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646244010;
        bh=zHMghSFxKEalRsIpugHnJwgRn+8xqMMJCySdEVzhO/Y=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Ff/rpuSjcQWlrA4ElZiyr2UsQhq2wJrk3VeRj9S0ITdgC365ywJoO8Jdt2LF3hkzd
         zazuQ3d9ZEaAcYPYzUag6fzyS03P23/GSK/w1X6IA2tAb62/sIZW7DFmaCj7ZoZCFZ
         O2Y57umgk2Eu6Uun2MyxYDIR9jRWcZtSR7vnOue5cuQRE0jTHeTnw6GL6wkj+RwKTc
         FpdeQ/0sttjLHg2mUXeYh7KqJxAdWlWqHWh2m6F1BBoBv7GHwk3HrcfcYp2DNbPMPF
         FSSJKZEkQIjoYwCS4yjp9wLFh22ykLVM4PDgobOm6txUZ2QDGZhloVTgJTH1vtvkNa
         c2hP0592OQPfg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 6D79EEAC095;
        Wed,  2 Mar 2022 18:00:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] ptp: ocp: Add ptp_ocp_adjtime_coarse for large
 adjustments
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164624401044.29389.11363718802091794919.git-patchwork-notify@kernel.org>
Date:   Wed, 02 Mar 2022 18:00:10 +0000
References: <20220228203957.367371-1-jonathan.lemon@gmail.com>
In-Reply-To: <20220228203957.367371-1-jonathan.lemon@gmail.com>
To:     Jonathan Lemon <jonathan.lemon@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        richardcochran@gmail.com, kernel-team@fb.com
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

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Mon, 28 Feb 2022 12:39:57 -0800 you wrote:
> In ("ptp: ocp: Have FPGA fold in ns adjustment for adjtime."), the
> ns adjustment was written to the FPGA register, so the clock could
> accurately perform adjustments.
> 
> However, the adjtime() call passes in a s64, while the clock adjustment
> registers use a s32.  When trying to perform adjustments with a large
> value (37 sec), things fail.
> 
> [...]

Here is the summary with links:
  - [net-next] ptp: ocp: Add ptp_ocp_adjtime_coarse for large adjustments
    https://git.kernel.org/netdev/net/c/90f8f4c0e3ce

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


