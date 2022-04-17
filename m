Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E3E955047C1
	for <lists+netdev@lfdr.de>; Sun, 17 Apr 2022 14:40:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234054AbiDQMmy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Apr 2022 08:42:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233751AbiDQMmw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 Apr 2022 08:42:52 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0ADBF22526;
        Sun, 17 Apr 2022 05:40:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 003D3CE0DB8;
        Sun, 17 Apr 2022 12:40:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 0F5BAC385A4;
        Sun, 17 Apr 2022 12:40:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650199211;
        bh=jy2UpKooiyGw2WUFOA9vk8hYlYnJUrUWC45EKh6nfyU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Ce8cTbRXx41FUWEudsJMpKY1EZK730nEiTPTDJxlpqF5A0sHUL0bO7D1okjyA1HMP
         7a2s672mahU7tXkZQDF/3A1MZyHp3r3uVO986M7tKa8NaJWdfRZ5YF2TmSg8FGXDKj
         afDKEAsaczEMdwCJByS0YRqlxkk0TXNEbRyd9mYcFpkab6U+nrhcWCDiUspxaqyxIE
         AOPuCz6PP9vvwtep8hpWpC00Bp4EGI7b1Zo3aLrBZhJQq6RQG5NEGp3PDLH2iDT6xj
         lTSdb45MApA6eke/kzVtLcGTA2v4Q7fvdwDDKubBiVnzs5xsQuKXN+vlr680W9c9dR
         8rz4lw5/xGqhQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id DE4B1E8DD6A;
        Sun, 17 Apr 2022 12:40:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] bonding: do not discard lowest hash bit for non layer3+4
 hashing
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165019921090.7317.10997111604536924126.git-patchwork-notify@kernel.org>
Date:   Sun, 17 Apr 2022 12:40:10 +0000
References: <20220416111410.356132-1-suresh2514@gmail.com>
In-Reply-To: <20220416111410.356132-1-suresh2514@gmail.com>
To:     Suresh Kumar <surkumar@redhat.com>
Cc:     j.vosburgh@gmail.com, vfalico@gmail.com, andy@greyhouse.net,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        suresh2514@gmail.com
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

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Sat, 16 Apr 2022 16:44:10 +0530 you wrote:
> From: suresh kumar <suresh2514@gmail.com>
> 
> Commit b5f862180d70 was introduced to discard lowest hash bit for layer3+4 hashing
> but it also removes last bit from non layer3+4 hashing
> 
> Below script shows layer2+3 hashing will result in same slave to be used with above commit.
> $ cat hash.py
> #/usr/bin/python3.6
> 
> [...]

Here is the summary with links:
  - bonding: do not discard lowest hash bit for non layer3+4 hashing
    https://git.kernel.org/netdev/net/c/49aefd131739

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


