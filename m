Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 59E095F8DC2
	for <lists+netdev@lfdr.de>; Sun,  9 Oct 2022 21:50:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230175AbiJITuS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Oct 2022 15:50:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230118AbiJITuR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Oct 2022 15:50:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3F6E252B2
        for <netdev@vger.kernel.org>; Sun,  9 Oct 2022 12:50:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8F35F60C4F
        for <netdev@vger.kernel.org>; Sun,  9 Oct 2022 19:50:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D967FC433C1;
        Sun,  9 Oct 2022 19:50:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665345014;
        bh=XM5XjSX4X8n1UgZpxrvAZ++9/CmzQwOf7Owy/tAJm4U=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Tn6Cs+JUtveVMgeQ72vY8KXT2zY4OUzMk48VL74cxwUz+6ECJTud8huMpTOkORAoe
         jx86wg+I3uKMNSqBj9drgTUOGROhpUOMqkfWhN8tz5uYo4QvXF1vQ43QBrP3iPD8gB
         38tVGUDhkPZM9UtfXhaxd6G7nIpty+S1PiZAtoCtkAKIfQu2h03wZBohwRLmBo/Kqd
         qlF3eYDsId5+NQDL6bIN9MObXUZBZgqNYRKTGm6Keprayf5nMlmVttq+SXbwLMpYQ3
         pUz8ZV11r9lOi1Iwmgvdm3ec2SJR4e3BafNEbjjIplt6tGdX+3iy73vHJjtH6OmCsP
         n/WuN4IQpEINA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id BF630E2A05F;
        Sun,  9 Oct 2022 19:50:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 iproute2-next 1/2] taprio: don't print the clockid if
 invalid
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166534501478.30532.14169631578075710711.git-patchwork-notify@kernel.org>
Date:   Sun, 09 Oct 2022 19:50:14 +0000
References: <20221004120028.679586-1-vladimir.oltean@nxp.com>
In-Reply-To: <20221004120028.679586-1-vladimir.oltean@nxp.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, dsahern@kernel.org,
        stephen@networkplumber.org, vinicius.gomes@intel.com,
        jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to iproute2/iproute2-next.git (main)
by David Ahern <dsahern@kernel.org>:

On Tue,  4 Oct 2022 15:00:27 +0300 you wrote:
> The clockid will not be reported by the kernel if the qdisc is fully
> offloaded, since it is implicitly the PTP Hardware Clock of the device.
> 
> Currently "tc qdisc show" points us to a "clockid invalid" for a qdisc
> created with "flags 0x2", let's hide that attribute instead.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> [...]

Here is the summary with links:
  - [v2,iproute2-next,1/2] taprio: don't print the clockid if invalid
    https://git.kernel.org/pub/scm/network/iproute2/iproute2-next.git/commit/?id=a23a6eff9c0c
  - [v2,iproute2-next,2/2] taprio: support dumping and setting per-tc max SDU
    (no matching commit)

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


