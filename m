Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1101A694EEA
	for <lists+netdev@lfdr.de>; Mon, 13 Feb 2023 19:10:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231239AbjBMSKx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Feb 2023 13:10:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229700AbjBMSKv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Feb 2023 13:10:51 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69E0FBDDF
        for <netdev@vger.kernel.org>; Mon, 13 Feb 2023 10:10:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 15800CE1C59
        for <netdev@vger.kernel.org>; Mon, 13 Feb 2023 18:10:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 42102C43443;
        Mon, 13 Feb 2023 18:10:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676311817;
        bh=LfEkdYmyIbLW6hzTKAF9b3wvvlrwVzFXNQxk/NqJ24U=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=D7JLna+U7n54wpEA5VhoGo3fRWQXbwVQlOhaNmO0thmxeSX3Zohk4G1LiiODm/34W
         lMQ3Fyqd2A78/U12Km+N8f/R/t6N6ERgxKl11YahcUwcZ/dThOa2Ej642bMDvps8Pl
         dEmJJr0y+y2lN9q/+GWbMJ0H6y/k/Keaxz16fVOyZb/+x9lToSE1ZFZbVzb5XsX+kG
         gqLXHuTZH7MinujdVrQGRaNvk9Mkuotsh4sgISTPvKstwTV4YG0PaiCO2ASV3Mh54J
         i41GoL6GL1fWA7bYGfzcj8Ot+M2woqZqRAqLWndMV4fTN+AggrEGapGTneoznF2JqF
         Q5UxFmGX/j2rQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 24715E68D2E;
        Mon, 13 Feb 2023 18:10:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v3 ethtool 0/4] MAC Merge layer support
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167631181714.31041.14690393587910114839.git-patchwork-notify@kernel.org>
Date:   Mon, 13 Feb 2023 18:10:17 +0000
References: <20230210213311.218456-1-vladimir.oltean@nxp.com>
In-Reply-To: <20230210213311.218456-1-vladimir.oltean@nxp.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, mkubecek@suse.cz,
        pranavi.somisetty@amd.com, piergiorgio.beruto@gmail.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to ethtool/ethtool.git (next)
by Michal Kubecek <mkubecek@suse.cz>:

On Fri, 10 Feb 2023 23:33:07 +0200 you wrote:
> Add support for the following 2 new commands:
> 
> $ ethtool [ --include-statistics ] --show-mm <eth>
> $ ethtool --set-mm <eth> [ ... ]
> 
> as well as for:
> 
> [...]

Here is the summary with links:
  - [v3,ethtool,1/4] netlink: add support for MAC Merge layer
    https://git.kernel.org/pub/scm/network/ethtool/ethtool.git/commit/?id=877c4c587cab
  - [v3,ethtool,2/4] netlink: pass the source of statistics for pause stats
    https://git.kernel.org/pub/scm/network/ethtool/ethtool.git/commit/?id=21810d54d28b
  - [v3,ethtool,3/4] netlink: pass the source of statistics for port stats
    https://git.kernel.org/pub/scm/network/ethtool/ethtool.git/commit/?id=c4342291d8b5
  - [v3,ethtool,4/4] ethtool.8: update documentation with MAC Merge related bits
    https://git.kernel.org/pub/scm/network/ethtool/ethtool.git/commit/?id=75f446cdb77a

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


