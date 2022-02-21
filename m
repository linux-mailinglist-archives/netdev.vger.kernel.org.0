Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C056E4BDE98
	for <lists+netdev@lfdr.de>; Mon, 21 Feb 2022 18:47:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356040AbiBULTr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Feb 2022 06:19:47 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:48150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355978AbiBULSH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Feb 2022 06:18:07 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A064017055
        for <netdev@vger.kernel.org>; Mon, 21 Feb 2022 03:00:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 37D5861168
        for <netdev@vger.kernel.org>; Mon, 21 Feb 2022 11:00:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 9CE9BC340EB;
        Mon, 21 Feb 2022 11:00:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645441211;
        bh=hx3oLo4QdHA7gn5CIdOjxnsTb5LksUD/zsT64E8cgjs=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=hy0csiMUc1PcGJHbrpRHNg/Z12nlzUdq8XyFRJXeFuWLAhGQ7Fhp5tVpmKFjkvmLS
         tyGf261i3BytOSgxvLObkRGi0LoWrTSivA2A8jZDfoQkWahL3wgytVyBhb3dxfo0fp
         NEL/UbrACXFJyfi1JFm2BNt31OzQeiPvODbB+Fj3bju/ZYHqs6dgQhqVagd8SJETsn
         PYvU/pM3Phv5MujKAl7N22Ehal2n5aTZibsn0jYsvhAmxcD+Mg2aT6VinZOrokXRSA
         j0Dloja0nPr+UsG4SDQPGD/cCbFmFJ42cLtgTm5ajZgmNP4iOhdOC/xpjj+ybYaDAQ
         hjbihWMN8XhVg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 7D3E7E5CF96;
        Mon, 21 Feb 2022 11:00:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/7] bnxt_en: Bug fixes
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164544121150.23639.11057842154424068505.git-patchwork-notify@kernel.org>
Date:   Mon, 21 Feb 2022 11:00:11 +0000
References: <1645347953-27003-1-git-send-email-michael.chan@broadcom.com>
In-Reply-To: <1645347953-27003-1-git-send-email-michael.chan@broadcom.com>
To:     Michael Chan <michael.chan@broadcom.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        gospo@broadcom.com
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

This series was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Sun, 20 Feb 2022 04:05:46 -0500 you wrote:
> This series contains bug fixes for FEC reporting, ethtool self test,
> multicast setup, devlink health reporting and live patching, and
> a firmware response timeout.
> 
> Kalesh AP (2):
>   bnxt_en: Restore the resets_reliable flag in bnxt_open()
>   bnxt_en: Fix devlink fw_activate
> 
> [...]

Here is the summary with links:
  - [net,1/7] bnxt_en: Fix active FEC reporting to ethtool
    https://git.kernel.org/netdev/net/c/84d3c83e6ea7
  - [net,2/7] bnxt_en: Fix offline ethtool selftest with RDMA enabled
    https://git.kernel.org/netdev/net/c/6758f937669d
  - [net,3/7] bnxt_en: Fix occasional ethtool -t loopback test failures
    https://git.kernel.org/netdev/net/c/cfcab3b3b615
  - [net,4/7] bnxt_en: Fix incorrect multicast rx mask setting when not requested
    https://git.kernel.org/netdev/net/c/8cdb15924252
  - [net,5/7] bnxt_en: Restore the resets_reliable flag in bnxt_open()
    https://git.kernel.org/netdev/net/c/0e0e3c535847
  - [net,6/7] bnxt_en: Increase firmware message response DMA wait time
    https://git.kernel.org/netdev/net/c/b891106da52b
  - [net,7/7] bnxt_en: Fix devlink fw_activate
    https://git.kernel.org/netdev/net/c/1278d17a1fb8

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


