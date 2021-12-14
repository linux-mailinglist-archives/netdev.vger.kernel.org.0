Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 671CC47431E
	for <lists+netdev@lfdr.de>; Tue, 14 Dec 2021 14:00:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234249AbhLNNAR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Dec 2021 08:00:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234234AbhLNNAO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Dec 2021 08:00:14 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82A88C061574
        for <netdev@vger.kernel.org>; Tue, 14 Dec 2021 05:00:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6BEC4614DC
        for <netdev@vger.kernel.org>; Tue, 14 Dec 2021 13:00:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id CDA29C34601;
        Tue, 14 Dec 2021 13:00:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639486812;
        bh=5U0ryrJBhSrNSglYrCB6HqOXmzWV9GKSe5eK8+cUtMQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=NmT5Hg6aavsKnIxGk7llTWFxalpe6UXKYP/EA+7nBC5lIa8Vzuax95fHfJyCepfaN
         d/yGOUa3KBLmnoC8y21aQATRIvUjH6+nwmFdbrnBExwXaag3MIMhF79aOjA4MlqG3F
         BB8se+fAwfJqmWPZuRaZtGNBXaKFDeS0lCuhusAJL6k0pr6LHdJAt59kDuIvOSPv19
         /zKzqRJOFk+XnpTA/cZa/3qLxphb5tyajmtYGn4ySYNpOg3rGPmrSKHo2kXLiMKlRH
         kCRz1sMo0Yd7iV143a2bHtvxY3iWkd7p08yizGcuCoyTog1aKoYnmRehve69sDZyK4
         pmbrJIk54P0CA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id BD00660A2F;
        Tue, 14 Dec 2021 13:00:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/2] cleanup return codes
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163948681276.21223.17022154051752052983.git-patchwork-notify@kernel.org>
Date:   Tue, 14 Dec 2021 13:00:12 +0000
References: <20211214051748.511675-1-drt@linux.ibm.com>
In-Reply-To: <20211214051748.511675-1-drt@linux.ibm.com>
To:     Dany Madden <drt@linux.ibm.com>
Cc:     netdev@vger.kernel.org, sukadev@linux.ibm.com,
        ricklind@linux.ibm.com, brking@linux.ibm.com, otis@otisroot.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Tue, 14 Dec 2021 00:17:46 -0500 you wrote:
> Update return code in the driver and remove unused defines from header
> file.
> 
> Dany Madden (2):
>   ibmvnic: Update driver return codes
>   ibmvnic: remove unused defines
> 
> [...]

Here is the summary with links:
  - [net,1/2] ibmvnic: Update driver return codes
    https://git.kernel.org/netdev/net-next/c/b6ee566cf394
  - [net,2/2] ibmvnic: remove unused defines
    https://git.kernel.org/netdev/net-next/c/fe4c82a7e0f0

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


