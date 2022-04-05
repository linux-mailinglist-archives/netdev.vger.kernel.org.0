Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5FA8F4F4581
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 00:48:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1384333AbiDEUFJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Apr 2022 16:05:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354847AbiDEOmO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Apr 2022 10:42:14 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA45BBCB6;
        Tue,  5 Apr 2022 06:20:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 834B9B81D6E;
        Tue,  5 Apr 2022 13:20:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id EDE92C385A4;
        Tue,  5 Apr 2022 13:20:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649164813;
        bh=I8dT2IWhn+QbeKF4pyUax35o8zj+GGN10pixx8XNIpE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=WMorRMoLslnyQPaE76TYhG9VLwiXn59mhLVUkA1i+nsrifSRYZeKN/kolHa/Z/DY8
         UyoKNM8StosuqY63zt8moZKsmqnzPG4SoJgssDT1AK3SHOwyINNV1mG2VLpwpwamIt
         gZtH2jec7Y3S+TodQRlXR2QedhJY3bWlBvy7Jm6yvUdY//g9id+9sEIWF/tQMtCQ4Q
         oxsp6h+aNyP0HZzal0DRr9sJvQIYDPktzCcQwIRW9Ir/FYPxYmgpkU4T/ULKyNOLIA
         eCC+LVkpo2ywn64EZ6DsLRdjjtYno7y1W6U6BdlRAr54BRkG6Sn3bsLXe7XapzGcHV
         5bV5uk1OkH+KQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id D0803E85D5D;
        Tue,  5 Apr 2022 13:20:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] ipv6: Fix stats accounting in ip6_pkt_drop
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164916481285.26533.3829481260242504695.git-patchwork-notify@kernel.org>
Date:   Tue, 05 Apr 2022 13:20:12 +0000
References: <20220404150908.2937-1-dsahern@kernel.org>
In-Reply-To: <20220404150908.2937-1-dsahern@kernel.org>
To:     David Ahern <dsahern@kernel.org>
Cc:     netdev@vger.kernel.org, kuba@kernel.org, davem@davemloft.net,
        pabeni@redhat.com, Filip.Pudak@windriver.com,
        Jiguang.Xiao@windriver.com, ssuryaextr@gmail.com,
        Pudak@vger.kernel.org, Xiao@vger.kernel.org
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

This patch was applied to netdev/net.git (master)
by Paolo Abeni <pabeni@redhat.com>:

On Mon,  4 Apr 2022 09:09:08 -0600 you wrote:
> VRF devices are the loopbacks for VRFs, and a loopback can not be
> assigned to a VRF. Accordingly, the condition in ip6_pkt_drop should
> be '||' not '&&'.
> 
> Fixes: 1d3fd8a10bed ("vrf: Use orig netdev to count Ip6InNoRoutes and a fresh route lookup when sending dest unreach")
> Reported-by: Pudak, Filip <Filip.Pudak@windriver.com>
> Reported-by: Xiao, Jiguang <Jiguang.Xiao@windriver.com>
> Signed-off-by: David Ahern <dsahern@kernel.org>
> 
> [...]

Here is the summary with links:
  - [net] ipv6: Fix stats accounting in ip6_pkt_drop
    https://git.kernel.org/netdev/net/c/1158f79f82d4

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


