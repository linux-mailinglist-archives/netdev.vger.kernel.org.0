Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E766F6EA269
	for <lists+netdev@lfdr.de>; Fri, 21 Apr 2023 05:40:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233524AbjDUDkX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 23:40:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229521AbjDUDkW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 23:40:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 261CF30FF;
        Thu, 20 Apr 2023 20:40:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B628164D92;
        Fri, 21 Apr 2023 03:40:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 16D4EC433D2;
        Fri, 21 Apr 2023 03:40:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682048420;
        bh=teOjyVxPLa0u9Lm8eTih1HtcmQE57mDsyRQpOGNER3A=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=sueapPap1NiEPYLkmLDRREbOwb/t40riE/TGdgvDHAtuA69oVNFHoyPyF2PIuM8g8
         X8ow22CWepzR64VlX5SYh6rY3X+pR321FwLwTz0+mZMG8XZ3IzcH0MCJKcX4apDF63
         T42X03Hujgff09da1cU/byOHFZJQzhc8QKbmHome0ijFJKXzUf9gdGhr95LLTTV53p
         wQObPo0HTx69BktZ1UrNWVEDXpjcLl3+5GoPx6K0RJifovMs5RR0DyYXiRW1MvwTjd
         ROxXphWrZ4U+RVoPVBSVSxxsk45+X4N9sTSK9wFsShI2E/pbymvv6RpOFIX0I0KGdV
         ChRze+Wc/4Dhg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id E9DAAE270E2;
        Fri, 21 Apr 2023 03:40:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v4 0/3] net: extend drop reasons
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168204841995.12253.8809097990085515051.git-patchwork-notify@kernel.org>
Date:   Fri, 21 Apr 2023 03:40:19 +0000
References: <20230419125254.20789-1-johannes@sipsolutions.net>
In-Reply-To: <20230419125254.20789-1-johannes@sipsolutions.net>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 19 Apr 2023 14:52:51 +0200 you wrote:
> Hi,
> 
> Here's v4 of the extended drop reasons, with fixes to kernel-doc
> and checkpatch.
> 
> johannes

Here is the summary with links:
  - [net-next,v4,1/3] net: move dropreason.h to dropreason-core.h
    https://git.kernel.org/netdev/net-next/c/5b8285cca6fe
  - [net-next,v4,2/3] net: extend drop reasons for multiple subsystems
    https://git.kernel.org/netdev/net-next/c/071c0fc6fb91
  - [net-next,v4,3/3] mac80211: use the new drop reasons infrastructure
    (no matching commit)

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


