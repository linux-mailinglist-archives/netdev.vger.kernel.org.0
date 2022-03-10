Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CDE8A4D5316
	for <lists+netdev@lfdr.de>; Thu, 10 Mar 2022 21:30:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243134AbiCJUbO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Mar 2022 15:31:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239379AbiCJUbN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Mar 2022 15:31:13 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AB39ECB03;
        Thu, 10 Mar 2022 12:30:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D44416179A;
        Thu, 10 Mar 2022 20:30:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 2F464C340F5;
        Thu, 10 Mar 2022 20:30:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646944210;
        bh=P8GXSJtGS9vWK7KLpSBtCJ/qJIolUoM2eF1tNgOWcQE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=UbXWkqW4AhEQ5EoqOpKySLsGH65tRAHjBfLHhftS3RnsEB7xg0vApvCOVbnCR0kzY
         k1UkMQEpWVYL4fErBj5pBjLgjQkCrNg3MnNaJuOKFPxzidK+ksQ5L36jw0O5bUosKz
         si7J8nu1HKgWbxTpDaqCSurZ3zKcquwWAH7rNWWoMgBtCQ417GvsTAXXfcOe/lzQUb
         l9B5HD5snxcn5W9fumF+1oRrHorPBpjWD0O4jsA20VE1XG5Ng/OW9p/gGXLHBd2qXN
         BpXzftnPPBrXUMX7G9Sjhk2xK+QQumjyrH8uMI2BDd5Wp+MTVAy9G4IpMdQ7/7v1td
         mj8SX19VSoLpQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 0F3EDE8DD5B;
        Thu, 10 Mar 2022 20:30:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] ethtool: Fix refcount leak in gfar_get_ts_info
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164694421005.25928.8192632263617789696.git-patchwork-notify@kernel.org>
Date:   Thu, 10 Mar 2022 20:30:10 +0000
References: <20220309091149.775-1-linmq006@gmail.com>
In-Reply-To: <20220309091149.775-1-linmq006@gmail.com>
To:     Miaoqian Lin <linmq006@gmail.com>
Cc:     claudiu.manoil@nxp.com, davem@davemloft.net, kuba@kernel.org,
        yangbo.lu@nxp.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Wed,  9 Mar 2022 09:11:49 +0000 you wrote:
> The of_find_compatible_node() function returns a node pointer with
> refcount incremented, We should use of_node_put() on it when done
> Add the missing of_node_put() to release the refcount.
> 
> Fixes: 7349a74ea75c ("net: ethernet: gianfar_ethtool: get phc index through drvdata")
> Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
> 
> [...]

Here is the summary with links:
  - ethtool: Fix refcount leak in gfar_get_ts_info
    https://git.kernel.org/netdev/net/c/2ac5b58e645c

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


