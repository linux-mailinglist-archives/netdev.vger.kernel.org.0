Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C87A6BE4C1
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 10:02:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231876AbjCQJCu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Mar 2023 05:02:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231847AbjCQJCR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Mar 2023 05:02:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FE54E2502
        for <netdev@vger.kernel.org>; Fri, 17 Mar 2023 02:00:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B2CD1B8254B
        for <netdev@vger.kernel.org>; Fri, 17 Mar 2023 09:00:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 51EABC433A8;
        Fri, 17 Mar 2023 09:00:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679043622;
        bh=/HMkuJctVa7XmtHZRkGylKUjtwfT9LgFfgxf2tIOdS8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=sUUuW9v7v0OpEe6ud4u4u5sJ8VVn9ilIANZ9JEILMMx5QFWY+Y7PBvJKxFISjLbR3
         MnS08PECGsah/mia3MRZEpF6j4DCGNhWxusAhF+9UrE4wi9qjO5/UmNs6RDA1K6TH4
         WFpDqK+sGsel2b49x5+uFRL7jjMT8/DAe2eSaC60b6kMBpvOTewKuMFuBhT904ui9+
         CsWeVHSLqvgOkVcFzrUfDCeRSd9FNRoPmWurp27lq2cFYjPHA6pfdimJbor2MYZ9/O
         4gSlt2Zi5vU9ZTGi0zx0VJA+Dra9CcE+PppQbxV5XzyQGd2NeC4wHBP5YKT/7Zh5LR
         DPJYvxYnzZXWw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 24BCDE2A03B;
        Fri, 17 Mar 2023 09:00:22 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] netlink-specs: add partial specification for devlink
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167904362214.30854.11422213573003561692.git-patchwork-notify@kernel.org>
Date:   Fri, 17 Mar 2023 09:00:22 +0000
References: <20230316044913.528600-1-kuba@kernel.org>
In-Reply-To: <20230316044913.528600-1-kuba@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, jiri@resnulli.us
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (main)
by David S. Miller <davem@davemloft.net>:

On Wed, 15 Mar 2023 21:49:13 -0700 you wrote:
> Devlink is quite complex but put in the very basics so we can
> incrementally fill in the commands as needed.
> 
> $ ./tools/net/ynl/cli.py --spec Documentation/netlink/specs/devlink.yaml \
>     --dump get
> 
> [{'bus-name': 'netdevsim',
>   'dev-name': 'netdevsim1',
>   'dev-stats': {'reload-stats': {'reload-action-info': {'reload-action': 1,
>                                                         'reload-action-stats': {'reload-stats-entry': [{'reload-stats-limit': 0,
>                                                                                                         'reload-stats-value': 0}]}}},
>                 'remote-reload-stats': {'reload-action-info': {'reload-action': 2,
>                                                                'reload-action-stats': {'reload-stats-entry': [{'reload-stats-limit': 0,
>                                                                                                                'reload-stats-value': 0},
>                                                                                                               {'reload-stats-limit': 1,
>                                                                                                                'reload-stats-value': 0}]}}}},
>   'reload-failed': 0}]
> 
> [...]

Here is the summary with links:
  - [net-next] netlink-specs: add partial specification for devlink
    https://git.kernel.org/netdev/net-next/c/74bf6477c18b

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


