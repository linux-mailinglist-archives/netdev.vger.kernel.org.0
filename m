Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 545004D5317
	for <lists+netdev@lfdr.de>; Thu, 10 Mar 2022 21:30:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244652AbiCJUbP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Mar 2022 15:31:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232725AbiCJUbN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Mar 2022 15:31:13 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DB96ECB10;
        Thu, 10 Mar 2022 12:30:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DD1616179E;
        Thu, 10 Mar 2022 20:30:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 39F9BC340F7;
        Thu, 10 Mar 2022 20:30:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646944210;
        bh=eREIy7aXyXOJiNE/a+y3BVUxOQadsmenqakhiafoC0s=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=QgMbCyroHXEFfM5i5u1MfFEghBG0gbawl16KY3a3t7lhPUV0SRh0fEb3qSieURQbU
         pbADUMJFe46PI8F2ke5jKo5P59bzkjbtb4Fand4ZobKA/lK12hKCJJi6fWqXE9B+8J
         6jFfPEZIOflaNfav7kIwk8ylw6ccyHPqctJadf9evkGI8ZFEeTma2BLadQORurmEwO
         1YDxu29zRjjZTcIkx6Ip1X9vlLXZ2QYyutEifigbPeR56jIoEkZrkI51Tae9EJWC9W
         ZtXFsS6JRAFGgthTrKJQX/MTzjTJ9giJvQGEw2ZI351BB7hoEephjvl7DoelwAwwSF
         S/F6adZNpZrUw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 18610F0383F;
        Thu, 10 Mar 2022 20:30:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v2] gianfar: ethtool: Fix refcount leak in
 gfar_get_ts_info
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164694421009.25928.3425721477014489869.git-patchwork-notify@kernel.org>
Date:   Thu, 10 Mar 2022 20:30:10 +0000
References: <20220310015313.14938-1-linmq006@gmail.com>
In-Reply-To: <20220310015313.14938-1-linmq006@gmail.com>
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

On Thu, 10 Mar 2022 01:53:13 +0000 you wrote:
> The of_find_compatible_node() function returns a node pointer with
> refcount incremented, We should use of_node_put() on it when done
> Add the missing of_node_put() to release the refcount.
> 
> Fixes: 7349a74ea75c ("net: ethernet: gianfar_ethtool: get phc index through drvdata")
> Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
> Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
> 
> [...]

Here is the summary with links:
  - [net,v2] gianfar: ethtool: Fix refcount leak in gfar_get_ts_info
    https://git.kernel.org/netdev/net/c/2ac5b58e645c

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


