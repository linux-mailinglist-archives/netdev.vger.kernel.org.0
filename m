Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AEFB96D7238
	for <lists+netdev@lfdr.de>; Wed,  5 Apr 2023 04:00:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236228AbjDECAZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Apr 2023 22:00:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236362AbjDECAV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Apr 2023 22:00:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8607A3C02
        for <netdev@vger.kernel.org>; Tue,  4 Apr 2023 19:00:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 12A4163AD9
        for <netdev@vger.kernel.org>; Wed,  5 Apr 2023 02:00:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 4F959C4339E;
        Wed,  5 Apr 2023 02:00:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680660019;
        bh=mmkPPtsj974uQQ9taIj8B47UCaBZMzGny/c/cSKo2x8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=mcS/lNKOcgX1lQiTckvXwHK9FRCUl/2aNtZWGbeIv4mtKzk7cOiaCuelJGX6E1h6o
         9Ex9gGnjGmvCnNUTZ69ZVWkD6DfnhgGhedMFpSR95cLLB8Pj975U7Jnj6yokFgFFzH
         Byg+wcP6Dk8wvNFQecBhu8N0nnuaBklG5BahJJXGQQLUKzjkQ9VMPILcpg3yOml1pK
         RhOSiWGe9ANKhUcOkmGtr+73AnTPQ0vdPyoM4GKI3KpPNNDLioFRf56S40ISHygGpb
         JtFfvhnoY9BmOGioOPhQ8oAbPS4ILo14MPhrAWtHeZ0POOzmp5GvDGQlTrnQW5RiwG
         jJxoaS62Nj4Jw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 28E9DE524E6;
        Wed,  5 Apr 2023 02:00:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v2] ethtool: reset #lanes when lanes is omitted
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168066001915.10193.5368413023772146892.git-patchwork-notify@kernel.org>
Date:   Wed, 05 Apr 2023 02:00:19 +0000
References: <ac238d6b-8726-8156-3810-6471291dbc7f@nvidia.com>
In-Reply-To: <ac238d6b-8726-8156-3810-6471291dbc7f@nvidia.com>
To:     Andy Roulin <aroulin@nvidia.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        jiri@nvidia.com, andrew@lunn.ch, f.fainelli@gmail.com,
        mkubecek@suse.cz, mlxsw@nvidia.com, idosch@nvidia.com,
        danieller@nvidia.com
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Mon, 3 Apr 2023 14:20:53 -0700 you wrote:
> If the number of lanes was forced and then subsequently the user
> omits this parameter, the ksettings->lanes is reset. The driver
> should then reset the number of lanes to the device's default
> for the specified speed.
> 
> However, although the ksettings->lanes is set to 0, the mod variable
> is not set to true to indicate the driver and userspace should be
> notified of the changes.
> 
> [...]

Here is the summary with links:
  - [net,v2] ethtool: reset #lanes when lanes is omitted
    https://git.kernel.org/netdev/net/c/e847c7675e19

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


