Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E049E645F8B
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 18:00:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229604AbiLGRAg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 12:00:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229892AbiLGRAS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 12:00:18 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1261D6723B
        for <netdev@vger.kernel.org>; Wed,  7 Dec 2022 09:00:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A647761B46
        for <netdev@vger.kernel.org>; Wed,  7 Dec 2022 17:00:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 17025C433D6;
        Wed,  7 Dec 2022 17:00:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670432417;
        bh=56KeDjfPN/AfE0Z+iqWGrlS7rS3hhjQFeK2UJqPez4Q=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=XEXKnO7rgNhsKLjmJHFM8y3zAym3hzuX3zIH0uAMBLkz+vWWGPINsWS5RR3jcfaFd
         ltsZp6yJNWoPkP8Sl+eul/mHBXfS+cnN8m6DTkx0BqBjmJ75uglj6lANVdjLQETlCT
         b+s73PYmJLDmFGnHcAEDFzXWGAtV90Np6S7GpHA3Are4JIG2xvL1oBWbRCfcFXZcN2
         6CCFca4zsgl6iC7Gtt1OHcLrCtgRo8ekK6xG1FGlYwFQmzIv2MFRx36pfr2F2v6zfB
         48ovA+mbALjM52wVqVJcqb5nd8ZvsjSLqdzLbSDj5wz7x+6PXA4U12ipGfnW+qajtK
         U3V+JEdCm6msA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id E7480E270CF;
        Wed,  7 Dec 2022 17:00:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH iproute2 1/1] tc: ct: Fix invalid pointer dereference
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167043241694.17877.6232578230277465738.git-patchwork-notify@kernel.org>
Date:   Wed, 07 Dec 2022 17:00:16 +0000
References: <20221207082213.707577-1-roid@nvidia.com>
In-Reply-To: <20221207082213.707577-1-roid@nvidia.com>
To:     Roi Dayan <roid@nvidia.com>
Cc:     netdev@vger.kernel.org, paulb@nvidia.com,
        stephen@networkplumber.org, dsahern@kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to iproute2/iproute2.git (main)
by Stephen Hemminger <stephen@networkplumber.org>:

On Wed, 7 Dec 2022 10:22:13 +0200 you wrote:
> Using macro NEXT_ARG_FWD does not validate argc.
> Use macro NEXT_ARG which validates argc while parsing args
> in the same loop iteration.
> 
> Fixes: c8a494314c40 ("tc: Introduce tc ct action")
> Signed-off-by: Roi Dayan <roid@nvidia.com>
> Reviewed-by: Paul Blakey <paulb@nvidia.com>
> 
> [...]

Here is the summary with links:
  - [iproute2,1/1] tc: ct: Fix invalid pointer dereference
    https://git.kernel.org/pub/scm/network/iproute2/iproute2.git/commit/?id=4de59102f49f

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


