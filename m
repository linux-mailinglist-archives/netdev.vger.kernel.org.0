Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6CE3358581B
	for <lists+netdev@lfdr.de>; Sat, 30 Jul 2022 04:50:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232675AbiG3CuV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jul 2022 22:50:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230476AbiG3CuT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Jul 2022 22:50:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8FA76313;
        Fri, 29 Jul 2022 19:50:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5147261DEF;
        Sat, 30 Jul 2022 02:50:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A76CFC433D6;
        Sat, 30 Jul 2022 02:50:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659149416;
        bh=OYcwmP/HH2EBP/VrLe/KBjMldPFfmdPvCbqgy2DZ+/E=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=u1FQk/6AQsV5NAsq4BBxwSSb+Tn2IpXOFVWTDCEE2u2lVCyvQ04ik5OFlKByBhbYK
         c35dHTsjvN/oYqUL/RNh/2b8lsx0C28MAPtZjnpgrLk1hkC6tSxjYQH2ePQ3WgxK30
         8ADZaWYn6GBJJkOXi78UKhuBWztEewUCYhuIreSLaN/2jGPk/5ZDOg/Ph5nWTyJlIC
         6SHZMstzZ38riBzTF1hPYRVLpbfL59Ktq23RCHQnmR1lLzP7reZiUuai5uf5IPermQ
         Xw9c7Oa+xIBqlrGSxkUqX7Iy2Ej2Mh4LDguY+O4mn7MktAxW4ePWq/lObAGeewzGo2
         NW0j2z1WQyObA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 7BF9FC43143;
        Sat, 30 Jul 2022 02:50:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: pull-request: wireless-next-2022-07-29
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165914941649.16912.5014098444002084930.git-patchwork-notify@kernel.org>
Date:   Sat, 30 Jul 2022 02:50:16 +0000
References: <20220729192832.A5011C433D6@smtp.kernel.org>
In-Reply-To: <20220729192832.A5011C433D6@smtp.kernel.org>
To:     Kalle Valo <kvalo@kernel.org>
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This pull request was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Fri, 29 Jul 2022 19:28:32 +0000 (UTC) you wrote:
> Hi,
> 
> here's a pull request to net-next tree, more info below. Please let me know if
> there are any problems.
> 
> Kalle
> 
> [...]

Here is the summary with links:
  - pull-request: wireless-next-2022-07-29
    https://git.kernel.org/netdev/net-next/c/ff4970b130e7

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


