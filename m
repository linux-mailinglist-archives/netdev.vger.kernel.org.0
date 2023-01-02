Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C56965B2E5
	for <lists+netdev@lfdr.de>; Mon,  2 Jan 2023 14:50:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236003AbjABNuT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Jan 2023 08:50:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229583AbjABNuS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Jan 2023 08:50:18 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5ECF422B;
        Mon,  2 Jan 2023 05:50:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E9C5D60EBA;
        Mon,  2 Jan 2023 13:50:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 3B251C433F0;
        Mon,  2 Jan 2023 13:50:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672667416;
        bh=ciW3s8dzacHToNPw4OvYdC/uY2aoAut0zkxVNyVnPQg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=rL00nTii6xsb0dajf/qS99eZFVKxppKd0Vc32WAaKuWp2E9OZKFvudOVz8xNHMKK2
         yG1eBtjMjF+sRJKtrOC1gbxMraqN74mud1EBw/JhDgf49LyOWxaVaRoXXHx2sui+cO
         W3YhRfm02uhp81yET09R6Au2g2Zx+xZqV5NCnfdD95WxHO4ogDb6/6am0JF2AduQCF
         Xkl+0BfYN5spYxwBUjTpvboma8+FcT0FGXFbzKpyuOf+osnhASvBdZxw4aXhzjeuW4
         KHugRjP4hn6e5+PpsfJn4/llAJ6pfKDWh8rtADuM00ybn/VzkPG0/VlTgP09BS31Zr
         COozlbXd9TW5A==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 1C1E6E5724D;
        Mon,  2 Jan 2023 13:50:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: sparx5: Fix reading of the MAC address
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167266741611.20674.15551725779256774063.git-patchwork-notify@kernel.org>
Date:   Mon, 02 Jan 2023 13:50:16 +0000
References: <20230102121215.2697179-1-horatiu.vultur@microchip.com>
In-Reply-To: <20230102121215.2697179-1-horatiu.vultur@microchip.com>
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
Cc:     netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        lars.povlsen@microchip.com, Steen.Hegelund@microchip.com,
        daniel.machon@microchip.com, UNGLinuxDriver@microchip.com,
        casper.casan@gmail.com, rmk+kernel@armlinux.org.uk,
        linqiheng@huawei.com, nathan@kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Mon, 2 Jan 2023 13:12:15 +0100 you wrote:
> There is an issue with the checking of the return value of
> 'of_get_mac_address', which returns 0 on success and negative value on
> failure. The driver interpretated the result the opposite way. Therefore
> if there was a MAC address defined in the DT, then the driver was
> generating a random MAC address otherwise it would use address 0.
> Fix this by checking correctly the return value of 'of_get_mac_address'
> 
> [...]

Here is the summary with links:
  - [net] net: sparx5: Fix reading of the MAC address
    https://git.kernel.org/netdev/net/c/588ab2dc25f6

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


