Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D496507EFC
	for <lists+netdev@lfdr.de>; Wed, 20 Apr 2022 04:40:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348670AbiDTCm6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Apr 2022 22:42:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344734AbiDTCm5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Apr 2022 22:42:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D903B13CC3
        for <netdev@vger.kernel.org>; Tue, 19 Apr 2022 19:40:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5CA3E61607
        for <netdev@vger.kernel.org>; Wed, 20 Apr 2022 02:40:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A7841C385AA;
        Wed, 20 Apr 2022 02:40:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650422411;
        bh=CA5WCJnZL2LTjgOnKpZlKQoKffTwOebhayHUlSEcPYQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=nEI8D7uw9Fhz64AORCQITPfT+WPTvGmInCm8z0EwVUQQOT32AeZdMWbKLK4QKzyQL
         gIc+c+Qb+w5GliGjeCnOpmDK6xPG4up1l0kTeoPh5aOg+0+etVrPDY91LJdKHlkLxU
         Mzex0iJ1xQYW0uMQnjI6NiS46eYaMrreoWkVjJMqwMjiDfAhaZMisD9l259cqu83px
         7FcA3z/i4/5tfQdeIYDmUgfdAu9ZGlO0j+7o7CwZdmt0i6fwWazQ2XY9b7xD9mtJhY
         UBa8FfsMqlkE4jaYDgiBMK+sR2BNi03E8ZlOKLEbshPml8d5WgiE53rPTWiecKBEWd
         IwW8Gn5DKNGrw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 8A656E8DD85;
        Wed, 20 Apr 2022 02:40:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v4] ip/iplink_virt_wifi: add support for virt_wifi
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165042241156.14476.6371846633674933686.git-patchwork-notify@kernel.org>
Date:   Wed, 20 Apr 2022 02:40:11 +0000
References: <20220418232507.4047-1-gasmibal@gmail.com>
In-Reply-To: <20220418232507.4047-1-gasmibal@gmail.com>
To:     Baligh GASMI <gasmibal@gmail.com>
Cc:     netdev@vger.kernel.org, stephen@networkplumber.org,
        dsahern@kernel.org
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

This patch was applied to iproute2/iproute2-next.git (main)
by David Ahern <dsahern@kernel.org>:

On Tue, 19 Apr 2022 01:25:07 +0200 you wrote:
> Add support for creating virt_wifi devices type.
> 
> Syntax:
> $ ip link add link eth0 name wlan0 type virt_wifi
> 
> Signed-off-by: Baligh Gasmi <gasmibal@gmail.com>
> 
> [...]

Here is the summary with links:
  - [v4] ip/iplink_virt_wifi: add support for virt_wifi
    https://git.kernel.org/pub/scm/network/iproute2/iproute2-next.git/commit/?id=ee53174bd977

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


