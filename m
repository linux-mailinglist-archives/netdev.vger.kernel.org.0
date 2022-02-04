Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B8B74A92B0
	for <lists+netdev@lfdr.de>; Fri,  4 Feb 2022 04:20:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356800AbiBDDUS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Feb 2022 22:20:18 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:40650 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356784AbiBDDUM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Feb 2022 22:20:12 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CB5E8B83658
        for <netdev@vger.kernel.org>; Fri,  4 Feb 2022 03:20:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 949A5C340F6;
        Fri,  4 Feb 2022 03:20:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643944810;
        bh=U6bl2htMZvEozpAC2T6eIanVTkWD4jbhxO1y+JZMrnI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=b1Km91vaQSE54xYE1TD20eOAc+BfwcGmbuP9RysWgZSH30WF40iM+dgwRd4JAo6SD
         skfM1Lh0mKgIV+EXE+rMVf/flV1+HfVtA2DjXcH9BW6XpmoTyarwmsuFRApbV9QDlb
         ohWFgXQAac+DWc3oV3gGwTqD6YqBRcoIaREN1XWlW73b0Qnh/H7oVi9EZgE9tvAVFw
         jn31gQPlh0n418QEtB0EJomJPMQlStemMZ9eMMe55vpDgyFytD1l2AKAcseI9bfI4e
         x5OIgGDW23Hni7vW+4e5t/y6yDq6FymapjfgHXDKOz1Q8cg6hhUAXaLTGqOqamVPlE
         ZzrcZqGf2jkjA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 7A7B8E6BB76;
        Fri,  4 Feb 2022 03:20:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: minor __dev_alloc_name() optimization
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164394481049.31803.10030267082981797075.git-patchwork-notify@kernel.org>
Date:   Fri, 04 Feb 2022 03:20:10 +0000
References: <20220203064609.3242863-1-eric.dumazet@gmail.com>
In-Reply-To: <20220203064609.3242863-1-eric.dumazet@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        edumazet@google.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Wed,  2 Feb 2022 22:46:09 -0800 you wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> __dev_alloc_name() allocates a private zeroed page,
> then sets bits in it while iterating through net devices.
> 
> It can use __set_bit() to avoid unecessary locked operations.
> 
> [...]

Here is the summary with links:
  - [net-next] net: minor __dev_alloc_name() optimization
    https://git.kernel.org/netdev/net-next/c/25ee1660a590

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


