Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A74D5574209
	for <lists+netdev@lfdr.de>; Thu, 14 Jul 2022 05:50:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233162AbiGNDuX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jul 2022 23:50:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229473AbiGNDuS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jul 2022 23:50:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C39DF26AD2;
        Wed, 13 Jul 2022 20:50:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 76DE3B822B5;
        Thu, 14 Jul 2022 03:50:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B29C0C341CF;
        Thu, 14 Jul 2022 03:50:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657770614;
        bh=evXXjMWqxHnQvr1Hiit9gMXtcIlGMTR20A4MwY5Ms9M=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=tl7dz1AZP+D1g1nxORUWIqlNsSJLqSvNw1kz50duVl/xX1ijZ2gNPJ7oB+kORoAzO
         fUOLB637waYAaU77YESkfYXrXKm159F9ppQS5fIEh43gI1gdbM6c72gxnD9KFXgdWj
         GDNI7jC9FSRwlj1cPj28RHnjbmeHxVAIWCNZE+k6KxImCgarDhzW7SAjVn6OqKVFaM
         aiJw6C7nOdm+VPbfbciK7V58Ei/84wDVhqOfPOnwGtdztggQ+Iql2P92Oq4aR/+gQU
         BKzClaRYa1h8IjzE/YI8v1uhAZYhevQHxL+FcrOMbz2zZOPLnuyRT5Qg5Een6+yshj
         udONENtZmUu+Q==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 9A6F7E45227;
        Thu, 14 Jul 2022 03:50:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net-next PATCH] octeontx2-af: Limit link bringup time at firmware
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165777061462.21676.17997781277041273852.git-patchwork-notify@kernel.org>
Date:   Thu, 14 Jul 2022 03:50:14 +0000
References: <20220712161815.12621-1-gakula@marvell.com>
In-Reply-To: <20220712161815.12621-1-gakula@marvell.com>
To:     Geetha sowjanya <gakula@marvell.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org, edumazet@google.com,
        pabeni@redhat.com, sgoutham@marvell.com, hkelam@marvell.com
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

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 12 Jul 2022 21:48:15 +0530 you wrote:
> From: Hariprasad Kelam <hkelam@marvell.com>
> 
> Set the maximum time firmware should poll for a link.
> If not set firmware could block CPU for a long time resulting
> in mailbox failures. If link doesn't come up within 1second,
> firmware will anyway notify the status as and when LINK comes up
> 
> [...]

Here is the summary with links:
  - [net-next] octeontx2-af: Limit link bringup time at firmware
    https://git.kernel.org/netdev/net-next/c/9b633670087e

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


