Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 96D304B05CB
	for <lists+netdev@lfdr.de>; Thu, 10 Feb 2022 06:51:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234729AbiBJFuQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Feb 2022 00:50:16 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:43916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231986AbiBJFuO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Feb 2022 00:50:14 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE90910DF
        for <netdev@vger.kernel.org>; Wed,  9 Feb 2022 21:50:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7A20661C47
        for <netdev@vger.kernel.org>; Thu, 10 Feb 2022 05:50:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D877EC340ED;
        Thu, 10 Feb 2022 05:50:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644472208;
        bh=8l4/xMMFusQmOxay4LeDZ4IazojfRRGme8YEX8Hv7II=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Q76Zp5RZXINX+bg4ByM9/QuGqHnaYnUITWkabC5z2Ok8pFdkOvUocINE4uyvzsAtM
         nhFpJwx0N8m5kRBUz4KmLixHOX539muzhrWErMiV58xrTUh9xWbaJQ46VR4w8/VPs7
         XIouviSjzzXfqClKKKbtiNvU75CCaGyw7g92PyxEan2GvDxYI9l79KVDrM5/HL0/lb
         JwxB5CgurA8bJ5pa1CcBJiMJpP8D/Pxg3xLgkEiBI/tmNhBK22x6EP3DtIZEZikOhu
         BXJye6ie/8gKFHoR55aZQUi+yHhTtg179CnX+6ecYYZW/RGWfiouRYHg6IakakyHsB
         HgOG/MWSWHi7A==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id BBA9DE6D446;
        Thu, 10 Feb 2022 05:50:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/2] mptcp: Fixes for 5.17
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164447220876.5409.2789457508100360921.git-patchwork-notify@kernel.org>
Date:   Thu, 10 Feb 2022 05:50:08 +0000
References: <20220210012508.226880-1-mathew.j.martineau@linux.intel.com>
In-Reply-To: <20220210012508.226880-1-mathew.j.martineau@linux.intel.com>
To:     Mat Martineau <mathew.j.martineau@linux.intel.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        matthieu.baerts@tessares.net, mptcp@lists.linux.dev
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Wed,  9 Feb 2022 17:25:06 -0800 you wrote:
> Patch 1 fixes a MPTCP selftest bug that combined the results of two
> separate tests in the test output.
> 
> Patch 2 fixes a problem where advertised IPv6 addresses were not actually
> available for incoming MP_JOIN requests.
> 
> Kishen Maloor (1):
>   mptcp: netlink: process IPv6 addrs in creating listening sockets
> 
> [...]

Here is the summary with links:
  - [net,1/2] selftests: mptcp: add missing join check
    https://git.kernel.org/netdev/net/c/857898eb4b28
  - [net,2/2] mptcp: netlink: process IPv6 addrs in creating listening sockets
    https://git.kernel.org/netdev/net/c/029744cd4bc6

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


