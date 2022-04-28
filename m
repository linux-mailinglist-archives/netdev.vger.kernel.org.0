Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4FFE4512F06
	for <lists+netdev@lfdr.de>; Thu, 28 Apr 2022 10:51:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344628AbiD1Ixj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Apr 2022 04:53:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344430AbiD1Ixb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Apr 2022 04:53:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1C9F5F56;
        Thu, 28 Apr 2022 01:50:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 77AFF61FCF;
        Thu, 28 Apr 2022 08:50:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A95FDC385BE;
        Thu, 28 Apr 2022 08:50:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651135811;
        bh=yJ3N75uEIR/gCanU0NC90G8JPSmkSdYcQ1tUtvj74pI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=DosSt2aNGB31lzMl08cJqXA8i+ur8IzPNOgDUFd1Xp5SWgZ6DByuGf6KpKi6mVvuT
         YgYFg4nxy8bJ9O0E0dki+GeOjEokDwGk9zctBCrGFPnEKFTvnAcbFEpB3bCbCf0Y9s
         wmhlUZqojoWPlOUHOASQbSPk8HbxkleiSiNmQlRg/RCCX8tgwqU8w6bHIa4yYyEkad
         Gitv6AQ9T1F6JRzho/1K122ES5NUuWqjBJeLo3awM8x+osIFz5EkI8Bj4BXeRS7RvX
         GvdGEkt02tx0AjeF1HYZ1TSJTemD8P3nbehbRNTSk6/ImDhhw9e0I0eJqqah6DF5h8
         Crud0KK1yZLig==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 9308EE8DD67;
        Thu, 28 Apr 2022 08:50:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: pull request: bluetooth 2022-04-27
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165113581159.13774.5811953848563780188.git-patchwork-notify@kernel.org>
Date:   Thu, 28 Apr 2022 08:50:11 +0000
References: <20220427234031.1257281-1-luiz.dentz@gmail.com>
In-Reply-To: <20220427234031.1257281-1-luiz.dentz@gmail.com>
To:     Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This pull request was applied to netdev/net.git (master)
by Paolo Abeni <pabeni@redhat.com>:

On Wed, 27 Apr 2022 16:40:31 -0700 you wrote:
> The following changes since commit acb16b395c3f3d7502443e0c799c2b42df645642:
> 
>   virtio_net: fix wrong buf address calculation when using xdp (2022-04-26 13:24:44 +0200)
> 
> are available in the Git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth.git tags/for-net-2022-04-27
> 
> [...]

Here is the summary with links:
  - pull request: bluetooth 2022-04-27
    https://git.kernel.org/netdev/net/c/febb2d2fa561

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


