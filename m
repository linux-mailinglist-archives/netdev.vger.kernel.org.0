Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B3BFE4C9B1B
	for <lists+netdev@lfdr.de>; Wed,  2 Mar 2022 03:20:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239085AbiCBCU4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Mar 2022 21:20:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239080AbiCBCUz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Mar 2022 21:20:55 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 783328BF1E
        for <netdev@vger.kernel.org>; Tue,  1 Mar 2022 18:20:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 20C53B81EF5
        for <netdev@vger.kernel.org>; Wed,  2 Mar 2022 02:20:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id AF8C4C340F0;
        Wed,  2 Mar 2022 02:20:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646187610;
        bh=6iD7KG3Zh6je3Bsu/wWTaq+O05aJUWfWI32GoOk0E7M=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=F+QNUG/iil1UQVqp6FRQj8ebs17VSwLd0NN29bmikKeWQLg4qG9w+dnN3F1oZE7cv
         EnIA/CTclhZySAkQKot4KA8jCsRv4hBwsVF7IorPwmkB0P3cXPdXb3+guNqZAT4B2+
         qQH6E3wUy6/dZyS+RQN8nzwnJLl8vvzY2DDv8ceU4qDxMqAYL2UM/i14zuIa2Vb2GQ
         JuoZKQ6wV+zmCkSyyq3QRkdWrJdmUGTKmleizn3TRlHYhv3ZfA3+ZkAWkwrTDDSnx1
         6slH6Z5pImaB1zS8mGCW98slR50BQe8CqguxfS+eraaiP0ZcPS6y9sc82MTig5vk4Z
         VO7a2WVNs2nQQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 910ACEAC096;
        Wed,  2 Mar 2022 02:20:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] macvtap: advertise link netns via netlink
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164618761059.10543.6751143056551360921.git-patchwork-notify@kernel.org>
Date:   Wed, 02 Mar 2022 02:20:10 +0000
References: <20220228003240.1337426-1-sven@narfation.org>
In-Reply-To: <20220228003240.1337426-1-sven@narfation.org>
To:     Sven Eckelmann <sven@narfation.org>
Cc:     netdev@vger.kernel.org, freifunk@irrelefant.net
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Mon, 28 Feb 2022 01:32:40 +0100 you wrote:
> Assign rtnl_link_ops->get_link_net() callback so that IFLA_LINK_NETNSID is
> added to rtnetlink messages. This fixes iproute2 which otherwise resolved
> the link interface to an interface in the wrong namespace.
> 
> Test commands:
> 
>   ip netns add nst
>   ip link add dummy0 type dummy
>   ip link add link macvtap0 link dummy0 type macvtap
>   ip link set macvtap0 netns nst
>   ip -netns nst link show macvtap0
> 
> [...]

Here is the summary with links:
  - macvtap: advertise link netns via netlink
    https://git.kernel.org/netdev/net-next/c/a02192151b7d

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


