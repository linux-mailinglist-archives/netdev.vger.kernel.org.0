Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55ACE47E248
	for <lists+netdev@lfdr.de>; Thu, 23 Dec 2021 12:30:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347950AbhLWLaP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Dec 2021 06:30:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347940AbhLWLaN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Dec 2021 06:30:13 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C860C061401
        for <netdev@vger.kernel.org>; Thu, 23 Dec 2021 03:30:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 55AE4B81FE3
        for <netdev@vger.kernel.org>; Thu, 23 Dec 2021 11:30:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 10FF0C36AE9;
        Thu, 23 Dec 2021 11:30:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640259011;
        bh=8kb38L1MaWKcmKK3bOhkpFTFUVb66W9Ad8UXKRnX214=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=j3VgpMOu8wCL+VVDkn+5+WZjt8CIe2G1MNzCsbTS4FukNs8h4rjVl6bf+hkfGHRzd
         MhwHW4cOT3Y6luF5dmZPmAlb+9Rg5rPYBmZuxSn6FzHZ9Vy83+p+n2bkPydUvREs4K
         EERs6ydJq9ka1EmQxiquUt6yT/8GZnaY32HEUHdOloeuoLClxuvBmZdcuvAX+9FDH/
         ZOOrqaY0ZlH33CJCxzOBThyvtuV//aisu3MDGTCuMnc7n3/pXz8QVLHILQjTHGMDfE
         maBKuyimsvQtDPKR4ClWZN/jeBBVDuDR9HUcJfIW7ErYj9xyEkkSYaKdih41x7D/qb
         Osib+mz1x59rA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id EBD16EAC060;
        Thu, 23 Dec 2021 11:30:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2 0/1] net: stmmac: add EthType Rx Frame steering
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164025901096.907.10306154000549571254.git-patchwork-notify@kernel.org>
Date:   Thu, 23 Dec 2021 11:30:10 +0000
References: <20211222144310.2761661-1-boon.leong.ong@intel.com>
In-Reply-To: <20211222144310.2761661-1-boon.leong.ong@intel.com>
To:     Ong Boon Leong <boon.leong.ong@intel.com>
Cc:     peppe.cavallaro@st.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, davem@davemloft.net, kuba@kernel.org,
        mcoquelin.stm32@gmail.com, alexandre.torgue@foss.st.com,
        kurt.kanzenbach@linutronix.de, bigeasy@linutronix.de,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Wed, 22 Dec 2021 22:43:09 +0800 you wrote:
> Hi,
> 
> Now that VLAN priority RX steering issue patch [1] is merged, this is
> the remaining patch from the original series to add LLDP and IEEE1588
> EtherType RX frame steering in tc flower.
> 
> As before, below are the test steps for checking out the newly added
> features (LLDP and PTP) together with VLAN priority:-
> 
> [...]

Here is the summary with links:
  - [net-next,v2,1/1] net: stmmac: add tc flower filter for EtherType matching
    https://git.kernel.org/netdev/net-next/c/e48cb313fde3

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


