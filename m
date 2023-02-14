Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B762D6966E2
	for <lists+netdev@lfdr.de>; Tue, 14 Feb 2023 15:30:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232507AbjBNOaW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Feb 2023 09:30:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229502AbjBNOaV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Feb 2023 09:30:21 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50E813C09
        for <netdev@vger.kernel.org>; Tue, 14 Feb 2023 06:30:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 02E48B81DD3
        for <netdev@vger.kernel.org>; Tue, 14 Feb 2023 14:30:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B8A9FC433EF;
        Tue, 14 Feb 2023 14:30:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676385016;
        bh=ZV01g/cRCmRsNDkOkUHoEc4QbKOKc1P8hpm9nR8SLzw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=htACy+9HwqY7QuLGmGX19QlNPgqPCtUhAFP3KFNimCMzZHixCwyWzfz7KsHEshSIh
         u47iQ/oifqeErWieeA+I0N+5WhK/lgUq86UDijrVkNWaqwc0sQAHDeVUpzeKgTnV4v
         2jhBIC41Ec7njoKzx7ByaZGrjrGMq7dkjhNqEq0r7GuuFCIxLeWfD7z9SnGoy/gsyX
         HUN4eiOSkg8O0oHykPk1A2Q8hbmMguwZAlTENiYJBAnrtZyXrEUpt1fVLOmtFW5pvS
         wdRK+c1NcazZgNd7o4wVHUfEQwmTwSo9uXer2TKlR+QCuo8XD3bG21QQ6lgORXQy/F
         0/JjOmkYOpyjg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 9CC0EE68D39;
        Tue, 14 Feb 2023 14:30:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [patch net-next v2] devlink: don't allow to change net namespace for
 FW_ACTIVATE reload action
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167638501663.3287.8484577642065785322.git-patchwork-notify@kernel.org>
Date:   Tue, 14 Feb 2023 14:30:16 +0000
References: <20230213115836.3404039-1-jiri@resnulli.us>
In-Reply-To: <20230213115836.3404039-1-jiri@resnulli.us>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com, jacob.e.keller@intel.com,
        moshe@nvidia.com, simon.horman@corigine.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Paolo Abeni <pabeni@redhat.com>:

On Mon, 13 Feb 2023 12:58:36 +0100 you wrote:
> From: Jiri Pirko <jiri@nvidia.com>
> 
> The change on network namespace only makes sense during re-init reload
> action. For FW activation it is not applicable. So check if user passed
> an ATTR indicating network namespace change request and forbid it.
> 
> Fixes: ccdf07219da6 ("devlink: Add reload action option to devlink reload command")
> Signed-off-by: Jiri Pirko <jiri@nvidia.com>
> 
> [...]

Here is the summary with links:
  - [net-next,v2] devlink: don't allow to change net namespace for FW_ACTIVATE reload action
    https://git.kernel.org/netdev/net-next/c/2edd92570441

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


