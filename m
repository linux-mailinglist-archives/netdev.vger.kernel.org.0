Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C99964AAEF3
	for <lists+netdev@lfdr.de>; Sun,  6 Feb 2022 12:10:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233558AbiBFLKQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Feb 2022 06:10:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232609AbiBFLKO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Feb 2022 06:10:14 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CD60C061A73
        for <netdev@vger.kernel.org>; Sun,  6 Feb 2022 03:10:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C9026B80DB1
        for <netdev@vger.kernel.org>; Sun,  6 Feb 2022 11:10:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 7C254C340F6;
        Sun,  6 Feb 2022 11:10:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644145809;
        bh=38KhMiWYxt8fY7ckeJpJ0KENkIii9htw+6ex/Fj0qus=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=itekfyAnUKUwK5m/QYJRXqFL+rIs7Ph3m1JlJvSeNK2BwSgyzQ2gLYdZCETWe0IRE
         X3jTRL73DshBWaZYqgXqXpSH2R3P/ADTRZdEFZ2muI+z6QX7eSRhDL4uBxiQsS3tpb
         ZVPFO/ubdDyGraiMvd0KuKrewZZfHUsWmqy/naoacKCeoUsk6datfA5q4uVM2iXES4
         rvMeAVnrOSCxRU4bQtw2K8+1+23LX4VxSRQtmB54euPDdNyAmsiEiikH2Lg09U3y0E
         3dmuzayML28oSfDH1EhO9HCfnz+F0ovUIZQHIlf4ESkiSvVCZSWHDQE7JrTPpzXp0o
         9IuAnlUOQ/MmQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 6A2ECE6D44F;
        Sun,  6 Feb 2022 11:10:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v4 net-next] net: hsr: use hlist_head instead of list_head for
 mac addresses
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164414580941.29882.3204574468884683223.git-patchwork-notify@kernel.org>
Date:   Sun, 06 Feb 2022 11:10:09 +0000
References: <20220205154038.2345-1-claudiajkang@gmail.com>
In-Reply-To: <20220205154038.2345-1-claudiajkang@gmail.com>
To:     Juhee Kang <claudiajkang@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        ennoerlangen@gmail.com, george.mccollister@gmail.com,
        olteanv@gmail.com, marco.wenzel@a-eberle.de,
        xiong.zhenwu@zte.com.cn
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
by David S. Miller <davem@davemloft.net>:

On Sat,  5 Feb 2022 15:40:38 +0000 you wrote:
> Currently, HSR manages mac addresses of known HSR nodes by using list_head.
> It takes a lot of time when there are a lot of registered nodes due to
> finding specific mac address nodes by using linear search. We can be
> reducing the time by using hlist. Thus, this patch moves list_head to
> hlist_head for mac addresses and this allows for further improvement of
> network performance.
> 
> [...]

Here is the summary with links:
  - [v4,net-next] net: hsr: use hlist_head instead of list_head for mac addresses
    https://git.kernel.org/netdev/net-next/c/4acc45db7115

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


