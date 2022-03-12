Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 51AF44D6D40
	for <lists+netdev@lfdr.de>; Sat, 12 Mar 2022 08:40:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231228AbiCLHlX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Mar 2022 02:41:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231205AbiCLHlV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Mar 2022 02:41:21 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2512E11A2E
        for <netdev@vger.kernel.org>; Fri, 11 Mar 2022 23:40:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ABE4660C02
        for <netdev@vger.kernel.org>; Sat, 12 Mar 2022 07:40:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 1C57CC340ED;
        Sat, 12 Mar 2022 07:40:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647070816;
        bh=zQCb5fEKaves1c9eujcJUffdMNVR4ZGdDoHIWWpq8Lg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=JavKuyQtWfj7vxTiWOTWGduR+sgoWFjdnfDa86nnrf12gr4XqqXPQ25RXuh9nP18t
         0iFfdh5Q2UC/Cx3uGjla1vNItKz/Djul352oobogtttqofWdvDO1wi8ygS2jc8ItY7
         +Yj7OM2YLsIDfPHhDbvlt0LmqJE32ZMfbcIyueX37ePWIR0X1o+fTsFR+91S1iPP2P
         GOeooDyT7iL0EZqbdPh+5errcct9oicVpq7FKZP9/jap1w/+AxHEBc6NxkygfldYf1
         uBhtfezujSMOjCAnAUApcNQ0jqxdqyT1aNfCYnaEG8Nd1ccinMPpP11F8Dd3O6p1H2
         T33mmx6Pocp3w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 069A3E6D3DD;
        Sat, 12 Mar 2022 07:40:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/11] nfp: preliminary support for NFP-3800
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164707081602.11016.3175676799335418676.git-patchwork-notify@kernel.org>
Date:   Sat, 12 Mar 2022 07:40:16 +0000
References: <20220311104306.28357-1-simon.horman@corigine.com>
In-Reply-To: <20220311104306.28357-1-simon.horman@corigine.com>
To:     Simon Horman <simon.horman@corigine.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        oss-drivers@corigine.com
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Fri, 11 Mar 2022 11:42:55 +0100 you wrote:
> Hi,
> 
> This series is the first step to add support to the NFP driver for the
> new NFP-3800 device. In this first series the goal is to clean
> up small issues found while adding support for the new device, prepare
> an abstraction of the differences between the already supported devices
> and the new Kestrel device and add the new PCI ID.
> 
> [...]

Here is the summary with links:
  - [net-next,01/11] nfp: remove defines for unused control bits
    https://git.kernel.org/netdev/net-next/c/940ea0eae31b
  - [net-next,02/11] nfp: remove pessimistic NFP_QCP_MAX_ADD limits
    https://git.kernel.org/netdev/net-next/c/f6df1aa628f5
  - [net-next,03/11] nfp: use PCI_DEVICE_ID_NETRONOME_NFP6000_VF for VFs instead
    https://git.kernel.org/netdev/net-next/c/113e96241631
  - [net-next,04/11] nfp: use PluDevice register for model for non-NFP6000 chips
    https://git.kernel.org/netdev/net-next/c/5d1359ed5d69
  - [net-next,05/11] nfp: sort the device ID tables
    https://git.kernel.org/netdev/net-next/c/7ab7985df257
  - [net-next,06/11] nfp: introduce dev_info static chip data
    https://git.kernel.org/netdev/net-next/c/9423d24b7b84
  - [net-next,07/11] nfp: use dev_info for PCIe config space BAR offsets
    https://git.kernel.org/netdev/net-next/c/f524b335c08c
  - [net-next,08/11] nfp: use dev_info for the DMA mask
    https://git.kernel.org/netdev/net-next/c/9ba1dc994ff5
  - [net-next,09/11] nfp: parametrize QCP offset/size using dev_info
    https://git.kernel.org/netdev/net-next/c/e900db704c85
  - [net-next,10/11] nfp: take chip version into account for ring sizes
    https://git.kernel.org/netdev/net-next/c/7f3aa620f86a
  - [net-next,11/11] nfp: add support for NFP3800/NFP3803 PCIe devices
    https://git.kernel.org/netdev/net-next/c/d3826a95222c

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


