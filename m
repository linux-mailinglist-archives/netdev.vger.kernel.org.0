Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 14A1869B793
	for <lists+netdev@lfdr.de>; Sat, 18 Feb 2023 02:50:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229568AbjBRBuU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Feb 2023 20:50:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbjBRBuT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Feb 2023 20:50:19 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F02B06B332
        for <netdev@vger.kernel.org>; Fri, 17 Feb 2023 17:50:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 863C8620AF
        for <netdev@vger.kernel.org>; Sat, 18 Feb 2023 01:50:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id DA77AC433D2;
        Sat, 18 Feb 2023 01:50:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676685017;
        bh=ZILIJNQLFomeuJ5zZV70Mn1Z+mQBXm5Wo88ow5LX02w=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=uiCzZj39xFXZjb92dHnr3Zr15HrT9llYX7shw+BVedkE3K2+QYHaC/zATz3pHERGH
         mp4FcjjHA7+ygvO9XDyrSNCF0jcbWAOWj8TUEw5ZbQOurFNM94IJQ6G98sqzQ95nuI
         D0NM7pcfiMia2BwJLwUJZ07CwtCl1SyHs0nIqmFY6IsE6iEKAfUm/bhj8jE9hL0S4r
         fZmzXS+ZMLOAkbJ7NvvNiTsy0VLaskK4GTvrNmpKo38qG+Uc/HYfVuq5jHrtDqgeRr
         bnpX5NU6OfsGxqv93NXElPIz/bv6DGbp/CAtfpWtWueXxASbhWO1igadY9D/evxAY8
         G8viIoqMOv2xQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id BD5E4E68D2F;
        Sat, 18 Feb 2023 01:50:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH iproute2-next 0/2] iplink: support IPv4 BIG TCP
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167668501777.31159.1822485726004278350.git-patchwork-notify@kernel.org>
Date:   Sat, 18 Feb 2023 01:50:17 +0000
References: <cover.1675985919.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1675985919.git.lucien.xin@gmail.com>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     netdev@vger.kernel.org, stephen@networkplumber.org,
        kuba@kernel.org, edumazet@google.com, pabeni@redhat.com,
        dsahern@gmail.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to iproute2/iproute2.git (main)
by Stephen Hemminger <stephen@networkplumber.org>:

On Thu,  9 Feb 2023 18:44:22 -0500 you wrote:
> Patch 1 fixes some typos in the documents, and Patch 2 adds two
> attributes to allow userspace to enable IPv4 BIG TCP.
> 
> Xin Long (2):
>   iplink: fix the gso and gro max_size names in documentation
>   iplink: add gso and gro max_size attributes for ipv4
> 
> [...]

Here is the summary with links:
  - [iproute2-next,1/2] iplink: fix the gso and gro max_size names in documentation
    https://git.kernel.org/pub/scm/network/iproute2/iproute2.git/commit/?id=62566ad5c0e6
  - [iproute2-next,2/2] iplink: add gso and gro max_size attributes for ipv4
    (no matching commit)

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


