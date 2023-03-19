Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E9446C002D
	for <lists+netdev@lfdr.de>; Sun, 19 Mar 2023 09:50:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230049AbjCSIuX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Mar 2023 04:50:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230265AbjCSIuU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Mar 2023 04:50:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCB30F756;
        Sun, 19 Mar 2023 01:50:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BDA3160F57;
        Sun, 19 Mar 2023 08:50:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 1A080C433D2;
        Sun, 19 Mar 2023 08:50:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679215817;
        bh=6RHf1C+OCmzWoKQezodfCUaNabA6BFOxV8iPo+xBnPQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=MGN6yldwBHASTB6xQctJpzezKknB6l9X4XOz4cVPgV5g1tzdcYyaW3XhWFqd0ei3w
         TRuEZCmV+vl7fj8qI2UozyH/PChSPwVDW5StkHk1WGgTOVHVndNVBV74zpvM7N/z36
         aqxkaFiBH15PVGAymt/1zwk6qA1g56AxFOvP7Sl2CsoYvIvzSMHdXNrwMxjV8mHXYu
         uv6Q1/fCcugBVyxMMcF4jbxfMJ8ZtmHmq3jqbR5pD7BcBbxlPVKRo38PJzfAjhiyOM
         Z/2H13ykwfQxKO7ZENY5uVWOB+btMNABZZpiCzKikEqgDdVhlk+va79tjpSrTtOAYF
         73N8aLFy+KP6Q==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 00262C43161;
        Sun, 19 Mar 2023 08:50:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2] qed/qed_sriov: guard against NULL derefs from
 qed_iov_get_vf_info
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167921581699.28457.11728066324665280341.git-patchwork-notify@kernel.org>
Date:   Sun, 19 Mar 2023 08:50:16 +0000
References: <20230316102921.609266-1-d-tatianin@yandex-team.ru>
In-Reply-To: <20230316102921.609266-1-d-tatianin@yandex-team.ru>
To:     Daniil Tatianin <d-tatianin@yandex-team.ru>
Cc:     aelior@marvell.com, manishc@marvell.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        Yuval.Mintz@qlogic.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (main)
by David S. Miller <davem@davemloft.net>:

On Thu, 16 Mar 2023 13:29:21 +0300 you wrote:
> We have to make sure that the info returned by the helper is valid
> before using it.
> 
> Found by Linux Verification Center (linuxtesting.org) with the SVACE
> static analysis tool.
> 
> Fixes: f990c82c385b ("qed*: Add support for ndo_set_vf_trust")
> Fixes: 733def6a04bf ("qed*: IOV link control")
> Signed-off-by: Daniil Tatianin <d-tatianin@yandex-team.ru>
> 
> [...]

Here is the summary with links:
  - [v2] qed/qed_sriov: guard against NULL derefs from qed_iov_get_vf_info
    https://git.kernel.org/netdev/net/c/25143b6a01d0

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


