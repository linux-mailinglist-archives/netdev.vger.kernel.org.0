Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A31357D83D
	for <lists+netdev@lfdr.de>; Fri, 22 Jul 2022 04:10:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233729AbiGVCKW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jul 2022 22:10:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbiGVCKU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jul 2022 22:10:20 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C1C51C129
        for <netdev@vger.kernel.org>; Thu, 21 Jul 2022 19:10:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B592EB82701
        for <netdev@vger.kernel.org>; Fri, 22 Jul 2022 02:10:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 68CEFC341D2;
        Fri, 22 Jul 2022 02:10:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658455814;
        bh=GNv308FXtL8XjTuEgjtjN+mmWGSD+jaSMx+XROwRPz0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=s7ljkE3F1S6ONXzMZqQHTiSefS//f8cVwMyPUd8xWqudrYQcuka8pC9oc5EWXqRMa
         8kLeaXAge5GLw4OhLXq+GmRPjxnXFPZB5OSKlHC+smRRAAAcWCrloEE51j5zWzL2gM
         sIUN0VVtPdc0INjhrQLx3xL4fK+Bm6fcmQ6RHEByFTaSJANaFcgr2yMRIlKwOSLk3v
         EPfh44ogkpDATLxbIe+S7Z9dlVlzWY6YpnlBXd8MHDYO4hihgIrRycd7IbK8X9v62d
         cOd/uQAHHWMaWe79rZkGc/ZtP5vzhf0ibto4oOtWVfp/CyAt/1FkafZvabft76jpu3
         LYLK7CyAsVdwA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 521A3E451BA;
        Fri, 22 Jul 2022 02:10:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 1/2] tls: rx: release the sock lock on locking
 timeout
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165845581432.5037.8359500078938599354.git-patchwork-notify@kernel.org>
Date:   Fri, 22 Jul 2022 02:10:14 +0000
References: <20220720203701.2179034-1-kuba@kernel.org>
In-Reply-To: <20220720203701.2179034-1-kuba@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, borisp@nvidia.com, john.fastabend@gmail.com,
        maximmi@nvidia.com, tariqt@nvidia.com, vfedorenko@novek.ru,
        syzbot+16e72110feb2b653ef27@syzkaller.appspotmail.com
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 20 Jul 2022 13:37:00 -0700 you wrote:
> Eric reports we should release the socket lock if the entire
> "grab reader lock" operation has failed. The callers assume
> they don't have to release it or otherwise unwind.
> 
> Reported-by: Eric Dumazet <edumazet@google.com>
> Reported-by: syzbot+16e72110feb2b653ef27@syzkaller.appspotmail.com
> Fixes: 4cbc325ed6b4 ("tls: rx: allow only one reader at a time")
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> 
> [...]

Here is the summary with links:
  - [net-next,1/2] tls: rx: release the sock lock on locking timeout
    https://git.kernel.org/netdev/net-next/c/dde06aaa89b7
  - [net-next,2/2] selftests: tls: add a test for timeo vs lock
    https://git.kernel.org/netdev/net-next/c/842463f253ab

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


