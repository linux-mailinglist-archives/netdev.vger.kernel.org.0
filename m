Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 93DB353A0D2
	for <lists+netdev@lfdr.de>; Wed,  1 Jun 2022 11:41:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349985AbiFAJkP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jun 2022 05:40:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349240AbiFAJkP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jun 2022 05:40:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2A8B4924A
        for <netdev@vger.kernel.org>; Wed,  1 Jun 2022 02:40:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 370E061543
        for <netdev@vger.kernel.org>; Wed,  1 Jun 2022 09:40:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8B373C34119;
        Wed,  1 Jun 2022 09:40:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654076412;
        bh=UE4PW23AMU0KcVHyzmNBWSTNZeSnqAKCopJ+VOR9lbA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=dvAPLWQnL9Prsl+NhZPVwNRsvIkhKxyHErpWPohaA/VFkodZ6/2BA18xwq7ntc5Fh
         5Gczq9/wAvhcnqvvNw6QN5VJqVgnxKQk/Br3jWybGck9cnJtRpZF7vhvC156BTdLCF
         ygw20X/cIOTC4iMWQmp2QHQLQbEW6GguFFSEIRhMXKTjJ25JsnFWyTyfpNyp8XIVIZ
         DJ6qd83VZwF6G6eFPLsR6Hlvoey8p0stkQNNk9LMgPxZvBGsluzV8h0e42YQlL6MQI
         3gBPzwxKupfp3N/3Ids9QiMt/DDx4UvfgLFTSD2W/et3dQw++nhCUK7bZfut55bPJZ
         EtFHGM/opVKjA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 6E9C9EAC081;
        Wed,  1 Jun 2022 09:40:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCHv2 net] bonding: guard ns_targets by CONFIG_IPV6
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165407641244.20823.11748787640846519666.git-patchwork-notify@kernel.org>
Date:   Wed, 01 Jun 2022 09:40:12 +0000
References: <20220531063727.224043-1-liuhangbin@gmail.com>
In-Reply-To: <20220531063727.224043-1-liuhangbin@gmail.com>
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     netdev@vger.kernel.org, j.vosburgh@gmail.com, vfalico@gmail.com,
        andy@greyhouse.net, davem@davemloft.net, kuba@kernel.org,
        jtoppins@redhat.com, eric.dumazet@gmail.com, pabeni@redhat.com
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
by Paolo Abeni <pabeni@redhat.com>:

On Tue, 31 May 2022 14:37:27 +0800 you wrote:
> Guard ns_targets in struct bond_params by CONFIG_IPV6, which could save
> 256 bytes if IPv6 not configed. Also add this protection for function
> bond_is_ip6_target_ok() and bond_get_targets_ip6().
> 
> Remove the IS_ENABLED() check for bond_opts[] as this will make
> BOND_OPT_NS_TARGETS uninitialized if CONFIG_IPV6 not enabled. Add
> a dummy bond_option_ns_ip6_targets_set() for this situation.
> 
> [...]

Here is the summary with links:
  - [PATCHv2,net] bonding: guard ns_targets by CONFIG_IPV6
    https://git.kernel.org/netdev/net/c/c4caa500ffeb

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


