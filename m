Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7C654C13EF
	for <lists+netdev@lfdr.de>; Wed, 23 Feb 2022 14:20:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240852AbiBWNUl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Feb 2022 08:20:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240851AbiBWNUk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Feb 2022 08:20:40 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94EA0AA02B;
        Wed, 23 Feb 2022 05:20:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3044B6153D;
        Wed, 23 Feb 2022 13:20:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8A385C340F1;
        Wed, 23 Feb 2022 13:20:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645622411;
        bh=4MINalVsLypM4gQLR9Y0Ac8CSDvIEk7Or3pxAcAHrp8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=HV3GKjiAoVKlfbobREUE3hGsHRDqzsmzlyL6o5mMSqbKX6IyY79VoWM3Qzs1adTt+
         LkM9R6Je7Nngy4QtNvhmvT6T7pNjV5Dy4/br1Sg3OxHES0FDEi37iLWe5U1nTm1A0g
         Fk+uWWn9uekrNHdyn3fqu17941JuiD0iZkpinXQipSKRkRk4EeTGTutow0eYKGip7Y
         Dttc+6C2xKBF1iq4wZWEaEQblmDcmje7g+sbNmyYkyNYfZbA3fhsoC2SMGwMAwXJJU
         PAx/RmL186qNt6pJUJvaSyI6CxDPgyimzTNvhDJLNHD1WnNdDOJ1fIGB3BLxn1xkAo
         XQ3XQgDRzy7Jw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 78F24E6D598;
        Wed, 23 Feb 2022 13:20:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 0/3] drivers/net/ftgmac100: fix occasional DHCP failure
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164562241149.17147.7259955928729255752.git-patchwork-notify@kernel.org>
Date:   Wed, 23 Feb 2022 13:20:11 +0000
References: <20220223031436.124858-1-guoheyi@linux.alibaba.com>
In-Reply-To: <20220223031436.124858-1-guoheyi@linux.alibaba.com>
To:     Heyi Guo <guoheyi@linux.alibaba.com>
Cc:     linux-kernel@vger.kernel.org, andrew@lunn.ch, davem@davemloft.net,
        kuba@kernel.org, joel@jms.id.au, huangguangbin2@huawei.com,
        chenhao288@hisilicon.com, arnd@arndb.de, dylan_hung@aspeedtech.com,
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

This series was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Wed, 23 Feb 2022 11:14:33 +0800 you wrote:
> This patch set is to fix the issues discussed in the mail thread:
> https://lore.kernel.org/netdev/51f5b7a7-330f-6b3c-253d-10e45cdb6805@linux.alibaba.com/
> and follows the advice from Andrew Lunn.
> 
> The first 2 patches refactors the code to enable adjust_link calling reset
> function directly.
> 
> [...]

Here is the summary with links:
  - [1/3] drivers/net/ftgmac100: refactor ftgmac100_reset_task to enable direct function call
    https://git.kernel.org/netdev/net/c/4f1e72850d45
  - [2/3] drivers/net/ftgmac100: adjust code place for function call dependency
    https://git.kernel.org/netdev/net/c/3c773dba8182
  - [3/3] drivers/net/ftgmac100: fix DHCP potential failure with systemd
    https://git.kernel.org/netdev/net/c/1baf2e50e48f

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


