Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7840E5A88B8
	for <lists+netdev@lfdr.de>; Thu,  1 Sep 2022 00:01:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232484AbiHaWA0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Aug 2022 18:00:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232463AbiHaWAY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Aug 2022 18:00:24 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53BB56DAEE;
        Wed, 31 Aug 2022 15:00:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 3F42ACE2371;
        Wed, 31 Aug 2022 22:00:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 19728C433B5;
        Wed, 31 Aug 2022 22:00:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661983217;
        bh=D2hckKTWv4BB2ko/rlSdTwsjSj88gseeyvmPpsyYjY4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=OBDpf6NekLJPoBGwSFts/vCEIXfXQ+t8afU++8QV+ZM6wMapDpgV/55jr8/umjNNz
         nwdZdc0tuQ0UjsNOFU6npmuI7XiByTI/lSL/SPGw4p1TjDgWE5LwspHiPBUfKNB0nr
         3xC/orlQ5jyxKie1tcQfIpu/j90SBA/4bVby/4ewxGvGhke7Qa5J3/YaJd4iQjgvwa
         95n4Mz44YO96Lpcw+NAJy5IseI13V71GbgvX+bBs5HascffJOiIDsVWOYXJ1mgRlns
         Z/g5dI6rCHcqE2bGuJKH3o8m8YEql71KpYjN42Ps8b1hCA3YLQN9YsFTxLbg6cOoGo
         +nhqd2DFaWmxA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 0259CE924D6;
        Wed, 31 Aug 2022 22:00:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v1] r8152: allow userland to disable multicast
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166198321700.20200.2886724035407277786.git-patchwork-notify@kernel.org>
Date:   Wed, 31 Aug 2022 22:00:17 +0000
References: <20220830045923.net-next.v1.1.I4fee0ac057083d4f848caf0fa3a9fd466fc374a0@changeid>
In-Reply-To: <20220830045923.net-next.v1.1.I4fee0ac057083d4f848caf0fa3a9fd466fc374a0@changeid>
To:     Sven van Ashbrook <svenva@chromium.org>
Cc:     linux-kernel@vger.kernel.org, levinale@google.com,
        chithraa@google.com, frankgor@google.com, aaron.ma@canonical.com,
        dober6023@gmail.com, davem@davemloft.net, edumazet@google.com,
        chenhao288@hisilicon.com, hayeswang@realtek.com, kuba@kernel.org,
        jflf_kernel@gmx.com, pabeni@redhat.com, linux-usb@vger.kernel.org,
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

On Tue, 30 Aug 2022 04:59:39 +0000 you wrote:
> The rtl8152 driver does not disable multicasting when userspace asks
> it to. For example:
>  $ ifconfig eth0 -multicast -allmulti
>  $ tcpdump -p -i eth0  # will still capture multicast frames
> 
> Fix by clearing the device multicast filter table when multicast and
> allmulti are both unset.
> 
> [...]

Here is the summary with links:
  - [net-next,v1] r8152: allow userland to disable multicast
    https://git.kernel.org/netdev/net-next/c/7305b78ae45f

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


