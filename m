Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A3955A32F5
	for <lists+netdev@lfdr.de>; Sat, 27 Aug 2022 02:10:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345049AbiH0AKT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Aug 2022 20:10:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231528AbiH0AKS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Aug 2022 20:10:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC3CAA830D
        for <netdev@vger.kernel.org>; Fri, 26 Aug 2022 17:10:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 97DC2B80B94
        for <netdev@vger.kernel.org>; Sat, 27 Aug 2022 00:10:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 19620C433D7;
        Sat, 27 Aug 2022 00:10:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661559014;
        bh=OeVc9XDte2la/GQ4rzl14BhXPPZEpv+SbX2xLf/RC4A=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=WicuvdVXY/m/Cw9Tz2zFGSOR+QR/v7pKJMPYZl/r3mckl+SqeTTOAEhFM1y5gC+BN
         YcFYvOELhd3xd8c9OXqDOL8lDkL+jQ1L6zzZNZrTKP1yI+VMEbJD7u0EG7BcQIt+2W
         StNOrLbW6k0yQj1va5CtLtDlmNLtvI03bJyHSv+Gnf6Qn0PRNtdjCFxndjfW1AQ5DX
         OMuxHXUQFBJqqD/7bkc9lcl3L9NeCms2bWYw52E9fPgar6bscQuKOj7x/5wV04cWVb
         lVz+Ax84EPFyTlKeCqBAE12sI9bjAz7IahTjQdZN/I0kFREbqeFWwzgOcv++lyB/nk
         lMOTWY6oTbZgA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id F0207E2A03C;
        Sat, 27 Aug 2022 00:10:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [patch net-next] mlx4: Do type_clear() for devlink ports when
 type_set() was called previously
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166155901397.24863.8192624805848196996.git-patchwork-notify@kernel.org>
Date:   Sat, 27 Aug 2022 00:10:13 +0000
References: <20220825114031.1361478-1-jiri@resnulli.us>
In-Reply-To: <20220825114031.1361478-1-jiri@resnulli.us>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com, tariqt@nvidia.com
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

On Thu, 25 Aug 2022 13:40:31 +0200 you wrote:
> From: Jiri Pirko <jiri@nvidia.com>
> 
> Whenever the type_set() is called on a devlink port, accompany it by
> matching type_clear() during cleanup.
> 
> Signed-off-by: Jiri Pirko <jiri@nvidia.com>
> 
> [...]

Here is the summary with links:
  - [net-next] mlx4: Do type_clear() for devlink ports when type_set() was called previously
    https://git.kernel.org/netdev/net-next/c/de9d555cb8d4

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


