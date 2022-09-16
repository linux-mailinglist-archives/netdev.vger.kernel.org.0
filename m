Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA02C5BB128
	for <lists+netdev@lfdr.de>; Fri, 16 Sep 2022 18:40:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229458AbiIPQkW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Sep 2022 12:40:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229579AbiIPQkT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Sep 2022 12:40:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F22B03DBC6
        for <netdev@vger.kernel.org>; Fri, 16 Sep 2022 09:40:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 502D5B8286B
        for <netdev@vger.kernel.org>; Fri, 16 Sep 2022 16:40:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id ECE4FC433D7;
        Fri, 16 Sep 2022 16:40:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663346415;
        bh=/yWv31phH8lSDL6SCZ1ZVLlH8wPEi1RpPMYhcgHLAnU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=XGYTLwbtkQZhAU+uxLrltA4+7sGCMqoWWvCpKqkkP/XnQRVRRbwUbqkJCsf+h4W4o
         GsH8iNkF+oeZ9Gg9uNlxkGj5FSp5qxCP5dvAZncgIKqeX7F3b7RCSzSDuqdjflk+dk
         ZnSR+/v46Vh/Rge8QfgWWPB8K6sLJLYVIorTS8ZxnG4OYq8iTwKRcKougpZPXyHSRR
         PSB9fHKZkiIvpzuTrehyS9lDaMPM9nhtQZHuuvbN5GHigFgsDkxsgEcgQHbkJ7rjNR
         Z6n9QoUQw5SO2fzjzinLcbfFOMDxKlipjLv7r3HGorMlTH9TRwTEuk2fyTAK64w1yi
         f3NUfz3+OtMDw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id C5BCDC73FE5;
        Fri, 16 Sep 2022 16:40:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH main v5 1/2] macsec: add Extended Packet Number support
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166334641480.16685.6458039498402066702.git-patchwork-notify@kernel.org>
Date:   Fri, 16 Sep 2022 16:40:14 +0000
References: <20220911092656.13986-1-ehakim@nvidia.com>
In-Reply-To: <20220911092656.13986-1-ehakim@nvidia.com>
To:     Emeel Hakim <ehakim@nvidia.com>
Cc:     dsahern@kernel.org, sd@queasysnail.net, netdev@vger.kernel.org,
        raeds@nvidia.com, tariqt@nvidia.com
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

On Sun, 11 Sep 2022 12:26:55 +0300 you wrote:
> This patch adds support for extended packet number (XPN).
> XPN can be configured by passing 'cipher gcm-aes-xpn-128' as part of
> the ip link add command using macsec type.
> In addition, using 'xpn' keyword instead of the 'pn', passing a 12
> bytes salt using the 'salt' keyword and passing short secure channel
> id (ssci) using the 'ssci' keyword as part of the ip macsec command
> is required (see example).
> 
> [...]

Here is the summary with links:
  - [main,v5,1/2] macsec: add Extended Packet Number support
    https://git.kernel.org/pub/scm/network/iproute2/iproute2-next.git/commit/?id=6ce23b7c2d79
  - [main,v5,2/2] macsec: add user manual description for extended packet number feature
    https://git.kernel.org/pub/scm/network/iproute2/iproute2-next.git/commit/?id=319c643ed741

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


