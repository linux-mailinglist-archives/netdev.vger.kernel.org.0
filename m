Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8446A4CB71C
	for <lists+netdev@lfdr.de>; Thu,  3 Mar 2022 07:40:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229785AbiCCGk7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Mar 2022 01:40:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229671AbiCCGk6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Mar 2022 01:40:58 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C6CC169203
        for <netdev@vger.kernel.org>; Wed,  2 Mar 2022 22:40:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 46710B82401
        for <netdev@vger.kernel.org>; Thu,  3 Mar 2022 06:40:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E1E79C340F2;
        Thu,  3 Mar 2022 06:40:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646289610;
        bh=o+AcRm/Apntu418v52Zmewh0uD93Hbsh3Z8u4I5hvyA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=CQ6CYPMU1ex8W5bV3EvDsj5XY7NkjlYAWs3oFpSOPsV4sPTKYgYc4CSTmLS/foeST
         ztP3z8A6lKUWRzKe3gwn0KFZ4K3LmTcLhpVAAwnhnSKySWCT15ntAB+UGzyGD0TYC0
         4tx2zo7ySxXSbNC/dRnDVYbnSfkfQwgLswJDbIAx4mCFNJLcKvjRFMgsZWj2J+C2kH
         YlN06Hipve5QeuYocpRuSw+aKUsWd27wEYjXjocy+7JK3VJz/ub5mOUWwIfg1mvYyG
         YNwH7PywigU/Er8pUo9Y+3X6X5Arvz8KEMOXpE8278j61Klk93mCBPdda5+9ygCOoo
         3fPs/nJN/2+YQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id C5E3FE7BB08;
        Thu,  3 Mar 2022 06:40:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2] flow_offload: improve extack msg for user when
 adding invalid filter
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164628961080.13615.5498398460194161358.git-patchwork-notify@kernel.org>
Date:   Thu, 03 Mar 2022 06:40:10 +0000
References: <1646191769-17761-1-git-send-email-baowen.zheng@corigine.com>
In-Reply-To: <1646191769-17761-1-git-send-email-baowen.zheng@corigine.com>
To:     Baowen Zheng <baowen.zheng@corigine.com>
Cc:     davem@davemloft.net, kuba@kernel.org, xiyou.wangcong@gmail.com,
        jhs@mojatatu.com, netdev@vger.kernel.org, oss-drivers@corigine.com,
        simon.horman@corigine.com, roid@nvidia.com
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Wed,  2 Mar 2022 11:29:29 +0800 you wrote:
> Add extack message to return exact message to user when adding invalid
> filter with conflict flags for TC action.
> 
> In previous implement we just return EINVAL which is confusing for user.
> 
> Signed-off-by: Baowen Zheng <baowen.zheng@corigine.com>
> Reviewed-by: Roi Dayan <roid@nvidia.com>
> 
> [...]

Here is the summary with links:
  - [net-next,v2] flow_offload: improve extack msg for user when adding invalid filter
    https://git.kernel.org/netdev/net-next/c/d922a99b96d0

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


