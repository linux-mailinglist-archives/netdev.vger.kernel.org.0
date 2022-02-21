Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A22A54BE3BB
	for <lists+netdev@lfdr.de>; Mon, 21 Feb 2022 18:57:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233081AbiBUMV3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Feb 2022 07:21:29 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:58564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358145AbiBUMVS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Feb 2022 07:21:18 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A1361EAE1
        for <netdev@vger.kernel.org>; Mon, 21 Feb 2022 04:20:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CD8FEB8110C
        for <netdev@vger.kernel.org>; Mon, 21 Feb 2022 12:20:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 6B00AC340EB;
        Mon, 21 Feb 2022 12:20:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645446011;
        bh=t8x3rRNHUUubKhYOZDVR8azMJIks2W5chi7V4kB5Qws=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=X/iNzQ2rlmNmogyYen33zIZ6R37iYpvK2aZDqZIqGhLMW98znZpxhRD3bfPm08WoU
         B+PpOUCGjad9Z3ce4W2UJJxk3FwsNg39SC5EUPO7VIWecLZlpOkkHnzGX/Jj0qSgr5
         JMwRM9co/vIPvSz9IFkclUffgou5A5I1Yodz1Cem2VB80ZWLmUlQsJtaSoOlKyx9M2
         w9rPfFKohRMiWWEB+7hNo9LVJLmA8YOpMG27Rk3pxoiv5qSF8u2rgjOHYDgd1OzJwb
         6shmbuY/VcanSNlV0JzOtf1lIhdCcgavYSW9Ua0GyzCa3txLd0xrdUPhIGc3cxABcQ
         tZ8n0MDu6ohKg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 53478E6D452;
        Mon, 21 Feb 2022 12:20:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCHv2 net-next 0/5] bonding: add IPv6 NS/NA monitor support
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164544601133.1164.18299386133202132825.git-patchwork-notify@kernel.org>
Date:   Mon, 21 Feb 2022 12:20:11 +0000
References: <20220221055458.18790-1-liuhangbin@gmail.com>
In-Reply-To: <20220221055458.18790-1-liuhangbin@gmail.com>
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     netdev@vger.kernel.org, j.vosburgh@gmail.com, vfalico@gmail.com,
        andy@greyhouse.net, davem@davemloft.net, kuba@kernel.org,
        dsahern@gmail.com, nikolay@nvidia.com, jtoppins@redhat.com,
        eric.dumazet@gmail.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Mon, 21 Feb 2022 13:54:52 +0800 you wrote:
> This patch add bond IPv6 NS/NA monitor support. A new option
> ns_ip6_target is added, which is similar with arp_ip_target.
> The IPv6 NS/NA monitor will take effect when there is a valid IPv6
> address. Both ARP monitor and NS monitor will working at the same time.
> 
> A new extra storage field is added to struct bond_opt_value for IPv6 support.
> 
> [...]

Here is the summary with links:
  - [PATCHv2,net-next,1/5] ipv6: separate ndisc_ns_create() from ndisc_send_ns()
    https://git.kernel.org/netdev/net-next/c/696c65444120
  - [PATCHv2,net-next,2/5] Bonding: split bond_handle_vlan from bond_arp_send
    https://git.kernel.org/netdev/net-next/c/1fcd5d448c59
  - [PATCHv2,net-next,3/5] bonding: add extra field for bond_opt_value
    https://git.kernel.org/netdev/net-next/c/841e95641e4c
  - [PATCHv2,net-next,4/5] bonding: add new parameter ns_targets
    https://git.kernel.org/netdev/net-next/c/4e24be018eb9
  - [PATCHv2,net-next,5/5] bonding: add new option ns_ip6_target
    https://git.kernel.org/netdev/net-next/c/129e3c1bab24

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


