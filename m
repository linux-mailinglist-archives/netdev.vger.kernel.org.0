Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 857195A3324
	for <lists+netdev@lfdr.de>; Sat, 27 Aug 2022 02:30:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345133AbiH0AaV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Aug 2022 20:30:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344171AbiH0AaS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Aug 2022 20:30:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37F81DABBA
        for <netdev@vger.kernel.org>; Fri, 26 Aug 2022 17:30:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A517761C7B
        for <netdev@vger.kernel.org>; Sat, 27 Aug 2022 00:30:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 09D95C43141;
        Sat, 27 Aug 2022 00:30:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661560216;
        bh=BhVnlwrI0+3ZMkt71njgy/+EQogV5YNSC2HicIzpKao=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=DV1Nx2BZ9GATQ0J1Yn395/vgWJDOo+Q6eDyA+zEF8/aF63WrHHHmHTzlIefb3BaGX
         mSUvSxGy8DPrtBlnohx+WHsm42kBXT0jN9Fwj5+U14LBXk0NwhtIXme/i0RnOZ7Lfg
         9g9PtRExBxobI/KsiT8NPynHuVqSaShHmw01ShmUGlbL2IYcwFOeZI4978DFC7FQyv
         9YNVBpTcsdzRReTCnYkGvE9dNQoHct8/veCYd+2uidcn9bGvOW5v41ed1ecYLnu8iE
         YlTh7dHr24eGZpcuiRJeMQsLY7syepNs+w8YTlJJYbILdkqMaa1ux8noonBHpiBqRO
         Hf6oTR6n21JVQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id E861DC0C3EC;
        Sat, 27 Aug 2022 00:30:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [patch net-next] net: devlink: add RNLT lock assertion to
 devlink_compat_switch_id_get()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166156021594.1708.8413836468794465269.git-patchwork-notify@kernel.org>
Date:   Sat, 27 Aug 2022 00:30:15 +0000
References: <20220825112923.1359194-1-jiri@resnulli.us>
In-Reply-To: <20220825112923.1359194-1-jiri@resnulli.us>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com
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

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 25 Aug 2022 13:29:23 +0200 you wrote:
> From: Jiri Pirko <jiri@nvidia.com>
> 
> Similar to devlink_compat_phys_port_name_get(), make sure that
> devlink_compat_switch_id_get() is called with RTNL lock held. Comment
> already says so, so put this in code as well.
> 
> Signed-off-by: Jiri Pirko <jiri@nvidia.com>
> 
> [...]

Here is the summary with links:
  - [net-next] net: devlink: add RNLT lock assertion to devlink_compat_switch_id_get()
    https://git.kernel.org/netdev/net-next/c/6005a8aecee8

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


