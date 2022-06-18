Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B6D6555026A
	for <lists+netdev@lfdr.de>; Sat, 18 Jun 2022 05:20:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383991AbiFRDUV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jun 2022 23:20:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343587AbiFRDUR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jun 2022 23:20:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2640B49F8C;
        Fri, 17 Jun 2022 20:20:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B1DB161FA8;
        Sat, 18 Jun 2022 03:20:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 1BA11C341C8;
        Sat, 18 Jun 2022 03:20:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655522415;
        bh=R9eG0HETLD3pXh8438vR/GErMXwLkHym1DCvy29aeMs=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=kohv1nmdYCeIWomiP/cPmUVyESpe2cizEx9tcuKiNY4QDGDW+32DjwBbfUok0ibat
         olJPTfbuZgIdHJ5JvD8nAjd2gw4u+2wOAPJgT3ACWmC9AAstAX2OHAb8JjP6nf0jn8
         vausyUWlenw0MuSYG3ePG1ImBJnyhfvc5CHokMEoLSfD0ti2kWyeNXMetgZctEUp7T
         hT9G9oIdljfjbqaA55IkkRZXKwv9UAW4B2qFxK7jkS9PnZdCM6/9V+rgAEjaL9sfx8
         LwPvjiwCnsRfpZZEDuxY8oZO7SYlQvdroIVJ+BTmF+KK+68gtIQnrbM1wEtzzqESQQ
         j3APyesq+uCGQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 040B0E7BB90;
        Sat, 18 Jun 2022 03:20:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] atm: iphase: Fix typo in comment
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165552241501.3144.3884094987660600637.git-patchwork-notify@kernel.org>
Date:   Sat, 18 Jun 2022 03:20:15 +0000
References: <20220616164155.11686-1-wangxiang@cdjrlc.com>
In-Reply-To: <20220616164155.11686-1-wangxiang@cdjrlc.com>
To:     Xiang wangx <wangxiang@cdjrlc.com>
Cc:     3chas3@gmail.com, linux-atm-general@lists.sourceforge.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
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
by Jakub Kicinski <kuba@kernel.org>:

On Fri, 17 Jun 2022 00:41:55 +0800 you wrote:
> Delete the redundant word 'the'.
> 
> Signed-off-by: Xiang wangx <wangxiang@cdjrlc.com>
> ---
>  drivers/atm/iphase.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Here is the summary with links:
  - atm: iphase: Fix typo in comment
    https://git.kernel.org/netdev/net-next/c/f691b4d87edf

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


