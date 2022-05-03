Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5CC7A5180DC
	for <lists+netdev@lfdr.de>; Tue,  3 May 2022 11:20:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233410AbiECJX7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 May 2022 05:23:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233384AbiECJXr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 May 2022 05:23:47 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C0E42FB;
        Tue,  3 May 2022 02:20:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 30E12B81BE1;
        Tue,  3 May 2022 09:20:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E7A45C385B1;
        Tue,  3 May 2022 09:20:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651569612;
        bh=EyqTsj+EFSH0FDi1wlRyfZ3SuBunmGQ6/GwrNH9g75M=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=b5QnscaClWg8zHPBXgBLJAKzBa6tXlrPYMROQAcwl3fkUGZRMGULpFcIOYzRFAEtu
         7OGlmXds2MgCMgvnpYhjgIQjK9LprrtwxrQ2k9jB5eQNnkL6RA5K+Z/LRdU3zphBEj
         vyJS3woxYsukryJwQqTTBcf3LzY7tDdWzPW4ksTwUvgE+0XBVhzVZTmz7NQb5Pzzjt
         Qqrcen7RnzioE9OgtG+VnpDUImnRcMzKhcG/t+YfDd7wHb0j3K60DKlMEpsMNjXYVY
         W56X4jZ41T5K8pC3jYgAhq/pZFNYik2Z1bV9M5W8fkKVQmdXDgZ6SmdFOgvwoT0dr1
         M1dh+q0OgMuvA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id C8616E6D402;
        Tue,  3 May 2022 09:20:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v3 0/2] emaclite: improve error handling and minor cleanup
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165156961181.14392.1143841142923055391.git-patchwork-notify@kernel.org>
Date:   Tue, 03 May 2022 09:20:11 +0000
References: <1651476470-23904-1-git-send-email-radhey.shyam.pandey@xilinx.com>
In-Reply-To: <1651476470-23904-1-git-send-email-radhey.shyam.pandey@xilinx.com>
To:     Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        michal.simek@xilinx.com, andrew@lunn.ch, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, git@xilinx.com
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

This series was applied to netdev/net.git (master)
by Paolo Abeni <pabeni@redhat.com>:

On Mon, 2 May 2022 12:57:48 +0530 you wrote:
> This patchset does error handling for of_address_to_resource() and also
> removes "Don't advertise 1000BASE-T" and auto negotiation.
> 
> Changes for v3:
> - Resolve git apply conflicts for 2/2 patch.
> 
> Changes for v2:
> - Added Andrew's reviewed by tag in 1/2 patch.
> - Move ret to down to align with reverse xmas tree style in 2/2 patch.
> - Also add fixes tag in 2/2 patch.
> - Specify tree name in subject prefix.
> 
> [...]

Here is the summary with links:
  - [net,v3,1/2] net: emaclite: Don't advertise 1000BASE-T and do auto negotiation
    https://git.kernel.org/netdev/net/c/b800528b97d0
  - [net,v3,2/2] net: emaclite: Add error handling for of_address_to_resource()
    https://git.kernel.org/netdev/net/c/7a6bc33ab549

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


