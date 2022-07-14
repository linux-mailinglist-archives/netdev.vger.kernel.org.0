Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 71D7B575698
	for <lists+netdev@lfdr.de>; Thu, 14 Jul 2022 22:50:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240584AbiGNUuR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jul 2022 16:50:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240580AbiGNUuQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jul 2022 16:50:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8BA143E47;
        Thu, 14 Jul 2022 13:50:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 77757B828D7;
        Thu, 14 Jul 2022 20:50:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 0627FC341C8;
        Thu, 14 Jul 2022 20:50:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657831813;
        bh=Gc7hd6A0rhnTNPpANrwASZ9kZF6yH5dYEfdNQYaKWos=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=O+F2nc1oGccGHGrqtuaX7hzSV/RPRaDQJqOQiyqy2W2EyMEHWZ4O2RuS31zk239Tt
         DIzHB7NY+sP/fVUcl8Rl/lsKIbG46no75wrTUVIDgRqVpUr+zgvcKwGfV0jRPRSFTr
         F3/F8pZoqUiYWA0D+cfvTaCSPC9NEnTrcelxhTwIDvULI6UoNjFdoALfvQGbJp2VOX
         4qZqT/qU+yQrARxruT8xSuKWxAYBDS6XuaJui6OPTfO7SHRTxiPVwJWSD9Orputzzk
         5Xy5UEex0OLhqDsWcjJxVEwnIab9/Qkjm3iyhK0pdD3NZF7Pi1g7CkkYrEMnwsoNIv
         8UBGxKbaEVv2g==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id E03A3E45225;
        Thu, 14 Jul 2022 20:50:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 bpf-next] xsk: mark napi_id on sendmsg()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165783181291.19017.2673215649469013294.git-patchwork-notify@kernel.org>
Date:   Thu, 14 Jul 2022 20:50:12 +0000
References: <20220707130842.49408-1-maciej.fijalkowski@intel.com>
In-Reply-To: <20220707130842.49408-1-maciej.fijalkowski@intel.com>
To:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Cc:     bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, netdev@vger.kernel.org,
        magnus.karlsson@intel.com, bjorn@kernel.org, kuba@kernel.org
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to bpf/bpf-next.git (master)
by Daniel Borkmann <daniel@iogearbox.net>:

On Thu,  7 Jul 2022 15:08:42 +0200 you wrote:
> When application runs in busy poll mode and does not receive a single
> packet but only sends them, it is currently
> impossible to get into napi_busy_loop() as napi_id is only marked on Rx
> side in xsk_rcv_check(). In there, napi_id is being taken from
> xdp_rxq_info carried by xdp_buff. From Tx perspective, we do not have
> access to it. What we have handy is the xsk pool.
> 
> [...]

Here is the summary with links:
  - [v2,bpf-next] xsk: mark napi_id on sendmsg()
    https://git.kernel.org/bpf/bpf-next/c/ca2e1a627035

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


