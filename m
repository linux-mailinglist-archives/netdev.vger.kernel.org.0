Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 453A6647450
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 17:30:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229743AbiLHQaZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 11:30:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229812AbiLHQaU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 11:30:20 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD9E4578F8
        for <netdev@vger.kernel.org>; Thu,  8 Dec 2022 08:30:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 655A3B824D2
        for <netdev@vger.kernel.org>; Thu,  8 Dec 2022 16:30:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 2721AC43398;
        Thu,  8 Dec 2022 16:30:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670517016;
        bh=FlCR6e2J/B51MU0OHYxv2gOYEtbu+93h57siTwI+jZ0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=NyBAyL3hhPmF4ZN6M/ldcE1VAJDOPmPCrvjmwhVNGDOsKL8L/TQXjJ6pPhvuTC0sm
         PFqR3QCZdkO+4jTQUTuFlCb7x4i0gKbVq45l+4c8ztaupHUJEGu3KWqdKl7dBIofw4
         wd7ORe2rUhCcR9RMfdV4B7PYJ/I6d2BbQVcNSb9Bp+GTR0uCieJpJ1+HQjt+/qpEFF
         REbnEK9NvYtggCcQBdGSNcPZasRQyzMCImPGB2bJ0sgHqPsl035aj99m/7HuSyYJxL
         P1r0UoZPNswkcURzD9icP8MtilyER8CmbCkkgen4wArKPB2viBixPWNN0flnePXahU
         vExmKgBgIv05Q==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 14109E1B4D8;
        Thu,  8 Dec 2022 16:30:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH iproute2-next v2 1/1] devlink: support direct region read
 requests
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167051701607.25268.14713708518266318278.git-patchwork-notify@kernel.org>
Date:   Thu, 08 Dec 2022 16:30:16 +0000
References: <20221205225931.2563966-1-jacob.e.keller@intel.com>
In-Reply-To: <20221205225931.2563966-1-jacob.e.keller@intel.com>
To:     Jacob Keller <jacob.e.keller@intel.com>
Cc:     netdev@vger.kernel.org, jiri@resnulli.us,
        stephen@networkplumber.org, dsahern@kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to iproute2/iproute2-next.git (main)
by David Ahern <dsahern@kernel.org>:

On Mon,  5 Dec 2022 14:59:31 -0800 you wrote:
> The kernel has gained support for reading from regions without needing to
> create a snapshot. To use this support, the DEVLINK_ATTR_REGION_DIRECT
> attribute must be added to the command.
> 
> For the "read" command, if the user did not specify a snapshot, add the new
> attribute to request a direct read. The "dump" command will still require a
> snapshot. While technically a dump could be performed without a snapshot it
> is not guaranteed to be atomic unless the region size is no larger than
> 256 bytes.
> 
> [...]

Here is the summary with links:
  - [iproute2-next,v2,1/1] devlink: support direct region read requests
    https://git.kernel.org/pub/scm/network/iproute2/iproute2-next.git/commit/?id=a74e7181c60b

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


