Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0FFAD691884
	for <lists+netdev@lfdr.de>; Fri, 10 Feb 2023 07:30:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231342AbjBJGaU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Feb 2023 01:30:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231278AbjBJGaT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Feb 2023 01:30:19 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 281932ED6D
        for <netdev@vger.kernel.org>; Thu,  9 Feb 2023 22:30:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B4BA861CC4
        for <netdev@vger.kernel.org>; Fri, 10 Feb 2023 06:30:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 11B76C433EF;
        Fri, 10 Feb 2023 06:30:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676010618;
        bh=RExqV2OK+2un0rNVJEM3ODlmmlvghndG2kbseoFUnqc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=GbVpHOMUGOxgIy21sG0lMjFaeuGXfDddURSYWVWt7KJSQhrhjIcAdZghRDR0DItM8
         GB64sGnzDIR0buIAdZYHwFr4kepIenDh6xIxqtHw94Sw2uxPLNLDrxrAOl1X3rcNG5
         +IZ0ANj7H5l5lcJybc6ORqIP3t1wN+YTZUlrKCHhMAPWIFkq77N2rsYj1DzlGlIiCF
         E2JCMZbCYs/hwb7IVYyWSI0hoGR89yMp14xqnUexkyYlnJTi2IXIh/wQlHxxd21x95
         pop/qg4fyRZMAjuFANy8t+BoxvAEBGh394/kDWuFE+GM3GBNgrSg0A1+P564aJTzow
         aWKMd/jbA8ZEA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id E872EE55EFD;
        Fri, 10 Feb 2023 06:30:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 net-next v2] nfp: support IPsec offloading for NFP3800
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167601061794.30320.10583988830365801120.git-patchwork-notify@kernel.org>
Date:   Fri, 10 Feb 2023 06:30:17 +0000
References: <20230208091000.4139974-1-simon.horman@corigine.com>
In-Reply-To: <20230208091000.4139974-1-simon.horman@corigine.com>
To:     Simon Horman <simon.horman@corigine.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        steffen.klassert@secunet.com, herbert@gondor.apana.org.au,
        leon@kernel.org, chengtian.liu@corigine.com,
        huanhuan.wang@corigine.com, niklas.soderlund@corigine.com,
        netdev@vger.kernel.org, oss-drivers@corigine.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Wed,  8 Feb 2023 10:10:00 +0100 you wrote:
> From: Huanhuan Wang <huanhuan.wang@corigine.com>
> 
> Add IPsec offloading support for NFP3800. Include data
> plane and control plane.
> 
> Data plane: add IPsec packet process flow in NFP3800
> datapath (NFDk).
> 
> [...]

Here is the summary with links:
  - [v2,net-next,v2] nfp: support IPsec offloading for NFP3800
    https://git.kernel.org/netdev/net-next/c/436396f26d50

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


