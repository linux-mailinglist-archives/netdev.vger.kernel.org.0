Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2DD9D5F3A3F
	for <lists+netdev@lfdr.de>; Tue,  4 Oct 2022 02:00:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229995AbiJDAAZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Oct 2022 20:00:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229919AbiJDAAU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Oct 2022 20:00:20 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E303614028
        for <netdev@vger.kernel.org>; Mon,  3 Oct 2022 17:00:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 02054B816DC
        for <netdev@vger.kernel.org>; Tue,  4 Oct 2022 00:00:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B115CC433B5;
        Tue,  4 Oct 2022 00:00:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664841614;
        bh=v60Tp+4+QJeYY/AWZOaVLdMJWqCN4tDj5UL3pvWxbOo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=lFsZ9BuS/sudsYwlu516cyiw6s0MMFy+QUN4weGQ7APgjfySbvaSZU7ZNTCBPwAuF
         7TSm2cvel0VfPNLbwACmrFX+QHr3wu25v9NByLmuu+aQIoIzSAqE7p5RNJUgp5s42n
         JHA1E88dy4xCbpGeb2C9X2Tv/sOTJ2JIkQTisPKZNzw8Fu3ZiggBgoeiqvYVrmVP5H
         KlVt3DtPZzLtFwr1M/qQ12AUd3m+veTBwkNGIjnxy+8cId0bEsP6+YRXWO7pqvxTfu
         zhW+VtNB3RMCAqzr0nhMkUYATtk81QC7sSVbR8JLk7F+K5ijJ2Hwt4LpApi5JMGr9T
         lYtVkWmMJ47Ng==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 8F6B1E49FA7;
        Tue,  4 Oct 2022 00:00:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] r8152: Rate limit overflow messages
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166484161458.2431.17953265834674033707.git-patchwork-notify@kernel.org>
Date:   Tue, 04 Oct 2022 00:00:14 +0000
References: <20221002034128.2026653-1-gaul@google.com>
In-Reply-To: <20221002034128.2026653-1-gaul@google.com>
To:     Andrew Gaul <gaul@gaul.org>
Cc:     netdev@vger.kernel.org, hayeswang@realtek.com, gaul@google.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Sun,  2 Oct 2022 12:41:28 +0900 you wrote:
> My system shows almost 10 million of these messages over a 24-hour
> period which pollutes my logs.
> 
> Signed-off-by: Andrew Gaul <gaul@google.com>
> ---
>  drivers/net/usb/r8152.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)

Here is the summary with links:
  - r8152: Rate limit overflow messages
    https://git.kernel.org/netdev/net/c/93e2be344a7d

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


