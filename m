Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4DDE8648D10
	for <lists+netdev@lfdr.de>; Sat, 10 Dec 2022 05:10:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229640AbiLJEKW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Dec 2022 23:10:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229482AbiLJEKT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Dec 2022 23:10:19 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7F806F481;
        Fri,  9 Dec 2022 20:10:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 82D1960BB8;
        Sat, 10 Dec 2022 04:10:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D41E0C433F0;
        Sat, 10 Dec 2022 04:10:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670645417;
        bh=tC9os5YzOOYHesgkLO6XHXBPhPn5Vp01W2MgAxHRoII=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=uLd7O2djQt4yfDkCzNU6m1Lp4/HEwQvW3k7Xp3utON70RIHcd3QRr8iSGWp2GXE4r
         mtzRTM8393mYI3TPIpoV9Ia+oUiZxWJYpcI85Y5Xiy8BZOYRD3gRF1TG9Q9JZZtG1a
         Fr1slDT97z28DVfyczd2+mJwSmfCQChM2vyfKySy8dGYlXund4Yz1XwDYSNvzXZc1+
         PLH629NbcH4EIhZTXtKenAzKTCxFIyZozQ+vT3/NKwggnz+R+FSHC3gEYX17r+IG3Y
         HBRWwT6sDbmhhrnYouaRziy7nXDXjx1/ot90CvN7/LB9iyRdhWqO0s81dCF7jj7iQm
         xPuySLxnFYjAg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id B5D49C433D7;
        Sat, 10 Dec 2022 04:10:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: devlink: Add missing error check to
 devlink_resource_put()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167064541773.24174.6966288912801812626.git-patchwork-notify@kernel.org>
Date:   Sat, 10 Dec 2022 04:10:17 +0000
References: <20221208082821.3927937-1-Ilia.Gavrilov@infotecs.ru>
In-Reply-To: <20221208082821.3927937-1-Ilia.Gavrilov@infotecs.ru>
To:     Gavrilov Ilia <Ilia.Gavrilov@infotecs.ru>
Cc:     jiri@nvidia.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 8 Dec 2022 08:31:39 +0000 you wrote:
> When the resource size changes, the return value of the
> 'nla_put_u64_64bit' function is not checked. That has been fixed to avoid
> rechecking at the next step.
> 
> Found by InfoTeCS on behalf of Linux Verification Center
> (linuxtesting.org) with SVACE.
> 
> [...]

Here is the summary with links:
  - net: devlink: Add missing error check to devlink_resource_put()
    https://git.kernel.org/netdev/net-next/c/5fc11a401a8d

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


