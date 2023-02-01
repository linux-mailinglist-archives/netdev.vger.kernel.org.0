Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 109E1685ED5
	for <lists+netdev@lfdr.de>; Wed,  1 Feb 2023 06:20:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231185AbjBAFUY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Feb 2023 00:20:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230523AbjBAFUW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Feb 2023 00:20:22 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6FDF166D8
        for <netdev@vger.kernel.org>; Tue, 31 Jan 2023 21:20:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7593CB82082
        for <netdev@vger.kernel.org>; Wed,  1 Feb 2023 05:20:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 1D272C433D2;
        Wed,  1 Feb 2023 05:20:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675228818;
        bh=enq8doSUIilqZevGkesIn5B1ZP/kkR3PgtmG4ZernPA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=YbE/AKoVcy4b4KrHxMM4Dmu0VKSgMARaNJnnwXiEnojoCwosCVfffs0M7ClNnbS+u
         CmsvS8bn7PKK7rFsqPks9F6toXrMa2g8N5tgAs1ADEXO0Y6fYVJwl9BmqmPNR2Ug4v
         bMNHIJHLfgaSkwxOdJUDHi6efVoCgbilmS9idVbaErwprBnRm4z1/5zbvDykrpqEeB
         5sRprwLeEijN6GJOSaT9VYkh+5pXRh48hykACGaL7LZ+hsUHoNKM2lk7APwRugbyZW
         VjbEvcsMuJ1JWx47D5nVOZES+u/cxs6smH7iCxkSEXhy7eVgen+nUnxgyp8sC51SJ5
         Fu6EsMMD1l3Rw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 013FDE21ED4;
        Wed,  1 Feb 2023 05:20:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: fman: memac: free mdio device if lynx_pcs_create()
 fails
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167522881799.32169.4823968183270694137.git-patchwork-notify@kernel.org>
Date:   Wed, 01 Feb 2023 05:20:17 +0000
References: <20230130193051.563315-1-vladimir.oltean@nxp.com>
In-Reply-To: <20230130193051.563315-1-vladimir.oltean@nxp.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, madalin.bucur@nxp.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        sean.anderson@seco.com, camelia.groza@nxp.com,
        maxime.chevallier@bootlin.com
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
by Jakub Kicinski <kuba@kernel.org>:

On Mon, 30 Jan 2023 21:30:51 +0200 you wrote:
> When memory allocation fails in lynx_pcs_create() and it returns NULL,
> there remains a dangling reference to the mdiodev returned by
> of_mdio_find_device() which is leaked as soon as memac_pcs_create()
> returns empty-handed.
> 
> Fixes: a7c2a32e7f22 ("net: fman: memac: Use lynx pcs driver")
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> [...]

Here is the summary with links:
  - [net] net: fman: memac: free mdio device if lynx_pcs_create() fails
    https://git.kernel.org/netdev/net/c/efec2e2a722e

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


