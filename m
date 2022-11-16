Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B41F62B26C
	for <lists+netdev@lfdr.de>; Wed, 16 Nov 2022 05:40:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231771AbiKPEka (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Nov 2022 23:40:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231821AbiKPEkV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Nov 2022 23:40:21 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 862E331F9C
        for <netdev@vger.kernel.org>; Tue, 15 Nov 2022 20:40:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BA27E619C5
        for <netdev@vger.kernel.org>; Wed, 16 Nov 2022 04:40:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 0BCADC433D6;
        Wed, 16 Nov 2022 04:40:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668573615;
        bh=y/eNCWDudT4EpjtZAHlIvoM0N4iIbvLDnwe0R9SODRY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=WdjnCT3d5EyI/HlYIjh1W/GIwt9xWzse7MIv9Dt93BrcriN5/umVgpblQyfIMpPoO
         +3/Tl6K3g6yj1Mv21UxDtETvcJNe8K2Gvwkpd50FjBP5kA2O2VN76oLi2oJvfhlP51
         3HJmzk3GZh1WIJ5fv1Qt834521vabc5lCOfPhdsGxwUzAIUMkor1af6eKXEcGmvXjp
         VImbEkZX8ayoxlYQf0VgGoHusIjCF0O30vcYnvRpK7PZqXgSqp5iqunHOe2yfVn2b6
         oSos4H82SZcSZoPP0vLVw5d4Ysgs0DaKIua2W68GYhciDYpjKcZsSzTsQu8ZTJ+Nny
         k3IKHaA8o838A==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id D7EEAC395F6;
        Wed, 16 Nov 2022 04:40:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v3] Documentation: nfp: update documentation
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166857361487.31418.16146111876091842816.git-patchwork-notify@kernel.org>
Date:   Wed, 16 Nov 2022 04:40:14 +0000
References: <20221115090834.738645-1-simon.horman@corigine.com>
In-Reply-To: <20221115090834.738645-1-simon.horman@corigine.com>
To:     Simon Horman <simon.horman@corigine.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, oss-drivers@corigine.com, leon@kernel.org,
        walter.heymans@corigine.com, niklas.soderlund@corigine.com,
        louis.peens@corigine.com
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

On Tue, 15 Nov 2022 10:08:34 +0100 you wrote:
> From: Walter Heymans <walter.heymans@corigine.com>
> 
> The NFP documentation is updated to include information about Corigine,
> and the new NFP3800 chips. The 'Acquiring Firmware' section is updated
> with new information about where to find firmware.
> 
> Two new sections are added to expand the coverage of the documentation.
> The new sections include:
> - Devlink Info
> - Configure Device
> 
> [...]

Here is the summary with links:
  - [net-next,v3] Documentation: nfp: update documentation
    https://git.kernel.org/netdev/net-next/c/1ec6360ddb83

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


