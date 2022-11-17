Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E4E4562CF42
	for <lists+netdev@lfdr.de>; Thu, 17 Nov 2022 01:00:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233056AbiKQAAU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Nov 2022 19:00:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231300AbiKQAAT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Nov 2022 19:00:19 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 516BE13CEA
        for <netdev@vger.kernel.org>; Wed, 16 Nov 2022 16:00:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 084CFB81F5E
        for <netdev@vger.kernel.org>; Thu, 17 Nov 2022 00:00:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B1082C433B5;
        Thu, 17 Nov 2022 00:00:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668643216;
        bh=9JdBCzy6RPKlyYxiJ93Lggj6quwM4V5Q+/aCs7YC3CU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Ju3pbt1fSQe1NhukUNwwqN1ihzZ2TLTJ/cc5fEkyHqPLCTuIkgeQVG3Fy3DKu13cs
         o+W/FruRGg6aDLvMyYF7NVy4ThgMHu7kTNPRzQ+zRWC45oiImCikmplzU/vCInWUBe
         ukAjpETjMwYK+wpYsXgukGDNIELto65XaK7ybLHOql+E5GQOd7H0M7LV+P0Qt/EGYz
         WaMp2PH/Ov7/gQlWNTirAX26I1YVkyT/xMXIy0ACv/YpV5aYttN/Unac2YB43Ejocp
         ZTYL/6QCkHZa+DoCMiwxJgU/vL7F1hRSUILKz9FboyUabJGQedPWhP6WGiNF7uSwH1
         kdl8MXcmuiKYQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 91C4BE21EFD;
        Thu, 17 Nov 2022 00:00:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH iproute2-next] bridge: Remove unused function argument
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166864321659.22686.17754906344869671034.git-patchwork-notify@kernel.org>
Date:   Thu, 17 Nov 2022 00:00:16 +0000
References: <20221115210715.172728-1-bpoirier@nvidia.com>
In-Reply-To: <20221115210715.172728-1-bpoirier@nvidia.com>
To:     Benjamin Poirier <bpoirier@nvidia.com>
Cc:     dsahern@kernel.org, stephen@networkplumber.org,
        netdev@vger.kernel.org, idosch@nvidia.com, roopa@nvidia.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to iproute2/iproute2-next.git (main)
by David Ahern <dsahern@kernel.org>:

On Tue, 15 Nov 2022 16:07:15 -0500 you wrote:
> print_vnifilter_rtm() was probably modeled on print_vlan_rtm() but the
> 'monitor' argument is unused in the vnifilter case.
> 
> Signed-off-by: Benjamin Poirier <bpoirier@nvidia.com>
> Reviewed-by: Ido Schimmel <idosch@nvidia.com>
> ---
>  bridge/br_common.h | 2 +-
>  bridge/monitor.c   | 2 +-
>  bridge/vni.c       | 4 ++--
>  3 files changed, 4 insertions(+), 4 deletions(-)

Here is the summary with links:
  - [iproute2-next] bridge: Remove unused function argument
    https://git.kernel.org/pub/scm/network/iproute2/iproute2-next.git/commit/?id=2ed09c3bf8ac

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


