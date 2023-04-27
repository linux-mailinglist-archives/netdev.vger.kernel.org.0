Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D7BC6F08ED
	for <lists+netdev@lfdr.de>; Thu, 27 Apr 2023 18:00:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244250AbjD0QAZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Apr 2023 12:00:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244283AbjD0QAX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Apr 2023 12:00:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AF41E48
        for <netdev@vger.kernel.org>; Thu, 27 Apr 2023 09:00:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DE2C863E1E
        for <netdev@vger.kernel.org>; Thu, 27 Apr 2023 16:00:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 44819C433EF;
        Thu, 27 Apr 2023 16:00:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682611221;
        bh=08/U0uF41kdZKo6NMMgBv9Bw9xgIpiUkLhiMAYb7/wI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=h2e2P6DjWPJ2hVEe7bMGGTxzlp8AANQUkfxpA2ZLzlcKYRV47pOmsLNKKmkl69jg8
         0Q4szvD2QC6kfiJllwp4qAUNbPPSw9/3Z4DDrl4dSmt5IziLt1hAwUDpJEJXgs0nKi
         a3WDd6SQ/8uhCt3UAscJ6Unks/sKEELO426KTnh12qAelFZip0UqcQ6Rloszjj+t3n
         rlLkOs7YhAll2SD05UkCayKzeiUzn+wPhfrTO2BwswxWSkxYvBqDxzWi+dVsW2IzDB
         5YbyMnSp402RaK+5by9boaEAbzs9qtg3g++sUTx6ZPKXHxGRLfbwU8Jwm9bH05qvbW
         zDjNxsgAMptnA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 1EBC5C39562;
        Thu, 27 Apr 2023 16:00:21 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH iproute2] devlink: Fix dumps where interface map is used
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168261122112.5400.4914631906398852585.git-patchwork-notify@kernel.org>
Date:   Thu, 27 Apr 2023 16:00:21 +0000
References: <20230427052521.464295-1-idosch@nvidia.com>
In-Reply-To: <20230427052521.464295-1-idosch@nvidia.com>
To:     Ido Schimmel <idosch@nvidia.com>
Cc:     netdev@vger.kernel.org, stephen@networkplumber.org,
        dsahern@gmail.com, jiri@nvidia.com
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to iproute2/iproute2.git (main)
by Stephen Hemminger <stephen@networkplumber.org>:

On Thu, 27 Apr 2023 08:25:21 +0300 you wrote:
> The devlink utility stores an interface map that can be used to map an
> interface name to a devlink port and vice versa. The map is populated by
> issuing a devlink port dump via 'DEVLINK_CMD_PORT_GET' command.
> 
> Cited commits started to populate the map only when it is actually
> needed. One such case is when a dump (e.g., shared buffer dump) only
> returns devlink port handles. When pretty printing is required, the
> utility will consult the map to translate the devlink port handles to
> the corresponding interface names.
> 
> [...]

Here is the summary with links:
  - [iproute2] devlink: Fix dumps where interface map is used
    https://git.kernel.org/pub/scm/network/iproute2/iproute2.git/commit/?id=b6f4a62ba7a0

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


