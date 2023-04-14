Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2959E6E1BC1
	for <lists+netdev@lfdr.de>; Fri, 14 Apr 2023 07:30:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229954AbjDNFap (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Apr 2023 01:30:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229878AbjDNFaj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Apr 2023 01:30:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF83659C3
        for <netdev@vger.kernel.org>; Thu, 13 Apr 2023 22:30:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4682064423
        for <netdev@vger.kernel.org>; Fri, 14 Apr 2023 05:30:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 7C147C433D2;
        Fri, 14 Apr 2023 05:30:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681450222;
        bh=kHcU5I7TaNF4Gldl9nmeiFutAGzWM0Jq0tF3PF7lE/w=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=iD9lWmSlUXu6t4O7pqWfqxaxLMJGSd6FS4weIEx0EwGb1bi6Hp8oRfgvIY/7sBLCO
         Sd5QjDq4OBGCEg/p2b+4GahnJOZmkI7j8xbnPowqWRtVsLNXtrfbEQQFQ2N3P6aHU+
         JwPPWyN0MUSw0MG7V5SHc7Yv+hUwQRfIkYinSIGku2YztZW9jN6dOKU35BxBnm3CL1
         OB7xD+jfZfcPyJHNenBiMtRqN5fqfCzWTL6YYGm1AaodhJY3Uvavx6LbEkgGKcK9uj
         XxYIcMHPv7HwFbLxSaW0duKQeBjHOFap/WNZ/qXNOcT4fkOxYnqHGYkjj7MwC0Y5k6
         Ne7F3hJC9tEOA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 5E4E3E29F41;
        Fri, 14 Apr 2023 05:30:22 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net-next 01/15] net/mlx5: Add mlx5_ifc definitions for bridge
 multicast support
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168145022238.29714.3408827760407301679.git-patchwork-notify@kernel.org>
Date:   Fri, 14 Apr 2023 05:30:22 +0000
References: <20230412040752.14220-2-saeed@kernel.org>
In-Reply-To: <20230412040752.14220-2-saeed@kernel.org>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, saeedm@nvidia.com, netdev@vger.kernel.org,
        tariqt@nvidia.com, vladbu@nvidia.com, maord@nvidia.com,
        roid@nvidia.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (main)
by Saeed Mahameed <saeedm@nvidia.com>:

On Tue, 11 Apr 2023 21:07:38 -0700 you wrote:
> From: Vlad Buslov <vladbu@nvidia.com>
> 
> Add the required hardware definitions to mlx5_ifc: fdb_uplink_hairpin,
> fdb_multi_path_any_table_limit_regc, fdb_multi_path_any_table.
> 
> Signed-off-by: Vlad Buslov <vladbu@nvidia.com>
> Reviewed-by: Maor Dickman <maord@nvidia.com>
> Reviewed-by: Roi Dayan <roid@nvidia.com>
> Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
> 
> [...]

Here is the summary with links:
  - [net-next,01/15] net/mlx5: Add mlx5_ifc definitions for bridge multicast support
    https://git.kernel.org/netdev/net-next/c/e5688f6fb9e3
  - [net-next,02/15] net/mlx5: Bridge, increase bridge tables sizes
    https://git.kernel.org/netdev/net-next/c/9071b423c302
  - [net-next,03/15] net/mlx5: Bridge, move additional data structures to priv header
    https://git.kernel.org/netdev/net-next/c/6767c97d7adc
  - [net-next,04/15] net/mlx5: Bridge, extract code to lookup parent bridge of port
    https://git.kernel.org/netdev/net-next/c/b99c4ef29e27
  - [net-next,05/15] net/mlx5: Bridge, snoop igmp/mld packets
    https://git.kernel.org/netdev/net-next/c/18c2916cee12
  - [net-next,06/15] net/mlx5: Bridge, add per-port multicast replication tables
    https://git.kernel.org/netdev/net-next/c/272ecfc92f6f
  - [net-next,07/15] net/mlx5: Bridge, support multicast VLAN pop
    https://git.kernel.org/netdev/net-next/c/b5e80625d168
  - [net-next,08/15] net/mlx5: Bridge, implement mdb offload
    https://git.kernel.org/netdev/net-next/c/70f0302b3f20
  - [net-next,09/15] net/mlx5: Bridge, add tracepoints for multicast
    https://git.kernel.org/netdev/net-next/c/55f3e740f7f6
  - [net-next,10/15] net/mlx5: Create a new profile for SFs
    https://git.kernel.org/netdev/net-next/c/9df839a711ae
  - [net-next,11/15] net/mlx5: DR, Set counter ID on the last STE for STEv1 TX
    https://git.kernel.org/netdev/net-next/c/cee6484eddc1
  - [net-next,12/15] net/mlx5: Add mlx5_ifc bits for modify header argument
    https://git.kernel.org/netdev/net-next/c/9fa7f1de3dda
  - [net-next,13/15] net/mlx5: Add new WQE for updating flow table
    https://git.kernel.org/netdev/net-next/c/977c4a3e7c89
  - [net-next,14/15] net/mlx5: DR, Prepare sending new WQE type
    https://git.kernel.org/netdev/net-next/c/1e5cc7369bb0
  - [net-next,15/15] net/mlx5: DR, Add modify-header-pattern ICM pool
    https://git.kernel.org/netdev/net-next/c/108ff8215b55

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


