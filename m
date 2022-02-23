Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5BD5C4C06A6
	for <lists+netdev@lfdr.de>; Wed, 23 Feb 2022 02:10:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236235AbiBWBKo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Feb 2022 20:10:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236147AbiBWBKk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Feb 2022 20:10:40 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A93160D9
        for <netdev@vger.kernel.org>; Tue, 22 Feb 2022 17:10:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 18F55B81CBB
        for <netdev@vger.kernel.org>; Wed, 23 Feb 2022 01:10:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A2C05C340F9;
        Wed, 23 Feb 2022 01:10:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645578610;
        bh=fxja6WzGU+F6f/gK/7nbcBKEu2ieMuXW+YoUBSrg0OI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=uNhqy+xMehLRxZ9R8PwHGNouJhT+4T17F9HaZe+5DIpDMwt9/h9R6oWvRPcLy/ctT
         PlsmL3vXridV5MJu9KxGARJzpxYVJV3sO4o4HU2Ix9wm2ueKr/0bTx9leJH31Fs3Zw
         VFN0u3V98RVUmUHvggn1yLoTqcr5fHBo2mTRum48oDknCIG/sWmZ0OtQDUK6jmvLDn
         uNauk6mhP5swMS0G7UgetZl+nKP043JwXWningj8QZtoC+cLxfjm81xV059v9loJ7I
         6zbMsfAjm3EMRYzznp00xVKKhgZ65pQQyIRDEWlYBkZEFUBsZhtX2tQ8PB/ElWy7Ag
         zi0PagpUMJy+w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 87AFBEAC081;
        Wed, 23 Feb 2022 01:10:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] testptp: add option to shift clock by nanoseconds
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164557861055.30746.8152477763605340046.git-patchwork-notify@kernel.org>
Date:   Wed, 23 Feb 2022 01:10:10 +0000
References: <20220221200637.125595-1-maciek@machnikowski.net>
In-Reply-To: <20220221200637.125595-1-maciek@machnikowski.net>
To:     Maciek Machnikowski <maciek@machnikowski.net>
Cc:     netdev@vger.kernel.org, richardcochran@gmail.com
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

On Mon, 21 Feb 2022 21:06:37 +0100 you wrote:
> Add option to shift the clock by a specified number of nanoseconds.
> 
> The new argument -n will specify the number of nanoseconds to add to the
> ptp clock. Since the API doesn't support negative shifts those needs to
> be calculated by subtracting full seconds and adding a nanosecond offset.
> 
> Signed-off-by: Maciek Machnikowski <maciek@machnikowski.net>
> 
> [...]

Here is the summary with links:
  - [net-next] testptp: add option to shift clock by nanoseconds
    https://git.kernel.org/netdev/net-next/c/f64ae40de5ef

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


