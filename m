Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8EC4066CEB3
	for <lists+netdev@lfdr.de>; Mon, 16 Jan 2023 19:23:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232788AbjAPSXQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Jan 2023 13:23:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233241AbjAPSWh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Jan 2023 13:22:37 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B56BB3A87E
        for <netdev@vger.kernel.org>; Mon, 16 Jan 2023 10:10:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 59A0C6110F
        for <netdev@vger.kernel.org>; Mon, 16 Jan 2023 18:10:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id BF5D6C433F0;
        Mon, 16 Jan 2023 18:10:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673892616;
        bh=XOPlKWIdQlyFBloKaUtpGINA90Jp4YSNxOkwdjSYHV4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=jBw2E8dSb5nUcKHQaFb2/vlCARxRoNnXqilfq+scyrf8rbiGqHAwxD2UIXjPMeWPq
         7btu/zRkauV64TfAsorBOEQ+ywAHvYNg0mxRVeYIvC5P9MunSuAubWQUWixiXFzorm
         gx/+y3kL5sMUBYchEfIiBuwVgeh/Kr9lpGhjzGEfJMf3fblxPQd8o7jb1YTqBq+YcN
         Lv/17AVrr35MmKnS5xVs5yi7fnT3z7iX/gLf5PqcNWPVtiDcAsjE0424jXSK3mIQ92
         o0NocUvBPlfNViu6kB0syT1u8blSHWhIgnzN8Anc6STaupDP/wbivo7kTEK0+I2N4G
         Up7PsqtIfGbSQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id A40D2E54D26;
        Mon, 16 Jan 2023 18:10:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH iproute] add space after keyword
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167389261666.21337.10609807783804346106.git-patchwork-notify@kernel.org>
Date:   Mon, 16 Jan 2023 18:10:16 +0000
References: <20230116172046.82178-1-stephen@networkplumber.org>
In-Reply-To: <20230116172046.82178-1-stephen@networkplumber.org>
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     netdev@vger.kernel.org
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

On Mon, 16 Jan 2023 09:20:46 -0800 you wrote:
> The style standard is to use space after keywords.
> Example:
> 	if (expr)
> verus
> 	if(expr)
> 
> Signed-off-by: Stephen Hemminger <stephen@networkplumber.org>
> 
> [...]

Here is the summary with links:
  - [iproute] add space after keyword
    https://git.kernel.org/pub/scm/network/iproute2/iproute2.git/commit/?id=46686c563b91

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


