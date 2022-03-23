Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A76484E57D6
	for <lists+netdev@lfdr.de>; Wed, 23 Mar 2022 18:50:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343805AbiCWRvu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Mar 2022 13:51:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343783AbiCWRvo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Mar 2022 13:51:44 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFFCF85671;
        Wed, 23 Mar 2022 10:50:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 928F7B81FFC;
        Wed, 23 Mar 2022 17:50:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 29768C340F5;
        Wed, 23 Mar 2022 17:50:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648057812;
        bh=rZ70td1sUS/GDoOuxgtxbnB3REa3lkh0/GuoF5TNc80=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=A8A7Rf/9WDlEbpiwDY0XgD9WpXagdbvWELls5xCw9GlhtOjaks+wbUu1rjvILhaGX
         BWReAfs4/hKOsPgAW69Z1jx8cWdjwlBGlAt7OYTdq+NYCqttMEeLeG7jLMEf6MTifn
         rv3FoXwFGuICDwujwm7lnr+lQphjAsaBnsbJ+ZhUXZaVOE6Fom41RpNYTuINtRpHRT
         Omm1PO68b5Cfm/J4cy1p8La7UlDF8c1slY3KSmFyl+0tl7/XzU4ISkh3FofS7BCyB5
         3LjtnmQAbhCanE027Uq8/5XAcaEV7Qe5kSPC1fekz9JkPrrFiCWGKFRm9EW5IcdLZW
         vs6eHqROz6bIQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 0D77BF03842;
        Wed, 23 Mar 2022 17:50:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: bridge: mst: Restrict info size queries to
 bridge ports
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164805781205.23946.3779643017453826471.git-patchwork-notify@kernel.org>
Date:   Wed, 23 Mar 2022 17:50:12 +0000
References: <20220322133001.16181-1-tobias@waldekranz.com>
In-Reply-To: <20220322133001.16181-1-tobias@waldekranz.com>
To:     Tobias Waldekranz <tobias@waldekranz.com>
Cc:     davem@davemloft.net, kuba@kernel.org, roopa@nvidia.com,
        razor@blackwall.org, pabeni@redhat.com,
        bridge@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Tue, 22 Mar 2022 14:30:01 +0100 you wrote:
> Ensure that no bridge masters are ever considered for MST info
> dumping. MST states are only supported on bridge ports, not bridge
> masters - which br_mst_info_size relies on.
> 
> Fixes: 122c29486e1f ("net: bridge: mst: Support setting and reporting MST port states")
> Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
> 
> [...]

Here is the summary with links:
  - [net-next] net: bridge: mst: Restrict info size queries to bridge ports
    https://git.kernel.org/netdev/net-next/c/a911ad18a56a

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


