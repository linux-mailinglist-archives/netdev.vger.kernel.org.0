Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED69C4BA7C3
	for <lists+netdev@lfdr.de>; Thu, 17 Feb 2022 19:11:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243995AbiBQSK2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Feb 2022 13:10:28 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:42642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237691AbiBQSK1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Feb 2022 13:10:27 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5BD8194153
        for <netdev@vger.kernel.org>; Thu, 17 Feb 2022 10:10:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6237E61A0F
        for <netdev@vger.kernel.org>; Thu, 17 Feb 2022 18:10:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id BD888C340F8;
        Thu, 17 Feb 2022 18:10:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645121411;
        bh=wbmoM9e3N0GB0MWpoVq862BEVDdOp70paJEQI/kJ/OU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=JSdsWhkGBXyiXcSq5LhM9z3OIIX+yBkuscP/h6nl/SrHEA7IyzZhJWSfKxYyufUaF
         irEYL5tWXJepFbHPbbMfh8/7CxP6kaA0Juf2dZZMUWNnvTASTBQ8TQuZ8v+39qf1xN
         qKix9Y6rze2cx69IbQCctQppXMmtY8yzf0UiQ4l2od3xlB4yzQejzEu+tRK0TXJi2F
         TO9084/wtxblX38C34x5YYd298DsQDA3lmS+RriQY1Qd4ge3kmxjAKBX2+EGuhJ2PB
         jHbQlWj9/F8QT/iz7uvxd9MujGw47UanVJ/FF1gV9MZ0YXEJzts1OpMVXPy4TWaAAB
         LGh9oqUVhLMmg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id A4DBAE7BB0A;
        Thu, 17 Feb 2022 18:10:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] nfp: flower: netdev offload check for ip6gretap
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164512141167.19163.6393555740793462648.git-patchwork-notify@kernel.org>
Date:   Thu, 17 Feb 2022 18:10:11 +0000
References: <20220217124820.40436-1-louis.peens@corigine.com>
In-Reply-To: <20220217124820.40436-1-louis.peens@corigine.com>
To:     Louis Peens <louis.peens@corigine.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        oss-drivers@corigine.com, danie.dutoit@corigine.com,
        simon.horman@corigine.com
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Thu, 17 Feb 2022 14:48:20 +0200 you wrote:
> From: Danie du Toit <danie.dutoit@corigine.com>
> 
> IPv6 GRE tunnels are not being offloaded, this is caused by a missing
> netdev offload check. The functionality of IPv6 GRE tunnel offloading
> was previously added but this check was not included. Adding the
> ip6gretap check allows IPv6 GRE tunnels to be offloaded correctly.
> 
> [...]

Here is the summary with links:
  - [net] nfp: flower: netdev offload check for ip6gretap
    https://git.kernel.org/netdev/net/c/7dbcda584eaa

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


