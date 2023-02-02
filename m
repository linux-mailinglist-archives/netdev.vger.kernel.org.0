Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8EBF0687542
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 06:33:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232142AbjBBFdh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Feb 2023 00:33:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232198AbjBBFdJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Feb 2023 00:33:09 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D5927B427;
        Wed,  1 Feb 2023 21:30:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 40901B824B2;
        Thu,  2 Feb 2023 05:30:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E0CCDC4339E;
        Thu,  2 Feb 2023 05:30:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675315816;
        bh=0PQA0CdkO4lnxRGdtrno44wWf54jX/54YWYdBo/7vKU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=u1mvu9oVbY29Qzoi2gb/bv7H3jOYPovXv3XMzQlsKkxcPB+IvZXja2PiM/XsivAfu
         BuNhr647+wcbaqJmbGGZE0Eovlm4M+UU5yENz7df7c2JDNZA/UhfjvbLugr3ym+sS/
         LpBBNlGYWr9pS0p4zd+maRglmqRgcZuW/3RRI6lCukx9900RWdf62tCcSjJzuenQMP
         7ijqQGOoJDx6WDr0HnEHEjY8pjEcdMvTnfqHHuMpc5ofQT+8DFmnv5dYQuC83kEceT
         ucM8OhhMyepMF+7K5bLDuDRY0fFnTtgm28KYTFAlCvsFREuCDXq0UJvLrswuEZXPuM
         S07jMp0WYRGmg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id C4AB1C0C40E;
        Thu,  2 Feb 2023 05:30:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net PATCH v2] octeontx2-af: Fix devlink unregister
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167531581680.11250.16211882708416024258.git-patchwork-notify@kernel.org>
Date:   Thu, 02 Feb 2023 05:30:16 +0000
References: <20230131061659.1025137-1-rkannoth@marvell.com>
In-Reply-To: <20230131061659.1025137-1-rkannoth@marvell.com>
To:     Ratheesh Kannoth <rkannoth@marvell.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, leon@kernel.org, jiri@resnulli.us,
        sgoutham@marvell.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 31 Jan 2023 11:46:59 +0530 you wrote:
> Exact match feature is only available in CN10K-B.
> Unregister exact match devlink entry only for
> this silicon variant.
> 
> Fixes: 87e4ea29b030 ("octeontx2-af: Debugsfs support for exact match.")
> Signed-off-by: Ratheesh Kannoth <rkannoth@marvell.com>
> 
> [...]

Here is the summary with links:
  - [net,v2] octeontx2-af: Fix devlink unregister
    https://git.kernel.org/netdev/net/c/917d5e04d4dd

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


