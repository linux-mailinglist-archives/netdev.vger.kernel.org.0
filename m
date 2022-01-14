Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3545448E92C
	for <lists+netdev@lfdr.de>; Fri, 14 Jan 2022 12:30:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240842AbiANLaR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jan 2022 06:30:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240808AbiANLaO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jan 2022 06:30:14 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4974C06161C;
        Fri, 14 Jan 2022 03:30:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D3197B825C6;
        Fri, 14 Jan 2022 11:30:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 7940BC36AEA;
        Fri, 14 Jan 2022 11:30:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642159810;
        bh=78rT9scg6j0SsJnKWtdXTkNU8eZ1HwPLWL6gwgB5vM4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=UTiCDAKLUfNJY5axjWJOIdf1r1BkY++eaexAFgL+jg1s4vHDbzBDTLFypyUc0kuuZ
         cIfySnQ2strdImdRN/1VCnG7hy1Xtd2izjqpCa9HkfO3XHwofH+1KfM5urmAievGdn
         aFNxwWfgTBXcaaj2v6R0EellNcUoIZmfr8SUZYuSZHXUY6F1q4cTmX0RXCGoBvuiXB
         9533f2E1src2bf1lqTfnTkEDGTofluntGn3eEiz6yzLS+xK38JYqaJGQwM1q2JMNv0
         HXBondE6rx4fqDeJ5IdPbQ7DuggDsIuttvFt5lv/WnpEoL7ouq2dbkpCLsIl69kl6E
         YmQsbzPXUI8QQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 5CE1CF6079A;
        Fri, 14 Jan 2022 11:30:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: usb: Correct reset handling of smsc95xx
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164215981037.30922.12998188270283713363.git-patchwork-notify@kernel.org>
Date:   Fri, 14 Jan 2022 11:30:10 +0000
References: <20220113200113.30702-1-m.reichl@fivetechno.de>
In-Reply-To: <20220113200113.30702-1-m.reichl@fivetechno.de>
To:     Markus Reichl <m.reichl@fivetechno.de>
Cc:     steve.glendinning@shawell.net, UNGLinuxDriver@microchip.com,
        davem@davemloft.net, kuba@kernel.org, martyn.welch@collabora.com,
        ghojda@yo2urs.ro, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Thu, 13 Jan 2022 21:01:11 +0100 you wrote:
> On boards with LAN9514 and no preconfigured MAC address we don't get an
> ip address from DHCP after commit a049a30fc27c ("net: usb: Correct PHY handling
> of smsc95xx") anymore. Adding an explicit reset before starting the phy
> fixes the issue.
> 
> [1]
> https://lore.kernel.org/netdev/199eebbd6b97f52b9119c9fa4fd8504f8a34de18.camel@collabora.com/
> 
> [...]

Here is the summary with links:
  - net: usb: Correct reset handling of smsc95xx
    https://git.kernel.org/netdev/net/c/0bf3885324a8

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


