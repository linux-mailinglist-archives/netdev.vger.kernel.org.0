Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 578886B1C56
	for <lists+netdev@lfdr.de>; Thu,  9 Mar 2023 08:30:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230139AbjCIHac (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Mar 2023 02:30:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229852AbjCIHaY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Mar 2023 02:30:24 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BAA662FDE;
        Wed,  8 Mar 2023 23:30:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id CA2E2CE228E;
        Thu,  9 Mar 2023 07:30:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id DFAE8C433AA;
        Thu,  9 Mar 2023 07:30:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678347019;
        bh=pLu2EUjm0EUWWJ8Bq7EHf6FFQCmBn3/LFHoWP+HFOaM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=TRQuKn87mlc14w2ao4dBhX1cwTkgy+XNoKUXHEVGLpkVkwA961dPU03wWDtoaRCoA
         KyBg+99tIz4BIEUt4yRJjLm4kakaKOhBW2bABom535uQzWsAYQzIuv2b1wGgbxVv1I
         h99HVGsJH5XnneOV/MClhLyGOSNsyynn8EROjm+3GxkFpvcDqjJgsJvhOCzKNNWsad
         T7AURXwMYPT/hjEhGGqeiGj61NUZLPgN9CxIxpcYVno1yA6HaIr2DDe7b/W8+MxBYs
         sw45PH57JbFR6WTsYZyqATB+g1nHYdBuBvdZyVhillv7JBDYRYVwybV3DK0ya5tBtz
         fVjbtpLQp/f2A==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id CB1B0E61B60;
        Thu,  9 Mar 2023 07:30:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 00/11] tree-wide: remove support for Renesas R-Car H3 ES1
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167834701982.22182.9521763384207545073.git-patchwork-notify@kernel.org>
Date:   Thu, 09 Mar 2023 07:30:19 +0000
References: <20230307163041.3815-1-wsa+renesas@sang-engineering.com>
In-Reply-To: <20230307163041.3815-1-wsa+renesas@sang-engineering.com>
To:     Wolfram Sang <wsa+renesas@sang-engineering.com>
Cc:     linux-renesas-soc@vger.kernel.org, dri-devel@lists.freedesktop.org,
        iommu@lists.linux.dev, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org, linux-mmc@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Tue,  7 Mar 2023 17:30:28 +0100 you wrote:
> Because H3 ES1 becomes an increasing maintenance burden and was only available
> to a development group, we decided to remove upstream support for it. Here are
> the patches to remove driver changes. Review tags have been gathered before
> during an internal discussion. Only change since the internal version is a
> plain rebase to v6.3-rc1. A branch with all removals is here:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/wsa/linux.git renesas/h3es1-removal
> 
> [...]

Here is the summary with links:
  - [07/11] ravb: remove R-Car H3 ES1.* handling
    https://git.kernel.org/netdev/net-next/c/6bf0ad7f2917

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


