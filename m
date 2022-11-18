Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C57B162ECF4
	for <lists+netdev@lfdr.de>; Fri, 18 Nov 2022 05:50:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235159AbiKREuW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Nov 2022 23:50:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231814AbiKREuS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Nov 2022 23:50:18 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CD1A97AAE;
        Thu, 17 Nov 2022 20:50:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 10FA26231E;
        Fri, 18 Nov 2022 04:50:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 5CE86C433D7;
        Fri, 18 Nov 2022 04:50:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668747016;
        bh=t7xxYvPYXc231KG6nUygpti/cAn5PnhIeSUqmicZtI4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=nAQMffMa52OpSTeeU2d7Z1kRKvlLDsUR2ErmflCHdG7bJW68wf08SXY3cF0BXZIDQ
         Z1mo894VPhQuXUg8Aj7/MvBtLMurizhwDWYhMMxwYJVYOJl+cvogIlqcFFQ62b7I2H
         PXQSNFs9U3d32PhHANeKtOYE0+UucVYF1qNMwwylpxOHWoQ6W1HmdZEOCgl2Y+m7g3
         b8yHsq6g+NRWuWKb+5C2vJpXx2xjL031L21dv6dyW5/iucBref6tF21UC1uTNvmhVD
         RcnR2hZzWuAFla80aa6X8sy3Ygbce7caExOzNK6bc5RGnfBpGnSn9OrPtDjWe1waO8
         ThZeJpdFi8xYw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 3BA26C395F3;
        Fri, 18 Nov 2022 04:50:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v3 0/3] net: dsa: use more appropriate NET_NAME_* constants
 for user ports
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166874701623.23195.16762278398550223590.git-patchwork-notify@kernel.org>
Date:   Fri, 18 Nov 2022 04:50:16 +0000
References: <20221116105205.1127843-1-linux@rasmusvillemoes.dk>
In-Reply-To: <20221116105205.1127843-1-linux@rasmusvillemoes.dk>
To:     Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, olteanv@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, linux@armlinux.org.uk, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 16 Nov 2022 11:52:01 +0100 you wrote:
> The intention of commit 685343fc3ba6 ("net: add name_assign_type
> netdev attribute") was clearly that drivers be switched over one by
> one to select appropriate NET_NAME_* constants instead of
> NET_NAME_UNKNOWN. This small series attempts to do that for DSA user
> ports.
> 
> This is obviously and intentionally user-visible changes, so there's a
> small chance that it could lead to a regression. To make it easy to
> revert either of the "label in DT" and "fallback to eth%d" changes,
> this is done as a refactoring which shouldn't introduce any functional
> change (but by itself adds code which looks a little odd, with the two
> identical assignments in the two branches), followed by changing the
> constant used in each case in two different patches.
> 
> [...]

Here is the summary with links:
  - [v3,1/3] net: dsa: refactor name assignment for user ports
    https://git.kernel.org/netdev/net-next/c/0171a1d22bb9
  - [v3,2/3] net: dsa: use NET_NAME_PREDICTABLE for user ports with name given in DT
    https://git.kernel.org/netdev/net-next/c/6fdb03842040
  - [v3,3/3] net: dsa: set name_assign_type to NET_NAME_ENUM for enumerated user ports
    https://git.kernel.org/netdev/net-next/c/b8790661d90d

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


