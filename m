Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE16F6B02EA
	for <lists+netdev@lfdr.de>; Wed,  8 Mar 2023 10:30:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229803AbjCHJac (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Mar 2023 04:30:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231225AbjCHJaW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Mar 2023 04:30:22 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 496A3A02AE
        for <netdev@vger.kernel.org>; Wed,  8 Mar 2023 01:30:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F36C8B81C11
        for <netdev@vger.kernel.org>; Wed,  8 Mar 2023 09:30:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 9FF92C4339B;
        Wed,  8 Mar 2023 09:30:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678267818;
        bh=Pp51wS03QDZ/7Eo7L/7EmHnUDw5C2rcs8fNQadDky1Y=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Z7I0YM6Hck/ZKiOpRmw0AwZT3UrOznjI59dqxHdHXvCZHiHXceSIwrST3hW/LT6Cl
         s4tcm8JKZUMqtXwB7njIQa/+5UcREnTXXO1wMhc4U7GCRzGaBgr3FHwsWNz0DSQ+jB
         kjDcc6AT+Z4ZV44mYgFosQir+RhpNDa/WHd1v9s4+l6HsKjnYajtTpF3oe8p3XkRDK
         nTZg8fHYlEcSAcFu76aUt7J/TfZgPsGT5TSW56cRASppOgKkoq/xRZe791vyK98znI
         xcF6kfOABODAQF8BahsVq+7CvVEMRLAGLE/ZJ3wI+EqY5s5PWFc3OvJ+Mn4CSfw78V
         pFafD3WLJW/OQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 89A7DE61B6F;
        Wed,  8 Mar 2023 09:30:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net-timestamp: extend SOF_TIMESTAMPING_OPT_ID to HW
 timestamps
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167826781855.28627.10294720560149649946.git-patchwork-notify@kernel.org>
Date:   Wed, 08 Mar 2023 09:30:18 +0000
References: <20230306160738.4116342-1-vadfed@meta.com>
In-Reply-To: <20230306160738.4116342-1-vadfed@meta.com>
To:     Vadim Fedorenko <vadfed@meta.com>
Cc:     pabeni@redhat.com, kuba@kernel.org, edumazet@google.com,
        dsahern@kernel.org, vadim.fedorenko@linux.dev,
        netdev@vger.kernel.org
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (main)
by David S. Miller <davem@davemloft.net>:

On Mon, 6 Mar 2023 08:07:38 -0800 you wrote:
> When the feature was added it was enabled for SW timestamps only but
> with current hardware the same out-of-order timestamps can be seen.
> Let's expand the area for the feature to all types of timestamps.
> 
> Signed-off-by: Vadim Fedorenko <vadfed@meta.com>
> ---
>  net/ipv4/ip_output.c  | 2 +-
>  net/ipv6/ip6_output.c | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)

Here is the summary with links:
  - [net-next] net-timestamp: extend SOF_TIMESTAMPING_OPT_ID to HW timestamps
    https://git.kernel.org/netdev/net-next/c/8ca5a5790b9a

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


