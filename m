Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8646C6B58C8
	for <lists+netdev@lfdr.de>; Sat, 11 Mar 2023 06:50:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229577AbjCKFub (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Mar 2023 00:50:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229761AbjCKFu0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Mar 2023 00:50:26 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 428A01ABC9
        for <netdev@vger.kernel.org>; Fri, 10 Mar 2023 21:50:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E30FCB824F7
        for <netdev@vger.kernel.org>; Sat, 11 Mar 2023 05:50:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 6F753C4339C;
        Sat, 11 Mar 2023 05:50:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678513822;
        bh=+8MtVDalN/+iyecw/i1LhAvBhNwavrRbUudHjz9+6dg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=e8Z2ZaBWSLuNSS1abvEiXFpdXSPtZCedlOwzcgtMC3mn5xYhLAVGPaS/k+adzym5H
         wkLYESrGU7Au7z+T3D76MQ+foqhbGmQmKehaN0uIkSh8zHDFlECibb/eORWe3pXpIh
         gflmL7Cx9Kj+oO59iYX1B2rb/flEn88/YvIKWiw00lnyUBoR38TKLdP1KVutyed1Y2
         BMz+7Ql/34PpeSJh5vc6aMqt6Kiptg8MAgOUhlrJE5YHISTY634VMo//TaKLN44uh4
         fj42p5bmPzYwhln/F327ihaA2Zhg2CdCGYNepyhzLk6EWqeKm1JoKae0JpFCa/0hr6
         rl9F91kDt54/g==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 58EBFE4D007;
        Sat, 11 Mar 2023 05:50:22 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 1/1] i40e: Fix kernel crash during reboot when adapter is
 in recovery mode
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167851382236.22535.14082525130526854071.git-patchwork-notify@kernel.org>
Date:   Sat, 11 Mar 2023 05:50:22 +0000
References: <20230309184509.984639-1-anthony.l.nguyen@intel.com>
In-Reply-To: <20230309184509.984639-1-anthony.l.nguyen@intel.com>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, netdev@vger.kernel.org, ivecera@redhat.com,
        arpanax.arland@intel.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Thu,  9 Mar 2023 10:45:09 -0800 you wrote:
> From: Ivan Vecera <ivecera@redhat.com>
> 
> If the driver detects during probe that firmware is in recovery
> mode then i40e_init_recovery_mode() is called and the rest of
> probe function is skipped including pci_set_drvdata(). Subsequent
> i40e_shutdown() called during shutdown/reboot dereferences NULL
> pointer as pci_get_drvdata() returns NULL.
> 
> [...]

Here is the summary with links:
  - [net,1/1] i40e: Fix kernel crash during reboot when adapter is in recovery mode
    https://git.kernel.org/netdev/net/c/7e4f8a0c4954

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


