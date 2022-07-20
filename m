Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D627557B440
	for <lists+netdev@lfdr.de>; Wed, 20 Jul 2022 12:00:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233747AbiGTKAR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jul 2022 06:00:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232168AbiGTKAQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jul 2022 06:00:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B531812765
        for <netdev@vger.kernel.org>; Wed, 20 Jul 2022 03:00:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 756E1B81EC4
        for <netdev@vger.kernel.org>; Wed, 20 Jul 2022 10:00:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 26973C341C7;
        Wed, 20 Jul 2022 10:00:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658311213;
        bh=9qRFtFan6ZZXX+jewtEboxoRsF6I++XJLDv1SIxxboQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=TNZxEBiroV9vPkRpY1GbrFOoKF/S1YdYK8cYtT6RHsdgtipTi1QbnXdsohArLn9b0
         J5lx3sNArWq8m4BMEkyRqWExbZ2c+bSnhXS64ubU4A0g0JkkKTBdXOqaHUDsmx3UQ1
         qOxHIIt7De8Ir/5ixFnfrnpxS1DheAglWOLBy5Ra1tnZtN2I+LvSzlhUvog5jBzJsW
         vIRKKBk9fWpsl6rJwFrcLv4DC5JrkeWt8D+BCZclfacYoQQaMFgshqGQtbyCj+m9gU
         MSuK9XjsSFh0GQ7iv+OtEtOwNfaLGvgw5yJhlNCrIX0+XLzAEJVip2wsEWZlsxCetD
         aabvadpw4lJiw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 0D93EE451B3;
        Wed, 20 Jul 2022 10:00:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v2] net/sched: cls_api: Fix flow action initialization
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165831121305.3977.9754621771164820109.git-patchwork-notify@kernel.org>
Date:   Wed, 20 Jul 2022 10:00:13 +0000
References: <20220719122409.18703-1-ozsh@nvidia.com>
In-Reply-To: <20220719122409.18703-1-ozsh@nvidia.com>
To:     Oz Shlomo <ozsh@nvidia.com>
Cc:     netdev@vger.kernel.org, baowen.zheng@corigine.com,
        simon.horman@corigine.com, davem@davemloft.net, roid@nvidia.com
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Tue, 19 Jul 2022 15:24:09 +0300 you wrote:
> The cited commit refactored the flow action initialization sequence to
> use an interface method when translating tc action instances to flow
> offload objects. The refactored version skips the initialization of the
> generic flow action attributes for tc actions, such as pedit, that allocate
> more than one offload entry. This can cause potential issues for drivers
> mapping flow action ids.
> 
> [...]

Here is the summary with links:
  - [net,v2] net/sched: cls_api: Fix flow action initialization
    https://git.kernel.org/netdev/net/c/c0f47c2822aa

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


