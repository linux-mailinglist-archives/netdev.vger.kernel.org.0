Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A8A9B62F423
	for <lists+netdev@lfdr.de>; Fri, 18 Nov 2022 13:00:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241337AbiKRMAb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Nov 2022 07:00:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229580AbiKRMA2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Nov 2022 07:00:28 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D800394A59;
        Fri, 18 Nov 2022 04:00:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 777DA624A0;
        Fri, 18 Nov 2022 12:00:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id CD024C433D6;
        Fri, 18 Nov 2022 12:00:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668772825;
        bh=LchO1UIvI6texoR8SGUilW21Bod173N/TLKlRubPnvU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=I2dVsLmsVfMAcMEEGTDNf61+L6xhHv4Hm6o2ZAJrdnyZDv7vqIjw/Pazt50Y0bWkY
         eSfgdW9zSJK+RVhmMGUKvLsEs21XFMQG4TUiWLb3jOY8VSNyKe/dtZJARv4pCsv53B
         RaiZUC30kVO4IOjhPZj5W8nFWhWTn/kFyx4AB4AIoiGGRzEOiHd0esrV3eWY3e1MQo
         myDr7ZkZlKbOXPVUfGvxefpmDjNDeAAssMWQCEkCC+DsvoSFAi9amPGwuy2P6yA99m
         l+oIcYL4eu/dAQg9y0k1HDrJWTtQmeBnWD2UF+CrDoS+QF31AEmmyDNDts4ngdExfE
         kPMfQQZmkwANg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id A2680E270F6;
        Fri, 18 Nov 2022 12:00:25 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCHv2 net-next 0/7] sctp: support vrf processing
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166877282566.14131.2810734964750035632.git-patchwork-notify@kernel.org>
Date:   Fri, 18 Nov 2022 12:00:25 +0000
References: <cover.1668628394.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1668628394.git.lucien.xin@gmail.com>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     netdev@vger.kernel.org, linux-sctp@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org, edumazet@google.com,
        pabeni@redhat.com, marcelo.leitner@gmail.com,
        nhorman@tuxdriver.com, dsahern@gmail.com, colrack@gmail.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Wed, 16 Nov 2022 15:01:15 -0500 you wrote:
> This patchset adds the VRF processing in SCTP. Simliar to TCP/UDP,
> it includes socket bind and socket/association lookup changes.
> 
> For socket bind change, it allows sockets to bind to a VRF device
> and allows multiple sockets with the same IP and PORT to bind to
> different interfaces in patch 1-3.
> 
> [...]

Here is the summary with links:
  - [PATCHv2,net-next,1/7] sctp: verify the bind address with the tb_id from l3mdev
    https://git.kernel.org/netdev/net-next/c/26943aefa870
  - [PATCHv2,net-next,2/7] sctp: check ipv6 addr with sk_bound_dev if set
    https://git.kernel.org/netdev/net-next/c/6fe1e52490a9
  - [PATCHv2,net-next,3/7] sctp: check sk_bound_dev_if when matching ep in get_port
    https://git.kernel.org/netdev/net-next/c/f87b1ac06c88
  - [PATCHv2,net-next,4/7] sctp: add skb_sdif in struct sctp_af
    https://git.kernel.org/netdev/net-next/c/33e93ed2209d
  - [PATCHv2,net-next,5/7] sctp: add dif and sdif check in asoc and ep lookup
    https://git.kernel.org/netdev/net-next/c/0af03170637f
  - [PATCHv2,net-next,6/7] sctp: add sysctl net.sctp.l3mdev_accept
    https://git.kernel.org/netdev/net-next/c/b712d0328c2c
  - [PATCHv2,net-next,7/7] selftests: add a selftest for sctp vrf
    https://git.kernel.org/netdev/net-next/c/a61bd7b9fef3

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


