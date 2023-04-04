Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F24AE6D5DB2
	for <lists+netdev@lfdr.de>; Tue,  4 Apr 2023 12:40:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234496AbjDDKkV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Apr 2023 06:40:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234439AbjDDKkT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Apr 2023 06:40:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B3F0171D;
        Tue,  4 Apr 2023 03:40:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D7B6860B88;
        Tue,  4 Apr 2023 10:40:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 3840DC433D2;
        Tue,  4 Apr 2023 10:40:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680604818;
        bh=BHkY1bcIaRuZGe2FrY9mgc4hNdy35R78BngNjIii8GI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=KSY/uu8LtWpijTxLNl9FnJvT9iMEx2lJsrf1lG7fhgnXWhzlDG6qdcbRwM7wL6BCH
         XbVo2NHjpVU7bHsqd24oviaoM+hGEVB6bHNYgFe1GVJIyMR7XDWa5T4Hlp6L1+dbRG
         KbvOXwDLlSlfBTX4JHANwNHEw0TR/O3Pxx9FCVhYRJh+agZNBIel8H0AvuqKViVLCX
         kEo4Eyf+49EAjtwfDZOuTQD59CbV+vdzMnp1siaWywtIdMhmA+KoORUUQBnmjBz37v
         Ae3dCtbbixssRlLm6T9JtlDIvPIeuoj1FWstuqnfDnBv+81JHkVlxZ91CvexmRdLZ8
         kSdF5enPBl+Gg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 19DBEE5EA85;
        Tue,  4 Apr 2023 10:40:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: ethernet: ti: am65-cpsw: Fix mdio cleanup in probe
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168060481810.9911.17255208221715242157.git-patchwork-notify@kernel.org>
Date:   Tue, 04 Apr 2023 10:40:18 +0000
References: <20230403090321.835877-1-s-vadapalli@ti.com>
In-Reply-To: <20230403090321.835877-1-s-vadapalli@ti.com>
To:     Siddharth Vadapalli <s-vadapalli@ti.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, rogerq@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        srk@ti.com
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (main)
by Paolo Abeni <pabeni@redhat.com>:

On Mon, 3 Apr 2023 14:33:21 +0530 you wrote:
> In the am65_cpsw_nuss_probe() function's cleanup path, the call to
> of_platform_device_destroy() for the common->mdio_dev device is invoked
> unconditionally. It is possible that either the MDIO node is not present
> in the device-tree, or the MDIO node is disabled in the device-tree. In
> both these cases, the MDIO device is not created, resulting in a NULL
> pointer dereference when the of_platform_device_destroy() function is
> invoked on the common->mdio_dev device on the cleanup path.
> 
> [...]

Here is the summary with links:
  - [net] net: ethernet: ti: am65-cpsw: Fix mdio cleanup in probe
    https://git.kernel.org/netdev/net/c/c6b486fb3368

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


