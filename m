Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4AF6368A81A
	for <lists+netdev@lfdr.de>; Sat,  4 Feb 2023 05:10:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233039AbjBDEK1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Feb 2023 23:10:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232976AbjBDEKZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Feb 2023 23:10:25 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12B796E96
        for <netdev@vger.kernel.org>; Fri,  3 Feb 2023 20:10:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A0EA560302
        for <netdev@vger.kernel.org>; Sat,  4 Feb 2023 04:10:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id EDCDFC4339B;
        Sat,  4 Feb 2023 04:10:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675483824;
        bh=NDbDMqzwr1zG20GXLHmHsxs741XsRHfLx9meDgZJgPs=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=loAPwX/Fu6o8Uw7WQ8tcSZAsMlU/eWPP8yJIdGCp5Eq7YjSZQEA4AiWtqj1N7GKwf
         wO076oWHxN2OvYwGYFanCdPs1issQ+Z0za3QVXkDKzh0zxqLvZrgMridZH66uWKQIQ
         jCPxttdkMBv6Bk7BgmYkaoSXip2lVaTgwGE2DHCkLKyX5keVYph6AHk03aEOvBXH2c
         o17QiHHAOSjb5asiKI8OaJYyeTkzt6LADIiWXkHF+zHInUW0NuzCthb/yTIamKOAG8
         Dg4IwDleJTuxUr4djrl3bLOaWgRN1sbyd11gH7OoQar3TYPFqw8IzmRuCFg6ZzsAIj
         QnL+doE83jy7g==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id CA4A5E270CB;
        Sat,  4 Feb 2023 04:10:23 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 net 0/3] ionic: code maintenance
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167548382381.22938.5766679464870620680.git-patchwork-notify@kernel.org>
Date:   Sat, 04 Feb 2023 04:10:23 +0000
References: <20230202215537.69756-1-shannon.nelson@amd.com>
In-Reply-To: <20230202215537.69756-1-shannon.nelson@amd.com>
To:     Shannon Nelson <shannon.nelson@amd.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        drivers@pensando.io
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 2 Feb 2023 13:55:34 -0800 you wrote:
> These are a few fixes for a hardware bug, a couple of sw bugs,
> and a little code cleanup.
> 
> v2: dropped 3 patches which will be resubmitted for net-next
>     added Leon's Reviewed-by where applicable
>     Fixed Allen's Author and SoB addresses
> 
> [...]

Here is the summary with links:
  - [v2,net,1/3] ionic: clean interrupt before enabling queue to avoid credit race
    https://git.kernel.org/netdev/net/c/e8797a058466
  - [v2,net,2/3] ionic: clear up notifyq alloc commentary
    https://git.kernel.org/netdev/net/c/1fffb0254178
  - [v2,net,3/3] ionic: missed doorbell workaround
    https://git.kernel.org/netdev/net/c/b69585bfcece

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


