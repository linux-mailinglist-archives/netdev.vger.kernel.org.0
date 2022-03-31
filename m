Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D45F4EDEA1
	for <lists+netdev@lfdr.de>; Thu, 31 Mar 2022 18:20:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239821AbiCaQWB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Mar 2022 12:22:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239827AbiCaQWA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Mar 2022 12:22:00 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A892F1F160D;
        Thu, 31 Mar 2022 09:20:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6D352B8218B;
        Thu, 31 Mar 2022 16:20:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 2A114C34115;
        Thu, 31 Mar 2022 16:20:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648743611;
        bh=XFXyNvd+Yayjca0tiSjpJKTNqxkgdTSAUId3UouoIhw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=VYUN2rRKIYMFvKHb5tXUpAp0200pdHcrEt01wZ0IRo4vg0DZS6iY9S8wGdiFYxfbA
         yrMctfzTeSLcT8QgUU2Qkju3str+kHXteF4JsF0O39KhjETDVfAdrHJejyeYUxQiin
         G938iOyBLZ30eORAG/xdsbJz1xU2LeBqc59ZmUH3wWMtLNVX00tR0haaJGnhV4YKJv
         FwENV0WCohIlpFKF+6jGhLz2U7GeHHbirsFkjzmOVO6dVKp2/wg4dmrcyLPCP4GXTu
         mG+I3CZ/dYb/W4CHlPzKbiTYqYVAvniRerKivEPfMxVVdwdvlGIx8+QVM7mEW4zvFk
         a1UccVWkyh09A==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 09C21F0384B;
        Thu, 31 Mar 2022 16:20:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] openvswitch: Add recirc_id to recirc warning
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164874361103.27032.11108416383428430823.git-patchwork-notify@kernel.org>
Date:   Thu, 31 Mar 2022 16:20:11 +0000
References: <20220330194244.3476544-1-stgraber@ubuntu.com>
In-Reply-To: <20220330194244.3476544-1-stgraber@ubuntu.com>
To:     =?utf-8?q?St=C3=A9phane_Graber_=3Cstgraber=40ubuntu=2Ecom=3E?=@ci.codeaurora.org
Cc:     netdev@vger.kernel.org, pshelar@ovn.org, davem@davemloft.net,
        kuba@kernel.org, pabeni@redhat.com, dev@openvswitch.org,
        linux-kernel@vger.kernel.org, frode.nordahl@canonical.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 30 Mar 2022 15:42:45 -0400 you wrote:
> When hitting the recirculation limit, the kernel would currently log
> something like this:
> 
> [   58.586597] openvswitch: ovs-system: deferred action limit reached, drop recirc action
> 
> Which isn't all that useful to debug as we only have the interface name
> to go on but can't track it down to a specific flow.
> 
> [...]

Here is the summary with links:
  - openvswitch: Add recirc_id to recirc warning
    https://git.kernel.org/netdev/net/c/ea07af2e71cd

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


