Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1254554ADFA
	for <lists+netdev@lfdr.de>; Tue, 14 Jun 2022 12:11:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233704AbiFNKKk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jun 2022 06:10:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241279AbiFNKKO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jun 2022 06:10:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7DED369EC;
        Tue, 14 Jun 2022 03:10:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6CFDA6009B;
        Tue, 14 Jun 2022 10:10:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C52F7C3411E;
        Tue, 14 Jun 2022 10:10:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655201412;
        bh=JvDzxUuOOtcGI1GXESqFqKZQSGOQ0UaFPLR+q/la0VY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=U404fFySO9/4Akc7Pv5G1a3Z1xddOD6jsvtaOr7+he4PLhU+cqBwMdQIlIYknaCNV
         mYWvGQe5958mEeybauAHje3i7MxrxaH8VsSkAnxIHKJHXoRQwpG6aswCc8AZ/FMRce
         3+d3ueXcuF0BiAZY+wfq5avh9Kz/Uqe8VvOF1UfBgxbZ273Lqwtfa50nr8b44kaAaI
         vunZdDdQE9VAOl58feaKAAR5R8Z4JUwiJWDeQZ2tdqJq0+EQE0GdYdNUu0CawMvrCT
         3yvkWbjjXIw/YPE11PittGrS3LH2R4r8S7XIy75XcYcOoqmNSZVMFlgpMNBbyoz021
         KGanex6+O9zqQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id A9F34E73858;
        Tue, 14 Jun 2022 10:10:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] docs: tls: document the TLS_TX_ZEROCOPY_RO
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165520141269.27801.15722081345018226392.git-patchwork-notify@kernel.org>
Date:   Tue, 14 Jun 2022 10:10:12 +0000
References: <20220610180212.110590-1-kuba@kernel.org>
In-Reply-To: <20220610180212.110590-1-kuba@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, maximmi@nvidia.com,
        corbet@lwn.net, linux-doc@vger.kernel.org
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Fri, 10 Jun 2022 11:02:12 -0700 you wrote:
> Add missing documentation for the TLS_TX_ZEROCOPY_RO opt-in.
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
> CC: corbet@lwn.net
> CC: linux-doc@vger.kernel.org
> 
> [...]

Here is the summary with links:
  - [net] docs: tls: document the TLS_TX_ZEROCOPY_RO
    https://git.kernel.org/netdev/net-next/c/7e5e8ec7dbd8

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


