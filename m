Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D64D4C3D94
	for <lists+netdev@lfdr.de>; Fri, 25 Feb 2022 06:20:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233793AbiBYFUo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Feb 2022 00:20:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229518AbiBYFUo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Feb 2022 00:20:44 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14B292692FA
        for <netdev@vger.kernel.org>; Thu, 24 Feb 2022 21:20:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BBD7FB82B30
        for <netdev@vger.kernel.org>; Fri, 25 Feb 2022 05:20:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 43E69C340E8;
        Fri, 25 Feb 2022 05:20:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645766410;
        bh=TQy9PWM+EYx8JQhwhJyVKnnWwdru8EoudqXZtg9a+ug=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=X+6CBN8aYPDgAo1QWW12RjSiSQCPrjcPtXmnDVwIL626qobPzjL+zlxKibOpWkh8a
         8GDwZ62YAvxJFawbIUJTtzGf3v5TcYUaGWAqVYpf9jWvnapZ0HT1UntiEKZE6oH3py
         BrVJx2ZZ8aps8MOP6PGC6qJDrTCo+U6RZGX6eHdiIKaiouwrxjX/7vVKVcNLVajAdF
         zdVTIm+GdTjP5EkFVxA4pgj9UUOGNAG3lhwqyQ+mBxogdW8Fse8N4aNTRdfVzchWVT
         wusGbCAhUefiMSwI5jq3roExHRu83WpcmsSX+VaD/PBRjFdRY0uGcFgXsKCFBZvc1+
         4aDksoGl/qNZA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 2A2BFE6D4BB;
        Fri, 25 Feb 2022 05:20:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v3] net: sparx5: Support offloading of bridge port
 flooding flags
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164576641016.4654.10769663380687066728.git-patchwork-notify@kernel.org>
Date:   Fri, 25 Feb 2022 05:20:10 +0000
References: <20220223082700.qrot7lepwqcdnyzw@wse-c0155>
In-Reply-To: <20220223082700.qrot7lepwqcdnyzw@wse-c0155>
To:     Casper Andersson <casper.casan@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, lars.povlsen@microchip.com,
        Steen.Hegelund@microchip.com, UNGLinuxDriver@microchip.com,
        netdev@vger.kernel.org
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

On Wed, 23 Feb 2022 09:27:00 +0100 you wrote:
> Though the SparX-5i can control IPv4/6 multicasts separately from non-IP
> multicasts, these are all muxed onto the bridge's BR_MCAST_FLOOD flag.
> 
> Signed-off-by: Casper Andersson <casper.casan@gmail.com>
> Reviewed-by: Horatiu Vultur <horatiu.vultur@microchip.com>
> ---
> Changes in v2:
>  - Added SWITCHDEV_ATTR_ID_PORT_PRE_BRIDGE_FLAGS callback
> Changes in v3:
>  - Removed trailing whitespace
> 
> [...]

Here is the summary with links:
  - [net-next,v3] net: sparx5: Support offloading of bridge port flooding flags
    https://git.kernel.org/netdev/net-next/c/06388a03d2a7

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


