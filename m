Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0789E4DCB93
	for <lists+netdev@lfdr.de>; Thu, 17 Mar 2022 17:40:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236603AbiCQQlc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Mar 2022 12:41:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236396AbiCQQla (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Mar 2022 12:41:30 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35793124C27;
        Thu, 17 Mar 2022 09:40:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DB644B81F38;
        Thu, 17 Mar 2022 16:40:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 55C8EC340F3;
        Thu, 17 Mar 2022 16:40:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647535211;
        bh=Sp40xu3ePRcdg/dpm8P4EPWXw8rRilG/SWyjSEz56ik=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=nouG5n/UM9l+6zLbdb7OHfXAlqUZH+mgrAsgJmVddtETE3Wl+eq/Lz49t/mMNQanZ
         w/qiV90fc2+OlH2QoPmLlmpAMQA9P4WtwLjfKNg6Vr7qiPVG905t/idMy/84nwL5xP
         cN/70t04TDHOEmqRhLjcyB7qnhjkAImSHTC8BWQ61TNM93jI3LkvYwsE7RQMf4b+gf
         /iu+RTXoxwixQuHN5VwSnMOHy0SqhN6VPaavqdUbfoFMPBQNQI5tC9Q3/5ClrcetM/
         eXLI4RO87H759m0iJ/KJo2UnBMcVUuvQ1ydfODvjbW4+rShrBBXzogcvvHmnSMMa7e
         afCqg6ZJBDXUA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 3CD08E8DD5B;
        Thu, 17 Mar 2022 16:40:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: bcmgenet: skip invalid partial checksums
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164753521124.23544.3849930377237051985.git-patchwork-notify@kernel.org>
Date:   Thu, 17 Mar 2022 16:40:11 +0000
References: <20220317012812.1313196-1-opendmb@gmail.com>
In-Reply-To: <20220317012812.1313196-1-opendmb@gmail.com>
To:     Doug Berger <opendmb@gmail.com>
Cc:     davem@davemloft.net, f.fainelli@gmail.com, kuba@kernel.org,
        pabeni@redhat.com, bcm-kernel-feedback-list@broadcom.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 16 Mar 2022 18:28:12 -0700 you wrote:
> The RXCHK block will return a partial checksum of 0 if it encounters
> a problem while receiving a packet. Since a 1's complement sum can
> only produce this result if no bits are set in the received data
> stream it is fair to treat it as an invalid partial checksum and
> not pass it up the stack.
> 
> Fixes: 810155397890 ("net: bcmgenet: use CHECKSUM_COMPLETE for NETIF_F_RXCSUM")
> Signed-off-by: Doug Berger <opendmb@gmail.com>
> 
> [...]

Here is the summary with links:
  - [net] net: bcmgenet: skip invalid partial checksums
    https://git.kernel.org/netdev/net/c/0f643c88c8d2

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


