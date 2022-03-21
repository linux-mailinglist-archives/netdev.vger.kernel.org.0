Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE12E4E277E
	for <lists+netdev@lfdr.de>; Mon, 21 Mar 2022 14:30:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347839AbiCUNcA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Mar 2022 09:32:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244205AbiCUNb7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Mar 2022 09:31:59 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9629393FF
        for <netdev@vger.kernel.org>; Mon, 21 Mar 2022 06:30:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2262FB81630
        for <netdev@vger.kernel.org>; Mon, 21 Mar 2022 13:30:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id BBE3BC340ED;
        Mon, 21 Mar 2022 13:30:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647869413;
        bh=MNag0YML/DjE2Bj2mOWG2GmqJRMnv9fpkbaEJqtqOqo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=nfFqn0p/M8YOXu0bq1LgPw1ulJTLz4VD/oDL3aJUOMGwp9U4m7Tyuia4ppQrT+k3i
         6oA56zaUWAJoCZb5JC+/aYgYLlavsxZdyRy4NuE+Vas88ukEtlef/ztOEAQWV68bEg
         nL1tEiNbZy5b/0parELK8qMNkUFc6F56pEw3oAAaScpllu4c2Iil5tX96VhbCd4pYZ
         HhuaAVBmwmO/3jqlVkD/AYNn87HOIZH6h8ZQna8JK7Mm4W089Akjvd5uCkArg8MSIz
         vlZR/urCOscEipduy1kexOncacJ4G3141eFLexkbmf4ValLdEvPZjnRjl2Gws7XC45
         0QvClTcgleFqw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 9F950E6D44B;
        Mon, 21 Mar 2022 13:30:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2 00/10] nfp: support for NFP-3800
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164786941364.23699.4075806885785318029.git-patchwork-notify@kernel.org>
Date:   Mon, 21 Mar 2022 13:30:13 +0000
References: <20220321104209.273535-1-simon.horman@corigine.com>
In-Reply-To: <20220321104209.273535-1-simon.horman@corigine.com>
To:     Simon Horman <simon.horman@corigine.com>
Cc:     davem@davemloft.net, kuba@kernel.org, yinjun.zhang@corigine.com,
        netdev@vger.kernel.org, oss-drivers@corigine.com
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Mon, 21 Mar 2022 11:41:59 +0100 you wrote:
> Hi,
> 
> Yinjun Zhan says:
> 
> This is the second of a two part series to support the NFP-3800 device.
> 
> To utilize the new hardware features of the NFP-3800, driver adds support
> of a new data path NFDK. This series mainly does some refactor work to the
> data path related implementations. The data path specific implementations
> are now separated into nfd3 and nfdk directories respectively, and the
> common part is also moved into a new file.
> 
> [...]

Here is the summary with links:
  - [net-next,v2,01/10] nfp: calculate ring masks without conditionals
    https://git.kernel.org/netdev/net-next/c/fc9769f62e59
  - [net-next,v2,02/10] nfp: move the fast path code to separate files
    https://git.kernel.org/netdev/net-next/c/62d033309d62
  - [net-next,v2,03/10] nfp: use callbacks for slow path ring related functions
    https://git.kernel.org/netdev/net-next/c/6fd86efa630e
  - [net-next,v2,04/10] nfp: prepare for multi-part descriptors
    https://git.kernel.org/netdev/net-next/c/d6488c49c253
  - [net-next,v2,05/10] nfp: move tx_ring->qcidx into cold data
    https://git.kernel.org/netdev/net-next/c/07cd69c96bff
  - [net-next,v2,06/10] nfp: use TX ring pointer write back
    https://git.kernel.org/netdev/net-next/c/0dcf7f500b0a
  - [net-next,v2,07/10] nfp: add per-data path feature mask
    https://git.kernel.org/netdev/net-next/c/b94b6a1342cc
  - [net-next,v2,08/10] nfp: choose data path based on version
    https://git.kernel.org/netdev/net-next/c/d9e3c29918a8
  - [net-next,v2,09/10] nfp: add support for NFDK data path
    https://git.kernel.org/netdev/net-next/c/c10d12e3dce8
  - [net-next,v2,10/10] nfp: nfdk: implement xdp tx path for NFDK
    https://git.kernel.org/netdev/net-next/c/d9d950490a0a

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


