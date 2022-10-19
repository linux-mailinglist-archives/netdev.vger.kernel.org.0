Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9ECFE6052CA
	for <lists+netdev@lfdr.de>; Thu, 20 Oct 2022 00:10:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231201AbiJSWKX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Oct 2022 18:10:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229929AbiJSWKW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Oct 2022 18:10:22 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEF5625C64
        for <netdev@vger.kernel.org>; Wed, 19 Oct 2022 15:10:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8829EB825C9
        for <netdev@vger.kernel.org>; Wed, 19 Oct 2022 22:10:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 489B5C433D6;
        Wed, 19 Oct 2022 22:10:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666217418;
        bh=82ef0NB3UqTM971wbkXg5TbZkHJ+wIg13m1/Wy/rO6Y=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=uFm00K3tbWOLgXTISCMxiIJeIBkwd6RYjR6aqVJ0X0oMqjNTVYaNNJdgzreYsi7Tu
         a7rQnX2D+iE/ZfY+k4rDuEz67ZQh96jI16ZuSq7h8j15koR0DzJeWSLVtKHP2L/CVV
         Vz6H3qU53hvUvuBYjRBOZvm7CY9TyBXqXXlZWcEvK/sa0V/O8BHGwme7BXNXJLaT2Z
         CVnm2bvyo2zy2KVpOpxyJdDan5RuO+seYd5VuqitQcvnnMrueii8Bfi2ubx4x5NVXR
         MZE6b0GkkOUaxKhTPe2trpY/pDJtee4xPKp7P7Z/V9BYxtjwjfx2AGxwssU7cReF/7
         tUUmohq9L/hLw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 28EE3E270EA;
        Wed, 19 Oct 2022 22:10:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] genetlink: fix kdoc warnings
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166621741816.14082.3422280619244614970.git-patchwork-notify@kernel.org>
Date:   Wed, 19 Oct 2022 22:10:18 +0000
References: <20221018231310.1040482-1-kuba@kernel.org>
In-Reply-To: <20221018231310.1040482-1-kuba@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Tue, 18 Oct 2022 16:13:10 -0700 you wrote:
> Address a bunch of kdoc warnings:
> 
> include/net/genetlink.h:81: warning: Function parameter or member 'module' not described in 'genl_family'
> include/net/genetlink.h:243: warning: expecting prototype for struct genl_info. Prototype was for struct genl_dumpit_info instead
> include/net/genetlink.h:419: warning: Function parameter or member 'net' not described in 'genlmsg_unicast'
> include/net/genetlink.h:438: warning: expecting prototype for gennlmsg_data(). Prototype was for genlmsg_data() instead
> include/net/genetlink.h:244: warning: Function parameter or member 'op' not described in 'genl_dumpit_info'
> 
> [...]

Here is the summary with links:
  - [net] genetlink: fix kdoc warnings
    https://git.kernel.org/netdev/net/c/a1a824f448ba

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


