Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7DFEB516E96
	for <lists+netdev@lfdr.de>; Mon,  2 May 2022 13:10:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231339AbiEBLNm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 May 2022 07:13:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231609AbiEBLNl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 May 2022 07:13:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38EAC339
        for <netdev@vger.kernel.org>; Mon,  2 May 2022 04:10:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B720061278
        for <netdev@vger.kernel.org>; Mon,  2 May 2022 11:10:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 1865CC385AF;
        Mon,  2 May 2022 11:10:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651489811;
        bh=U8XwvMR2Zm3e0nsvg+XKbn2QhGQK4Rr+NPSbNIUm8ag=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=H5kL02tqts8aK+ITH3vnhJu7u6yjvc10AvVlpr1oiWu3I7fJh4Pi1g7SJkx/LiDKe
         VI2ZExrVLHYKz8orVtIAOAvDG96zlCNpe0JCj+60Hj5xFeWojdxcuJzbqprtGYfkiw
         JLVxBrA3NOw7Cn/m/x0RUgWfN8L3VmngY4/z1X5o6oRTTlGQw0jQoXmZwkiAq5xS1N
         0chTORAN7zm0jvWIztvMSsU2WkcFgBDhP95fqLibjficNDONkbto/5XvqajpbVK0vt
         KyO+DQlQwaDnljLJTuflp5mcqg9KhNiysURTsGwnNb/bfduC86FET6XFUQUChZQKs6
         xWt7WRPWoTq3w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id F155CE8DBDA;
        Mon,  2 May 2022 11:10:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] nfp: support VxLAN inner TSO with GSO_PARTIAL offload
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165148981098.30678.14391687945548653020.git-patchwork-notify@kernel.org>
Date:   Mon, 02 May 2022 11:10:10 +0000
References: <20220430231150.175270-1-simon.horman@corigine.com>
In-Reply-To: <20220430231150.175270-1-simon.horman@corigine.com>
To:     Simon Horman <simon.horman@corigine.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        oss-drivers@corigine.com, fei.qin@corigine.com
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

This patch was applied to netdev/net-next.git (master)
by Paolo Abeni <pabeni@redhat.com>:

On Sun,  1 May 2022 08:11:50 +0900 you wrote:
> From: Fei Qin <fei.qin@corigine.com>
> 
> VxLAN belongs to UDP-based encapsulation protocol. Inner TSO for VxLAN
> packet with udpcsum requires offloading of outer header csum.
> 
> The device doesn't support outer header csum offload. However, inner TSO
> for VxLAN with udpcsum can still work with GSO_PARTIAL offload, which
> means outer udp csum computed by stack and inner tcp segmentation finished
> by hardware. Thus, the patch enable features "NETIF_F_GSO_UDP_TUNNEL_CSUM"
> and "NETIF_F_GSO_PARTIAL" and set gso_partial_features.
> 
> [...]

Here is the summary with links:
  - nfp: support VxLAN inner TSO with GSO_PARTIAL offload
    https://git.kernel.org/netdev/net-next/c/ae664d9d8559

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


