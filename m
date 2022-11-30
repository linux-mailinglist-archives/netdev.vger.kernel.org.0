Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DDA4563CEB4
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 06:30:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232477AbiK3FaS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 00:30:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229777AbiK3FaS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 00:30:18 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73FAE64567
        for <netdev@vger.kernel.org>; Tue, 29 Nov 2022 21:30:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1DE94B81A42
        for <netdev@vger.kernel.org>; Wed, 30 Nov 2022 05:30:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B75C1C433D7;
        Wed, 30 Nov 2022 05:30:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669786214;
        bh=epeFDQ6UWNJXOICh5QttItlviIyEEk6WCMI1LkmGS2c=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=CQWck4+B4GVsNPzP9caK/ubJQapuS1e4LCF2kc6P6hvA7ODyDyByhR3NH+db03g3y
         K2nftkKJUwhP3axJRkOC6h6TzchLOL+mINu8vqL1wUn8MFyx7N+RQn6yXR1kMZ5cb2
         lOIcMcuXk13zZ0jYXiuiSzTPV/vWcAsQUrq4ECH39AGMXz9rXrX3yKC2vA0wsofw81
         1s52QR2aEM9K1sEE4JLj+SvQXj3qbgDdEkVjDJm+c+ZZuGoCDx5/6YKXUXU9cn+86A
         ebFnX/FmET6w7KP5Ov928ykNLdJ9BzwORH97y/GH3bQW/6qdG2HKP6RnjFAV3k//Rc
         rjmsjrb5927CA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 99AA0E21EF2;
        Wed, 30 Nov 2022 05:30:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] selftests/net: add csum offload test
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166978621462.24891.16331025384130651336.git-patchwork-notify@kernel.org>
Date:   Wed, 30 Nov 2022 05:30:14 +0000
References: <20221128140210.553391-1-willemdebruijn.kernel@gmail.com>
In-Reply-To: <20221128140210.553391-1-willemdebruijn.kernel@gmail.com>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        edumazet@google.com, pabeni@redhat.com, willemb@google.com
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

On Mon, 28 Nov 2022 09:02:10 -0500 you wrote:
> From: Willem de Bruijn <willemb@google.com>
> 
> Test NIC hardware checksum offload:
> 
> - Rx + Tx
> - IPv4 + IPv6
> - TCP + UDP
> 
> [...]

Here is the summary with links:
  - [net-next] selftests/net: add csum offload test
    https://git.kernel.org/netdev/net-next/c/91a7de85600d

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


