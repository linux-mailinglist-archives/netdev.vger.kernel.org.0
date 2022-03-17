Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00E084DBD20
	for <lists+netdev@lfdr.de>; Thu, 17 Mar 2022 03:40:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244156AbiCQCl2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Mar 2022 22:41:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234599AbiCQCl1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Mar 2022 22:41:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E1B01FCFB;
        Wed, 16 Mar 2022 19:40:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CD3A661501;
        Thu, 17 Mar 2022 02:40:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 2C015C340F9;
        Thu, 17 Mar 2022 02:40:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647484811;
        bh=vTg9bCjzbKN8xCysi4DgNH3ZTibUDMpo9k34u/96jew=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=fSqgQmsYUIjiXtOZZXjkkjj9w36FemxGUjI2D0j8e0IkDh0ybhxBR+8fwjwCfr57c
         7pcKS64LaSmzx50BnUqZ5aW7pqknA9LlIP7oltNeRuIALDOexumd92tzjCNJabnkcL
         pDgd4OGWDtVUfUWynlUchlKBDx7Ga+ZxRiQZ3TzJobGT3T9OgeRipeDxZGy3LvhpWD
         v+GjPUNeZt1AIkQ9CbM6ESQxrhDqucQvk+hmkULP4UmIWyLpB5KLmy9iyoch+R2EfY
         TE2aqJmQDFI635q42nsUkpgVuGWi53DN8fWsfYvkldDtIAhJPcr1qx4rbWr6QVkE+k
         06K8iuy0lF7ww==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id DEC8AF03845;
        Thu, 17 Mar 2022 02:40:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH -next] phy: Remove duplicated include in phy-fsl-lynx-28g.c
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164748481090.31245.11547820410255926210.git-patchwork-notify@kernel.org>
Date:   Thu, 17 Mar 2022 02:40:10 +0000
References: <20220315235603.59481-1-yang.lee@linux.alibaba.com>
In-Reply-To: <20220315235603.59481-1-yang.lee@linux.alibaba.com>
To:     Yang Li <yang.lee@linux.alibaba.com>
Cc:     ioana.ciornei@nxp.com, kishon@ti.com, vkoul@kernel.org,
        netdev@vger.kernel.org, linux-phy@lists.infradead.org,
        linux-kernel@vger.kernel.org, abaci@linux.alibaba.com
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 16 Mar 2022 07:56:03 +0800 you wrote:
> Fix following includecheck warning:
> ./drivers/phy/freescale/phy-fsl-lynx-28g.c: linux/workqueue.h is
> included more than once.
> 
> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
> 
> [...]

Here is the summary with links:
  - [-next] phy: Remove duplicated include in phy-fsl-lynx-28g.c
    https://git.kernel.org/netdev/net-next/c/4de7c8bd6a38

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


