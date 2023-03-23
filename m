Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7DEF26C5D83
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 04:51:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230298AbjCWDuz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Mar 2023 23:50:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230299AbjCWDua (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Mar 2023 23:50:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB68B302A9
        for <netdev@vger.kernel.org>; Wed, 22 Mar 2023 20:50:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3F1D061179
        for <netdev@vger.kernel.org>; Thu, 23 Mar 2023 03:50:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8BD5FC4339C;
        Thu, 23 Mar 2023 03:50:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679543418;
        bh=Dp/fl79L3boSezM/951Ro/93OIyAgnzxZL2/oLT5joE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=GuzT8J8+voiDsjSv1tU2PBNWS8XARH/wVB2y3oIbGVbPYZptOmt5p4ysYEk8RSj8V
         WTsnPfSdU86wrI/LdrS7Bp+Figf4+TZM+/tE0L/8sRdQoM6zv1Sj5fas4xH5YMcax6
         yaGM7fyVHux41851x4a2Fk/Ta9B0zpVVQ10Oq+G/DbXfFHLOzSIlAoBtLiF2Dg3EBf
         EmKIxd6Ejz7KQRlcgEmbRjeDBwf0E0SUZqys3j7h5XRwhGGFm8oCjnB1vXjvlr/8c4
         JheDeBa4ssHSHALMt1+h1ZHctkTv2QZDBx77LT8TT196X2F/PZGVVGXlG8kNWnaAAV
         sTKvjExgHPPWQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 6BECEE4F0D7;
        Thu, 23 Mar 2023 03:50:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2 0/6] ynl: add support for user headers and struct
 attrs
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167954341843.25225.317267332666975407.git-patchwork-notify@kernel.org>
Date:   Thu, 23 Mar 2023 03:50:18 +0000
References: <20230319193803.97453-1-donald.hunter@gmail.com>
In-Reply-To: <20230319193803.97453-1-donald.hunter@gmail.com>
To:     Donald Hunter <donald.hunter@gmail.com>
Cc:     netdev@vger.kernel.org, kuba@kernel.org, davem@davemloft.net,
        edumazet@google.com, pabeni@redhat.com, donald.hunter@redhat.com
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Sun, 19 Mar 2023 19:37:57 +0000 you wrote:
> Add support for user headers and struct attrs to YNL. This patchset adds
> features to ynl and add a partial spec for openvswitch that demonstrates
> use of the features.
> 
> Patch 1 fixes a trivial signedness mismatch with struct genlmsghdr
> Patch 2-5 add features to ynl
> Patch 6 adds partial openvswitch specs that demonstrate the new features
> 
> [...]

Here is the summary with links:
  - [net-next,v2,1/6] tools: ynl: Fix genlmsg header encoding formats
    https://git.kernel.org/netdev/net/c/758d29fb3a8b
  - [net-next,v2,2/6] tools: ynl: Add struct parsing to nlspec
    (no matching commit)
  - [net-next,v2,3/6] tools: ynl: Add array-nest attr decoding to ynl
    (no matching commit)
  - [net-next,v2,4/6] tools: ynl: Add struct attr decoding to ynl
    (no matching commit)
  - [net-next,v2,5/6] tools: ynl: Add fixed-header support to ynl
    (no matching commit)
  - [net-next,v2,6/6] netlink: specs: add partial specification for openvswitch
    (no matching commit)

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


