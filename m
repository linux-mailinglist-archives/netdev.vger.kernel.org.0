Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 59A9858589B
	for <lists+netdev@lfdr.de>; Sat, 30 Jul 2022 06:30:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239849AbiG3EaV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Jul 2022 00:30:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232298AbiG3EaU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 30 Jul 2022 00:30:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB100167C7
        for <netdev@vger.kernel.org>; Fri, 29 Jul 2022 21:30:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AD68B60A50
        for <netdev@vger.kernel.org>; Sat, 30 Jul 2022 04:30:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id F3496C433D7;
        Sat, 30 Jul 2022 04:30:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659155417;
        bh=VRlbLFKpbkdmm8iYunAtdQj+pPTyf0xoXArpBpcqtmw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=K0Ke6e4+QCJgtJ5RGKk+L/CbECDI2BOnVLS6ztTtezzuCwknkqUico5nLAlwCFyIJ
         6dvvcWG2D0u/+uATEYpFMqfqbtfC0zvZuAw3VOLFLQU33L+S+AeDzpoBN3rPmmnvyO
         nygtSjLn0n86I4+/LnOiPw5w9ox3Y+cdsoAq8xpbz8qpm1KkYAngAiqB5VLV0CfnRb
         slu9FD94y0BEITZZiQ71QwcnWA2GVMUL/EaQbjr8ta31Cf1ZBOBx2PhRNZ7sF3Nkgp
         W6mddqr6wFB+ePY24ea+dIjqesIg0H7UC52509P1Tig9ZskmyxshZoRep4hVqiDki1
         MBtExaNJSn2NQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id D141CC43143;
        Sat, 30 Jul 2022 04:30:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v3 00/10] sfc: VF representors for EF100 - RX side
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165915541685.4914.132372456330250954.git-patchwork-notify@kernel.org>
Date:   Sat, 30 Jul 2022 04:30:16 +0000
References: <cover.1659034549.git.ecree.xilinx@gmail.com>
In-Reply-To: <cover.1659034549.git.ecree.xilinx@gmail.com>
To:     <ecree@xilinx.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        linux-net-drivers@amd.com, netdev@vger.kernel.org,
        ecree.xilinx@gmail.com
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 28 Jul 2022 19:57:42 +0100 you wrote:
> From: Edward Cree <ecree.xilinx@gmail.com>
> 
> This series adds the receive path for EF100 VF representors, plus other
>  minor features such as statistics.
> 
> Changes in v3: dropped MAC address setting as it was semantically incorrect.
> Changes in v2: fixed build failure on CONFIG_SFC_SRIOV=n (kernel test robot).
> 
> [...]

Here is the summary with links:
  - [net-next,v3,01/10] sfc: plumb ef100 representor stats
    https://git.kernel.org/netdev/net-next/c/a95115c407a2
  - [net-next,v3,02/10] sfc: ef100 representor RX NAPI poll
    https://git.kernel.org/netdev/net-next/c/69bb5fa73d2b
  - [net-next,v3,03/10] sfc: ef100 representor RX top half
    https://git.kernel.org/netdev/net-next/c/9fe00c800ecd
  - [net-next,v3,04/10] sfc: determine wire m-port at EF100 PF probe time
    https://git.kernel.org/netdev/net-next/c/6f6838aabff5
  - [net-next,v3,05/10] sfc: check ef100 RX packets are from the wire
    https://git.kernel.org/netdev/net-next/c/08d0b16ecb36
  - [net-next,v3,06/10] sfc: receive packets from EF100 VFs into representors
    https://git.kernel.org/netdev/net-next/c/f50e8fcda6b8
  - [net-next,v3,07/10] sfc: insert default MAE rules to connect VFs to representors
    https://git.kernel.org/netdev/net-next/c/67ab160ed08f
  - [net-next,v3,08/10] sfc: move table locking into filter_table_{probe,remove} methods
    https://git.kernel.org/netdev/net-next/c/77eb40749d73
  - [net-next,v3,09/10] sfc: use a dynamic m-port for representor RX and set it promisc
    https://git.kernel.org/netdev/net-next/c/e37f3b1561a0
  - [net-next,v3,10/10] sfc: implement ethtool get/set RX ring size for EF100 reps
    https://git.kernel.org/netdev/net-next/c/7267aa6d99f5

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


