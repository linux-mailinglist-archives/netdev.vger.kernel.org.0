Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D9C3B51EEBE
	for <lists+netdev@lfdr.de>; Sun,  8 May 2022 18:00:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233613AbiEHQEJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 May 2022 12:04:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232281AbiEHQEH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 May 2022 12:04:07 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5B61654C
        for <netdev@vger.kernel.org>; Sun,  8 May 2022 09:00:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 12727CE1047
        for <netdev@vger.kernel.org>; Sun,  8 May 2022 16:00:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 2C4DCC385AF;
        Sun,  8 May 2022 16:00:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652025613;
        bh=l54dc4L5/6Ybd1k8JbtMmQ5+bPVQo0HTPQeeqCqsJjE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=N38DZazz/eiQLsuo/3kXZ1Qx7xXbEzyChqyOCLS+KU1iw0ZftAIeoe6xC44cQ8fng
         qLN/TPaQIMNhWWAuk52o2q0UAPl8WLQo1uVAF534Yt6muDaFTslf7SiR7Lc9Znicl0
         pV22E8wNT85IryevZq5Ma+vpbKUL7BWoZ8P0gLwqcKKtk/RmAXT4crQlTKtd44yCH5
         qnuqv0zX5I/iNXbaNfetnbmb50E9auUbSUFOFX/Wyabxk/LTD40+DP/3IofLdyRoxF
         SEBXYkgIkZ0MjbyZxJ2jvFR/Twnn7qy9fWKkCfQiGSLPcK7UHcIS4A51+4DEDueiIg
         VzFIPEvK11YVQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 0DB0DE8DBDA;
        Sun,  8 May 2022 16:00:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH iproute2 net-next v2 0/3] support for vxlan vni filtering
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165202561305.31176.1174962649456446616.git-patchwork-notify@kernel.org>
Date:   Sun, 08 May 2022 16:00:13 +0000
References: <20220508045340.120653-1-roopa@nvidia.com>
In-Reply-To: <20220508045340.120653-1-roopa@nvidia.com>
To:     Roopa Prabhu <roopa@nvidia.com>
Cc:     dsahern@gmail.com, netdev@vger.kernel.org,
        stephen@networkplumber.org, razor@blackwall.org
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to iproute2/iproute2-next.git (main)
by David Ahern <dsahern@kernel.org>:

On Sun, 8 May 2022 04:53:37 +0000 you wrote:
> This series adds bridge command to manage
> recently added vnifilter on a collect metadata
> vxlan (external) device. Also includes per vni stats
> support.
> 
> examples:
> $bridge vni add dev vxlan0 vni 400
> 
> [...]

Here is the summary with links:
  - [iproute2,net-next,v2,1/3] bridge: vxlan device vnifilter support
    https://git.kernel.org/pub/scm/network/iproute2/iproute2-next.git/commit/?id=45cd32f9f7d5
  - [iproute2,net-next,v2,2/3] ip: iplink_vxlan: add support to set vnifiltering flag on vxlan device
    (no matching commit)
  - [iproute2,net-next,v2,3/3] bridge: vni: add support for stats dumping
    https://git.kernel.org/pub/scm/network/iproute2/iproute2-next.git/commit/?id=40b50f153c52

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


