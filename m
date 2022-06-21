Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8880552F91
	for <lists+netdev@lfdr.de>; Tue, 21 Jun 2022 12:20:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240982AbiFUKUR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jun 2022 06:20:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229616AbiFUKUQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jun 2022 06:20:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 358B7252A1
        for <netdev@vger.kernel.org>; Tue, 21 Jun 2022 03:20:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 91DE6B8114A
        for <netdev@vger.kernel.org>; Tue, 21 Jun 2022 10:20:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 5451FC341C4;
        Tue, 21 Jun 2022 10:20:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655806813;
        bh=oER/AlQVO0oNWPoHOtIOTOd/8U+o7R/Etzo5MzS7Is0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=aKeQi0VIuiwvHTr9RaBI2wvm4zV6B1sqWdtaBkjD+COFoHDz7hwwQiCQgR2BVVjwG
         /PeMi6a/j0vxfSaT+FQmisKpOuCh2BSpvNffsZrbZblNiophd7WZhnQ7R2pcvuka2Q
         9EIF+TJkPdJUz0CFYiN0Ifif6OvmFyoj9Sjht+IBoAgF2sopx0jvgkINYHAXlNCPVK
         L/V4Et5+SacDsQ1f4eAWiwc+D26finkqa5eWlLyKG7hodExHQlHVK19kY6HXCV+8em
         f8MMWZTQDb8jmW1/pjqOBs73ITLOE9+Zr9RpeLCx9ONLCVzyNqXQH/MwWtiSy7B3ev
         l8DfTyeOLItGA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 385D0E574DA;
        Tue, 21 Jun 2022 10:20:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] raw: complete rcu conversion
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165580681322.12821.1230923216395954605.git-patchwork-notify@kernel.org>
Date:   Tue, 21 Jun 2022 10:20:13 +0000
References: <20220620100509.3493504-1-eric.dumazet@gmail.com>
In-Reply-To: <20220620100509.3493504-1-eric.dumazet@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, edumazet@google.com
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

On Mon, 20 Jun 2022 03:05:09 -0700 you wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> raw_diag_dump() can use rcu_read_lock() instead of read_lock()
> 
> Now the hashinfo lock is only used from process context,
> in write mode only, we can convert it to a spinlock,
> and we do not need to block BH anymore.
> 
> [...]

Here is the summary with links:
  - [net-next] raw: complete rcu conversion
    https://git.kernel.org/netdev/net-next/c/af185d8c7633

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


