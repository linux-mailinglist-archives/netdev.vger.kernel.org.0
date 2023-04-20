Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 53BC46E875F
	for <lists+netdev@lfdr.de>; Thu, 20 Apr 2023 03:20:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233039AbjDTBUY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Apr 2023 21:20:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230335AbjDTBUW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Apr 2023 21:20:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8345C49FD;
        Wed, 19 Apr 2023 18:20:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 21D8C64245;
        Thu, 20 Apr 2023 01:20:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 7A6A1C433EF;
        Thu, 20 Apr 2023 01:20:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681953619;
        bh=b/5BKQ0VH2PtX3y81oVCg/1Mk2m/CPrOfxJ7F7Iz1vs=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=GZqxx1mURIuEGG/bJu2YxO7oXXFz+QVeEJIG1qdyfHXnEBy1sY8S3N+gmTyKSyRJZ
         sDzzneCiyEp256zXdtX8ASzSyRTbE7IlsQGhJHLa587MkxK4arG9F/Y3Es7c954ZMu
         86RuRqZQOuPhMaX68+Q0+Tq5FfPnVXkavZ4EX5hl1FmfpiMQIrWAltkGVJZsH5vns0
         lj3OGpoVk67UdZLiiCo/8BmWNOS3qclax41Ptzb6hwj1X633tZ3KZALQ9I2GOOT7Kk
         DxjheRptw6NGfVVUB63+uPvIF7QAtWtbMVbqcN74acmJUQHTzvCsbxKKDpUHx9Wg4t
         9+aM6RblSAtag==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 545FEE4D033;
        Thu, 20 Apr 2023 01:20:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] mailmap: add entries for Mat Martineau
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168195361933.31134.18158689364466953201.git-patchwork-notify@kernel.org>
Date:   Thu, 20 Apr 2023 01:20:19 +0000
References: <20230418-upstream-net-20230418-mailmap-mat-v1-1-13ca5dc83037@tessares.net>
In-Reply-To: <20230418-upstream-net-20230418-mailmap-mat-v1-1-13ca5dc83037@tessares.net>
To:     Matthieu Baerts <matthieu.baerts@tessares.net>
Cc:     mptcp@lists.linux.dev, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, martineau@kernel.org
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 18 Apr 2023 10:36:59 +0200 you wrote:
> Map Mat's old corporate addresses to his kernel.org one.
> 
> Reviewed-by: Mat Martineau <martineau@kernel.org>
> Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
> ---
>  .mailmap | 2 ++
>  1 file changed, 2 insertions(+)
> 
> [...]

Here is the summary with links:
  - [net] mailmap: add entries for Mat Martineau
    https://git.kernel.org/netdev/net/c/7b3aba7ea336

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


