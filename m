Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C1FFE62D6ED
	for <lists+netdev@lfdr.de>; Thu, 17 Nov 2022 10:30:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239180AbiKQJaS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Nov 2022 04:30:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233466AbiKQJaR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Nov 2022 04:30:17 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB6796CA3C;
        Thu, 17 Nov 2022 01:30:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 64EC362159;
        Thu, 17 Nov 2022 09:30:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id BF29CC43145;
        Thu, 17 Nov 2022 09:30:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668677415;
        bh=w8PnUiL8+Rb3e6GdnaJKp9udSTxNnnzvsLok7fnMxBo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=fZYmsrK3HScbYKDChXbOlI6DbHyF+9LgPbKYQGa0wS07KzQ86NBRlvmKJSxohSYyd
         ZkzUxkcWJak47/22evidHZqJh8Mj6HsA7FQx1d3rmRjgV3McIu54MshATxkrA7ei/g
         n6PUMF+HVV/NJ9swPA3lZ+wsSXepL8uviMb670C6N8xNKmDDk/tzhArbjK+ogd/nbC
         27sU3Yzct8MgTAxQu56v1hcKKuTjbJm/xdWnVpTo+ANVMCBfRCxm41unkuAsSKN0Kf
         TLEuVP8iK+qsSz2Cp8zfhqL9pXBXbgShmdzf4ZRPWaHtkaN4JjQEYKiQ8DvBr976p8
         8AsuowgHlfW1g==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id A2746C395FE;
        Thu, 17 Nov 2022 09:30:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 1/1] net: usb: qmi_wwan: add Telit 0x103a composition
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166867741566.24883.13179415715279429065.git-patchwork-notify@kernel.org>
Date:   Thu, 17 Nov 2022 09:30:15 +0000
References: <20221115105859.14324-1-enrico.sau@gmail.com>
In-Reply-To: <20221115105859.14324-1-enrico.sau@gmail.com>
To:     Enrico Sau <enrico.sau@gmail.com>
Cc:     bjorn@mork.no, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org
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
by Paolo Abeni <pabeni@redhat.com>:

On Tue, 15 Nov 2022 11:58:59 +0100 you wrote:
> Add the following Telit LE910C4-WWX composition:
> 
> 0x103a: rmnet
> 
> Signed-off-by: Enrico Sau <enrico.sau@gmail.com>
> ---
> 
> [...]

Here is the summary with links:
  - [1/1] net: usb: qmi_wwan: add Telit 0x103a composition
    https://git.kernel.org/netdev/net/c/e103ba33998d

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


