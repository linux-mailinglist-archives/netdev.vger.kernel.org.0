Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D1655159B0
	for <lists+netdev@lfdr.de>; Sat, 30 Apr 2022 03:51:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382038AbiD3Bxh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Apr 2022 21:53:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1382036AbiD3Bxf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Apr 2022 21:53:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F8A15F5A;
        Fri, 29 Apr 2022 18:50:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7C80D6247B;
        Sat, 30 Apr 2022 01:50:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id BFD70C385AC;
        Sat, 30 Apr 2022 01:50:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651283411;
        bh=4amxzgiIc8EudEU2X7SISkhxud6zHWtuW7goa+dtg6o=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=p+Erfm8kFBk8qFdSybLHXIfsUOT0TZ08J1rsUb+vSd/O1FG6SEQssv/JU87BexJWG
         95xF+P/TTM5gpVNqSyPRbbq0ao3vfk7r3HC0aMUAaoUCVAsvvalkw1YnUq3F3UgE7v
         GcOQzQ/rr8jWd1fcOwrgq4q7XajhwHN7iUoH34gZd4rOSgC/qcp1fj/jKApZJEgFoi
         6W0P2lpxiutaAtczH1nF+MWLzK8/p3ifaNJNZmKqvxgQhvJyvA/p5UHgGaciXTJ0yK
         LRzygJZaDG21gfZ6JIvZpD/sfbBRGW+i/Au7WTVj/7AinYcU6bUhvPhDeTUXK7oU4z
         +MlCQGh7QwjxQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id A38FEE8DBDA;
        Sat, 30 Apr 2022 01:50:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [Patch net] net: dsa: ksz9477: port mirror sniffing limited to one
 port
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165128341166.13664.5718757147720361929.git-patchwork-notify@kernel.org>
Date:   Sat, 30 Apr 2022 01:50:11 +0000
References: <20220428070709.7094-1-arun.ramadoss@microchip.com>
In-Reply-To: <20220428070709.7094-1-arun.ramadoss@microchip.com>
To:     Arun Ramadoss <arun.ramadoss@microchip.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        pabeni@redhat.com, kuba@kernel.org, davem@davemloft.net,
        olteanv@gmail.com, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        andrew@lunn.ch, UNGLinuxDriver@microchip.com,
        woojung.huh@microchip.com
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 28 Apr 2022 12:37:09 +0530 you wrote:
> This patch limits the sniffing to only one port during the mirror add.
> And during the mirror_del it checks for all the ports using the sniff,
> if and only if no other ports are referring, sniffing is disabled.
> The code is updated based on the review comments of LAN937x port mirror
> patch.
> 
> Link: https://patchwork.kernel.org/project/netdevbpf/patch/20210422094257.1641396-8-prasanna.vengateshan@microchip.com/
> Fixes: b987e98e50ab ("dsa: add DSA switch driver for Microchip KSZ9477")
> Signed-off-by: Prasanna Vengateshan <prasanna.vengateshan@microchip.com>
> Signed-off-by: Arun Ramadoss <arun.ramadoss@microchip.com>
> 
> [...]

Here is the summary with links:
  - [net] net: dsa: ksz9477: port mirror sniffing limited to one port
    https://git.kernel.org/netdev/net/c/fee34dd19938

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


