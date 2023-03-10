Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 508616B3795
	for <lists+netdev@lfdr.de>; Fri, 10 Mar 2023 08:41:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230404AbjCJHln (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Mar 2023 02:41:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230392AbjCJHkv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Mar 2023 02:40:51 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DECE0105F30;
        Thu,  9 Mar 2023 23:40:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 63023B821DE;
        Fri, 10 Mar 2023 07:40:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E8A70C4331E;
        Fri, 10 Mar 2023 07:40:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678434021;
        bh=wvcMHdJRRBs9HZji361PEDZYsBjS1f+O9OuS3HjOHuw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=XW38VndKYE3BaPFzV4GpRkpuoRf12flVpDlI180EjYpZLkeBWbyJSaEA5xSDRecCp
         hCSXpMaoSsaRW+7DFWCtrKXEA/EaiXmevfhNnT/DiffnUQJ6BXbWcq2x/wX4+o6uOR
         FjWKZ7Jb91ptWu3zoFFGumYBYw09fuGwoTCQsuOcdnRvl0jyldEgAEwXRFW5QkYcke
         pkidt4IDdwH8prxTUVehzTzhXoxSEqZBBBmxkWPLo8Vt7qrbMi5zoFOX11j2xJWT7g
         3g1VmIvmMrnp0FWqlvA8/5dz+v2DzOowXj2ayM8A0u1XmutM+VLgFrKB0+50DvpmkB
         JIX47D+g/xYkg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id CC820E270DD;
        Fri, 10 Mar 2023 07:40:20 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: restore alpha order to Ethernet devices in config
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167843402083.26917.15568614307797182755.git-patchwork-notify@kernel.org>
Date:   Fri, 10 Mar 2023 07:40:20 +0000
References: <20230307221051.890135-1-helgaas@kernel.org>
In-Reply-To: <20230307221051.890135-1-helgaas@kernel.org>
To:     Bjorn Helgaas <helgaas@kernel.org>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, jiawenwu@trustnetic.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bhelgaas@google.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Tue,  7 Mar 2023 16:10:51 -0600 you wrote:
> From: Bjorn Helgaas <bhelgaas@google.com>
> 
> The filename "wangxun" sorts between "intel" and "xscale", but
> xscale/Kconfig contains "Intel XScale" prompts, so Wangxun ends up in the
> wrong place in the config front-ends.
> 
> Move wangxun/Kconfig so the Wangxun devices appear in order in the user
> interface.
> 
> [...]

Here is the summary with links:
  - net: restore alpha order to Ethernet devices in config
    https://git.kernel.org/netdev/net-next/c/a1331535aeb4

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


