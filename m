Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8ABB96441C5
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 12:02:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230313AbiLFLBf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 06:01:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234542AbiLFLAr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 06:00:47 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01D3823158;
        Tue,  6 Dec 2022 03:00:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AFB66B81901;
        Tue,  6 Dec 2022 11:00:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 51013C433B5;
        Tue,  6 Dec 2022 11:00:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670324415;
        bh=U/0VRHgrSM8Y5IYzd71Kgi5ZjK26Pe6Xi2PyRPfYrQg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=am4/9U0zvVzyxAAInh8alvrsL3uewSBCE8AcQhoGwqYTowbwW9yND/qcDF0Dkfe9H
         leSs+ZRh/xHn4RDFJScbIuuWMBCBkKudpi2wLui2y961gklERM1qm/F6H8paXRbKJl
         6T5cpslbOWxe4rG2bmt3C5JgdLH5PRbbXHbB7yYmIjr2dajCUBM4+IBAqRQGmVPyzE
         Jx5giLmOpAzvlObobedwr3ldIv9Pc8YeX51DXOEoxDscF6QfAPUhmRvcYnbUzQhCex
         Zqms7T50IUC6Mmxi2xTzERhwxZGYdyKXigXIv+uohFcSPRjHuSALH8296ibVnKGPKv
         6D56q2fbqLyVA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 385FDC395E5;
        Tue,  6 Dec 2022 11:00:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2] net: microchip: sparx5: Fix missing destroy_workqueue of
 mact_queue
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167032441522.13103.458741845784845586.git-patchwork-notify@kernel.org>
Date:   Tue, 06 Dec 2022 11:00:15 +0000
References: <20221203070259.19560-1-linqiheng@huawei.com>
In-Reply-To: <20221203070259.19560-1-linqiheng@huawei.com>
To:     Qiheng Lin <linqiheng@huawei.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, lars.povlsen@microchip.com,
        Steen.Hegelund@microchip.com, daniel.machon@microchip.com,
        UNGLinuxDriver@microchip.com, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
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
by Paolo Abeni <pabeni@redhat.com>:

On Sat, 3 Dec 2022 15:02:59 +0800 you wrote:
> The mchp_sparx5_probe() won't destroy workqueue created by
> create_singlethread_workqueue() in sparx5_start() when later
> inits failed. Add destroy_workqueue in the cleanup_ports case,
> also add it in mchp_sparx5_remove()
> 
> Fixes: b37a1bae742f ("net: sparx5: add mactable support")
> Signed-off-by: Qiheng Lin <linqiheng@huawei.com>
> 
> [...]

Here is the summary with links:
  - [v2] net: microchip: sparx5: Fix missing destroy_workqueue of mact_queue
    https://git.kernel.org/netdev/net/c/7b8232bdb178

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


