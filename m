Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 622F66B58C2
	for <lists+netdev@lfdr.de>; Sat, 11 Mar 2023 06:50:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229735AbjCKFuZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Mar 2023 00:50:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229636AbjCKFuY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Mar 2023 00:50:24 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E44E1ABC9;
        Fri, 10 Mar 2023 21:50:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 20CEB601D6;
        Sat, 11 Mar 2023 05:50:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 67AD5C4339E;
        Sat, 11 Mar 2023 05:50:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678513822;
        bh=Rn8pMZ0BHfATsUxMa6IeYyL9VUbUN5i12ur6bJi0RPI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=rlzIVmn6ZFw5PisdBtcIsv02Wf/yQaJ3r6y4QPVgreEbpakhrYM0B/el9c6uVExOE
         dlG3R3zPFsX+6SipjNkTC0BJsVdy6UicIwbOfXAKUEduzkaCQzts3q72Bws7/meTqm
         GHOSuWC7KzCN95mO5m8OwLDPrMKrX7SUxyFugoEqH5MRwylvuqK3jxdjWF63aOWI7u
         ceJmoA67a5B9J0NUR9WhokL91Y8PYnVKgxWVySU5vBJjfEmINynhzJ2QSY+i6ulcfd
         Yd4g5ook9r+q0RMlVXN+MG68yHJFQBDDTJrIDZ5s9WX05viZ2L6JaUkHLxUyFXifWB
         VIFndYRcvq58g==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 4FB90E21EEE;
        Sat, 11 Mar 2023 05:50:22 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v2 0/8] update xdp_features flag according to NIC
 re-configuration
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167851382232.22535.4113022029818108082.git-patchwork-notify@kernel.org>
Date:   Sat, 11 Mar 2023 05:50:22 +0000
References: <cover.1678364612.git.lorenzo@kernel.org>
In-Reply-To: <cover.1678364612.git.lorenzo@kernel.org>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        ast@kernel.org, daniel@iogearbox.net, hawk@kernel.org,
        john.fastabend@gmail.com, saeedm@nvidia.com, leon@kernel.org,
        shayagr@amazon.com, akiyano@amazon.com, darinzon@amazon.com,
        sgoutham@marvell.com, lorenzo.bianconi@redhat.com, toke@redhat.com,
        teknoraver@meta.com, ttoukan.linux@gmail.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Thu,  9 Mar 2023 13:25:24 +0100 you wrote:
> Changes since v1:
> - rebase on top of net tree
> - remove NETDEV_XDP_ACT_NDO_XMIT_SG support in mlx5e driver
> - always enable NETDEV_XDP_ACT_NDO_XMIT support in mlx5e driver
> 
> Lorenzo Bianconi (7):
>   tools: ynl: fix render-max for flags definition
>   tools: ynl: fix get_mask utility routine
>   xdp: add xdp_set_features_flag utility routine
>   net: thunderx: take into account xdp_features setting tx/rx queues
>   net: ena: take into account xdp_features setting tx/rx queues
>   veth: take into account device reconfiguration for xdp_features flag
>   net/mlx5e: take into account device reconfiguration for xdp_features
>     flag
> 
> [...]

Here is the summary with links:
  - [net,v2,1/8] tools: ynl: fix render-max for flags definition
    https://git.kernel.org/netdev/net/c/8f76a4f80fba
  - [net,v2,2/8] tools: ynl: fix get_mask utility routine
    https://git.kernel.org/netdev/net/c/bf51d27704c9
  - [net,v2,3/8] xdp: add xdp_set_features_flag utility routine
    https://git.kernel.org/netdev/net/c/f85949f98206
  - [net,v2,4/8] net: thunderx: take into account xdp_features setting tx/rx queues
    https://git.kernel.org/netdev/net/c/3c249fe4de16
  - [net,v2,5/8] net: ena: take into account xdp_features setting tx/rx queues
    https://git.kernel.org/netdev/net/c/7aa6dc351b92
  - [net,v2,6/8] veth: take into account device reconfiguration for xdp_features flag
    https://git.kernel.org/netdev/net/c/fccca038f300
  - [net,v2,7/8] net/mlx5e: take into account device reconfiguration for xdp_features flag
    https://git.kernel.org/netdev/net/c/4d5ab0ad964d
  - [net,v2,8/8] mvpp2: take care of xdp_features when reconfiguring queues
    https://git.kernel.org/netdev/net/c/481e96fc1307

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


