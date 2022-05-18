Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 474AD52BC74
	for <lists+netdev@lfdr.de>; Wed, 18 May 2022 16:16:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237543AbiERNK2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 May 2022 09:10:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237535AbiERNKR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 May 2022 09:10:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D26817B851;
        Wed, 18 May 2022 06:10:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D2EE5B82032;
        Wed, 18 May 2022 13:10:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 7CB1CC36AE2;
        Wed, 18 May 2022 13:10:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652879413;
        bh=yopJBrymAGv8hrzx/cz6109W5zx6EL0S7W74oPz0Wbo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=fcSFyseC494l5VnUIljp4rWVTPPPPLOQhkBv1zOWTy60KACoKERcsKD+8fseJ1FZU
         VVZRYnvGb8VFq8ujyE6MWZF3FhiIApfRd6vP1YACfziuf2s80i5T1JSLcCRsVPqbG2
         F7UlIhgNfkkzHOQ9BPVwyXns5ato1EqzvfowipptGr0X7IUuqawsw4pCQs20Nh44Fn
         l1PkKHN+Y+sekcXhnbxum8IqoE40mI8Uf5m5cvVm1CO4iLAMS5rng97kCQWZi6OHa7
         wyM7sUXFp0X0mMJ2lX/8WdVyVdaTAjMP4TgX+KQTHgemzjhqcZpoaXNq9jU5uRGhPn
         qhF62JcLIvMdw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 5DAA8F03935;
        Wed, 18 May 2022 13:10:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH -next v2] net: ethernet: sunplus: add missing of_node_put() in
 spl2sw_mdio_init()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165287941338.26952.5380355560504992321.git-patchwork-notify@kernel.org>
Date:   Wed, 18 May 2022 13:10:13 +0000
References: <20220518020812.2626293-1-yangyingliang@huawei.com>
In-Reply-To: <20220518020812.2626293-1-yangyingliang@huawei.com>
To:     Yang Yingliang <yangyingliang@huawei.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        wellslutw@gmail.com, andrew@lunn.ch, pabeni@redhat.com,
        davem@davemloft.net, kuba@kernel.org
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Wed, 18 May 2022 10:08:12 +0800 you wrote:
> of_get_child_by_name() returns device node pointer with refcount
> incremented. The refcount should be decremented before returning
> from spl2sw_mdio_init().
> 
> Fixes: fd3040b9394c ("net: ethernet: Add driver for Sunplus SP7021")
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
> 
> [...]

Here is the summary with links:
  - [-next,v2] net: ethernet: sunplus: add missing of_node_put() in spl2sw_mdio_init()
    https://git.kernel.org/netdev/net-next/c/223153ea6c79

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


