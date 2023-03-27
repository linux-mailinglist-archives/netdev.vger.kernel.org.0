Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B89626C9D10
	for <lists+netdev@lfdr.de>; Mon, 27 Mar 2023 10:00:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232570AbjC0IAZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Mar 2023 04:00:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232925AbjC0IAX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Mar 2023 04:00:23 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C853F4225
        for <netdev@vger.kernel.org>; Mon, 27 Mar 2023 01:00:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 360CAB80EAE
        for <netdev@vger.kernel.org>; Mon, 27 Mar 2023 08:00:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id EAA83C4339B;
        Mon, 27 Mar 2023 08:00:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679904019;
        bh=KWUOi/0sPHVVmvfADn6X/OagE7LytDGx4of/M3pBjpU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=kBDohiGVdTitZpeqfa6nhQjcooLfV/9CbQNc2nRQnFhEBOooNJJBIsdjjiwDNWvHq
         v0u9e8oLhGubeqr9bsNz8HmNCSMQht2UrojKltHaa9eanO0GVIjRfUILXo0d8yFmtg
         KJpI/wVCRxtK4yVudUH50ejJEic1PwIGO39T+0ekqaIs05i86KVn+wazrnHUNg2VMf
         cyLUCep9b3f3os5M6iWERD2CKDFu9djx3hkYh2kn3zXkM7GEeDvDAZ+jeJOJLRlB3f
         dJ0LG2BHI7cOW3+S6myzO58AkE/1WUKx2LKP+Y9Y7EKc2d4FPpAyxssyMxlH7bPj2M
         68tifJmDhNnAw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id CA929E2A038;
        Mon, 27 Mar 2023 08:00:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] tools: ynl: default to treating enums as flags for
 mask generation
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167990401882.27318.2964259452335533540.git-patchwork-notify@kernel.org>
Date:   Mon, 27 Mar 2023 08:00:18 +0000
References: <20230324190356.2418748-1-kuba@kernel.org>
In-Reply-To: <20230324190356.2418748-1-kuba@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (main)
by David S. Miller <davem@davemloft.net>:

On Fri, 24 Mar 2023 12:03:56 -0700 you wrote:
> I was a bit too optimistic in commit bf51d27704c9 ("tools: ynl: fix
> get_mask utility routine"), not every mask we use is necessarily
> coming from an enum of type "flags". We also allow flipping an
> enum into flags on per-attribute basis. That's done by
> the 'enum-as-flags' property of an attribute.
> 
> Restore this functionality, it's not currently used by any in-tree
> family.
> 
> [...]

Here is the summary with links:
  - [net-next] tools: ynl: default to treating enums as flags for mask generation
    https://git.kernel.org/netdev/net-next/c/4c6170d1ae2c

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


