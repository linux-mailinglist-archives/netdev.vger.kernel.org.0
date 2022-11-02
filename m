Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00F4B61633C
	for <lists+netdev@lfdr.de>; Wed,  2 Nov 2022 14:00:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231245AbiKBNAd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Nov 2022 09:00:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231307AbiKBNAU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Nov 2022 09:00:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B84329C9D;
        Wed,  2 Nov 2022 06:00:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7719A61944;
        Wed,  2 Nov 2022 13:00:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id CAC0EC433B5;
        Wed,  2 Nov 2022 13:00:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667394018;
        bh=10Z6uXDE6nv9we1caDEijEa5FDJ4Ne5WNxQT8wsxKq0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=bdVHI4Rc1FXA/QJuXfbM4fFxr7sbY8APi129r0O+8pnK1ATFKTzkn0K5KvjC/JLqA
         TNvVb/Yq9MhD0BBL2it1zqDCH/KFO6zfDoeK8eojkVwtjMXu2HFnhGpl6GpO0TBPGQ
         dAXsj2HiMPWu1ZZryImhk+JZT8hkDijfB35OXqZj7Vn/UgPI+sfwftL/ijGa+7EByc
         VjJWi79wUvdPEOn/Cv2IKyS9NOnCy6pdaWt5SHrg+mmlHQPclvuK21rgN+dKg+fgp2
         dYO7up3BMmGKk9oyTE1rAqyBMvVfSN6gr/ymzgG3gbteM3OTT0mBVNjDtmUkKaYKTj
         Ms0BBvXO2PXEg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id AE52FE270D2;
        Wed,  2 Nov 2022 13:00:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v7 0/3] net: ethernet: renesas: Add support for "Ethernet
 Switch"
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166739401870.9062.8744215770877095925.git-patchwork-notify@kernel.org>
Date:   Wed, 02 Nov 2022 13:00:18 +0000
References: <20221031123242.2528208-1-yoshihiro.shimoda.uh@renesas.com>
In-Reply-To: <20221031123242.2528208-1-yoshihiro.shimoda.uh@renesas.com>
To:     Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-renesas-soc@vger.kernel.org
X-Spam-Status: No, score=-8.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Mon, 31 Oct 2022 21:32:39 +0900 you wrote:
> This patch series is based on next-20221027.
> 
> Add initial support for Renesas "Ethernet Switch" device of R-Car S4-8.
> The hardware has features about forwarding for an ethernet switch
> device. But, for now, it acts as ethernet controllers so that any
> forwarding offload features are not supported. So, any switchdev
> header files and DSA framework are not used.
> 
> [...]

Here is the summary with links:
  - [v7,1/3] dt-bindings: net: renesas: Document Renesas Ethernet Switch
    https://git.kernel.org/netdev/net-next/c/f9edd82774c0
  - [v7,2/3] net: ethernet: renesas: Add support for "Ethernet Switch"
    https://git.kernel.org/netdev/net-next/c/3590918b5d07
  - [v7,3/3] net: ethernet: renesas: rswitch: Add R-Car Gen4 gPTP support
    https://git.kernel.org/netdev/net-next/c/6c6fa1a00ad3

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


