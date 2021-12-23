Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D37647E229
	for <lists+netdev@lfdr.de>; Thu, 23 Dec 2021 12:20:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347817AbhLWLUM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Dec 2021 06:20:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232691AbhLWLUM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Dec 2021 06:20:12 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B7CDC061401;
        Thu, 23 Dec 2021 03:20:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0AFC4B81FFC;
        Thu, 23 Dec 2021 11:20:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id CFCB0C36AEA;
        Thu, 23 Dec 2021 11:20:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640258409;
        bh=8mwJQtKH0Rrnt5k+UXUwA5lkXJsB6rHiYVYMUUnjq7s=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=BAyO8hILxYpnAgBP+/uMeOpOUwSwnn7kfVtZoERCjjSIg45jjR/sn0XzZddHXFcZZ
         GL3JcjwDs7KLV80i3Zywfv8QZ/RoPP3vzN40Jb4hR152q0MQId4ZhysfDewmH7bJBa
         nwKGVw23GeEXbBuVzC53nR7dZDF/mpUN3gr29jBIUbovphP/xCdDVT1qSfyuqq64dd
         h0b22YIGTtdOBVtgDA6ed8fJxzazCFZwMdeWUALtN5mgFMT34cGRp3YrpPeol6a/AG
         tBWMIjiVzc5xybQ++6Euh+QzEOd8LXhMubXz9sDUajAbkeK7RNyDbkZgayEn537q8B
         lMvrusHpkMDpg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id B8CC3EAC067;
        Thu, 23 Dec 2021 11:20:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] sctp: move hlist_node and hashent out of
 sctp_ep_common
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164025840975.28761.7027815149215841178.git-patchwork-notify@kernel.org>
Date:   Thu, 23 Dec 2021 11:20:09 +0000
References: <21619581e3ed03aa08156f280b3181b9c2823600.1640122830.git.lucien.xin@gmail.com>
In-Reply-To: <21619581e3ed03aa08156f280b3181b9c2823600.1640122830.git.lucien.xin@gmail.com>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     netdev@vger.kernel.org, linux-sctp@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org, marcelo.leitner@gmail.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Tue, 21 Dec 2021 16:40:30 -0500 you wrote:
> Struct sctp_ep_common is included in both asoc and ep, but hlist_node
> and hashent are only needed by ep after asoc_hashtable was dropped by
> Commit b5eff7128366 ("sctp: drop the old assoc hashtable of sctp").
> 
> So it is better to move hlist_node and hashent from sctp_ep_common to
> sctp_endpoint, and it saves some space for each asoc.
> 
> [...]

Here is the summary with links:
  - [net-next] sctp: move hlist_node and hashent out of sctp_ep_common
    https://git.kernel.org/netdev/net-next/c/3d3b2f57d444

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


