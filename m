Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F5A555790C
	for <lists+netdev@lfdr.de>; Thu, 23 Jun 2022 13:50:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231530AbiFWLuV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jun 2022 07:50:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231529AbiFWLuR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jun 2022 07:50:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FB8B4D260
        for <netdev@vger.kernel.org>; Thu, 23 Jun 2022 04:50:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2415BB8225F
        for <netdev@vger.kernel.org>; Thu, 23 Jun 2022 11:50:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C133EC341C0;
        Thu, 23 Jun 2022 11:50:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655985012;
        bh=22JzWEhDRJsnn10yD/yJMd5HdfhZs+XXCTm1RImoYNw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=kPji4y3WwufIwG/citIiUvXjtrVbC0/6QzBtD00t4qgptlkSUPby4fKj6KAt0incM
         mIZxYCRDQP2IbQDwkNDPgiyzIMBh5m3Lif2m4FCu1ROtnCaKAIfVWXd0dZn7gxqWYW
         Hq0ZzZwCI5NLCg16a1lpEKD4fi3MpR5EBb4gW2LMqnNOfih/+ib9xN9V2nDeGXCT1k
         b02wXw74Wwln4iXwQGHOej9GK1ntn8lsBp9xlxKkkmCE2vCZH8LhTnI+n6c5n2zP0G
         5gUHzceHyYKT07jWRO9QGJ1dWzzfJXmGVlXRVMzxLUzHn+YDpMCCf++TTQP0vPNKY/
         n4w4wZ0xcOZ8A==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id A7183E7387A;
        Thu, 23 Jun 2022 11:50:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] nfp: add 'ethtool --identify' support
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165598501268.9941.1360098272686313526.git-patchwork-notify@kernel.org>
Date:   Thu, 23 Jun 2022 11:50:12 +0000
References: <20220622083938.291548-1-simon.horman@corigine.com>
In-Reply-To: <20220622083938.291548-1-simon.horman@corigine.com>
To:     Simon Horman <simon.horman@corigine.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, oss-drivers@corigine.com,
        sixiang.chen@corigine.com
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
by Paolo Abeni <pabeni@redhat.com>:

On Wed, 22 Jun 2022 10:39:38 +0200 you wrote:
> From: Sixiang Chen <sixiang.chen@corigine.com>
> 
> Add support for ethtool -p|--identify
> by enabling blinking of the panel LED if supported by the NIC firmware.
> 
> Signed-off-by: Sixiang Chen <sixiang.chen@corigine.com>
> Signed-off-by: Simon Horman <simon.horman@corigine.com>
> 
> [...]

Here is the summary with links:
  - [net-next] nfp: add 'ethtool --identify' support
    https://git.kernel.org/netdev/net-next/c/ccb9bc1dfa44

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


