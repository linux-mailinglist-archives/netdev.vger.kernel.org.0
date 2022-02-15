Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 746464B6F30
	for <lists+netdev@lfdr.de>; Tue, 15 Feb 2022 15:46:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238785AbiBOOke (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Feb 2022 09:40:34 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:48842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238782AbiBOOk2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Feb 2022 09:40:28 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E8EA1029D8
        for <netdev@vger.kernel.org>; Tue, 15 Feb 2022 06:40:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 07AC9B81A6D
        for <netdev@vger.kernel.org>; Tue, 15 Feb 2022 14:40:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A490AC34101;
        Tue, 15 Feb 2022 14:40:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644936011;
        bh=djUWGLD9tehh0R9Cj4xhYLthMRL4aTMDdfjShSZ3VGI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=BTIOIhxDIccMgKp9F8Ry+9iyu1FKGUyCR8/pnFkOgglW1Ph79rXNfzC+A2syu9ewF
         AMBSbXlHc3NC7MAQPDxD0rCJXBxCaPklLCqzuuemNHjhn0IsqduSh306dlIWc6649K
         dnJ8MChiB9gorFpeiQWPXmVUxBF34PvjvLejKLLVJ0gOSjG1eQJE0RK3x8HwVsJQoo
         PnuZ7NHDij+T1YDuSYpBFi2BXSuMp93v7u9D26rPhoVxNn0zD4fl2ZhYsLfzYNP+Pm
         bBwUIsWK+Ogi1Fm0ciPwkSXve2jgtyUcHHu6VMksdylAC4UJMKSwyD0q40ax6P+Dsh
         YXxYiuMKo+aWQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 92332E5D07D;
        Tue, 15 Feb 2022 14:40:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: bridge: vlan: check for errors from __vlan_del
 in __vlan_flush
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164493601159.31968.14296697396749186330.git-patchwork-notify@kernel.org>
Date:   Tue, 15 Feb 2022 14:40:11 +0000
References: <20220214233646.1592855-1-vladimir.oltean@nxp.com>
In-Reply-To: <20220214233646.1592855-1-vladimir.oltean@nxp.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, roopa@nvidia.com, nikolay@nvidia.com,
        davem@davemloft.net, kuba@kernel.org
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
by David S. Miller <davem@davemloft.net>:

On Tue, 15 Feb 2022 01:36:46 +0200 you wrote:
> If the following call path returns an error from switchdev:
> 
> nbp_vlan_flush
> -> __vlan_del
>    -> __vlan_vid_del
>       -> br_switchdev_port_vlan_del
> -> __vlan_group_free
>    -> WARN_ON(!list_empty(&vg->vlan_list));
> 
> [...]

Here is the summary with links:
  - [net-next] net: bridge: vlan: check for errors from __vlan_del in __vlan_flush
    https://git.kernel.org/netdev/net-next/c/5454f5c28eca

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


