Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9F42560079
	for <lists+netdev@lfdr.de>; Wed, 29 Jun 2022 14:55:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233437AbiF2Mu1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jun 2022 08:50:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233427AbiF2MuX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jun 2022 08:50:23 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7EA032EF5
        for <netdev@vger.kernel.org>; Wed, 29 Jun 2022 05:50:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A8E15B8241E
        for <netdev@vger.kernel.org>; Wed, 29 Jun 2022 12:50:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 54AD1C341D1;
        Wed, 29 Jun 2022 12:50:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656507020;
        bh=vst2VfpHQtD6kF9Fkz/ITluE/HWUXe1/ekoMZyvd53g=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=OJQIUnpj8DK17Z1Gr7EhxR/owzkMNniSlJo3DM1ORcfCPAE+j278kozgL05llnTZt
         6DVxRPZ7z7wcxNlQeV91Z/b/Yrugut9TW1IBnbKmqzcBNnkRrZ4xt0Ldj7WPkPcuwj
         TSn8sdvDxK0JkF+KGC4b4PnNhFi4vYuGuUPIXmOT5v+BXwgTrNY5uhTfoK/OFdlKjq
         57Y5xrbl/PgCCmaebLoH/wu/LVFTo8bOHxBOZ2ExZb1v5KSg99NkUEkhWdSUXP3ai0
         vy4xdLnIfpjHSzsFHBDuYF/jRatBcmE3FCo33IRAwsGIFZAiexIxZgy5wKwcWtuQZ3
         eAjbSGUH7o/yQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 355B7E49F61;
        Wed, 29 Jun 2022 12:50:20 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2 00/10]  sfc: Add extra states for VDPA
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165650702021.9231.8524288962828359852.git-patchwork-notify@kernel.org>
Date:   Wed, 29 Jun 2022 12:50:20 +0000
References: <165642465886.31669.17429834766693417246.stgit@palantir17.mph.net>
In-Reply-To: <165642465886.31669.17429834766693417246.stgit@palantir17.mph.net>
To:     Martin Habets <habetsm.xilinx@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, jonathan.s.cooper@amd.com,
        netdev@vger.kernel.org, ecree.xilinx@gmail.com
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
by David S. Miller <davem@davemloft.net>:

On Tue, 28 Jun 2022 14:58:43 +0100 you wrote:
> For EF100 VDPA support we need to enhance the sfc driver's load and
> unload functionality so that it can probe and then unregister its
> network device, so that VDPA can use services such as MCDI to initialise
> VDPA resources.
> 
> v2:
> - Fix checkpatch errors.
> - Correct signoffs.
> 
> [...]

Here is the summary with links:
  - [net-next,v2,01/10] sfc: Split STATE_READY in to STATE_NET_DOWN and STATE_NET_UP.
    https://git.kernel.org/netdev/net-next/c/813cf9d1e753
  - [net-next,v2,02/10] sfc: Add a PROBED state for EF100 VDPA use.
    https://git.kernel.org/netdev/net-next/c/8b39db19b21b
  - [net-next,v2,03/10] sfc: Remove netdev init from efx_init_struct
    https://git.kernel.org/netdev/net-next/c/62ac3ce542ff
  - [net-next,v2,04/10] sfc: Change BUG_ON to WARN_ON and recovery code.
    https://git.kernel.org/netdev/net-next/c/b3fd0a86dad2
  - [net-next,v2,05/10] sfc: Encapsulate access to netdev_priv()
    https://git.kernel.org/netdev/net-next/c/8cb03f4e084e
  - [net-next,v2,06/10] sfc: Separate efx_nic memory from net_device memory
    https://git.kernel.org/netdev/net-next/c/7e773594dada
  - [net-next,v2,07/10] sfc: Move EF100 efx_nic_type structs to the end of the file
    https://git.kernel.org/netdev/net-next/c/3e341d84bd9f
  - [net-next,v2,08/10] sfc: Unsplit literal string.
    https://git.kernel.org/netdev/net-next/c/bba84bf4c1f2
  - [net-next,v2,09/10] sfc: replace function name in string with __func__
    https://git.kernel.org/netdev/net-next/c/7592d754c09c
  - [net-next,v2,10/10] sfc: Separate netdev probe/remove from PCI probe/remove
    https://git.kernel.org/netdev/net-next/c/98ff4c7c8ac7

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


