Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66E2F6EA540
	for <lists+netdev@lfdr.de>; Fri, 21 Apr 2023 09:50:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231400AbjDUHus (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Apr 2023 03:50:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231307AbjDUHum (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Apr 2023 03:50:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0345902B
        for <netdev@vger.kernel.org>; Fri, 21 Apr 2023 00:50:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3123964E9A
        for <netdev@vger.kernel.org>; Fri, 21 Apr 2023 07:50:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 84139C4339E;
        Fri, 21 Apr 2023 07:50:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682063430;
        bh=Ghb4ujWOL+ptngeA/TuY2Pd/yHbrToTKrKLoD/hDrBU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=V6L7C6QH3j6FxdnEi8rfB0tJSVJFDUdEujC0yCCbdjb4WmwGu2XvzdkjssW7PkgGI
         GZuI6FLJLUsQ27umX7E1m0BMFf5AXZeqOtpCOiTzrD8QgsAknj3r5VqMllkoH2xfAN
         ZJeIfuMIEbhKjCAyYeEwZFI4i1kAdtH1bx1/o7xyjmvrr0oXB6wb4yXZDMsAxfqu9G
         MX4ZQ4oG5LT1RRe2anj0Y75i/37pc17rz7+yWuoZ/0p5udkd7zsT+2PLvq5BCsjWaJ
         Qi6zjEZOCdd1kqWjQCroQxJPpEZlIEVZcaO8b11CjnazV498tznb8x6OJRuJLJlhQZ
         z9oBWqhCsai7w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 660A1E501EA;
        Fri, 21 Apr 2023 07:50:30 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v7 0/5] Support MACsec VLAN
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168206343041.30967.48845527348863788.git-patchwork-notify@kernel.org>
Date:   Fri, 21 Apr 2023 07:50:30 +0000
References: <20230419142126.9788-1-ehakim@nvidia.com>
In-Reply-To: <20230419142126.9788-1-ehakim@nvidia.com>
To:     Emeel Hakim <ehakim@nvidia.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, sd@queasysnail.net, netdev@vger.kernel.org,
        leon@kernel.org
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (main)
by David S. Miller <davem@davemloft.net>:

On Wed, 19 Apr 2023 17:21:21 +0300 you wrote:
> Dear maintainers,
> 
> This patch series introduces support for hardware (HW) offload MACsec
> devices with VLAN configuration. The patches address both scenarios
> where the VLAN header is both the inner and outer header for MACsec.
> 
> The changes include:
> 
> [...]

Here is the summary with links:
  - [net-next,v7,1/5] vlan: Add MACsec offload operations for VLAN interface
    https://git.kernel.org/netdev/net-next/c/abff3e5e2935
  - [net-next,v7,2/5] net/mlx5: Enable MACsec offload feature for VLAN interface
    https://git.kernel.org/netdev/net-next/c/339ccec8d43d
  - [net-next,v7,3/5] net/mlx5: Support MACsec over VLAN
    https://git.kernel.org/netdev/net-next/c/4bba492b0427
  - [net-next,v7,4/5] net/mlx5: Consider VLAN interface in MACsec TX steering rules
    https://git.kernel.org/netdev/net-next/c/765f974c7dfd
  - [net-next,v7,5/5] macsec: Don't rely solely on the dst MAC address to identify destination MACsec device
    https://git.kernel.org/netdev/net-next/c/7661351a54ec

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


