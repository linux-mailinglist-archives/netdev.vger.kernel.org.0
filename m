Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A59F5679004
	for <lists+netdev@lfdr.de>; Tue, 24 Jan 2023 06:40:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232550AbjAXFkf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Jan 2023 00:40:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231371AbjAXFkb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Jan 2023 00:40:31 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEF953250F;
        Mon, 23 Jan 2023 21:40:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 28962CE18F0;
        Tue, 24 Jan 2023 05:40:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 6440AC433D2;
        Tue, 24 Jan 2023 05:40:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674538826;
        bh=bfkoAhcoQxBC6EAiRd/vv+XFwfFfyZk1twaBTNp6SPk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ekhPtlbu0xMV2pAg4Vd65mFeVY6N3Um3Q4XaVhBn5rzKctbGQEcVW+1wu5K2K7POc
         oALS1dsVNDrZFRiVcmDawa6E1ImrC3POfYmY+Vj+K46IZDTBTl1JV33kdQg7XbsUH2
         u//v6+MohWd7Q7SalfVtKfPbYLvongDzxcoDViFriC884tUv39T2ybW+fg8ycSmrNO
         38Vl/H5nJ+PGUZtViJda4Ocwg6+nPtJiO8aj9Mt3n9q7v62ZgUKM9t7VXmhJIYJagL
         3EhgjQmzE3zCGo3uG45HWwjpjen90/7iL6zM3peAyI/9p1CCCYfD/ocCLQDwTf5aIU
         sQ+EryZF6MwKw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 3C350C04E33;
        Tue, 24 Jan 2023 05:40:26 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: pull-request: wireless-next-2023-01-23
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167453882624.30916.8152362263859065188.git-patchwork-notify@kernel.org>
Date:   Tue, 24 Jan 2023 05:40:26 +0000
References: <20230123103338.330CBC433EF@smtp.kernel.org>
In-Reply-To: <20230123103338.330CBC433EF@smtp.kernel.org>
To:     Kalle Valo <kvalo@kernel.org>
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This pull request was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Mon, 23 Jan 2023 10:33:38 +0000 (UTC) you wrote:
> Hi,
> 
> here's a pull request to net-next tree, more info below. Please let me know if
> there are any problems.
> 
> Kalle
> 
> [...]

Here is the summary with links:
  - pull-request: wireless-next-2023-01-23
    https://git.kernel.org/netdev/net-next/c/62be69397e53

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


