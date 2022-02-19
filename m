Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E59114BC94B
	for <lists+netdev@lfdr.de>; Sat, 19 Feb 2022 17:30:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238268AbiBSQaf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Feb 2022 11:30:35 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:60446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231519AbiBSQae (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Feb 2022 11:30:34 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 773E61B7625;
        Sat, 19 Feb 2022 08:30:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5C63160B8D;
        Sat, 19 Feb 2022 16:30:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id AFBCFC340ED;
        Sat, 19 Feb 2022 16:30:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645288210;
        bh=tJVABENQLLFlTYHlBQE3dOhZT4/zn1fMVfl58sIxJLQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=R43a+grRG8B0QhD0IIMQ4Fqr5DRNE4NnCbBZ66r8KA5SCBwcaJs0QAt3zqZTj/iuF
         kqpaqwN3O3CK5RBYAdBqaiXrvk4D7CRkpYp3peVr8BfysGCP3WH+jIALK4N65sKsJx
         mREWkoqKVGWAy7q3zptqbQ82G8KoI1LwM2XLYpoP/33CAA6u2tI1YjR420GdbYcHQa
         Z+J/b7qs8sUOcOenGToVSoGwRN+zl2PqbXFWjiwGbwkdeXIn9tN5g6B6ou8erTGjkh
         lW6NCx7kYtfvCTNxB1wLcaxiKVzIVcKRQ6DbZlTtIe0FbMjfXF3MBz3qQBdApwya6P
         Pq1HYiN7HTIHA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 8D756E5D07D;
        Sat, 19 Feb 2022 16:30:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v4] net: Force inlining of checksum functions in
 net/checksum.h
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164528821057.2939.79120804393158510.git-patchwork-notify@kernel.org>
Date:   Sat, 19 Feb 2022 16:30:10 +0000
References: <4c4e276f6491d127c61b627c9ff13f0a71dab092.1645104881.git.christophe.leroy@csgroup.eu>
In-Reply-To: <4c4e276f6491d127c61b627c9ff13f0a71dab092.1645104881.git.christophe.leroy@csgroup.eu>
To:     Christophe Leroy <christophe.leroy@csgroup.eu>
Cc:     davem@davemloft.net, kuba@kernel.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, netdev@vger.kernel.org,
        yamada.masahiro@socionext.com, ndesaulniers@google.com,
        akpm@linux-foundation.org
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Thu, 17 Feb 2022 14:35:49 +0100 you wrote:
> All functions defined as static inline in net/checksum.h are
> meant to be inlined for performance reason.
> 
> But since commit ac7c3e4ff401 ("compiler: enable
> CONFIG_OPTIMIZE_INLINING forcibly") the compiler is allowed to
> uninline functions when it wants.
> 
> [...]

Here is the summary with links:
  - [net,v4] net: Force inlining of checksum functions in net/checksum.h
    https://git.kernel.org/netdev/net/c/5486f5bf790b

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


