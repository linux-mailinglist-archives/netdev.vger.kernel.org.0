Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4BA336E2AFA
	for <lists+netdev@lfdr.de>; Fri, 14 Apr 2023 22:10:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230034AbjDNUK2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Apr 2023 16:10:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229965AbjDNUKW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Apr 2023 16:10:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61F7A65B8;
        Fri, 14 Apr 2023 13:10:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E056C64A26;
        Fri, 14 Apr 2023 20:10:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 40E58C433A0;
        Fri, 14 Apr 2023 20:10:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681503020;
        bh=Mvyvuwtj/oRXkXPTS/Co4jsSYBGPv4LCGVF9JXluDUY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=XpSGiKFUcGwX9yKPxNsP0eXXIc+VwVoXFr0ef+rwUtKfWAaR8wnAjVY7n+Lt6/3sn
         9VNffWlgQCdhUBbRBoMWEgdpU0PVSN09DNJngxEFBk3aW4phlZYOey3+pbV9lvl8nt
         6H8ZlDE3ushFWARQxJFRCdHGjC3D8/7AeL3tkU+6JiHYqBtqK4aiBXTuM+FwhJd3UD
         q5k7KW42GOk18zO6xk9mR02x8o/0+1tYyWAS0kTTM5CYk4Me6zp4oBtaLAEKrU9dxF
         ZuDdg+g3oiR8i9r9ohlkyTO1MO1vOwhZ1mKsfNd6mcRO3x6MOl5CsMizNfoURAyLkf
         7wfEicCuj8EIg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 2A3C2E4508F;
        Fri, 14 Apr 2023 20:10:20 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: bluetooth: hci_debugfs: fix inconsistent indenting
From:   patchwork-bot+bluetooth@kernel.org
Message-Id: <168150302017.15322.3070073451036592572.git-patchwork-notify@kernel.org>
Date:   Fri, 14 Apr 2023 20:10:20 +0000
References: <20230408164542.2316-1-u202212060@hust.edu.cn>
In-Reply-To: <20230408164542.2316-1-u202212060@hust.edu.cn>
To:     Lanzhe Li <u202212060@hust.edu.cn>
Cc:     marcel@holtmann.org, johan.hedberg@gmail.com, luiz.dentz@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, linux-bluetooth@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
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

This patch was applied to bluetooth/bluetooth-next.git (master)
by Luiz Augusto von Dentz <luiz.von.dentz@intel.com>:

On Sun,  9 Apr 2023 00:45:42 +0800 you wrote:
> From: markli <u202212060@hust.edu.cn>
> 
> Fixed a wrong indentation before "return".This line uses a 7 space
> indent instead of a tab.
> 
> Signed-off-by: Lanzhe Li <u202212060@hust.edu.cn>
> 
> [...]

Here is the summary with links:
  - net: bluetooth: hci_debugfs: fix inconsistent indenting
    https://git.kernel.org/bluetooth/bluetooth-next/c/2df7d630ef53

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


