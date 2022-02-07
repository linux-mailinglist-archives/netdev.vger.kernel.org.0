Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A5834ABF60
	for <lists+netdev@lfdr.de>; Mon,  7 Feb 2022 14:24:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1447810AbiBGNBw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Feb 2022 08:01:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1442601AbiBGMVU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Feb 2022 07:21:20 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9020AC1DC406
        for <netdev@vger.kernel.org>; Mon,  7 Feb 2022 04:10:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3F031B81210
        for <netdev@vger.kernel.org>; Mon,  7 Feb 2022 12:10:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id F0979C340F6;
        Mon,  7 Feb 2022 12:10:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644235810;
        bh=a4tAQivLLDnC6Olhz+v5YQOfbxVkviL3evnAaBE+GBQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Ffmf51AKhKR1Ww46r3UJQadm4gnA1fJBCxMaCH/NiG/wRyR6B0qjKh8p9NTwV6q46
         LqC6lVPAQNsbUpSjFINBddeS9MPWnOk/bi6D6Q1e7KVKkpOfuiBSro0JBDkbAtSCRI
         BXjyjz9xGSCr4RfgjSF3hV0jrrLHdpCNlXKTkLpzqqgI3ZyVW9eGQme5uBPqRpHC76
         rLEEOf8eNNWk3uViGa/sQAGT2A01RJvU4oFEbtdWwGG8bxmp4uS3mesvC0XI6c7C8l
         W9jrKOtaadloXWMjbm+HghOx6oEoKanhf4p9kY+lZcT32ifT7+iyzwGJjJxLTDZi8f
         AwFz/n1FJAcmA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id D9647E5D09D;
        Mon,  7 Feb 2022 12:10:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/4] mlxsw: Add SIP and DIP mangling support
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164423580988.24406.14518725132699250939.git-patchwork-notify@kernel.org>
Date:   Mon, 07 Feb 2022 12:10:09 +0000
References: <20220206153613.763944-1-idosch@nvidia.com>
In-Reply-To: <20220206153613.763944-1-idosch@nvidia.com>
To:     Ido Schimmel <idosch@nvidia.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        petrm@nvidia.com, danieller@nvidia.com, mlxsw@nvidia.com
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

On Sun,  6 Feb 2022 17:36:09 +0200 you wrote:
> Danielle says:
> 
> On Spectrum-2 onwards, it is possible to overwrite SIP and DIP address
> of an IPv4 or IPv6 packet in the ACL engine. That corresponds to pedit
> munges of, respectively, ip src and ip dst fields, and likewise for ip6.
> Offload these munges on the systems where they are supported.
> 
> [...]

Here is the summary with links:
  - [net-next,1/4] mlxsw: core_acl_flex_actions: Add SIP_DIP_ACTION
    https://git.kernel.org/netdev/net-next/c/e3541022e48b
  - [net-next,2/4] mlxsw: Support FLOW_ACTION_MANGLE for SIP and DIP IPv4 addresses
    https://git.kernel.org/netdev/net-next/c/d7809b620ff3
  - [net-next,3/4] mlxsw: Support FLOW_ACTION_MANGLE for SIP and DIP IPv6 addresses
    https://git.kernel.org/netdev/net-next/c/463e1ab82a41
  - [net-next,4/4] selftests: forwarding: Add a test for pedit munge SIP and DIP
    https://git.kernel.org/netdev/net-next/c/92ad3828944e

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


