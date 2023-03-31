Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A3EC6D1830
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 09:10:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230422AbjCaHKi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Mar 2023 03:10:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230351AbjCaHKh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Mar 2023 03:10:37 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A0C7C17E;
        Fri, 31 Mar 2023 00:10:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id E695CCE2D5B;
        Fri, 31 Mar 2023 07:10:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 39C1AC4339C;
        Fri, 31 Mar 2023 07:10:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680246631;
        bh=0wQ/RzY4rHEWiieWRxcRrBTwfv5MtdNQ5UOFJonBDGc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=FOsBkU1/Z/6lZXhWcLguXNxXANdqoQsQ1snZmM40XPORDqKg5B5Q1PpPW7BCiuf97
         VGEzHStL/A1FKgm1T9k8U+pAQaLH49IGKWlA26R+LuFU0JpPg8+kkF0XoR/C0IuE7b
         DbHzaqeojm6ak+z9AOy001z3zdNyP1iCARvBZ5WG1qEolET756+ahri28pTjKToWLZ
         7hUfxh/bZY/Reb30R6jVk1b+PX1dWKNYEoYTQ2IgOFytAD/UfpjwvpRZwrDwB2yTEG
         zZKN0+nKrQCu/EGnMj6rLgx1G8aOHa3QJ/tpYDNuU4uADSzmJuAAdX3B1/WB/AnVEh
         JkGtJxnOTTZXw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 2549CC395C3;
        Fri, 31 Mar 2023 07:10:31 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: pull-request: wireless-next-2023-03-30
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168024663114.20376.13843160460132792277.git-patchwork-notify@kernel.org>
Date:   Fri, 31 Mar 2023 07:10:31 +0000
References: <20230330205612.921134-1-johannes@sipsolutions.net>
In-Reply-To: <20230330205612.921134-1-johannes@sipsolutions.net>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This pull request was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 30 Mar 2023 22:56:11 +0200 you wrote:
> Hi,
> 
> Here's new content for -next, this time with a bunch
> of the promised iwlwifi work, but also lots of changes
> in other drivers and some new stack features.
> 
> I also mention it in the tag, but Kalle moved all the
> plain C files out of drivers/net/wireless/ into dirs,
> just FYI.
> 
> [...]

Here is the summary with links:
  - pull-request: wireless-next-2023-03-30
    https://git.kernel.org/netdev/net-next/c/ce7928f7cf98

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


