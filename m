Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92FC9660086
	for <lists+netdev@lfdr.de>; Fri,  6 Jan 2023 13:50:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232676AbjAFMuT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Jan 2023 07:50:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230514AbjAFMuS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Jan 2023 07:50:18 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18370714BA
        for <netdev@vger.kernel.org>; Fri,  6 Jan 2023 04:50:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 48AA061D96
        for <netdev@vger.kernel.org>; Fri,  6 Jan 2023 12:50:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 9E9D4C43396;
        Fri,  6 Jan 2023 12:50:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673009416;
        bh=Nv3zsL40GD3T1jXEoBpZGrFWfWUr+FJCnCk5jaDnSUk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=cXoITV4skOBoueuiMNHHKOjf9K0H21J3WLd+X9dxlScys63rPQo1IhDnl+xxrep9E
         aTpYMimANskaWASV7/RQwjPlwlMyUY5WwyGcYal29hDOc2dIALF8cHwVF1cKli5FVI
         QNOeBBJz47mgNg7SzVG46lAQV8H+NZI4qqolAu9Z0LajXmyk4I/y1OgqCBC4IEXUyj
         JyZv3uIRqnTZOfj68ncn0vvbF+gadXoV5eu/bjO0KqApI2sU3Msp4xCcOPf7eIXELJ
         Dt8Vwi8hqNaU4R+7XV3dEGZSes2D3uUCnm86QM7X80uAmiKe9ilVmfRx7lDzvDaA1W
         auQ2ZR7b+iO1A==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 880B1E270EC;
        Fri,  6 Jan 2023 12:50:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH (repost) next] sysctl: expose all net/core sysctls inside
 netns
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167300941655.27619.4744687616350541556.git-patchwork-notify@kernel.org>
Date:   Fri, 06 Jan 2023 12:50:16 +0000
References: <20230105022842.3113230-1-maheshb@google.com>
In-Reply-To: <20230105022842.3113230-1-maheshb@google.com>
To:     Mahesh Bandewar <maheshb@google.com>
Cc:     netdev@vger.kernel.org, mahesh@bandewar.net, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        soheil@google.com
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
by David S. Miller <davem@davemloft.net>:

On Wed,  4 Jan 2023 18:28:42 -0800 you wrote:
> All were not visible to the non-priv users inside netns. However,
> with 4ecb90090c84 ("sysctl: allow override of /proc/sys/net with
> CAP_NET_ADMIN"), these vars are protected from getting modified.
> A proc with capable(CAP_NET_ADMIN) can change the values so
> not having them visible inside netns is just causing nuisance to
> process that check certain values (e.g. net.core.somaxconn) and
> see different behavior in root-netns vs. other-netns
> 
> [...]

Here is the summary with links:
  - [(repost),next] sysctl: expose all net/core sysctls inside netns
    https://git.kernel.org/netdev/net-next/c/6b754d7bd007

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


