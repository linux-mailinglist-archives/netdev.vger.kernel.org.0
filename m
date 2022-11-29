Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C7D6263BDB0
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 11:12:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230083AbiK2KMA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Nov 2022 05:12:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232478AbiK2KLg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Nov 2022 05:11:36 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A83945E3CF;
        Tue, 29 Nov 2022 02:10:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4480A61620;
        Tue, 29 Nov 2022 10:10:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 895FAC433D7;
        Tue, 29 Nov 2022 10:10:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669716616;
        bh=3eKCHItsWSnQNAWASvCBxxLNZqKr4Q2+OOVfLGrAh6g=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=lFawjEVSME8aySxx+WiLk5T86VKrIXeryQt0Mvs3Z1cPBeYz5lI17wshNMLurUpjT
         P9oKFLTOdIYBtyh397s8CrCrbSSMsK4IIA18y/33zaBFdg2D8T8KD2dOLWEb3M24qD
         CxQQGbyGb2rYIpUfWS7ofWv2LGV9Qj42GV2pWo5NK5Jvh3s7au/IKJbTs3Xg6Ot/AI
         yVd2lR25t2ubCnUsPOb2tgB/cJYLAivgQB5RJedQnkTmvUILL4DJHeLhB6mFuVelBK
         BngfgbSU7lUrAqZlIydXtcuHQopHrXwCQ7/NTwoZVWXgfjjzR7Piq68LXqhQTmkiRL
         3P3k7CvD9LEzA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 6CF15C395EC;
        Tue, 29 Nov 2022 10:10:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2 0/7] Marvell nvmem mac addresses support
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166971661643.29836.9423706129492957108.git-patchwork-notify@kernel.org>
Date:   Tue, 29 Nov 2022 10:10:16 +0000
References: <20221124111556.264647-1-miquel.raynal@bootlin.com>
In-Reply-To: <20221124111556.264647-1-miquel.raynal@bootlin.com>
To:     Miquel Raynal <miquel.raynal@bootlin.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, netdev@vger.kernel.org, robh+dt@kernel.org,
        krzk+dt@kernel.org, devicetree@vger.kernel.org,
        robert.marko@sartura.hr, luka.perkov@sartura.hr,
        thomas.petazzoni@bootlin.com, michael@walle.cc, mw@semihalf.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        vadym.kochan@plvision.eu
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by Paolo Abeni <pabeni@redhat.com>:

On Thu, 24 Nov 2022 12:15:49 +0100 you wrote:
> Hello,
> 
> Now that we are aligned on how to make information available from static
> storage media to drivers like Ethernet controller drivers or switch
> drivers by using nvmem cells and going through the whole nvmem
> infrastructure, here are two driver updates to reflect these changes.
> 
> [...]

Here is the summary with links:
  - [net-next,v2,1/7] Revert "dt-bindings: marvell,prestera: Add description for device-tree bindings"
    https://git.kernel.org/netdev/net-next/c/98eb05dc99fd
  - [net-next,v2,2/7] dt-bindings: net: marvell,dfx-server: Convert to yaml
    https://git.kernel.org/netdev/net-next/c/63b956f99175
  - [net-next,v2,3/7] dt-bindings: net: marvell,prestera: Convert to yaml
    https://git.kernel.org/netdev/net-next/c/a429ab01163c
  - [net-next,v2,4/7] dt-bindings: net: marvell,prestera: Describe PCI devices of the prestera family
    https://git.kernel.org/netdev/net-next/c/39d103862015
  - [net-next,v2,5/7] of: net: export of_get_mac_address_nvmem()
    https://git.kernel.org/netdev/net-next/c/4c47867bc789
  - [net-next,v2,6/7] net: marvell: prestera: Avoid unnecessary DT lookups
    https://git.kernel.org/netdev/net-next/c/a48acad789ff
  - [net-next,v2,7/7] net: mvpp2: Consider NVMEM cells as possible MAC address source
    https://git.kernel.org/netdev/net-next/c/7a74c1265ab4

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


